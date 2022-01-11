Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF2548AF10
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 15:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbiAKOCj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 11 Jan 2022 09:02:39 -0500
Received: from mail-qt1-f180.google.com ([209.85.160.180]:37725 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238129AbiAKOCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 09:02:39 -0500
Received: by mail-qt1-f180.google.com with SMTP id c15so18163311qtc.4;
        Tue, 11 Jan 2022 06:02:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XuRUuLBL0LO4l/7Vzw5hsRxoKoTaJt1gWWvfirCSVGU=;
        b=W61eZWziCTqZnpxJyizO7pYL+8iEgY99XsuvrURS/mgfP+S/+mfNPgnpn2zrEt3vVi
         V/UqREa9urncP23/VS6fGQEfXFJ9z6ScEjfcqnle/qk5DrPewfKlMKi7ZgxbJJceDwJt
         AcQ3A6i3zlDaQoj5q9oQoI6Y5htg+324vSUA6R7YCx49IWDZ2m8uwb9Iax5a0UuMl5p0
         KW+9sSOHirz6EAgqzUhzHzd2FwYLLrgzlVawgkgDo9PWSPHpb2OtHEwZKUxK0T8Hq1s5
         F52gxH3nboC/ZPW0qErirs1SsEimSg0jY7cg1wCUHgpc0LAfxhqc7NNw7Z+38KwXHcG7
         vgSg==
X-Gm-Message-State: AOAM532VJDEFUEl/CGpIqoqU3XDHQH4wZjdBM1/GaZHpX3vdXiMhToB4
        g9fMSo+Xf6AncZCuAuKdR3wIte1Pl7izaF3DrSc=
X-Google-Smtp-Source: ABdhPJzXA7cm/2zBttHyL3oyAnskPD0Lo3P6S49TZ9PZ0l0J7HO3gc8HjpKSmEm4UxxOWKD0TgiTdibTD1Zt+RHCuTk=
X-Received: by 2002:a05:622a:44e:: with SMTP id o14mr3696357qtx.369.1641909757395;
 Tue, 11 Jan 2022 06:02:37 -0800 (PST)
MIME-Version: 1.0
References: <20220110171123.GA60297@bhelgaas> <3f85e298-2e55-2190-21b7-596cfc8388aa@redhat.com>
In-Reply-To: <3f85e298-2e55-2190-21b7-596cfc8388aa@redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 11 Jan 2022 15:02:26 +0100
Message-ID: <CAJZ5v0gdK1ULNztKE3OARkm46iwz9LUcCYHvOkKsOm3LSx+d8A@mail.gmail.com>
Subject: Re: [PATCH v6] x86/PCI: Ignore E820 reservations for bridge windows
 on newer systems
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Benoit_Gr=C3=A9goire?= <benoitg@coeus.ca>,
        Hui Wang <hui.wang@canonical.com>,
        Stable <stable@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 10, 2022 at 10:25 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> On 1/10/22 18:11, Bjorn Helgaas wrote:
> > On Mon, Jan 10, 2022 at 12:41:37PM +0100, Hans de Goede wrote:
> >> Hi All,
> >>
> >> On 12/17/21 15:13, Hans de Goede wrote:
> >>> Some BIOS-es contain a bug where they add addresses which map to system
> >>> RAM in the PCI host bridge window returned by the ACPI _CRS method, see
> >>> commit 4dc2287c1805 ("x86: avoid E820 regions when allocating address
> >>> space").
> >>>
> >>> To work around this bug Linux excludes E820 reserved addresses when
> >>> allocating addresses from the PCI host bridge window since 2010.
> >>>
> >>> Recently (2019) some systems have shown-up with E820 reservations which
> >>> cover the entire _CRS returned PCI bridge memory window, causing all
> >>> attempts to assign memory to PCI BARs which have not been setup by the
> >>> BIOS to fail. For example here are the relevant dmesg bits from a
> >>> Lenovo IdeaPad 3 15IIL 81WE:
> >>>
> >>>  [mem 0x000000004bc50000-0x00000000cfffffff] reserved
> >>>  pci_bus 0000:00: root bus resource [mem 0x65400000-0xbfffffff window]
> >>>
> >>> The ACPI specifications appear to allow this new behavior:
> >>>
> >>> The relationship between E820 and ACPI _CRS is not really very clear.
> >>> ACPI v6.3, sec 15, table 15-374, says AddressRangeReserved means:
> >>>
> >>>   This range of addresses is in use or reserved by the system and is
> >>>   not to be included in the allocatable memory pool of the operating
> >>>   system's memory manager.
> >>>
> >>> and it may be used when:
> >>>
> >>>   The address range is in use by a memory-mapped system device.
> >>>
> >>> Furthermore, sec 15.2 says:
> >>>
> >>>   Address ranges defined for baseboard memory-mapped I/O devices, such
> >>>   as APICs, are returned as reserved.
> >>>
> >>> A PCI host bridge qualifies as a baseboard memory-mapped I/O device,
> >>> and its apertures are in use and certainly should not be included in
> >>> the general allocatable pool, so the fact that some BIOS-es reports
> >>> the PCI aperture as "reserved" in E820 doesn't seem like a BIOS bug.
> >>>
> >>> So it seems that the excluding of E820 reserved addresses is a mistake.
> >>>
> >>> Ideally Linux would fully stop excluding E820 reserved addresses,
> >>> but then the old systems this was added for will regress.
> >>> Instead keep the old behavior for old systems, while ignoring
> >>> the E820 reservations for any systems from now on.
> >>>
> >>> Old systems are defined here as BIOS year < 2018, this was chosen to make
> >>> sure that E820 reservations will not be used on the currently affected
> >>> systems, while at the same time also taking into account that the systems
> >>> for which the E820 checking was originally added may have received BIOS
> >>> updates for quite a while (esp. CVE related ones), giving them a more
> >>> recent BIOS year then 2010.
> >>>
> >>> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206459
> >>> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1868899
> >>> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1871793
> >>> BugLink: https://bugs.launchpad.net/bugs/1878279
> >>> BugLink: https://bugs.launchpad.net/bugs/1931715
> >>> BugLink: https://bugs.launchpad.net/bugs/1932069
> >>> BugLink: https://bugs.launchpad.net/bugs/1921649
> >>> Cc: Benoit Grégoire <benoitg@coeus.ca>
> >>> Cc: Hui Wang <hui.wang@canonical.com>
> >>> Cc: stable@vger.kernel.org
> >>> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >>> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> >>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >>> ---
> >>> Changes in v6:
> >>> - Remove the possibility to change the behavior from the commandline
> >>>   because of worries that users may use this to paper over other problems
> >>
> >> ping ?
> >
> > Thanks, Hans.  Maybe I'm quixotic, but I'm still hoping for an
> > approach based on firmware behavior instead of firmware date.  If
> > nobody else tries, I will eventually try myself, but I don't have any
> > ETA.
>
> I really do NOT see how doing a better approach later blocks
> merging the date based fix now ?
>
> The date based approach can simply be replaced by any better
> solution later.

Agreed.

> Can we please merge the date based approach now so peoples broken
> systems get fixed now, rather then at some unknown later time ?

OK, I'll queue it up.  Thanks!
