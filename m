Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCBF02C3156
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 20:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgKXTsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 14:48:01 -0500
Received: from mga04.intel.com ([192.55.52.120]:26173 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728211AbgKXTr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 14:47:59 -0500
IronPort-SDR: rX7RV4a6Zt2vhi1gOephrPgWRilW3S+wl1BSL9dzLhflVnIB5/i6WjoSeUaGDL3/OG3WrATMnk
 /I2X8J4NA3sQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9815"; a="169444058"
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="169444058"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 11:46:30 -0800
IronPort-SDR: 98u2aPAVv3SOxEf7T4UlmYt8bdGdtEBjs0RXubMnlKd51YmN1bwMUuHEpRcmb+lq2FZX6Xdb4/
 HNBCkBwvrsIg==
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="313358360"
Received: from partheeb-mobl1.amr.corp.intel.com (HELO intel.com) ([10.251.20.252])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 11:46:30 -0800
Date:   Tue, 24 Nov 2020 11:46:29 -0800
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Limit frequency drop to RPe on
 parking
Message-ID: <20201124194629.GA719740@intel.com>
References: <20201124183521.28623-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124183521.28623-1-chris@chris-wilson.co.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 24, 2020 at 06:35:21PM +0000, Chris Wilson wrote:
> We treat idling the GT (intel_rps_park) as a downclock event, and reduce
> the frequency we intend to restart the GT with. Since the two workloads
> are likely related (e.g. a compositor rendering every 16ms), we want to
> carry the frequency and load information from across the idling.
> However, we do also need to update the frequencies so that workloads
> that run for less than 1ms are autotuned by RPS (otherwise we leave
> compositors running at max clocks, draining excess power). Conversely,
> if we try to run too slowly, the next workload has to run longer. Since
> there is a hysteresis in the power graph, below a certain frequency
> running a short workload for longer consumes more energy than running it
> slightly higher for less time. The exact balance point is unknown
> beforehand, but measurements with 30fps media playback indicate that RPe
> is a better choice.
> 
> Reported-by: Edward Baker <edward.baker@intel.com>
> Fixes: 043cd2d14ede ("drm/i915/gt: Leave rps->cur_freq on unpark")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Edward Baker <edward.baker@intel.com>
> Cc: Andi Shyti <andi.shyti@intel.com>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: <stable@vger.kernel.org> # v5.8+
> ---
>  drivers/gpu/drm/i915/gt/intel_rps.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/gt/intel_rps.c
> index b13e7845d483..f74d5e09e176 100644
> --- a/drivers/gpu/drm/i915/gt/intel_rps.c
> +++ b/drivers/gpu/drm/i915/gt/intel_rps.c
> @@ -907,6 +907,10 @@ void intel_rps_park(struct intel_rps *rps)
>  		adj = -2;
>  	rps->last_adj = adj;
>  	rps->cur_freq = max_t(int, rps->cur_freq + adj, rps->min_freq);
> +	if (rps->cur_freq < rps->efficient_freq) {
> +		rps->cur_freq = rps->efficient_freq;
> +		rps->last_adj = 0;

this is indeed the smallest fix we can propagate:


Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

but I wonder now if we couldn't simply kill the last_adj now and always go
with the rpe on park/unpark

> +	}
>  
>  	GT_TRACE(rps_to_gt(rps), "park:%x\n", rps->cur_freq);
>  }
> -- 
> 2.20.1
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
