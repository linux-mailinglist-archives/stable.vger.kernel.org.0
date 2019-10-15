Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98367D842A
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 01:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390181AbfJOXCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 19:02:54 -0400
Received: from mga12.intel.com ([192.55.52.136]:46916 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730039AbfJOXCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 19:02:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 16:02:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,301,1566889200"; 
   d="scan'208";a="347242961"
Received: from nodlab-s2600wft.lm.intel.com (HELO skalakox.lm.intel.com) ([10.232.116.60])
  by orsmga004.jf.intel.com with ESMTP; 15 Oct 2019 16:02:52 -0700
From:   Sushma Kalakota <sushmax.kalakota@intel.com>
To:     stable@vger.kernel.org
Cc:     Jon Derrick <jonathan.derrick@intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sushma Kalakota <sushmax.kalakota@intel.com>
Subject: [BACKPORT v4.19] PCI: vmd: Fix config addressing when using bus offsets
Date:   Tue, 15 Oct 2019 17:06:07 -0600
Message-Id: <20191015230607.5330-1-sushmax.kalakota@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

commit e3dffa4f6c3612dea337c9c59191bd418afc941b upstream

This is a backport due to feature dependencies preventing
the upstream patch from applying cleanly.

VMD maps child device config spaces to the VMD Config BAR linearly
regardless of the starting bus offset. Because of this, the config
address decode must ignore starting bus offsets when mapping the BDF to
the config space address.

Fixes: 2a5a9c9a20f9 ("PCI: vmd: Add offset to bus numbers if necessary")
Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Signed-off-by: Sushma Kalakota <sushmax.kalakota@intel.com>
---
 drivers/pci/controller/vmd.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index 52d4fa4161dc..65eaa6b61868 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -97,6 +97,7 @@ struct vmd_dev {
 	struct resource		resources[3];
 	struct irq_domain	*irq_domain;
 	struct pci_bus		*bus;
+	u8			busn_start;
 
 #ifdef CONFIG_X86_DEV_DMA_OPS
 	struct dma_map_ops	dma_ops;
@@ -468,7 +469,8 @@ static char __iomem *vmd_cfg_addr(struct vmd_dev *vmd, struct pci_bus *bus,
 				  unsigned int devfn, int reg, int len)
 {
 	char __iomem *addr = vmd->cfgbar +
-			     (bus->number << 20) + (devfn << 12) + reg;
+			     ((bus->number - vmd->busn_start) << 20) +
+			     (devfn << 12) + reg;
 
 	if ((addr - vmd->cfgbar) + len >=
 	    resource_size(&vmd->dev->resource[VMD_CFGBAR]))
@@ -591,7 +593,7 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
 	unsigned long flags;
 	LIST_HEAD(resources);
 	resource_size_t offset[2] = {0};
-	resource_size_t membar2_offset = 0x2000, busn_start = 0;
+	resource_size_t membar2_offset = 0x2000;
 
 	/*
 	 * Shadow registers may exist in certain VMD device ids which allow
@@ -633,14 +635,14 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
 		pci_read_config_dword(vmd->dev, PCI_REG_VMCONFIG, &vmconfig);
 		if (BUS_RESTRICT_CAP(vmcap) &&
 		    (BUS_RESTRICT_CFG(vmconfig) == 0x1))
-			busn_start = 128;
+			vmd->busn_start = 128;
 	}
 
 	res = &vmd->dev->resource[VMD_CFGBAR];
 	vmd->resources[0] = (struct resource) {
 		.name  = "VMD CFGBAR",
-		.start = busn_start,
-		.end   = busn_start + (resource_size(res) >> 20) - 1,
+		.start = vmd->busn_start,
+		.end   = vmd->busn_start + (resource_size(res) >> 20) - 1,
 		.flags = IORESOURCE_BUS | IORESOURCE_PCI_FIXED,
 	};
 
@@ -708,8 +710,8 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
 	pci_add_resource_offset(&resources, &vmd->resources[1], offset[0]);
 	pci_add_resource_offset(&resources, &vmd->resources[2], offset[1]);
 
-	vmd->bus = pci_create_root_bus(&vmd->dev->dev, busn_start, &vmd_ops,
-				       sd, &resources);
+	vmd->bus = pci_create_root_bus(&vmd->dev->dev, vmd->busn_start,
+					&vmd_ops, sd, &resources);
 	if (!vmd->bus) {
 		pci_free_resource_list(&resources);
 		irq_domain_remove(vmd->irq_domain);
-- 
2.17.1

