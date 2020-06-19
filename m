Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFB1201426
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391111AbgFSPEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:04:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:32800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391105AbgFSPEK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:04:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B9AC21BE5;
        Fri, 19 Jun 2020 15:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579049;
        bh=dtp5uvGLbHw4Xfc/4V3mo3lxqduEex7T+w3FHSLK934=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvhHEv0W1rbwEq0C+Kg1R3dPFYDZmj+PQyU+D+5pm4DpjBLghxN1n60GTtWGVagqn
         PBHyVNgal/QWPGMPLRvpGqXlPPIAACEwBTlOPg4Bi+jln0B9S7GP75lqgmvWhCIlbg
         o7ffc0GKzbMyuUeAZ/jdHREYgZnbckCrYChefzIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianjun Wang <jianjun.wang@mediatek.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 216/267] PCI: mediatek: Add controller support for MT7629
Date:   Fri, 19 Jun 2020 16:33:21 +0200
Message-Id: <20200619141659.084933223@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianjun Wang <jianjun.wang@mediatek.com>

[ Upstream commit 0cccd42e6193e168cbecc271dae464e4a53fd7b3 ]

MT7629 is an ARM platform SoC which has the same PCIe IP as MT7622.

The HW default value of its PCI host controller Device ID is invalid,
fix it to match the hardware implementation.

Signed-off-by: Jianjun Wang <jianjun.wang@mediatek.com>
[lorenzo.pieralisi@arm.com: commit log/minor spelling update]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Acked-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek.c | 18 ++++++++++++++++++
 include/linux/pci_ids.h                |  1 +
 2 files changed, 19 insertions(+)

diff --git a/drivers/pci/controller/pcie-mediatek.c b/drivers/pci/controller/pcie-mediatek.c
index 1bfbceb9f445..ca06d8bc01e7 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -72,6 +72,7 @@
 #define PCIE_MSI_VECTOR		0x0c0
 
 #define PCIE_CONF_VEND_ID	0x100
+#define PCIE_CONF_DEVICE_ID	0x102
 #define PCIE_CONF_CLASS_ID	0x106
 
 #define PCIE_INT_MASK		0x420
@@ -134,12 +135,16 @@ struct mtk_pcie_port;
 /**
  * struct mtk_pcie_soc - differentiate between host generations
  * @need_fix_class_id: whether this host's class ID needed to be fixed or not
+ * @need_fix_device_id: whether this host's device ID needed to be fixed or not
+ * @device_id: device ID which this host need to be fixed
  * @ops: pointer to configuration access functions
  * @startup: pointer to controller setting functions
  * @setup_irq: pointer to initialize IRQ functions
  */
 struct mtk_pcie_soc {
 	bool need_fix_class_id;
+	bool need_fix_device_id;
+	unsigned int device_id;
 	struct pci_ops *ops;
 	int (*startup)(struct mtk_pcie_port *port);
 	int (*setup_irq)(struct mtk_pcie_port *port, struct device_node *node);
@@ -678,6 +683,9 @@ static int mtk_pcie_startup_port_v2(struct mtk_pcie_port *port)
 		writew(val, port->base + PCIE_CONF_CLASS_ID);
 	}
 
+	if (soc->need_fix_device_id)
+		writew(soc->device_id, port->base + PCIE_CONF_DEVICE_ID);
+
 	/* 100ms timeout value should be enough for Gen1/2 training */
 	err = readl_poll_timeout(port->base + PCIE_LINK_STATUS_V2, val,
 				 !!(val & PCIE_PORT_LINKUP_V2), 20,
@@ -1213,11 +1221,21 @@ static const struct mtk_pcie_soc mtk_pcie_soc_mt7622 = {
 	.setup_irq = mtk_pcie_setup_irq,
 };
 
+static const struct mtk_pcie_soc mtk_pcie_soc_mt7629 = {
+	.need_fix_class_id = true,
+	.need_fix_device_id = true,
+	.device_id = PCI_DEVICE_ID_MEDIATEK_7629,
+	.ops = &mtk_pcie_ops_v2,
+	.startup = mtk_pcie_startup_port_v2,
+	.setup_irq = mtk_pcie_setup_irq,
+};
+
 static const struct of_device_id mtk_pcie_ids[] = {
 	{ .compatible = "mediatek,mt2701-pcie", .data = &mtk_pcie_soc_v1 },
 	{ .compatible = "mediatek,mt7623-pcie", .data = &mtk_pcie_soc_v1 },
 	{ .compatible = "mediatek,mt2712-pcie", .data = &mtk_pcie_soc_mt2712 },
 	{ .compatible = "mediatek,mt7622-pcie", .data = &mtk_pcie_soc_mt7622 },
+	{ .compatible = "mediatek,mt7629-pcie", .data = &mtk_pcie_soc_mt7629 },
 	{},
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index b952f1557f5d..a7abaaa9bc27 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2132,6 +2132,7 @@
 #define PCI_VENDOR_ID_MYRICOM		0x14c1
 
 #define PCI_VENDOR_ID_MEDIATEK		0x14c3
+#define PCI_DEVICE_ID_MEDIATEK_7629	0x7629
 
 #define PCI_VENDOR_ID_TITAN		0x14D2
 #define PCI_DEVICE_ID_TITAN_010L	0x8001
-- 
2.25.1



