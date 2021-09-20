Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAC6412640
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387228AbhITS4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384534AbhITSsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:48:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2DCC63367;
        Mon, 20 Sep 2021 17:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159231;
        bh=u81EWNfIbcVZsD5p+qkJmolKUj1fpHjjnQqbglo2upM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELvapU6bHvdOrrKLkwedSBEE8WOXtgyOhcyKDeo4KxF0nk5Al/Rn8ljnlI+YtDnTU
         RQpR1fx4GjvrIjh5VikEFDPXarC/Cey0GovaRPFZUZuHrly2NDSWorolCzsPAn1rXA
         YedaJZ1nK6FKgNYUT9Xn3c/JyuUD5tl0K2kAXjkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Om Prakash Singh <omp@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 095/168] PCI: tegra194: Fix handling BME_CHGED event
Date:   Mon, 20 Sep 2021 18:43:53 +0200
Message-Id: <20210920163924.753231519@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Om Prakash Singh <omp@nvidia.com>

[ Upstream commit ceb1412c1c8ca5b28c4252bdb15f2f1f17b4a1b0 ]

In tegra_pcie_ep_hard_irq(), APPL_INTR_STATUS_L0 is stored in val and again
APPL_INTR_STATUS_L1_0_0 is also stored in val. So when execution reaches
"if (val & APPL_INTR_STATUS_L0_PCI_CMD_EN_INT)", val is not correct.

Link: https://lore.kernel.org/r/20210623100525.19944-2-omp@nvidia.com
Signed-off-by: Om Prakash Singh <omp@nvidia.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 30 +++++++++++-----------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 3ec7b29d5dc7..fd14e2f45bba 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -497,19 +497,19 @@ static irqreturn_t tegra_pcie_ep_hard_irq(int irq, void *arg)
 	struct tegra_pcie_dw *pcie = arg;
 	struct dw_pcie_ep *ep = &pcie->pci.ep;
 	int spurious = 1;
-	u32 val, tmp;
+	u32 status_l0, status_l1, link_status;
 
-	val = appl_readl(pcie, APPL_INTR_STATUS_L0);
-	if (val & APPL_INTR_STATUS_L0_LINK_STATE_INT) {
-		val = appl_readl(pcie, APPL_INTR_STATUS_L1_0_0);
-		appl_writel(pcie, val, APPL_INTR_STATUS_L1_0_0);
+	status_l0 = appl_readl(pcie, APPL_INTR_STATUS_L0);
+	if (status_l0 & APPL_INTR_STATUS_L0_LINK_STATE_INT) {
+		status_l1 = appl_readl(pcie, APPL_INTR_STATUS_L1_0_0);
+		appl_writel(pcie, status_l1, APPL_INTR_STATUS_L1_0_0);
 
-		if (val & APPL_INTR_STATUS_L1_0_0_HOT_RESET_DONE)
+		if (status_l1 & APPL_INTR_STATUS_L1_0_0_HOT_RESET_DONE)
 			pex_ep_event_hot_rst_done(pcie);
 
-		if (val & APPL_INTR_STATUS_L1_0_0_RDLH_LINK_UP_CHGED) {
-			tmp = appl_readl(pcie, APPL_LINK_STATUS);
-			if (tmp & APPL_LINK_STATUS_RDLH_LINK_UP) {
+		if (status_l1 & APPL_INTR_STATUS_L1_0_0_RDLH_LINK_UP_CHGED) {
+			link_status = appl_readl(pcie, APPL_LINK_STATUS);
+			if (link_status & APPL_LINK_STATUS_RDLH_LINK_UP) {
 				dev_dbg(pcie->dev, "Link is up with Host\n");
 				dw_pcie_ep_linkup(ep);
 			}
@@ -518,11 +518,11 @@ static irqreturn_t tegra_pcie_ep_hard_irq(int irq, void *arg)
 		spurious = 0;
 	}
 
-	if (val & APPL_INTR_STATUS_L0_PCI_CMD_EN_INT) {
-		val = appl_readl(pcie, APPL_INTR_STATUS_L1_15);
-		appl_writel(pcie, val, APPL_INTR_STATUS_L1_15);
+	if (status_l0 & APPL_INTR_STATUS_L0_PCI_CMD_EN_INT) {
+		status_l1 = appl_readl(pcie, APPL_INTR_STATUS_L1_15);
+		appl_writel(pcie, status_l1, APPL_INTR_STATUS_L1_15);
 
-		if (val & APPL_INTR_STATUS_L1_15_CFG_BME_CHGED)
+		if (status_l1 & APPL_INTR_STATUS_L1_15_CFG_BME_CHGED)
 			return IRQ_WAKE_THREAD;
 
 		spurious = 0;
@@ -530,8 +530,8 @@ static irqreturn_t tegra_pcie_ep_hard_irq(int irq, void *arg)
 
 	if (spurious) {
 		dev_warn(pcie->dev, "Random interrupt (STATUS = 0x%08X)\n",
-			 val);
-		appl_writel(pcie, val, APPL_INTR_STATUS_L0);
+			 status_l0);
+		appl_writel(pcie, status_l0, APPL_INTR_STATUS_L0);
 	}
 
 	return IRQ_HANDLED;
-- 
2.30.2



