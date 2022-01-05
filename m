Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B148C484F19
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 09:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238423AbiAEINS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 03:13:18 -0500
Received: from inva020.nxp.com ([92.121.34.13]:39626 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238359AbiAEINE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jan 2022 03:13:04 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id EF7E41A125A;
        Wed,  5 Jan 2022 09:12:56 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8C3F51A10AF;
        Wed,  5 Jan 2022 09:12:56 +0100 (CET)
Received: from localhost.localdomain (shlinux2.ap.freescale.net [10.192.224.44])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 49A0A183ACDE;
        Wed,  5 Jan 2022 16:12:55 +0800 (+08)
From:   Richard Zhu <hongxing.zhu@nxp.com>
To:     l.stach@pengutronix.de, bhelgaas@google.com, broonie@kernel.org,
        lorenzo.pieralisi@arm.com, jingoohan1@gmail.com, festevam@gmail.com
Cc:     hongxing.zhu@nxp.com, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-imx@nxp.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH v5 5/6] PCI: imx6: Fix the regulator dump when link never came up
Date:   Wed,  5 Jan 2022 15:43:21 +0800
Message-Id: <1641368602-20401-6-git-send-email-hongxing.zhu@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1641368602-20401-1-git-send-email-hongxing.zhu@nxp.com>
References: <1641368602-20401-1-git-send-email-hongxing.zhu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When PCIe PHY link never came up and vpcie regulator is present, there
would be following dump when try to put the regulator.
Add a new host_exit() callback for i.MX PCIe driver to disable this
regulator and fix this dump when link never came up.

The driver should undo any enables it did itself, and not undo any
enables that anything else did which means it should never be basing
decisions on regulator_is_enabled().

To keep usage counter balance of the clocks, powers and so on. Do the
clock disable in the error handling after host_init too.

  imx6q-pcie 33800000.pcie: Phy link never came up
  imx6q-pcie: probe of 33800000.pcie failed with error -110
  ------------[ cut here ]------------
  WARNING: CPU: 3 PID: 119 at drivers/regulator/core.c:2256 _regulator_put.part.0+0x14c/0x158
  Modules linked in:
  CPU: 3 PID: 119 Comm: kworker/u8:2 Not tainted 5.13.0-rc7-next-20210625-94710-ge4e92b2588a3 #10
  Hardware name: FSL i.MX8MM EVK board (DT)
  Workqueue: events_unbound async_run_entry_fn
  pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
  pc : _regulator_put.part.0+0x14c/0x158
  lr : regulator_put+0x34/0x48
  sp : ffff8000122ebb30
  x29: ffff8000122ebb30 x28: ffff800011be7000 x27: 0000000000000000
  x26: 0000000000000000 x25: 0000000000000000 x24: ffff00000025f2bc
  x23: ffff00000025f2c0 x22: ffff00000025f010 x21: ffff8000122ebc18
  x20: ffff800011e3fa60 x19: ffff00000375fd80 x18: 0000000000000010
  x17: 000000040044ffff x16: 00400032b5503510 x15: 0000000000000108
  x14: ffff0000003cc938 x13: 00000000ffffffea x12: 0000000000000000
  x11: 0000000000000000 x10: ffff80001076ba88 x9 : ffff80001076a540
  x8 : ffff00000025f2c0 x7 : ffff0000001f4450 x6 : ffff000000176cd8
  x5 : ffff000003857880 x4 : 0000000000000000 x3 : ffff800011e3fe30
  x2 : ffff0000003cc4c0 x1 : 0000000000000000 x0 : 0000000000000001
  Call trace:
   _regulator_put.part.0+0x14c/0x158
   regulator_put+0x34/0x48
   devm_regulator_release+0x10/0x18
   release_nodes+0x38/0x60
   devres_release_all+0x88/0xd0
   really_probe+0xd0/0x2e8
   __driver_probe_device+0x74/0xd8
   driver_probe_device+0x7c/0x108
   __device_attach_driver+0x8c/0xd0
   bus_for_each_drv+0x74/0xc0
   __device_attach_async_helper+0xb4/0xd8
   async_run_entry_fn+0x30/0x100
   process_one_work+0x19c/0x320
   worker_thread+0x48/0x418
   kthread+0x14c/0x158
   ret_from_fork+0x10/0x18
  ---[ end trace 3664ca4a50ce849b ]---

