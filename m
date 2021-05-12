Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2645037D24A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237765AbhELSIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:08:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352153AbhELSCh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:02:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ED746142C;
        Wed, 12 May 2021 18:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842488;
        bh=SX3vtGdfkaIFSrcOF67/KYO8+uPemnaQDZtNcVxPI6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Em/frt5ECPkoYS15KKYwFxMSKr+w6sTBZVEvR/p0BKjE6gv3QJb7z8prguqXKviSd
         QTWEUj12zvJEdLF6lmFFW2pqEZ8iv/rfW+oiIx31xBCv1C+5neuKLgAN9FAcEPcC40
         t+0mbkQ3HVXpido0hef8cFQ6thhp01Vq/BlvXpwtxnLbhOwEeN2LT6uLZTLULhl4dW
         lwEKVvShlo1/gounMwWziLHK3HGtdjpSPI1mTvzKJ2nGs8BKR4N0cruRNEnxw8nTrt
         kFCS1Nox0SVZ/xHHQZG2PY42PvPUpcbnaP6QXsrDowZ3MPWJySIdIM6JkwQP5Q6Qtg
         ZNnRJDAJMEFAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vidya Sagar <vidyas@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 16/37] PCI: tegra: Add Tegra194 MCFG quirks for ECAM errata
Date:   Wed, 12 May 2021 14:00:43 -0400
Message-Id: <20210512180104.664121-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180104.664121-1-sashal@kernel.org>
References: <20210512180104.664121-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit 7f100744749e4fe547dece3bb6557fae5f0a7252 ]

The PCIe controller in Tegra194 SoC is not ECAM-compliant.  With the
current hardware design, ECAM can be enabled only for one controller (the
C5 controller) with bus numbers starting from 160 instead of 0. A different
approach is taken to avoid this abnormal way of enabling ECAM for just one
controller but to enable configuration space access for all the other
controllers. In this approach, ops are added through MCFG quirk mechanism
which access the configuration spaces by dynamically programming iATU
(internal AddressTranslation Unit) to generate respective configuration
accesses just like the way it is done in DesignWare core sub-system.

This issue is specific to Tegra194 and it would be fixed in the future
generations of Tegra SoCs.

Link: https://lore.kernel.org/r/20210416134537.19474-1-vidyas@nvidia.com
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pci_mcfg.c                    |   7 ++
 drivers/pci/controller/dwc/Makefile        |   2 +-
 drivers/pci/controller/dwc/pcie-tegra194.c | 102 +++++++++++++++++++++
 include/linux/pci-ecam.h                   |   1 +
 4 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/pci_mcfg.c b/drivers/acpi/pci_mcfg.c
