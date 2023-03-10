Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E74E6B4385
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbjCJOPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbjCJOO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:14:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AA48F527
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:13:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF7F96187C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA016C4339E;
        Fri, 10 Mar 2023 14:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457625;
        bh=k0RF+a3AhoRQllXllO7JwwmPs6fYeQVPqzJoQ3FDxy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ch/CSgOsxxTZh4rrhbpUgZCND0eAa8rMju3NsZY0r+qZe0m0mm/z0Tfh/Zoa/J8Ph
         q6cX23+/zYjrB87YUGSWMVg/dnIkbhsi9uytUWmE9NbhUzivf3coalgY0GMcE4WmYg
         mHmDDY9DoC98IGMZSWdE/GyRpPAJb+XgFvO090Pk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Alexander Motin <mav@ixsystems.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 161/200] PCI: Take other bus devices into account when distributing resources
Date:   Fri, 10 Mar 2023 14:39:28 +0100
Message-Id: <20230310133722.059385120@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 9db0b9b6a14249ef65a5f1e5e3b37762af96f425 ]

A PCI bridge may reside on a bus with other devices as well. The resource
distribution code does not take this into account and therefore it expands
the bridge resource windows too much, not leaving space for the other
devices (or functions of a multifunction device).  This leads to an issue
that Jonathan reported when running QEMU with the following topology (QEMU
parameters):

  -device pcie-root-port,port=0,id=root_port13,chassis=0,slot=2  \
  -device x3130-upstream,id=sw1,bus=root_port13,multifunction=on \
  -device e1000,bus=root_port13,addr=0.1                         \
  -device xio3130-downstream,id=fun1,bus=sw1,chassis=0,slot=3    \
  -device e1000,bus=fun1

The first e1000 NIC here is another function in the switch upstream port.
This leads to following errors:

  pci 0000:00:04.0: bridge window [mem 0x10200000-0x103fffff] to [bus 02-04]
  pci 0000:02:00.0: bridge window [mem 0x10200000-0x103fffff] to [bus 03-04]
  pci 0000:02:00.1: BAR 0: failed to assign [mem size 0x00020000]
  e1000 0000:02:00.1: can't ioremap BAR 0: [??? 0x00000000 flags 0x0]

Fix this by taking into account bridge windows, device BARs and SR-IOV PF
BARs on the bus (PF BARs include space for VF BARS so only account PF
BARs), including the ones belonging to bridges themselves if it has any.

Link: https://lore.kernel.org/linux-pci/20221014124553.0000696f@huawei.com/
Link: https://lore.kernel.org/linux-pci/6053736d-1923-41e7-def9-7585ce1772d9@ixsystems.com/
Link: https://lore.kernel.org/r/20230131092405.29121-3-mika.westerberg@linux.intel.com
Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reported-by: Alexander Motin <mav@ixsystems.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 176 ++++++++++++++++++++++++----------------
 1 file changed, 106 insertions(+), 70 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index e440f264accb8..b7b8dddb77722 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1765,12 +1765,67 @@ static void adjust_bridge_window(struct pci_dev *bridge, struct resource *res,
 		add_size = size - new_size;
 		pci_dbg(bridge, "bridge window %pR shrunken by %pa\n", res,
 			&add_size);
+	} else {
+		return;
 	}
 
 	res->end = res->start + new_size - 1;
 	remove_from_list(add_list, res);
 }
 
