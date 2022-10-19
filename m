Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E1B605119
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 22:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiJSUNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 16:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiJSUNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 16:13:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4D71B2BA9
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 13:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666210379; x=1697746379;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=St73ZqXrFg6jpq6tzl6wsAnS3lOpAT2cGNAdsqwD2vE=;
  b=d6mUhJxVQnboD+SDMcwt4RfEiuopvUEwSGC66mcazmPnrc2t3Rv/JgwZ
   2MLtcu8NIg+oVEq+H9r/3fnkMcle6QQPIS/z2RxMg1FLpM/4MhMASgul5
   F2F8h6EJOkbtax+iLa4wDWP9aowcTTuJTl23yGHRSCh7ERJ6hSWplEwKs
   o8d+qYndfs1Oekg35n/sze6xYmR0wMGiiF9m+rbfK1+w6vclxWiTWFaQk
   Ij4L4qTpEXFWOcs/qyPgvgBgrxXf+J3YcMKADrIOuitlYKCatZXQik+W1
   TpnTewK7/84d0vvlyOGVg4/sVVus/DUyVCgX1IlIrtmXvIOBDS0JPrY9c
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="368568696"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="368568696"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 13:12:58 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="771953094"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="771953094"
Received: from ideak-desk.fi.intel.com ([10.237.72.175])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 13:12:57 -0700
Date:   Wed, 19 Oct 2022 23:12:53 +0300
From:   Imre Deak <imre.deak@intel.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 1/3] drm/i915/tgl+: Add locking around DKL
 PHY register accesses
Message-ID: <Y1BaRfTAH/l+XLqc@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20221018172042.1449885-1-imre.deak@intel.com>
 <87bkq8i3xp.fsf@intel.com>
 <Y0/BNSKHS+GYkLCw@intel.com>
 <Y0/Dwl3Bct0owF7S@intel.com>
 <8735bkhu65.fsf@intel.com>
 <Y0/9Et5mQ5K/Tnsl@ideak-desk.fi.intel.com>
 <87wn8vhndx.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87wn8vhndx.fsf@intel.com>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 05:57:30PM +0300, Jani Nikula wrote:
