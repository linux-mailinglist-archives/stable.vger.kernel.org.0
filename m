Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34ADD6AA2C3
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbjCCVve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233149AbjCCVui (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:50:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986C664871;
        Fri,  3 Mar 2023 13:46:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88BC961943;
        Fri,  3 Mar 2023 21:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE11C433A0;
        Fri,  3 Mar 2023 21:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879894;
        bh=BPvNuEoIcrDhMCnlwaSg0666iVjyarZBp9q3ys8goR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2N0lg1e/jzDa+L4Eg2Nhmz6f4nqj8fvzPbC9zwA/PShZxHfWPixPdElFbXqf9I69
         +/696tQQ5Gw3DOzlFGRb5lqpf106QrP3ObDgZNqSjz0x+Q9cehP2I4BW2H2UPXQR4c
         0rUK+jEgyE3mcnmzf0437S3DjbNQjnaedr4N3ucnge2m0T0VcFVGIRiolXWucKGKuw
         3DQd9Y1Ns4ryb9aL5g7HfnbZlb/kqjP4c7YTySnweiDNvdTdRyMmtUZFwFqGq/dymm
         +P3btUr8ujqkmELDA4VUa/uBiMhgOsF7Jjlv+33GsfFybs0seCQDKjcKElqnuMoA1c
         3HLiLscw7PUYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Chris Chiu <chris.chiu@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 45/60] PCI: Distribute available resources for root buses, too
Date:   Fri,  3 Mar 2023 16:42:59 -0500
Message-Id: <20230303214315.1447666-45-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 7180c1d08639f28e63110ad35815f7a1785b8a19 ]

Previously we distributed spare resources only upon hot-add, so if the
initial root bus scan found devices that had not been fully configured by
the BIOS, we allocated only enough resources to cover what was then
present. If some of those devices were hotplug bridges, we did not leave
any additional resource space for future expansion.

Distribute the available resources for root buses, too, to make this work
the same way as the normal hotplug case.

A previous commit to do this was reverted due to a regression reported by
Jonathan Cameron:

  e96e27fc6f79 ("PCI: Distribute available resources for root buses, too")
  5632e2beaf9d ("Revert "PCI: Distribute available resources for root buses, too"")

This commit changes pci_bridge_resources_not_assigned() to work with
bridges that do not have all the resource windows programmed by the boot
firmware (previously we expected all I/O, memory and prefetchable memory
were programmed).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216000
Link: https://lore.kernel.org/r/20220905080232.36087-5-mika.westerberg@linux.intel.com
Link: https://lore.kernel.org/r/20230131092405.29121-4-mika.westerberg@linux.intel.com
Reported-by: Chris Chiu <chris.chiu@canonical.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 57 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index b7b8dddb77722..c690572b10ce7 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1770,7 +1770,10 @@ static void adjust_bridge_window(struct pci_dev *bridge, struct resource *res,
 	}
 
 	res->end = res->start + new_size - 1;
-	remove_from_list(add_list, res);
+
+	/* If the resource is part of the add_list, remove it now */
+	if (add_list)
+		remove_from_list(add_list, res);
 }
 
 static void remove_dev_resource(struct resource *avail, struct pci_dev *dev,
@@ -1972,6 +1975,8 @@ static void pci_bridge_distribute_available_resources(struct pci_dev *bridge,
 	if (!bridge->is_hotplug_bridge)
 		return;
 
+	pci_dbg(bridge, "distributing available resources\n");
+
 	/* Take the initial extra resources from the hotplug port */
 	available_io = bridge->resource[PCI_BRIDGE_IO_WINDOW];
 	available_mmio = bridge->resource[PCI_BRIDGE_MEM_WINDOW];
@@ -1983,6 +1988,54 @@ static void pci_bridge_distribute_available_resources(struct pci_dev *bridge,
 					       available_mmio_pref);
 }
 
+static bool pci_bridge_resources_not_assigned(struct pci_dev *dev)
+{
+	const struct resource *r;
+
+	/*
+	 * If the child device's resources are not yet assigned it means we
+	 * are configuring them (not the boot firmware), so we should be
+	 * able to extend the upstream bridge resources in the same way we
+	 * do with the normal hotplug case.
+	 */
+	r = &dev->resource[PCI_BRIDGE_IO_WINDOW];
+	if (r->flags && !(r->flags & IORESOURCE_STARTALIGN))
+		return false;
+	r = &dev->resource[PCI_BRIDGE_MEM_WINDOW];
+	if (r->flags && !(r->flags & IORESOURCE_STARTALIGN))
+		return false;
+	r = &dev->resource[PCI_BRIDGE_PREF_MEM_WINDOW];
+	if (r->flags && !(r->flags & IORESOURCE_STARTALIGN))
+		return false;
+
+	return true;
+}
+
+static void
+pci_root_bus_distribute_available_resources(struct pci_bus *bus,
+					    struct list_head *add_list)
+{
+	struct pci_dev *dev, *bridge = bus->self;
+
+	for_each_pci_bridge(dev, bus) {
+		struct pci_bus *b;
+
+		b = dev->subordinate;
+		if (!b)
+			continue;
+
+		/*
+		 * Need to check "bridge" here too because it is NULL
+		 * in case of root bus.
+		 */
+		if (bridge && pci_bridge_resources_not_assigned(dev))
+			pci_bridge_distribute_available_resources(bridge,
+								  add_list);
+		else
+			pci_root_bus_distribute_available_resources(b, add_list);
+	}
+}
+
 /*
  * First try will not touch PCI bridge res.
  * Second and later try will clear small leaf bridge res.
@@ -2022,6 +2075,8 @@ void pci_assign_unassigned_root_bus_resources(struct pci_bus *bus)
 	 */
 	__pci_bus_size_bridges(bus, add_list);
 
+	pci_root_bus_distribute_available_resources(bus, add_list);
+
 	/* Depth last, allocate resources and update the hardware. */
 	__pci_bus_assign_resources(bus, add_list, &fail_head);
 	if (add_list)
-- 
2.39.2

