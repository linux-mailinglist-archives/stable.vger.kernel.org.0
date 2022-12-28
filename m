Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEFD65829E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbiL1Qiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235058AbiL1Qi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:38:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F48E1DDC1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:34:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00E55B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180FFC433D2;
        Wed, 28 Dec 2022 16:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245241;
        bh=O/c2K+3SVHHDfHCUQlx+c2lVWGvQVGauO2ixrrjWCZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAfahziv87XdTo9YAfMlsxFPDCc+j5bWykmik6D/Ak8f7d2HX57m+v3KlIpP72rAf
         10kIAkisoEPpPyaQsJVCJHd7af7ujdZHjJVQvgIHU/Nf/Ahrb07KMOr9ZMHu0/ftd+
         gwcSbcqkrfTJv5Geb4LYx1KjILpgzfe5xUNyPQ/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0825/1146] phy: qcom-qmp-pcie: support separate tables for EP mode
Date:   Wed, 28 Dec 2022 15:39:24 +0100
Message-Id: <20221228144352.565630944@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 11bf53a38c82baef349b4efc6a84f069dab7085a ]

The PCIe QMP PHY requires different programming sequences when being
used for the RC (Root Complex) or for the EP (End Point) modes. Allow
selecting the submode and thus selecting a set of PHY programming
tables.

Since the RC and EP modes share common some common init sequence, the
common sequence is kept in the main table and the sequence differences
are pushed to the extra tables.

Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220927092207.161501-3-dmitry.baryshkov@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 9ddcd920f8ed ("phy: qcom-qmp-pcie: Fix high latency with 4x2 PHY when ASPM is enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c | 46 ++++++++++++++++++++----
 1 file changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
index 9ccc6e27fc1f..0a5493940b99 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_address.h>
+#include <linux/phy/pcie.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
@@ -1323,10 +1324,14 @@ struct qmp_phy_cfg {
 	/* Main init sequence for PHY blocks - serdes, tx, rx, pcs */
 	const struct qmp_phy_cfg_tables tables;
 	/*
-	 * Additional init sequence for PHY blocks, providing additional
-	 * register programming. Unless required it can be left omitted.
+	 * Additional init sequences for PHY blocks, providing additional
+	 * register programming. They are used for providing separate sequences
+	 * for the Root Complex and End Point use cases.
+	 *
+	 * If EP mode is not supported, both tables can be left unset.
 	 */
 	const struct qmp_phy_cfg_tables *tables_rc;
+	const struct qmp_phy_cfg_tables *tables_ep;
 
 	/* clock ids to be requested */
 	const char * const *clk_list;
@@ -1366,6 +1371,7 @@ struct qmp_phy_cfg {
  * @pcs_misc: iomapped memory space for lane's pcs_misc
  * @pipe_clk: pipe clock
  * @qmp: QMP phy to which this lane belongs
+ * @mode: currently selected PHY mode
  */
 struct qmp_phy {
 	struct phy *phy;
@@ -1379,6 +1385,7 @@ struct qmp_phy {
 	void __iomem *pcs_misc;
 	struct clk *pipe_clk;
 	struct qcom_qmp *qmp;
+	int mode;
 };
 
 /**
@@ -1953,13 +1960,19 @@ static int qmp_pcie_power_on(struct phy *phy)
 	struct qmp_phy *qphy = phy_get_drvdata(phy);
 	struct qcom_qmp *qmp = qphy->qmp;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
+	const struct qmp_phy_cfg_tables *mode_tables;
 	void __iomem *pcs = qphy->pcs;
 	void __iomem *status;
 	unsigned int mask, val, ready;
 	int ret;
 
+	if (qphy->mode == PHY_MODE_PCIE_RC)
+		mode_tables = cfg->tables_rc;
+	else
+		mode_tables = cfg->tables_ep;
+
 	qmp_pcie_serdes_init(qphy, &cfg->tables);
-	qmp_pcie_serdes_init(qphy, cfg->tables_rc);
+	qmp_pcie_serdes_init(qphy, mode_tables);
 
 	ret = clk_prepare_enable(qphy->pipe_clk);
 	if (ret) {
@@ -1969,10 +1982,10 @@ static int qmp_pcie_power_on(struct phy *phy)
 
 	/* Tx, Rx, and PCS configurations */
 	qmp_pcie_lanes_init(qphy, &cfg->tables);
-	qmp_pcie_lanes_init(qphy, cfg->tables_rc);
+	qmp_pcie_lanes_init(qphy, mode_tables);
 
 	qmp_pcie_pcs_init(qphy, &cfg->tables);
-	qmp_pcie_pcs_init(qphy, cfg->tables_rc);
+	qmp_pcie_pcs_init(qphy, mode_tables);
 
 	/* Pull PHY out of reset state */
 	qphy_clrbits(pcs, cfg->regs[QPHY_SW_RESET], SW_RESET);
@@ -2053,6 +2066,23 @@ static int qmp_pcie_disable(struct phy *phy)
 	return qmp_pcie_exit(phy);
 }
 
+static int qmp_pcie_set_mode(struct phy *phy, enum phy_mode mode, int submode)
+{
+	struct qmp_phy *qphy = phy_get_drvdata(phy);
+
+	switch (submode) {
+	case PHY_MODE_PCIE_RC:
+	case PHY_MODE_PCIE_EP:
+		qphy->mode = submode;
+		break;
+	default:
+		dev_err(&phy->dev, "Unsupported submode %d\n", submode);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int qmp_pcie_vreg_init(struct device *dev, const struct qmp_phy_cfg *cfg)
 {
 	struct qcom_qmp *qmp = dev_get_drvdata(dev);
@@ -2176,6 +2206,7 @@ static int phy_pipe_clk_register(struct qcom_qmp *qmp, struct device_node *np)
 static const struct phy_ops qmp_pcie_ops = {
 	.power_on	= qmp_pcie_enable,
 	.power_off	= qmp_pcie_disable,
+	.set_mode	= qmp_pcie_set_mode,
 	.owner		= THIS_MODULE,
 };
 
@@ -2191,6 +2222,8 @@ static int qmp_pcie_create(struct device *dev, struct device_node *np, int id,
 	if (!qphy)
 		return -ENOMEM;
 
+	qphy->mode = PHY_MODE_PCIE_RC;
+
 	qphy->cfg = cfg;
 	qphy->serdes = serdes;
 	/*
@@ -2234,7 +2267,8 @@ static int qmp_pcie_create(struct device *dev, struct device_node *np, int id,
 
 	if (IS_ERR(qphy->pcs_misc)) {
 		if (cfg->tables.pcs_misc ||
-		    (cfg->tables_rc && cfg->tables_rc->pcs_misc))
+		    (cfg->tables_rc && cfg->tables_rc->pcs_misc) ||
+		    (cfg->tables_ep && cfg->tables_ep->pcs_misc))
 			return PTR_ERR(qphy->pcs_misc);
 	}
 
-- 
2.35.1



