Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272C34B6A22
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 12:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbiBOLCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 06:02:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiBOLCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 06:02:46 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AEC105A9D
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 03:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644922956; x=1676458956;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=xEF2rIv38ac0ZABvDS1me9bEC+ySsoHcnXt3lAT4guE=;
  b=S5UeXlnif3jq6DPlQEIrUfHCGpSssWImg6Xv+3HGr0vB1qwZaacMeA1n
   0HhNkNfsmCx+T7lO7bmAMbqONs/g/+7XO3FYUi194k15tBVfFrmBymA3f
   v6KhJ56UozMPAnG2nBPg2OLMaswy40Y39U7ktunSucTyNyCI4SF1yTlVC
   svDV6k+rL7hhnX3EyNoj6rqv85CnX4lkG3ubdn3g5eT0UBMFaS90btY4W
   4sfEcy4ao2w5iqpqht2lcP0+Xr7ASWQLJLUd0aLyKFGQUgYzrvv2mavBq
   FLhCE6v1Ayy5V+nYxQ+PYBmMNwMOAFL/i54EXT018pV7TE0QhsE1JQaCB
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="230290237"
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="230290237"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 03:02:35 -0800
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="703591999"
Received: from unknown (HELO intel.com) ([10.237.72.65])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 03:02:34 -0800
Date:   Tue, 15 Feb 2022 13:02:48 +0200
From:   "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
To:     Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/6] drm/i915: Fix bw atomic check when switching between
 SAGV vs. no SAGV
Message-ID: <20220215110248.GA16287@intel.com>
References: <20220214091811.13725-1-ville.syrjala@linux.intel.com>
 <20220214091811.13725-3-ville.syrjala@linux.intel.com>
 <20220214100536.GB24878@intel.com>
 <Ygot+UVlBnA/Xzfk@intel.com>
 <20220214170305.GA25600@intel.com>
 <Ygq6/32Cy6CjMrDu@intel.com>
 <20220215085957.GA15926@intel.com>
 <Ygt8C/SHHLXfHw+A@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ygt8C/SHHLXfHw+A@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 12:10:19PM +0200, Ville Syrjälä wrote:
