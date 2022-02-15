Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447534B756C
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238605AbiBOQ6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 11:58:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236268AbiBOQ6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 11:58:49 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672F6E6C33
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 08:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644944319; x=1676480319;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=AgA9yoniJy+Q7ihp42/+yB1onWxVA8pJj+mZjD3v8S4=;
  b=bhAeZ8z1LKzbob1BN/y4B1UmA5NPhOTh21Wnn19DOY46ha4BqIS3OZLS
   eaCQPyxCpH0Iqx3ZmZTsGjXMf+AuZk5UYl1Eq4CjTPQljzJDQIQc9dfvY
   3UbkiXdwDn4gRDSek/n/IPTD1s/Z6+pZvIKWLBI7HKax2aiB0waitQX/F
   LhHVacXnaQ240bd1g+SsLD+PuGEu1oH7y16KF/0QdmVlSSOqAd3UXmoIW
   iKRAQU76MCTuWEztTfxdmqbTle9A7FoT/LcN8PWIvu6XPM6ake+FgsEUE
   3GYryKHML4/nUit78YPPCKWpp4Mjp1Q3uj+NCxecGWrNqEt0d4szEHkLf
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="249229293"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="249229293"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 08:58:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="502539098"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by orsmga002.jf.intel.com with SMTP; 15 Feb 2022 08:58:36 -0800
Received: by stinkbox (sSMTP sendmail emulation); Tue, 15 Feb 2022 18:58:35 +0200
Date:   Tue, 15 Feb 2022 18:58:35 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 2/6] drm/i915: Fix bw atomic check when
 switching between SAGV vs. no SAGV
Message-ID: <Ygvbu30Mo1yqgwgw@intel.com>
References: <20220214100536.GB24878@intel.com>
 <Ygot+UVlBnA/Xzfk@intel.com>
 <20220214170305.GA25600@intel.com>
 <Ygq6/32Cy6CjMrDu@intel.com>
 <20220215085957.GA15926@intel.com>
 <Ygt8C/SHHLXfHw+A@intel.com>
 <20220215110248.GA16287@intel.com>
 <YguN+rpdJEIjxjkC@intel.com>
 <20220215163342.GA16750@intel.com>
 <YgvaY8iodSyMlyjI@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YgvaY8iodSyMlyjI@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 06:52:51PM +0200, Ville Syrjälä wrote:
