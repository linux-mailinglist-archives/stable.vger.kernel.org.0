Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B234407743
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236526AbhIKNPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:15:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236592AbhIKNOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:14:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D750E6124B;
        Sat, 11 Sep 2021 13:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365975;
        bh=KfGxBqgb3mnKJOc11Ogxd2i4fFLWa3cqb+xQVzKN5Vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GV5sPZlOHs4BE4OleIkQ2pk/MxUyrMFh8f3D/0rvxftbNTbKaqO65HG6OgGmO5Ts7
         NXXGV/vMolql/58QAX45bmYSEw+6Z7NU6LPyjJy6MZlUc7VkO/REEZB6LQ4LZ/TEFS
         /FXk3y68M1H3RUQw4dhLgTEoMUMt7hkM4uqtQj2LBPuCNQs97pJ20aeT0jQL0+7exM
         GESCuBIUcwY+zQ9ffhJzhEr/LZfRkeMSUgMsX32iDNanOYpMjPhVlMRdpkK/hzpVji
         49ZZeflUvDhqKtTIXaWtgnY32QsNNsCM111ik0P+xhqDIn+aqiwzcT7skuURbuBMOz
         f1/AIg9JLuC6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 16/29] PCI: j721e: Add PCIe support for J7200
Date:   Sat, 11 Sep 2021 09:12:20 -0400
Message-Id: <20210911131233.284800-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131233.284800-1-sashal@kernel.org>
References: <20210911131233.284800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit f1de58802f0fff364cf49f5e47d1be744baa434f ]

J7200 has the same PCIe IP as in J721E with minor changes in the
wrapper. J7200 allows byte access of bridge configuration space
registers and the register field for LINK_DOWN interrupt is different.
J7200 also requires "quirk_detect_quiet_flag" to be set. Configure these
changes as part of driver data applicable only to J7200.

Link: https://lore.kernel.org/r/20210811123336.31357-4-kishon@ti.com
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pci-j721e.c | 40 +++++++++++++++++++---
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/cadence/pci-j721e.c b/drivers/pci/controller/cadence/pci-j721e.c
index 0c5813b230b4..10b13b728284 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -27,6 +27,7 @@
 #define STATUS_REG_SYS_2	0x508
 #define STATUS_CLR_REG_SYS_2	0x708
 #define LINK_DOWN		BIT(1)
+#define J7200_LINK_DOWN		BIT(10)
 
 #define J721E_PCIE_USER_CMD_STATUS	0x4
 #define LINK_TRAINING_ENABLE		BIT(0)
@@ -57,6 +58,7 @@ struct j721e_pcie {
 	struct cdns_pcie	*cdns_pcie;
 	void __iomem		*user_cfg_base;
 	void __iomem		*intd_cfg_base;
+	u32			linkdown_irq_regfield;
 };
 
 enum j721e_pcie_mode {
@@ -67,6 +69,9 @@ enum j721e_pcie_mode {
 struct j721e_pcie_data {
 	enum j721e_pcie_mode	mode;
 	unsigned int		quirk_retrain_flag:1;
+	unsigned int		quirk_detect_quiet_flag:1;
+	u32			linkdown_irq_regfield;
+	unsigned int		byte_access_allowed:1;
 };
 
 static inline u32 j721e_pcie_user_readl(struct j721e_pcie *pcie, u32 offset)
@@ -98,12 +103,12 @@ static irqreturn_t j721e_pcie_link_irq_handler(int irq, void *priv)
 	u32 reg;
 
 	reg = j721e_pcie_intd_readl(pcie, STATUS_REG_SYS_2);
-	if (!(reg & LINK_DOWN))
+	if (!(reg & pcie->linkdown_irq_regfield))
 		return IRQ_NONE;
 
 	dev_err(dev, "LINK DOWN!\n");
 
-	j721e_pcie_intd_writel(pcie, STATUS_CLR_REG_SYS_2, LINK_DOWN);
+	j721e_pcie_intd_writel(pcie, STATUS_CLR_REG_SYS_2, pcie->linkdown_irq_regfield);
 	return IRQ_HANDLED;
 }
 
@@ -112,7 +117,7 @@ static void j721e_pcie_config_link_irq(struct j721e_pcie *pcie)
 	u32 reg;
 
 	reg = j721e_pcie_intd_readl(pcie, ENABLE_REG_SYS_2);
-	reg |= LINK_DOWN;
+	reg |= pcie->linkdown_irq_regfield;
 	j721e_pcie_intd_writel(pcie, ENABLE_REG_SYS_2, reg);
 }
 
@@ -284,10 +289,25 @@ static struct pci_ops cdns_ti_pcie_host_ops = {
 static const struct j721e_pcie_data j721e_pcie_rc_data = {
 	.mode = PCI_MODE_RC,
 	.quirk_retrain_flag = true,
+	.byte_access_allowed = false,
+	.linkdown_irq_regfield = LINK_DOWN,
 };
 
 static const struct j721e_pcie_data j721e_pcie_ep_data = {
 	.mode = PCI_MODE_EP,
+	.linkdown_irq_regfield = LINK_DOWN,
+};
+
+static const struct j721e_pcie_data j7200_pcie_rc_data = {
+	.mode = PCI_MODE_RC,
+	.quirk_detect_quiet_flag = true,
+	.linkdown_irq_regfield = J7200_LINK_DOWN,
+	.byte_access_allowed = true,
+};
+
+static const struct j721e_pcie_data j7200_pcie_ep_data = {
+	.mode = PCI_MODE_EP,
+	.quirk_detect_quiet_flag = true,
 };
 
 static const struct of_device_id of_j721e_pcie_match[] = {
@@ -299,6 +319,14 @@ static const struct of_device_id of_j721e_pcie_match[] = {
 		.compatible = "ti,j721e-pcie-ep",
 		.data = &j721e_pcie_ep_data,
 	},
+	{
+		.compatible = "ti,j7200-pcie-host",
+		.data = &j7200_pcie_rc_data,
+	},
+	{
+		.compatible = "ti,j7200-pcie-ep",
+		.data = &j7200_pcie_ep_data,
+	},
 	{},
 };
 
@@ -332,6 +360,7 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 
 	pcie->dev = dev;
 	pcie->mode = mode;
+	pcie->linkdown_irq_regfield = data->linkdown_irq_regfield;
 
 	base = devm_platform_ioremap_resource_byname(pdev, "intd_cfg");
 	if (IS_ERR(base))
@@ -391,9 +420,11 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 			goto err_get_sync;
 		}
 
-		bridge->ops = &cdns_ti_pcie_host_ops;
+		if (!data->byte_access_allowed)
+			bridge->ops = &cdns_ti_pcie_host_ops;
 		rc = pci_host_bridge_priv(bridge);
 		rc->quirk_retrain_flag = data->quirk_retrain_flag;
+		rc->quirk_detect_quiet_flag = data->quirk_detect_quiet_flag;
 
 		cdns_pcie = &rc->pcie;
 		cdns_pcie->dev = dev;
@@ -459,6 +490,7 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 			ret = -ENOMEM;
 			goto err_get_sync;
 		}
+		ep->quirk_detect_quiet_flag = data->quirk_detect_quiet_flag;
 
 		cdns_pcie = &ep->pcie;
 		cdns_pcie->dev = dev;
-- 
2.30.2

