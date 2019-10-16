Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F343D9E4E
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395551AbfJPV6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438107AbfJPV6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:02 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F33621D7C;
        Wed, 16 Oct 2019 21:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263081;
        bh=t8kCr9OERd06qMJrE5RDGH1pIt8S8DDPE6lr14OjXHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7BAikQlmoJtnkOStgReQ7nbsfixxshoK/A2XMEZVFUi4Ly4x2YPUHRA7y78H1Rj/
         MGIcCDSO2Xeqk3sLi5W2Ups0xRUrkJ65y161OsNnOUSLHDmPXs1YhF8SFqhW1R+RiC
         jYKmQK2/QLjKZuegqgKRMHzZzxou27DYTyT7XjHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sushma Kalakota <sushmax.kalakota@intel.com>
Subject: [PATCH 4.19 80/81] PCI: vmd: Fix config addressing when using bus offsets
Date:   Wed, 16 Oct 2019 14:51:31 -0700
Message-Id: <20191016214848.666862802@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
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
Signed-off-by: Sushma Kalakota <sushmax.kalakota@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/controller/vmd.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -97,6 +97,7 @@ struct vmd_dev {
 	struct resource		resources[3];
 	struct irq_domain	*irq_domain;
 	struct pci_bus		*bus;
+	u8			busn_start;
 
 #ifdef CONFIG_X86_DEV_DMA_OPS
 	struct dma_map_ops	dma_ops;
@@ -468,7 +469,8 @@ static char __iomem *vmd_cfg_addr(struct
 				  unsigned int devfn, int reg, int len)
 {
 	char __iomem *addr = vmd->cfgbar +
-			     (bus->number << 20) + (devfn << 12) + reg;
+			     ((bus->number - vmd->busn_start) << 20) +
+			     (devfn << 12) + reg;
 
 	if ((addr - vmd->cfgbar) + len >=
 	    resource_size(&vmd->dev->resource[VMD_CFGBAR]))
@@ -591,7 +593,7 @@ static int vmd_enable_domain(struct vmd_
 	unsigned long flags;
 	LIST_HEAD(resources);
 	resource_size_t offset[2] = {0};
-	resource_size_t membar2_offset = 0x2000, busn_start = 0;
+	resource_size_t membar2_offset = 0x2000;
 
 	/*
 	 * Shadow registers may exist in certain VMD device ids which allow
@@ -633,14 +635,14 @@ static int vmd_enable_domain(struct vmd_
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
 
@@ -708,8 +710,8 @@ static int vmd_enable_domain(struct vmd_
 	pci_add_resource_offset(&resources, &vmd->resources[1], offset[0]);
 	pci_add_resource_offset(&resources, &vmd->resources[2], offset[1]);
 
-	vmd->bus = pci_create_root_bus(&vmd->dev->dev, busn_start, &vmd_ops,
-				       sd, &resources);
+	vmd->bus = pci_create_root_bus(&vmd->dev->dev, vmd->busn_start,
+					&vmd_ops, sd, &resources);
 	if (!vmd->bus) {
 		pci_free_resource_list(&resources);
 		irq_domain_remove(vmd->irq_domain);


