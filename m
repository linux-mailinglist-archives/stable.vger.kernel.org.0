Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539846A6FE2
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 16:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjCAPis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 10:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjCAPip (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 10:38:45 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30922749F
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 07:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677685123; x=1709221123;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=bqBvF88UuAnIyTNFxyVHy8IHR7fDjAkGO3i1PbdF1WQ=;
  b=E8LkpdUPn6ge6srxMfbAncq9/S+jqN2rupB6pbVJ1QM7yYZumm81PrIJ
   NPWL6OIEmsfKI7IwH5rCAkOzni05gn0a/tu2sNkcN4VN1FlrmrPy1BA1t
   xfj8C0aBsVOzVp6UHyR4ybwHEdhP3T8SDISvtAIWAwJIpCf6UsE+fdadU
   aueYogq6XALvi6rOGjfrPuVn1Mas3UH/DbLkNkAm8ERZv3fRHV+7SBtju
   vwLnBJp5bMvY1LGdoUz2vmPIjg/XJ7Hn1ooJWNovM9JyIZjD3lJ0jwICx
   kVFojdg06/54DHDXtxcVBW8k31Aj2nGwFAxmmhrqBF4v+CaTobXmy5Rc6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="331917097"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="331917097"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 07:38:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="674598474"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="674598474"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.70])
  by orsmga002.jf.intel.com with SMTP; 01 Mar 2023 07:38:40 -0800
Received: by stinkbox (sSMTP sendmail emulation); Wed, 01 Mar 2023 17:38:39 +0200
Date:   Wed, 1 Mar 2023 17:38:39 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/dsi: fix DSS CTL register offsets for TGL+
Message-ID: <Y/9xf6SkV1fG4JSA@intel.com>
References: <20230301151409.1581574-1-jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230301151409.1581574-1-jani.nikula@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 05:14:09PM +0200, Jani Nikula wrote:
> On TGL+ the DSS control registers are at different offsets, and there's
> one per pipe. Fix the offsets to fix dual link DSI for TGL+.
> 
> There would be helpers for this in the DSC code, but just do the quick
> fix now for DSI. Long term, we should probably move all the DSS handling
> into intel_vdsc.c, so exporting the helpers seems counter-productive.

I'm not entirely happy with intel_vdsc.c since it handles
both the hardware VDSC block (which includes DSS, and so
also uncompressed joiner and MSO), and also some actual
DSC calculations/etc. Might be nice to have a cleaner
split of some sort.

That also reminds me that MSO+dsc/joiner is probably going
to fail miserably given that neither side knows about the
other and both poke the DSS registers.

> 
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8232
> Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> ---
>  drivers/gpu/drm/i915/display/icl_dsi.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
> index b5316715bb3b..5a17ab3f0d1a 100644
> --- a/drivers/gpu/drm/i915/display/icl_dsi.c
> +++ b/drivers/gpu/drm/i915/display/icl_dsi.c
> @@ -277,9 +277,21 @@ static void configure_dual_link_mode(struct intel_encoder *encoder,
>  {
>  	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
>  	struct intel_dsi *intel_dsi = enc_to_intel_dsi(encoder);
> +	i915_reg_t dss_ctl1_reg, dss_ctl2_reg;
>  	u32 dss_ctl1;
>  
> -	dss_ctl1 = intel_de_read(dev_priv, DSS_CTL1);
> +	/* FIXME: Move all DSS handling to intel_vdsc.c */
> +	if (DISPLAY_VER(dev_priv) >= 12) {
> +		struct intel_crtc *crtc = to_intel_crtc(pipe_config->uapi.crtc);
> +
> +		dss_ctl1_reg = ICL_PIPE_DSS_CTL1(crtc->pipe);
> +		dss_ctl2_reg = ICL_PIPE_DSS_CTL2(crtc->pipe);
> +	} else {
> +		dss_ctl1_reg = DSS_CTL1;
> +		dss_ctl2_reg = DSS_CTL2;
> +	}
> +
> +	dss_ctl1 = intel_de_read(dev_priv, dss_ctl1_reg);

Side note: should get rid of this rmw to make sure the thing
fully configuerd the way we want...

Anyways, this seems fine for now:
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

>  	dss_ctl1 |= SPLITTER_ENABLE;
>  	dss_ctl1 &= ~OVERLAP_PIXELS_MASK;
>  	dss_ctl1 |= OVERLAP_PIXELS(intel_dsi->pixel_overlap);
> @@ -299,14 +311,14 @@ static void configure_dual_link_mode(struct intel_encoder *encoder,
>  
>  		dss_ctl1 &= ~LEFT_DL_BUF_TARGET_DEPTH_MASK;
>  		dss_ctl1 |= LEFT_DL_BUF_TARGET_DEPTH(dl_buffer_depth);
> -		intel_de_rmw(dev_priv, DSS_CTL2, RIGHT_DL_BUF_TARGET_DEPTH_MASK,
> +		intel_de_rmw(dev_priv, dss_ctl2_reg, RIGHT_DL_BUF_TARGET_DEPTH_MASK,
>  			     RIGHT_DL_BUF_TARGET_DEPTH(dl_buffer_depth));
>  	} else {
>  		/* Interleave */
>  		dss_ctl1 |= DUAL_LINK_MODE_INTERLEAVE;
>  	}
>  
> -	intel_de_write(dev_priv, DSS_CTL1, dss_ctl1);
> +	intel_de_write(dev_priv, dss_ctl1_reg, dss_ctl1);
>  }
>  
>  /* aka DSI 8X clock */
> -- 
> 2.39.1

-- 
Ville Syrjälä
Intel
