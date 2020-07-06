require 'simplecov'
SimpleCov.start 'rails'

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require_relative '../config/environment'
require 'faker'
require 'rails/test_help'
require 'mocha/minitest'

require 'testhelpers/constants'
require 'testhelpers/stub_helper'
require 'testhelpers/delayed_job_helper'
require 'testhelpers/crud_helper'
require 'testhelpers/git_helper'
require 'testhelpers/remote_helper'
require 'testhelpers/export_zip_helper'

# automatically set locale for all routes
require 'minitest/utils/rails/locale'

# Always generate the same testdata
Faker::Config.random = Random.new(42)

OmniAuth.config.test_mode = true

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
  include Constants
  include StubHelper
  include DelayedJobHelper
  include RemoteHelper
  include SeriesZipHelper

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  parallelize_setup do |worker|
    SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
  end

  parallelize_teardown do |_worker|
    SimpleCov.result
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
