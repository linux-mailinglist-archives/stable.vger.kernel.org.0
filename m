Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152FF1A9BDC
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896779AbgDOLLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:11:49 -0400
Received: from mga18.intel.com ([134.134.136.126]:6920 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896754AbgDOLLj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:11:39 -0400
IronPort-SDR: LVf3c91CMstKsFtm0AQXE0LxDXX6omwBuylh53LK4GdlR6J1EnKjAbxouQ/JXRHlzJitNhyUve
 cG6I2AeXu3pg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 04:11:02 -0700
IronPort-SDR: m784YejBeSGPC4uUll48KfJugWat0l1mlLktWdHH8pxDn013ofHBIaKHoM7AZzX9rcj6zDgRKU
 h0BrXbORmCtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,386,1580803200"; 
   d="scan'208";a="256825955"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by orsmga006.jf.intel.com with ESMTP; 15 Apr 2020 04:11:00 -0700
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id 0316E5C1DA7; Wed, 15 Apr 2020 14:09:10 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Francisco Jerez <currojerez@riseup.net>,
        Andi Shyti <andi.shyti@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/gt: Update PMINTRMSK holding fw
In-Reply-To: <20200415075018.7636-1-chris@chris-wilson.co.uk>
References: <20200415075018.7636-1-chris@chris-wilson.co.uk>
Date:   Wed, 15 Apr 2020 14:09:10 +0300
Message-ID: <875ze1ngyx.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> If we use a non-forcewaked write to PMINTRMSK, it does not take effect
> until much later, if at all, causing a loss of RPS interrupts and no GPU
> reclocking, leaving the GPU running at the wrong frequency for long
> periods of time.
>
> Reported-by: Francisco Jerez <currojerez@riseup.net>
> Suggested-by: Francisco Jerez <currojerez@riseup.net>
> Fixes: 35cc7f32c298 ("drm/i915/gt: Use non-forcewake writes for RPS")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Francisco Jerez <currojerez@riseup.net>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: Andi Shyti <andi.shyti@intel.com>
> Cc: <stable@vger.kernel.org> # v5.6+

Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/gt/intel_rps.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/gt/intel_rps.c
> index 86110458e2a7..6a3505467406 100644
> --- a/drivers/gpu/drm/i915/gt/intel_rps.c
> +++ b/drivers/gpu/drm/i915/gt/intel_rps.c
> @@ -81,13 +81,14 @@ static void rps_enable_interrupts(struct intel_rps *rps)
>  		events = (GEN6_PM_RP_UP_THRESHOLD |
>  			  GEN6_PM_RP_DOWN_THRESHOLD |
>  			  GEN6_PM_RP_DOWN_TIMEOUT);
> -
>  	WRITE_ONCE(rps->pm_events, events);
> +
>  	spin_lock_irq(&gt->irq_lock);
>  	gen6_gt_pm_enable_irq(gt, rps->pm_events);
>  	spin_unlock_irq(&gt->irq_lock);
>  
> -	set(gt->uncore, GEN6_PMINTRMSK, rps_pm_mask(rps, rps->cur_freq));
> +	intel_uncore_write(gt->uncore,
> +                           GEN6_PMINTRMSK, rps_pm_mask(rps, rps->last_freq));
>  }
>  
>  static void gen6_rps_reset_interrupts(struct intel_rps *rps)
> @@ -120,7 +121,9 @@ static void rps_disable_interrupts(struct intel_rps *rps)
>  	struct intel_gt *gt = rps_to_gt(rps);
>  
>  	WRITE_ONCE(rps->pm_events, 0);
> -	set(gt->uncore, GEN6_PMINTRMSK, rps_pm_sanitize_mask(rps, ~0u));
> +
> +	intel_uncore_write(gt->uncore,
> +                           GEN6_PMINTRMSK, rps_pm_sanitize_mask(rps, ~0u));
>  
>  	spin_lock_irq(&gt->irq_lock);
>  	gen6_gt_pm_disable_irq(gt, GEN6_PM_RPS_EVENTS);
> -- 
> 2.20.1
