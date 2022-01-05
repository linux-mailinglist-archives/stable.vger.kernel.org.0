Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C371B484F1D
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 09:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238444AbiAEIN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 03:13:26 -0500
Received: from inva020.nxp.com ([92.121.34.13]:39306 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238370AbiAEIM5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jan 2022 03:12:57 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 019A11A2371;
        Wed,  5 Jan 2022 09:12:56 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id BD6DD1A1298;
        Wed,  5 Jan 2022 09:12:55 +0100 (CET)
Received: from localhost.localdomain (shlinux2.ap.freescale.net [10.192.224.44])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 224DF183F0C2;
        Wed,  5 Jan 2022 16:12:54 +0800 (+08)
From:   Richard Zhu <hongxing.zhu@nxp.com>
To:     l.stach@pengutronix.de, bhelgaas@google.com, broonie@kernel.org,
        lorenzo.pieralisi@arm.com, jingoohan1@gmail.com, festevam@gmail.com
Cc:     hongxing.zhu@nxp.com, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-imx@nxp.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH v5 4/6] PCI: dwc: Add dw_pcie_host_ops.host_exit() callback
Date:   Wed,  5 Jan 2022 15:43:20 +0800
Message-Id: <1641368602-20401-5-git-send-email-hongxing.zhu@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1641368602-20401-1-git-send-email-hongxing.zhu@nxp.com>
References: <1641368602-20401-1-git-send-email-hongxing.zhu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When link is never came up in the link training after host_init.
The clocks and power supplies usage counter balance should be handled
properly on some DWC platforms (for example, i.MX PCIe).

Add a new host_exit() callback into dw_pcie_host_ops, then it could be
invoked to handle the unbalance issue in the error handling after
host_init() function when link is down.

Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
---
 drivers/pci/controller/dwc/pcie-designware-host.c | 5 ++++-
 drivers/pci/controller/dwc/pcie-designware.h      | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index f4755f3a03be..461863bde3c9 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -405,7 +405,7 @@ int dw_pcie_host_init(struct pcie_port *pp)
 	if (!dw_pcie_link_up(pci) && pci->ops && pci->ops->start_link) {
 		ret = pci->ops->start_link(pci);
 		if (ret)
-			goto err_free_msi;
+			goto err_host_init;
 	}
 
 	/* Ignore errors, the link may come up later */
@@ -417,6 +417,9 @@ int dw_pcie_host_init(struct pcie_port *pp)
 	if (!ret)
 		return 0;
 
+err_host_init:
+	if (pp->ops->host_exit)
+		pp->ops->host_exit(pp);
 err_free_msi:
 	if (pp->has_msi_ctrl)
 		dw_pcie_free_msi(pp);
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index 7d6e9b7576be..1153687ea9a6 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -174,6 +174,7 @@ enum dw_pcie_device_mode {
 
 struct dw_pcie_host_ops {
 	int (*host_init)(struct pcie_port *pp);
+	void (*host_exit)(struct pcie_port *pp);
 	int (*msi_host_init)(struct pcie_port *pp);
 };
 
-- 
2.25.1

