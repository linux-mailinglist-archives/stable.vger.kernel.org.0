Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1939D4B4D35
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 12:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349797AbiBNLAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 06:00:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349958AbiBNK7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:59:49 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DD0D2244
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 02:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644834301; x=1676370301;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=GtlQFE0Q4Zcs5BiqIrt5jpMaVlWJ4LKUc+5L2in/Z+o=;
  b=G5tsWTA+yiM0oZy6hT8EtqhnL0ze+3HjQoHKyFs0LIC05aQ5xA5hywkP
   qdH79xa6dm/6A+WFPtMDJ8bf+nOS5nKokeMqGvZXaAd5sS0Affi/V20Qe
   oXcc6xlpFVstVXho3oB42IeGTGwavnwqaSDWtjESuE927km6AcyfCRIYC
   XmFERLrdofmPwNcub6qm19C6yeeZWacFP3fy03Lj5ZMZq5n7aDeYxIA/M
   eQLx9FmrVxv22e0wNdviG9Z/Oer++foe73+rknRhEDaQpr4aoNWUNYjZM
   9wInrf2BMt4TaoYPNkuA1kKrgnKfXHyItMhJtWRaZoAUzyeVlqTSk3qa3
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="310798549"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="310798549"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 02:25:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="570074700"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by orsmga001.jf.intel.com with SMTP; 14 Feb 2022 02:24:58 -0800
Received: by stinkbox (sSMTP sendmail emulation); Mon, 14 Feb 2022 12:24:57 +0200
Date:   Mon, 14 Feb 2022 12:24:57 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/6] drm/i915: Fix bw atomic check when switching between
 SAGV vs. no SAGV
Message-ID: <Ygot+UVlBnA/Xzfk@intel.com>
References: <20220214091811.13725-1-ville.syrjala@linux.intel.com>
 <20220214091811.13725-3-ville.syrjala@linux.intel.com>
 <20220214100536.GB24878@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220214100536.GB24878@intel.com>
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

On Mon, Feb 14, 2022 at 12:05:36PM +0200, Lisovskiy, Stanislav wrote:
> On Mon, Feb 14, 2022 at 11:18:07AM +0200, Ville Syrjala wrote:
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > 
> > If the only thing that is changing is SAGV vs. no SAGV but
> > the number of active planes and the total data rates end up
> > unchanged we currently bail out of intel_bw_atomic_check()
> > early and forget to actually compute the new WGV point
> > mask and thus won't actually enable/disable SAGV as requested.
> > This ends up poorly if we end up running with SAGV enabled
> > when we shouldn't. Usually ends up in underruns.
> > To fix this let's go through the QGV point mask computation
> > if anyone else already added the bw state for us.
> 
> Haven't been looking this in a while. Despite we have been
> looking like few revisions together still some bugs :(
> 
> I thought SAGV vs No SAGV can't change if active planes 
> or data rate didn't change? Because it means we probably
> still have same ddb allocations, which means SAGV state
> will just stay the same.

SAGV can change due to watermarks/ddb allocations. The easiest
way to trip this up is to try to use the async flip wm0/ddb 
optimization. That immediately forgets to turn off SAGV and
we get underruns, whcih is how I noticed this. And I don't
immediately see any easy proof that this couldn't also happen
due to some other plane changes.

> 
> Stan
> 
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
> > Fixes: 20f505f22531 ("drm/i915: Restrict qgv points which don't have enough bandwidth.")
> > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > ---
> >  drivers/gpu/drm/i915/display/intel_bw.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/i915/display/intel_bw.c b/drivers/gpu/drm/i915/display/intel_bw.c
> > index 23aa8e06de18..d72ccee7d53b 100644
> > --- a/drivers/gpu/drm/i915/display/intel_bw.c
> > +++ b/drivers/gpu/drm/i915/display/intel_bw.c
> > @@ -846,6 +846,13 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
> >  	if (num_psf_gv_points > 0)
> >  		mask |= REG_GENMASK(num_psf_gv_points - 1, 0) << ADLS_PSF_PT_SHIFT;
> >  
> > +	/*
> > +	 * If we already have the bw state then recompute everything
> > +	 * even if pipe data_rate / active_planes didn't change.
> > +	 * Other things (such as SAGV) may have changed.
> > +	 */
> > +	new_bw_state = intel_atomic_get_new_bw_state(state);
> > +
> >  	for_each_oldnew_intel_crtc_in_state(state, crtc, old_crtc_state,
> >  					    new_crtc_state, i) {
> >  		unsigned int old_data_rate =
> > -- 
> > 2.34.1
> > 

-- 
Ville Syrjälä
Intel
