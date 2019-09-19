Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 676BFB8772
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405024AbfISWFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405017AbfISWFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:05:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BED5218AF;
        Thu, 19 Sep 2019 22:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930740;
        bh=dlmc9ydi+R3F2noOv0d6WqylLM7f+rTyJ1JHOwZrmOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qyKCGtnQtSGkGEBkSbGuDt+CbQBZx3QS5bGAKZ7g45ENkFi9GWivL6OOe79ne+mFD
         TF4anOEz6EMek8QVSKcfFmiD8FtRjSG36QgiWxZhexNeiDlv8Ix30IgiQ8PwkxrLiZ
         oRXrC/1P8Vs/r4EOpyyEyfmeK5Q7d+tWlVjewBEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>,
        Evan Green <evgreen@chromium.org>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        Marc Gonzalez <marc.w.gonzalez@free.fr>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 5.3 19/21] phy: qcom-qmp: Correct ready status, again
Date:   Fri, 20 Sep 2019 00:03:20 +0200
Message-Id: <20190919214713.133603641@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214657.842130855@linuxfoundation.org>
References: <20190919214657.842130855@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit 14ced7e3a1ae9bed7051df3718c8c7b583854a5c upstream.

Despite extensive testing of commit 885bd765963b ("phy: qcom-qmp: Correct
READY_STATUS poll break condition") I failed to conclude that the
PHYSTATUS bit of the PCS_STATUS register used in PCIe and USB3 falls as
the PHY gets ready. Similar to the prior bug with UFS the code will
generally get past the check before the transition and thereby
"succeed".

Correct the name of the register used PCIe and USB3 PHYs, replace
mask_pcs_ready with a constant expression depending on the type of the
PHY and check for the appropriate ready state.

Cc: stable@vger.kernel.org
Cc: Vivek Gautam <vivek.gautam@codeaurora.org>
Cc: Evan Green <evgreen@chromium.org>
Cc: Niklas Cassel <niklas.cassel@linaro.org>
Reported-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
Fixes: 885bd765963b ("phy: qcom-qmp: Correct READY_STATUS poll break condition")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Tested-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/phy/qualcomm/phy-qcom-qmp.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -35,7 +35,7 @@
 #define PLL_READY_GATE_EN			BIT(3)
 /* QPHY_PCS_STATUS bit */
 #define PHYSTATUS				BIT(6)
-/* QPHY_COM_PCS_READY_STATUS bit */
+/* QPHY_PCS_READY_STATUS & QPHY_COM_PCS_READY_STATUS bit */
 #define PCS_READY				BIT(0)
 
 /* QPHY_V3_DP_COM_RESET_OVRD_CTRL register bits */
@@ -115,6 +115,7 @@ enum qphy_reg_layout {
 	QPHY_SW_RESET,
 	QPHY_START_CTRL,
 	QPHY_PCS_READY_STATUS,
+	QPHY_PCS_STATUS,
 	QPHY_PCS_AUTONOMOUS_MODE_CTRL,
 	QPHY_PCS_LFPS_RXTERM_IRQ_CLEAR,
 	QPHY_PCS_LFPS_RXTERM_IRQ_STATUS,
@@ -133,7 +134,7 @@ static const unsigned int pciephy_regs_l
 	[QPHY_FLL_MAN_CODE]		= 0xd4,
 	[QPHY_SW_RESET]			= 0x00,
 	[QPHY_START_CTRL]		= 0x08,
-	[QPHY_PCS_READY_STATUS]		= 0x174,
+	[QPHY_PCS_STATUS]		= 0x174,
 };
 
 static const unsigned int usb3phy_regs_layout[] = {
@@ -144,7 +145,7 @@ static const unsigned int usb3phy_regs_l
 	[QPHY_FLL_MAN_CODE]		= 0xd0,
 	[QPHY_SW_RESET]			= 0x00,
 	[QPHY_START_CTRL]		= 0x08,
-	[QPHY_PCS_READY_STATUS]		= 0x17c,
+	[QPHY_PCS_STATUS]		= 0x17c,
 	[QPHY_PCS_AUTONOMOUS_MODE_CTRL]	= 0x0d4,
 	[QPHY_PCS_LFPS_RXTERM_IRQ_CLEAR]  = 0x0d8,
 	[QPHY_PCS_LFPS_RXTERM_IRQ_STATUS] = 0x178,
@@ -153,7 +154,7 @@ static const unsigned int usb3phy_regs_l
 static const unsigned int qmp_v3_usb3phy_regs_layout[] = {
 	[QPHY_SW_RESET]			= 0x00,
 	[QPHY_START_CTRL]		= 0x08,
-	[QPHY_PCS_READY_STATUS]		= 0x174,
+	[QPHY_PCS_STATUS]		= 0x174,
 	[QPHY_PCS_AUTONOMOUS_MODE_CTRL]	= 0x0d8,
 	[QPHY_PCS_LFPS_RXTERM_IRQ_CLEAR]  = 0x0dc,
 	[QPHY_PCS_LFPS_RXTERM_IRQ_STATUS] = 0x170,
@@ -911,7 +912,6 @@ struct qmp_phy_cfg {
 
 	unsigned int start_ctrl;
 	unsigned int pwrdn_ctrl;
-	unsigned int mask_pcs_ready;
 	unsigned int mask_com_pcs_ready;
 
 	/* true, if PHY has a separate PHY_COM control block */
@@ -1074,7 +1074,6 @@ static const struct qmp_phy_cfg msm8996_
 
 	.start_ctrl		= PCS_START | PLL_READY_GATE_EN,
 	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
-	.mask_pcs_ready		= PHYSTATUS,
 	.mask_com_pcs_ready	= PCS_READY,
 
 	.has_phy_com_ctrl	= true,
@@ -1106,7 +1105,6 @@ static const struct qmp_phy_cfg msm8996_
 
 	.start_ctrl		= SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN,
-	.mask_pcs_ready		= PHYSTATUS,
 };
 
 /* list of resets */
@@ -1136,7 +1134,6 @@ static const struct qmp_phy_cfg ipq8074_
 
 	.start_ctrl		= SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
-	.mask_pcs_ready		= PHYSTATUS,
 
 	.has_phy_com_ctrl	= false,
 	.has_lane_rst		= false,
@@ -1167,7 +1164,6 @@ static const struct qmp_phy_cfg qmp_v3_u
 
 	.start_ctrl		= SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN,
-	.mask_pcs_ready		= PHYSTATUS,
 
 	.has_pwrdn_delay	= true,
 	.pwrdn_delay_min	= POWER_DOWN_DELAY_US_MIN,
@@ -1199,7 +1195,6 @@ static const struct qmp_phy_cfg qmp_v3_u
 
 	.start_ctrl		= SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN,
-	.mask_pcs_ready		= PHYSTATUS,
 
 	.has_pwrdn_delay	= true,
 	.pwrdn_delay_min	= POWER_DOWN_DELAY_US_MIN,
@@ -1226,7 +1221,6 @@ static const struct qmp_phy_cfg sdm845_u
 
 	.start_ctrl		= SERDES_START,
 	.pwrdn_ctrl		= SW_PWRDN,
-	.mask_pcs_ready		= PCS_READY,
 
 	.is_dual_lane_phy	= true,
 	.no_pcs_sw_reset	= true,
@@ -1254,7 +1248,6 @@ static const struct qmp_phy_cfg msm8998_
 
 	.start_ctrl             = SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
-	.mask_pcs_ready		= PHYSTATUS,
 };
 
 static const struct qmp_phy_cfg msm8998_usb3phy_cfg = {
@@ -1279,7 +1272,6 @@ static const struct qmp_phy_cfg msm8998_
 
 	.start_ctrl             = SERDES_START | PCS_START,
 	.pwrdn_ctrl             = SW_PWRDN,
-	.mask_pcs_ready         = PHYSTATUS,
 
 	.is_dual_lane_phy       = true,
 };
@@ -1457,7 +1449,7 @@ static int qcom_qmp_phy_enable(struct ph
 	void __iomem *pcs = qphy->pcs;
 	void __iomem *dp_com = qmp->dp_com;
 	void __iomem *status;
-	unsigned int mask, val;
+	unsigned int mask, val, ready;
 	int ret;
 
 	dev_vdbg(qmp->dev, "Initializing QMP phy\n");
@@ -1545,10 +1537,17 @@ static int qcom_qmp_phy_enable(struct ph
 	/* start SerDes and Phy-Coding-Sublayer */
 	qphy_setbits(pcs, cfg->regs[QPHY_START_CTRL], cfg->start_ctrl);
 
-	status = pcs + cfg->regs[QPHY_PCS_READY_STATUS];
-	mask = cfg->mask_pcs_ready;
+	if (cfg->type == PHY_TYPE_UFS) {
+		status = pcs + cfg->regs[QPHY_PCS_READY_STATUS];
+		mask = PCS_READY;
+		ready = PCS_READY;
+	} else {
+		status = pcs + cfg->regs[QPHY_PCS_STATUS];
+		mask = PHYSTATUS;
+		ready = 0;
+	}
 
-	ret = readl_poll_timeout(status, val, val & mask, 10,
+	ret = readl_poll_timeout(status, val, (val & mask) == ready, 10,
 				 PHY_INIT_COMPLETE_TIMEOUT);
 	if (ret) {
 		dev_err(qmp->dev, "phy initialization timed-out\n");


