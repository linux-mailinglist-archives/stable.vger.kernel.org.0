Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58EDB65D5B6
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239401AbjADOc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239574AbjADOcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:32:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3911312F
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:32:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7260B81680
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5353BC433D2;
        Wed,  4 Jan 2023 14:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672842740;
        bh=3qc9R67u+9uJghClkxqOSiWmF69kTWhLYtfX/k1kZ7Y=;
        h=Subject:To:Cc:From:Date:From;
        b=Jou5ezy7qoUm+ZXv+MJ/wsmfGa1b1OCrwLs2oWCNT/eI02635eb0EnOW7MGtzuPCb
         fm/HbDLUSWIaFjWwjAZe/bShMPhsCgTZi2dJ1I4Sy6/xMhAIXmsi7/V9kMtfdTFwA6
         4m2scLRE5/tst/LMQ09HFAmV8YJuJQsbTiJinHlo=
Subject: FAILED: patch "[PATCH] phy: qcom-qmp-combo: fix broken power on" failed to apply to 6.1-stable tree
To:     johan+linaro@kernel.org, dmitry.baryshkov@linaro.org,
        vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:32:17 +0100
Message-ID: <167284273796174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

7a7d86d14d07 ("phy: qcom-qmp-combo: fix broken power on")
d4b81490fe44 ("phy: qcom-qmp-combo: drop start and pwrdn-ctrl abstraction")
f7075f4905e7 ("phy: qcom-qmp-combo: clean up status polling")
acfee73b635b ("phy: qcom-qmp-combo: drop power-down delay config")
d71eb7083e5e ("phy: qcom-qmp-combo: drop sc8280xp power-down delay")
2e52ddf045a0 ("phy: qcom-qmp-combo: clean up power-down handling")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7a7d86d14d073dfa3429c550667a8e78b99edbd4 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 14 Nov 2022 09:13:44 +0100
Subject: [PATCH] phy: qcom-qmp-combo: fix broken power on

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

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index 40c25a0ead23..17707f68d482 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -932,6 +932,7 @@ struct qcom_qmp {
 	struct regulator_bulk_data *vregs;
 
 	struct qmp_phy **phys;
+	struct qmp_phy *usb_phy;
 
 	struct mutex phy_mutex;
 	int init_count;
@@ -1911,7 +1912,7 @@ static int qmp_combo_com_init(struct qmp_phy *qphy)
 {
 	struct qcom_qmp *qmp = qphy->qmp;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
-	void __iomem *pcs = qphy->pcs;
+	struct qmp_phy *usb_phy = qmp->usb_phy;
 	void __iomem *dp_com = qmp->dp_com;
 	int ret;
 
@@ -1963,7 +1964,8 @@ static int qmp_combo_com_init(struct qmp_phy *qphy)
 	qphy_clrbits(dp_com, QPHY_V3_DP_COM_SWI_CTRL, 0x03);
 	qphy_clrbits(dp_com, QPHY_V3_DP_COM_SW_RESET, SW_RESET);
 
-	qphy_setbits(pcs, cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL], SW_PWRDN);
+	qphy_setbits(usb_phy->pcs, usb_phy->cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL],
+			SW_PWRDN);
 
 	mutex_unlock(&qmp->phy_mutex);
 
@@ -2831,6 +2833,8 @@ static int qmp_combo_probe(struct platform_device *pdev)
 				goto err_node_put;
 			}
 
+			qmp->usb_phy = qmp->phys[id];
+
 			/*
 			 * Register the pipe clock provided by phy.
 			 * See function description to see details of this pipe clock.
@@ -2846,6 +2850,9 @@ static int qmp_combo_probe(struct platform_device *pdev)
 		id++;
 	}
 
+	if (!qmp->usb_phy)
+		return -EINVAL;
+
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
 
 	return PTR_ERR_OR_ZERO(phy_provider);

