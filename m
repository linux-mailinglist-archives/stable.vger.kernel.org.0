Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A66240761
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 16:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgHJOUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 10:20:12 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:41900 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726845AbgHJOUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 10:20:11 -0400
Received: from vla1-fdfb804fb3f3.qloud-c.yandex.net (vla1-fdfb804fb3f3.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3199:0:640:fdfb:804f])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 8796C2E150B;
        Mon, 10 Aug 2020 17:20:00 +0300 (MSK)
Received: from vla5-58875c36c028.qloud-c.yandex.net (vla5-58875c36c028.qloud-c.yandex.net [2a02:6b8:c18:340b:0:640:5887:5c36])
        by vla1-fdfb804fb3f3.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id LeTWfixU5P-JxveHejL;
        Mon, 10 Aug 2020 17:20:00 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1597069200; bh=SMvhApGc0TGzL18UYs9cPD5VoiTYiXpb1a/uRsGLt+k=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=c0dIIm/9894EMORAz3FIn0jP+XEOkPe5CN225vMNXJyj7mVev82u67iEZCih2kCWg
         +1F4MmEBc1hf1rLw1iadBIBbbN6jd3ezJrGvP0m+LQbqxL2NQiKWXZwQKWOGgBWYzE
         zM3CaLdB3jpTHOcYjFkEqZBOKvtyWR+b+gDC17G8=
Authentication-Results: vla1-fdfb804fb3f3.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:701::1:8])
        by vla5-58875c36c028.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 0B6aCfyL1a-JxmuMJ6I;
        Mon, 10 Aug 2020 17:19:59 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dima Stepanov <dimastep@yandex-team.ru>
To:     stable@vger.kernel.org
Cc:     bjorn@helgaas.com, dimastep@yandex-team.ru
Subject: [PATCH 4.19.y] PCI: Probe bridge window attributes once at enumeration-time
Date:   Mon, 10 Aug 2020 17:19:42 +0300
Message-Id: <1597069182-5075-1-git-send-email-dimastep@yandex-team.ru>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

commit 51c48b310183ab6ba5419edfc6a8de889cc04521 upstream.

pci_bridge_check_ranges() determines whether a bridge supports the optional
I/O and prefetchable memory windows and sets the flag bits in the bridge
resources.  This *could* be done once during enumeration except that the
resource allocation code completely clears the flag bits, e.g., in the
pci_assign_unassigned_bridge_resources() path.

The problem with pci_bridge_check_ranges() in the resource allocation path
is that we may allocate resources after devices have been claimed by
drivers, and pci_bridge_check_ranges() *changes* the window registers to
determine whether they're writable.  This may break concurrent accesses to
devices behind the bridge.

Add a new pci_read_bridge_windows() to determine whether a bridge supports
the optional windows, call it once during enumeration, remember the
results, and change pci_bridge_check_ranges() so it doesn't touch the
bridge windows but sets the flag bits based on those remembered results.

Link: https://lore.kernel.org/linux-pci/1506151482-113560-1-git-send-email-wangzhou1@hisilicon.com
Link: https://lists.gnu.org/archive/html/qemu-devel/2018-12/msg02082.html
Reported-by: Yandong Xu <xuyandong2@huawei.com>
Tested-by: Yandong Xu <xuyandong2@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Ofer Hayut <ofer@lightbitslabs.com>
Cc: Roy Shterman <roys@lightbitslabs.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Zhou Wang <wangzhou1@hisilicon.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=208371
Signed-off-by: Dima Stepanov <dimastep@yandex-team.ru>
---
 drivers/pci/probe.c     | 52 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/setup-bus.c | 45 ++++--------------------------------------
 include/linux/pci.h     |  3 +++
 3 files changed, 59 insertions(+), 41 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 257b9f6..2ef8b95 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -348,6 +348,57 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 	}
 }
 
