Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8B5828CB
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 02:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731099AbfHFAnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 20:43:01 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46273 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730875AbfHFAnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 20:43:01 -0400
Received: by mail-pf1-f193.google.com with SMTP id c3so17358643pfa.13
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 17:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ueOERlEtYBgX0GLBCId/GHdBVP4Bxw4qttSqTD9yYIo=;
        b=J6ADLRqwbznZafl9dA+zR/2eExHzMsBD6jFL0wDfzPnnQ9Kn9zyIvETW9D6pmsJk5O
         eDfBAcq6htpwC1PVmviIBQLnqxBP+Xm7Ve6RCCtmmkAKAx6V4uqJ7aJTxgW2p8mefxsz
         uJ2iB5ztDWE8rG4N8DXEkckrOwR5YeZiDbtOFPTBKJ/GYIewMyaeV0cgr0c6DQJBc11H
         YPpirIiPuYTyJmW0GIZQERcg9NrnGIPcv32fuYfVXCJnkOaOO40Hq0IPjb4KJYZadKo2
         4QPPvB2bv1r6bJGtbVpquIrYJHgTTwAUkso9Fj8W94yN3IM3LbOPhy5CPdH3KLTef74J
         R1Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ueOERlEtYBgX0GLBCId/GHdBVP4Bxw4qttSqTD9yYIo=;
        b=uB9XSFKdGWsxi2BBPNDFeIdWqoSIS52VWIwWxXIb12bNjJrP4ElMZI6jdKcGnlEqfm
         CDHDJp+5qFz/1EkePU3aS/lxrJ0zEYtEeZDc2oJSgtOGQEvekzk9d63KXxfX4xP1H3Ew
         +Wl2pwJEd4IQGeY6eVtkzq4DqWc6dn//duvwQlTWbO25g5ZctX6aGiil3la8vFUAEnQK
         Rsz6AsWwoGMNsQ10t2csFQF9C43kubS9GmAra53yKJC4+w18SLibT/ChyrFjSxu9/k+9
         0GBi28JXaVdpOQMjW6RQuox+MRCCxVED9Lnt5cAvuj5Lnm+fUBbcAwiyXucgNbzBWPap
         zF+g==
X-Gm-Message-State: APjAAAUELemh8mqEO6VUoQHyPuLkRnb5jKBxFdbngsK11gN6aXe0/J4H
        Eo10rPbVMOZiD1iiJv9zJEnNrg==
X-Google-Smtp-Source: APXvYqxal+OsTtvFj4HRmsoSYr/SwRw4CC3u6NOxtF7px8Njr/YvDoTKVjcN7oYFWsNucTfvjhg02Q==
X-Received: by 2002:a65:5202:: with SMTP id o2mr497163pgp.29.1565052180144;
        Mon, 05 Aug 2019 17:43:00 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id h6sm81898821pfb.20.2019.08.05.17.42.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 17:42:59 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>,
        Evan Green <evgreen@chromium.org>,
        Niklas Cassel <niklas.cassel@linaro.org>
