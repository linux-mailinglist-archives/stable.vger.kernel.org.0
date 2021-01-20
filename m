Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC332FCCB3
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 09:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730429AbhATI1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 03:27:05 -0500
Received: from mga12.intel.com ([192.55.52.136]:12130 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730805AbhATI0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 03:26:13 -0500
IronPort-SDR: SLFwOHoScg1j4oVbidYrRpArj26c/t0BkTpdyrCOxKFJ6fwhAVykJt863L5A/PelMCPwDOU5ZS
 tAIo9e7J9tEg==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="158246163"
X-IronPort-AV: E=Sophos;i="5.79,360,1602572400"; 
   d="scan'208";a="158246163"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 00:24:18 -0800
IronPort-SDR: UItnTtRdZ8jDigUOqGGa0BjFO+2MiyffHK4yaVRsVUychU3a9caNmvbdoE5ir8yZ0J2m+x363/
 uv0AXI5QT+Ig==
X-IronPort-AV: E=Sophos;i="5.79,360,1602572400"; 
   d="scan'208";a="384634946"
Received: from dgravino-mobl1.ger.corp.intel.com (HELO [10.249.41.166]) ([10.249.41.166])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 00:24:17 -0800
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Close race between
 enable_breadcrumbs and cancel_breadcrumbs
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20210119162057.31097-1-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <c77fba54-7d23-0203-b6cd-a44a0fb89532@linux.intel.com>
Date:   Wed, 20 Jan 2021 08:24:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210119162057.31097-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 19/01/2021 16:20, Chris Wilson wrote:
> If we enable_breadcrumbs for a request while that request is being
> removed from HW; we may see that the request is active as we take the
> ce->signal_lock and proceed to attach the request to ce->signals.
> However, during unsubmission after marking the request as inactive, we
> see that the request has not yet been added to ce->signals and so skip
> the removal. Pull the check during cancel_breadcrumbs under the same
> spinlock as enabling so that we the two tests are consistent in
> enable/cancel.
> 
> Otherwise, we may insert a request onto ce->signal that we expect should
> not be there:
> 
>    intel_context_remove_breadcrumbs:488 GEM_BUG_ON(!__i915_request_is_complete(rq))
> 
> While updating, we can note that we are always called with
> irqs-disabled, due to the engine->active.lock being held at the single
> caller, and so remove the irqsave/restore.
> 
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2931
> Fixes: c18636f76344 ("drm/i915: Remove requirement for holding i915_request.lock for breadcrumbs")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: Andi Shyti <andi.shyti@intel.com>
> Cc: <stable@vger.kernel.org> # v5.10+
> ---
>   drivers/gpu/drm/i915/gt/intel_breadcrumbs.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
> index d098fc0c14ec..34a645d6babd 100644
> --- a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
> +++ b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
> @@ -453,16 +453,17 @@ void i915_request_cancel_breadcrumb(struct i915_request *rq)
>   {
>   	struct intel_breadcrumbs *b = READ_ONCE(rq->engine)->breadcrumbs;
>   	struct intel_context *ce = rq->context;
> -	unsigned long flags;
>   	bool release;
>   
> -	if (!test_and_clear_bit(I915_FENCE_FLAG_SIGNAL, &rq->fence.flags))
> +	spin_lock(&ce->signal_lock);
> +	if (!test_and_clear_bit(I915_FENCE_FLAG_SIGNAL, &rq->fence.flags)) {
> +		spin_unlock(&ce->signal_lock);
>   		return;
> +	}
>   
> -	spin_lock_irqsave(&ce->signal_lock, flags);
>   	list_del_rcu(&rq->signal_link);
>   	release = remove_signaling_context(b, ce);
> -	spin_unlock_irqrestore(&ce->signal_lock, flags);
> +	spin_unlock(&ce->signal_lock);
>   	if (release)
>   		intel_context_put(ce);
>   
> 

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
