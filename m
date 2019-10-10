Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06CFAD25BC
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387959AbfJJIjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387971AbfJJIju (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:39:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEA8F21920;
        Thu, 10 Oct 2019 08:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696789;
        bh=TGYeBg12/iq0HiGgbjcQSknzFHxK4TpcgEVOsKH/c/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQCchUFvBE03VyozYOmkfipj1Ek4XiDidZh1l7c9e8aQhWB0+sP50A0CzFAGUVQLI
         Wee3ZQ9DjtvM9mnPsAlgsyobzQXCqwoEj5m25+1jrxVtjzcM7bWCBstVYVN7Gks4kv
         yuQwC6GVvpsnXbkB3IbgAW0i+VIsFPJbnHPLGxIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.3 053/148] PCI: vmd: Fix config addressing when using bus offsets
Date:   Thu, 10 Oct 2019 10:35:14 +0200
Message-Id: <20191010083614.366709635@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

commit e3dffa4f6c3612dea337c9c59191bd418afc941b upstream.

VMD maps child device config spaces to the VMD Config BAR linearly
regardless of the starting bus offset. Because of this, the config
address decode must ignore starting bus offsets when mapping the BDF to
the config space address.

Fixes: 2a5a9c9a20f9 ("PCI: vmd: Add offset to bus numbers if necessary")
Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/controller/vmd.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -94,6 +94,7 @@ struct vmd_dev {
 	struct resource		resources[3];
 	struct irq_domain	*irq_domain;
 	struct pci_bus		*bus;
+	u8			busn_start;
 
 	struct dma_map_ops	dma_ops;
 	struct dma_domain	dma_domain;
@@ -440,7 +441,8 @@ static char __iomem *vmd_cfg_addr(struct
 				  unsigned int devfn, int reg, int len)
 {
 	char __iomem *addr = vmd->cfgbar +
-			     (bus->number << 20) + (devfn << 12) + reg;
+			     ((bus->number - vmd->busn_start) << 20) +
+			     (devfn << 12) + reg;
 
 	if ((addr - vmd->cfgbar) + len >=
 	    resource_size(&vmd->dev->resource[VMD_CFGBAR]))
@@ -563,7 +565,7 @@ static int vmd_enable_domain(struct vmd_
 	unsigned long flags;
 	LIST_HEAD(resources);
 	resource_size_t offset[2] = {0};
-	resource_size_t membar2_offset = 0x2000, busn_start = 0;
+	resource_size_t membar2_offset = 0x2000;
 	struct pci_bus *child;
 
 	/*
@@ -606,14 +608,14 @@ static int vmd_enable_domain(struct vmd_
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
 
@@ -681,8 +683,8 @@ static int vmd_enable_domain(struct vmd_
 	pci_add_resource_offset(&resources, &vmd->resources[1], offset[0]);
 	pci_add_resource_offset(&resources, &vmd->resources[2], offset[1]);
 
-	vmd->bus = pci_create_root_bus(&vmd->dev->dev, busn_start, &vmd_ops,
-				       sd, &resources);
+	vmd->bus = pci_create_root_bus(&vmd->dev->dev, vmd->busn_start,
+				       &vmd_ops, sd, &resources);
 	if (!vmd->bus) {
 		pci_free_resource_list(&resources);
 		irq_domain_remove(vmd->irq_domain);


