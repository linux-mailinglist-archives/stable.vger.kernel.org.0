Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECAE435526
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 23:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhJTVRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 17:17:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231445AbhJTVRM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 17:17:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C3ED610EA;
        Wed, 20 Oct 2021 21:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634764497;
        bh=V/+W4v5tNf/2ivT8N+EbTjrcdmFRUPSG/ga808dBaC4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=R/f+9p4e76pt2xgbttYPaiEwLEWIMzADvFUB/0U6ij35Y3LB6ATEJpgLLGSSC4TOu
         6Ry7EHkWcrNypsT0HXUmmcCVg56VN0sAxtFq21gVNO3yYCFXI7jqC0/WYC4I6l4uA+
         sH9FC4JfzD1tcsK936Zox75YD3Jf+t2dMm7KLZb63x5K/HpjjROoNfF1vUwG8qgkBx
         yN6xm0N/xngEqEFLgWXcDRrrexGvdr2b1jCdhexqeuKwlPnaz3nShceWS9Ey+7RDpE
         ekXEHip7TDoZz1BYEkzETe2ooqkHYVtLh/VyQ4nsWxyDBm31z/6i9WUrfXo/Bla8X6
         m9WA40qY89eMQ==
Date:   Wed, 20 Oct 2021 16:14:55 -0500
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
Message-ID: <20211020211455.GA2641031@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfbac749-7434-1497-039b-3b8bc4dc5499@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 20, 2021 at 12:23:26PM +0200, Hans de Goede wrote:
> On 10/19/21 23:52, Bjorn Helgaas wrote:
> > On Thu, Oct 14, 2021 at 08:39:42PM +0200, Hans de Goede wrote:
> >> Some BIOS-es contain a bug where they add addresses which map to system
> >> RAM in the PCI host bridge window returned by the ACPI _CRS method, see
> >> commit 4dc2287c1805 ("x86: avoid E820 regions when allocating address
> >> space").
> >>
> >> To work around this bug Linux excludes E820 reserved addresses when
> >> allocating addresses from the PCI host bridge window since 2010.
> >> ...

> > I haven't seen anybody else eager to merge this, so I guess I'll stick
> > my neck out here.
> > 
> > I applied this to my for-linus branch for v5.15.
> 
> Thank you, and sorry about the build-errors which the lkp
> kernel-test-robot found.
> 
> I've just send out a patch which fixes these build-errors
> (verified with both .config-s from the lkp reports).
> Feel free to squash this into the original patch (or keep
> them separate, whatever works for you).

Thanks, I squashed the fix in.

HOWEVER, I think it would be fairly risky to push this into v5.15.
We would be relying on the assumption that current machines have all
fixed the BIOS defect that 4dc2287c1805 addressed, and we have little
evidence for that.

I'm not sure there's significant benefit to having this in v5.15.
Yes, the mainline v5.15 kernel would work on the affected machines,
but I suspect most people with those machines are running distro
kernels, not mainline kernels.

This issue has been around a long time, so it's not like a regression
that we just introduced.  If we fixed these machines and regressed
*other* machines, we'd be worse off than we are now.

Convince me otherwise if you see this differently :)

In the meantime, here's another possibility for working around this.
What if we discarded remove_e820_regions() completely, but aligned the
problem _CRS windows a little more?  The 4dc2287c1805 case was this:

  BIOS-e820: 00000000bfe4dc00 - 00000000c0000000 (reserved)
  pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xdfffffff]

where the _CRS window was of size 0x20100000, i.e., 512M + 1M.  At
least in this particular case, we could avoid the problem by throwing
away that first 1M and aligning the window to a nice 3G boundary.
Maybe it would be worth giving up a small fraction (less than 0.2% in
this case) of questionable windows like this?

Bjorn
