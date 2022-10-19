Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F69604A60
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 17:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiJSPEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 11:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiJSPDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 11:03:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8CEDBBDE
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 07:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666191478; x=1697727478;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=7LsV+0pP/htYJCm1IC5zGKdLThuZykYXnZRen0ZLpKM=;
  b=D9ltwUqP6RpCM7oWNIzPBz+YE8IGskpOKwb8o0NMbRmnBX/ireJDTnKX
   s1pbz3uA9T1SHEc5/UMUZMyT6IwhFGx4sQeDltZiE6fuTeJajwF6c2VW9
   giG4D20su8KQnfzSKNo3zChWXq3HN3C8dYjSp4NMikzbLPs7nZ30IjUit
   wmu7mhvwGe6DebNa5S2xtnwkPTyyA25Uem8mrIHvuuADj1ox79widFnXO
   WBcp64skSWn7nAp3WQ0xfNJZ6X+pMge2TocQeqGSRIcpC6gwC/qqeU4rs
   D97MCWaqwA9OlpBnUD6hFfMBWMLxCIxRvjVoq366i2/VGbfSEtXR149mg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="289749801"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="289749801"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 07:57:35 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="698110707"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="698110707"
Received: from mosermix-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.50.2])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 07:57:33 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     imre.deak@intel.com
Cc:     Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 1/3] drm/i915/tgl+: Add locking around DKL
 PHY register accesses
In-Reply-To: <Y0/9Et5mQ5K/Tnsl@ideak-desk.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20221018172042.1449885-1-imre.deak@intel.com>
 <87bkq8i3xp.fsf@intel.com> <Y0/BNSKHS+GYkLCw@intel.com>
 <Y0/Dwl3Bct0owF7S@intel.com> <8735bkhu65.fsf@intel.com>
 <Y0/9Et5mQ5K/Tnsl@ideak-desk.fi.intel.com>
Date:   Wed, 19 Oct 2022 17:57:30 +0300
Message-ID: <87wn8vhndx.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Oct 2022, Imre Deak <imre.deak@intel.com> wrote:
> On Wed, Oct 19, 2022 at 03:30:58PM +0300, Jani Nikula wrote:
>> On Wed, 19 Oct 2022, Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.=
com> wrote:
>> > On Wed, Oct 19, 2022 at 12:19:49PM +0300, Ville Syrj=C3=A4l=C3=A4 wrot=
e:
>> >> On Wed, Oct 19, 2022 at 12:00:02PM +0300, Jani Nikula wrote:
>> >> > On Tue, 18 Oct 2022, Imre Deak <imre.deak@intel.com> wrote:
>> >> > > Accessing the TypeC DKL PHY registers during modeset-commit,
>> >> > > -verification, DP link-retraining and AUX power well toggling is =
racy
>> >> > > due to these code paths being concurrent and the PHY register bank
>> >> > > selection register (HIP_INDEX_REG) being shared between PHY insta=
nces
>> >> > > (aka TC ports) and the bank selection being not atomic wrt. the a=
ctual
>> >> > > PHY register access.
>> >> > >
>> >> > > Add the required locking around each PHY register bank selection->
>> >> > > register access sequence.
>> >> >=20
>> >> > I honestly think the abstraction here is at a too low level.
>> >> >=20
>> >> > Too many places are doing DKL PHY register access to begin with. IM=
O the
>> >> > solution should be to abstract DKL PHY better, not to provide low l=
evel
>> >> > DKL PHY register accessors.
>> >> >=20
>> >> > Indeed, this level of granularity leads to a lot of unnecessary
>> >> > lock/unlock that could have a longer span otherwise, and the interf=
ace
>> >> > does not lend itself for that.
>> >>=20
>> >> It's no worse than uncore.lock. No one cares about that in
>> >> these codepaths either.
>> >>=20
>> >> > Also requires separate bank selection for
>> >> > every write, nearly doubling the MMIO writes.
>> >>=20
>> >> Drop in the ocean. This is all slow modeset stuff anyway.
>> >>=20
>> >> IMO separate reg accessors is the correct way to handle indexed
>> >> registers unless you have some very specific performance concerns
>> >> to deal with.
>>=20
>> Fair enough.
>>=20
>> > Now, whether those accessors need to be visible everywere is another
>> > matter. It should certainly be possible to suck all dkl phy stuff
>> > into one file and keep the accessors static. But currently eveything
>> > is grouped by function (PLLs in one file, vswing stuff in another,
>> > etc.). We'd have to flip that around so that all the sub functions
>> > of of each IP block is in the same file. Is that a better apporach?
>> > Not sure.
>>=20
>> I'm often interested in the precedent a change makes. What's the
>> direction we want to go to?
>>=20
>> So here, we're saying the DKL PHY registers are special, and need to be
>> accessed via dedicated register accessors. To enforce this, we create
>> strong typing for DKL PHY registers. We go out of our way to make it
>> safe to access DKL PHY registers anywhere in the driver.
>>=20
>> Do we want to add more and more register types in the future? And
>> duplicate the accessors for each? Oops, looks like we're already on our
>> way [1].
>
> Making the DKL PHY accesses type safe was just a bonus, the main reason
> for adding the dkl_phy_reg struct (in a later refactoring patch) is that
> defining those registers only makes sense to me specifying all the
> attributes (both MMIO and the bank index) of the register at one place.
> That's instead of the current way of having to pass these separately to
> each accessor functions. For instance to be able to call
>
> read(DKL_PLL_DIV0(tc_port))
>
> instead of having to remember the index of each (non lane-instanced)
> register and call
>
> read(DKL_PLL_DIV0(tc_port), 2)
>
> It also makes more sense to me that the register itself is parametric
> if that's needed (lane-instanced registers), for instance
>
> read(DKL_TX_DPCNTL0(tc_port, 0))
>
> instead of this being a separate parameter of each accessor function:
>
> read(DKL_TX_DPCNTL0(tc_port), 0)

This is actually a very good point.

An alternative to this that I've been pondering separately, before these
patches, is expanding i915_reg_t to encode things like "display
register", "mcr register", etc.

So you'd still have only one i915_reg_t type, and only one set of
accessors, but they could be smarter behind the scenes. But I don't like
teaching intel uncore about stuff like dkl either. And the main point
would be avoiding all the duplication that C type safety requires.

But it's a moot point anyway because we also need something to backport
to stable, and I acknowledge your approach makes a lot of sense for that
too.

>> My argument is that maybe access to such a hardware block should instead
>> be limited to a module (.c file) that abstracts the details. Abstract
>> hardware blocks and function, not registers. How many files need big
>> changes to add a new PHY?
>
> I think the accessors could be added to a new intel_tc_phy.c file
> instead? (That would still allow further refactoring of both the MG and
> DKL functionality as a follow-up to this change for -stable.)

So, why intel_tc_anything? Why not just intel_dkl_phy.[ch],
intel_dkl_phy_regs.h? Even if initially limited to the register
accessors, you could easily move things like
tgl_dkl_phy_set_signal_levels() there, just like
intel_snps_phy_set_signal_levels() is in intel_snps_phy.c. And you could
have intel_mg_phy.c for MG stuff.

I guess intel_tc_phy_regs.h would mostly be split to
intel_dkl_phy_regs.h and intel_mg_phy_regs.h.


BR,
Jani.


>
>> BR,
>> Jani.
>>=20
>> [1] https://lore.kernel.org/r/20221014230239.1023689-13-matthew.d.roper@=
intel.com
>>=20
>> --=20
>> Jani Nikula, Intel Open Source Graphics Center

--=20
Jani Nikula, Intel Open Source Graphics Center
