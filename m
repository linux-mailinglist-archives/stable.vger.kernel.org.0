Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6864340DE
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 23:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbhJSV5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 17:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhJSV5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 17:57:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2730161260;
        Tue, 19 Oct 2021 21:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634680508;
        bh=k8/6DG7Gf2l0QXlkRyX6y3iUIQXOBGnkd5657VOQQA4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Fax3yqYqNGg3N08Y+4+3iEZixE+nIKZolAfgragJsxeDSoYNqsS8ZBnmsZYKw8mo4
         zve70NBrjQnDfrFxB92w+w16AHTqikE+RZ1xPkHeKkCGiwAU09zMNimobQtnykFA8G
         M1ce2nnqRbr+P5eSqu6KHbGnH+0ud0uoMQbkCYh9v4OKLkO77PL7c3TqxuXEvYqYzO
         FEMbvzhAAvKb8wwzrQjasn3BnLK3hG5LOQi68ZtZTGec6mrY1xeEetZK6xFvA3DN+E
         IzWB1c8pW4PAyhN0QN5tjloz8TA/9B0+erE+czyyekpIv4WTvhShl4sOSE/JpWug7Z
         PcLWjJVxzXeag==
Date:   Tue, 19 Oct 2021 16:55:06 -0500
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
Message-ID: <20211019215506.GA2411878@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211019215240.GA2411590@bhelgaas>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 19, 2021 at 04:52:42PM -0500, Bjorn Helgaas wrote:
> On Thu, Oct 14, 2021 at 08:39:42PM +0200, Hans de Goede wrote:
> > Some BIOS-es contain a bug where they add addresses which map to system
> > RAM in the PCI host bridge window returned by the ACPI _CRS method, see
> > commit 4dc2287c1805 ("x86: avoid E820 regions when allocating address
> > space").
> > 
> > To work around this bug Linux excludes E820 reserved addresses when
> > allocating addresses from the PCI host bridge window since 2010.
> > 
> > Recently (2020) some systems have shown-up with E820 reservations which
> > cover the entire _CRS returned PCI bridge memory window, causing all
> > attempts to assign memory to PCI BARs which have not been setup by the
> > BIOS to fail. For example here are the relevant dmesg bits from a
> > Lenovo IdeaPad 3 15IIL 81WE:
> > 
> >  [mem 0x000000004bc50000-0x00000000cfffffff] reserved
> >  pci_bus 0000:00: root bus resource [mem 0x65400000-0xbfffffff window]
> > 
> > The ACPI specifications appear to allow this new behavior:
> > 
> > The relationship between E820 and ACPI _CRS is not really very clear.
> > ACPI v6.3, sec 15, table 15-374, says AddressRangeReserved means:
> > 
> >   This range of addresses is in use or reserved by the system and is
> >   not to be included in the allocatable memory pool of the operating
> >   system's memory manager.
> > 
> > and it may be used when:
> > 
> >   The address range is in use by a memory-mapped system device.
> > 
> > Furthermore, sec 15.2 says:
> > 
> >   Address ranges defined for baseboard memory-mapped I/O devices, such
> >   as APICs, are returned as reserved.
> > 
> > A PCI host bridge qualifies as a baseboard memory-mapped I/O device,
> > and its apertures are in use and certainly should not be included in
> > the general allocatable pool, so the fact that some BIOS-es reports
> > the PCI aperture as "reserved" in E820 doesn't seem like a BIOS bug.
> > 
> > So it seems that the excluding of E820 reserved addresses is a mistake.
> > 
> > Ideally Linux would fully stop excluding E820 reserved addresses,
> > but then the old systems this was added for will regress.
> > Instead keep the old behavior for old systems, while ignoring
> > the E820 reservations for any systems from now on.
> > 
> > Old systems are defined here as BIOS year < 2018, this was chosen to
> > make sure that pci_use_e820 will not be set on the currently affected
> > systems, while at the same time also taking into account that the
> > systems for which the E820 checking was originally added may have
> > received BIOS updates for quite a while (esp. CVE related ones),
> > giving them a more recent BIOS year then 2010.
> > 
> > Also add pci=no_e820 and pci=use_e820 options to allow overriding
> > the BIOS year heuristic.
> > 
> > BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206459
> > BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1868899
> > BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1871793
> > BugLink: https://bugs.launchpad.net/bugs/1878279
> > BugLink: https://bugs.launchpad.net/bugs/1931715
> > BugLink: https://bugs.launchpad.net/bugs/1932069
> > BugLink: https://bugs.launchpad.net/bugs/1921649
> > Cc: Benoit Grégoire <benoitg@coeus.ca>
> > Cc: Hui Wang <hui.wang@canonical.com>
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> 
> I haven't seen anybody else eager to merge this, so I guess I'll stick
> my neck out here.
> 
> I applied this to my for-linus branch for v5.15.

(I only applied patch 1/2, to fix the PCI BAR assignments.  The 2/2
patch to convert printk to pr_info might be nice, but definitely not
-rc7 material.  I'm hesitant enough about 1/2.)
