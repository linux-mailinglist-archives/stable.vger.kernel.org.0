Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D35D2416BC
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 23:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406954AbfFKVPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 17:15:44 -0400
Received: from mga06.intel.com ([134.134.136.31]:28104 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406935AbfFKVPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 17:15:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jun 2019 14:15:44 -0700
X-ExtLoop1: 1
Received: from jderrick-mobl.amr.corp.intel.com ([10.232.115.162])
  by orsmga006.jf.intel.com with ESMTP; 11 Jun 2019 14:15:43 -0700
From:   Jon Derrick <jonathan.derrick@intel.com>
To:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Keith Busch <keith.busch@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        <linux-pci@vger.kernel.org>,
        Jon Derrick <jonathan.derrick@intel.com>
Subject: [PATCH] PCI/VMD: Fix config addressing with bus offsets
Date:   Tue, 11 Jun 2019 15:15:38 -0600
Message-Id: <20190611211538.29151-1-jonathan.derrick@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VMD config space addressing relies on mapping the BDF of the target into
the VMD config bar. When using bus number offsets to number the VMD
domain, the offset needs to be ignored in order to correctly map devices
to their config space.

Fixes: 2a5a9c9a20f9 ("PCI: vmd: Add offset to bus numbers if necessary")
Cc: <stable@vger.kernel.org> # v4.19
Cc: <stable@vger.kernel.org> # v4.18
Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
---
 drivers/pci/controller/vmd.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index fd2dbd7..a59afec 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -94,6 +94,7 @@ struct vmd_dev {
 	struct resource		resources[3];
 	struct irq_domain	*irq_domain;
 	struct pci_bus		*bus;
+	u8			busn_start;
 
 #ifdef CONFIG_X86_DEV_DMA_OPS
 	struct dma_map_ops	dma_ops;
@@ -465,7 +466,8 @@ static char __iomem *vmd_cfg_addr(struct vmd_dev *vmd, struct pci_bus *bus,
 				  unsigned int devfn, int reg, int len)
 {
 	char __iomem *addr = vmd->cfgbar +
-			     (bus->number << 20) + (devfn << 12) + reg;
+			     ((bus->number - vmd->busn_start) << 20) +
+			     (devfn << 12) + reg;
 
 	if ((addr - vmd->cfgbar) + len >=
 	    resource_size(&vmd->dev->resource[VMD_CFGBAR]))
@@ -588,7 +590,7 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
 	unsigned long flags;
 	LIST_HEAD(resources);
 	resource_size_t offset[2] = {0};
-	resource_size_t membar2_offset = 0x2000, busn_start = 0;
+	resource_size_t membar2_offset = 0x2000;
 
 	/*
 	 * Shadow registers may exist in certain VMD device ids which allow
@@ -630,14 +632,14 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
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
 
@@ -705,8 +707,8 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
 	pci_add_resource_offset(&resources, &vmd->resources[1], offset[0]);
 	pci_add_resource_offset(&resources, &vmd->resources[2], offset[1]);
 
-	vmd->bus = pci_create_root_bus(&vmd->dev->dev, busn_start, &vmd_ops,
-				       sd, &resources);
+	vmd->bus = pci_create_root_bus(&vmd->dev->dev, vmd->busn_start,
+				       &vmd_ops, sd, &resources);
 	if (!vmd->bus) {
 		pci_free_resource_list(&resources);
 		irq_domain_remove(vmd->irq_domain);
-- 
1.8.3.1

