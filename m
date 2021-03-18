Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71992340C4D
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 18:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbhCRR5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 13:57:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:61653 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232474AbhCRR50 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 13:57:26 -0400
IronPort-SDR: Y+xFBhZddSmGI0iBhI9KKUvWFQsge+1UNKJv/mTixw+3ZBwdO2lI/HWLB1lbef382POP3XKbC8
 jTjNtTKBMFLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="177332039"
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="177332039"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 10:57:25 -0700
IronPort-SDR: 0eIFfhRZh7RlG1GaHFlFO08q5HUeeloK0+GkyQ9d8bSBm9nwe75rBo06S0ohxLQLbkqxrL8ZrT
 zI0zE4E/8g7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="512210990"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by fmsmga001.fm.intel.com with SMTP; 18 Mar 2021 10:57:23 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 18 Mar 2021 19:57:22 +0200
Date:   Thu, 18 Mar 2021 19:57:22 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Imre Deak <imre.deak@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/3] drm/i915: Disable LTTPR support when the DPCD rev
 < 1.4
Message-ID: <YFOUgp1QvipUwSGR@intel.com>
References: <20210317184901.4029798-3-imre.deak@intel.com>
 <20210317190149.4032966-1-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210317190149.4032966-1-imre.deak@intel.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 17, 2021 at 09:01:49PM +0200, Imre Deak wrote:
