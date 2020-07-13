Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3EC21DB5E
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 18:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgGMQOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 12:14:41 -0400
Received: from mga18.intel.com ([134.134.136.126]:32719 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729027AbgGMQOl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jul 2020 12:14:41 -0400
IronPort-SDR: XhRUtHQD/7UTrY3ligYdp2YvIcebIKdIuXUO3Qq6WsECqsiY6F/kUcrbZ9u0j0vusDYpgyYl5u
 b031J3qHQLEQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="136120756"
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="136120756"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 09:14:41 -0700
IronPort-SDR: Zeu/T5TI1Rac8PoQbZGtf/LJKOLNIrpQivAL38EHyGP4b3mpP6y1pwXeYbQJvwiQXaoz8QBFY1
 t1nnPXx88dwg==
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="459349806"
Received: from thoebenx-mobl.ger.corp.intel.com (HELO [10.255.194.109]) ([10.255.194.109])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 09:14:39 -0700
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Only swap to a random sibling
 once upon creation
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200713160549.17344-1-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <9ff03777-4411-5c60-9c78-1d5be3252915@linux.intel.com>
Date:   Mon, 13 Jul 2020 17:14:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200713160549.17344-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 13/07/2020 17:05, Chris Wilson wrote:
> The danger in switching at random upon intel_context_pin is that the
> context may still actually be inflight, as it will not be scheduled out
> until a context switch after it is complete -- that is after we do a
> final intel_context_unpin.
> 
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2118
> Fixes: 6d06779e8672 ("drm/i915: Load balancing across a virtual engine")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: <stable@vger.kernel.org> # v5.3+
> ---
>   drivers/gpu/drm/i915/gt/intel_lrc.c | 18 ++++--------------
>   1 file changed, 4 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
> index cd4262cc96e2..f4658849b08a 100644
> --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> @@ -5435,13 +5435,8 @@ static void virtual_engine_initial_hint(struct virtual_engine *ve)
>   	 * typically be the first we inspect for submission.
>   	 */
>   	swp = prandom_u32_max(ve->num_siblings);
> -	if (!swp)
> -		return;
> -
> -	swap(ve->siblings[swp], ve->siblings[0]);
> -	if (!intel_engine_has_relative_mmio(ve->siblings[0]))
> -		virtual_update_register_offsets(ve->context.lrc_reg_state,
> -						ve->siblings[0]);
> +	if (swp)
> +		swap(ve->siblings[swp], ve->siblings[0]);
>   }
>   
>   static int virtual_context_alloc(struct intel_context *ce)
> @@ -5454,15 +5449,9 @@ static int virtual_context_alloc(struct intel_context *ce)
>   static int virtual_context_pin(struct intel_context *ce)
>   {
>   	struct virtual_engine *ve = container_of(ce, typeof(*ve), context);
> -	int err;
>   
>   	/* Note: we must use a real engine class for setting up reg state */
> -	err = __execlists_context_pin(ce, ve->siblings[0]);
> -	if (err)
> -		return err;
> -
> -	virtual_engine_initial_hint(ve);
> -	return 0;
> +	return __execlists_context_pin(ce, ve->siblings[0]);
>   }
>   
>   static void virtual_context_enter(struct intel_context *ce)
> @@ -5808,6 +5797,7 @@ intel_execlists_create_virtual(struct intel_engine_cs **siblings,
>   
>   	ve->base.flags |= I915_ENGINE_IS_VIRTUAL;
>   
> +	virtual_engine_initial_hint(ve);
>   	return &ve->context;
>   
>   err_put:
> 

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
