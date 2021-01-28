Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53BF307782
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 14:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhA1N4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 08:56:40 -0500
Received: from mga05.intel.com ([192.55.52.43]:62457 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229652AbhA1N4k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 08:56:40 -0500
IronPort-SDR: Ts5AJaREvQLy9R00YXColfNkAjTkPrWlwdVGMFcgBxr5XgQEYcTlWNmlgM6G3HNxYrcR3pWG2+
 VHFm1Iwv6qZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9877"; a="265066345"
X-IronPort-AV: E=Sophos;i="5.79,382,1602572400"; 
   d="scan'208";a="265066345"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 05:54:52 -0800
IronPort-SDR: Mm7gPm0MgWf1yF3EZk6YLHaX8IuWruvEpl/GRxggb2XEWeGhyBGOJctEDA5ZSQZpJ7tc+OqB8T
 K66iI/tjg17g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,382,1602572400"; 
   d="scan'208";a="363737732"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by fmsmga008.fm.intel.com with SMTP; 28 Jan 2021 05:54:49 -0800
Received: by stinkbox (sSMTP sendmail emulation); Thu, 28 Jan 2021 15:54:48 +0200
Date:   Thu, 28 Jan 2021 15:54:48 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Imre Deak <imre.deak@intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Ville Syrjala <ville.syrjala@intel.com>, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 2/2] drm/i915: Fix the MST PBN divider
 calculation
Message-ID: <YBLCKKLil4zto+U7@intel.com>
References: <20210125173636.1733812-1-imre.deak@intel.com>
 <20210125173636.1733812-2-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210125173636.1733812-2-imre.deak@intel.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 07:36:36PM +0200, Imre Deak wrote:
> Atm the driver will calculate a wrong MST timeslots/MTP (aka time unit)
> value for MST streams if the link parameters (link rate or lane count)
> are limited in a way independent of the sink capabilities (reported by
> DPCD).
> 
> One example of such a limitation is when a MUX between the sink and
> source connects only a limited number of lanes to the display and
> connects the rest of the lanes to other peripherals (USB).
> 
> Another issue is that atm MST core calculates the divider based on the
> backwards compatible DPCD (at address 0x0000) vs. the extended
> capability info (at address 0x2200). This can result in leaving some
> part of the MST BW unused (For instance in case of the WD19TB dock).
> 
> Fix the above two issues by calculating the PBN divider value based on
> the rate and lane count link parameters that the driver uses for all
> other computation.
> 
> Bugzilla: https://gitlab.freedesktop.org/drm/intel/-/issues/2977
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Ville Syrjala <ville.syrjala@intel.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Imre Deak <imre.deak@intel.com>

Looks all right to fix some of the immediate problems.

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/display/intel_dp_mst.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> index d6a1b961a0e8..b4621ed0127e 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> @@ -68,7 +68,9 @@ static int intel_dp_mst_compute_link_config(struct intel_encoder *encoder,
>  
>  		slots = drm_dp_atomic_find_vcpi_slots(state, &intel_dp->mst_mgr,
>  						      connector->port,
> -						      crtc_state->pbn, 0);
> +						      crtc_state->pbn,
> +						      drm_dp_get_vc_payload_bw(crtc_state->port_clock,
> +									       crtc_state->lane_count));
>  		if (slots == -EDEADLK)
>  			return slots;
>  		if (slots >= 0)
> -- 
> 2.25.1
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Ville Syrjälä
Intel