> On Wed, 19 Oct 2022, Imre Deak <imre.deak@intel.com> wrote:
> > On Wed, Oct 19, 2022 at 03:30:58PM +0300, Jani Nikula wrote:
> >> On Wed, 19 Oct 2022, Ville Syrjälä <ville.syrjala@linux.intel.com> wrote:
> >> > On Wed, Oct 19, 2022 at 12:19:49PM +0300, Ville Syrjälä wrote:
> >> >> On Wed, Oct 19, 2022 at 12:00:02PM +0300, Jani Nikula wrote:
> >> >> > On Tue, 18 Oct 2022, Imre Deak <imre.deak@intel.com> wrote:
> >> >> > > Accessing the TypeC DKL PHY registers during modeset-commit,
> >> >> > > -verification, DP link-retraining and AUX power well toggling is racy
> >> >> > > due to these code paths being concurrent and the PHY register bank
> >> >> > > selection register (HIP_INDEX_REG) being shared between PHY instances
> >> >> > > (aka TC ports) and the bank selection being not atomic wrt. the actual
> >> >> > > PHY register access.
> >> >> > >
> >> >> > > Add the required locking around each PHY register bank selection->
> >> >> > > register access sequence.
> >> >> > 
> >> >> > I honestly think the abstraction here is at a too low level.
> >> >> > 
> >> >> > Too many places are doing DKL PHY register access to begin with. IMO the
> >> >> > solution should be to abstract DKL PHY better, not to provide low level
> >> >> > DKL PHY register accessors.
> >> >> > 
> >> >> > Indeed, this level of granularity leads to a lot of unnecessary
> >> >> > lock/unlock that could have a longer span otherwise, and the interface
> >> >> > does not lend itself for that.
> >> >> 
> >> >> It's no worse than uncore.lock. No one cares about that in
> >> >> these codepaths either.
> >> >> 
> >> >> > Also requires separate bank selection for
> >> >> > every write, nearly doubling the MMIO writes.
> >> >> 
> >> >> Drop in the ocean. This is all slow modeset stuff anyway.
> >> >> 
> >> >> IMO separate reg accessors is the correct way to handle indexed
> >> >> registers unless you have some very specific performance concerns
> >> >> to deal with.
> >> 
> >> Fair enough.
> >> 
> >> > Now, whether those accessors need to be visible everywere is another
> >> > matter. It should certainly be possible to suck all dkl phy stuff
> >> > into one file and keep the accessors static. But currently eveything
> >> > is grouped by function (PLLs in one file, vswing stuff in another,
> >> > etc.). We'd have to flip that around so that all the sub functions
> >> > of of each IP block is in the same file. Is that a better apporach?
> >> > Not sure.
> >> 
> >> I'm often interested in the precedent a change makes. What's the
> >> direction we want to go to?
> >> 
> >> So here, we're saying the DKL PHY registers are special, and need to be
> >> accessed via dedicated register accessors. To enforce this, we create
> >> strong typing for DKL PHY registers. We go out of our way to make it
> >> safe to access DKL PHY registers anywhere in the driver.
> >> 
> >> Do we want to add more and more register types in the future? And
> >> duplicate the accessors for each? Oops, looks like we're already on our
> >> way [1].
> >
> > Making the DKL PHY accesses type safe was just a bonus, the main reason
> > for adding the dkl_phy_reg struct (in a later refactoring patch) is that
> > defining those registers only makes sense to me specifying all the
> > attributes (both MMIO and the bank index) of the register at one place.
> > That's instead of the current way of having to pass these separately to
> > each accessor functions. For instance to be able to call
> >
> > read(DKL_PLL_DIV0(tc_port))
> >
> > instead of having to remember the index of each (non lane-instanced)
> > register and call
> >
> > read(DKL_PLL_DIV0(tc_port), 2)
> >
> > It also makes more sense to me that the register itself is parametric
> > if that's needed (lane-instanced registers), for instance
> >
> > read(DKL_TX_DPCNTL0(tc_port, 0))
> >
> > instead of this being a separate parameter of each accessor function:
> >
> > read(DKL_TX_DPCNTL0(tc_port), 0)
> 
> This is actually a very good point.
> 
> An alternative to this that I've been pondering separately, before these
> patches, is expanding i915_reg_t to encode things like "display
> register", "mcr register", etc.
> 
> So you'd still have only one i915_reg_t type, and only one set of
> accessors, but they could be smarter behind the scenes. But I don't like
> teaching intel uncore about stuff like dkl either. And the main point
> would be avoiding all the duplication that C type safety requires.
> 
> But it's a moot point anyway because we also need something to backport
> to stable, and I acknowledge your approach makes a lot of sense for that
> too.
> 
> >> My argument is that maybe access to such a hardware block should instead
> >> be limited to a module (.c file) that abstracts the details. Abstract
> >> hardware blocks and function, not registers. How many files need big
> >> changes to add a new PHY?
> >
> > I think the accessors could be added to a new intel_tc_phy.c file
> > instead? (That would still allow further refactoring of both the MG and
> > DKL functionality as a follow-up to this change for -stable.)
> 
> So, why intel_tc_anything? Why not just intel_dkl_phy.[ch],
> intel_dkl_phy_regs.h? Even if initially limited to the register
> accessors, you could easily move things like
> tgl_dkl_phy_set_signal_levels() there, just like
> intel_snps_phy_set_signal_levels() is in intel_snps_phy.c. And you could
> have intel_mg_phy.c for MG stuff.

MG and DKL share some register flags and programming sequences
(calculating PLL params, setting pin assignments for instance), hence
thought to have one file for both PHY implementations. But there are
also differences and sharing code would also be possible between the
MG and DKL files, so ok if no objections I can add the accessors to
intel_dkl_phy.[ch].

> I guess intel_tc_phy_regs.h would mostly be split to
> intel_dkl_phy_regs.h and intel_mg_phy_regs.h.

Ok, so I suppose this means renaming the current intel_tc_phy_regs.h to
intel_mg_phy_regs.h, move the DKL regs to intel_dkl_phy_regs.h and
copy/rename the shared MG_* flags in the former to DKL_* in the latter.

--Imre

> BR,
> Jani.
> >
> >> BR,
> >> Jani.
> >> 
> >> [1] https://lore.kernel.org/r/20221014230239.1023689-13-matthew.d.roper@intel.com
> >> 
> >> -- 
> >> Jani Nikula, Intel Open Source Graphics Center
> 
> -- 
> Jani Nikula, Intel Open Source Graphics Center
