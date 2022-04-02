Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9EE4F01E4
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 15:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354938AbiDBNFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 09:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354933AbiDBNFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 09:05:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64CD13FA0
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 06:03:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5164561456
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 13:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D28C340EE;
        Sat,  2 Apr 2022 13:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648904588;
        bh=FPb8JnBDIYIX7PTkmdgxKl/O349AHWTSFuom+bpYfZo=;
        h=Subject:To:Cc:From:Date:From;
        b=ftE+giSZ+NURTlgtq/HOxc/e1xaPcByRtZjsizfoyQyT6iKtop8xGkKJSbUDFEJMA
         MBsrVsTYaUGkhykf6F8SJVIdEWcd91ynSD8bA01ri+MXpGKUuWVWa10U5BjZA2Ijfj
         BNamuG986/M2O9ypH6mUYeo3Ji4jZBhMu7tsc1hY=
Subject: FAILED: patch "[PATCH] PCI: xgene: Revert "PCI: xgene: Use inbound resources for" failed to apply to 5.10-stable tree
To:     maz@kernel.org, bhelgaas@google.com, dann.frazier@canonical.com,
        kw@linux.com, lorenzo.pieralisi@arm.com, robh@kernel.org,
        stgraber@ubuntu.com, toan@os.amperecomputing.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 15:02:56 +0200
Message-ID: <1648904576201106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1874b6d7ab1bdc900e8398026350313ac29caddb Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Mon, 21 Mar 2022 10:48:42 +0000
Subject: [PATCH] PCI: xgene: Revert "PCI: xgene: Use inbound resources for
 setup"
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
killed PCIe on my XGene-1 box (a Mustang board). The machine itself
is still alive, but half of its storage (over NVMe) is gone, and the
NVMe driver just times out.

Note that this machine boots with a device tree provided by the
UEFI firmware (2016 vintage), which could well be non conformant
with the spec, hence the breakage.

With the patch reverted, the box boots 5.17-rc8 with flying colors.

Link: https://lore.kernel.org/all/Yf2wTLjmcRj+AbDv@xps13.dannf
Link: https://lore.kernel.org/r/20220321104843.949645-2-maz@kernel.org
Fixes: 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>
Cc: Toan Le <toan@os.amperecomputing.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Krzysztof Wilczyński <kw@linux.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stéphane Graber <stgraber@ubuntu.com>
Cc: dann frazier <dann.frazier@canonical.com>

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
 

