Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E64350B7EE
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 15:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbiDVNNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 09:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbiDVNND (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 09:13:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F5815712;
        Fri, 22 Apr 2022 06:10:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A24CB82CC4;
        Fri, 22 Apr 2022 13:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B350AC385AB;
        Fri, 22 Apr 2022 13:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650633007;
        bh=ItXHPzCWaDbrNKiK53WMBEuShGLtb9S+gVvDhMea3zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BRg+lJsQSUhF/pS107sPkge5fTxCbjdpNym7EP/J6tip7amPjyC8QJcLz5wN14ODv
         5Szcg/+3GNWkDRWb+Z/QZvdgsCt4vHw3KLV8KNTw2ipKIK8lIt9Q7+Lx+bEupT9k04
         apsWZOinAIy4J+Z0UL70kwo+dKVhnCFEKIBi2YVSpGMHNXNrqG4IJdSDk0TaA7MBTD
         1Tw1EexQbi4w5W7fiD8G76mn/VfRjqDK5rsQp+1VZmOjYj7mLNu50vXS2VOGqrMlrr
         vLwAzlWEIfiCa9LdWUWK9dAWWbfpQUNZDt7EKiRWwZ59MJng25xNIuY4xL6Uqr1y4R
         tBSUud6e9zxlg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1nht2w-0000XM-3N; Fri, 22 Apr 2022 15:10:02 +0200
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
Subject: [PATCH 1/2] phy: qcom-qmp: fix struct clk leak on probe errors
Date:   Fri, 22 Apr 2022 15:09:40 +0200
Message-Id: <20220422130941.2044-2-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220422130941.2044-1-johan+linaro@kernel.org>
References: <20220422130941.2044-1-johan+linaro@kernel.org>
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

Make sure to release the pipe clock reference in case of a late probe
error (e.g. probe deferral).

Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
Cc: stable@vger.kernel.org      # 4.12
Cc: Vivek Gautam <vivek.gautam@codeaurora.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index 7d2d1ab061f7..a84f7d1fc9b7 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -6077,7 +6077,7 @@ int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id,
 	 * all phys that don't need this.
 	 */
 	snprintf(prop_name, sizeof(prop_name), "pipe%d", id);
-	qphy->pipe_clk = of_clk_get_by_name(np, prop_name);
+	qphy->pipe_clk = devm_get_clk_from_child(dev, np, prop_name);
 	if (IS_ERR(qphy->pipe_clk)) {
 		if (cfg->type == PHY_TYPE_PCIE ||
 		    cfg->type == PHY_TYPE_USB3) {
-- 
2.35.1

