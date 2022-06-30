Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C382B561FD5
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 18:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbiF3QBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 12:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235325AbiF3QBt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 12:01:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED842A42A;
        Thu, 30 Jun 2022 09:01:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E31FB82ABE;
        Thu, 30 Jun 2022 16:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB750C34115;
        Thu, 30 Jun 2022 16:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656604904;
        bh=9a7QJETb8qsbuncRpKStDGFKmjVy6m0K4HKIoKMMraU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V/N8XLuksk5MA93MtP65IvD7QRm6kOLDphiRkrcJ5MtaosHu31TRkakySZuHwYo90
         rogmqcWoZ1QRiAV0sCQGHVYnmySgxLFNjDVq3ptVjPJCdLefLEmfw3Xxr0wYdcVsqI
         a8gjOBcEa4AJtTZ31xzfkhuzScgblTIbwRpqpyTZQGDzunmlIOjDsw6Z1flIZPriHj
         iCyhwIKgVE1NKu81yg6j3SBZCZ+a+HvOIbtDj8bUhuzoAW6DSzIn2dzzI2h79dx7uz
         Yx9UoqFuM7S1WUqhkrgbeZo14g95py2IcmGzBLLjTtJDjj+OKBl1RsX5NBOuEiaHSh
         Cp4bLllWiFveA==
Date:   Thu, 30 Jun 2022 17:01:34 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc:     Matthew Brost <matthew.brost@intel.com>,
        Thomas =?UTF-8?B?SGVsbHN0csO2?= =?UTF-8?B?bQ==?= 
        <thomas.hellstrom@linux.intel.com>,
        Mauro Carvalho Chehab <mauro.chehab@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Thomas Hellstrom <thomas.hellstrom@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Dave Airlie <airlied@redhat.com>, stable@vger.kernel.org,
        Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        John Harrison <John.C.Harrison@intel.com>,
        Bruce Chang <yu.bruce.chang@intel.com>
Subject: Re: [PATCH 5/6] drm/i915/gt: Serialize GRDOM access between
 multiple engine resets
Message-ID: <20220630170134.3f89e0a3@sal.lan>
In-Reply-To: <9477a8f1-3535-ed7f-c491-9ca9f27a10dc@linux.intel.com>
References: <cover.1655306128.git.mchehab@kernel.org>
        <5ee647f243a774927ec328bfca8212abc4957909.1655306128.git.mchehab@kernel.org>
        <YrRLyg1IJoZpVGfg@intel.intel>
        <160e613f-a0a8-18ff-5d4b-249d4280caa8@linux.intel.com>
        <20220627110056.6dfa4f9b@maurocar-mobl2>
        <d79492ad-b99a-f9a9-f64a-52b94db68a3b@linux.intel.com>
        <20220629172955.64ffb5c3@maurocar-mobl2>
        <7e6a9a27-7286-7f21-7fec-b9832b93b10c@linux.intel.com>
        <20220630083256.35a56cb1@sal.lan>
        <9477a8f1-3535-ed7f-c491-9ca9f27a10dc@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Thu, 30 Jun 2022 09:12:41 +0100
Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> escreveu:

> On 30/06/2022 08:32, Mauro Carvalho Chehab wrote:
> > Em Wed, 29 Jun 2022 17:02:59 +0100
> > Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> escreveu:
> >  =20
> >> On 29/06/2022 16:30, Mauro Carvalho Chehab wrote: =20
> >>> On Tue, 28 Jun 2022 16:49:23 +0100
> >>> Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> wrote:
> >>>     =20
> >>>> .. which for me means a different patch 1, followed by patch 6 (moved
> >>>> to be patch 2) would be ideal stable material.
> >>>>
> >>>> Then we have the current patch 2 which is open/unknown (to me at lea=
st).
> >>>>
> >>>> And the rest seem like optimisations which shouldn't be tagged as fi=
xes.
> >>>>
> >>>> Apart from patch 5 which should be cc: stable, but no fixes as agree=
d.
> >>>>
> >>>> Could you please double check if what I am suggesting here is feasib=
le
> >>>> to implement and if it is just send those minimal patches out alone?=
 =20
