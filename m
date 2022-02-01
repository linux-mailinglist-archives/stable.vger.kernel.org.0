Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3F14A5A8F
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 11:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236846AbiBAKvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 05:51:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236853AbiBAKvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 05:51:14 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75556C06173B
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 02:51:14 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 4927192009D; Tue,  1 Feb 2022 11:51:11 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 4220292009C;
        Tue,  1 Feb 2022 10:51:11 +0000 (GMT)
Date:   Tue, 1 Feb 2022 10:51:11 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Bjorn Helgaas <bhelgaas@google.com>
cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [RESEND][PATCH v2] PCI: Sanitise firmware BAR assignments behind a
 PCI-PCI bridge
Message-ID: <alpine.DEB.2.21.2202010150100.58572@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix an issue with the Tyan Tomcat IV S1564D system, the BIOS of which 
does not assign PCI buses beyond #2, where our resource reallocation 
code preserves the reset default of an I/O BAR assignment outside its 
upstream PCI-to-PCI bridge's I/O forwarding range for device 06:08.0 in 
this log:

pci_bus 0000:00: max bus depth: 4 pci_try_num: 5
[...]
pci 0000:06:08.0: BAR 4: no space for [io  size 0x0020]
pci 0000:06:08.0: BAR 4: trying firmware assignment [io  0xfce0-0xfcff]
pci 0000:06:08.0: BAR 4: assigned [io  0xfce0-0xfcff]
pci 0000:06:08.1: BAR 4: no space for [io  size 0x0020]
pci 0000:06:08.1: BAR 4: trying firmware assignment [io  0xfce0-0xfcff]
pci 0000:06:08.1: BAR 4: [io  0xfce0-0xfcff] conflicts with 0000:06:08.0 [io  0xfce0-0xfcff]
pci 0000:06:08.1: BAR 4: failed to assign [io  size 0x0020]
pci 0000:05:00.0: PCI bridge to [bus 06]
pci 0000:05:00.0:   bridge window [mem 0xd8000000-0xd85fffff]
[...]
pci 0000:00:11.0: PCI bridge to [bus 01-06]
pci 0000:00:11.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:11.0:   bridge window [mem 0xd8000000-0xdfffffff]
pci 0000:00:11.0:   bridge window [mem 0xa8000000-0xafffffff 64bit pref]
pci_bus 0000:00: No. 2 try to assign unassigned res
[...]
pci 0000:06:08.1: BAR 4: no space for [io  size 0x0020]
pci 0000:06:08.1: BAR 4: trying firmware assignment [io  0xfce0-0xfcff]
pci 0000:06:08.1: BAR 4: [io  0xfce0-0xfcff] conflicts with 0000:06:08.0 [io  0xfce0-0xfcff]
pci 0000:06:08.1: BAR 4: failed to assign [io  size 0x0020]
pci 0000:05:00.0: PCI bridge to [bus 06]
pci 0000:05:00.0:   bridge window [mem 0xd8000000-0xd85fffff]
[...]
pci 0000:00:11.0: PCI bridge to [bus 01-06]
pci 0000:00:11.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:11.0:   bridge window [mem 0xd8000000-0xdfffffff]
pci 0000:00:11.0:   bridge window [mem 0xa8000000-0xafffffff 64bit pref]
pci_bus 0000:00: No. 3 try to assign unassigned res
pci 0000:00:11.0: resource 7 [io  0xe000-0xefff] released
[...]
pci 0000:06:08.1: BAR 4: assigned [io  0x2000-0x201f]
pci 0000:05:00.0: PCI bridge to [bus 06]
pci 0000:05:00.0:   bridge window [io  0x2000-0x2fff]
pci 0000:05:00.0:   bridge window [mem 0xd8000000-0xd85fffff]
[...]
pci 0000:00:11.0: PCI bridge to [bus 01-06]
pci 0000:00:11.0:   bridge window [io  0x1000-0x2fff]
pci 0000:00:11.0:   bridge window [mem 0xd8000000-0xdfffffff]
pci 0000:00:11.0:   bridge window [mem 0xa8000000-0xafffffff 64bit pref]
pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
pci_bus 0000:01: resource 0 [io  0x1000-0x2fff]
pci_bus 0000:01: resource 1 [mem 0xd8000000-0xdfffffff]
pci_bus 0000:01: resource 2 [mem 0xa8000000-0xafffffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0x1000-0x2fff]
pci_bus 0000:02: resource 1 [mem 0xd8000000-0xd8bfffff]
pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:04: resource 1 [mem 0xd8600000-0xd8afffff]
pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:05: resource 1 [mem 0xd8000000-0xd85fffff]
pci_bus 0000:06: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:06: resource 1 [mem 0xd8000000-0xd85fffff]

-- note that the assignment of 0xfce0-0xfcff is outside the range of 
0x2000-0x2fff assigned to bus #6:

05:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200A PCI Express-to-PCI Bridge (rev 03) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=05, secondary=06, subordinate=06, sec-latency=0
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: d8000000-d85fffff
        Capabilities: [50] Power Management version 2
        Capabilities: [60] Message Signalled Interrupts: 64bit+ Queue=0/4 Enable-
        Capabilities: [80] #0d [0000]
        Capabilities: [90] Express PCI/PCI-X Bridge IRQ 0

06:08.0 USB controller: VIA Technologies, Inc. VT82xx/62xx/VX700/8x0/900 UHCI USB 1.1 Controller (rev 61) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. VT82xx/62xx/VX700/8x0/900 UHCI USB 1.1 Controller
        Flags: bus master, medium devsel, latency 22, IRQ 5
        I/O ports at fce0 [size=32]
        Capabilities: [80] Power Management version 2

