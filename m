Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D78489E12
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 18:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237961AbiAJRL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 12:11:29 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49110 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbiAJRL3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 12:11:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D620CCE1677;
        Mon, 10 Jan 2022 17:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069ADC36AE3;
        Mon, 10 Jan 2022 17:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641834685;
        bh=X4tXoAGC6EqJ6PYEuG6VCZ/OpyF8blgVmWjeySllZjQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=empKVpZSr2IPSLiNwSMhcQyNj0YdWaPaD1kHUE2YOI95Bc0/xHllJHIJ2w1eEzItk
         /Ag9iEjQ3tvNVUjQAshIVIgB45mBrjIjVtKRi8YNTDjz+bQBRZ5zhIrAEbIfK2cl/O
         nV/x3qj6KAdajx7F49Vj2GjPUATphHfNsrWBQDLX+v9iT6ERZGqZAYtL/h0G7KN8d2
         rNnds4Y5qmTQl76eEdPBPUi5zK+i2Wv/Vrn1khMtXibf5x9NkOZuT+e5ti4YCF7yAT
         V2HXSP8zsyVFd650EoK0kLpV1tLdSy+ICmWVXJYdIw1fKPjUe886ijAQihynoApjBy
         jEAvK1ta7unvg==
Date:   Mon, 10 Jan 2022 11:11:23 -0600
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
Subject: Re: [PATCH v6] x86/PCI: Ignore E820 reservations for bridge windows
 on newer systems
Message-ID: <20220110171123.GA60297@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c992ece7-6878-a39e-0386-5a499265c4cb@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 10, 2022 at 12:41:37PM +0100, Hans de Goede wrote:
> Hi All,
> 
> On 12/17/21 15:13, Hans de Goede wrote:
> > Some BIOS-es contain a bug where they add addresses which map to system
> > RAM in the PCI host bridge window returned by the ACPI _CRS method, see
> > commit 4dc2287c1805 ("x86: avoid E820 regions when allocating address
> > space").
> > 
> > To work around this bug Linux excludes E820 reserved addresses when
> > allocating addresses from the PCI host bridge window since 2010.
> > 
> > Recently (2019) some systems have shown-up with E820 reservations which
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
> > Old systems are defined here as BIOS year < 2018, this was chosen to make
> > sure that E820 reservations will not be used on the currently affected
> > systems, while at the same time also taking into account that the systems
> > for which the E820 checking was originally added may have received BIOS
> > updates for quite a while (esp. CVE related ones), giving them a more
> > recent BIOS year then 2010.
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
> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> > ---
> > Changes in v6:
> > - Remove the possibility to change the behavior from the commandline
> >   because of worries that users may use this to paper over other problems
> 
> ping ?

Thanks, Hans.  Maybe I'm quixotic, but I'm still hoping for an
approach based on firmware behavior instead of firmware date.  If
nobody else tries, I will eventually try myself, but I don't have any
ETA.

Bjorn
