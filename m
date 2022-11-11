Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003A1625593
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 09:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbiKKIo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 03:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233270AbiKKIoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 03:44:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DC17C8E9;
        Fri, 11 Nov 2022 00:44:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E37061ED4;
        Fri, 11 Nov 2022 08:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3430C433C1;
        Fri, 11 Nov 2022 08:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668156293;
        bh=BsM6e57E76PP1RYFVtT8hgjhqoIm78zr8LXoGcM453w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Arcu4vGl2iArUUjbEgyd0rM4627m/lwmFwbJYhsJVkhGMUgddru7vVbPFWdFc74tH
         0mXNwNeaRvtJV/0x33fgIJAliMlZIYdaG2Pv6Bp0eIshD23LRRz7ImHnNrU1b8cHFo
         csJNjHciLKkWbMATl+pwLOH8JwxQXC2GVeUtMgvhQ9IslLIGB+mR9qCChFJRfPXzR2
         xjw+YWnicinABDv6ET0G/9IwyR39k05OPgNRi5rX+YzTAz/63+aRpgV0r/gM8oI0m+
         riZUPdi/71Ee8AsPF7bNqs6m1yYpGLWGuhX1sIBFzsmwoeb4UVUvlf+0Wf2OX0A9t7
         F6iYC2dZMqGUg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1otPeD-0002Mi-M3; Fri, 11 Nov 2022 09:44:25 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Vinod Koul <vkoul@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/6] phy: qcom-qmp-combo: fix sdm845 reset
Date:   Fri, 11 Nov 2022 09:42:51 +0100
Message-Id: <20221111084255.8963-3-johan+linaro@kernel.org>
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

The SDM845 has two resets but the DP configuration erroneously described
only one.

In case the DP part of the PHY is initialised before the USB part (e.g.
depending on probe order), then only the first reset would be asserted.

Add a dedicated configuration for SDM845 rather than reuse the
incompatible SC7180 configuration.

Fixes: d88497fb6bbd ("phy: qualcomm: phy-qcom-qmp: add support for combo USB3+DP phy on SDM845")
Cc: stable@vger.kernel.org	# 6.1
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 39 ++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index bb38b18258ca..cc53e2f99121 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -1084,9 +1084,46 @@ static const struct qmp_phy_cfg sdm845_usb3phy_cfg = {
 	.has_pwrdn_delay	= true,
 };
 
+static const struct qmp_phy_cfg sdm845_dpphy_cfg = {
+	.type			= PHY_TYPE_DP,
+	.lanes			= 2,
+
+	.serdes_tbl		= qmp_v3_dp_serdes_tbl,
+	.serdes_tbl_num		= ARRAY_SIZE(qmp_v3_dp_serdes_tbl),
+	.tx_tbl			= qmp_v3_dp_tx_tbl,
+	.tx_tbl_num		= ARRAY_SIZE(qmp_v3_dp_tx_tbl),
+
+	.serdes_tbl_rbr		= qmp_v3_dp_serdes_tbl_rbr,
+	.serdes_tbl_rbr_num	= ARRAY_SIZE(qmp_v3_dp_serdes_tbl_rbr),
+	.serdes_tbl_hbr		= qmp_v3_dp_serdes_tbl_hbr,
+	.serdes_tbl_hbr_num	= ARRAY_SIZE(qmp_v3_dp_serdes_tbl_hbr),
+	.serdes_tbl_hbr2	= qmp_v3_dp_serdes_tbl_hbr2,
+	.serdes_tbl_hbr2_num	= ARRAY_SIZE(qmp_v3_dp_serdes_tbl_hbr2),
+	.serdes_tbl_hbr3	= qmp_v3_dp_serdes_tbl_hbr3,
+	.serdes_tbl_hbr3_num	= ARRAY_SIZE(qmp_v3_dp_serdes_tbl_hbr3),
+
+	.swing_hbr_rbr		= &qmp_dp_v3_voltage_swing_hbr_rbr,
+	.pre_emphasis_hbr_rbr	= &qmp_dp_v3_pre_emphasis_hbr_rbr,
+	.swing_hbr3_hbr2	= &qmp_dp_v3_voltage_swing_hbr3_hbr2,
+	.pre_emphasis_hbr3_hbr2 = &qmp_dp_v3_pre_emphasis_hbr3_hbr2,
+
+	.clk_list		= qmp_v3_phy_clk_l,
+	.num_clks		= ARRAY_SIZE(qmp_v3_phy_clk_l),
+	.reset_list		= msm8996_usb3phy_reset_l,
+	.num_resets		= ARRAY_SIZE(msm8996_usb3phy_reset_l),
+	.vreg_list		= qmp_phy_vreg_l,
+	.num_vregs		= ARRAY_SIZE(qmp_phy_vreg_l),
+	.regs			= qmp_v3_usb3phy_regs_layout,
+
+	.dp_aux_init = qcom_qmp_v3_phy_dp_aux_init,
+	.configure_dp_tx = qcom_qmp_v3_phy_configure_dp_tx,
+	.configure_dp_phy = qcom_qmp_v3_phy_configure_dp_phy,
+	.calibrate_dp_phy = qcom_qmp_v3_dp_phy_calibrate,
+};
+
 static const struct qmp_phy_combo_cfg sdm845_usb3dpphy_cfg = {
 	.usb_cfg                = &sdm845_usb3phy_cfg,
-	.dp_cfg                 = &sc7180_dpphy_cfg,
+	.dp_cfg                 = &sdm845_dpphy_cfg,
 };
 
 static const struct qmp_phy_cfg sm8150_usb3phy_cfg = {
-- 
2.37.4