> On Tue, Feb 15, 2022 at 10:59:57AM +0200, Lisovskiy, Stanislav wrote:
> > On Mon, Feb 14, 2022 at 10:26:39PM +0200, Ville Syrjälä wrote:
> > > On Mon, Feb 14, 2022 at 07:03:05PM +0200, Lisovskiy, Stanislav wrote:
> > > > On Mon, Feb 14, 2022 at 12:24:57PM +0200, Ville Syrjälä wrote:
> > > > > On Mon, Feb 14, 2022 at 12:05:36PM +0200, Lisovskiy, Stanislav wrote:
> > > > > > On Mon, Feb 14, 2022 at 11:18:07AM +0200, Ville Syrjala wrote:
> > > > > > > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > > > > 
> > > > > > > If the only thing that is changing is SAGV vs. no SAGV but
> > > > > > > the number of active planes and the total data rates end up
> > > > > > > unchanged we currently bail out of intel_bw_atomic_check()
> > > > > > > early and forget to actually compute the new WGV point
> > > > > > > mask and thus won't actually enable/disable SAGV as requested.
> > > > > > > This ends up poorly if we end up running with SAGV enabled
> > > > > > > when we shouldn't. Usually ends up in underruns.
> > > > > > > To fix this let's go through the QGV point mask computation
> > > > > > > if anyone else already added the bw state for us.
> > > > > > 
> > > > > > Haven't been looking this in a while. Despite we have been
> > > > > > looking like few revisions together still some bugs :(
> > > > > > 
> > > > > > I thought SAGV vs No SAGV can't change if active planes 
> > > > > > or data rate didn't change? Because it means we probably
> > > > > > still have same ddb allocations, which means SAGV state
> > > > > > will just stay the same.
> > > > > 
> > > > > SAGV can change due to watermarks/ddb allocations. The easiest
> > > > > way to trip this up is to try to use the async flip wm0/ddb 
> > > > > optimization. That immediately forgets to turn off SAGV and
> > > > > we get underruns, whcih is how I noticed this. And I don't
> > > > > immediately see any easy proof that this couldn't also happen
> > > > > due to some other plane changes.
> > > > 
> > > > Thats the way it was initially implemented even before SAGV was added.
> > > 
> > > Yeah, it wasn't a problem as long as SAGV was not enabled.
> > > 
> > > > I think it can be dated back to the very first bw check was implemented.
> > > > 
> > > > commit c457d9cf256e942138a54a2e80349ee7fe20c391
> > > > Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > Date:   Fri May 24 18:36:14 2019 +0300
> > > > 
> > > >     drm/i915: Make sure we have enough memory bandwidth on ICL
> > > > 
> > > > +int intel_bw_atomic_check(struct intel_atomic_state *state)
> > > > +{
> > > > +       struct drm_i915_private *dev_priv = to_i915(state->base.dev);
> > > > +       struct intel_crtc_state *new_crtc_state, *old_crtc_state;
> > > > +       struct intel_bw_state *bw_state = NULL;
> > > > +       unsigned int data_rate, max_data_rate;
> > > > +       unsigned int num_active_planes;
> > > > +       struct intel_crtc *crtc;
> > > > +       int i;
> > > > +
> > > > +       /* FIXME earlier gens need some checks too */
> > > > +       if (INTEL_GEN(dev_priv) < 11)
> > > > +               return 0;
> > > > +
> > > > +       for_each_oldnew_intel_crtc_in_state(state, crtc, old_crtc_state,
> > > > +                                           new_crtc_state, i) {
> > > > +               unsigned int old_data_rate =
> > > > +                       intel_bw_crtc_data_rate(old_crtc_state);
> > > > +               unsigned int new_data_rate =
> > > > +                       intel_bw_crtc_data_rate(new_crtc_state);
> > > > +               unsigned int old_active_planes =
> > > > +                       intel_bw_crtc_num_active_planes(old_crtc_state);
> > > > +               unsigned int new_active_planes =
> > > > +                       intel_bw_crtc_num_active_planes(new_crtc_state);
> > > > +
> > > > +               /*
> > > > +                * Avoid locking the bw state when
> > > > +                * nothing significant has changed.
> > > > +                */
> > > > +               if (old_data_rate == new_data_rate &&
> > > > +                   old_active_planes == new_active_planes)
> > > > +                       continue;
> > > > +
> > > > +               bw_state  = intel_atomic_get_bw_state(state);
> > > > +               if (IS_ERR(bw_state))
> > > > +                       return PTR_ERR(bw_state);
> > > > 
> > > > However, what can cause watermarks/ddb to change, besides plane state change
> > > > and/or active planes change? We change watermarks, when we change ddb allocations
> > > > and we change ddb allocations when active planes had changed and/or data rate
> > > > had changed.
> > > 
> > > The bw code only cares about the aggregate numbers from all the planes.
> > > The planes could still change in some funny way where eg. some plane
> > > frees up some bandwidth, but the other planes gobble up the exact same
> > > amount and thus the aggregate numbers the bw atomic check cares about
> > > do not change but the watermarks/ddb do.
> > > 
> > > And as mentiioned, the async flip wm0/ddb optimization makes this trivial
> > > to trip up since it will want to disable SAGV as there is not enough ddb
> > > for the SAGV watermark. And async flip specifically isn't even allowed
> > > to change anything that would affect the bandwidth utilization, and neither
> > > is it allowed to enable/disable planes.
> > 
> > I think the whole idea of setting ddb to minimum in case of async flip optimization
> > was purely our idea - BSpec/HSD only mentions forbidding wm levels > 0 in case of async
> > flip, however there is nothing about limiting ddb allocations.
> 
> Reducing just the watermark doesn't really make sense 
> if the goal is to keep the DBUF level to a minimum. Also
> I don't think there is any proper docs for this thing. The
> only thing we have just has some vague notes about using
> "minimum watermarks", whatever that means.

Was it the goal? I thought limiting watermarks would by itself also
limit package C states, thus affecting memory clocks and latency.
Because it really doesn't say anything about keeping Dbuf allocations
to a minimum. 

> 
> > 
> > Was a bit suspicious about that whole change, to be honest - and yep, now it seems to
> > cause some unexpected side effects.
> 
> The bw_state vs. SAGV bug is there regardless of the wm0 optimization.

I agree there is a bug. The bug is such that initial bw checks were relying
on total data rate + active planes comparison, while it should have accounted
data rate per plane usage.

This should have been changed in SAGV patches, but probably had gone
unnoticed both by you and me.

> 
> Also the SAGV watermark is not the minimum watermark (if that is
> the doc really means by that), the normal WM0 is the minimum watermark.
> So even if we interpret the doc to say that we should just disable all
> watermark levels except the smallest one (normal WM0) without changing
> the ddb allocations we would still end up disabling SAGV.

Thats actually a good question. Did they mean, disable all "regular" wm levels
or the SAGV one also? Probably they meant what you say, but would be nice to know
exactly.

Anyway my point here is that, we probably shouldn't use new_bw_state as a way to 
check that plane allocations had changed. Thats just confusing.

May be for you as i915 guru, thats obvious however not for someone else, who might
touch the code and we are doing open source here.

Can we just add some check which explicitly does per plane data rate checks?

So that we know bail out from that first cycle not only when total_data_rate/active planes
had changed, but we check per plane data rate? 
That might actually save us also in future, if we ever get into such situation, when
bw_state doesn't change, but ddb allocations do.

I know you might say it shouldn't happen, but there is always some new stuff coming.

Stan

> 
> > Also we are now forcing the recalculation to be done always no matter what and using
> > new bw state for that in a bit counterintuitive way, which I don't like. 
> > Not even sure that will always work, as we are not guaranteed to get a non-NULL
> > new_bw_state object from calling intel_atomic_get_new_bw_state, for that purpose we
> > typically call intel_atomic_get_bw_state, which is supposed to do that and its called only
> > here and in cause of CDCLK recalculation, which is called in intel_cdclk_atomic_check and
> > done right after this one.
> 
> If there is no bw_state then bw_state->pipe_sagv_reject can't have
> changed and there is nothing to recalculate.
> 
> > 
> > So if we haven't called intel_atomic_get_bw_state beforehand, which we didn't because there are
> > 2 places, where new bw state was supposed to be created to be usable by intel_atomic_get_new_bw_state
> > - I think, we will(or might) get a NULL here, because intel_atomic_get_bw_state hasn't been called yet.
> 
> Yes, NULL is perfectly fine.
> 
> -- 
> Ville Syrjälä
> Intel