06:08.1 USB controller: VIA Technologies, Inc. VT82xx/62xx/VX700/8x0/900 UHCI USB 1.1 Controller (rev 61) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. VT82xx/62xx/VX700/8x0/900 UHCI USB 1.1 Controller
        Flags: bus master, medium devsel, latency 22, IRQ 5
        I/O ports at 2000 [size=32]
        Capabilities: [80] Power Management version 2

Since both 06:08.0 and 06:08.1 have the same reset defaults the latter 
device escapes its fate and gets a good assignment owing to an address 
conflict with the former device.

Consequently when the device driver tries to access 06:08.0 according to 
its designated address range it pokes at an unassigned I/O location, 
likely subtractively decoded by the southbridge and forwarded to ISA, 
causing the driver to become confused and bail out:

uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host controller halted, very bad!
uhci_hcd 0000:06:08.0: HCRESET not completed yet!
uhci_hcd 0000:06:08.0: HC died; cleaning up

if good luck happens or if bad luck does, an infinite flood of messages:

uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
uhci_hcd 0000:06:08.0: host system error, PCI problems?
uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
[...]

making the system virtually unusuable.

This is because we have code to deal with a situation from PR #16263, 
where broken ACPI firmware reports the wrong address range for the host 
bridge's decoding window and trying to adjust to the window causes more 
breakage than leaving the BIOS assignments intact.

This may work for a device directly on the root bus decoded by the host 
bridge only, but for a device behind one or more PCI-to-PCI (or CardBus) 
bridges those bridges' forwarding windows have been standardised and 
need to be respected, or leaving whatever has been there in a downstream 
device's BAR will have no effect as cycles for the addresses recorded 
there will have no chance to appear on the bus the device has been 
immediately attached to.

Make sure then for a device behind a PCI-to-PCI bridge that any firmware 
assignment is within the bridge's relevant forwarding window or do not 
restore the assignment, fixing the system concerned as follows:

pci_bus 0000:00: max bus depth: 4 pci_try_num: 5
[...]
pci 0000:06:08.0: BAR 4: no space for [io  size 0x0020]
pci 0000:06:08.0: BAR 4: failed to assign [io  0xfce0-0xfcff]
pci 0000:06:08.1: BAR 4: no space for [io  size 0x0020]
pci 0000:06:08.1: BAR 4: failed to assign [io  0xfce0-0xfcff]
[...]
pci_bus 0000:00: No. 2 try to assign unassigned res
[...]
pci 0000:06:08.0: BAR 4: no space for [io  size 0x0020]
pci 0000:06:08.0: BAR 4: failed to assign [io  0xfce0-0xfcff]
pci 0000:06:08.1: BAR 4: no space for [io  size 0x0020]
pci 0000:06:08.1: BAR 4: failed to assign [io  0xfce0-0xfcff]
[...]
pci_bus 0000:00: No. 3 try to assign unassigned res
[...]
pci 0000:06:08.0: BAR 4: assigned [io  0x2000-0x201f]
pci 0000:06:08.1: BAR 4: assigned [io  0x2020-0x203f]

and making device 06:08.0 work correctly.

Cf. <https://bugzilla.kernel.org/show_bug.cgi?id=16263>

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 58c84eda0756 ("PCI: fall back to original BIOS BAR addresses")
Cc: stable@vger.kernel.org # v2.6.35+
---
Hi,

 Resending this patch as it has gone into void.  Patch re-verified against 
5.17-rc2.

 For the record the system's bus topology is as follows:

-[0000:00]-+-00.0
           +-07.0
           +-07.1
           +-07.2
           +-11.0-[0000:01-06]----00.0-[0000:02-06]--+-00.0-[0000:03]--
           |                                         +-01.0-[0000:04]--+-00.0
           |                                         |                 \-00.3
           |                                         \-02.0-[0000:05-06]----00.0-[0000:06]--+-05.0
           |                                                                                +-08.0
           |                                                                                +-08.1
           |                                                                                \-08.2
           +-12.0
           +-13.0
           \-14.0

  Maciej

Changes from v1:

- Do restore firmware BAR assignments behind a PCI-PCI bridge, but only if 
  within the bridge's forwarding window.

- Update the change description and heading accordingly (was: PCI: Do not 
  restore firmware BAR assignments behind a PCI-PCI bridge).
---
 drivers/pci/setup-res.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

linux-pci-setup-res-fw-address-nobridge.diff
Index: linux-macro/drivers/pci/setup-res.c
===================================================================
--- linux-macro.orig/drivers/pci/setup-res.c
+++ linux-macro/drivers/pci/setup-res.c
@@ -212,9 +212,19 @@ static int pci_revert_fw_address(struct
 	res->end = res->start + size - 1;
 	res->flags &= ~IORESOURCE_UNSET;
 
+	/*
+	 * If we're behind a P2P or CardBus bridge, make sure we're
+	 * inside the relevant forwarding window, or otherwise the
+	 * assignment must have been bogus and accesses intended for
+	 * the range assigned would not reach the device anyway.
+	 * On the root bus accept anything under the assumption the
+	 * host bridge will let it through.
+	 */
 	root = pci_find_parent_resource(dev, res);
 	if (!root) {
-		if (res->flags & IORESOURCE_IO)
+		if (dev->bus->parent)
+			return -ENXIO;
+		else if (res->flags & IORESOURCE_IO)
 			root = &ioport_resource;
 		else
 			root = &iomem_resource;
