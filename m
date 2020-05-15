Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3051D57F2
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 19:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgEORa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 13:30:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:15374 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgEORa6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 13:30:58 -0400
IronPort-SDR: KSTjSOOFBDK5ODGrk7Mrt/ADMxI/iM2fZ807+kfP65HTiIXJ7SVBw64mCf8BlK8fuwUndFRVc1
 M+//F5+jZ/yA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 10:30:58 -0700
IronPort-SDR: 4ojzq7Ji0R1QM9Lgy2aHLf1UV9DIblXQk/fLb9PCY/ZUBs3NEuW3bpiNquxNzg78bhYyZoEpxD
 zCIRpIno/v4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,396,1583222400"; 
   d="scan'208";a="307476087"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by FMSMGA003.fm.intel.com with SMTP; 15 May 2020 10:30:55 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 15 May 2020 20:30:54 +0300
Date:   Fri, 15 May 2020 20:30:54 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Imre Deak <imre.deak@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Fix AUX power domain toggling
 across TypeC mode resets
Message-ID: <20200515173054.GM6112@intel.com>
References: <20200514204553.27193-1-imre.deak@intel.com>
 <20200515162106.GL6112@intel.com>
 <20200515172445.GA20373@ideak-desk.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200515172445.GA20373@ideak-desk.fi.intel.com>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 15, 2020 at 08:24:45PM +0300, Imre Deak wrote:
> On Fri, May 15, 2020 at 07:21:06PM +0300, Ville Syrjälä wrote:
> > On Thu, May 14, 2020 at 11:45:53PM +0300, Imre Deak wrote:
> > > Make sure to select the port's AUX power domain while holding the TC
> > > port lock. The domain depends on the port's current TC mode, which may
> > > get changed under us if we're not holding the lock.
> > 
> > Can we toss in a lockdep assert?
> 
> Yes, can do that. However, now I realize, there is one more place to fix
> in intel_dp_force(), where I think we could just drop the aux get/put.
> 
> So are you ok to do that as a follow-up?

Sure.

> 
> > Did this by any chance help with the MST issues you were seeing?
> 
> No, at least it didn't resolve it. Still some missing responses to MST
> down messages. More precisely the sink does send interrupts as a
> response, but the interrupt handler won't see the DP_DOWN_REP_MSG_RDY
> being set in ESI.

:(

> 
> > > This was left out from
> > > commit 8c10e2262663 ("drm/i915: Keep the TypeC port mode fixed for detect/AUX transfers")
> > > 
> > > Cc: <stable@vger.kernel.org> # v5.4+
> > > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > > ---
> > >  drivers/gpu/drm/i915/display/intel_dp.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
> > > index 408c3c1c5e81..40d42dcff0b7 100644
> > > --- a/drivers/gpu/drm/i915/display/intel_dp.c
> > > +++ b/drivers/gpu/drm/i915/display/intel_dp.c
> > > @@ -1359,8 +1359,7 @@ intel_dp_aux_xfer(struct intel_dp *intel_dp,
> > >  	bool is_tc_port = intel_phy_is_tc(i915, phy);
> > >  	i915_reg_t ch_ctl, ch_data[5];
> > >  	u32 aux_clock_divider;
> > > -	enum intel_display_power_domain aux_domain =
> > > -		intel_aux_power_domain(intel_dig_port);
> > > +	enum intel_display_power_domain aux_domain;
> > >  	intel_wakeref_t aux_wakeref;
> > >  	intel_wakeref_t pps_wakeref;
> > >  	int i, ret, recv_bytes;
> > > @@ -1375,6 +1374,8 @@ intel_dp_aux_xfer(struct intel_dp *intel_dp,
> > >  	if (is_tc_port)
> > >  		intel_tc_port_lock(intel_dig_port);
> > >  
> > > +	aux_domain = intel_aux_power_domain(intel_dig_port);
> > > +
> > >  	aux_wakeref = intel_display_power_get(i915, aux_domain);
> > >  	pps_wakeref = pps_lock(intel_dp);
> > >  
> > > -- 
> > > 2.23.1
> > > 
> > > _______________________________________________
> > > Intel-gfx mailing list
> > > Intel-gfx@lists.freedesktop.org
> > > https://lists.freedesktop.org/mailman/listinfo/intel-gfx
> > 
> > -- 
> > Ville Syrjälä
> > Intel

-- 
Ville Syrjälä
Intel