+static void remove_dev_resource(struct resource *avail, struct pci_dev *dev,
+				struct resource *res)
+{
+	resource_size_t size, align, tmp;
+
+	size = resource_size(res);
+	if (!size)
+		return;
+
+	align = pci_resource_alignment(dev, res);
+	align = align ? ALIGN(avail->start, align) - avail->start : 0;
+	tmp = align + size;
+	avail->start = min(avail->start + tmp, avail->end + 1);
+}
+
+static void remove_dev_resources(struct pci_dev *dev, struct resource *io,
+				 struct resource *mmio,
+				 struct resource *mmio_pref)
+{
+	int i;
+
+	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+		struct resource *res = &dev->resource[i];
+
+		if (resource_type(res) == IORESOURCE_IO) {
+			remove_dev_resource(io, dev, res);
+		} else if (resource_type(res) == IORESOURCE_MEM) {
+
+			/*
+			 * Make sure prefetchable memory is reduced from
+			 * the correct resource. Specifically we put 32-bit
+			 * prefetchable memory in non-prefetchable window
+			 * if there is an 64-bit pretchable window.
+			 *
+			 * See comments in __pci_bus_size_bridges() for
+			 * more information.
+			 */
+			if ((res->flags & IORESOURCE_PREFETCH) &&
+			    ((res->flags & IORESOURCE_MEM_64) ==
+			     (mmio_pref->flags & IORESOURCE_MEM_64)))
+				remove_dev_resource(mmio_pref, dev, res);
+			else
+				remove_dev_resource(mmio, dev, res);
+		}
+	}
+}
+
+/*
+ * io, mmio and mmio_pref contain the total amount of bridge window space
+ * available. This includes the minimal space needed to cover all the
+ * existing devices on the bus and the possible extra space that can be
+ * shared with the bridges.
+ */
 static void pci_bus_distribute_available_resources(struct pci_bus *bus,
 					    struct list_head *add_list,
 					    struct resource io,
@@ -1780,7 +1835,7 @@ static void pci_bus_distribute_available_resources(struct pci_bus *bus,
 	unsigned int normal_bridges = 0, hotplug_bridges = 0;
 	struct resource *io_res, *mmio_res, *mmio_pref_res;
 	struct pci_dev *dev, *bridge = bus->self;
-	resource_size_t io_per_hp, mmio_per_hp, mmio_pref_per_hp, align;
+	resource_size_t io_per_b, mmio_per_b, mmio_pref_per_b, align;
 
 	io_res = &bridge->resource[PCI_BRIDGE_IO_WINDOW];
 	mmio_res = &bridge->resource[PCI_BRIDGE_MEM_WINDOW];
@@ -1824,100 +1879,81 @@ static void pci_bus_distribute_available_resources(struct pci_bus *bus,
 			normal_bridges++;
 	}
 
-	/*
-	 * There is only one bridge on the bus so it gets all available
-	 * resources which it can then distribute to the possible hotplug
-	 * bridges below.
-	 */
-	if (hotplug_bridges + normal_bridges == 1) {
-		dev = list_first_entry(&bus->devices, struct pci_dev, bus_list);
-		if (dev->subordinate)
-			pci_bus_distribute_available_resources(dev->subordinate,
-				add_list, io, mmio, mmio_pref);
-		return;
-	}
-
-	if (hotplug_bridges == 0)
+	if (!(hotplug_bridges + normal_bridges))
 		return;
 
 	/*
-	 * Calculate the total amount of extra resource space we can
-	 * pass to bridges below this one.  This is basically the
-	 * extra space reduced by the minimal required space for the
-	 * non-hotplug bridges.
+	 * Calculate the amount of space we can forward from "bus" to any
+	 * downstream buses, i.e., the space left over after assigning the
+	 * BARs and windows on "bus".
 	 */
-	for_each_pci_bridge(dev, bus) {
-		resource_size_t used_size;
-		struct resource *res;
-
-		if (dev->is_hotplug_bridge)
-			continue;
-
-		/*
-		 * Reduce the available resource space by what the
-		 * bridge and devices below it occupy.
-		 */
-		res = &dev->resource[PCI_BRIDGE_IO_WINDOW];
-		align = pci_resource_alignment(dev, res);
-		align = align ? ALIGN(io.start, align) - io.start : 0;
-		used_size = align + resource_size(res);
-		if (!res->parent)
-			io.start = min(io.start + used_size, io.end + 1);
-
-		res = &dev->resource[PCI_BRIDGE_MEM_WINDOW];
-		align = pci_resource_alignment(dev, res);
-		align = align ? ALIGN(mmio.start, align) - mmio.start : 0;
-		used_size = align + resource_size(res);
-		if (!res->parent)
-			mmio.start = min(mmio.start + used_size, mmio.end + 1);
-
-		res = &dev->resource[PCI_BRIDGE_PREF_MEM_WINDOW];
-		align = pci_resource_alignment(dev, res);
-		align = align ? ALIGN(mmio_pref.start, align) -
-			mmio_pref.start : 0;
-		used_size = align + resource_size(res);
-		if (!res->parent)
-			mmio_pref.start = min(mmio_pref.start + used_size,
-				mmio_pref.end + 1);
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (!dev->is_virtfn)
+			remove_dev_resources(dev, &io, &mmio, &mmio_pref);
 	}
 
-	io_per_hp = div64_ul(resource_size(&io), hotplug_bridges);
-	mmio_per_hp = div64_ul(resource_size(&mmio), hotplug_bridges);
-	mmio_pref_per_hp = div64_ul(resource_size(&mmio_pref),
-		hotplug_bridges);
-
 	/*
-	 * Go over devices on this bus and distribute the remaining
-	 * resource space between hotplug bridges.
+	 * If there is at least one hotplug bridge on this bus it gets all
+	 * the extra resource space that was left after the reductions
+	 * above.
+	 *
+	 * If there are no hotplug bridges the extra resource space is
+	 * split between non-hotplug bridges. This is to allow possible
+	 * hotplug bridges below them to get the extra space as well.
 	 */
+	if (hotplug_bridges) {
+		io_per_b = div64_ul(resource_size(&io), hotplug_bridges);
+		mmio_per_b = div64_ul(resource_size(&mmio), hotplug_bridges);
+		mmio_pref_per_b = div64_ul(resource_size(&mmio_pref),
+					   hotplug_bridges);
+	} else {
+		io_per_b = div64_ul(resource_size(&io), normal_bridges);
+		mmio_per_b = div64_ul(resource_size(&mmio), normal_bridges);
+		mmio_pref_per_b = div64_ul(resource_size(&mmio_pref),
+					   normal_bridges);
+	}
+
 	for_each_pci_bridge(dev, bus) {
 		struct resource *res;
 		struct pci_bus *b;
 
 		b = dev->subordinate;
-		if (!b || !dev->is_hotplug_bridge)
+		if (!b)
 			continue;
+		if (hotplug_bridges && !dev->is_hotplug_bridge)
+			continue;
+
+		res = &dev->resource[PCI_BRIDGE_IO_WINDOW];
 
 		/*
-		 * Distribute available extra resources equally between
-		 * hotplug-capable downstream ports taking alignment into
-		 * account.
+		 * Make sure the split resource space is properly aligned
+		 * for bridge windows (align it down to avoid going above
+		 * what is available).
 		 */
-		res = &dev->resource[PCI_BRIDGE_IO_WINDOW];
 		align = pci_resource_alignment(dev, res);
-		io.end = align ? io.start + ALIGN_DOWN(io_per_hp, align) - 1
-			       : io.start + io_per_hp - 1;
+		io.end = align ? io.start + ALIGN_DOWN(io_per_b, align) - 1
+			       : io.start + io_per_b - 1;
+
+		/*
+		 * The x_per_b holds the extra resource space that can be
+		 * added for each bridge but there is the minimal already
+		 * reserved as well so adjust x.start down accordingly to
+		 * cover the whole space.
+		 */
+		io.start -= resource_size(res);
 
 		res = &dev->resource[PCI_BRIDGE_MEM_WINDOW];
 		align = pci_resource_alignment(dev, res);
-		mmio.end = align ? mmio.start + ALIGN_DOWN(mmio_per_hp, align) - 1
-				 : mmio.start + mmio_per_hp - 1;
+		mmio.end = align ? mmio.start + ALIGN_DOWN(mmio_per_b, align) - 1
+				 : mmio.start + mmio_per_b - 1;
+		mmio.start -= resource_size(res);
 
 		res = &dev->resource[PCI_BRIDGE_PREF_MEM_WINDOW];
 		align = pci_resource_alignment(dev, res);
 		mmio_pref.end = align ? mmio_pref.start +
-					ALIGN_DOWN(mmio_pref_per_hp, align) - 1
-				      : mmio_pref.start + mmio_pref_per_hp - 1;
+					ALIGN_DOWN(mmio_pref_per_b, align) - 1
+				      : mmio_pref.start + mmio_pref_per_b - 1;
+		mmio_pref.start -= resource_size(res);
 
 		pci_bus_distribute_available_resources(b, add_list, io, mmio,
 						       mmio_pref);
-- 
2.39.2



