Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A926DE1B24
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 14:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390079AbfJWMqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 08:46:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:60015 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403914AbfJWMqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Oct 2019 08:46:19 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 05:46:18 -0700
X-IronPort-AV: E=Sophos;i="5.68,220,1569308400"; 
   d="scan'208";a="191819544"
Received: from ideak-desk.fi.intel.com ([10.237.68.142])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 05:46:17 -0700
Date:   Wed, 23 Oct 2019 15:44:50 +0300
From:   Imre Deak <imre.deak@intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, Andrija <akijo97@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Fix PCH reference clock for FDI on
 HSW/BDW
Message-ID: <20191023124450.GA11288@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20191022185643.1483-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191022185643.1483-1-ville.syrjala@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 22, 2019 at 09:56:43PM +0300, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> The change to skip the PCH reference initialization during fastboot
> did end up breaking FDI. To fix that let's try to do the PCH reference
> init whenever we're disabling a DPLL that was using said reference
> previously.
> 
> Cc: stable@vger.kernel.org
> Tested-by: Andrija <akijo97@gmail.com>
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=112084
> Fixes: b16c7ed95caf ("drm/i915: Do not touch the PCH SSC reference if a PLL is using it")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

Reviewed-by: Imre Deak <imre.deak@intel.com>

> ---
>  drivers/gpu/drm/i915/display/intel_display.c  | 11 ++++++-----
>  drivers/gpu/drm/i915/display/intel_dpll_mgr.c | 15 +++++++++++++++
>  drivers/gpu/drm/i915/i915_drv.h               |  2 ++
>  3 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
> index 236fdf122e47..da76f794a965 100644
> --- a/drivers/gpu/drm/i915/display/intel_display.c
> +++ b/drivers/gpu/drm/i915/display/intel_display.c
> @@ -9359,7 +9359,6 @@ static bool wrpll_uses_pch_ssc(struct drm_i915_private *dev_priv,
>  static void lpt_init_pch_refclk(struct drm_i915_private *dev_priv)
>  {
>  	struct intel_encoder *encoder;
> -	bool pch_ssc_in_use = false;
>  	bool has_fdi = false;
>  
>  	for_each_intel_encoder(&dev_priv->drm, encoder) {
> @@ -9387,22 +9386,24 @@ static void lpt_init_pch_refclk(struct drm_i915_private *dev_priv)
>  	 * clock hierarchy. That would also allow us to do
>  	 * clock bending finally.
>  	 */
> +	dev_priv->pch_ssc_use = 0;
> +
>  	if (spll_uses_pch_ssc(dev_priv)) {
>  		DRM_DEBUG_KMS("SPLL using PCH SSC\n");
> -		pch_ssc_in_use = true;
> +		dev_priv->pch_ssc_use |= BIT(DPLL_ID_SPLL);
>  	}
>  
>  	if (wrpll_uses_pch_ssc(dev_priv, DPLL_ID_WRPLL1)) {
>  		DRM_DEBUG_KMS("WRPLL1 using PCH SSC\n");
> -		pch_ssc_in_use = true;
> +		dev_priv->pch_ssc_use |= BIT(DPLL_ID_WRPLL1);
>  	}
>  
>  	if (wrpll_uses_pch_ssc(dev_priv, DPLL_ID_WRPLL2)) {
>  		DRM_DEBUG_KMS("WRPLL2 using PCH SSC\n");
> -		pch_ssc_in_use = true;
> +		dev_priv->pch_ssc_use |= BIT(DPLL_ID_WRPLL2);
>  	}
>  
> -	if (pch_ssc_in_use)
> +	if (dev_priv->pch_ssc_use)
>  		return;
>  
>  	if (has_fdi) {
> diff --git a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
> index ec10fa7d3c69..3ce0a023eee0 100644
> --- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
> +++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
> @@ -526,16 +526,31 @@ static void hsw_ddi_wrpll_disable(struct drm_i915_private *dev_priv,
>  	val = I915_READ(WRPLL_CTL(id));
>  	I915_WRITE(WRPLL_CTL(id), val & ~WRPLL_PLL_ENABLE);
>  	POSTING_READ(WRPLL_CTL(id));
> +
> +	/*
> +	 * Try to set up the PCH reference clock once all DPLLs
> +	 * that depend on it have been shut down.
> +	 */
> +	if (dev_priv->pch_ssc_use & BIT(id))
> +		intel_init_pch_refclk(dev_priv);
>  }
>  
>  static void hsw_ddi_spll_disable(struct drm_i915_private *dev_priv,
>  				 struct intel_shared_dpll *pll)
>  {
> +	enum intel_dpll_id id = pll->info->id;
>  	u32 val;
>  
>  	val = I915_READ(SPLL_CTL);
>  	I915_WRITE(SPLL_CTL, val & ~SPLL_PLL_ENABLE);
>  	POSTING_READ(SPLL_CTL);
> +
> +	/*
> +	 * Try to set up the PCH reference clock once all DPLLs
> +	 * that depend on it have been shut down.
> +	 */
> +	if (dev_priv->pch_ssc_use & BIT(id))
> +		intel_init_pch_refclk(dev_priv);
>  }
>  
>  static bool hsw_ddi_wrpll_get_hw_state(struct drm_i915_private *dev_priv,
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index 8882c0908c3b..5332825e0ce4 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -1348,6 +1348,8 @@ struct drm_i915_private {
>  		} contexts;
>  	} gem;
>  
> +	u8 pch_ssc_use;
> +
>  	/* For i915gm/i945gm vblank irq workaround */
>  	u8 vblank_enabled;
>  
> -- 
> 2.21.0
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
