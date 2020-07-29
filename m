Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BD9232198
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 17:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgG2PbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 11:31:08 -0400
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:10011 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726709AbgG2PbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jul 2020 11:31:07 -0400
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 29 Jul 2020 08:31:04 -0700
Received: from sivaprak-linux.qualcomm.com ([10.201.3.202])
  by ironmsg01-sd.qualcomm.com with ESMTP; 29 Jul 2020 08:30:56 -0700
Received: by sivaprak-linux.qualcomm.com (Postfix, from userid 459349)
        id 005A9219A9; Wed, 29 Jul 2020 21:00:54 +0530 (IST)
From:   Sivaprakash Murugesan <sivaprak@codeaurora.org>
To:     agross@kernel.org, bjorn.andersson@linaro.org, bhelgaas@google.com,
        robh+dt@kernel.org, kishon@ti.com, vkoul@kernel.org,
        svarbanov@mm-sol.com, lorenzo.pieralisi@arm.com,
        p.zabel@pengutronix.de, sivaprak@codeaurora.org,
        mgautam@codeaurora.org, smuthayy@codeaurora.org,
        varada@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-pci@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Selvam Sathappan Periakaruppan <speriaka@codeaurora.org>
Subject: [PATCH V2 3/7] phy: qcom-qmp: Use correct values for ipq8074 PCIe Gen2 PHY init
Date:   Wed, 29 Jul 2020 21:00:03 +0530
Message-Id: <1596036607-11877-4-git-send-email-sivaprak@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596036607-11877-1-git-send-email-sivaprak@codeaurora.org>
References: <1596036607-11877-1-git-send-email-sivaprak@codeaurora.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There were some problem in ipq8074 Gen2 PCIe phy init sequence.

1. Few register values were wrongly updated in the phy init sequence.
2. The register QSERDES_RX_SIGDET_CNTRL is a RX tuning parameter
   register which is added in serdes table causing the wrong register
   was getting updated.
3. Clocks and resets were not added in the phy init.

Fix these to make Gen2 PCIe port on ipq8074 devices to work.

Fixes: eef243d04b2b6 ("phy: qcom-qmp: Add support for IPQ8074")

Cc: stable@vger.kernel.org
Co-developed-by: Selvam Sathappan Periakaruppan <speriaka@codeaurora.org>
Signed-off-by: Selvam Sathappan Periakaruppan <speriaka@codeaurora.org>
Signed-off-by: Sivaprakash Murugesan <sivaprak@codeaurora.org>
---
[V2]
 * Fixed commit message as commented by Vinod
 drivers/phy/qualcomm/phy-qcom-qmp.c | 16 +++++++++-------
 drivers/phy/qualcomm/phy-qcom-qmp.h |  2 ++
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index 562053c..6e6f992 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -604,8 +604,8 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_serdes_tbl[] = {
 	QMP_PHY_INIT_CFG(QSERDES_COM_BG_TRIM, 0xf),
 	QMP_PHY_INIT_CFG(QSERDES_COM_LOCK_CMP_EN, 0x1),
 	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_MAP, 0x0),
-	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_TIMER1, 0x1f),
-	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_TIMER2, 0x3f),
+	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_TIMER1, 0xff),
+	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_TIMER2, 0x1f),
 	QMP_PHY_INIT_CFG(QSERDES_COM_CMN_CONFIG, 0x6),
 	QMP_PHY_INIT_CFG(QSERDES_COM_PLL_IVCO, 0xf),
 	QMP_PHY_INIT_CFG(QSERDES_COM_HSCLK_SEL, 0x0),
@@ -631,7 +631,6 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_serdes_tbl[] = {
 	QMP_PHY_INIT_CFG(QSERDES_COM_INTEGLOOP_GAIN1_MODE0, 0x0),
 	QMP_PHY_INIT_CFG(QSERDES_COM_INTEGLOOP_GAIN0_MODE0, 0x80),
 	QMP_PHY_INIT_CFG(QSERDES_COM_BIAS_EN_CTRL_BY_PSM, 0x1),
-	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_CTRL, 0xa),
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_EN_CENTER, 0x1),
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_PER1, 0x31),
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_PER2, 0x1),
@@ -640,7 +639,6 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_serdes_tbl[] = {
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_STEP_SIZE1, 0x2f),
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_STEP_SIZE2, 0x19),
 	QMP_PHY_INIT_CFG(QSERDES_COM_CLK_EP_DIV, 0x19),
