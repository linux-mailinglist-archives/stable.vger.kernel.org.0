Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F38781213B8
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbfLPSET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:04:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729445AbfLPSER (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:04:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 661F02072D;
        Mon, 16 Dec 2019 18:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519455;
        bh=vWpec5VhB3CUngkYh6UIiOcmKJ4jFbjxAXQH3GFI/AE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSZnrxGH0gat1I8qw1CKWgOI/SS6CiSgz/SepRXCFbxmTQNZC/d2gk68sZRdDXD6N
         1aeNyXM7C8y+LsSFty4qaUV4prHwf8Ef7cP91KZRuXXTy4yH8PkHd5Ahe07mcdrspm
         zserMwqE8odAyGZIvT99WqSBSWEtkyjwbKwFIaR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Valerio Passini <passini.valerio@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 073/140] ACPI / hotplug / PCI: Allocate resources directly under the non-hotplug bridge
Date:   Mon, 16 Dec 2019 18:49:01 +0100
Message-Id: <20191216174807.294446033@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 77adf9355304f8dcf09054280af5e23fc451ab3d upstream.

Valerio and others reported that commit 84c8b58ed3ad ("ACPI / hotplug /
PCI: Don't scan bridges managed by native hotplug") prevents some recent
LG and HP laptops from booting with endless loop of:

  ACPI Error: No handler or method for GPE 08, disabling event (20190215/evgpe-835)
  ACPI Error: No handler or method for GPE 09, disabling event (20190215/evgpe-835)
  ACPI Error: No handler or method for GPE 0A, disabling event (20190215/evgpe-835)
  ...

What seems to happen is that during boot, after the initial PCI enumeration
when EC is enabled the platform triggers ACPI Notify() to one of the root
ports. The root port itself looks like this:

  pci 0000:00:1b.0: PCI bridge to [bus 02-3a]
  pci 0000:00:1b.0:   bridge window [mem 0xc4000000-0xda0fffff]
  pci 0000:00:1b.0:   bridge window [mem 0x80000000-0xa1ffffff 64bit pref]

The BIOS has configured the root port so that it does not have I/O bridge
window.

Now when the ACPI Notify() is triggered ACPI hotplug handler calls
acpiphp_native_scan_bridge() for each non-hotplug bridge (as this system is
using native PCIe hotplug) and pci_assign_unassigned_bridge_resources() to
allocate resources.

The device connected to the root port is a PCIe switch (Thunderbolt
controller) with two hotplug downstream ports. Because of the hotplug ports
__pci_bus_size_bridges() tries to add "additional I/O" of 256 bytes to each
(DEFAULT_HOTPLUG_IO_SIZE). This gets further aligned to 4k as that's the
minimum I/O window size so each hotplug port gets 4k I/O window and the
same happens for the root port (which is also hotplug port). This means
3 * 4k = 12k I/O window.

Because of this pci_assign_unassigned_bridge_resources() ends up opening a
I/O bridge window for the root port at first available I/O address which
seems to be in range 0x1000 - 0x3fff. Normally this range is used for ACPI
stuff such as GPE bits (below is part of /proc/ioports):

    1800-1803 : ACPI PM1a_EVT_BLK
    1804-1805 : ACPI PM1a_CNT_BLK
    1808-180b : ACPI PM_TMR
    1810-1815 : ACPI CPU throttle
    1850-1850 : ACPI PM2_CNT_BLK
    1854-1857 : pnp 00:05
    1860-187f : ACPI GPE0_BLK

However, when the ACPI Notify() happened this range was not yet reserved
for ACPI/PNP (that happens later) so PCI gets it. It then starts writing to
this range and accidentally stomps over GPE bits among other things causing
the endless stream of messages about missing GPE handler.

This problem does not happen if "pci=hpiosize=0" is passed in the kernel
command line. The reason is that then the kernel does not try to allocate
the additional 256 bytes for each hotplug port.

Fix this by allocating resources directly below the non-hotplug bridges
where a new device may appear as a result of ACPI Notify(). This avoids the
hotplug bridges and prevents opening the additional I/O window.

Fixes: 84c8b58ed3ad ("ACPI / hotplug / PCI: Don't scan bridges managed by native hotplug")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=203617
Link: https://lore.kernel.org/r/20191030150545.19885-1-mika.westerberg@linux.intel.com
Reported-by: Valerio Passini <passini.valerio@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/hotplug/acpiphp_glue.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -449,8 +449,15 @@ static void acpiphp_native_scan_bridge(s
 
 	/* Scan non-hotplug bridges that need to be reconfigured */
 	for_each_pci_bridge(dev, bus) {
-		if (!hotplug_is_native(dev))
-			max = pci_scan_bridge(bus, dev, max, 1);
+		if (hotplug_is_native(dev))
+			continue;
+
+		max = pci_scan_bridge(bus, dev, max, 1);
+		if (dev->subordinate) {
+			pcibios_resource_survey_bus(dev->subordinate);
+			pci_bus_size_bridges(dev->subordinate);
+			pci_bus_assign_resources(dev->subordinate);
+		}
 	}
 }
 
@@ -480,7 +487,6 @@ static void enable_slot(struct acpiphp_s
 			if (PCI_SLOT(dev->devfn) == slot->device)
 				acpiphp_native_scan_bridge(dev);
 		}
-		pci_assign_unassigned_bridge_resources(bus->self);
 	} else {
 		LIST_HEAD(add_list);
 		int max, pass;


