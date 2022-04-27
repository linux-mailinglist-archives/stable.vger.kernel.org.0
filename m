Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5C351113E
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 08:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358161AbiD0Gjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 02:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358181AbiD0Gis (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 02:38:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039B01CB19;
        Tue, 26 Apr 2022 23:35:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92F7BB82503;
        Wed, 27 Apr 2022 06:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D70FC385A7;
        Wed, 27 Apr 2022 06:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651041335;
        bh=3dR4OmJG6gvns4unQ6WAXw8yKHmRGcvo/1l1zQKbAjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SrC/WdTNWFNfHhphHcADN0Uj1HB/ajgQQk/SVaFmBHboQexT0Ni0bhvnDn2GAc0pu
         ayv1DqjD4KA0GArUFsiIy5odk7lkBFJtrbEiy3IZCK7E1Wq2hMHvQv0eEKARppo5yI
         nr+DFInofCApcnGan60uvb/2Wwww6LgobLRX4aK10CED2i2LoGnE1+qMZnt+634ugN
         EnwHfcvCuWTb0CYPApsbwW5ejHDvocYYpioljUKjchKZZ9XIKCOHutdTbCr8WTiL70
         Dwzd/1TKoHR+VV9L724z73kaFFNO2w7I3mH6WjvI2uUt0yMBIEthkl47+oBcbrX5sl
         +r37uP99tFkUw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1njbGz-0008VX-0a; Wed, 27 Apr 2022 08:35:37 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org,
        Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v2 2/3] phy: qcom-qmp: fix reset-controller leak on probe errors
Date:   Wed, 27 Apr 2022 08:32:42 +0200
Message-Id: <20220427063243.32576-3-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427063243.32576-1-johan+linaro@kernel.org>
References: <20220427063243.32576-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to release the lane reset controller in case of a late probe
error (e.g. probe deferral).

Note that due to the reset controller being defined in devicetree in
"lane" child nodes, devm_reset_control_get_exclusive() cannot be used
directly.

Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
Cc: stable@vger.kernel.org      # 4.12
Cc: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index a84f7d1fc9b7..3f77830921f5 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -6005,6 +6005,11 @@ static const struct phy_ops qcom_qmp_pcie_ufs_ops = {
 	.owner		= THIS_MODULE,
 };
 
+static void qcom_qmp_reset_control_put(void *data)
+{
+	reset_control_put(data);
+}
+
 static
 int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id,
 			void __iomem *serdes, const struct qmp_phy_cfg *cfg)
@@ -6099,6 +6104,10 @@ int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id,
 			dev_err(dev, "failed to get lane%d reset\n", id);
 			return PTR_ERR(qphy->lane_rst);
 		}
+		ret = devm_add_action_or_reset(dev, qcom_qmp_reset_control_put,
+					       qphy->lane_rst);
+		if (ret)
+			return ret;
 	}
 
 	if (cfg->type == PHY_TYPE_UFS || cfg->type == PHY_TYPE_PCIE)
-- 
2.35.1