-	QMP_PHY_INIT_CFG(QSERDES_RX_SIGDET_CNTRL, 0x7),
 };
 
 static const struct qmp_phy_init_tbl ipq8074_pcie_tx_tbl[] = {
@@ -648,6 +646,8 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_tx_tbl[] = {
 	QMP_PHY_INIT_CFG(QSERDES_TX_LANE_MODE, 0x6),
 	QMP_PHY_INIT_CFG(QSERDES_TX_RES_CODE_LANE_OFFSET, 0x2),
 	QMP_PHY_INIT_CFG(QSERDES_TX_RCV_DETECT_LVL_2, 0x12),
+	QMP_PHY_INIT_CFG(QSERDES_TX_EMP_POST1_LVL, 0x36),
+	QMP_PHY_INIT_CFG(QSERDES_TX_SLEW_CNTL, 0x0a),
 };
 
 static const struct qmp_phy_init_tbl ipq8074_pcie_rx_tbl[] = {
@@ -658,7 +658,6 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_rx_tbl[] = {
 	QMP_PHY_INIT_CFG(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL4, 0xdb),
 	QMP_PHY_INIT_CFG(QSERDES_RX_UCDR_SO_SATURATION_AND_ENABLE, 0x4b),
 	QMP_PHY_INIT_CFG(QSERDES_RX_UCDR_SO_GAIN, 0x4),
-	QMP_PHY_INIT_CFG(QSERDES_RX_UCDR_SO_GAIN_HALF, 0x4),
 };
 
 static const struct qmp_phy_init_tbl ipq8074_pcie_pcs_tbl[] = {
@@ -2046,6 +2045,9 @@ static const struct qmp_phy_cfg msm8996_usb3phy_cfg = {
 	.pwrdn_ctrl		= SW_PWRDN,
 };
 
+static const char * const ipq8074_pciephy_clk_l[] = {
+	"aux", "cfg_ahb",
+};
 /* list of resets */
 static const char * const ipq8074_pciephy_reset_l[] = {
 	"phy", "common",
@@ -2063,8 +2065,8 @@ static const struct qmp_phy_cfg ipq8074_pciephy_cfg = {
 	.rx_tbl_num		= ARRAY_SIZE(ipq8074_pcie_rx_tbl),
 	.pcs_tbl		= ipq8074_pcie_pcs_tbl,
 	.pcs_tbl_num		= ARRAY_SIZE(ipq8074_pcie_pcs_tbl),
-	.clk_list		= NULL,
-	.num_clks		= 0,
+	.clk_list		= ipq8074_pciephy_clk_l,
+	.num_clks		= ARRAY_SIZE(ipq8074_pciephy_clk_l),
 	.reset_list		= ipq8074_pciephy_reset_l,
 	.num_resets		= ARRAY_SIZE(ipq8074_pciephy_reset_l),
 	.vreg_list		= NULL,
diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.h b/drivers/phy/qualcomm/phy-qcom-qmp.h
index 4277f59..904b80a 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.h
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.h
@@ -77,6 +77,8 @@
 #define QSERDES_COM_CORECLK_DIV_MODE1			0x1bc
 
 /* Only for QMP V2 PHY - TX registers */
+#define QSERDES_TX_EMP_POST1_LVL			0x018
+#define QSERDES_TX_SLEW_CNTL				0x040
 #define QSERDES_TX_RES_CODE_LANE_OFFSET			0x054
 #define QSERDES_TX_DEBUG_BUS_SEL			0x064
 #define QSERDES_TX_HIGHZ_TRANSCEIVEREN_BIAS_DRVR_EN	0x068
-- 
2.7.4

