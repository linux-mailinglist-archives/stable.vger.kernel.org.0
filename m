Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8194162559A
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 09:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbiKKIo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 03:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbiKKIo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 03:44:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933D17C8E7;
        Fri, 11 Nov 2022 00:44:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4ED05B8245A;
        Fri, 11 Nov 2022 08:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7ACC43142;
        Fri, 11 Nov 2022 08:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668156293;
        bh=lNIoKDoFO4aYN+HOb6Or1Q9qGXfioSo1MkkvV/9tMeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTz2aeWwlbSVEsHLWLBdKOrgty07atSygAyISrUHTGrZg9E22blnBH86WfMYkQEtC
         a5VVc6NWCMDkRV/xTlojDysgXgD/Gi2nt6hK+rFtCDrAYBdE2I8oT7sAmuJhZi1i45
         OZZnhM+3zHUxDGoUNdHbqAkyWBf9Jhmb4p6GEe7tHSr+2VNeTQs7L7vxxfIOArcgzS
         Stxyi/SYnTCmD0ogaHu7YTp0pW4xVI3X66TQGgILlYO2Y5weCaLztLVZwMSxntATtu
         u4jb/3YJsKl6DJgzleaCsZm3sbvprMHDuHR4Tj/7fge1tzAL5CTnxDDadivQzpArIV
         Cc9FoZxw4XGGA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1otPeD-0002Mm-Rp; Fri, 11 Nov 2022 09:44:25 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Vinod Koul <vkoul@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 4/6] phy: qcom-qmp-combo: fix broken power on
Date:   Fri, 11 Nov 2022 09:42:53 +0100
Message-Id: <20221111084255.8963-5-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221111084255.8963-1-johan+linaro@kernel.org>
References: <20221111084255.8963-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The PHY is powered on during phy-init by setting the SW_PRWDN bit in the
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
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

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
-- 
2.37.4

