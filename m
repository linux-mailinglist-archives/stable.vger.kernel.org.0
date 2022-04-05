Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A490D4F25F2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbiDEHw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbiDEHvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:51:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CFB972C7;
        Tue,  5 Apr 2022 00:47:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4496B81B98;
        Tue,  5 Apr 2022 07:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39D0C36AE5;
        Tue,  5 Apr 2022 07:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144855;
        bh=V0AMbed3y2aTkDzH3QoR1TLnabPaMgt3c7GcI48nFnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QS83CQK8OPZQ+aw1Jfd5jOEaTiG5J/CwiajGeHslv0qUnY4acEUEMyY6A0VLmDBTu
         xaXHDaYxzWt1DvzpWDKH0oxku7SjJ0BZZz39+1rkTKbF2e2hOmbbU9D8n4VzWzZsIS
         /OZZrDT4CJlTMXzmgdrkUGziLytH3LMxvS35DvOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Toan Le <toan@os.amperecomputing.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        dann frazier <dann.frazier@canonical.com>
Subject: [PATCH 5.17 0196/1126] PCI: xgene: Revert "PCI: xgene: Use inbound resources for setup"
Date:   Tue,  5 Apr 2022 09:15:43 +0200
Message-Id: <20220405070413.360448939@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Marc Zyngier <maz@kernel.org>

commit 1874b6d7ab1bdc900e8398026350313ac29caddb upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-xgene.c |   33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -479,28 +479,27 @@ static int xgene_pcie_select_ib_reg(u8 *
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
@@ -531,13 +530,25 @@ static void xgene_pcie_setup_ib_reg(stru
 
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
 
+	/* Get the dma-ranges from DT */
+	for_each_of_pci_range(&parser, &range) {
+		u64 end = range.cpu_addr + range.size - 1;
+
+		dev_dbg(dev, "0x%08x 0x%016llx..0x%016llx -> 0x%016llx\n",
+			range.flags, range.cpu_addr, end, range.pci_addr);
+		xgene_pcie_setup_ib_reg(port, &range, &ib_reg_mask);
+	}
 	return 0;
 }
 


