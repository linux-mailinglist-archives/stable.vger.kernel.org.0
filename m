Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6762A432F9D
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 09:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbhJSHfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 03:35:54 -0400
Received: from mga03.intel.com ([134.134.136.65]:54982 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229551AbhJSHfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 03:35:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10141"; a="228393008"
X-IronPort-AV: E=Sophos;i="5.85,383,1624345200"; 
   d="scan'208";a="228393008"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 00:33:40 -0700
X-IronPort-AV: E=Sophos;i="5.85,383,1624345200"; 
   d="scan'208";a="574072986"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 00:33:39 -0700
Date:   Tue, 19 Oct 2021 10:33:35 +0300
From:   Imre Deak <imre.deak@intel.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 2/6] drm/i915/dp: Ensure sink rate values are
 always valid
Message-ID: <20211019073335.GB1537791@ideak-desk.fi.intel.com>
References: <20211018094154.1407705-1-imre.deak@intel.com>
 <20211018094154.1407705-3-imre.deak@intel.com>
 <87pms1scdl.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87pms1scdl.fsf@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 19, 2021 at 10:27:18AM +0300, Jani Nikula wrote:
> On Mon, 18 Oct 2021, Imre Deak <imre.deak@intel.com> wrote:
> > Atm, there are no sink rate values set for DP (vs. eDP) sinks until the
> > DPCD capabilities are successfully read from the sink. During this time
> > intel_dp->num_common_rates is 0 which can lead to a
> >
> > intel_dp->common_rates[-1]    (*)
> >
> > access, which is an undefined behaviour, in the following cases:
> >
> > - In intel_dp_sync_state(), if the encoder is enabled without a sink
> >   connected to the encoder's connector (BIOS enabled a monitor, but the
> >   user unplugged the monitor until the driver loaded).
> > - In intel_dp_sync_state() if the encoder is enabled with a sink
> >   connected, but for some reason the DPCD read has failed.
> > - In intel_dp_compute_link_config() if modesetting a connector without
> >   a sink connected on it.
> > - In intel_dp_compute_link_config() if modesetting a connector with a
> >   a sink connected on it, but before probing the connector first.
> >
> > To avoid the (*) access in all the above cases, make sure that the sink
> > rate table - and hence the common rate table - is always valid, by
> > setting a default minimum sink rate when registering the connector
> > before anything could use it.
> >
> > I also considered setting all the DP link rates by default, so that
> > modesetting with higher resolution modes also succeeds in the last two
> > cases above. However in case a sink is not connected that would stop
> > working after the first modeset, due to the LT fallback logic. So this
> > would need more work, beyond the scope of this fix.
> >
> > As I mentioned in the previous patch, I don't think the issue this patch
> > fixes is user visible, however it is an undefined behaviour by
> > definition and triggers a BUG() in CONFIG_UBSAN builds, hence CC:stable.
> 
> I think the question here, and in the following patches, is whether this
> papers over potential bugs elsewhere.
> 
> Would the original bug fixed by patch 1 have been detected if all the
> safeguards here had been in place? Point being, we shouldn't be doing
> any of these things before we've read the dpcd.

Modesets are possible even without a connected sink or a read-out DPCD,
so the link parameters need to be valid even without those.

> BR,
> Jani.
> 
> 
> >
> > Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/4297
> > References: https://gitlab.freedesktop.org/drm/intel/-/issues/4298
> > Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > ---
> >  drivers/gpu/drm/i915/display/intel_dp.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
> > index 23de500d56b52..153ae944a354b 100644
> > --- a/drivers/gpu/drm/i915/display/intel_dp.c
> > +++ b/drivers/gpu/drm/i915/display/intel_dp.c
> > @@ -120,6 +120,12 @@ bool intel_dp_is_uhbr(const struct intel_crtc_state *crtc_state)
> >  	return crtc_state->port_clock >= 1000000;
> >  }
> >  
> > +static void intel_dp_set_default_sink_rates(struct intel_dp *intel_dp)
> > +{
> > +	intel_dp->sink_rates[0] = 162000;
> > +	intel_dp->num_sink_rates = 1;
> > +}
> > +
> >  /* update sink rates from dpcd */
> >  static void intel_dp_set_sink_rates(struct intel_dp *intel_dp)
> >  {
> > @@ -5003,6 +5009,8 @@ intel_dp_init_connector(struct intel_digital_port *dig_port,
> >  	}
> >  
> >  	intel_dp_set_source_rates(intel_dp);
> > +	intel_dp_set_default_sink_rates(intel_dp);
> > +	intel_dp_set_common_rates(intel_dp);
> >  
> >  	if (IS_VALLEYVIEW(dev_priv) || IS_CHERRYVIEW(dev_priv))
> >  		intel_dp->pps.active_pipe = vlv_active_pipe(intel_dp);
> 
> -- 
> Jani Nikula, Intel Open Source Graphics Center
