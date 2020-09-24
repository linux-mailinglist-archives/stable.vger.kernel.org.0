Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB702773E2
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 16:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgIXO1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 10:27:02 -0400
Received: from mga07.intel.com ([134.134.136.100]:51232 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728064AbgIXO1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 10:27:02 -0400
IronPort-SDR: kS5ADQr/e/uhyPue67uRUUE64p5Cewh8k/0Rv9POt0IHThCdcBqLG2nYr8B8tp0wmYB71dTJPy
 XVxM03OH4+OQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="225357200"
X-IronPort-AV: E=Sophos;i="5.77,298,1596524400"; 
   d="scan'208";a="225357200"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 07:27:00 -0700
IronPort-SDR: HA/gdiVbyru/Ci/jiRbz8roSCHZSMXk6tYBl3rSUwxA+JqThCmOPg8ivgj2m/TrYYvNjKzFbhB
 3fBEKP7VfZQw==
X-IronPort-AV: E=Sophos;i="5.77,298,1596524400"; 
   d="scan'208";a="486918890"
Received: from dsmahang-mobl2.ger.corp.intel.com (HELO [10.252.48.167]) ([10.252.48.167])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 07:26:59 -0700
Subject: Re: [Intel-gfx] [PATCH 4/4] drm/i915/gem: Always test execution
 status on closing the context
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200916094219.3878-1-chris@chris-wilson.co.uk>
 <20200916094219.3878-4-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <e665fc1d-1b9d-a6ee-1798-df32d1296118@linux.intel.com>
Date:   Thu, 24 Sep 2020 15:26:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200916094219.3878-4-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/09/2020 10:42, Chris Wilson wrote:
> Verify that if a context is active at the time it is closed, that it is
> either persistent and preemptible (with hangcheck running) or it shall
> be removed from execution.
> 
> Fixes: 9a40bddd47ca ("drm/i915/gt: Expose heartbeat interval via sysfs")
> Testcase: igt/gem_ctx_persistence/heartbeat-close
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v5.7+
> ---
>   drivers/gpu/drm/i915/gem/i915_gem_context.c | 48 +++++----------------
>   1 file changed, 10 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
> index a548626fa8bc..4fd38101bb56 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
> @@ -390,24 +390,6 @@ __context_engines_static(const struct i915_gem_context *ctx)
>   	return rcu_dereference_protected(ctx->engines, true);
>   }
>   
> -static bool __reset_engine(struct intel_engine_cs *engine)
> -{
> -	struct intel_gt *gt = engine->gt;
> -	bool success = false;
> -
> -	if (!intel_has_reset_engine(gt))
> -		return false;
> -
> -	if (!test_and_set_bit(I915_RESET_ENGINE + engine->id,
> -			      &gt->reset.flags)) {
> -		success = intel_engine_reset(engine, NULL) == 0;
> -		clear_and_wake_up_bit(I915_RESET_ENGINE + engine->id,
> -				      &gt->reset.flags);
> -	}
> -
> -	return success;
> -}
> -
>   static void __reset_context(struct i915_gem_context *ctx,
>   			    struct intel_engine_cs *engine)
>   {
> @@ -431,12 +413,7 @@ static bool __cancel_engine(struct intel_engine_cs *engine)
>   	 * kill the banned context, we fallback to doing a local reset
>   	 * instead.
>   	 */
> -	if (IS_ACTIVE(CONFIG_DRM_I915_PREEMPT_TIMEOUT) &&
> -	    !intel_engine_pulse(engine))
> -		return true;
> -
> -	/* If we are unable to send a pulse, try resetting this engine. */
> -	return __reset_engine(engine);
> +	return intel_engine_pulse(engine) == 0;

Where is the path now which actually resets the currently running 
workload (engine) of a non-persistent context? Pulse will be sent and 
then rely on hangcheck but otherwise let it run?

Regards,

Tvrtko

>   }
>   
>   static bool
> @@ -506,7 +483,7 @@ static struct intel_engine_cs *active_engine(struct intel_context *ce)
>   	return engine;
>   }
>   
> -static void kill_engines(struct i915_gem_engines *engines)
> +static void kill_engines(struct i915_gem_engines *engines, bool ban)
>   {
>   	struct i915_gem_engines_iter it;
>   	struct intel_context *ce;
> @@ -521,7 +498,7 @@ static void kill_engines(struct i915_gem_engines *engines)
>   	for_each_gem_engine(ce, engines, it) {
>   		struct intel_engine_cs *engine;
>   
> -		if (intel_context_set_banned(ce))
> +		if (ban && intel_context_set_banned(ce))
>   			continue;
>   
>   		/*
> @@ -534,7 +511,7 @@ static void kill_engines(struct i915_gem_engines *engines)
>   		engine = active_engine(ce);
>   
>   		/* First attempt to gracefully cancel the context */
> -		if (engine && !__cancel_engine(engine))
> +		if (engine && !__cancel_engine(engine) && ban)
>   			/*
>   			 * If we are unable to send a preemptive pulse to bump
>   			 * the context from the GPU, we have to resort to a full
> @@ -544,8 +521,10 @@ static void kill_engines(struct i915_gem_engines *engines)
>   	}
>   }
>   
> -static void kill_stale_engines(struct i915_gem_context *ctx)
> +static void kill_context(struct i915_gem_context *ctx)
>   {
> +	bool ban = (!i915_gem_context_is_persistent(ctx) ||
> +		    !ctx->i915->params.enable_hangcheck);
>   	struct i915_gem_engines *pos, *next;
>   
>   	spin_lock_irq(&ctx->stale.lock);
> @@ -558,7 +537,7 @@ static void kill_stale_engines(struct i915_gem_context *ctx)
>   
>   		spin_unlock_irq(&ctx->stale.lock);
>   
> -		kill_engines(pos);
> +		kill_engines(pos, ban);
>   
>   		spin_lock_irq(&ctx->stale.lock);
>   		GEM_BUG_ON(i915_sw_fence_signaled(&pos->fence));
> @@ -570,11 +549,6 @@ static void kill_stale_engines(struct i915_gem_context *ctx)
>   	spin_unlock_irq(&ctx->stale.lock);
>   }
>   
> -static void kill_context(struct i915_gem_context *ctx)
> -{
> -	kill_stale_engines(ctx);
> -}
> -
>   static void engines_idle_release(struct i915_gem_context *ctx,
>   				 struct i915_gem_engines *engines)
>   {
> @@ -609,7 +583,7 @@ static void engines_idle_release(struct i915_gem_context *ctx,
>   
>   kill:
>   	if (list_empty(&engines->link)) /* raced, already closed */
> -		kill_engines(engines);
> +		kill_engines(engines, true);
>   
>   	i915_sw_fence_commit(&engines->fence);
>   }
> @@ -667,9 +641,7 @@ static void context_close(struct i915_gem_context *ctx)
>   	 * case we opt to forcibly kill off all remaining requests on
>   	 * context close.
>   	 */
> -	if (!i915_gem_context_is_persistent(ctx) ||
> -	    !ctx->i915->params.enable_hangcheck)
> -		kill_context(ctx);
> +	kill_context(ctx);
>   
>   	i915_gem_context_put(ctx);
>   }
> 