> >>>
> >>> Tested and porting just those 3 patches are enough to fix the Broadwe=
ll
> >>> bug.
> >>>
> >>> So, I submitted a v2 of this series with just those. They all need to
> >>> be backported to stable. =20
> >>
> >> I would really like to give even a smaller fix a try. Something like, =
although not even compile tested:
> >>
> >> commit 4d5e94aef164772f4d85b3b4c1a46eac9a2bd680
> >> Author: Chris Wilson <chris.p.wilson@intel.com>
> >> Date:   Wed Jun 29 16:25:24 2022 +0100
> >>
> >>       drm/i915/gt: Serialize TLB invalidates with GT resets
> >>      =20
> >>       Avoid trying to invalidate the TLB in the middle of performing an
> >>       engine reset, as this may result in the reset timing out. Curren=
tly,
> >>       the TLB invalidate is only serialised by its own mutex, forgoing=
 the
> >>       uncore lock, but we can take the uncore->lock as well to seriali=
se
> >>       the mmio access, thereby serialising with the GDRST.
> >>      =20
> >>       Tested on a NUC5i7RYB, BIOS RYBDWi35.86A.0380.2019.0517.1530 with
> >>       i915 selftest/hangcheck.
> >>      =20
> >>       Cc: stable@vger.kernel.org
> >>       Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing back=
ing store")
> >>       Reported-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> >>       Tested-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> >>       Reviewed-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> >>       Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
> >>       Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> >>       Acked-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.co=
m>
> >>       Reviewed-by: Andi Shyti <andi.shyti@intel.com>
> >>       Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> >>       Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> >>
> >> diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915=
/gt/intel_gt.c
> >> index 8da3314bb6bf..aaadd0b02043 100644
> >> --- a/drivers/gpu/drm/i915/gt/intel_gt.c
> >> +++ b/drivers/gpu/drm/i915/gt/intel_gt.c
> >> @@ -952,7 +952,23 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
> >>           mutex_lock(&gt->tlb_invalidate_lock);
> >>           intel_uncore_forcewake_get(uncore, FORCEWAKE_ALL);
> >>   =20
> >> +       spin_lock_irq(&uncore->lock); /* serialise invalidate with GT =
reset */
> >> +
> >> +       for_each_engine(engine, gt, id) {
> >> +               struct reg_and_bit rb;
> >> +
> >> +               rb =3D get_reg_and_bit(engine, regs =3D=3D gen8_regs, =
regs, num);
> >> +               if (!i915_mmio_reg_offset(rb.reg))
> >> +                       continue;
> >> +
> >> +               intel_uncore_write_fw(uncore, rb.reg, rb.bit);
> >> +       }
> >> +
> >> +       spin_unlock_irq(&uncore->lock);
> >> +
> >>           for_each_engine(engine, gt, id) {
> >> +               struct reg_and_bit rb;
> >> +
> >>                   /*
> >>                    * HW architecture suggest typical invalidation time=
 at 40us,
> >>                    * with pessimistic cases up to 100us and a recommen=
dation to
> >> @@ -960,13 +976,11 @@ void intel_gt_invalidate_tlbs(struct intel_gt *g=
t)
> >>                    */
> >>                   const unsigned int timeout_us =3D 100;
> >>                   const unsigned int timeout_ms =3D 4;
> >> -               struct reg_and_bit rb;
> >>   =20
> >>                   rb =3D get_reg_and_bit(engine, regs =3D=3D gen8_regs=
, regs, num);
> >>                   if (!i915_mmio_reg_offset(rb.reg))
> >>                           continue;
> >>   =20
> >> -               intel_uncore_write_fw(uncore, rb.reg, rb.bit);
> >>                   if (__intel_wait_for_register_fw(uncore,
> >>                                                    rb.reg, rb.bit, 0,
> >>                                                    timeout_us, timeout=
_ms,
> >> =20
> >=20
> > This won't work, as it is not serializing TLB cache invalidation with
> > i915 resets. Besides that, this is more or less merging patches 1 and 3=
, =20
>=20
> Could you explain why you think it is not doing exactly that? In both=20
> versions end result is TLB flush requests are under the uncore lock and=20
> waits are outside it.

Sure, but patch 2/3 (see v2) serializes i915 reset with TLB cache changes.
This is needed in order to fix the regression.

> > placing patches with different rationales altogether. Upstream rule is
> > to have one logical change per patch. =20
>=20
> I don't think it applies in this case. It is simply splitting into two=20
> loops so lock can be held across all mmio writes. I think of it this way=
=20
> - what is the rationale for sending only the first patch to stable? What=
=20
> does it _fix_ on it's own?

There's no -stable rule enforcing that only one patch would be allowed,
nor saying that patches should be fold, doing multiple changes on as single
patch just due to "Fixes" tag.

So, while several -stable fixes can be done on a single patch, there are
fixes that will require multiple patches. That's nothing wrong with that.

The only rule is that backports should follow what's merged upstream.
So, if, in order to fix a regression, multiple patches are needed upstream,
in principle, all of those can be backported if they fit at -stable rules.

As an example, once we backported a patch series on media that had ~20 patc=
hes,
addressing security issues at the media compat32 logic (media ioctls usually
pass structs and some with pointers). As the issue was discovered several
years after compat32 got introduced, those 22 patches (some containing
compat32 redesigns) had to be backported to all maintained LTS.

-

In this specific case, fixing the regression requires 3 logical changes:

	1) Split the loop;
	2) Add serialize logic to i915 reset;
	3) use the same i915 reset spinlock to serialize TLB cache
	   invalidation.

