Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414384E24A3
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 11:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346467AbiCUKuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 06:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346422AbiCUKuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 06:50:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705C51EC5B;
        Mon, 21 Mar 2022 03:49:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03C3561380;
        Mon, 21 Mar 2022 10:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9B9C340F8;
        Mon, 21 Mar 2022 10:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647859757;
        bh=rcPzakiRhLn0L4CaRIfnK5+mNrh3wUEKLdQNYv52Jcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPW0dQplLspNs2oGVSbHdBwI3GPXabPkkS8z8bLAG3jFTtNOQfW1PSgtO8YsGvEwG
         Str8c8dOEpPAMY2d0RZbqht7RH+I1e1/0s4Uuli3xIN+d4Y17FDxHlQIveh9HbOFFd
         XmcbOsZq7XQQR7js/+4/P3GL6vcTCmgEJh4BcioynzACwOgDPrygpH0CBviNeSyzp+
         v49zmt7glOVNzgggHKzlKhJ8LA2P5Tu4x6aX9luLky932KvN5mZF1VApRJyI7h9par
         6QSSTY8R+qRBXSgPmEEr49VeCa3W7Hc/0TclLCjBrS57h5nkU/3hWFIM25+o6pN5ro
         Wy44spP+zmpdg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nWFb9-00FvJp-6f; Mon, 21 Mar 2022 10:49:15 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>,
        Toan Le <toan@os.amperecomputing.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        dann frazier <dann.frazier@canonical.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: [PATCH v2 1/2] PCI: xgene: Revert "PCI: xgene: Use inbound resources for setup"
Date:   Mon, 21 Mar 2022 10:48:42 +0000
Message-Id: <20220321104843.949645-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220321104843.949645-1-maz@kernel.org>
References: <20220321104843.949645-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org, robh@kernel.org, toan@os.amperecomputing.com, lorenzo.pieralisi@arm.com, kw@linux.com, bhelgaas@google.com, stgraber@ubuntu.com, dann.frazier@canonical.com, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Cc: Rob Herring <robh@kernel.org>
Cc: Toan Le <toan@os.amperecomputing.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Krzysztof Wilczyński <kw@linux.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stéphane Graber <stgraber@ubuntu.com>
Cc: dann frazier <dann.frazier@canonical.com>
Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Fixes: 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
Link: https://lore.kernel.org/all/Yf2wTLjmcRj+AbDv@xps13.dannf
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

