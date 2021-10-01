Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CC241F733
	for <lists+stable@lfdr.de>; Sat,  2 Oct 2021 00:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355835AbhJAWDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 18:03:30 -0400
Received: from mga04.intel.com ([192.55.52.120]:49259 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355808AbhJAWD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 18:03:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="223694646"
X-IronPort-AV: E=Sophos;i="5.85,340,1624345200"; 
   d="scan'208";a="223694646"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 15:01:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,340,1624345200"; 
   d="scan'208";a="521387924"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by fmsmga008.fm.intel.com with SMTP; 01 Oct 2021 15:01:32 -0700
Received: by stinkbox (sSMTP sendmail emulation); Sat, 02 Oct 2021 01:01:31 +0300
Date:   Sat, 2 Oct 2021 01:01:31 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Matt Roper <matthew.d.roper@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Karthik B S <karthik.b.s@intel.com>
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915: Extend the async flip VT-d w/a
 to skl/bxt
Message-ID: <YVeFOzabpcWAbVFQ@intel.com>
References: <20210930190943.17547-1-ville.syrjala@linux.intel.com>
 <20211001210815.GG3389343@mdroper-desk1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211001210815.GG3389343@mdroper-desk1.amr.corp.intel.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 01, 2021 at 02:08:15PM -0700, Matt Roper wrote:
> On Thu, Sep 30, 2021 at 10:09:42PM +0300, Ville Syrjala wrote:
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > 
> > Looks like skl/bxt/derivatives also need the plane stride
> > stretch w/a when using async flips and VT-d is enabled, or
> > else we get corruption on screen. To my surprise this was
> > even documented in bspec, but only as a note on the
> > CHICHKEN_PIPESL register description rather than on the
> > w/a list.
> > 
> > So very much the same thing as on HSW/BDW, except the bits
> > moved yet again.
> 
> Bspec 7522 doesn't say anything about this requirement being tied to
> VT-d on these platforms.  Should we drop the intel_vtd_active()
> condition to be safe?

I think it's just an oversight in bspec. I read through the hsd and
IIRC it did specify that it's VT-d only. Also real life confirms
it. No problems whatsoever when VT-d is disabled.

> 
> 
> Matt
> 
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Karthik B S <karthik.b.s@intel.com>
> > Fixes: 55ea1cb178ef ("drm/i915: Enable async flips in i915")
> > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > ---
> >  drivers/gpu/drm/i915/i915_reg.h |  5 +++++
> >  drivers/gpu/drm/i915/intel_pm.c | 12 ++++++++++++
> >  2 files changed, 17 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
> > index 3a20a55d2512..29f6bfc2002d 100644
> > --- a/drivers/gpu/drm/i915/i915_reg.h
> > +++ b/drivers/gpu/drm/i915/i915_reg.h
> > @@ -8222,6 +8222,11 @@ enum {
> >  #define  HSW_SPR_STRETCH_MAX_X1		REG_FIELD_PREP(HSW_SPR_STRETCH_MAX_MASK, 3)
> >  #define  HSW_FBCQ_DIS			(1 << 22)
> >  #define  BDW_DPRS_MASK_VBLANK_SRD	(1 << 0)
> > +#define  SKL_PLANE1_STRETCH_MAX_MASK	REG_GENMASK(1, 0)
> > +#define  SKL_PLANE1_STRETCH_MAX_X8	REG_FIELD_PREP(SKL_PLANE1_STRETCH_MAX_MASK, 0)
> > +#define  SKL_PLANE1_STRETCH_MAX_X4	REG_FIELD_PREP(SKL_PLANE1_STRETCH_MAX_MASK, 1)
> > +#define  SKL_PLANE1_STRETCH_MAX_X2	REG_FIELD_PREP(SKL_PLANE1_STRETCH_MAX_MASK, 2)
> > +#define  SKL_PLANE1_STRETCH_MAX_X1	REG_FIELD_PREP(SKL_PLANE1_STRETCH_MAX_MASK, 3)
> >  #define CHICKEN_PIPESL_1(pipe) _MMIO_PIPE(pipe, _CHICKEN_PIPESL_1_A, _CHICKEN_PIPESL_1_B)
> >  
> >  #define _CHICKEN_TRANS_A	0x420c0
> > diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
> > index ef5f73934dab..74d4620a4999 100644
> > --- a/drivers/gpu/drm/i915/intel_pm.c
> > +++ b/drivers/gpu/drm/i915/intel_pm.c
> > @@ -76,6 +76,8 @@ struct intel_wm_config {
> >  
> >  static void gen9_init_clock_gating(struct drm_i915_private *dev_priv)
> >  {
> > +	enum pipe pipe;
> > +
> >  	if (HAS_LLC(dev_priv)) {
> >  		/*
> >  		 * WaCompressedResourceDisplayNewHashMode:skl,kbl
> > @@ -89,6 +91,16 @@ static void gen9_init_clock_gating(struct drm_i915_private *dev_priv)
> >  			   SKL_DE_COMPRESSED_HASH_MODE);
> >  	}
> >  
> > +	for_each_pipe(dev_priv, pipe) {
> > +		/*
> > +		 * "Plane N strech max must be programmed to 11b (x1)
> > +		 *  when Async flips are enabled on that plane."
> > +		 */
> > +		if (!IS_GEMINILAKE(dev_priv) && intel_vtd_active())
> > +			intel_uncore_rmw(&dev_priv->uncore, CHICKEN_PIPESL_1(pipe),
> > +					 SKL_PLANE1_STRETCH_MAX_MASK, SKL_PLANE1_STRETCH_MAX_X1);
> > +	}
> > +
> >  	/* See Bspec note for PSR2_CTL bit 31, Wa#828:skl,bxt,kbl,cfl */
> >  	intel_uncore_write(&dev_priv->uncore, CHICKEN_PAR1_1,
> >  		   intel_uncore_read(&dev_priv->uncore, CHICKEN_PAR1_1) | SKL_EDP_PSR_FIX_RDWRAP);
> > -- 
> > 2.32.0
> > 
> 
> -- 
> Matt Roper
> Graphics Software Engineer
> VTT-OSGC Platform Enablement
> Intel Corporation
> (916) 356-2795

-- 
Ville Syrjälä
Intel
