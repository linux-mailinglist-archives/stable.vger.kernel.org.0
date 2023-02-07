Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD08B68D918
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbjBGNPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbjBGNPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:15:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8E53B671
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:15:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 52AC1CE1DA1
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32123C433D2;
        Tue,  7 Feb 2023 13:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775700;
        bh=+gfxedufpQIC04DkgJyOJw1ii/MPG48WYJWnbVR40O8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KjP1eJimq0URvR7dsHh2TgJgTwXrRvSW/mBlfp0Q1c1eba8X4XRngAYVPU9eS6HO1
         XRR3R5ORORSDx+b0DhCgm0iTzle8tJvWJ6XWigwlnbHiviSD96pXxtw3KZQefCN7xX
         lv3EnlJ+5zYz5/X0+aR2r6vR1+uhQnJ6hx31Xnko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 5.15 105/120] phy: qcom-qmp-combo: fix memleak on probe deferral
Date:   Tue,  7 Feb 2023 13:57:56 +0100
Message-Id: <20230207125623.225380383@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
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

commit 2de8a325b1084330ae500380cc27edc39f488c30 upstream.

Switch to using the device-managed of_iomap helper to avoid leaking
memory on probe deferral and driver unbind.

Note that this helper checks for already reserved regions and may fail
if there are multiple devices claiming the same memory.

Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220916102340.11520-5-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -5410,17 +5410,17 @@ int qcom_qmp_phy_create(struct device *d
 	 * For dual lane PHYs: tx2 -> 3, rx2 -> 4, pcs_misc (optional) -> 5
 	 * For single lane PHYs: pcs_misc (optional) -> 3.
 	 */
-	qphy->tx = of_iomap(np, 0);
-	if (!qphy->tx)
-		return -ENOMEM;
-
-	qphy->rx = of_iomap(np, 1);
-	if (!qphy->rx)
-		return -ENOMEM;
-
-	qphy->pcs = of_iomap(np, 2);
-	if (!qphy->pcs)
-		return -ENOMEM;
+	qphy->tx = devm_of_iomap(dev, np, 0, NULL);
+	if (IS_ERR(qphy->tx))
+		return PTR_ERR(qphy->tx);
+
+	qphy->rx = devm_of_iomap(dev, np, 1, NULL);
+	if (IS_ERR(qphy->rx))
+		return PTR_ERR(qphy->rx);
+
+	qphy->pcs = devm_of_iomap(dev, np, 2, NULL);
+	if (IS_ERR(qphy->pcs))
+		return PTR_ERR(qphy->pcs);
 
 	/*
 	 * If this is a dual-lane PHY, then there should be registers for the
@@ -5429,9 +5429,9 @@ int qcom_qmp_phy_create(struct device *d
 	 * offset from the first lane.
 	 */
 	if (cfg->is_dual_lane_phy) {
-		qphy->tx2 = of_iomap(np, 3);
-		qphy->rx2 = of_iomap(np, 4);
-		if (!qphy->tx2 || !qphy->rx2) {
+		qphy->tx2 = devm_of_iomap(dev, np, 3, NULL);
+		qphy->rx2 = devm_of_iomap(dev, np, 4, NULL);
+		if (IS_ERR(qphy->tx2) || IS_ERR(qphy->rx2)) {
 			dev_warn(dev,
 				 "Underspecified device tree, falling back to legacy register regions\n");
 
@@ -5441,15 +5441,17 @@ int qcom_qmp_phy_create(struct device *d
 			qphy->rx2 = qphy->rx + QMP_PHY_LEGACY_LANE_STRIDE;
 
 		} else {
-			qphy->pcs_misc = of_iomap(np, 5);
+			qphy->pcs_misc = devm_of_iomap(dev, np, 5, NULL);
 		}
 
 	} else {
-		qphy->pcs_misc = of_iomap(np, 3);
+		qphy->pcs_misc = devm_of_iomap(dev, np, 3, NULL);
 	}
 
-	if (!qphy->pcs_misc)
+	if (IS_ERR(qphy->pcs_misc)) {
 		dev_vdbg(dev, "PHY pcs_misc-reg not used\n");
+		qphy->pcs_misc = NULL;
+	}
 
 	/*
 	 * Get PHY's Pipe clock, if any. USB3 and PCIe are PIPE3


