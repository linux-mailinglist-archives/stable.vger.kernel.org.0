Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9C915EC82
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388870AbgBNR2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:28:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:59978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390855AbgBNQII (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:08:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D690322314;
        Fri, 14 Feb 2020 16:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696487;
        bh=x7sw3HRxfEHEX1Ax+eGUS8pRpBWe8NIuHfYdorZmjqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tP06EpJtxJLfmtAz3NJ3gEpuiW7b7dYujP0MgDmyDAh00MPxH/y3KQR6USffl6GQg
         ZuABup5W7yjW1T9nnNl9wEUvMw9KcYTT2LLuj0vL/Svl8gjoXtJz6FWxbZ3rYYR05h
         lEh1eVt/kyEXPRdPRqwBvO2Vd7b1EVhbddWatc2Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Logan Gunthorpe <logang@deltatee.com>, Kit Chow <kchow@gigaio.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 293/459] PCI: Don't disable bridge BARs when assigning bus resources
Date:   Fri, 14 Feb 2020 10:59:03 -0500
Message-Id: <20200214160149.11681-293-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 9db8dc6d0785225c42a37be7b44d1b07b31b8957 ]

Some PCI bridges implement BARs in addition to bridge windows.  For
example, here's a PLX switch:

  04:00.0 PCI bridge: PLX Technology, Inc. PEX 8724 24-Lane, 6-Port PCI
            Express Gen 3 (8 GT/s) Switch, 19 x 19mm FCBGA (rev ca)
	    (prog-if 00 [Normal decode])
      Flags: bus master, fast devsel, latency 0, IRQ 30, NUMA node 0
      Memory at 90a00000 (32-bit, non-prefetchable) [size=256K]
      Bus: primary=04, secondary=05, subordinate=0a, sec-latency=0
      I/O behind bridge: 00002000-00003fff
      Memory behind bridge: 90000000-909fffff
      Prefetchable memory behind bridge: 0000380000800000-0000380000bfffff

Previously, when the kernel assigned resource addresses (with the
pci=realloc command line parameter, for example) it could clear the struct
resource corresponding to the BAR.  When this happened, lspci would report
this BAR as "ignored":

   Region 0: Memory at <ignored> (32-bit, non-prefetchable) [size=256K]

This is because the kernel reports a zero start address and zero flags
in the corresponding sysfs resource file and in /proc/bus/pci/devices.
Investigation with 'lspci -x', however, shows the BIOS-assigned address
will still be programmed in the device's BAR registers.

It's clearly a bug that the kernel lost track of the BAR value, but in most
cases, this still won't result in a visible issue because nothing uses the
memory, so nothing is affected.  However, when an IOMMU is in use, it will
not reserve this space in the IOVA because the kernel no longer thinks the
range is valid.  (See dmar_init_reserved_ranges() for the Intel
implementation of this.)

Without the proper reserved range, a DMA mapping may allocate an IOVA that
matches a bridge BAR, which results in DMA accesses going to the BAR
instead of the intended RAM.

The problem was in pci_assign_unassigned_root_bus_resources().  When any
resource from a bridge device fails to get assigned, the code set the
resource's flags to zero.  This makes sense for bridge windows, as they
will be re-enabled later, but for regular BARs, it makes the kernel
permanently lose track of the fact that they decode address space.

Change pci_assign_unassigned_root_bus_resources() and
pci_assign_unassigned_bridge_resources() so they only clear "res->flags"
for bridge *windows*, not bridge BARs.

Fixes: da7822e5ad71 ("PCI: update bridge resources to get more big ranges when allocating space (again)")
Link: https://lore.kernel.org/r/20200108213208.4612-1-logang@deltatee.com
[bhelgaas: commit log, check for pci_is_bridge()]
Reported-by: Kit Chow <kchow@gigaio.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index e7dbe21705ba5..5356630e0e483 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1785,12 +1785,18 @@ void pci_assign_unassigned_root_bus_resources(struct pci_bus *bus)
 	/* Restore size and flags */
 	list_for_each_entry(fail_res, &fail_head, list) {
 		struct resource *res = fail_res->res;
+		int idx;
 
 		res->start = fail_res->start;
 		res->end = fail_res->end;
 		res->flags = fail_res->flags;
-		if (fail_res->dev->subordinate)
-			res->flags = 0;
+
+		if (pci_is_bridge(fail_res->dev)) {
+			idx = res - &fail_res->dev->resource[0];
+			if (idx >= PCI_BRIDGE_RESOURCES &&
+			    idx <= PCI_BRIDGE_RESOURCE_END)
+				res->flags = 0;
+		}
 	}
 	free_list(&fail_head);
 
@@ -2037,12 +2043,18 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 	/* Restore size and flags */
 	list_for_each_entry(fail_res, &fail_head, list) {
 		struct resource *res = fail_res->res;
+		int idx;
 
 		res->start = fail_res->start;
 		res->end = fail_res->end;
 		res->flags = fail_res->flags;
-		if (fail_res->dev->subordinate)
-			res->flags = 0;
+
+		if (pci_is_bridge(fail_res->dev)) {
+			idx = res - &fail_res->dev->resource[0];
+			if (idx >= PCI_BRIDGE_RESOURCES &&
+			    idx <= PCI_BRIDGE_RESOURCE_END)
+				res->flags = 0;
+		}
 	}
 	free_list(&fail_head);
 
-- 
2.20.1

