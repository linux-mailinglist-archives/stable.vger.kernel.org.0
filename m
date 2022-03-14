Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB504D872B
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 15:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236436AbiCNOps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 10:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiCNOpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 10:45:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187441BE9D;
        Mon, 14 Mar 2022 07:44:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A988B80D38;
        Mon, 14 Mar 2022 14:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C396C340E9;
        Mon, 14 Mar 2022 14:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647269074;
        bh=UnunP4eX9Tyb4P5pAj81z5/19bGk3OIFv/pkt4kWZPA=;
        h=From:To:Cc:Subject:Date:From;
        b=E3HMzu4aUAEa/07h7JHqT3EZzEGwocWB7huRIQrMcQ6OD31MTixQfyMOUh9VVvh69
         OFBk8E9El8VdprcJwMAIF6J/EOqiI+UccvZFxLiQFgEtM/kxn6iV++UixEMK7vyBjo
         6/za/xyr9a5LGCtRLumy4MU1QmRqQK4l5owHsQfUqFBD6U5AAdAeoFoV6QkALB5Eid
         QUM0+FSlHy6NC+SllL66tRvNkvIQIGqUYoN0hiKXxG629SpEmcFRwy2Iu2O8veMjgv
         m+QvAje5ZgEsUjTPzaaCgzdDtS0Ogi2vgHKHjM+2mxoWupFOeYpJghohqCISZNoYH1
         uHJ8gFLSGs7hw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nTlw0-00ENlh-A9; Mon, 14 Mar 2022 14:44:32 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, Rob Herring <robh@kernel.org>,
        Toan Le <toan@os.amperecomputing.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        dann frazier <dann.frazier@canonical.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        stable@vger.kernel.org
Subject: [PATCH] PCI: xgene: Revert "PCI: xgene: Use inbound resources for setup"
Date:   Mon, 14 Mar 2022 14:44:29 +0000
Message-Id: <20220314144429.1947610-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com, robh@kernel.org, toan@os.amperecomputing.com, lorenzo.pieralisi@arm.com, kw@linux.com, bhelgaas@google.com, stgraber@ubuntu.com, dann.frazier@canonical.com, regressions@leemhuis.info, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
killed PCIe on my XGene-1 box (a Mustang board). The machine itself
is still alive, but half of its storage (over NVMe) is gone, and the
NVMe driver just times out.

Note that this machine boots with a device tree provided by the
UEFI firmware (2016 vintage), which could well be non conformant
with the spec, hence the breakage.

With the patch reverted, the box boots 5.17-rc8 with flying colors.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Toan Le <toan@os.amperecomputing.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Krzysztof Wilczyński <kw@linux.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stéphane Graber <stgraber@ubuntu.com>
Cc: dann frazier <dann.frazier@canonical.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: stable@vger.kernel.org>
---
 drivers/pci/controller/pci-xgene.c | 33 ++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/controller/pci-xgene.c b/drivers/pci/controller/pci-xgene.c
index 0d5acbfc7143..aa41ceaf031f 100644
--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -479,28 +479,27 @@ static int xgene_pcie_select_ib_reg(u8 *ib_reg_mask, u64 size)
 }
 
 static void xgene_pcie_setup_ib_reg(struct xgene_pcie *port,
-				    struct resource_entry *entry,
-				    u8 *ib_reg_mask)
+				    struct of_pci_range *range, u8 *ib_reg_mask)
 {
 	void __iomem *cfg_base = port->cfg_base;
 	struct device *dev = port->dev;
 	void __iomem *bar_addr;
 	u32 pim_reg;
-	u64 cpu_addr = entry->res->start;
-	u64 pci_addr = cpu_addr - entry->offset;
-	u64 size = resource_size(entry->res);
+	u64 cpu_addr = range->cpu_addr;
+	u64 pci_addr = range->pci_addr;
+	u64 size = range->size;
 	u64 mask = ~(size - 1) | EN_REG;
 	u32 flags = PCI_BASE_ADDRESS_MEM_TYPE_64;
 	u32 bar_low;
 	int region;
 
-	region = xgene_pcie_select_ib_reg(ib_reg_mask, size);
+	region = xgene_pcie_select_ib_reg(ib_reg_mask, range->size);
 	if (region < 0) {
 		dev_warn(dev, "invalid pcie dma-range config\n");
 		return;
 	}
 
-	if (entry->res->flags & IORESOURCE_PREFETCH)
+	if (range->flags & IORESOURCE_PREFETCH)
 		flags |= PCI_BASE_ADDRESS_MEM_PREFETCH;
 
 	bar_low = pcie_bar_low_val((u32)cpu_addr, flags);
@@ -531,13 +530,25 @@ static void xgene_pcie_setup_ib_reg(struct xgene_pcie *port,
 
 static int xgene_pcie_parse_map_dma_ranges(struct xgene_pcie *port)
 {
-	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(port);
-	struct resource_entry *entry;
+	struct device_node *np = port->node;
+	struct of_pci_range range;
+	struct of_pci_range_parser parser;
+	struct device *dev = port->dev;
 	u8 ib_reg_mask = 0;
 
-	resource_list_for_each_entry(entry, &bridge->dma_ranges)
-		xgene_pcie_setup_ib_reg(port, entry, &ib_reg_mask);
+	if (of_pci_dma_range_parser_init(&parser, np)) {
+		dev_err(dev, "missing dma-ranges property\n");
+		return -EINVAL;
+	}
+
+	/* Get the dma-ranges from DT */
+	for_each_of_pci_range(&parser, &range) {
+		u64 end = range.cpu_addr + range.size - 1;
 
+		dev_dbg(dev, "0x%08x 0x%016llx..0x%016llx -> 0x%016llx\n",
+			range.flags, range.cpu_addr, end, range.pci_addr);
+		xgene_pcie_setup_ib_reg(port, &range, &ib_reg_mask);
+	}
 	return 0;
 }
 
-- 
2.34.1

