Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64EA59A213
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352455AbiHSQch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352789AbiHSQ3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:29:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245C1119A6C;
        Fri, 19 Aug 2022 09:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFD5FB8281D;
        Fri, 19 Aug 2022 16:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FC0C433C1;
        Fri, 19 Aug 2022 16:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925065;
        bh=jxCpoJivwvu0FF76n53BjfJeP8PO5SuBKMbYAiIEf4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n10v8X31SWvKLIUwPdPRQ12Rxi57l2Vg7CYb7QZM2NaztYNTAeTUrW/GmybP+jfRx
         x34RUIrMgNOayHblOPfpsymLh1276N0C+LBfTD5mLurH6j5WEBawWNI5OzfGLGYUql
         3Pq4Jsbfd44WdJVjMoXOo30Dx1/QLxs9sdFbnOFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vidya Sagar <vidyas@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 345/545] PCI: tegra194: Fix Root Port interrupt handling
Date:   Fri, 19 Aug 2022 17:41:55 +0200
Message-Id: <20220819153844.833657110@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit 6646e99bcec627e866bc84365af37942c72b4b76 ]

As part of Root Port interrupt handling, level-0 register is read first and
based on the bits set in that, corresponding level-1 registers are read for
further interrupt processing. Since both these values are currently read
into the same 'val' variable, checking level-0 bits the second time around
is happening on the 'val' variable value of level-1 register contents
instead of freshly reading the level-0 value again.

Fix by using different variables to store level-0 and level-1 registers
contents.

Link: https://lore.kernel.org/r/20220721142052.25971-11-vidyas@nvidia.com
Fixes: 56e15a238d92 ("PCI: tegra: Add Tegra194 PCIe support")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 46 +++++++++++-----------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 845f1e1de3ab..bcbd600116d7 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -370,15 +370,14 @@ static irqreturn_t tegra_pcie_rp_irq_handler(int irq, void *arg)
 	struct tegra_pcie_dw *pcie = arg;
 	struct dw_pcie *pci = &pcie->pci;
 	struct pcie_port *pp = &pci->pp;
-	u32 val, tmp;
+	u32 val, status_l0, status_l1;
 	u16 val_w;
 
