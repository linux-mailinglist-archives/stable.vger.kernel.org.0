Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E97C8980F5
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 19:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbfHUREQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 13:04:16 -0400
Received: from mga17.intel.com ([192.55.52.151]:58356 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbfHUREQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Aug 2019 13:04:16 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 10:04:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="203086539"
Received: from labuser-z97x-ud5h.jf.intel.com (HELO intel.com) ([10.54.75.49])
  by fmsmga004.fm.intel.com with ESMTP; 21 Aug 2019 10:04:15 -0700
Date:   Wed, 21 Aug 2019 10:05:48 -0700
From:   Manasi Navare <manasi.d.navare@intel.com>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH 01/10] drm/i915/dp: Fix dsc bpp calculations.
Message-ID: <20190821170548.GA31411@intel.com>
References: <20190821133221.29456-1-maarten.lankhorst@linux.intel.com>
 <20190821133221.29456-2-maarten.lankhorst@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821133221.29456-2-maarten.lankhorst@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 21, 2019 at 03:32:12PM +0200, Maarten Lankhorst wrote:
> There was a integer wraparound when mode_clock became too high,
> and we didn't correct for the FEC overhead factor when dividing,
> also the calculations would break at HBR3.

But the mode_clock is obtained from the adusted_mode->crtc_clock which is
defined as an int in drm_mode_config struct, does that need to change also?

> 
> As a result our calculated bpp was way too high, and the link width
> bpp limitation never came into effect.
> 
> Print out the resulting bpp calcululations as a sanity check, just
> in case we ever have to debug it later on again.
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Fixes: d9218c8f6cf4 ("drm/i915/dp: Add helpers for Compressed BPP and Slice Count for DSC")
> Cc: <stable@vger.kernel.org> # v5.0+
> Cc: Manasi Navare <manasi.d.navare@intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_dp.c | 16 +++++++++-------
>  drivers/gpu/drm/i915/display/intel_dp.h |  4 ++--
>  2 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
> index 921ad0a2f7ba..614a25911f07 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp.c
> @@ -4323,10 +4323,10 @@ intel_dp_get_sink_irq_esi(struct intel_dp *intel_dp, u8 *sink_irq_vector)
>  		DP_DPRX_ESI_LEN;
>  }
>  
> -u16 intel_dp_dsc_get_output_bpp(int link_clock, u8 lane_count,
> -				int mode_clock, int mode_hdisplay)
> +u16 intel_dp_dsc_get_output_bpp(u32 link_clock, u8 lane_count,
> +				u32 mode_clock, u32 mode_hdisplay)
>  {
> -	u16 bits_per_pixel, max_bpp_small_joiner_ram;
> +	u32 bits_per_pixel, max_bpp_small_joiner_ram;

But bits_per_pixel is a 16 bit value for DSC PPS, why does this need to be u32?

>  	int i;
>  
>  	/*
> @@ -4335,13 +4335,14 @@ u16 intel_dp_dsc_get_output_bpp(int link_clock, u8 lane_count,
>  	 * FECOverhead = 2.4%, for SST -> TimeSlotsPerMTP is 1,
>  	 * for MST -> TimeSlotsPerMTP has to be calculated
>  	 */
> -	bits_per_pixel = (link_clock * lane_count * 8 *
> -			  DP_DSC_FEC_OVERHEAD_FACTOR) /
> -		mode_clock;
> +	bits_per_pixel = div_u64((u64)link_clock * lane_count * 8 *
> +				 DP_DSC_FEC_OVERHEAD_FACTOR, 1000ULL * mode_clock);

Thanks for catching this, this had the 1000 in the denominator in my original patches :https://patchwork.freedesktop.org/series/47514/#rev3
And  then the nex rev lost it somehow, so thanks for catching this 

Manasi

> +	DRM_DEBUG_KMS("Max link bpp: %u\n", bits_per_pixel);
>  
>  	/* Small Joiner Check: output bpp <= joiner RAM (bits) / Horiz. width */
>  	max_bpp_small_joiner_ram = DP_DSC_MAX_SMALL_JOINER_RAM_BUFFER /
>  		mode_hdisplay;
> +	DRM_DEBUG_KMS("Max small joiner bpp: %u\n", max_bpp_small_joiner_ram);
>  
>  	/*
>  	 * Greatest allowed DSC BPP = MIN (output BPP from avaialble Link BW
> @@ -4351,7 +4352,8 @@ u16 intel_dp_dsc_get_output_bpp(int link_clock, u8 lane_count,
>  
>  	/* Error out if the max bpp is less than smallest allowed valid bpp */
>  	if (bits_per_pixel < valid_dsc_bpp[0]) {
> -		DRM_DEBUG_KMS("Unsupported BPP %d\n", bits_per_pixel);
> +		DRM_DEBUG_KMS("Unsupported BPP %u, min %u\n",
> +			      bits_per_pixel, valid_dsc_bpp[0]);
>  		return 0;
>  	}
>  
> diff --git a/drivers/gpu/drm/i915/display/intel_dp.h b/drivers/gpu/drm/i915/display/intel_dp.h
> index 657bbb1f5ed0..007d1981a33b 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp.h
> +++ b/drivers/gpu/drm/i915/display/intel_dp.h
> @@ -102,8 +102,8 @@ bool intel_dp_source_supports_hbr2(struct intel_dp *intel_dp);
>  bool intel_dp_source_supports_hbr3(struct intel_dp *intel_dp);
>  bool
>  intel_dp_get_link_status(struct intel_dp *intel_dp, u8 *link_status);
> -u16 intel_dp_dsc_get_output_bpp(int link_clock, u8 lane_count,
> -				int mode_clock, int mode_hdisplay);
> +u16 intel_dp_dsc_get_output_bpp(u32 link_clock, u8 lane_count,
> +				u32 mode_clock, u32 mode_hdisplay);
>  u8 intel_dp_dsc_get_slice_count(struct intel_dp *intel_dp, int mode_clock,
>  				int mode_hdisplay);
>  
> -- 
> 2.20.1
> 
