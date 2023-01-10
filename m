Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A7D664844
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238672AbjAJSKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239014AbjAJSJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:09:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4788E9AE
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:07:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51E0FB81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE03CC433EF;
        Tue, 10 Jan 2023 18:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374039;
        bh=IVsJLTN9Ds8ZTDHFMg6LQCsP1w+6bSjoafRpXZWh/fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IeOqbKS+t2FWM3cdrC9YNdKMl5EhpnsFajVbjQbgjt+t5MFDd3fIfeOwxuZet6O+Q
         cCW/wn1WmqZwcMHFJAcT2US+wSgylhziN0+MWrcGZ2Rki3YRgVyQhc1JvPY1mNMmUq
         Y9U9mW8k7kQDuhxNYcMoUNzroNPoy/fMDWMq/AIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 008/148] phy: qcom-qmp-combo: fix broken power on
Date:   Tue, 10 Jan 2023 19:01:52 +0100
Message-Id: <20230110180017.436940087@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 7a7d86d14d073dfa3429c550667a8e78b99edbd4 ]

The PHY is powered on during phy-init by setting the SW_PWRDN bit in the
COM_POWER_DOWN_CTRL register and then setting the same bit in the in the
PCS_POWER_DOWN_CONTROL register that belongs to the USB part of the
PHY.

Currently, whether power on succeeds depends on probe order and having
the USB part of the PHY be initialised first. In case the DP part of the
PHY is instead initialised first, the intended power on of the USB block
results in a corrupted DP_PHY register (e.g. DP_PHY_AUX_CFG8).

Add a pointer to the USB part of the PHY to the driver data and use that
to power on the PHY also if the DP part of the PHY is initialised first.

Fixes: 52e013d0bffa ("phy: qcom-qmp: Add support for DP in USB3+DP combo phy")
Cc: stable@vger.kernel.org	# 5.10
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20221114081346.5116-5-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index 0feda8eb93b5..5e011520650d 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -767,6 +767,7 @@ struct qcom_qmp {
 	struct regulator_bulk_data *vregs;
 
 	struct qmp_phy **phys;
+	struct qmp_phy *usb_phy;
 
 	struct mutex phy_mutex;
 	int init_count;
@@ -1607,7 +1608,7 @@ static int qcom_qmp_phy_combo_com_init(struct qmp_phy *qphy)
 {
 	struct qcom_qmp *qmp = qphy->qmp;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
-	void __iomem *pcs = qphy->pcs;
+	struct qmp_phy *usb_phy = qmp->usb_phy;
 	void __iomem *dp_com = qmp->dp_com;
 	int ret;
 
@@ -1663,13 +1664,13 @@ static int qcom_qmp_phy_combo_com_init(struct qmp_phy *qphy)
 		qphy_clrbits(dp_com, QPHY_V3_DP_COM_SW_RESET, SW_RESET);
 	}
 
-	if (cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL])
-		qphy_setbits(pcs,
-				cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL],
-				cfg->pwrdn_ctrl);
+	if (usb_phy->cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL])
+		qphy_setbits(usb_phy->pcs,
+				usb_phy->cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL],
+				usb_phy->cfg->pwrdn_ctrl);
 	else
-		qphy_setbits(pcs, QPHY_V2_PCS_POWER_DOWN_CONTROL,
-				cfg->pwrdn_ctrl);
+		qphy_setbits(usb_phy->pcs, QPHY_V2_PCS_POWER_DOWN_CONTROL,
+				usb_phy->cfg->pwrdn_ctrl);
 
 	mutex_unlock(&qmp->phy_mutex);
 
@@ -2576,6 +2577,8 @@ static int qcom_qmp_phy_combo_probe(struct platform_device *pdev)
 				goto err_node_put;
 			}
 
+			qmp->usb_phy = qmp->phys[id];
+
 			/*
 			 * Register the pipe clock provided by phy.
 			 * See function description to see details of this pipe clock.
@@ -2591,6 +2594,9 @@ static int qcom_qmp_phy_combo_probe(struct platform_device *pdev)
 		id++;
 	}
 
+	if (!qmp->usb_phy)
+		return -EINVAL;
+
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
 	if (!IS_ERR(phy_provider))
 		dev_info(dev, "Registered Qcom-QMP phy\n");
-- 
2.35.1



