Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB84A4D3B2D
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 21:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbiCIUhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 15:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbiCIUhA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 15:37:00 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D84248
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 12:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646858161; x=1678394161;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=FK9NNmoAGFTq2ihAR1KujEBks0jqcCloQFKN1uVBomo=;
  b=Cf2ct4fZHNhtnySaFwFfhPW2PAyOzreKSAE0b5y6bHc9igEf0lWjq4J4
   U5fq78cIbXSkOKm7GrQL/7PiyffY+xr1tGnJaAQPweKxn0KlKjwsGv0XR
   K1vmVyrIK+DcpDHvg5GwLOr8NqoybSWZREHrpTWiUao22o3/roa94ggI1
   lOZX6/HWNmjnnPpemylLnnmhjq7IEnqvzaa2oa9hrw4Lg/bRcJy6B9j1N
   dNE0iUTKv9AS91Oe20ktJdeH/VGEm5Uedwo9XBlP3jo3ZzsfwExxjaRK/
   voi/SG83FPtC3KD2K6yTjfrDi5eXU6d8mh2cNd4pAdS/LHm2aHGaNSBVw
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="235038229"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="235038229"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 12:35:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="547768557"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by fmsmga007.fm.intel.com with SMTP; 09 Mar 2022 12:35:50 -0800
Received: by stinkbox (sSMTP sendmail emulation); Wed, 09 Mar 2022 22:35:49 +0200
Date:   Wed, 9 Mar 2022 22:35:49 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH v2 1/8] drm/i915: Treat SAGV block time 0 as
 SAGV disabled
Message-ID: <YikPpRpbmphJuenr@intel.com>
References: <20220309164948.10671-1-ville.syrjala@linux.intel.com>
 <20220309164948.10671-2-ville.syrjala@linux.intel.com>
 <20220309192958.GA9517@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220309192958.GA9517@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 09, 2022 at 09:29:58PM +0200, Lisovskiy, Stanislav wrote:
> On Wed, Mar 09, 2022 at 06:49:41PM +0200, Ville Syrjala wrote:
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > 
> > For modern platforms the spec explicitly states that a
> > SAGV block time of zero means that SAGV is not supported.
> > Let's extend that to all platforms. Supposedly there should
> > be no systems where this isn't true, and it'll allow us to:
> > - use the same code regardless of older vs. newer platform
> > - wm latencies already treat 0 as disabled, so this fits well
> >   with other related code
> > - make it a bit more clear when SAGV is used vs. not
> > - avoid overflows from adding U32_MAX with a u16 wm0 latency value
> >   which could cause us to miscalculate the SAGV watermarks on tgl+
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > ---
> >  drivers/gpu/drm/i915/intel_pm.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
> > index 8ee31c9590a7..40a3094e55ca 100644
> > --- a/drivers/gpu/drm/i915/intel_pm.c
> > +++ b/drivers/gpu/drm/i915/intel_pm.c
> > @@ -3696,8 +3696,7 @@ skl_setup_sagv_block_time(struct drm_i915_private *dev_priv)
> >  		MISSING_CASE(DISPLAY_VER(dev_priv));
> >  	}
> >  
> > -	/* Default to an unusable block time */
> > -	dev_priv->sagv_block_time_us = -1;
> > +	dev_priv->sagv_block_time_us = 0;
> >  }
> >  
> >  /*
> > @@ -5644,7 +5643,7 @@ static void skl_compute_plane_wm(const struct intel_crtc_state *crtc_state,
> >  	result->min_ddb_alloc = max(min_ddb_alloc, blocks) + 1;
> >  	result->enable = true;
> >  
> > -	if (DISPLAY_VER(dev_priv) < 12)
> > +	if (DISPLAY_VER(dev_priv) < 12 && dev_priv->sagv_block_time_us)
> >  		result->can_sagv = latency >= dev_priv->sagv_block_time_us;
> >  }
> >  
> > @@ -5677,7 +5676,10 @@ static void tgl_compute_sagv_wm(const struct intel_crtc_state *crtc_state,
> >  	struct drm_i915_private *dev_priv = to_i915(crtc_state->uapi.crtc->dev);
> >  	struct skl_wm_level *sagv_wm = &plane_wm->sagv.wm0;
> >  	struct skl_wm_level *levels = plane_wm->wm;
> > -	unsigned int latency = dev_priv->wm.skl_latency[0] + dev_priv->sagv_block_time_us;
> > +	unsigned int latency = 0;
> > +
> > +	if (dev_priv->sagv_block_time_us)
> > +		latency = dev_priv->sagv_block_time_us + dev_priv->wm.skl_latency[0];
> 
> Should we may be add this to intel_has_sagv? I thought this was supposed to tell,
> if SAGV is supported or not. Should we just call it hear as well, may be..
> Now we kinda making it less obvious. 

We already use intel_has_sagv() to see if we should zero out the
block time. I don't think I want to make it a full circle.

> 
> Stan
> 
> >  
> >  	skl_compute_plane_wm(crtc_state, plane, 0, latency,
> >  			     wm_params, &levels[0],
> > -- 
> > 2.34.1
> > 

-- 
Ville Syrjälä
Intel
