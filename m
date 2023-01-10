Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9274C664871
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbjAJSLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239088AbjAJSKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:10:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3A565B5
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:09:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 886A4B81909
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11BAC433EF;
        Tue, 10 Jan 2023 18:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374149;
        bh=gY1a5ERSTIZgrNMRDuG2O2Et1lzql3dRj0Y0QDk1ce8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tx/HC8AHdF/ExdKLCbdR7X5PaSo7Ua5EdZYcjxVX8/68QLqrl0bU3gRrJmapG5S2x
         kai1QDLOx+DW2U2Bim12MlP4Mrtw9TT68X2jVKsTQRop9cEfvaOkc6osFb3Ih5f8fk
         87WvDf+/OdXCmMxnCKHO7VYdryvfVbHzuMdUP/n0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiguang Xiao <jiguang.xiao@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 063/148] net: amd-xgbe: add missed tasklet_kill
Date:   Tue, 10 Jan 2023 19:02:47 +0100
Message-Id: <20230110180019.226757958@linuxfoundation.org>
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

From: Jiguang Xiao <jiguang.xiao@windriver.com>

[ Upstream commit d530ece70f16f912e1d1bfeea694246ab78b0a4b ]

The driver does not call tasklet_kill in several places.
Add the calls to fix it.

Fixes: 85b85c853401 ("amd-xgbe: Re-issue interrupt if interrupt status not cleared")
Signed-off-by: Jiguang Xiao <jiguang.xiao@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c  | 3 +++
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c  | 4 +++-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 4 +++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index f342bb853189..2ee2cd4a1e35 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1064,6 +1064,9 @@ static void xgbe_free_irqs(struct xgbe_prv_data *pdata)
 
 	devm_free_irq(pdata->dev, pdata->dev_irq, pdata);
 
+	tasklet_kill(&pdata->tasklet_dev);
+	tasklet_kill(&pdata->tasklet_ecc);
+
 	if (pdata->vdata->ecc_support && (pdata->dev_irq != pdata->ecc_irq))
 		devm_free_irq(pdata->dev, pdata->ecc_irq, pdata);
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c b/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
index 22d4fc547a0a..a9ccc4258ee5 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
@@ -447,8 +447,10 @@ static void xgbe_i2c_stop(struct xgbe_prv_data *pdata)
 	xgbe_i2c_disable(pdata);
 	xgbe_i2c_clear_all_interrupts(pdata);
 
-	if (pdata->dev_irq != pdata->i2c_irq)
+	if (pdata->dev_irq != pdata->i2c_irq) {
 		devm_free_irq(pdata->dev, pdata->i2c_irq, pdata);
+		tasklet_kill(&pdata->tasklet_i2c);
+	}
 }
 
 static int xgbe_i2c_start(struct xgbe_prv_data *pdata)
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 4e97b4869522..0c5c1b155683 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -1390,8 +1390,10 @@ static void xgbe_phy_stop(struct xgbe_prv_data *pdata)
 	/* Disable auto-negotiation */
 	xgbe_an_disable_all(pdata);
 
-	if (pdata->dev_irq != pdata->an_irq)
+	if (pdata->dev_irq != pdata->an_irq) {
 		devm_free_irq(pdata->dev, pdata->an_irq, pdata);
+		tasklet_kill(&pdata->tasklet_an);
+	}
 
 	pdata->phy_if.phy_impl.stop(pdata);
 
-- 
2.35.1



