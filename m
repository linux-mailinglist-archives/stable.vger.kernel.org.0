Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEB1E5236
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 19:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409406AbfJYRYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 13:24:33 -0400
Received: from mga03.intel.com ([134.134.136.65]:36600 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388862AbfJYRYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 13:24:33 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 10:24:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,229,1569308400"; 
   d="scan'208";a="228974992"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga002.fm.intel.com with SMTP; 25 Oct 2019 10:24:29 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 25 Oct 2019 20:24:29 +0300
Date:   Fri, 25 Oct 2019 20:24:29 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Imre Deak <imre.deak@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, Andrija <akijo97@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Fix PCH reference clock for FDI on
 HSW/BDW
Message-ID: <20191025172429.GH1208@intel.com>
References: <20191022185643.1483-1-ville.syrjala@linux.intel.com>
 <20191023124450.GA11288@ideak-desk.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191023124450.GA11288@ideak-desk.fi.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 23, 2019 at 03:44:50PM +0300, Imre Deak wrote:
> On Tue, Oct 22, 2019 at 09:56:43PM +0300, Ville Syrjala wrote:
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > 
> > The change to skip the PCH reference initialization during fastboot
> > did end up breaking FDI. To fix that let's try to do the PCH reference
> > init whenever we're disabling a DPLL that was using said reference
> > previously.
> > 
> > Cc: stable@vger.kernel.org
> > Tested-by: Andrija <akijo97@gmail.com>
> > Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=112084
> > Fixes: b16c7ed95caf ("drm/i915: Do not touch the PCH SSC reference if a PLL is using it")
> > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> Reviewed-by: Imre Deak <imre.deak@intel.com>

CI had some bsd fails which are not relevant, so pushed to dinq.
Thanks for the review.

> 
> > ---
> >  drivers/gpu/drm/i915/display/intel_display.c  | 11 ++++++-----
> >  drivers/gpu/drm/i915/display/intel_dpll_mgr.c | 15 +++++++++++++++
> >  drivers/gpu/drm/i915/i915_drv.h               |  2 ++
> >  3 files changed, 23 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
> > index 236fdf122e47..da76f794a965 100644
> > --- a/drivers/gpu/drm/i915/display/intel_display.c
> > +++ b/drivers/gpu/drm/i915/display/intel_display.c
> > @@ -9359,7 +9359,6 @@ static bool wrpll_uses_pch_ssc(struct drm_i915_private *dev_priv,
> >  static void lpt_init_pch_refclk(struct drm_i915_private *dev_priv)
> >  {
> >  	struct intel_encoder *encoder;
> > -	bool pch_ssc_in_use = false;
> >  	bool has_fdi = false;
> >  
> >  	for_each_intel_encoder(&dev_priv->drm, encoder) {
> > @@ -9387,22 +9386,24 @@ static void lpt_init_pch_refclk(struct drm_i915_private *dev_priv)
> >  	 * clock hierarchy. That would also allow us to do
> >  	 * clock bending finally.
> >  	 */
> > +	dev_priv->pch_ssc_use = 0;
> > +
> >  	if (spll_uses_pch_ssc(dev_priv)) {
> >  		DRM_DEBUG_KMS("SPLL using PCH SSC\n");
> > -		pch_ssc_in_use = true;
> > +		dev_priv->pch_ssc_use |= BIT(DPLL_ID_SPLL);
> >  	}
> >  
> >  	if (wrpll_uses_pch_ssc(dev_priv, DPLL_ID_WRPLL1)) {
> >  		DRM_DEBUG_KMS("WRPLL1 using PCH SSC\n");
> > -		pch_ssc_in_use = true;
> > +		dev_priv->pch_ssc_use |= BIT(DPLL_ID_WRPLL1);
> >  	}
> >  
> >  	if (wrpll_uses_pch_ssc(dev_priv, DPLL_ID_WRPLL2)) {
> >  		DRM_DEBUG_KMS("WRPLL2 using PCH SSC\n");
> > -		pch_ssc_in_use = true;
> > +		dev_priv->pch_ssc_use |= BIT(DPLL_ID_WRPLL2);
> >  	}
> >  
> > -	if (pch_ssc_in_use)
> > +	if (dev_priv->pch_ssc_use)
> >  		return;
> >  
> >  	if (has_fdi) {
> > diff --git a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
> > index ec10fa7d3c69..3ce0a023eee0 100644
> > --- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
> > +++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
> > @@ -526,16 +526,31 @@ static void hsw_ddi_wrpll_disable(struct drm_i915_private *dev_priv,
> >  	val = I915_READ(WRPLL_CTL(id));
> >  	I915_WRITE(WRPLL_CTL(id), val & ~WRPLL_PLL_ENABLE);
> >  	POSTING_READ(WRPLL_CTL(id));
> > +
> > +	/*
> > +	 * Try to set up the PCH reference clock once all DPLLs
> > +	 * that depend on it have been shut down.
> > +	 */
> > +	if (dev_priv->pch_ssc_use & BIT(id))
> > +		intel_init_pch_refclk(dev_priv);
> >  }
> >  
> >  static void hsw_ddi_spll_disable(struct drm_i915_private *dev_priv,
> >  				 struct intel_shared_dpll *pll)
> >  {
> > +	enum intel_dpll_id id = pll->info->id;
> >  	u32 val;
> >  
> >  	val = I915_READ(SPLL_CTL);
> >  	I915_WRITE(SPLL_CTL, val & ~SPLL_PLL_ENABLE);
> >  	POSTING_READ(SPLL_CTL);
> > +
> > +	/*
> > +	 * Try to set up the PCH reference clock once all DPLLs
> > +	 * that depend on it have been shut down.
> > +	 */
> > +	if (dev_priv->pch_ssc_use & BIT(id))
> > +		intel_init_pch_refclk(dev_priv);
> >  }
> >  
> >  static bool hsw_ddi_wrpll_get_hw_state(struct drm_i915_private *dev_priv,
> > diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> > index 8882c0908c3b..5332825e0ce4 100644
> > --- a/drivers/gpu/drm/i915/i915_drv.h
> > +++ b/drivers/gpu/drm/i915/i915_drv.h
> > @@ -1348,6 +1348,8 @@ struct drm_i915_private {
> >  		} contexts;
> >  	} gem;
> >  
> > +	u8 pch_ssc_use;
> > +
> >  	/* For i915gm/i945gm vblank irq workaround */
> >  	u8 vblank_enabled;
> >  
> > -- 
> > 2.21.0
> > 
> > _______________________________________________
> > Intel-gfx mailing list
> > Intel-gfx@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Ville Syrjälä
Intel
