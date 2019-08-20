Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B68A9960FD
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730789AbfHTNoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:44:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730778AbfHTNnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:43:05 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B576F2332A;
        Tue, 20 Aug 2019 13:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308585;
        bh=Q5HI2uqSsn9Q2lche9iF1O586AHO9f04gzNyzOLNNd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P7GxV7/T8lVEihgT+Kcsa7SyNj/kntj5AiQbcd0OXom2eaOVs4A7F4q3FFNpwxm5p
         58gCDutZO13Dz0szYUYojmrpOu3KCGKlPkfJPyV5WF1x7rhqNc6hReQpBh6HNjFGvC
         VjQmNU6dOGEw4pp8/v3Q8vU+vor/JKtvQ676QDbs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Krzysztof Adamski <krzysztof.adamski@nokia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/12] i2c: emev2: avoid race when unregistering slave client
Date:   Tue, 20 Aug 2019 09:42:50 -0400
Message-Id: <20190820134253.11562-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134253.11562-1-sashal@kernel.org>
References: <20190820134253.11562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit d7437fc0d8291181debe032671a289b6bd93f46f ]

After we disabled interrupts, there might still be an active one
running. Sync before clearing the pointer to the slave device.

Fixes: c31d0a00021d ("i2c: emev2: add slave support")
Reported-by: Krzysztof Adamski <krzysztof.adamski@nokia.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Krzysztof Adamski <krzysztof.adamski@nokia.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-emev2.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-emev2.c b/drivers/i2c/busses/i2c-emev2.c
index d2e84480fbe96..dd97e5d9f49a2 100644
--- a/drivers/i2c/busses/i2c-emev2.c
+++ b/drivers/i2c/busses/i2c-emev2.c
@@ -72,6 +72,7 @@ struct em_i2c_device {
 	struct completion msg_done;
 	struct clk *sclk;
 	struct i2c_client *slave;
+	int irq;
 };
 
 static inline void em_clear_set_bit(struct em_i2c_device *priv, u8 clear, u8 set, u8 reg)
@@ -342,6 +343,12 @@ static int em_i2c_unreg_slave(struct i2c_client *slave)
 
 	writeb(0, priv->base + I2C_OFS_SVA0);
 
+	/*
+	 * Wait for interrupt to finish. New slave irqs cannot happen because we
+	 * cleared the slave address and, thus, only extension codes will be
+	 * detected which do not use the slave ptr.
+	 */
+	synchronize_irq(priv->irq);
 	priv->slave = NULL;
 
 	return 0;
@@ -358,7 +365,7 @@ static int em_i2c_probe(struct platform_device *pdev)
 {
 	struct em_i2c_device *priv;
 	struct resource *r;
-	int irq, ret;
+	int ret;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -393,8 +400,8 @@ static int em_i2c_probe(struct platform_device *pdev)
 
 	em_i2c_reset(&priv->adap);
 
-	irq = platform_get_irq(pdev, 0);
-	ret = devm_request_irq(&pdev->dev, irq, em_i2c_irq_handler, 0,
+	priv->irq = platform_get_irq(pdev, 0);
+	ret = devm_request_irq(&pdev->dev, priv->irq, em_i2c_irq_handler, 0,
 				"em_i2c", priv);
 	if (ret)
 		goto err_clk;
@@ -404,7 +411,8 @@ static int em_i2c_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_clk;
 
-	dev_info(&pdev->dev, "Added i2c controller %d, irq %d\n", priv->adap.nr, irq);
+	dev_info(&pdev->dev, "Added i2c controller %d, irq %d\n", priv->adap.nr,
+		 priv->irq);
 
 	return 0;
 
-- 
2.20.1

