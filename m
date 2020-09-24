Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A4527727A
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 15:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgIXNfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 09:35:50 -0400
Received: from mga04.intel.com ([192.55.52.120]:16802 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727742AbgIXNfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 09:35:50 -0400
IronPort-SDR: L3RzRzNsoyzMwPDlaBQnQJk/zVqk3lYY/8mhDgXW7XgKF7ru+Wwi0UiWeqS8mXh5z5IYpS19iS
 gXDKLVkhgfFA==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="158581502"
X-IronPort-AV: E=Sophos;i="5.77,297,1596524400"; 
   d="scan'208";a="158581502"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 06:35:50 -0700
IronPort-SDR: xYueDg963HflFEGQZdmFiKalgrrcEt4jJAxDByKW/i3Ru72GSr9LlGyHSKjvGufKhyriSpnv7V
 5U7kjhmCRn+w==
X-IronPort-AV: E=Sophos;i="5.77,297,1596524400"; 
   d="scan'208";a="486903083"
Received: from dsmahang-mobl2.ger.corp.intel.com (HELO [10.252.48.167]) ([10.252.48.167])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 06:35:49 -0700
Subject: Re: [Intel-gfx] [PATCH 2/4] drm/i915: Cancel outstanding work after
 disabling heartbeats on an engine
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200916094219.3878-1-chris@chris-wilson.co.uk>
 <20200916094219.3878-2-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <756c5947-dcc4-0a4e-e5b7-960d0afe8fd3@linux.intel.com>
Date:   Thu, 24 Sep 2020 14:35:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200916094219.3878-2-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/09/2020 10:42, Chris Wilson wrote:
> We only allow persistent requests to remain on the GPU past the closure
> of their containing context (and process) so long as they are continuously
> checked for hangs or allow other requests to preempt them, as we need to
> ensure forward progress of the system. If we allow persistent contexts
> to remain on the system after the the hangcheck mechanism is disabled,
> the system may grind to a halt. On disabling the mechanism, we sent a
> pulse along the engine to remove all executing contexts from the engine
> which would check for hung contexts -- but we did not prevent those
> contexts from being resubmitted if they survived the final hangcheck.
> 
> Fixes: 9a40bddd47ca ("drm/i915/gt: Expose heartbeat interval via sysfs")
> Testcase: igt/gem_ctx_persistence/heartbeat-stop
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v5.7+
> ---
>   drivers/gpu/drm/i915/gt/intel_engine.h | 9 +++++++++
>   drivers/gpu/drm/i915/i915_request.c    | 5 +++++
>   2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_engine.h b/drivers/gpu/drm/i915/gt/intel_engine.h
> index 08e2c000dcc3..7c3a1012e702 100644
> --- a/drivers/gpu/drm/i915/gt/intel_engine.h
> +++ b/drivers/gpu/drm/i915/gt/intel_engine.h
> @@ -337,4 +337,13 @@ intel_engine_has_preempt_reset(const struct intel_engine_cs *engine)
>   	return intel_engine_has_preemption(engine);
>   }
>   
> +static inline bool
> +intel_engine_has_heartbeat(const struct intel_engine_cs *engine)
> +{
> +	if (!IS_ACTIVE(CONFIG_DRM_I915_HEARTBEAT_INTERVAL))
> +		return false;
> +
> +	return READ_ONCE(engine->props.heartbeat_interval_ms);
> +}
> +
>   #endif /* _INTEL_RINGBUFFER_H_ */
> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> index 436ce368ddaa..0e813819b041 100644
> --- a/drivers/gpu/drm/i915/i915_request.c
> +++ b/drivers/gpu/drm/i915/i915_request.c
> @@ -542,8 +542,13 @@ bool __i915_request_submit(struct i915_request *request)
>   	if (i915_request_completed(request))
>   		goto xfer;
>   
> +	if (unlikely(intel_context_is_closed(request->context) &&
> +		     !intel_engine_has_heartbeat(engine)))
> +		intel_context_set_banned(request->context);
> +
>   	if (unlikely(intel_context_is_banned(request->context)))
>   		i915_request_set_error_once(request, -EIO);
> +
>   	if (unlikely(fatal_error(request->fence.error)))
>   		__i915_request_skip(request);
>   
> 

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
