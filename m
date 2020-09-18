Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1B426F421
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbgIRDMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:12:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbgIRCCM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D36C23772;
        Fri, 18 Sep 2020 02:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394531;
        bh=VmeZ1DFYbzu3R/HAnt7aUFll3uASV6SeN1Pfm3K1Ubs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YroPYyANOsL4L75k9AhXIgK/ERYEb0QHcM5lJkoPXbxaqTyeJrobbOldttBgrUVu8
         gB+ncInKvBKqnJVb/6J2yzp5mYRNBOLEjDryZBY0ZxONPLJQUjpq71tlP6ilMqGaeh
         iZULSRqurUCDfV6m9pe5jUhBy9ptiuQkY4hNSsz0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Kit Chow <kchow@gigaio.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 050/330] PCI: Avoid double hpmemsize MMIO window assignment
Date:   Thu, 17 Sep 2020 21:56:30 -0400
Message-Id: <20200918020110.2063155-50-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>

[ Upstream commit c13704f5685deb7d6eb21e293233e0901ed77377 ]

Previously, the kernel sometimes assigned more MMIO or MMIO_PREF space than
desired.  For example, if the user requested 128M of space with
"pci=realloc,hpmemsize=128M", we sometimes assigned 256M:

  pci 0000:06:01.0: BAR 14: assigned [mem 0x90100000-0xa00fffff] = 256M
  pci 0000:06:04.0: BAR 14: assigned [mem 0xa0200000-0xb01fffff] = 256M

With this patch applied:

  pci 0000:06:01.0: BAR 14: assigned [mem 0x90100000-0x980fffff] = 128M
  pci 0000:06:04.0: BAR 14: assigned [mem 0x98200000-0xa01fffff] = 128M

This happened when in the first pass, the MMIO_PREF succeeded but the MMIO
failed. In the next pass, because MMIO_PREF was already assigned, the
attempt to assign MMIO_PREF returned an error code instead of success
(nothing more to do, already allocated). Hence, the size which was actually
allocated, but thought to have failed, was placed in the MMIO window.

The bug resulted in the MMIO_PREF being added to the MMIO window, which
meant doubling if MMIO_PREF size = MMIO size. With a large MMIO_PREF, the
MMIO window would likely fail to be assigned altogether due to lack of
32-bit address space.

Change find_free_bus_resource() to do the following:

  - Return first unassigned resource of the correct type.
  - If there is none, return first assigned resource of the correct type.
  - If none of the above, return NULL.

Returning an assigned resource of the correct type allows the caller to
distinguish between already assigned and no resource of the correct type.

Add checks in pbus_size_io() and pbus_size_mem() to return success if
resource returned from find_free_bus_resource() is already allocated.

This avoids pbus_size_io() and pbus_size_mem() returning error code to
__pci_bus_size_bridges() when a resource has been successfully assigned in
a previous pass. This fixes the existing behaviour where space for a
resource could be reserved multiple times in different parent bridge
windows.

Link: https://lore.kernel.org/lkml/20190531171216.20532-2-logang@deltatee.com/T/#u
Link: https://bugzilla.kernel.org/show_bug.cgi?id=203243
Link: https://lore.kernel.org/r/PS2P216MB075563AA6AD242AA666EDC6A80760@PS2P216MB0755.KORP216.PROD.OUTLOOK.COM
Reported-by: Kit Chow <kchow@gigaio.com>
Reported-by: Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
Signed-off-by: Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 5356630e0e483..44f4866d95d8c 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -752,24 +752,32 @@ static void pci_bridge_check_ranges(struct pci_bus *bus)
 }
 
 /*
- * Helper function for sizing routines: find first available bus resource
- * of a given type.  Note: we intentionally skip the bus resources which
- * have already been assigned (that is, have non-NULL parent resource).
+ * Helper function for sizing routines.  Assigned resources have non-NULL
+ * parent resource.
+ *
+ * Return first unassigned resource of the correct type.  If there is none,
+ * return first assigned resource of the correct type.  If none of the
+ * above, return NULL.
+ *
+ * Returning an assigned resource of the correct type allows the caller to
+ * distinguish between already assigned and no resource of the correct type.
  */
-static struct resource *find_free_bus_resource(struct pci_bus *bus,
-					       unsigned long type_mask,
-					       unsigned long type)
+static struct resource *find_bus_resource_of_type(struct pci_bus *bus,
+						  unsigned long type_mask,
+						  unsigned long type)
 {
+	struct resource *r, *r_assigned = NULL;
 	int i;
-	struct resource *r;
 
 	pci_bus_for_each_resource(bus, r, i) {
 		if (r == &ioport_resource || r == &iomem_resource)
 			continue;
 		if (r && (r->flags & type_mask) == type && !r->parent)
 			return r;
+		if (r && (r->flags & type_mask) == type && !r_assigned)
+			r_assigned = r;
 	}
-	return NULL;
+	return r_assigned;
 }
 
 static resource_size_t calculate_iosize(resource_size_t size,
@@ -866,8 +874,8 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 			 struct list_head *realloc_head)
 {
 	struct pci_dev *dev;
-	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO,
-							IORESOURCE_IO);
+	struct resource *b_res = find_bus_resource_of_type(bus, IORESOURCE_IO,
+							   IORESOURCE_IO);
 	resource_size_t size = 0, size0 = 0, size1 = 0;
 	resource_size_t children_add_size = 0;
 	resource_size_t min_align, align;
@@ -875,6 +883,10 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 	if (!b_res)
 		return;
 
+	/* If resource is already assigned, nothing more to do */
+	if (b_res->parent)
+		return;
+
 	min_align = window_alignment(bus, IORESOURCE_IO);
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		int i;
@@ -978,7 +990,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	resource_size_t min_align, align, size, size0, size1;
 	resource_size_t aligns[18]; /* Alignments from 1MB to 128GB */
 	int order, max_order;
-	struct resource *b_res = find_free_bus_resource(bus,
+	struct resource *b_res = find_bus_resource_of_type(bus,
 					mask | IORESOURCE_PREFETCH, type);
 	resource_size_t children_add_size = 0;
 	resource_size_t children_add_align = 0;
@@ -987,6 +999,10 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	if (!b_res)
 		return -ENOSPC;
 
+	/* If resource is already assigned, nothing more to do */
+	if (b_res->parent)
+		return 0;
+
 	memset(aligns, 0, sizeof(aligns));
 	max_order = 0;
 	size = 0;
-- 
2.25.1