+static void pci_read_bridge_windows(struct pci_dev *bridge)
+{
+	u16 io;
+	u32 pmem, tmp;
+
+	pci_read_config_word(bridge, PCI_IO_BASE, &io);
+	if (!io) {
+		pci_write_config_word(bridge, PCI_IO_BASE, 0xe0f0);
+		pci_read_config_word(bridge, PCI_IO_BASE, &io);
+		pci_write_config_word(bridge, PCI_IO_BASE, 0x0);
+	}
+	if (io)
+		bridge->io_window = 1;
+
+	/*
+	 * DECchip 21050 pass 2 errata: the bridge may miss an address
+	 * disconnect boundary by one PCI data phase.  Workaround: do not
+	 * use prefetching on this device.
+	 */
+	if (bridge->vendor == PCI_VENDOR_ID_DEC && bridge->device == 0x0001)
+		return;
+
+	pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &pmem);
+	if (!pmem) {
+		pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE,
+					       0xffe0fff0);
+		pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &pmem);
+		pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, 0x0);
+	}
+	if (!pmem)
+		return;
+
+	bridge->pref_window = 1;
+
+	if ((pmem & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64) {
+
+		/*
+		 * Bridge claims to have a 64-bit prefetchable memory
+		 * window; verify that the upper bits are actually
+		 * writable.
+		 */
+		pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32, &pmem);
+		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
+				       0xffffffff);
+		pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32, &tmp);
+		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, pmem);
+		if (tmp)
+			bridge->pref_64_window = 1;
+	}
+}
+
 static void pci_read_bridge_io(struct pci_bus *child)
 {
 	struct pci_dev *dev = child->self;
@@ -1739,6 +1790,7 @@ int pci_setup_device(struct pci_dev *dev)
 		pci_read_irq(dev);
 		dev->transparent = ((dev->class & 0xff) == 1);
 		pci_read_bases(dev, 2, PCI_ROM_ADDRESS1);
+		pci_read_bridge_windows(dev);
 		set_pcie_hotplug_bridge(dev);
 		pos = pci_find_capability(dev, PCI_CAP_ID_SSVID);
 		if (pos) {
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index ed96043..1941bb0 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -735,58 +735,21 @@ int pci_claim_bridge_resource(struct pci_dev *bridge, int i)
    base/limit registers must be read-only and read as 0. */
 static void pci_bridge_check_ranges(struct pci_bus *bus)
 {
-	u16 io;
-	u32 pmem;
 	struct pci_dev *bridge = bus->self;
-	struct resource *b_res;
+	struct resource *b_res = &bridge->resource[PCI_BRIDGE_RESOURCES];
 
-	b_res = &bridge->resource[PCI_BRIDGE_RESOURCES];
 	b_res[1].flags |= IORESOURCE_MEM;
 
-	pci_read_config_word(bridge, PCI_IO_BASE, &io);
-	if (!io) {
-		pci_write_config_word(bridge, PCI_IO_BASE, 0xe0f0);
-		pci_read_config_word(bridge, PCI_IO_BASE, &io);
-		pci_write_config_word(bridge, PCI_IO_BASE, 0x0);
-	}
-	if (io)
+	if (bridge->io_window)
 		b_res[0].flags |= IORESOURCE_IO;
 
-	/*  DECchip 21050 pass 2 errata: the bridge may miss an address
-	    disconnect boundary by one PCI data phase.
-	    Workaround: do not use prefetching on this device. */
-	if (bridge->vendor == PCI_VENDOR_ID_DEC && bridge->device == 0x0001)
-		return;
-
-	pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &pmem);
-	if (!pmem) {
-		pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE,
-					       0xffe0fff0);
-		pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &pmem);
-		pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, 0x0);
-	}
-	if (pmem) {
+	if (bridge->pref_window) {
 		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
-		if ((pmem & PCI_PREF_RANGE_TYPE_MASK) ==
-		    PCI_PREF_RANGE_TYPE_64) {
+		if (bridge->pref_64_window) {
 			b_res[2].flags |= IORESOURCE_MEM_64;
 			b_res[2].flags |= PCI_PREF_RANGE_TYPE_64;
 		}
 	}
-
-	/* double check if bridge does support 64 bit pref */
-	if (b_res[2].flags & IORESOURCE_MEM_64) {
-		u32 mem_base_hi, tmp;
-		pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32,
-					 &mem_base_hi);
-		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
-					       0xffffffff);
-		pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32, &tmp);
-		if (!tmp)
-			b_res[2].flags &= ~IORESOURCE_MEM_64;
-		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
-				       mem_base_hi);
-	}
 }
 
 /* Helper function for sizing routines: find first available
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 65f1d8c..40b327b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -373,6 +373,9 @@ struct pci_dev {
 	bool		match_driver;		/* Skip attaching driver */
 
 	unsigned int	transparent:1;		/* Subtractive decode bridge */
+	unsigned int	io_window:1;		/* Bridge has I/O window */
+	unsigned int	pref_window:1;		/* Bridge has pref mem window */
+	unsigned int	pref_64_window:1;	/* Pref mem window is 64-bit */
 	unsigned int	multifunction:1;	/* Multi-function device */
 
 	unsigned int	is_busmaster:1;		/* Is busmaster */
-- 
2.7.4

