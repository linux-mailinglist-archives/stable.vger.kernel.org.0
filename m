Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FA52CF05F
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 16:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgLDPIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 10:08:10 -0500
Received: from mga07.intel.com ([134.134.136.100]:16201 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgLDPIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Dec 2020 10:08:10 -0500
IronPort-SDR: EVscu//8yd0z9muhCjQrsTMaKdRnbBtO349dUaJtYo17Q9OTLeApX028PT+RZkDsJPMQd6/sMl
 gRQ6qiANvYSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9824"; a="237503747"
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="237503747"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2020 07:06:29 -0800
IronPort-SDR: lPZyzBSeP1HcfqEBYs3o/PZMJVGBsu2oUAVZYrR2EI5jp3xRpp5vn9it8b3PIp3yhIK7afg8+z
 AESgQ8aJKA0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="346630937"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by orsmga002.jf.intel.com with ESMTP; 04 Dec 2020 07:06:28 -0800
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id 9ACB35C2069; Fri,  4 Dec 2020 17:04:16 +0200 (EET)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 03/24] drm/i915/gt: Cancel the preemption timeout on responding to it
In-Reply-To: <20201204140315.24341-3-chris@chris-wilson.co.uk>
References: <20201204140315.24341-1-chris@chris-wilson.co.uk> <20201204140315.24341-3-chris@chris-wilson.co.uk>
Date:   Fri, 04 Dec 2020 17:04:16 +0200
Message-ID: <874kl1395b.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> We currently presume that the engine reset is successful, cancelling the
> expired preemption timer in the process. However, engine resets can
> fail, leaving the timeout still pending and we will then respond to the
> timeout again next time the tasklet fires. What we want is for the
> failed engine reset to be promoted to a full device reset, which is
> kicked by the heartbeat once the engine stops processing events.
>
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1168
> Fixes: 3a7a92aba8fb ("drm/i915/execlists: Force preemption")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: <stable@vger.kernel.org> # v5.5+

Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/gt/intel_lrc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
> index 1d209a8a95e8..7f25894e41d5 100644
> --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> @@ -3209,8 +3209,10 @@ static void execlists_submission_tasklet(unsigned long data)
>  		spin_unlock_irqrestore(&engine->active.lock, flags);
>  
>  		/* Recheck after serialising with direct-submission */
> -		if (unlikely(timeout && preempt_timeout(engine)))
> +		if (unlikely(timeout && preempt_timeout(engine))) {
> +			cancel_timer(&engine->execlists.preempt);
>  			execlists_reset(engine, "preemption time out");
> +		}
>  	}
>  }
>  
> -- 
> 2.20.1
>
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