> On Tue, Feb 15, 2022 at 06:33:42PM +0200, Lisovskiy, Stanislav wrote:
> > On Tue, Feb 15, 2022 at 01:26:50PM +0200, Ville Syrjälä wrote:
> > > On Tue, Feb 15, 2022 at 01:02:48PM +0200, Lisovskiy, Stanislav wrote:
> > > > On Tue, Feb 15, 2022 at 12:10:19PM +0200, Ville Syrjälä wrote:
> > > > > On Tue, Feb 15, 2022 at 10:59:57AM +0200, Lisovskiy, Stanislav wrote:
> > > > > > On Mon, Feb 14, 2022 at 10:26:39PM +0200, Ville Syrjälä wrote:
> > > > > > > On Mon, Feb 14, 2022 at 07:03:05PM +0200, Lisovskiy, Stanislav wrote:
> > > > > > > > On Mon, Feb 14, 2022 at 12:24:57PM +0200, Ville Syrjälä wrote:
> > > > > > > > > On Mon, Feb 14, 2022 at 12:05:36PM +0200, Lisovskiy, Stanislav wrote:
> > > > > > > > > > On Mon, Feb 14, 2022 at 11:18:07AM +0200, Ville Syrjala wrote:
> > > > > > > > > > > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > > > > > > > > 
> > > > > > > > > > > If the only thing that is changing is SAGV vs. no SAGV but
> > > > > > > > > > > the number of active planes and the total data rates end up
> > > > > > > > > > > unchanged we currently bail out of intel_bw_atomic_check()
> > > > > > > > > > > early and forget to actually compute the new WGV point
> > > > > > > > > > > mask and thus won't actually enable/disable SAGV as requested.
> > > > > > > > > > > This ends up poorly if we end up running with SAGV enabled
> > > > > > > > > > > when we shouldn't. Usually ends up in underruns.
> > > > > > > > > > > To fix this let's go through the QGV point mask computation
> > > > > > > > > > > if anyone else already added the bw state for us.
> > > > > > > > > > 
> > > > > > > > > > Haven't been looking this in a while. Despite we have been
> > > > > > > > > > looking like few revisions together still some bugs :(
> > > > > > > > > > 
> > > > > > > > > > I thought SAGV vs No SAGV can't change if active planes 
> > > > > > > > > > or data rate didn't change? Because it means we probably
> > > > > > > > > > still have same ddb allocations, which means SAGV state
> > > > > > > > > > will just stay the same.
> > > > > > > > > 
> > > > > > > > > SAGV can change due to watermarks/ddb allocations. The easiest
> > > > > > > > > way to trip this up is to try to use the async flip wm0/ddb 
> > > > > > > > > optimization. That immediately forgets to turn off SAGV and
> > > > > > > > > we get underruns, whcih is how I noticed this. And I don't
> > > > > > > > > immediately see any easy proof that this couldn't also happen
> > > > > > > > > due to some other plane changes.
> > > > > > > > 
> > > > > > > > Thats the way it was initially implemented even before SAGV was added.
> > > > > > > 
> > > > > > > Yeah, it wasn't a problem as long as SAGV was not enabled.
> > > > > > > 
> > > > > > > > I think it can be dated back to the very first bw check was implemented.
> > > > > > > > 
> > > > > > > > commit c457d9cf256e942138a54a2e80349ee7fe20c391
> > > > > > > > Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > > > > > Date:   Fri May 24 18:36:14 2019 +0300
> > > > > > > > 
> > > > > > > >     drm/i915: Make sure we have enough memory bandwidth on ICL
> > > > > > > > 
> > > > > > > > +int intel_bw_atomic_check(struct intel_atomic_state *state)
> > > > > > > > +{
> > > > > > > > +       struct drm_i915_private *dev_priv = to_i915(state->base.dev);
> > > > > > > > +       struct intel_crtc_state *new_crtc_state, *old_crtc_state;
> > > > > > > > +       struct intel_bw_state *bw_state = NULL;
> > > > > > > > +       unsigned int data_rate, max_data_rate;
> > > > > > > > +       unsigned int num_active_planes;
> > > > > > > > +       struct intel_crtc *crtc;
> > > > > > > > +       int i;
> > > > > > > > +
> > > > > > > > +       /* FIXME earlier gens need some checks too */
> > > > > > > > +       if (INTEL_GEN(dev_priv) < 11)
> > > > > > > > +               return 0;
> > > > > > > > +
> > > > > > > > +       for_each_oldnew_intel_crtc_in_state(state, crtc, old_crtc_state,
> > > > > > > > +                                           new_crtc_state, i) {
> > > > > > > > +               unsigned int old_data_rate =
> > > > > > > > +                       intel_bw_crtc_data_rate(old_crtc_state);
> > > > > > > > +               unsigned int new_data_rate =
> > > > > > > > +                       intel_bw_crtc_data_rate(new_crtc_state);
> > > > > > > > +               unsigned int old_active_planes =
> > > > > > > > +                       intel_bw_crtc_num_active_planes(old_crtc_state);
> > > > > > > > +               unsigned int new_active_planes =
> > > > > > > > +                       intel_bw_crtc_num_active_planes(new_crtc_state);
> > > > > > > > +
> > > > > > > > +               /*
> > > > > > > > +                * Avoid locking the bw state when
> > > > > > > > +                * nothing significant has changed.
> > > > > > > > +                */
> > > > > > > > +               if (old_data_rate == new_data_rate &&
> > > > > > > > +                   old_active_planes == new_active_planes)
> > > > > > > > +                       continue;
> > > > > > > > +
> > > > > > > > +               bw_state  = intel_atomic_get_bw_state(state);
> > > > > > > > +               if (IS_ERR(bw_state))
> > > > > > > > +                       return PTR_ERR(bw_state);
> > > > > > > > 
> > > > > > > > However, what can cause watermarks/ddb to change, besides plane state change
> > > > > > > > and/or active planes change? We change watermarks, when we change ddb allocations
> > > > > > > > and we change ddb allocations when active planes had changed and/or data rate
> > > > > > > > had changed.
> > > > > > > 
> > > > > > > The bw code only cares about the aggregate numbers from all the planes.
> > > > > > > The planes could still change in some funny way where eg. some plane
> > > > > > > frees up some bandwidth, but the other planes gobble up the exact same
> > > > > > > amount and thus the aggregate numbers the bw atomic check cares about
> > > > > > > do not change but the watermarks/ddb do.
> > > > > > > 
> > > > > > > And as mentiioned, the async flip wm0/ddb optimization makes this trivial
> > > > > > > to trip up since it will want to disable SAGV as there is not enough ddb
> > > > > > > for the SAGV watermark. And async flip specifically isn't even allowed
> > > > > > > to change anything that would affect the bandwidth utilization, and neither
> > > > > > > is it allowed to enable/disable planes.
> > > > > > 
> > > > > > I think the whole idea of setting ddb to minimum in case of async flip optimization
> > > > > > was purely our idea - BSpec/HSD only mentions forbidding wm levels > 0 in case of async
> > > > > > flip, however there is nothing about limiting ddb allocations.
> > > > > 
> > > > > Reducing just the watermark doesn't really make sense 
> > > > > if the goal is to keep the DBUF level to a minimum. Also
> > > > > I don't think there is any proper docs for this thing. The
> > > > > only thing we have just has some vague notes about using
> > > > > "minimum watermarks", whatever that means.
> > > > 
> > > > Was it the goal? I thought limiting watermarks would by itself also
> > > > limit package C states, thus affecting memory clocks and latency.
> > > > Because it really doesn't say anything about keeping Dbuf allocations
> > > > to a minimum. 
> > > 
> > > The goal is to miminize the amount of data in the FIFO.
> > > 
> > > > 
> > > > > 
> > > > > > 
> > > > > > Was a bit suspicious about that whole change, to be honest - and yep, now it seems to
> > > > > > cause some unexpected side effects.
> > > > > 
> > > > > The bw_state vs. SAGV bug is there regardless of the wm0 optimization.
> > > > 
> > > > I agree there is a bug. The bug is such that initial bw checks were relying
> > > > on total data rate + active planes comparison, while it should have accounted
> > > > data rate per plane usage.
> > > > 
> > > > This should have been changed in SAGV patches, but probably had gone
> > > > unnoticed both by you and me.
> > > > 
> > > > > 
> > > > > Also the SAGV watermark is not the minimum watermark (if that is
> > > > > the doc really means by that), the normal WM0 is the minimum watermark.
> > > > > So even if we interpret the doc to say that we should just disable all
> > > > > watermark levels except the smallest one (normal WM0) without changing
> > > > > the ddb allocations we would still end up disabling SAGV.
> > > > 
> > > > Thats actually a good question. Did they mean, disable all "regular" wm levels
> > > > or the SAGV one also? Probably they meant what you say, but would be nice to know
> > > > exactly.
> > > 
> > > They said neither. It's just "program minimum watermarks" which
> > > could mean anything really. They do explicitly say "DBUF level
> > > can also adversely affect flip performance." which I think is
> > > the whole point of this exercise.
> > > 
> > > > 
> > > > Anyway my point here is that, we probably shouldn't use new_bw_state as a way to 
> > > > check that plane allocations had changed. Thats just confusing.
> > > 
> > > We are not checking if plane allocations have changed. We are
> > > trying to determine if anything in the bw_state has changed.
> > > If we have said state already then something in it may have 
> > > changed and we have to recalculate anything that may depend
> > > on those changed things, namely pipe_sagv_reject->qgv_point_mask.
> > 
> > I think it is just not very intuitive that we use the fact whether
> > we can get new_bw_state or not, as a way to check if something had
> > changed.
> > Would be nice to put it in somekind of a wrapper like "has_new_bw_state"
> > or "bw_state_changed". Because for anyone not quite familiar with
> > that state paradigm we use, that would look pretty confusing that first
> > we get new_bw_state using intel_atomic_get_new_bw_state, then immediately
> > override it with intel_atomic_get_bw_state.
> > And whether we can get new_bw_state or not is just acting like a check,
> > that we don't have anything changed in bw_state.
> 
> I think the only thing we'd achieve is something like this:
> 
> new_bw_state = NULL;
> if (has_new_bw_state())
> 	new_bw_state = get_new_bw_state();
> ...
> if (!new_bw_state)
> 	return 0;
> 
> instead of just
> 
> new_bw_state = get_new_bw_state();
> ...
> if (!new_bw_state)
> 	return 0;
> 
> I don't know why that would be an improvement.

Though I suppose a comment might be in order pointing the
reader towards intel_compute_sagv_mask().

-- 
Ville Syrjälä
Intel