Neither one of those logical changes alone would solve the issue. That's
why I originally added the same Fixes: to the entire series: basically,
any Kernel that has the TLB patch backported will require those
three logical changes to be backported too.

That basically will follow what's there at the Kernel process docs:

	"If your patch fixes a bug in a specific commit, e.g. you found an issue u=
sing
	 ``git bisect``, please use the 'Fixes:' tag with the first 12 characters =
of
	 the SHA-1 ID, and the one line summary."

	Documentation/process/submitting-patches.rst

See, Fixes was originally introduced to be a hint to help stable=20
and distro maintainers to identify how far they need to backport
a patch. That's mainly why I placed fixes to the entire series.=20
Yet, the same will also happen, in practice, if we place:

	Cc: stable@vger.kernel.org # Up to version 4.4

Greg, Sasha and others -stable/distro maintainers will also have a=20
(much less precise) hint about how far the backport is needed.

>> If this works it would be least painful to backport. The other improveme=
nts can then be devoid of the fixes tag. =20
> >=20
> >  From backport PoV, it wouldn't make any difference applying one patch
> > or two. See, intel_gt_invalidate_tlbs() function doesn't exist before
> > changeset 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing =
store"),
> > so, it shouldn't have merge conflicts while backporting it, maybe except
> > if some functions it calls (or parameters) have changed. On such case,
> > the backport fix should be trivial, and the end result of backporting
> > one folded patch or two would be the same. =20
>=20
> Yes a lot of things changed. Not least engine and GT pm code. Note that=20
> TLB flushing was backported all the way to 4.4 so any hunk you don't=20
> strictly need can and will bite you. I have attached a tarball of=20
> patches for you to explore. :)
> Regards,

Thanks! That's very helpful to check the amount of work. It makes easy
to use interdiff and (k)diff3 to check what changed.

=46rom it, the differences between 5.4 and 5.16 at intel_gt_invalidate_tlbs()
are really trivial.

On 4.14, the function was added on a different file (intel_gem), and
there were a few more API differences, as only gen8 code is there,
but again, the changes are trivial: mostly macros/functions were renamed
and some function parameters changed.

=46rom 4.9 to 4.14 there were also some changes but they also look trivial.

Kernel 4.4 has some other differences - the loop logic is different, and
there's a ring initialization function, but, as version 4.4 is not listed
anymore as LTS at kernel.org, we probably need to backport only up to
4.9.

All the above should be affecting patch v2 1/3. Patches v2 2/3 and 3/3 just
have spin lock/unlock for the gt uncore spinlock. Those will very likely
require some work on Kernels 4.x, but folding (or not) the patches won't
really help.

Regards,
Mauro
