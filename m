Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28026048A4
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 16:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbiJSODF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 10:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiJSOCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 10:02:42 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFD59AC28
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 06:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666187019; x=1697723019;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=dvlsG5sEh3EylAD9QJMNycaZauGQIGu7yJfnhIe0dIU=;
  b=nVERxAbD8ybO5Td9avMlh0XnamXwdY1rvQm8+Cy0VWh7ulPLUrud7wlt
   lJhue+wZ0UHmpZo8YuSuS1DWbJ0ai8Lzi8WVnrHuH3DJocr8s/Blih1Cw
   /bC0svkGKD5iqWCcNpPdY/xy7zFk/94jMXW20aMJr2lOqe/hHUY+7zGCe
   +VhLj5bD3oIrFgz5U+hoBxMqQxy3kAvkuvOlzdAPfTqVyEwjIztJT6rL5
   2Ik9hKlYePOWd90+W6W6JMIgSONrI66kiFjlCWOpIrdC1N4ED1fx2DxRP
   DAAekDUxbi85+DA8NsisKaAQKpdE+aA8VbUq3pLefnwcIbIVnObRjQIGL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="289728375"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="289728375"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 06:41:36 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="631673289"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="631673289"
Received: from ideak-desk.fi.intel.com ([10.237.72.175])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 06:41:35 -0700
Date:   Wed, 19 Oct 2022 16:41:31 +0300
From:   Imre Deak <imre.deak@intel.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 1/3] drm/i915/tgl+: Add locking around DKL
 PHY register accesses
Message-ID: <Y0/9Et5mQ5K/Tnsl@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20221018172042.1449885-1-imre.deak@intel.com>
 <87bkq8i3xp.fsf@intel.com>
 <Y0/BNSKHS+GYkLCw@intel.com>
 <Y0/Dwl3Bct0owF7S@intel.com>
 <8735bkhu65.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8735bkhu65.fsf@intel.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 03:30:58PM +0300, Jani Nikula wrote:
> On Wed, 19 Oct 2022, Ville Syrjälä <ville.syrjala@linux.intel.com> wrote:
> > On Wed, Oct 19, 2022 at 12:19:49PM +0300, Ville Syrjälä wrote:
> >> On Wed, Oct 19, 2022 at 12:00:02PM +0300, Jani Nikula wrote:
> >> > On Tue, 18 Oct 2022, Imre Deak <imre.deak@intel.com> wrote:
> >> > > Accessing the TypeC DKL PHY registers during modeset-commit,
> >> > > -verification, DP link-retraining and AUX power well toggling is racy
> >> > > due to these code paths being concurrent and the PHY register bank
> >> > > selection register (HIP_INDEX_REG) being shared between PHY instances
> >> > > (aka TC ports) and the bank selection being not atomic wrt. the actual
> >> > > PHY register access.
> >> > >
> >> > > Add the required locking around each PHY register bank selection->
> >> > > register access sequence.
> >> > 
> >> > I honestly think the abstraction here is at a too low level.
> >> > 
> >> > Too many places are doing DKL PHY register access to begin with. IMO the
> >> > solution should be to abstract DKL PHY better, not to provide low level
> >> > DKL PHY register accessors.
> >> > 
> >> > Indeed, this level of granularity leads to a lot of unnecessary
> >> > lock/unlock that could have a longer span otherwise, and the interface
> >> > does not lend itself for that.
> >> 
> >> It's no worse than uncore.lock. No one cares about that in
> >> these codepaths either.
> >> 
> >> > Also requires separate bank selection for
> >> > every write, nearly doubling the MMIO writes.
> >> 
> >> Drop in the ocean. This is all slow modeset stuff anyway.
> >> 
> >> IMO separate reg accessors is the correct way to handle indexed
> >> registers unless you have some very specific performance concerns
> >> to deal with.
> 
> Fair enough.
> 
> > Now, whether those accessors need to be visible everywere is another
> > matter. It should certainly be possible to suck all dkl phy stuff
> > into one file and keep the accessors static. But currently eveything
> > is grouped by function (PLLs in one file, vswing stuff in another,
> > etc.). We'd have to flip that around so that all the sub functions
> > of of each IP block is in the same file. Is that a better apporach?
> > Not sure.
> 
> I'm often interested in the precedent a change makes. What's the
> direction we want to go to?
> 
> So here, we're saying the DKL PHY registers are special, and need to be
> accessed via dedicated register accessors. To enforce this, we create
> strong typing for DKL PHY registers. We go out of our way to make it
> safe to access DKL PHY registers anywhere in the driver.
> 
> Do we want to add more and more register types in the future? And
> duplicate the accessors for each? Oops, looks like we're already on our
> way [1].

Making the DKL PHY accesses type safe was just a bonus, the main reason
for adding the dkl_phy_reg struct (in a later refactoring patch) is that
defining those registers only makes sense to me specifying all the
attributes (both MMIO and the bank index) of the register at one place.
That's instead of the current way of having to pass these separately to
each accessor functions. For instance to be able to call

read(DKL_PLL_DIV0(tc_port))

instead of having to remember the index of each (non lane-instanced)
register and call

read(DKL_PLL_DIV0(tc_port), 2)

It also makes more sense to me that the register itself is parametric
if that's needed (lane-instanced registers), for instance

read(DKL_TX_DPCNTL0(tc_port, 0))

instead of this being a separate parameter of each accessor function:

read(DKL_TX_DPCNTL0(tc_port), 0)

> My argument is that maybe access to such a hardware block should instead
> be limited to a module (.c file) that abstracts the details. Abstract
> hardware blocks and function, not registers. How many files need big
> changes to add a new PHY?

I think the accessors could be added to a new intel_tc_phy.c file
instead? (That would still allow further refactoring of both the MG and
DKL functionality as a follow-up to this change for -stable.)

> BR,
> Jani.
> 
> [1] https://lore.kernel.org/r/20221014230239.1023689-13-matthew.d.roper@intel.com
> 
> -- 
> Jani Nikula, Intel Open Source Graphics Center
