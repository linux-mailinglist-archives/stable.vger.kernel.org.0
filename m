Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3247F541E97
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381560AbiFGWcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385515AbiFGWbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:31:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38EF27B490;
        Tue,  7 Jun 2022 12:24:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89EC6B823CA;
        Tue,  7 Jun 2022 19:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1F8C385A2;
        Tue,  7 Jun 2022 19:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629896;
        bh=4Wlc1BHfcp7K3SVwrbuEW60ljxGlDMXggyJ2yaEMzkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2tyl6jTfZjsGD5ZDAJldiSu2FaMrEaOJfFy5WK4IB4RAt5B0xlaCDetl5ecO7j50
         4cwUPIfVmeC85U9sLiSdTudcPJ+R9rzzwAewLffD41uvlnzW1pvQG0fRegfVL5R2zB
         kVrp4aNNCTfkYaF566dWIFojI1UQ31fCVl4pUcGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.18 849/879] phy: qcom-qmp: fix struct clk leak on probe errors
Date:   Tue,  7 Jun 2022 19:06:07 +0200
Message-Id: <20220607165027.494409359@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit f0a4bc38a12f5a0cc5ad68670d9480e91e6a94df upstream.

Make sure to release the pipe clock reference in case of a late probe
error (e.g. probe deferral).

Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
Cc: stable@vger.kernel.org      # 4.12
Cc: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220427063243.32576-2-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -5890,7 +5890,7 @@ int qcom_qmp_phy_create(struct device *d
 	 * all phys that don't need this.
 	 */
 	snprintf(prop_name, sizeof(prop_name), "pipe%d", id);
-	qphy->pipe_clk = of_clk_get_by_name(np, prop_name);
+	qphy->pipe_clk = devm_get_clk_from_child(dev, np, prop_name);
 	if (IS_ERR(qphy->pipe_clk)) {
 		if (cfg->type == PHY_TYPE_PCIE ||
 		    cfg->type == PHY_TYPE_USB3) {


