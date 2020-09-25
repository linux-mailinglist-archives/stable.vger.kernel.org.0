Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D663C278585
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 13:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgIYLEP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 25 Sep 2020 07:04:15 -0400
Received: from mga03.intel.com ([134.134.136.65]:63962 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgIYLEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 07:04:15 -0400
IronPort-SDR: 0e247YJFuzE5fVpi41sfjMyjLsQ2iLkcBvUeQczjfsPEtbm6mQPFEKsfdtRGEWIRbrawJzsv/5
 kFs4K/dlikIA==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="161583492"
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="161583492"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 04:04:14 -0700
IronPort-SDR: CZKxz2YcHMrBDhdnoMh8DD78AiwgTgMk1XCVVcCYnfZJQLRgFcQ81bh37+XfqstdE/qgjOUxwZ
 n4owsiso+BtA==
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="455786504"
Received: from gkeaveny-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.30.201])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 04:04:12 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200916094219.3878-2-chris@chris-wilson.co.uk>
References: <20200916094219.3878-1-chris@chris-wilson.co.uk> <20200916094219.3878-2-chris@chris-wilson.co.uk>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
From:   Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 2/4] drm/i915: Cancel outstanding work after disabling heartbeats on an engine
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Message-ID: <160103184907.9735.4650760110326834457@jlahtine-mobl.ger.corp.intel.com>
User-Agent: alot/0.8.1
Date:   Fri, 25 Sep 2020 14:04:09 +0300
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Chris Wilson (2020-09-16 12:42:17)
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

Definitely makes sense to ensure.

Acked-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

Regards, Joonas

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
>         return intel_engine_has_preemption(engine);
>  }
>  
> +static inline bool
> +intel_engine_has_heartbeat(const struct intel_engine_cs *engine)
> +{
> +       if (!IS_ACTIVE(CONFIG_DRM_I915_HEARTBEAT_INTERVAL))
> +               return false;
> +
> +       return READ_ONCE(engine->props.heartbeat_interval_ms);
> +}
> +
>  #endif /* _INTEL_RINGBUFFER_H_ */
> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> index 436ce368ddaa..0e813819b041 100644
> --- a/drivers/gpu/drm/i915/i915_request.c
> +++ b/drivers/gpu/drm/i915/i915_request.c
> @@ -542,8 +542,13 @@ bool __i915_request_submit(struct i915_request *request)
>         if (i915_request_completed(request))
>                 goto xfer;
>  
> +       if (unlikely(intel_context_is_closed(request->context) &&
> +                    !intel_engine_has_heartbeat(engine)))
> +               intel_context_set_banned(request->context);
> +
>         if (unlikely(intel_context_is_banned(request->context)))
>                 i915_request_set_error_once(request, -EIO);
> +
>         if (unlikely(fatal_error(request->fence.error)))
>                 __i915_request_skip(request);
>  
> -- 
> 2.20.1
> 
