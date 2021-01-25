Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC95B303099
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 00:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbhAYXyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 18:54:23 -0500
Received: from mga07.intel.com ([134.134.136.100]:23002 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732515AbhAYVFq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 16:05:46 -0500
IronPort-SDR: gkDG67hlyFnz9ItMkKpXpI+TAjtGlabTojNMqKuWO0bUIvAoonVFOH+MiLEasjjuVVZGGlJFs0
 NkQjX0xnzUHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="243880689"
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="243880689"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 13:04:39 -0800
IronPort-SDR: rg0SaxtUFofJmwOHCAURmxVXbJ+AP53IyiyG/bg+UIiX0RuOyEBdhEx5p95eWkQqqzoIiDhAey
 6Sxgxh1QGZNA==
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="387538679"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 13:04:37 -0800
Date:   Mon, 25 Jan 2021 23:04:34 +0200
From:   Imre Deak <imre.deak@intel.com>
To:     Lyude Paul <lyude@redhat.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Ville Syrjala <ville.syrjala@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] drm/i915: Fix the MST PBN divider calculation
Message-ID: <20210125210434.GA1756222@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20210125173636.1733812-1-imre.deak@intel.com>
 <20210125173636.1733812-2-imre.deak@intel.com>
 <2be72160accef04bf2ed7341b3619befc2121330.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2be72160accef04bf2ed7341b3619befc2121330.camel@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 02:24:58PM -0500, Lyude Paul wrote:
> On Mon, 2021-01-25 at 19:36 +0200, Imre Deak wrote:
> > Atm the driver will calculate a wrong MST timeslots/MTP (aka time unit)
> > value for MST streams if the link parameters (link rate or lane count)
> > are limited in a way independent of the sink capabilities (reported by
> > DPCD).
> > 
> > One example of such a limitation is when a MUX between the sink and
> > source connects only a limited number of lanes to the display and
> > connects the rest of the lanes to other peripherals (USB).
> > 
> > Another issue is that atm MST core calculates the divider based on the
> > backwards compatible DPCD (at address 0x0000) vs. the extended
> > capability info (at address 0x2200). This can result in leaving some
> > part of the MST BW unused (For instance in case of the WD19TB dock).
> > 
> > Fix the above two issues by calculating the PBN divider value based on
> > the rate and lane count link parameters that the driver uses for all
> > other computation.
> > 
> > Bugzilla: https://gitlab.freedesktop.org/drm/intel/-/issues/2977
> > Cc: Lyude Paul <lyude@redhat.com>
> > Cc: Ville Syrjala <ville.syrjala@intel.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > ---
> >  drivers/gpu/drm/i915/display/intel_dp_mst.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > index d6a1b961a0e8..b4621ed0127e 100644
> > --- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> > @@ -68,7 +68,9 @@ static int intel_dp_mst_compute_link_config(struct
> > intel_encoder *encoder,
> >  
> >                 slots = drm_dp_atomic_find_vcpi_slots(state, &intel_dp-
> > >mst_mgr,
> >                                                       connector->port,
> > -                                                     crtc_state->pbn, 0);
> > +                                                     crtc_state->pbn,
> > +                                                    
> > drm_dp_get_vc_payload_bw(crtc_state->port_clock,
> > +                                                                      
> 
> This patch looks fine, however you should take care to also update the
> documentation for drm_dp_atomic_find_vcpi_slots() so that it mentiones that
> pbn_div should be DSC aware but also is not exclusive to systems supporting DSC
> over MST (see the docs for the @pbn_div parameter)

I thought (as a follow-up work) that drm_dp_atomic_find_vcpi_slots() and
drm_dp_mst_allocate_vcpi() could be made more generic, requiring the
drivers to always pass in pbn_div. By that we could remove
mst_mgr::pbn_div, keeping only one copy of this value (the one passed to
the above functions).

> Thank you for doing this! I've been meaning to fix the WD19 issues for a while
> now but have been too bogged down by other stuff to spend any time on MST
> recently.
> 
> >         crtc_state->lane_count));
> >                 if (slots == -EDEADLK)
> >                         return slots;
> >                 if (slots >= 0)
> 
> -- 
> Sincerely,
>    Lyude Paul (she/her)
>    Software Engineer at Red Hat
>    
> Note: I deal with a lot of emails and have a lot of bugs on my plate. If you've
> asked me a question, are waiting for a review/merge on a patch, etc. and I
> haven't responded in a while, please feel free to send me another email to check
> on my status. I don't bite!
> 
