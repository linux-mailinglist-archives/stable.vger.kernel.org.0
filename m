Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42EE44B51E
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244530AbhKIWKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235632AbhKIWKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:10:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3CE460524;
        Tue,  9 Nov 2021 22:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636495639;
        bh=+qSgvYpQTfGO4XzzrvtjFVSaT33ud9DXLSG7u/nEfKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=fq2dTkrvLVbcHQygx3bgnOZwesHj+kuGNINPDowb8PKPAyzzmrBcWAyRx2ZFunkUg
         0if6hh7IFlxwkpFpQ/F/W+qj0jQbhbDctVE1h9yVj1rWbWu1hnNEGYTQ53Kp8XOVv/
         81mCqvd37Kktfx/b7Lvje2zcE/wAvz6kTxcGoFLsmIi2ZH6r9AWIRJtDASK6VwZnrk
         Dr1GkmXmlbDggxypf9yCBwIcCsohexJTK1Dz6cZ1AUEAFzl4AlU7f/HMbZyl4WhmHi
         WYvVagrMdUsemxqWIHAIOK3Czdsk8kuiprhR8JKmEdQFU1YFH3Fg7k0IkY+3bySgMP
         Mz2Yt9vWcEBRA==
Date:   Tue, 9 Nov 2021 16:07:17 -0600
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
Message-ID: <20211109220717.GA1187103@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c85a917e-143d-1218-61fa-e4f4810c4950@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 06, 2021 at 11:15:07AM +0100, Hans de Goede wrote:
> On 10/20/21 23:14, Bjorn Helgaas wrote:
> > On Wed, Oct 20, 2021 at 12:23:26PM +0200, Hans de Goede wrote:
> >> On 10/19/21 23:52, Bjorn Helgaas wrote:
> >>> On Thu, Oct 14, 2021 at 08:39:42PM +0200, Hans de Goede wrote:
> >>>> Some BIOS-es contain a bug where they add addresses which map to system
> >>>> RAM in the PCI host bridge window returned by the ACPI _CRS method, see
> >>>> commit 4dc2287c1805 ("x86: avoid E820 regions when allocating address
> >>>> space").
> >>>>
> >>>> To work around this bug Linux excludes E820 reserved addresses when
> >>>> allocating addresses from the PCI host bridge window since 2010.
> >>>> ...
> > 
> >>> I haven't seen anybody else eager to merge this, so I guess I'll stick
> >>> my neck out here.
> >>>
> >>> I applied this to my for-linus branch for v5.15.
> >>
> >> Thank you, and sorry about the build-errors which the lkp
> >> kernel-test-robot found.
> >>
> >> I've just send out a patch which fixes these build-errors
> >> (verified with both .config-s from the lkp reports).
> >> Feel free to squash this into the original patch (or keep
> >> them separate, whatever works for you).
> > 
> > Thanks, I squashed the fix in.
> > 
> > HOWEVER, I think it would be fairly risky to push this into v5.15.
> > We would be relying on the assumption that current machines have all
> > fixed the BIOS defect that 4dc2287c1805 addressed, and we have little
> > evidence for that.
> >
> > I'm not sure there's significant benefit to having this in v5.15.
> > Yes, the mainline v5.15 kernel would work on the affected machines,
> > but I suspect most people with those machines are running distro
> > kernels, not mainline kernels.
> 
> I understand that you were reluctant to add this to 5.15 so close
> near the end of the 5.15 cycle, but can we please get this into
> 5.16 now ?
> 
> I know you ultimately want to see if there is a better fix,
> but this is hitting a *lot* of users right now and if we come up
> with a better fix we can always use that to replace this one
> later.

I don't know whether there's a "better" fix, but I do know that if we
merge what we have right now, nobody will be looking for a better
one.

We're in the middle of the merge window, so the v5.16 development
cycle is over.  The v5.17 cycle is just starting, so we have time to
hit that.  Obviously a fix can be backported to older kernels as
needed.

> So can we please just go with this fix now, so that we can
> fix the issues a lot of users are seeing caused by the current
> *wrong* behavior of taking the e820 reservations into account ?

I think the fix on the table is "ignore E820 for BIOS date >= 2018"
plus the obvious parameters to force it both ways.

The thing I don't like is that this isn't connected at all to the
actual BIOS defect.  We have no indication that current BIOSes have
fixed the defect, and we have no assurance that future ones will not
have the defect.  It would be better if we had some algorithmic way of
figuring out what to do.

Thank you very much for chasing down the dmesg log archive
(https://github.com/linuxhw/Dmesg; see
https://lore.kernel.org/r/82035130-d810-9f0b-259e-61280de1d81f@redhat.com).
Unfortunately I haven't had time to look through it myself, and I
haven't heard of anybody else doing it either.

Bjorn
