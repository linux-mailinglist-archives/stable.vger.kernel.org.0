Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818B96677F0
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240076AbjALOvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240061AbjALOur (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:50:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403DB13CF6
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:37:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9048B81E7A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53358C433F0;
        Thu, 12 Jan 2023 14:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534234;
        bh=ZVw6xi5FOV4USayG73uMIWgm58Br0PBUGIfcjuqnO+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phBdJ0O+iukpIG90c79Gn6MHpWc7tdUUD7YZwfv4/C9Knii2yyMBtbnIRWaMzjepy
         pZpSzLis5kqDe5eFgqtE+Vao+Cgw4EG4+I9Zzopa1LC/24EdKTKUl+h6qT0k2dXPDv
         Fsf7rvddYIarQ4FqsXOnpdz0cgojUsyWeEb3FDs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiguang Xiao <jiguang.xiao@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 741/783] net: amd-xgbe: add missed tasklet_kill
Date:   Thu, 12 Jan 2023 14:57:37 +0100
Message-Id: <20230112135558.712671358@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index a816b30bca04..a5d6faf7b89e 100644
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



