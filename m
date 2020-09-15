Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05EA026B5F4
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgIOXzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:55:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727052AbgIOObb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:31:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A866122274;
        Tue, 15 Sep 2020 14:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179801;
        bh=YRUkE2pQjH65cs2kBN5O6TM5lKeb36fw4rbU70ef/K8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLkpk+PDb2YlE/iufRukOj3w+X5ylkGG/4iTidNsPl12rl8AcnYu5V46nf49XZR5t
         lrjzD0fvu8NayyaiB5WHj1nIXvN27HqD5KhXrJk+yvtD4zMpltzC9m9sSD6JSuXgcZ
         Q6XF8QkYEj4jeA0OyL2RCPxDkhfWcIwslAnaVOl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Selvam Sathappan Periakaruppan <speriaka@codeaurora.org>,
        Sivaprakash Murugesan <sivaprak@codeaurora.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 122/132] phy: qcom-qmp: Use correct values for ipq8074 PCIe Gen2 PHY init
Date:   Tue, 15 Sep 2020 16:13:44 +0200
Message-Id: <20200915140650.225125999@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sivaprakash Murugesan <sivaprak@codeaurora.org>

commit afd55e6d1bd35b4b36847869011447a83a81c8e0 upstream.

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
Link: https://lore.kernel.org/r/1596036607-11877-4-git-send-email-sivaprak@codeaurora.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/phy/qualcomm/phy-qcom-qmp.c |   16 +++++++++-------
 drivers/phy/qualcomm/phy-qcom-qmp.h |    2 ++
 2 files changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -402,8 +402,8 @@ static const struct qmp_phy_init_tbl ipq
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
@@ -429,7 +429,6 @@ static const struct qmp_phy_init_tbl ipq
 	QMP_PHY_INIT_CFG(QSERDES_COM_INTEGLOOP_GAIN1_MODE0, 0x0),
 	QMP_PHY_INIT_CFG(QSERDES_COM_INTEGLOOP_GAIN0_MODE0, 0x80),
 	QMP_PHY_INIT_CFG(QSERDES_COM_BIAS_EN_CTRL_BY_PSM, 0x1),
-	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_CTRL, 0xa),
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_EN_CENTER, 0x1),
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_PER1, 0x31),
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_PER2, 0x1),
@@ -438,7 +437,6 @@ static const struct qmp_phy_init_tbl ipq
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_STEP_SIZE1, 0x2f),
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_STEP_SIZE2, 0x19),
 	QMP_PHY_INIT_CFG(QSERDES_COM_CLK_EP_DIV, 0x19),
-	QMP_PHY_INIT_CFG(QSERDES_RX_SIGDET_CNTRL, 0x7),
 };
 
 static const struct qmp_phy_init_tbl ipq8074_pcie_tx_tbl[] = {
@@ -446,6 +444,8 @@ static const struct qmp_phy_init_tbl ipq
 	QMP_PHY_INIT_CFG(QSERDES_TX_LANE_MODE, 0x6),
 	QMP_PHY_INIT_CFG(QSERDES_TX_RES_CODE_LANE_OFFSET, 0x2),
 	QMP_PHY_INIT_CFG(QSERDES_TX_RCV_DETECT_LVL_2, 0x12),
+	QMP_PHY_INIT_CFG(QSERDES_TX_EMP_POST1_LVL, 0x36),
+	QMP_PHY_INIT_CFG(QSERDES_TX_SLEW_CNTL, 0x0a),
 };
 
 static const struct qmp_phy_init_tbl ipq8074_pcie_rx_tbl[] = {
@@ -456,7 +456,6 @@ static const struct qmp_phy_init_tbl ipq
 	QMP_PHY_INIT_CFG(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL4, 0xdb),
 	QMP_PHY_INIT_CFG(QSERDES_RX_UCDR_SO_SATURATION_AND_ENABLE, 0x4b),
 	QMP_PHY_INIT_CFG(QSERDES_RX_UCDR_SO_GAIN, 0x4),
-	QMP_PHY_INIT_CFG(QSERDES_RX_UCDR_SO_GAIN_HALF, 0x4),
 };
 
 static const struct qmp_phy_init_tbl ipq8074_pcie_pcs_tbl[] = {
@@ -1107,6 +1106,9 @@ static const struct qmp_phy_cfg msm8996_
 	.pwrdn_ctrl		= SW_PWRDN,
 };
 
+static const char * const ipq8074_pciephy_clk_l[] = {
+	"aux", "cfg_ahb",
+};
 /* list of resets */
 static const char * const ipq8074_pciephy_reset_l[] = {
 	"phy", "common",
@@ -1124,8 +1126,8 @@ static const struct qmp_phy_cfg ipq8074_
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


