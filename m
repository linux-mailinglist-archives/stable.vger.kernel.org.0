Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFF66581B8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234766AbiL1QbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234805AbiL1QbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:31:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E851D0FD
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:27:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99A8F6157A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2D2C433D2;
        Wed, 28 Dec 2022 16:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244825;
        bh=mGHi25JdCjCf1Lb6KEr7Vxw28JvRAQS6ch20phV1Ycc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWEbI2UGNFX3/VLd8o5RV46lxnap+3ZDMWjam2GnEhccFIfPLUjuWAobNnD9v5Kmb
         9oYnlxs8RCYzwo2PSiCCkAYVCyifT+oJN78V1IVOM2HNe0VQzQQhIDMtwOduTo8za8
         OmlwatQdUwhOf9TRgLjtCvSf9UMuQvZ3AxUWFvuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0780/1073] phy: qcom-qmp-pcie: Fix sm8450_qmp_gen4x2_pcie_pcs_tbl[] register names
Date:   Wed, 28 Dec 2022 15:39:28 +0100
Message-Id: <20221228144349.196645292@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 883aebf6e1ea88145d64dcf940dbcb5181313338 ]

sm8450_qmp_gen4x2_pcie_pcs_tbl[] contains the init sequence for PCS
registers of QMP PHY v5.20. So use the v5.20 specific register names.
Only major change is the rename of PCS_EQ_CONFIG{2/3} registers to
PCS_EQ_CONFIG{4/5}.

Fixes: 2c91bf6bf290 ("phy: qcom-qmp: Add SM8450 PCIe1 PHY support")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20221102081835.41892-2-manivannan.sadhasivam@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c      |  8 ++++----
 drivers/phy/qualcomm/phy-qcom-qmp-pcs-v5_20.h | 14 ++++++++++++++
 drivers/phy/qualcomm/phy-qcom-qmp.h           |  1 +
 3 files changed, 19 insertions(+), 4 deletions(-)
 create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-pcs-v5_20.h

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
index b17248506fe8..51dc4f2de106 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -1329,10 +1329,10 @@ static const struct qmp_phy_init_tbl sm8450_qmp_gen4x2_pcie_rx_tbl[] = {
 };
 
 static const struct qmp_phy_init_tbl sm8450_qmp_gen4x2_pcie_pcs_tbl[] = {
-	QMP_PHY_INIT_CFG(QPHY_V5_PCS_EQ_CONFIG2, 0x16),
-	QMP_PHY_INIT_CFG(QPHY_V5_PCS_EQ_CONFIG3, 0x22),
-	QMP_PHY_INIT_CFG(QPHY_V5_PCS_G3S2_PRE_GAIN, 0x2e),
-	QMP_PHY_INIT_CFG(QPHY_V5_PCS_RX_SIGDET_LVL, 0x99),
+	QMP_PHY_INIT_CFG(QPHY_V5_20_PCS_EQ_CONFIG4, 0x16),
+	QMP_PHY_INIT_CFG(QPHY_V5_20_PCS_EQ_CONFIG5, 0x22),
+	QMP_PHY_INIT_CFG(QPHY_V5_20_PCS_G3S2_PRE_GAIN, 0x2e),
+	QMP_PHY_INIT_CFG(QPHY_V5_20_PCS_RX_SIGDET_LVL, 0x99),
 };
 
 static const struct qmp_phy_init_tbl sm8450_qmp_gen4x2_pcie_pcs_misc_tbl[] = {
diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcs-v5_20.h b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-v5_20.h
new file mode 100644
index 000000000000..9a5a20daf62c
--- /dev/null
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-v5_20.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2022, Linaro Ltd.
+ */
+
+#ifndef QCOM_PHY_QMP_PCS_V5_20_H_
+#define QCOM_PHY_QMP_PCS_V5_20_H_
+
+#define QPHY_V5_20_PCS_G3S2_PRE_GAIN			0x170
+#define QPHY_V5_20_PCS_RX_SIGDET_LVL			0x188
+#define QPHY_V5_20_PCS_EQ_CONFIG4			0x1e0
+#define QPHY_V5_20_PCS_EQ_CONFIG5			0x1e4
+
+#endif
diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.h b/drivers/phy/qualcomm/phy-qcom-qmp.h
index b139c8af5e8b..1a0c6c3026e3 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.h
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.h
@@ -37,6 +37,7 @@
 #include "phy-qcom-qmp-pcs-pcie-v4_20.h"
 
 #include "phy-qcom-qmp-pcs-v5.h"
+#include "phy-qcom-qmp-pcs-v5_20.h"
 #include "phy-qcom-qmp-pcs-pcie-v5.h"
 #include "phy-qcom-qmp-pcs-usb-v5.h"
 #include "phy-qcom-qmp-pcs-ufs-v5.h"
-- 
2.35.1



