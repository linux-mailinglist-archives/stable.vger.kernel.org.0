Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68354278F5B
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 19:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgIYRIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 13:08:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:22417 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgIYRIS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 13:08:18 -0400
IronPort-SDR: fRo8Sqw/WhOsf2i59nD2keD7AP3HR51PA03XgbBtp423Ogw7L79xBVbI7eB3mabojftAln4r3b
 QGS3U3qY1AgA==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="158867868"
X-IronPort-AV: E=Sophos;i="5.77,302,1596524400"; 
   d="scan'208";a="158867868"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 06:23:36 -0700
IronPort-SDR: WLUmg5rmr9hQCksKMErW3xHxwfXHOX9ydxyS0ZbNDCZZRZvnO5dp55MOfwM8qfr9YAhPTW+icu
 LuXOHkDj4RBA==
X-IronPort-AV: E=Sophos;i="5.77,302,1596524400"; 
   d="scan'208";a="455832584"
Received: from mlevy2-mobl.ger.corp.intel.com (HELO [10.251.176.131]) ([10.251.176.131])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 06:23:34 -0700
Subject: Re: [Intel-gfx] [PATCH 4/4] drm/i915/gem: Always test execution
 status on closing the context
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200916094219.3878-1-chris@chris-wilson.co.uk>
 <20200916094219.3878-4-chris@chris-wilson.co.uk>
 <e665fc1d-1b9d-a6ee-1798-df32d1296118@linux.intel.com>
 <160102830667.30248.7803662790481339170@build.alporthouse.com>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <f2e8aa26-45d3-969f-daad-c4b208c69352@linux.intel.com>
Date:   Fri, 25 Sep 2020 14:23:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <160102830667.30248.7803662790481339170@build.alporthouse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 25/09/2020 11:05, Chris Wilson wrote:
> Quoting Tvrtko Ursulin (2020-09-24 15:26:56)
>>
>> On 16/09/2020 10:42, Chris Wilson wrote:
>>> Verify that if a context is active at the time it is closed, that it is
>>> either persistent and preemptible (with hangcheck running) or it shall
>>> be removed from execution.
>>>
>>> Fixes: 9a40bddd47ca ("drm/i915/gt: Expose heartbeat interval via sysfs")
>>> Testcase: igt/gem_ctx_persistence/heartbeat-close
>>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>>> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
>>> Cc: <stable@vger.kernel.org> # v5.7+
>>> ---
>>>    drivers/gpu/drm/i915/gem/i915_gem_context.c | 48 +++++----------------
>>>    1 file changed, 10 insertions(+), 38 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
>>> index a548626fa8bc..4fd38101bb56 100644
>>> --- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
>>> +++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
>>> @@ -390,24 +390,6 @@ __context_engines_static(const struct i915_gem_context *ctx)
>>>        return rcu_dereference_protected(ctx->engines, true);
>>>    }
>>>    
>>> -static bool __reset_engine(struct intel_engine_cs *engine)
>>> -{
>>> -     struct intel_gt *gt = engine->gt;
>>> -     bool success = false;
>>> -
>>> -     if (!intel_has_reset_engine(gt))
>>> -             return false;
>>> -
>>> -     if (!test_and_set_bit(I915_RESET_ENGINE + engine->id,
>>> -                           &gt->reset.flags)) {
>>> -             success = intel_engine_reset(engine, NULL) == 0;
>>> -             clear_and_wake_up_bit(I915_RESET_ENGINE + engine->id,
>>> -                                   &gt->reset.flags);
>>> -     }
>>> -
>>> -     return success;
>>> -}
>>> -
>>>    static void __reset_context(struct i915_gem_context *ctx,
>>>                            struct intel_engine_cs *engine)
>>>    {
>>> @@ -431,12 +413,7 @@ static bool __cancel_engine(struct intel_engine_cs *engine)
>>>         * kill the banned context, we fallback to doing a local reset
>>>         * instead.
>>>         */
>>> -     if (IS_ACTIVE(CONFIG_DRM_I915_PREEMPT_TIMEOUT) &&
>>> -         !intel_engine_pulse(engine))
>>> -             return true;
>>> -
>>> -     /* If we are unable to send a pulse, try resetting this engine. */
>>> -     return __reset_engine(engine);
>>> +     return intel_engine_pulse(engine) == 0;
>>
>> Where is the path now which actually resets the currently running
>> workload (engine) of a non-persistent context? Pulse will be sent and
>> then rely on hangcheck but otherwise let it run?
> 
> If the pulse fails, we just call intel_handle_error() on the engine. On
> looking at this code again, I could not justify the open-coding of the
> engine reset fragment of the general error handler, especially as we end
> up taking that route anyway for device resets. (Unlike inside the
> tasklet, there's no atomicity concerns on this engine-reset path.)

I think yesterday I got lost in boolean logic and flows here. Today it 
looks fine. Bool ban will be true and code will indeed enter the 
__kill_context path.

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko



