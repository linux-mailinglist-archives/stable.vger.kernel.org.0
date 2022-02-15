Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752CF4B78FA
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243522AbiBOTTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 14:19:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243523AbiBOTTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 14:19:07 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073A4109A7C
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 11:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644952736; x=1676488736;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=o7MvG4trEZptKVj/nm2ADSOXzPOf/0wv/Zxg8yyc8Q8=;
  b=fYz28SI1rcmIF5fMMwRwX3JTS6FnulDgqXxkAbgIyfTFXWZcNjUBO7BB
   9LTIQ5DJygneN4LD01HmhHR/5w38GL3/PBG21Cuyy0IPjQly785MnQypH
   aXa0qNi9x/59dkIrNH4pQszcL0TszqMv5xCyjyf+pSYJCOiIyNtLNw1ED
   96P9Z1RN+jIhS89/hf1l5ac3YQz0ltw2vIEdiBoE/sgIvP4r4Z4YvoyRs
   WIm2v/3syXBBhjs82miUyQCvyV8Tpjldaap0bEg0jPDhsxXnqhRBPBZX+
   vz+ve3fA4BQB2rsclO/k7L0386tuzA0wqVD5NRzj+6i89o11AmdjDdd3T
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="230396650"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="230396650"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 11:18:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="544457476"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by orsmga008.jf.intel.com with SMTP; 15 Feb 2022 11:18:53 -0800
Received: by stinkbox (sSMTP sendmail emulation); Tue, 15 Feb 2022 21:18:53 +0200
Date:   Tue, 15 Feb 2022 21:18:53 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 2/6] drm/i915: Fix bw atomic check when
 switching between SAGV vs. no SAGV
Message-ID: <Ygv8nWzNP7F6c2Db@intel.com>
References: <Ygot+UVlBnA/Xzfk@intel.com>
 <20220214170305.GA25600@intel.com>
 <Ygq6/32Cy6CjMrDu@intel.com>
 <20220215085957.GA15926@intel.com>
 <Ygt8C/SHHLXfHw+A@intel.com>
 <20220215110248.GA16287@intel.com>
 <YguN+rpdJEIjxjkC@intel.com>
 <20220215163342.GA16750@intel.com>
 <YgvaY8iodSyMlyjI@intel.com>
 <Ygvbu30Mo1yqgwgw@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ygvbu30Mo1yqgwgw@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 06:58:35PM +0200, Ville Syrjälä wrote:
> On Tue, Feb 15, 2022 at 06:52:51PM +0200, Ville Syrjälä wrote:
> > On Tue, Feb 15, 2022 at 06:33:42PM +0200, Lisovskiy, Stanislav wrote:
> > > On Tue, Feb 15, 2022 at 01:26:50PM +0200, Ville Syrjälä wrote:
> > > > On Tue, Feb 15, 2022 at 01:02:48PM +0200, Lisovskiy, Stanislav wrote:
> > > > > Anyway my point here is that, we probably shouldn't use new_bw_state as a way to 
> > > > > check that plane allocations had changed. Thats just confusing.
> > > > 
> > > > We are not checking if plane allocations have changed. We are
> > > > trying to determine if anything in the bw_state has changed.
> > > > If we have said state already then something in it may have 
> > > > changed and we have to recalculate anything that may depend
> > > > on those changed things, namely pipe_sagv_reject->qgv_point_mask.
> > > 
> > > I think it is just not very intuitive that we use the fact whether
> > > we can get new_bw_state or not, as a way to check if something had
> > > changed.
> > > Would be nice to put it in somekind of a wrapper like "has_new_bw_state"
> > > or "bw_state_changed". Because for anyone not quite familiar with
> > > that state paradigm we use, that would look pretty confusing that first
> > > we get new_bw_state using intel_atomic_get_new_bw_state, then immediately
> > > override it with intel_atomic_get_bw_state.
> > > And whether we can get new_bw_state or not is just acting like a check,
> > > that we don't have anything changed in bw_state.
> > 
> > I think the only thing we'd achieve is something like this:
> > 
> > new_bw_state = NULL;
> > if (has_new_bw_state())
> > 	new_bw_state = get_new_bw_state();
> > ...
> > if (!new_bw_state)
> > 	return 0;
> > 
> > instead of just
> > 
> > new_bw_state = get_new_bw_state();
> > ...
> > if (!new_bw_state)
> > 	return 0;
> > 
> > I don't know why that would be an improvement.
> 
> Though I suppose a comment might be in order pointing the
> reader towards intel_compute_sagv_mask().

Although, I guess one idea would be to extract that data_rate
loop thing into a separate function and then we'd just end up with
something along the lines of:

ret = intel_bw_check_data_rate(state);
if (ret)
	return ret;

new_bw_state = intel_atomic_get_new_bw_state(state);
if (!new_bw_state)
	return 0;

...

-- 
Ville Syrjälä
Intel
