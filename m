Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498F8484F10
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 09:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238352AbiAEING (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 03:13:06 -0500
Received: from inva020.nxp.com ([92.121.34.13]:39188 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238365AbiAEIMy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jan 2022 03:12:54 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 5280A1A2366;
        Wed,  5 Jan 2022 09:12:53 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 19B8C1A1298;
        Wed,  5 Jan 2022 09:12:53 +0100 (CET)
Received: from localhost.localdomain (shlinux2.ap.freescale.net [10.192.224.44])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id C9A45183F0C0;
        Wed,  5 Jan 2022 16:12:51 +0800 (+08)
From:   Richard Zhu <hongxing.zhu@nxp.com>
To:     l.stach@pengutronix.de, bhelgaas@google.com, broonie@kernel.org,
        lorenzo.pieralisi@arm.com, jingoohan1@gmail.com, festevam@gmail.com
Cc:     hongxing.zhu@nxp.com, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-imx@nxp.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH v5 2/6] PCI: imx6: Add the error propagation from host_init
Date:   Wed,  5 Jan 2022 15:43:18 +0800
Message-Id: <1641368602-20401-3-git-send-email-hongxing.zhu@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1641368602-20401-1-git-send-email-hongxing.zhu@nxp.com>
References: <1641368602-20401-1-git-send-email-hongxing.zhu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since there is error return check of the host_init callback, add error
check to imx6_pcie_deassert_core_reset() function, and change the
function type accordingly.

Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
---
 drivers/pci/controller/dwc/pci-imx6.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 1d324fd05d7f..13a4328bea19 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -546,24 +546,24 @@ static void imx7d_pcie_wait_for_phy_pll_lock(struct imx6_pcie *imx6_pcie)
 		dev_err(dev, "PCIe PLL lock timeout\n");
 }
 
-static void imx6_pcie_deassert_core_reset(struct imx6_pcie *imx6_pcie)
+static int imx6_pcie_deassert_core_reset(struct imx6_pcie *imx6_pcie)
 {
 	struct dw_pcie *pci = imx6_pcie->pci;
 	struct device *dev = pci->dev;
-	int ret;
+	int ret, err;
 
 	if (imx6_pcie->vpcie && !regulator_is_enabled(imx6_pcie->vpcie)) {
 		ret = regulator_enable(imx6_pcie->vpcie);
 		if (ret) {
 			dev_err(dev, "failed to enable vpcie regulator: %d\n",
 				ret);
-			return;
+			return ret;
 		}
 	}
 
-	ret = imx6_pcie_clk_enable(imx6_pcie);
-	if (ret) {
-		dev_err(dev, "unable to enable pcie clocks\n");
+	err = imx6_pcie_clk_enable(imx6_pcie);
+	if (err) {
+		dev_err(dev, "unable to enable pcie clocks: %d\n", err);
 		goto err_clks;
 	}
 
@@ -622,7 +622,7 @@ static void imx6_pcie_deassert_core_reset(struct imx6_pcie *imx6_pcie)
 		break;
 	}
 
-	return;
+	return 0;
 
 err_clks:
 	if (imx6_pcie->vpcie && regulator_is_enabled(imx6_pcie->vpcie) > 0) {
@@ -631,6 +631,7 @@ static void imx6_pcie_deassert_core_reset(struct imx6_pcie *imx6_pcie)
 			dev_err(dev, "failed to disable vpcie regulator: %d\n",
 				ret);
 	}
+	return err;
 }
 
 static void imx6_pcie_configure_type(struct imx6_pcie *imx6_pcie)
@@ -888,11 +889,18 @@ static int imx6_pcie_start_link(struct dw_pcie *pci)
 static int imx6_pcie_host_init(struct pcie_port *pp)
 {
 	struct dw_pcie *pci = to_dw_pcie_from_pp(pp);
+	struct device *dev = pci->dev;
 	struct imx6_pcie *imx6_pcie = to_imx6_pcie(pci);
+	int ret;
 
 	imx6_pcie_assert_core_reset(imx6_pcie);
 	imx6_pcie_init_phy(imx6_pcie);
-	imx6_pcie_deassert_core_reset(imx6_pcie);
+	ret = imx6_pcie_deassert_core_reset(imx6_pcie);
+	if (ret < 0) {
+		dev_err(dev, "pcie host init failed: %d.\n", ret);
+		return ret;
+	}
+
 	imx6_setup_phy_mpll(imx6_pcie);
 
 	return 0;
-- 
2.25.1

