Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D155CA9190
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732206AbfIDSSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:18:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389398AbfIDSKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:10:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 315B123402;
        Wed,  4 Sep 2019 18:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620630;
        bh=QrPGqFjmN3VWaRhYMWu04bxZKL55/V7mCxBsqYP8BXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=off4VN96pARTsLpbj5ZG1CB6HBk+3IlckShiLkN+2IhgnS7Sf925ttmkTqA5/RskY
         PCT5msAxQS81/Ds7oLtThFxvYOeZeDag624A2cFmn9XodNAdh5mKPsZbgEpE4A16WD
         sFWepMCcu66x5vxkz5PK9dMIl4RSfJllwIDUlZK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Adamski <krzysztof.adamski@nokia.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 036/143] i2c: rcar: avoid race when unregistering slave client
Date:   Wed,  4 Sep 2019 19:52:59 +0200
Message-Id: <20190904175315.460634723@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7b814d852af6944657c2961039f404c4490771c0 ]

After we disabled interrupts, there might still be an active one
running. Sync before clearing the pointer to the slave device.

Fixes: de20d1857dd6 ("i2c: rcar: add slave support")
Reported-by: Krzysztof Adamski <krzysztof.adamski@nokia.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Krzysztof Adamski <krzysztof.adamski@nokia.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index d39a4606f72d3..531c01100b560 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -139,6 +139,7 @@ struct rcar_i2c_priv {
 	enum dma_data_direction dma_direction;
 
 	struct reset_control *rstc;
+	int irq;
 };
 
 #define rcar_i2c_priv_to_dev(p)		((p)->adap.dev.parent)
@@ -861,9 +862,11 @@ static int rcar_unreg_slave(struct i2c_client *slave)
 
 	WARN_ON(!priv->slave);
 
+	/* disable irqs and ensure none is running before clearing ptr */
 	rcar_i2c_write(priv, ICSIER, 0);
 	rcar_i2c_write(priv, ICSCR, 0);
 
+	synchronize_irq(priv->irq);
 	priv->slave = NULL;
 
 	pm_runtime_put(rcar_i2c_priv_to_dev(priv));
@@ -918,7 +921,7 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	struct i2c_adapter *adap;
 	struct device *dev = &pdev->dev;
 	struct i2c_timings i2c_t;
-	int irq, ret;
+	int ret;
 
 	/* Otherwise logic will break because some bytes must always use PIO */
 	BUILD_BUG_ON_MSG(RCAR_MIN_DMA_LEN < 3, "Invalid min DMA length");
@@ -984,10 +987,10 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 		pm_runtime_put(dev);
 
 
-	irq = platform_get_irq(pdev, 0);
-	ret = devm_request_irq(dev, irq, rcar_i2c_irq, 0, dev_name(dev), priv);
+	priv->irq = platform_get_irq(pdev, 0);
+	ret = devm_request_irq(dev, priv->irq, rcar_i2c_irq, 0, dev_name(dev), priv);
 	if (ret < 0) {
-		dev_err(dev, "cannot get irq %d\n", irq);
+		dev_err(dev, "cannot get irq %d\n", priv->irq);
 		goto out_pm_disable;
 	}
 
-- 
2.20.1