Link: https://lore.kernel.org/r/20201105211159.1814485-11-robh@kernel.org
Fixes: 886a9c134755 ("PCI: dwc: Move link handling into common code")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
---
 drivers/pci/controller/dwc/pci-imx6.c | 36 +++++++++++++++++----------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 15908c184953..61b25f5cbf5c 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -369,8 +369,6 @@ static int imx6_pcie_attach_pd(struct device *dev)
 
 static void imx6_pcie_assert_core_reset(struct imx6_pcie *imx6_pcie)
 {
-	struct device *dev = imx6_pcie->pci->dev;
-
 	switch (imx6_pcie->drvdata->variant) {
 	case IMX7D:
 	case IMX8MQ:
@@ -400,14 +398,6 @@ static void imx6_pcie_assert_core_reset(struct imx6_pcie *imx6_pcie)
 				   IMX6Q_GPR1_PCIE_REF_CLK_EN, 0 << 16);
 		break;
 	}
-
-	if (imx6_pcie->vpcie && regulator_is_enabled(imx6_pcie->vpcie) > 0) {
-		int ret = regulator_disable(imx6_pcie->vpcie);
-
-		if (ret)
-			dev_err(dev, "failed to disable vpcie regulator: %d\n",
-				ret);
-	}
 }
 
 static unsigned int imx6_pcie_grp_offset(const struct imx6_pcie *imx6_pcie)
@@ -575,7 +565,7 @@ static int imx6_pcie_deassert_core_reset(struct imx6_pcie *imx6_pcie)
 	struct device *dev = pci->dev;
 	int ret, err;
 
-	if (imx6_pcie->vpcie && !regulator_is_enabled(imx6_pcie->vpcie)) {
+	if (imx6_pcie->vpcie) {
 		ret = regulator_enable(imx6_pcie->vpcie);
 		if (ret) {
 			dev_err(dev, "failed to enable vpcie regulator: %d\n",
@@ -648,7 +638,7 @@ static int imx6_pcie_deassert_core_reset(struct imx6_pcie *imx6_pcie)
 	return 0;
 
 err_clks:
-	if (imx6_pcie->vpcie && regulator_is_enabled(imx6_pcie->vpcie) > 0) {
+	if (imx6_pcie->vpcie) {
 		ret = regulator_disable(imx6_pcie->vpcie);
 		if (ret)
 			dev_err(dev, "failed to disable vpcie regulator: %d\n",
@@ -905,7 +895,6 @@ static int imx6_pcie_start_link(struct dw_pcie *pci)
 	dev_dbg(dev, "PHY DEBUG_R0=0x%08x DEBUG_R1=0x%08x\n",
 		dw_pcie_readl_dbi(pci, PCIE_PORT_DEBUG0),
 		dw_pcie_readl_dbi(pci, PCIE_PORT_DEBUG1));
-	imx6_pcie_reset_phy(imx6_pcie);
 	return ret;
 }
 
@@ -929,8 +918,29 @@ static int imx6_pcie_host_init(struct pcie_port *pp)
 	return 0;
 }
 
+static void imx6_pcie_host_exit(struct pcie_port *pp)
+{
+	struct dw_pcie *pci = to_dw_pcie_from_pp(pp);
+	struct device *dev = pci->dev;
+	struct imx6_pcie *imx6_pcie = to_imx6_pcie(pci);
+
+	imx6_pcie_reset_phy(imx6_pcie);
+	imx6_pcie_clk_disable(imx6_pcie);
+	switch (imx6_pcie->drvdata->variant) {
+	case IMX8MM:
+		if (phy_power_off(imx6_pcie->phy))
+			dev_err(dev, "unable to power off phy\n");
+		break;
+	default:
+		break;
+	}
+	if (imx6_pcie->vpcie)
+		regulator_disable(imx6_pcie->vpcie);
+}
+
 static const struct dw_pcie_host_ops imx6_pcie_host_ops = {
 	.host_init = imx6_pcie_host_init,
+	.host_exit = imx6_pcie_host_exit,
 };
 
 static const struct dw_pcie_ops dw_pcie_ops = {
-- 
2.25.1

