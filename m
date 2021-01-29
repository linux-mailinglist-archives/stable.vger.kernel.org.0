Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9368E308BE1
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 18:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbhA2Rpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 12:45:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:14122 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232553AbhA2Rnf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Jan 2021 12:43:35 -0500
IronPort-SDR: pDEiCcF7OawcaAYyDBGeAlpYWO9BWD/5GYyswIveKPgyYdaDPglPqTHc5BYTMSilNnpKkGUv4f
 ClP+46v/Y/vw==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="176952163"
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="176952163"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 09:40:27 -0800
IronPort-SDR: ZrQ/cnhtRMHvTsAF1tV5hd/039K/H2FgupUL1a5205aoGNRchC4UEwFGHMgz8nEqKvTrcBtWLV
 BPGqZwZvy9dA==
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="365345834"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 09:40:26 -0800
Date:   Fri, 29 Jan 2021 19:40:22 +0200
From:   Imre Deak <imre.deak@intel.com>
To:     Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 3/5] drm/i915: Power up combo PHY lanes for
 for HDMI as well
Message-ID: <20210129174022.GF183052@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20210128155948.13678-1-ville.syrjala@linux.intel.com>
 <20210128155948.13678-3-ville.syrjala@linux.intel.com>
 <20210129170633.GC183052@ideak-desk.fi.intel.com>
 <YBRDS8ye67GY+kdM@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YBRDS8ye67GY+kdM@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 29, 2021 at 07:18:03PM +0200, Ville Syrjälä wrote:
> On Fri, Jan 29, 2021 at 07:06:33PM +0200, Imre Deak wrote:
> > On Thu, Jan 28, 2021 at 05:59:46PM +0200, Ville Syrjala wrote:
> > > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > 
> > > Currently we only explicitly power up the combo PHY lanes
> > > for DP. The spec says we should do it for HDMI as well.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > ---
> > >  drivers/gpu/drm/i915/display/intel_ddi.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
> > > index 88cc6e2fbe91..8fbeb8c24efb 100644
> > > --- a/drivers/gpu/drm/i915/display/intel_ddi.c
> > > +++ b/drivers/gpu/drm/i915/display/intel_ddi.c
> > > @@ -4337,6 +4337,8 @@ static void intel_enable_ddi_hdmi(struct intel_atomic_state *state,
> > >  		intel_de_write(dev_priv, reg, val);
> > >  	}
> > >  
> > > +	intel_ddi_power_up_lanes(encoder, crtc_state);
> > > +
> > 
> > Not sure if it matters, but the spec says to apply WA #1143 just before
> > enabling DDI_BUF_CTL.
> 
> intel_ddi_power_up_lanes() is a nop for pre-icl, so we still do that.

Ok, missed this detail, it looks ok then:
Reviewed-by: Imre Deak <imre.deak@intel.com>

> Also not sure what the final fate of that w/a will be since apparently
> it's not working as intended.
> 
> That said I was debating with myself what order to put these in, but
> in the end I chose this order because the w/a is related to the
> vswing programming, and so wanted to keep it next to the BUF_TRANS
> programming.
>
> > >  	/* In HDMI/DVI mode, the port width, and swing/emphasis values
> > >  	 * are ignored so nothing special needs to be done besides
> > >  	 * enabling the port.
> > > -- 
> > > 2.26.2
> > > 
> > > _______________________________________________
> > > Intel-gfx mailing list
> > > Intel-gfx@lists.freedesktop.org
> > > https://lists.freedesktop.org/mailman/listinfo/intel-gfx
> 
> -- 
> Ville Syrjälä
> Intel
