Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D952E33F434
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 16:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhCQPsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 11:48:43 -0400
Received: from mga05.intel.com ([192.55.52.43]:8509 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232465AbhCQPsK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 11:48:10 -0400
IronPort-SDR: YqFO1vC9Np2HU3cm62mjkCvi0KaTI4i8w4HKN7N5TZKyiEEl1RqihAXVD4ItQxbq9SneULrmtP
 jBWhuI3v4K9A==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="274528619"
X-IronPort-AV: E=Sophos;i="5.81,256,1610438400"; 
   d="scan'208";a="274528619"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 08:03:33 -0700
IronPort-SDR: 2A9SGhZzgnaR1J6UUaV7TUlw0gXksDQ79T6G2COwq5CYLXkSg/5VDvrTxRorfzDi7yfgJAHCUq
 JDeSdiaEw3Zw==
X-IronPort-AV: E=Sophos;i="5.81,256,1610438400"; 
   d="scan'208";a="605743643"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 08:03:31 -0700
Date:   Wed, 17 Mar 2021 17:03:27 +0200
From:   Imre Deak <imre.deak@intel.com>
To:     Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, Takashi Iwai <tiwai@suse.de>,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/ilk-glk: Fix link training on links
 with LTTPRs
Message-ID: <20210317150327.GG3823928@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20210316165426.3388513-1-imre.deak@intel.com>
 <YFIMz62Zkq9ewP4m@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YFIMz62Zkq9ewP4m@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 17, 2021 at 04:06:07PM +0200, Ville Syrjälä wrote:
> On Tue, Mar 16, 2021 at 06:54:26PM +0200, Imre Deak wrote:
> > The spec requires to use at least 3.2ms for the AUX timeout period if
> > there are LT-tunable PHY Repeaters on the link (2.11.2). An upcoming
> > spec update makes this more specific, by requiring a 3.2ms minimum
> > timeout period for the LTTPR detection reading the 0xF0000-0xF0007
> > range (3.6.5.1).
> > 
> > Accordingly disable LTTPR detection until GLK, where the maximum timeout
> > we can set is only 1.6ms.
> > 
> > Link training in the non-transparent mode is known to fail at least on
> > some SKL systems with a WD19 dock on the link, which exposes an LTTPR
> > (see the References below). While this could have different reasons
> > besides the too short AUX timeout used, not detecting LTTPRs (and so not
> > using the non-transparent LT mode) fixes link training on these systems.
> > 
> > While at it add a code comment about the platform specific maximum
> > timeout values.
> > 
> > Reported-by: Takashi Iwai <tiwai@suse.de>
> > References: https://gitlab.freedesktop.org/drm/intel/-/issues/3166
> > Fixes: b30edfd8d0b4 ("drm/i915: Switch to LTTPR non-transparent mode link training")
> > Cc: <stable@vger.kernel.org> # v5.11
> > Cc: Takashi Iwai <tiwai@suse.de>
> > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > ---
> >  drivers/gpu/drm/i915/display/intel_dp_aux.c           | 7 +++++++
> >  drivers/gpu/drm/i915/display/intel_dp_link_training.c | 8 ++++++++
> >  2 files changed, 15 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux.c b/drivers/gpu/drm/i915/display/intel_dp_aux.c
> > index eaebf123310a..b581e8acce07 100644
> > --- a/drivers/gpu/drm/i915/display/intel_dp_aux.c
> > +++ b/drivers/gpu/drm/i915/display/intel_dp_aux.c
> > @@ -133,6 +133,7 @@ static u32 g4x_get_aux_send_ctl(struct intel_dp *intel_dp,
> >  	else
> >  		precharge = 5;
> >  
> > +	/* Max timeout value on ILK-BDW: 1.6ms */
> 
> also g4x

Ok, will add it.

> 
> >  	if (IS_BROADWELL(dev_priv))
> >  		timeout = DP_AUX_CH_CTL_TIME_OUT_600us;
> >  	else
> > @@ -159,6 +160,12 @@ static u32 skl_get_aux_send_ctl(struct intel_dp *intel_dp,
> >  	enum phy phy = intel_port_to_phy(i915, dig_port->base.port);
> >  	u32 ret;
> >  
> > +	/*
> > +	 * Max timeout values:
> > +	 * SKL-GLK: 1.6ms
> > +	 * CNL: 3.2ms
> > +	 * ICL+: 4ms
> > +	 */
> >  	ret = DP_AUX_CH_CTL_SEND_BUSY |
> >  	      DP_AUX_CH_CTL_DONE |
> >  	      DP_AUX_CH_CTL_INTERRUPT |
> > diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> > index 19ba7c7cbaab..de6d70a29b47 100644
> > --- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> > +++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> > @@ -123,10 +123,18 @@ intel_dp_set_lttpr_transparent_mode(struct intel_dp *intel_dp, bool enable)
> >   */
> >  int intel_dp_lttpr_init(struct intel_dp *intel_dp)
> >  {
> > +	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
> >  	int lttpr_count;
> >  	bool ret;
> >  	int i;
> >  
> > +	/*
> > +	 * Detecting LTTPRs must be avoided on platforms with an AUX timeout
> > +	 * period < 3.2ms. (see DP Standard v2.0, 2.11.2, 3.6.6.1).
> > +	 */
> > +	if (INTEL_GEN(i915) < 10)
> > +		return 0;
> 
> I don't understand how detecting the LTTPR affects this? The LTTPRs will
> still snoop stuff and do their hidden magic even if we don't know
> they're there. How does leaving them in transparent mode speed up
> whatever they do?

After an LTTPR detection, the DPTX reading the 0xF0000-0xF0007 range,
LTTPRs will be either in transparent or non-transparent mode. In these
modes the spec requires the LTTPRs not to send DEFERs and use a 3.2ms
timeout scheme. I'm not sure about the exact details for the rational on
this (afaiu it's to avoid a retransmission loop or corruption of
transmit/reply packets), but the point is that LTTPRs will switch to
this mode.

W/o DEFERs and a timeout less than 3.2ms the DPTX can corrupt reply
packets and so miss the ACK (or just simply miss reply because stopping
to listen too early).

Without doing an LTTPR detection, the LTTPRs will remain in no-LTTPR
mode (so there are 3 different modes), where the LTTPRs will send DEFERs
to their closest DPTX PHY and use the original 400us timeout scheme.
This avoids the above transmit/reply packet clash.

> Also, maybe we should just bump the timeout to the max on all platforms?

Yes, I suppose we could do this as a follow-up.

> 
> > +
> >  	if (intel_dp_is_edp(intel_dp))
> >  		return 0;
> >  
> > -- 
> > 2.25.1
> > 
> > _______________________________________________
> > Intel-gfx mailing list
> > Intel-gfx@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/intel-gfx
> 
> -- 
> Ville Syrjälä
> Intel
