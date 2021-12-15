Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA33D475C91
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 17:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbhLOQBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 11:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbhLOQBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 11:01:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F140C061574;
        Wed, 15 Dec 2021 08:01:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA2F4618A9;
        Wed, 15 Dec 2021 16:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3D8C36B1E;
        Wed, 15 Dec 2021 16:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639584107;
        bh=GBwdoRdSPGRpBbNNoPSHpiQpTtDQIVFhDXrpKtzl0jU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=uce6mGOKP2vE6+M+8Tr9l9xYoqNQDdsTbqGoJJNTkYxhaz5j2uiB+oxyYbARQwkwn
         NEBFRFZTW8Z3vIGbfCWnCWSq0QHuJeqkUQB1P2cYN7bRVlC/SUIK8nHxdHo5Q8Vb5M
         v/8wPaLoxwKuZSvDatYuyh5xIlDPBxU/eVsGOFGEEzYApmFKlkHGsVnnpdkugZjVq2
         OCzAZQ8hiHP1qkVgG5g0feZcC6eRiDHyFQ9foTyfQGEsBFhLtHIkrjjHBMKc4V8+Fj
         oRf6g6vxvkTABqhvbXdo3lTWKnh4jVzGtkjD9R9Up9Jfnfr7KoDD6qmqPWG5OPFSn4
         /61GWk1+QmDdQ==
Date:   Wed, 15 Dec 2021 10:01:45 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Benoit =?iso-8859-1?Q?Gr=E9goire?= <benoitg@coeus.ca>,
        Hui Wang <hui.wang@canonical.com>, stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v5 1/2] x86/PCI: Ignore E820 reservations for bridge
 windows on newer systems
