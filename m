Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4354B57D6
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 18:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbiBNRDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 12:03:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356865AbiBNRDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 12:03:06 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AECB65170
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 09:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644858178; x=1676394178;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=GUEDrqd/S1rE3V6iwQk0PZUCusXZGzuaNOs02CAtayk=;
  b=bxOu0UZcEAjkj1dhQSL6lmt2P7dhLmNKlTwJmhBHEM/Yx5nBGW81bHF2
   1FORuVwh4xGs6YH4fJFfofDzw+BRA8OSZiKRI/ZVJuI8v86HiQSjIx7LV
   0QC8bLtZ9uFBrf6SEAJHHrDQMuOxvOuMgJ2mlZcebarjLqG+CUS/wsfO1
   OVzhXYJFS33mkfWsPQzqZz7lxWGs9gvpCe5ON1cVHUIXJmgjO6Uu/lZLR
   391qijWHiwdfaVNy5A+t8O0sQ3MnzrYd935g1DUEa459ALsbw6GOGyCJa
   X8YAvBlVqFW/MDGZNrocMfxVzEh6fh2bmMsyWfptLY8MFxp40g8gDtM0W
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="250340456"
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="250340456"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 09:02:58 -0800
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="703182551"
Received: from unknown (HELO intel.com) ([10.237.72.65])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 09:02:56 -0800
Date:   Mon, 14 Feb 2022 19:03:05 +0200
From:   "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
To:     Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/6] drm/i915: Fix bw atomic check when switching between
 SAGV vs. no SAGV
Message-ID: <20220214170305.GA25600@intel.com>
References: <20220214091811.13725-1-ville.syrjala@linux.intel.com>
 <20220214091811.13725-3-ville.syrjala@linux.intel.com>
 <20220214100536.GB24878@intel.com>
 <Ygot+UVlBnA/Xzfk@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ygot+UVlBnA/Xzfk@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 12:24:57PM +0200, Ville Syrjälä wrote:
> On Mon, Feb 14, 2022 at 12:05:36PM +0200, Lisovskiy, Stanislav wrote:
> > On Mon, Feb 14, 2022 at 11:18:07AM +0200, Ville Syrjala wrote:
> > > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > 
> > > If the only thing that is changing is SAGV vs. no SAGV but
> > > the number of active planes and the total data rates end up
> > > unchanged we currently bail out of intel_bw_atomic_check()
> > > early and forget to actually compute the new WGV point
> > > mask and thus won't actually enable/disable SAGV as requested.
> > > This ends up poorly if we end up running with SAGV enabled
> > > when we shouldn't. Usually ends up in underruns.
> > > To fix this let's go through the QGV point mask computation
> > > if anyone else already added the bw state for us.
> > 
> > Haven't been looking this in a while. Despite we have been
> > looking like few revisions together still some bugs :(
> > 
> > I thought SAGV vs No SAGV can't change if active planes 
> > or data rate didn't change? Because it means we probably
> > still have same ddb allocations, which means SAGV state
> > will just stay the same.
> 
> SAGV can change due to watermarks/ddb allocations. The easiest
> way to trip this up is to try to use the async flip wm0/ddb 
> optimization. That immediately forgets to turn off SAGV and
> we get underruns, whcih is how I noticed this. And I don't
> immediately see any easy proof that this couldn't also happen
> due to some other plane changes.

Thats the way it was initially implemented even before SAGV was added.
I think it can be dated back to the very first bw check was implemented.

commit c457d9cf256e942138a54a2e80349ee7fe20c391
Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
Date:   Fri May 24 18:36:14 2019 +0300

    drm/i915: Make sure we have enough memory bandwidth on ICL

+int intel_bw_atomic_check(struct intel_atomic_state *state)
+{
+       struct drm_i915_private *dev_priv = to_i915(state->base.dev);
+       struct intel_crtc_state *new_crtc_state, *old_crtc_state;
+       struct intel_bw_state *bw_state = NULL;
+       unsigned int data_rate, max_data_rate;
+       unsigned int num_active_planes;
+       struct intel_crtc *crtc;
+       int i;
+
+       /* FIXME earlier gens need some checks too */
+       if (INTEL_GEN(dev_priv) < 11)
+               return 0;
+
+       for_each_oldnew_intel_crtc_in_state(state, crtc, old_crtc_state,
+                                           new_crtc_state, i) {
+               unsigned int old_data_rate =
+                       intel_bw_crtc_data_rate(old_crtc_state);
+               unsigned int new_data_rate =
+                       intel_bw_crtc_data_rate(new_crtc_state);
+               unsigned int old_active_planes =
+                       intel_bw_crtc_num_active_planes(old_crtc_state);
+               unsigned int new_active_planes =
+                       intel_bw_crtc_num_active_planes(new_crtc_state);
+
+               /*
+                * Avoid locking the bw state when
+                * nothing significant has changed.
+                */
+               if (old_data_rate == new_data_rate &&
+                   old_active_planes == new_active_planes)
+                       continue;
+
+               bw_state  = intel_atomic_get_bw_state(state);
+               if (IS_ERR(bw_state))
+                       return PTR_ERR(bw_state);

However, what can cause watermarks/ddb to change, besides plane state change
and/or active planes change? We change watermarks, when we change ddb allocations
and we change ddb allocations when active planes had changed and/or data rate
had changed.

Stan

> 
> > 
> > Stan
> > 
> > > 
> > > Cc: stable@vger.kernel.org
> > > Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
> > > Fixes: 20f505f22531 ("drm/i915: Restrict qgv points which don't have enough bandwidth.")
> > > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > ---
> > >  drivers/gpu/drm/i915/display/intel_bw.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > > 
> > > diff --git a/drivers/gpu/drm/i915/display/intel_bw.c b/drivers/gpu/drm/i915/display/intel_bw.c
> > > index 23aa8e06de18..d72ccee7d53b 100644
> > > --- a/drivers/gpu/drm/i915/display/intel_bw.c
> > > +++ b/drivers/gpu/drm/i915/display/intel_bw.c
> > > @@ -846,6 +846,13 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
> > >  	if (num_psf_gv_points > 0)
> > >  		mask |= REG_GENMASK(num_psf_gv_points - 1, 0) << ADLS_PSF_PT_SHIFT;
> > >  
> > > +	/*
> > > +	 * If we already have the bw state then recompute everything
> > > +	 * even if pipe data_rate / active_planes didn't change.
> > > +	 * Other things (such as SAGV) may have changed.
> > > +	 */
> > > +	new_bw_state = intel_atomic_get_new_bw_state(state);
> > > +
> > >  	for_each_oldnew_intel_crtc_in_state(state, crtc, old_crtc_state,
> > >  					    new_crtc_state, i) {
> > >  		unsigned int old_data_rate =
> > > -- 
> > > 2.34.1
> > > 
> 
> -- 
> Ville Syrjälä
> Intel
