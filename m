Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB05658329
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbiL1QjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbiL1Qil (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:38:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B141C42D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:34:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F51DB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF83C433D2;
        Wed, 28 Dec 2022 16:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245252;
        bh=W4IJTgpGPL7R83Cr9e/83msLC0nkUYBio7i30LOLwa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVJWLNsXcEYdu0cxJqvOYY9RSm6e+qCZgRVSYRP8kj4KMFS/nFqXrg5g1zpgaWOqo
         bXjNNqslmRw+tmUCWx+UYGOT5X+QVWvyVOoo0k8NL/OREdzTk9laSU6LMqYX3sDP1X
         EKC9tJprXOyTUoALQlprbDFqiM6jByz4BWHw4WHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0827/1146] phy: qcom-qmp-pcie: Fix high latency with 4x2 PHY when ASPM is enabled
Date:   Wed, 28 Dec 2022 15:39:26 +0100
Message-Id: <20221228144352.621082628@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 9ddcd920f8edfe65c3670fbd0b49db00e1e562fe ]

The PCIe QMP 4x2 RC PHY generates high latency when ASPM is enabled. This
seem to be fixed by clearing the QPHY_V5_20_PCS_PCIE_PRESET_P10_POST
register of the pcs_misc register space.

Fixes: 2c91bf6bf290 ("phy: qcom-qmp: Add SM8450 PCIe1 PHY support")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20221102081835.41892-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c           | 1 +
 drivers/phy/qualcomm/phy-qcom-qmp-pcs-pcie-v5_20.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
index 3c5c4a4412e0..5a17cda1a6b8 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -1308,6 +1308,7 @@ static const struct qmp_phy_init_tbl sm8450_qmp_gen4x2_pcie_pcs_misc_tbl[] = {
 static const struct qmp_phy_init_tbl sm8450_qmp_gen4x2_pcie_rc_pcs_misc_tbl[] = {
 	QMP_PHY_INIT_CFG(QPHY_V5_20_PCS_PCIE_ENDPOINT_REFCLK_DRIVE, 0xc1),
 	QMP_PHY_INIT_CFG(QPHY_V5_20_PCS_PCIE_OSC_DTCT_ACTIONS, 0x00),
+	QMP_PHY_INIT_CFG(QPHY_V5_20_PCS_PCIE_PRESET_P10_POST, 0x00),
 };
 
 static const struct qmp_phy_init_tbl sm8450_qmp_gen4x2_pcie_ep_serdes_tbl[] = {
diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcs-pcie-v5_20.h b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-pcie-v5_20.h
index c9fa90b45475..3d9713d348fe 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcs-pcie-v5_20.h
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-pcie-v5_20.h
@@ -11,6 +11,7 @@
 #define QPHY_V5_20_PCS_PCIE_OSC_DTCT_MODE2_CONFIG5	0x084
 #define QPHY_V5_20_PCS_PCIE_OSC_DTCT_ACTIONS		0x090
 #define QPHY_V5_20_PCS_PCIE_EQ_CONFIG1			0x0a0
+#define QPHY_V5_20_PCS_PCIE_PRESET_P10_POST		0x0e0
 #define QPHY_V5_20_PCS_PCIE_G4_EQ_CONFIG5		0x108
 #define QPHY_V5_20_PCS_PCIE_G4_PRE_GAIN			0x15c
 #define QPHY_V5_20_PCS_PCIE_RX_MARGINING_CONFIG3	0x184
-- 
2.35.1



