Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D25507CD8
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 00:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358336AbiDSWw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 18:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbiDSWw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 18:52:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353791D305;
        Tue, 19 Apr 2022 15:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F34B8B81CAD;
        Tue, 19 Apr 2022 22:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C59C385A7;
        Tue, 19 Apr 2022 22:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650408610;
        bh=6wVwcM+rCSuWgB240PgHPKTV1wdSBpdLNlDmNfUHYe4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=uVRFnvmi0zheCB8Z/P9yjO1I2s46oeQIwZQDTTp+v5e/TotS5XSXd3cblWCLUaTgD
         fMgAHT6ZfvLgJknSZdJ96VCRnoAM2wRI3wA8+F99QrmLXRfZHojQn8OB021Viycez7
         8yfNhpFQD2gqjHExgdf/a0XrlejuR7YjU28Q9Au7bRexN3LpOFnfRXuGN7nETkfZuy
         Y55pCptsNFROnaGWOHWjuDf35LGTfrN6mS8DtJ4EPi6ur2etlkxRN929V7/VvE60Pa
         tNCpWzFwvLgPjlK0Y57RztJ+DgnUIUS0hBvwV48aPhT5uinKhFDV5pcvLEmYSB8FVJ
         hWu2Iv4XjzlKA==
Date:   Tue, 19 Apr 2022 17:50:08 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RESEND][PATCH v2] PCI: Sanitise firmware BAR assignments behind
 a PCI-PCI bridge
Message-ID: <20220419225008.GA1241595@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2202010150100.58572@angie.orcam.me.uk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 01, 2022 at 10:51:11AM +0000, Maciej W. Rozycki wrote:
> Fix an issue with the Tyan Tomcat IV S1564D system, the BIOS of which 
> does not assign PCI buses beyond #2, where our resource reallocation 
> code preserves the reset default of an I/O BAR assignment outside its 
> upstream PCI-to-PCI bridge's I/O forwarding range for device 06:08.0 in 
> this log:
> 
> pci_bus 0000:00: max bus depth: 4 pci_try_num: 5
> [...]
> pci 0000:06:08.0: BAR 4: no space for [io  size 0x0020]
> pci 0000:06:08.0: BAR 4: trying firmware assignment [io  0xfce0-0xfcff]
> pci 0000:06:08.0: BAR 4: assigned [io  0xfce0-0xfcff]
> pci 0000:06:08.1: BAR 4: no space for [io  size 0x0020]
> pci 0000:06:08.1: BAR 4: trying firmware assignment [io  0xfce0-0xfcff]
> pci 0000:06:08.1: BAR 4: [io  0xfce0-0xfcff] conflicts with 0000:06:08.0 [io  0xfce0-0xfcff]
> pci 0000:06:08.1: BAR 4: failed to assign [io  size 0x0020]
> pci 0000:05:00.0: PCI bridge to [bus 06]
> pci 0000:05:00.0:   bridge window [mem 0xd8000000-0xd85fffff]
> [...]
> pci 0000:00:11.0: PCI bridge to [bus 01-06]
> pci 0000:00:11.0:   bridge window [io  0xe000-0xefff]
> pci 0000:00:11.0:   bridge window [mem 0xd8000000-0xdfffffff]
> pci 0000:00:11.0:   bridge window [mem 0xa8000000-0xafffffff 64bit pref]
> pci_bus 0000:00: No. 2 try to assign unassigned res
> [...]
> pci 0000:06:08.1: BAR 4: no space for [io  size 0x0020]
> pci 0000:06:08.1: BAR 4: trying firmware assignment [io  0xfce0-0xfcff]
> pci 0000:06:08.1: BAR 4: [io  0xfce0-0xfcff] conflicts with 0000:06:08.0 [io  0xfce0-0xfcff]
> pci 0000:06:08.1: BAR 4: failed to assign [io  size 0x0020]
> pci 0000:05:00.0: PCI bridge to [bus 06]
> pci 0000:05:00.0:   bridge window [mem 0xd8000000-0xd85fffff]
> [...]
> pci 0000:00:11.0: PCI bridge to [bus 01-06]
> pci 0000:00:11.0:   bridge window [io  0xe000-0xefff]
> pci 0000:00:11.0:   bridge window [mem 0xd8000000-0xdfffffff]
> pci 0000:00:11.0:   bridge window [mem 0xa8000000-0xafffffff 64bit pref]
> pci_bus 0000:00: No. 3 try to assign unassigned res
> pci 0000:00:11.0: resource 7 [io  0xe000-0xefff] released
> [...]
> pci 0000:06:08.1: BAR 4: assigned [io  0x2000-0x201f]
> pci 0000:05:00.0: PCI bridge to [bus 06]
> pci 0000:05:00.0:   bridge window [io  0x2000-0x2fff]
> pci 0000:05:00.0:   bridge window [mem 0xd8000000-0xd85fffff]
> [...]
> pci 0000:00:11.0: PCI bridge to [bus 01-06]
> pci 0000:00:11.0:   bridge window [io  0x1000-0x2fff]
> pci 0000:00:11.0:   bridge window [mem 0xd8000000-0xdfffffff]
> pci 0000:00:11.0:   bridge window [mem 0xa8000000-0xafffffff 64bit pref]
> pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
> pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
> pci_bus 0000:01: resource 0 [io  0x1000-0x2fff]
> pci_bus 0000:01: resource 1 [mem 0xd8000000-0xdfffffff]
> pci_bus 0000:01: resource 2 [mem 0xa8000000-0xafffffff 64bit pref]
> pci_bus 0000:02: resource 0 [io  0x1000-0x2fff]
> pci_bus 0000:02: resource 1 [mem 0xd8000000-0xd8bfffff]
> pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
> pci_bus 0000:04: resource 1 [mem 0xd8600000-0xd8afffff]
> pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
> pci_bus 0000:05: resource 1 [mem 0xd8000000-0xd85fffff]
> pci_bus 0000:06: resource 0 [io  0x2000-0x2fff]
> pci_bus 0000:06: resource 1 [mem 0xd8000000-0xd85fffff]