Message-ID: <20211215160145.GA695366@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cfab16c-5edc-dbff-b73e-65419a649ac2@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 07, 2021 at 05:52:40PM +0100, Hans de Goede wrote:
> On 11/10/21 14:05, Hans de Goede wrote:
> > On 11/10/21 09:45, Hans de Goede wrote:
> >> On 11/9/21 23:07, Bjorn Helgaas wrote:
> >>> On Sat, Nov 06, 2021 at 11:15:07AM +0100, Hans de Goede wrote:
> >>>> On 10/20/21 23:14, Bjorn Helgaas wrote:
> >>>>> On Wed, Oct 20, 2021 at 12:23:26PM +0200, Hans de Goede wrote:
> >>>>>> On 10/19/21 23:52, Bjorn Helgaas wrote:
> >>>>>>> On Thu, Oct 14, 2021 at 08:39:42PM +0200, Hans de Goede wrote:
> >>>>>>>> Some BIOS-es contain a bug where they add addresses which map to system
> >>>>>>>> RAM in the PCI host bridge window returned by the ACPI _CRS method, see
> >>>>>>>> commit 4dc2287c1805 ("x86: avoid E820 regions when allocating address
> >>>>>>>> space").
> >>>>>>>>
> >>>>>>>> To work around this bug Linux excludes E820 reserved addresses when
> >>>>>>>> allocating addresses from the PCI host bridge window since 2010.
> >>>>>>>> ...
> >>>>>
> >>>>>>> I haven't seen anybody else eager to merge this, so I guess I'll stick
> >>>>>>> my neck out here.
> >>>>>>>
> >>>>>>> I applied this to my for-linus branch for v5.15.
> >>>>>>
> >>>>>> Thank you, and sorry about the build-errors which the lkp
> >>>>>> kernel-test-robot found.
> >>>>>>
> >>>>>> I've just send out a patch which fixes these build-errors
> >>>>>> (verified with both .config-s from the lkp reports).
> >>>>>> Feel free to squash this into the original patch (or keep
> >>>>>> them separate, whatever works for you).
> >>>>>
> >>>>> Thanks, I squashed the fix in.
> >>>>>
> >>>>> HOWEVER, I think it would be fairly risky to push this into v5.15.
> >>>>> We would be relying on the assumption that current machines have all
> >>>>> fixed the BIOS defect that 4dc2287c1805 addressed, and we have little
> >>>>> evidence for that.
> >>>>>
> >>>>> I'm not sure there's significant benefit to having this in v5.15.
> >>>>> Yes, the mainline v5.15 kernel would work on the affected machines,
> >>>>> but I suspect most people with those machines are running distro
> >>>>> kernels, not mainline kernels.
> >>>>
> >>>> I understand that you were reluctant to add this to 5.15 so close
> >>>> near the end of the 5.15 cycle, but can we please get this into
> >>>> 5.16 now ?
> >>>>
> >>>> I know you ultimately want to see if there is a better fix,
> >>>> but this is hitting a *lot* of users right now and if we come up
> >>>> with a better fix we can always use that to replace this one
> >>>> later.
> >>>
> >>> I don't know whether there's a "better" fix, but I do know that if we
> >>> merge what we have right now, nobody will be looking for a better
> >>> one.
> >>>
> >>> We're in the middle of the merge window, so the v5.16 development
> >>> cycle is over.  The v5.17 cycle is just starting, so we have time to
> >>> hit that.  Obviously a fix can be backported to older kernels as
> >>> needed.
> >>>
> >>>> So can we please just go with this fix now, so that we can
> >>>> fix the issues a lot of users are seeing caused by the current
> >>>> *wrong* behavior of taking the e820 reservations into account ?
> >>>
> >>> I think the fix on the table is "ignore E820 for BIOS date >= 2018"
> >>> plus the obvious parameters to force it both ways.
> >>
> >> Correct.
> >>
> >>> The thing I don't like is that this isn't connected at all to the
> >>> actual BIOS defect.  We have no indication that current BIOSes have
> >>> fixed the defect,
> >>
> >> We also have no indication that that defect from 10 years ago, from
> >> pre UEFI firmware is still present in modern day UEFI firmware which
> >> is basically an entire different code-base.
> >>
> >> And even 10 years ago the problem was only happening to a single
> >> family of laptop models (Dell Precision laptops) so this clearly
> >> was a bug in that specific implementation and not some generic
> >> issue which is likely to be carried forward.
> >>
> >>> and we have no assurance that future ones will not
> >>> have the defect.  It would be better if we had some algorithmic way of
> >>> figuring out what to do.
> >>
> >> You yourself have said that in hindsight taking E820 reservations
> >> into account for PCI bridge host windows was a mistake. So what
> >> the "ignore E820 for BIOS date >= 2018" is doing is letting the
> >> past be the past (without regressing on older models) while fixing
> >> that mistake on any hardware going forward.
> >>
> >> In the unlikely case that we hit that BIOS bug again on 1 or 2 models,
> >> we can simply DMI quirk those models, as we do for countless other
> >> BIOS issues.
> >>
> >>> Thank you very much for chasing down the dmesg log archive
> >>> (https://github.com/linuxhw/Dmesg; see
> >>> https://lore.kernel.org/r/82035130-d810-9f0b-259e-61280de1d81f@redhat.com).
> >>> Unfortunately I haven't had time to look through it myself, and I
> >>> haven't heard of anybody else doing it either.
> >>
> >> Right, I'm afraid that I already have spend way too much time on this
> >> myself. Note that I've been working with users on this bug on and off
> >> for over a year now.
> >>
> >> This is hitting many users and now that we have a viable fix, this
> >> really needs to be fixed now.
> >>
> >> I believe that the "ignore E820 for BIOS date >= 2018" fix is good
> >> enough and that you are letting perfect be the enemy of good here.
> >>
> >> As an upstream kernel maintainer myself, I'm sorry to say this,
> >> but if we don't get some fix for this merged soon you are leaving
> >> my no choice but to add my fix to the Fedora kernels as a downstream
> >> patch (and to advise other distros to do the same).
> >>
> >> Note that if you are still afraid of regressions going the downstream
> >> route is also an opportunity, Fedora will start testing moving users
> >> to 5.15.y soon, so I could add the patch to Fedora's 5.15.y builds and
> >> see how that goes ?
> > 
> > So I've discussed this with the Fedora kernel maintainers and they have
> > agreed to add the patch to the Fedora 5.15 kernels, which we will ask
> > our users to start testing soon (we first run some voluntary testing
> > before eventually moving all users over).
> > 
> > This will provide us with valuable feedback wrt this patch causing
> > regressions as you are worried about, or not.
> > 
> > Assuming no regressions show up I hope that this will give you
> > some assurance that there the patch causes no regressions and that
> > you will then be willing to pick this up later during the 5.16
> > cycle so that Fedora only deviates from upstream for 1 cycle.
> 
> 5.15.y kernels with this patch added have been in Fedora's
> stable updates repo for a while now without any reports of the
> regressions you feared this may cause.
> 
> Bjorn, I hope that you are willing to merge this patch now that it has
> seen some more wide spread testing ?

I'm still not happy about the idea of basing this on BIOS dates.  I
did this with 7bc5e3f2be32 ("x86/PCI: use host bridge _CRS info by
default on 2008 and newer machines"), and it was a mistake.

Because of that mistake, we now have the use_crs/nocrs kernel
parameters, which confuse users and lead to them being passed around
as "fixes" on random bulletin boards.

Adding another BIOS date check and use_e820/no_e820 kernel parameters
feels like it's layering on more complexity to cover up another major
mistake I made, 4dc2287c1805 ("x86: avoid E820 regions when allocating
address space").

I think it would be better for the code to recognize the situation
addressed by 4dc2287c1805 and deal with it directly.  Is that
possible?  I dunno; I don't think we've really tried.

Bjorn
