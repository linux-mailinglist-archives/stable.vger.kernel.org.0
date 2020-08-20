Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B0124BB37
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbgHTJxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729260AbgHTJwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:52:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34AB42067C;
        Thu, 20 Aug 2020 09:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917136;
        bh=7rs0DGOGXSOavQi90SfnLQVIxV16ME5jLXm/6qbDOuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=etF8/ERUvKl19dCipGr2G1Uj5fnA1rdp2Lf29z6BMCa3e3Zq0s8aOY21grxvUJfJX
         qVrX0QduxoTpyeyReVZ24mrXzr2VCG4n9DbVpQRlgF3XNMIwJGcxDgH1AiF0Wrr1+x
         OIsC61ejjw9M0bYxFeolowLX2bnJTEjjFA9OFfZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yandong Xu <xuyandong2@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Ofer Hayut <ofer@lightbitslabs.com>,
        Roy Shterman <roys@lightbitslabs.com>,
        Keith Busch <keith.busch@intel.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Dima Stepanov <dimastep@yandex-team.ru>
Subject: [PATCH 4.19 08/92] PCI: Probe bridge window attributes once at enumeration-time
Date:   Thu, 20 Aug 2020 11:20:53 +0200
Message-Id: <20200820091537.936056109@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/probe.c     |   52 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/setup-bus.c |   45 +++--------------------------------------
 include/linux/pci.h     |    3 ++
 3 files changed, 59 insertions(+), 41 deletions(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -348,6 +348,57 @@ static void pci_read_bases(struct pci_de
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
@@ -1712,6 +1763,7 @@ int pci_setup_device(struct pci_dev *dev
 		pci_read_irq(dev);
 		dev->transparent = ((dev->class & 0xff) == 1);
 		pci_read_bases(dev, 2, PCI_ROM_ADDRESS1);
+		pci_read_bridge_windows(dev);
 		set_pcie_hotplug_bridge(dev);
 		pos = pci_find_capability(dev, PCI_CAP_ID_SSVID);
 		if (pos) {
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -735,58 +735,21 @@ int pci_claim_bridge_resource(struct pci
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