index 95f23acd5b80..53cab975f612 100644
--- a/drivers/acpi/pci_mcfg.c
+++ b/drivers/acpi/pci_mcfg.c
@@ -116,6 +116,13 @@ static struct mcfg_fixup mcfg_quirks[] = {
 	THUNDER_ECAM_QUIRK(2, 12),
 	THUNDER_ECAM_QUIRK(2, 13),
 
+	{ "NVIDIA", "TEGRA194", 1, 0, MCFG_BUS_ANY, &tegra194_pcie_ops},
+	{ "NVIDIA", "TEGRA194", 1, 1, MCFG_BUS_ANY, &tegra194_pcie_ops},
+	{ "NVIDIA", "TEGRA194", 1, 2, MCFG_BUS_ANY, &tegra194_pcie_ops},
+	{ "NVIDIA", "TEGRA194", 1, 3, MCFG_BUS_ANY, &tegra194_pcie_ops},
+	{ "NVIDIA", "TEGRA194", 1, 4, MCFG_BUS_ANY, &tegra194_pcie_ops},
+	{ "NVIDIA", "TEGRA194", 1, 5, MCFG_BUS_ANY, &tegra194_pcie_ops},
+
 #define XGENE_V1_ECAM_MCFG(rev, seg) \
 	{"APM   ", "XGENE   ", rev, seg, MCFG_BUS_ANY, \
 		&xgene_v1_pcie_ecam_ops }
diff --git a/drivers/pci/controller/dwc/Makefile b/drivers/pci/controller/dwc/Makefile
index a751553fa0db..dbb981876556 100644
--- a/drivers/pci/controller/dwc/Makefile
+++ b/drivers/pci/controller/dwc/Makefile
@@ -17,7 +17,6 @@ obj-$(CONFIG_PCIE_INTEL_GW) += pcie-intel-gw.o
 obj-$(CONFIG_PCIE_KIRIN) += pcie-kirin.o
 obj-$(CONFIG_PCIE_HISI_STB) += pcie-histb.o
 obj-$(CONFIG_PCI_MESON) += pci-meson.o
-obj-$(CONFIG_PCIE_TEGRA194) += pcie-tegra194.o
 obj-$(CONFIG_PCIE_UNIPHIER) += pcie-uniphier.o
 obj-$(CONFIG_PCIE_UNIPHIER_EP) += pcie-uniphier-ep.o
 
@@ -34,4 +33,5 @@ obj-$(CONFIG_PCIE_UNIPHIER_EP) += pcie-uniphier-ep.o
 ifdef CONFIG_PCI
 obj-$(CONFIG_ARM64) += pcie-al.o
 obj-$(CONFIG_ARM64) += pcie-hisi.o
+obj-$(CONFIG_ARM64) += pcie-tegra194.o
 endif
diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 0e94190ca4e8..926a8def2e26 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -22,6 +22,8 @@
 #include <linux/of_irq.h>
 #include <linux/of_pci.h>
 #include <linux/pci.h>
+#include <linux/pci-acpi.h>
+#include <linux/pci-ecam.h>
 #include <linux/phy/phy.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
@@ -311,6 +313,104 @@ struct tegra_pcie_dw_of_data {
 	enum dw_pcie_device_mode mode;
 };
 
+#if defined(CONFIG_ACPI) && defined(CONFIG_PCI_QUIRKS)
+struct tegra194_pcie_ecam  {
+	void __iomem *config_base;
+	void __iomem *iatu_base;
+	void __iomem *dbi_base;
+};
+
+static int tegra194_acpi_init(struct pci_config_window *cfg)
+{
+	struct device *dev = cfg->parent;
+	struct tegra194_pcie_ecam *pcie_ecam;
+
+	pcie_ecam = devm_kzalloc(dev, sizeof(*pcie_ecam), GFP_KERNEL);
+	if (!pcie_ecam)
+		return -ENOMEM;
+
+	pcie_ecam->config_base = cfg->win;
+	pcie_ecam->iatu_base = cfg->win + SZ_256K;
+	pcie_ecam->dbi_base = cfg->win + SZ_512K;
+	cfg->priv = pcie_ecam;
+
+	return 0;
+}
+
+static void atu_reg_write(struct tegra194_pcie_ecam *pcie_ecam, int index,
+			  u32 val, u32 reg)
+{
+	u32 offset = PCIE_GET_ATU_OUTB_UNR_REG_OFFSET(index);
+
+	writel(val, pcie_ecam->iatu_base + offset + reg);
+}
+
+static void program_outbound_atu(struct tegra194_pcie_ecam *pcie_ecam,
+				 int index, int type, u64 cpu_addr,
+				 u64 pci_addr, u64 size)
+{
+	atu_reg_write(pcie_ecam, index, lower_32_bits(cpu_addr),
+		      PCIE_ATU_LOWER_BASE);
+	atu_reg_write(pcie_ecam, index, upper_32_bits(cpu_addr),
+		      PCIE_ATU_UPPER_BASE);
+	atu_reg_write(pcie_ecam, index, lower_32_bits(pci_addr),
+		      PCIE_ATU_LOWER_TARGET);
+	atu_reg_write(pcie_ecam, index, lower_32_bits(cpu_addr + size - 1),
+		      PCIE_ATU_LIMIT);
+	atu_reg_write(pcie_ecam, index, upper_32_bits(pci_addr),
+		      PCIE_ATU_UPPER_TARGET);
+	atu_reg_write(pcie_ecam, index, type, PCIE_ATU_CR1);
+	atu_reg_write(pcie_ecam, index, PCIE_ATU_ENABLE, PCIE_ATU_CR2);
+}
+
+static void __iomem *tegra194_map_bus(struct pci_bus *bus,
+				      unsigned int devfn, int where)
+{
+	struct pci_config_window *cfg = bus->sysdata;
+	struct tegra194_pcie_ecam *pcie_ecam = cfg->priv;
+	u32 busdev;
+	int type;
+
+	if (bus->number < cfg->busr.start || bus->number > cfg->busr.end)
+		return NULL;
+
+	if (bus->number == cfg->busr.start) {
+		if (PCI_SLOT(devfn) == 0)
+			return pcie_ecam->dbi_base + where;
+		else
+			return NULL;
+	}
+
+	busdev = PCIE_ATU_BUS(bus->number) | PCIE_ATU_DEV(PCI_SLOT(devfn)) |
+		 PCIE_ATU_FUNC(PCI_FUNC(devfn));
+
+	if (bus->parent->number == cfg->busr.start) {
+		if (PCI_SLOT(devfn) == 0)
+			type = PCIE_ATU_TYPE_CFG0;
+		else
+			return NULL;
+	} else {
+		type = PCIE_ATU_TYPE_CFG1;
+	}
+
+	program_outbound_atu(pcie_ecam, 0, type, cfg->res.start, busdev,
+			     SZ_256K);
+
+	return pcie_ecam->config_base + where;
+}
+
+const struct pci_ecam_ops tegra194_pcie_ops = {
+	.init		= tegra194_acpi_init,
+	.pci_ops	= {
+		.map_bus	= tegra194_map_bus,
+		.read		= pci_generic_config_read,
+		.write		= pci_generic_config_write,
+	}
+};
+#endif /* defined(CONFIG_ACPI) && defined(CONFIG_PCI_QUIRKS) */
+
+#ifdef CONFIG_PCIE_TEGRA194
+
 static inline struct tegra_pcie_dw *to_tegra_pcie(struct dw_pcie *pci)
 {
 	return container_of(pci, struct tegra_pcie_dw, pci);
@@ -2311,3 +2411,5 @@ MODULE_DEVICE_TABLE(of, tegra_pcie_dw_of_match);
 MODULE_AUTHOR("Vidya Sagar <vidyas@nvidia.com>");
 MODULE_DESCRIPTION("NVIDIA PCIe host controller driver");
 MODULE_LICENSE("GPL v2");
+
+#endif /* CONFIG_PCIE_TEGRA194 */
diff --git a/include/linux/pci-ecam.h b/include/linux/pci-ecam.h
index 65d3d83015c3..fbdadd4d8377 100644
--- a/include/linux/pci-ecam.h
+++ b/include/linux/pci-ecam.h
@@ -85,6 +85,7 @@ extern const struct pci_ecam_ops pci_thunder_ecam_ops; /* Cavium ThunderX 1.x */
 extern const struct pci_ecam_ops xgene_v1_pcie_ecam_ops; /* APM X-Gene PCIe v1 */
 extern const struct pci_ecam_ops xgene_v2_pcie_ecam_ops; /* APM X-Gene PCIe v2.x */
 extern const struct pci_ecam_ops al_pcie_ops;	/* Amazon Annapurna Labs PCIe */
+extern const struct pci_ecam_ops tegra194_pcie_ops; /* Tegra194 PCIe */
 #endif
 
 #if IS_ENABLED(CONFIG_PCI_HOST_COMMON)
-- 
2.30.2

