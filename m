Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CB5256679
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 11:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgH2Jb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Aug 2020 05:31:28 -0400
Received: from mga04.intel.com ([192.55.52.120]:37707 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbgH2Jb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Aug 2020 05:31:27 -0400
IronPort-SDR: BfnNXjxkNAxZgxfOxB2GM+3VHp5T5yodUN6cBuqZDY+tgWV3UrmA3N1UG8Ki96Kiwem0XfxNp9
 DIeo1sYj8pTg==
X-IronPort-AV: E=McAfee;i="6000,8403,9727"; a="154199271"
X-IronPort-AV: E=Sophos;i="5.76,367,1592895600"; 
   d="scan'208";a="154199271"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2020 02:31:26 -0700
IronPort-SDR: JJxhgVCl0X0KoFn/lCq77GN0rdXAb6qnVR/3wCv2t3QIDe8IIhnuOM34VzXr7XYBa01lvqJSJA
 xhFVOYvHUKuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,367,1592895600"; 
   d="scan'208";a="340134502"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by orsmga007.jf.intel.com with ESMTP; 29 Aug 2020 02:31:24 -0700
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id E49D55C2774; Sat, 29 Aug 2020 12:30:27 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [Intel-gfx] [PATCH 10/39] drm/i915: Cancel outstanding work after disabling heartbeats on an engine
In-Reply-To: <20200826132811.17577-10-chris@chris-wilson.co.uk>
References: <20200826132811.17577-1-chris@chris-wilson.co.uk> <20200826132811.17577-10-chris@chris-wilson.co.uk>
Date:   Sat, 29 Aug 2020 12:30:27 +0300
Message-ID: <87r1rpztn0.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

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

Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/gt/intel_engine.h | 9 +++++++++
>  drivers/gpu/drm/i915/i915_request.c    | 5 +++++
>  2 files changed, 14 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_engine.h b/drivers/gpu/drm/i915/gt/intel_engine.h
> index 08e2c000dcc3..7c3a1012e702 100644
> --- a/drivers/gpu/drm/i915/gt/intel_engine.h
> +++ b/drivers/gpu/drm/i915/gt/intel_engine.h
> @@ -337,4 +337,13 @@ intel_engine_has_preempt_reset(const struct intel_engine_cs *engine)
>  	return intel_engine_has_preemption(engine);
>  }
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
>  #endif /* _INTEL_RINGBUFFER_H_ */
> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> index a931b8b571d1..c187e1ec0278 100644
> --- a/drivers/gpu/drm/i915/i915_request.c
> +++ b/drivers/gpu/drm/i915/i915_request.c
> @@ -542,8 +542,13 @@ bool __i915_request_submit(struct i915_request *request)
>  	if (i915_request_completed(request))
>  		goto xfer;
>  
> +	if (unlikely(intel_context_is_closed(request->context) &&
> +		     !intel_engine_has_heartbeat(engine)))
> +		intel_context_set_banned(request->context);
> +
>  	if (unlikely(intel_context_is_banned(request->context)))
>  		i915_request_set_error_once(request, -EIO);
> +
>  	if (unlikely(fatal_error(request->fence.error)))
>  		__i915_request_skip(request);
>  
> -- 
> 2.20.1
>
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