Subject: [PATCH] phy: qcom-qmp: Correct ready status, again
Date:   Mon,  5 Aug 2019 17:42:56 -0700
Message-Id: <20190806004256.20152-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Despite extensive testing of 885bd765963b ("phy: qcom-qmp: Correct
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
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 33 ++++++++++++++---------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index 34ff6434da8f..6bb49cc25c63 100644
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
@@ -133,7 +134,7 @@ static const unsigned int pciephy_regs_layout[] = {
 	[QPHY_FLL_MAN_CODE]		= 0xd4,
 	[QPHY_SW_RESET]			= 0x00,
 	[QPHY_START_CTRL]		= 0x08,
-	[QPHY_PCS_READY_STATUS]		= 0x174,
+	[QPHY_PCS_STATUS]		= 0x174,
 };
 
 static const unsigned int usb3phy_regs_layout[] = {
@@ -144,7 +145,7 @@ static const unsigned int usb3phy_regs_layout[] = {
 	[QPHY_FLL_MAN_CODE]		= 0xd0,
 	[QPHY_SW_RESET]			= 0x00,
 	[QPHY_START_CTRL]		= 0x08,
-	[QPHY_PCS_READY_STATUS]		= 0x17c,
+	[QPHY_PCS_STATUS]		= 0x17c,
 	[QPHY_PCS_AUTONOMOUS_MODE_CTRL]	= 0x0d4,
 	[QPHY_PCS_LFPS_RXTERM_IRQ_CLEAR]  = 0x0d8,
 	[QPHY_PCS_LFPS_RXTERM_IRQ_STATUS] = 0x178,
@@ -153,7 +154,7 @@ static const unsigned int usb3phy_regs_layout[] = {
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
@@ -1074,7 +1074,6 @@ static const struct qmp_phy_cfg msm8996_pciephy_cfg = {
 
 	.start_ctrl		= PCS_START | PLL_READY_GATE_EN,
 	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
-	.mask_pcs_ready		= PHYSTATUS,
 	.mask_com_pcs_ready	= PCS_READY,
 
 	.has_phy_com_ctrl	= true,
@@ -1106,7 +1105,6 @@ static const struct qmp_phy_cfg msm8996_usb3phy_cfg = {
 
 	.start_ctrl		= SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN,
-	.mask_pcs_ready		= PHYSTATUS,
 };
 
 /* list of resets */
@@ -1136,7 +1134,6 @@ static const struct qmp_phy_cfg ipq8074_pciephy_cfg = {
 
 	.start_ctrl		= SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
-	.mask_pcs_ready		= PHYSTATUS,
 
 	.has_phy_com_ctrl	= false,
 	.has_lane_rst		= false,
@@ -1167,7 +1164,6 @@ static const struct qmp_phy_cfg qmp_v3_usb3phy_cfg = {
 
 	.start_ctrl		= SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN,
-	.mask_pcs_ready		= PHYSTATUS,
 
 	.has_pwrdn_delay	= true,
 	.pwrdn_delay_min	= POWER_DOWN_DELAY_US_MIN,
@@ -1199,7 +1195,6 @@ static const struct qmp_phy_cfg qmp_v3_usb3_uniphy_cfg = {
 
 	.start_ctrl		= SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN,
-	.mask_pcs_ready		= PHYSTATUS,
 
 	.has_pwrdn_delay	= true,
 	.pwrdn_delay_min	= POWER_DOWN_DELAY_US_MIN,
@@ -1226,7 +1221,6 @@ static const struct qmp_phy_cfg sdm845_ufsphy_cfg = {
 
 	.start_ctrl		= SERDES_START,
 	.pwrdn_ctrl		= SW_PWRDN,
-	.mask_pcs_ready		= PCS_READY,
 
 	.is_dual_lane_phy	= true,
 	.no_pcs_sw_reset	= true,
@@ -1254,7 +1248,6 @@ static const struct qmp_phy_cfg msm8998_pciephy_cfg = {
 
 	.start_ctrl             = SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
-	.mask_pcs_ready		= PHYSTATUS,
 };
 
 static const struct qmp_phy_cfg msm8998_usb3phy_cfg = {
@@ -1279,7 +1272,6 @@ static const struct qmp_phy_cfg msm8998_usb3phy_cfg = {
 
 	.start_ctrl             = SERDES_START | PCS_START,
 	.pwrdn_ctrl             = SW_PWRDN,
-	.mask_pcs_ready         = PHYSTATUS,
 
 	.is_dual_lane_phy       = true,
 };
@@ -1457,7 +1449,7 @@ static int qcom_qmp_phy_enable(struct phy *phy)
 	void __iomem *pcs = qphy->pcs;
 	void __iomem *dp_com = qmp->dp_com;
 	void __iomem *status;
-	unsigned int mask, val;
+	unsigned int mask, val, ready;
 	int ret;
 
 	dev_vdbg(qmp->dev, "Initializing QMP phy\n");
@@ -1545,10 +1537,17 @@ static int qcom_qmp_phy_enable(struct phy *phy)
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
-- 
2.18.0

