module Cacher
  CACHE_LENGTH = 60.seconds

  #redis_key must be defined in the class that includes Cacher

    def data
      REDIS.get(redis_key)
    end

    def cache_data(raw_data)
      cachable_data = raw_data.merge(:cache_expires => DateTime.now + CACHE_LENGTH).to_json
      REDIS.set(redis_key, cachable_data)
    end

    def cache_current?
      (JSON.parse(data)["cache_expires"].to_datetime >= DateTime.now) rescue false
    end
  
    def push_list(key, value)
      REDIS.lpush("#{@redis_key}-#{key}", value)
    end

    def pop_list(key)
      REDIS.lpop("#{@redis_key}-#{key}")
    end

    def count_list(key)
      REDIS.llen("#{@redis_key}-#{key}")
    end

    def get_list(key)
      REDIS.lrange("#{@redis_key}-#{key}", 0, -1) || []
    end
  end