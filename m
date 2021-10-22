Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFC3436F55
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 03:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbhJVBWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 21:22:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhJVBWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Oct 2021 21:22:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4C286101C;
        Fri, 22 Oct 2021 01:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634865636;
        bh=g7zKhZ0KPLiGMSOh1+9QyItNNSQJciCAUhhGDw/w/Cw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=IYtrB4qYTLoAuY2+Htoys6JdZdGgpg9MIQOp7AMX3K1rhifnCG2Cn98+65O8GSANq
         c+OcW5mi8Lj+BA6HjWW173YvSJ66nKXi0tPMcBKzrNnBayfDFynpyYscOFFdRIWV4/
         GNMXkiasr+d7FC8LUV74UN5oYMsAnY26xzImFyy4rQGGmOeL9ai/wiLmhycD7Cri6p
         xE2mInhF5fKRa+WeMjseh9okNhNWsgJuxA5Ax3/dryUboH/+qKImXuIlv85G2iHwtV
         qB8x6dT1GdOzDGJ5Es43hnFzVxZJJo/cJN0VBZYCLU8Gtj+8rrnof9s5FNovRCVKHQ
         w1lj+uSL/e50Q==
Date:   Thu, 21 Oct 2021 20:20:34 -0500
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
Message-ID: <20211022012034.GA2703195@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73aeec22-2ec7-ff21-5c89-c13f2e90a213@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 21, 2021 at 07:15:57PM +0200, Hans de Goede wrote:
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
> 
> It is a 10 year old BIOS defect, so hopefully anything from 2018
> or later will not have it.

We can hope.  AFAIK, Windows allocates space top-down, while Linux
allocates bottom-up, so I think it's quite possible these defects
would never be discovered or fixed.  In any event, I don't think we
have much evidence either way.

> > I'm not sure there's significant benefit to having this in v5.15.
> > Yes, the mainline v5.15 kernel would work on the affected machines,
> > but I suspect most people with those machines are running distro
> > kernels, not mainline kernels.
> 
> Fedora and Arch do follow mainline pretty closely and a lot of
> users are affected by this (see the large number of BugLinks in
> the commit).
> 
> I completely understand why you are reluctant to push this out, but
> your argument about most distros not running mainline kernels also
> applies to chances of people where this may cause a regression
> running mainline kernels also being quite small.

True.

> > This issue has been around a long time, so it's not like a regression
> > that we just introduced.  If we fixed these machines and regressed
> > *other* machines, we'd be worse off than we are now.
> 
> If we break one machine model and fix a whole bunch of other machines
> then in my book that is a win. Ideally we would not break anything,
> but we can only find out if we actually break anything if we ship
> the change.

I'm definitely not going to try the "fix many, break one" argument on
Linus.  Of course we want to fix systems, but IMO it's far better to
leave a system broken than it is to break one that used to work.

> > In the meantime, here's another possibility for working around this.
> > What if we discarded remove_e820_regions() completely, but aligned the
> > problem _CRS windows a little more?  The 4dc2287c1805 case was this:
> > 
> >   BIOS-e820: 00000000bfe4dc00 - 00000000c0000000 (reserved)
> >   pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xdfffffff]
> > 
> > where the _CRS window was of size 0x20100000, i.e., 512M + 1M.  At
> > least in this particular case, we could avoid the problem by throwing
> > away that first 1M and aligning the window to a nice 3G boundary.
> > Maybe it would be worth giving up a small fraction (less than 0.2% in
> > this case) of questionable windows like this?
> 
> The PCI BAR allocation code tries to fall back to the BIOS assigned
> resource if the allocation fails. That BIOS assigned resource might
> fall outside of the host bridge window after we round the address.
> 
> My initial gut instinct here is that this has a bigger chance
> of breaking things then my change.
> 
> In the beginning of the thread you said that ideally we would
> completely stop using the E820 reservations for PCI host bridge
> windows. Because in hindsight messing with the windows on all
> machines just to work around a clear BIOS bug in some was not a
> good idea.
> 
> This address-rounding/-aligning you now suggest, is again
> messing with the windows on all machines just to work around
> a clear BIOS bug in some. At least that is how I see this.

That's true.  I assume Red Hat has a bunch of machines and hopefully
an archive of dmesg logs from them.  Those logs should contain good
E820 and _CRS information, so with a little scripting, maybe we could
get some idea of what's out there.

Bjorn