-	val = appl_readl(pcie, APPL_INTR_STATUS_L0);
-	if (val & APPL_INTR_STATUS_L0_LINK_STATE_INT) {
-		val = appl_readl(pcie, APPL_INTR_STATUS_L1_0_0);
-		if (val & APPL_INTR_STATUS_L1_0_0_LINK_REQ_RST_NOT_CHGED) {
-			appl_writel(pcie, val, APPL_INTR_STATUS_L1_0_0);
-
+	status_l0 = appl_readl(pcie, APPL_INTR_STATUS_L0);
+	if (status_l0 & APPL_INTR_STATUS_L0_LINK_STATE_INT) {
+		status_l1 = appl_readl(pcie, APPL_INTR_STATUS_L1_0_0);
+		appl_writel(pcie, status_l1, APPL_INTR_STATUS_L1_0_0);
+		if (status_l1 & APPL_INTR_STATUS_L1_0_0_LINK_REQ_RST_NOT_CHGED) {
 			/* SBR & Surprise Link Down WAR */
 			val = appl_readl(pcie, APPL_CAR_RESET_OVRD);
 			val &= ~APPL_CAR_RESET_OVRD_CYA_OVERRIDE_CORE_RST_N;
@@ -394,15 +393,15 @@ static irqreturn_t tegra_pcie_rp_irq_handler(int irq, void *arg)
 		}
 	}
 
-	if (val & APPL_INTR_STATUS_L0_INT_INT) {
-		val = appl_readl(pcie, APPL_INTR_STATUS_L1_8_0);
-		if (val & APPL_INTR_STATUS_L1_8_0_AUTO_BW_INT_STS) {
+	if (status_l0 & APPL_INTR_STATUS_L0_INT_INT) {
+		status_l1 = appl_readl(pcie, APPL_INTR_STATUS_L1_8_0);
+		if (status_l1 & APPL_INTR_STATUS_L1_8_0_AUTO_BW_INT_STS) {
 			appl_writel(pcie,
 				    APPL_INTR_STATUS_L1_8_0_AUTO_BW_INT_STS,
 				    APPL_INTR_STATUS_L1_8_0);
 			apply_bad_link_workaround(pp);
 		}
-		if (val & APPL_INTR_STATUS_L1_8_0_BW_MGT_INT_STS) {
+		if (status_l1 & APPL_INTR_STATUS_L1_8_0_BW_MGT_INT_STS) {
 			appl_writel(pcie,
 				    APPL_INTR_STATUS_L1_8_0_BW_MGT_INT_STS,
 				    APPL_INTR_STATUS_L1_8_0);
@@ -414,25 +413,24 @@ static irqreturn_t tegra_pcie_rp_irq_handler(int irq, void *arg)
 		}
 	}
 
-	val = appl_readl(pcie, APPL_INTR_STATUS_L0);
-	if (val & APPL_INTR_STATUS_L0_CDM_REG_CHK_INT) {
-		val = appl_readl(pcie, APPL_INTR_STATUS_L1_18);
-		tmp = dw_pcie_readl_dbi(pci, PCIE_PL_CHK_REG_CONTROL_STATUS);
-		if (val & APPL_INTR_STATUS_L1_18_CDM_REG_CHK_CMPLT) {
+	if (status_l0 & APPL_INTR_STATUS_L0_CDM_REG_CHK_INT) {
+		status_l1 = appl_readl(pcie, APPL_INTR_STATUS_L1_18);
+		val = dw_pcie_readl_dbi(pci, PCIE_PL_CHK_REG_CONTROL_STATUS);
+		if (status_l1 & APPL_INTR_STATUS_L1_18_CDM_REG_CHK_CMPLT) {
 			dev_info(pci->dev, "CDM check complete\n");
-			tmp |= PCIE_PL_CHK_REG_CHK_REG_COMPLETE;
+			val |= PCIE_PL_CHK_REG_CHK_REG_COMPLETE;
 		}
-		if (val & APPL_INTR_STATUS_L1_18_CDM_REG_CHK_CMP_ERR) {
+		if (status_l1 & APPL_INTR_STATUS_L1_18_CDM_REG_CHK_CMP_ERR) {
 			dev_err(pci->dev, "CDM comparison mismatch\n");
-			tmp |= PCIE_PL_CHK_REG_CHK_REG_COMPARISON_ERROR;
+			val |= PCIE_PL_CHK_REG_CHK_REG_COMPARISON_ERROR;
 		}
-		if (val & APPL_INTR_STATUS_L1_18_CDM_REG_CHK_LOGIC_ERR) {
+		if (status_l1 & APPL_INTR_STATUS_L1_18_CDM_REG_CHK_LOGIC_ERR) {
 			dev_err(pci->dev, "CDM Logic error\n");
-			tmp |= PCIE_PL_CHK_REG_CHK_REG_LOGIC_ERROR;
+			val |= PCIE_PL_CHK_REG_CHK_REG_LOGIC_ERROR;
 		}
-		dw_pcie_writel_dbi(pci, PCIE_PL_CHK_REG_CONTROL_STATUS, tmp);
-		tmp = dw_pcie_readl_dbi(pci, PCIE_PL_CHK_REG_ERR_ADDR);
-		dev_err(pci->dev, "CDM Error Address Offset = 0x%08X\n", tmp);
+		dw_pcie_writel_dbi(pci, PCIE_PL_CHK_REG_CONTROL_STATUS, val);
+		val = dw_pcie_readl_dbi(pci, PCIE_PL_CHK_REG_ERR_ADDR);
+		dev_err(pci->dev, "CDM Error Address Offset = 0x%08X\n", val);
 	}
 
 	return IRQ_HANDLED;
-- 
2.35.1



