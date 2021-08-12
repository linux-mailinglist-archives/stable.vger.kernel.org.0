Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E74E3EA837
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 18:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbhHLQFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 12:05:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:55449 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229661AbhHLQFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Aug 2021 12:05:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="237418746"
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="237418746"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 09:01:24 -0700
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="517506148"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 09:01:21 -0700
Date:   Thu, 12 Aug 2021 19:01:18 +0300
From:   Imre Deak <imre.deak@intel.com>
To:     Swati Sharma <swati2.sharma@intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Ville Syrj_l_ <ville.syrjala@linux.intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Jos_ Roberto de Souza <jose.souza@intel.com>,
        Sean Paul <seanpaul@chromium.org>, stable@vger.kernel.org
Subject: Re: [v3][PATCH] drm/i915/display: Drop redundant debug print
Message-ID: <20210812160118.GH2600583@ideak-desk.fi.intel.com>
References: <20210812131107.5531-1-swati2.sharma@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812131107.5531-1-swati2.sharma@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 12, 2021 at 06:41:07PM +0530, Swati Sharma wrote:
> drm_dp_dpcd_read/write already has debug error message.
> Drop redundant error messages which gives false
> status even if correct value is read in drm_dp_dpcd_read().
> 
> v2: -Added fixes tag (Ankit)
> v3: -Fixed build error (CI)
> 
> Fixes: 9488a030ac91 ("drm/i915: Add support for enabling link status and recovery")
> Cc: Swati Sharma <swati2.sharma@intel.com>
> Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
> Cc: Uma Shankar <uma.shankar@intel.com> (v2)
> Cc: Jani Nikula <jani.nikula@intel.com>
> Cc: "Ville Syrj_l_" <ville.syrjala@linux.intel.com>
> Cc: Imre Deak <imre.deak@intel.com>
> Cc: Manasi Navare <manasi.d.navare@intel.com>
> Cc: Uma Shankar <uma.shankar@intel.com>
> Cc: "Jos_ Roberto de Souza" <jose.souza@intel.com>
> Cc: Sean Paul <seanpaul@chromium.org>
> Cc: <stable@vger.kernel.org> # v5.12+
> 
> Link: https://patchwork.freedesktop.org/patch/msgid/20201218103723.30844-12-ankit.k.nautiyal@intel.com
> 
> Signed-off-by: Swati Sharma <swati2.sharma@intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_dp.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
> index c386ef8eb200..2526c9c8c690 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp.c
> @@ -3864,23 +3864,18 @@ static void intel_dp_check_device_service_irq(struct intel_dp *intel_dp)
>  
>  static void intel_dp_check_link_service_irq(struct intel_dp *intel_dp)
>  {
> -	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
>  	u8 val;
>  
>  	if (intel_dp->dpcd[DP_DPCD_REV] < 0x11)
>  		return;
>  
>  	if (drm_dp_dpcd_readb(&intel_dp->aux,
> -			      DP_LINK_SERVICE_IRQ_VECTOR_ESI0, &val) != 1 || !val) {
> -		drm_dbg_kms(&i915->drm, "Error in reading link service irq vector\n");

The only problem seems to be that for !val the debug print is incorrect,
so maybe just have a separate check for that after this one for the read()
and return w/o the debug message?

Is it really a stable material, since the change wouldn't have any
effect for regular users?

> +			      DP_LINK_SERVICE_IRQ_VECTOR_ESI0, &val) != 1 || !val)
>  		return;
> -	}
>  
>  	if (drm_dp_dpcd_writeb(&intel_dp->aux,
> -			       DP_LINK_SERVICE_IRQ_VECTOR_ESI0, val) != 1) {
> -		drm_dbg_kms(&i915->drm, "Error in writing link service irq vector\n");
> +			       DP_LINK_SERVICE_IRQ_VECTOR_ESI0, val) != 1)
>  		return;
> -	}
>  
>  	if (val & HDMI_LINK_STATUS_CHANGED)
>  		intel_dp_handle_hdmi_link_status_change(intel_dp);
> -- 
> 2.25.1
> 
