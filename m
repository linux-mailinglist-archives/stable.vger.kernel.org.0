Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07AAF2C339D
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 22:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388382AbgKXV6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 16:58:55 -0500
Received: from mga04.intel.com ([192.55.52.120]:38118 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731696AbgKXV6z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 16:58:55 -0500
IronPort-SDR: MBJf3wp241UMTw4xqnUAaZTB7digrQRVFfRhiAiPXvt53I6THkm+QFMUf86L+K+alf2B5uh5ft
 xWpku0CAEjRg==
X-IronPort-AV: E=McAfee;i="6000,8403,9815"; a="169461908"
X-IronPort-AV: E=Sophos;i="5.78,367,1599548400"; 
   d="scan'208";a="169461908"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 13:58:54 -0800
IronPort-SDR: zGtiG5sC6xyKG7myy1BAR+BbgFi5eXj0OTpBc4Wk5VgUDukbjML5rpQ7iO7zEBKXi5yVHlMwbm
 a1FZxcYVS3sg==
X-IronPort-AV: E=Sophos;i="5.78,367,1599548400"; 
   d="scan'208";a="535027894"
Received: from tphelan-mobl3.ger.corp.intel.com (HELO intel.com) ([10.252.20.12])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 13:58:52 -0800
Date:   Tue, 24 Nov 2020 23:58:49 +0200
From:   Andi Shyti <andi.shyti@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org,
        Edward Baker <edward.baker@intel.com>,
        Lyude Paul <lyude@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/gt: Limit frequency drop to RPe on parking
Message-ID: <20201124215849.GC6936@intel.intel>
References: <20201124183521.28623-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124183521.28623-1-chris@chris-wilson.co.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Chris,

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
> +	}

looks OK to me, makes sense:

Reviewed-by: Andi Shyti <andi.shyti@intel.com>

Thanks,
Andi