Let's include the URL to the you posted
(https://lore.kernel.org/r/alpine.DEB.2.21.2203012338460.46819@angie.orcam.me.uk)
and trim as much as possible out of the commit log.  E.g., the memory
windows probably aren't relevant, the lspci output seems to repeat
information that's already in the dmesg snippets (the dmesg log is
intended to contain enough information to diagnose problems like this,
so if it doesn't we should augment it), one or two samples of error
messages should be enough, etc.

I don't think "try 2", "try 3", etc are really relevant to this
problem.

> -- note that the assignment of 0xfce0-0xfcff is outside the range of 
> 0x2000-0x2fff assigned to bus #6:
> 
> 05:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200A PCI Express-to-PCI Bridge (rev 03) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=05, secondary=06, subordinate=06, sec-latency=0
>         I/O behind bridge: 00002000-00002fff
>         Memory behind bridge: d8000000-d85fffff
>         Capabilities: [50] Power Management version 2
>         Capabilities: [60] Message Signalled Interrupts: 64bit+ Queue=0/4 Enable-
>         Capabilities: [80] #0d [0000]
>         Capabilities: [90] Express PCI/PCI-X Bridge IRQ 0
> 
> 06:08.0 USB controller: VIA Technologies, Inc. VT82xx/62xx/VX700/8x0/900 UHCI USB 1.1 Controller (rev 61) (prog-if 00 [UHCI])
> 	Subsystem: VIA Technologies, Inc. VT82xx/62xx/VX700/8x0/900 UHCI USB 1.1 Controller
>         Flags: bus master, medium devsel, latency 22, IRQ 5
>         I/O ports at fce0 [size=32]
>         Capabilities: [80] Power Management version 2
> 
> 06:08.1 USB controller: VIA Technologies, Inc. VT82xx/62xx/VX700/8x0/900 UHCI USB 1.1 Controller (rev 61) (prog-if 00 [UHCI])
> 	Subsystem: VIA Technologies, Inc. VT82xx/62xx/VX700/8x0/900 UHCI USB 1.1 Controller
>         Flags: bus master, medium devsel, latency 22, IRQ 5
>         I/O ports at 2000 [size=32]
>         Capabilities: [80] Power Management version 2
> 
> Since both 06:08.0 and 06:08.1 have the same reset defaults the latter 
> device escapes its fate and gets a good assignment owing to an address 
> conflict with the former device.
> 
> Consequently when the device driver tries to access 06:08.0 according to 
> its designated address range it pokes at an unassigned I/O location, 
> likely subtractively decoded by the southbridge and forwarded to ISA, 
> causing the driver to become confused and bail out:
> 
> uhci_hcd 0000:06:08.0: host system error, PCI problems?
> uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
> uhci_hcd 0000:06:08.0: host controller halted, very bad!
> uhci_hcd 0000:06:08.0: HCRESET not completed yet!
> uhci_hcd 0000:06:08.0: HC died; cleaning up
> 
> if good luck happens or if bad luck does, an infinite flood of messages:
> 
> uhci_hcd 0000:06:08.0: host system error, PCI problems?
> uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
> uhci_hcd 0000:06:08.0: host system error, PCI problems?
> uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
> uhci_hcd 0000:06:08.0: host system error, PCI problems?
> uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
> [...]
> 
> making the system virtually unusuable.

s/unusuable/unusable/

> This is because we have code to deal with a situation from PR #16263, 
> where broken ACPI firmware reports the wrong address range for the host 
> bridge's decoding window and trying to adjust to the window causes more 
> breakage than leaving the BIOS assignments intact.

What is the antecedent of "this"?  Just the fact that we restore
firmware assignments?  I think 58c84eda0756 ("PCI: fall back to
original BIOS BAR addresses"), which you already reference, is enough
to explain that part.

Here we just need to explain that we know assigning a BAR that's not
inside an upstream bridge's window cannot work, so we might as well
fail so we can try something else.

> This may work for a device directly on the root bus decoded by the host 
> bridge only, but for a device behind one or more PCI-to-PCI (or CardBus) 
> bridges those bridges' forwarding windows have been standardised and 
> need to be respected, or leaving whatever has been there in a downstream 
> device's BAR will have no effect as cycles for the addresses recorded 
> there will have no chance to appear on the bus the device has been 
> immediately attached to.
> 
> Make sure then for a device behind a PCI-to-PCI bridge that any firmware 
> assignment is within the bridge's relevant forwarding window or do not 
> restore the assignment, fixing the system concerned as follows:
> 
> pci_bus 0000:00: max bus depth: 4 pci_try_num: 5
> [...]
> pci 0000:06:08.0: BAR 4: no space for [io  size 0x0020]
> pci 0000:06:08.0: BAR 4: failed to assign [io  0xfce0-0xfcff]
> pci 0000:06:08.1: BAR 4: no space for [io  size 0x0020]
> pci 0000:06:08.1: BAR 4: failed to assign [io  0xfce0-0xfcff]
> [...]
> pci_bus 0000:00: No. 2 try to assign unassigned res
> [...]
> pci 0000:06:08.0: BAR 4: no space for [io  size 0x0020]
> pci 0000:06:08.0: BAR 4: failed to assign [io  0xfce0-0xfcff]
> pci 0000:06:08.1: BAR 4: no space for [io  size 0x0020]
> pci 0000:06:08.1: BAR 4: failed to assign [io  0xfce0-0xfcff]
> [...]
> pci_bus 0000:00: No. 3 try to assign unassigned res
> [...]
> pci 0000:06:08.0: BAR 4: assigned [io  0x2000-0x201f]
> pci 0000:06:08.1: BAR 4: assigned [io  0x2020-0x203f]

I don't think the failures add to the understanding here.

> and making device 06:08.0 work correctly.
> 
> Cf. <https://bugzilla.kernel.org/show_bug.cgi?id=16263>
> 
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Fixes: 58c84eda0756 ("PCI: fall back to original BIOS BAR addresses")
> Cc: stable@vger.kernel.org # v2.6.35+
> ---
> Hi,
> 
>  Resending this patch as it has gone into void.  Patch re-verified against 
> 5.17-rc2.
> 
>  For the record the system's bus topology is as follows:
> 
> -[0000:00]-+-00.0
>            +-07.0
>            +-07.1
>            +-07.2
>            +-11.0-[0000:01-06]----00.0-[0000:02-06]--+-00.0-[0000:03]--
>            |                                         +-01.0-[0000:04]--+-00.0
>            |                                         |                 \-00.3
>            |                                         \-02.0-[0000:05-06]----00.0-[0000:06]--+-05.0
>            |                                                                                +-08.0
>            |                                                                                +-08.1
>            |                                                                                \-08.2
>            +-12.0
>            +-13.0
>            \-14.0
> 
>   Maciej
> 
> Changes from v1:
> 
> - Do restore firmware BAR assignments behind a PCI-PCI bridge, but only if 
>   within the bridge's forwarding window.
> 
> - Update the change description and heading accordingly (was: PCI: Do not 
>   restore firmware BAR assignments behind a PCI-PCI bridge).
> ---
>  drivers/pci/setup-res.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> linux-pci-setup-res-fw-address-nobridge.diff
> Index: linux-macro/drivers/pci/setup-res.c
> ===================================================================
> --- linux-macro.orig/drivers/pci/setup-res.c
> +++ linux-macro/drivers/pci/setup-res.c
> @@ -212,9 +212,19 @@ static int pci_revert_fw_address(struct
>  	res->end = res->start + size - 1;
>  	res->flags &= ~IORESOURCE_UNSET;
>  
> +	/*
> +	 * If we're behind a P2P or CardBus bridge, make sure we're
> +	 * inside the relevant forwarding window, or otherwise the
> +	 * assignment must have been bogus and accesses intended for
> +	 * the range assigned would not reach the device anyway.
> +	 * On the root bus accept anything under the assumption the
> +	 * host bridge will let it through.
> +	 */
>  	root = pci_find_parent_resource(dev, res);
>  	if (!root) {
> -		if (res->flags & IORESOURCE_IO)
> +		if (dev->bus->parent)
> +			return -ENXIO;
> +		else if (res->flags & IORESOURCE_IO)
>  			root = &ioport_resource;
>  		else
>  			root = &iomem_resource;

Is there value in the ioport_resource and iomem_resource lines here?  
They've been there since 58c84eda0756, when we didn't look for a
parent resource.

351fc6d1a517 ("PCI: Fix starting basis for resource requests") added
the pci_find_parent_resource() call, and I think that *should* find
the root bus resources if the device is on the root bus.  And the root
bus resources should already include ioport_resource and
iomem_resource if we don't have anything better.

So I wonder if we should just always return failure when we don't find
a parent resource?

Bjorn