> By the specification the 0xF0000-0xF02FF range is only valid when the
> DPCD revision is 1.4 or higher. Disable LTTPR support if this isn't so.
> 
> Trying to detect LTTPRs returned corrupted values for the above DPCD
> range at least on a Skylake host with an LG 43UD79-B monitor with a DPCD
> revision 1.2 connected.
> 
> v2: Add the actual version check.
> 
> Fixes: 7b2a4ab8b0ef ("drm/i915: Switch to LTTPR transparent mode link training")
> Cc: <stable@vger.kernel.org> # v5.11
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_dp.c       |  4 +-
>  .../drm/i915/display/intel_dp_link_training.c | 48 ++++++++++++++-----
>  .../drm/i915/display/intel_dp_link_training.h |  2 +-
>  3 files changed, 39 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
> index b6b5776f5a66..873684da0cd4 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp.c
> @@ -3711,9 +3711,7 @@ intel_dp_get_dpcd(struct intel_dp *intel_dp)
>  {
>  	int ret;
>  
> -	intel_dp_lttpr_init(intel_dp);
> -
> -	if (drm_dp_read_dpcd_caps(&intel_dp->aux, intel_dp->dpcd))
> +	if (intel_dp_init_lttpr_and_dprx_caps(intel_dp) < 0)
>  		return false;
>  
>  	/*
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> index c0e25c75c105..5a821d644e9c 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> @@ -35,6 +35,11 @@ intel_dp_dump_link_status(struct drm_device *drm,
>  		    link_status[3], link_status[4], link_status[5]);
>  }
>  
> +static void intel_dp_reset_lttpr_common_caps(struct intel_dp *intel_dp)
> +{
> +	memset(&intel_dp->lttpr_common_caps, 0, sizeof(intel_dp->lttpr_common_caps));
> +}
> +
>  static void intel_dp_reset_lttpr_count(struct intel_dp *intel_dp)
>  {
>  	intel_dp->lttpr_common_caps[DP_PHY_REPEATER_CNT -
> @@ -96,8 +101,7 @@ static bool intel_dp_read_lttpr_common_caps(struct intel_dp *intel_dp)
>  
>  	if (drm_dp_read_lttpr_common_caps(&intel_dp->aux,
>  					  intel_dp->lttpr_common_caps) < 0) {
> -		memset(intel_dp->lttpr_common_caps, 0,
> -		       sizeof(intel_dp->lttpr_common_caps));
> +		intel_dp_reset_lttpr_common_caps(intel_dp);
>  		return false;
>  	}
>  
> @@ -119,30 +123,49 @@ intel_dp_set_lttpr_transparent_mode(struct intel_dp *intel_dp, bool enable)
>  }
>  
>  /**
> - * intel_dp_lttpr_init - detect LTTPRs and init the LTTPR link training mode
> + * intel_dp_init_lttpr_and_dprx_caps - detect LTTPR and DPRX caps, init the LTTPR link training mode
>   * @intel_dp: Intel DP struct
>   *
> - * Read the LTTPR common capabilities, switch to non-transparent link training
> - * mode if any is detected and read the PHY capabilities for all detected
> - * LTTPRs. In case of an LTTPR detection error or if the number of
> + * Read the LTTPR common and DPRX capabilities and switch to non-transparent
> + * link training mode if any is detected and read the PHY capabilities for all
> + * detected LTTPRs. In case of an LTTPR detection error or if the number of
>   * LTTPRs is more than is supported (8), fall back to the no-LTTPR,
>   * transparent mode link training mode.
>   *
>   * Returns:
> - *   >0  if LTTPRs were detected and the non-transparent LT mode was set
> + *   >0  if LTTPRs were detected and the non-transparent LT mode was set. The
> + *       DPRX capabilities are read out.
>   *    0  if no LTTPRs or more than 8 LTTPRs were detected or in case of a
> - *       detection failure and the transparent LT mode was set
> + *       detection failure and the transparent LT mode was set. The DPRX
> + *       capabilities are read out.
> + *   <0  Reading out the DPRX capabilities failed.
>   */
> -int intel_dp_lttpr_init(struct intel_dp *intel_dp)
> +int intel_dp_init_lttpr_and_dprx_caps(struct intel_dp *intel_dp)
>  {
>  	int lttpr_count;
>  	bool ret;
>  	int i;
>  
>  	ret = intel_dp_read_lttpr_common_caps(intel_dp);
> +
> +	/* The DPTX shall read the DRPX caps after LTTPR detection. */
> +	if (drm_dp_read_dpcd_caps(&intel_dp->aux, intel_dp->dpcd)) {
> +		intel_dp_reset_lttpr_common_caps(intel_dp);
> +		return -EIO;
> +	}
> +
>  	if (!ret)
>  		return 0;
>  
> +	/*
> +	 * The 0xF0000-0xF02FF range is only valid if the DPCD revision is
> +	 * at least 1.4.
> +	 */
> +	if (intel_dp->dpcd[DP_DPCD_REV] < 0x14) {
> +		intel_dp_reset_lttpr_common_caps(intel_dp);
> +		return 0;
> +	}

Slight chicken vs. egg I guess. Seems ok

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

> +
>  	lttpr_count = drm_dp_lttpr_count(intel_dp->lttpr_common_caps);
>  	/*
>  	 * Prevent setting LTTPR transparent mode explicitly if no LTTPRs are
> @@ -182,7 +205,7 @@ int intel_dp_lttpr_init(struct intel_dp *intel_dp)
>  
>  	return lttpr_count;
>  }
> -EXPORT_SYMBOL(intel_dp_lttpr_init);
> +EXPORT_SYMBOL(intel_dp_init_lttpr_and_dprx_caps);
>  
>  static u8 dp_voltage_max(u8 preemph)
>  {
> @@ -817,7 +840,10 @@ void intel_dp_start_link_train(struct intel_dp *intel_dp,
>  	 * TODO: Reiniting LTTPRs here won't be needed once proper connector
>  	 * HW state readout is added.
>  	 */
> -	int lttpr_count = intel_dp_lttpr_init(intel_dp);
> +	int lttpr_count = intel_dp_init_lttpr_and_dprx_caps(intel_dp);
> +
> +	if (lttpr_count < 0)
> +		return;
>  
>  	if (!intel_dp_link_train_all_phys(intel_dp, crtc_state, lttpr_count))
>  		intel_dp_schedule_fallback_link_training(intel_dp, crtc_state);
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.h b/drivers/gpu/drm/i915/display/intel_dp_link_training.h
> index 6a1f76bd8c75..9cb7c28027f0 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_link_training.h
> +++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.h
> @@ -11,7 +11,7 @@
>  struct intel_crtc_state;
>  struct intel_dp;
>  
> -int intel_dp_lttpr_init(struct intel_dp *intel_dp);
> +int intel_dp_init_lttpr_and_dprx_caps(struct intel_dp *intel_dp);
>  
>  void intel_dp_get_adjust_train(struct intel_dp *intel_dp,
>  			       const struct intel_crtc_state *crtc_state,
> -- 
> 2.25.1

-- 
Ville Syrjälä
Intel
