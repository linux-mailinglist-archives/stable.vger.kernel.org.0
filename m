Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C161437CA40
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbhELQ2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233709AbhELQSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9836961D85;
        Wed, 12 May 2021 15:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834328;
        bh=gxlODZ85nCTDLysysM9vylBIlDyxt+ShhMjDh2KepUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oi8iCDt7NRIQqluXXfaSJcIwAvV5MeHLsvEwmb31EbjQioiOyTukt+JZZJ6Vo2yPM
         2kK9OyN34RPd3i26o1icCBSbsdivZ4KNk27SJsHx+u/IHts2zxniNrdRk8RBDza+Et
         IfEZBr59nJBbmRQd7jNZvO60r+DHEiRRjE8kvmFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 500/601] i2c: rcar: make sure irq is not threaded on Gen2 and earlier
Date:   Wed, 12 May 2021 16:49:37 +0200
Message-Id: <20210512144844.302242001@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 24c6d4bc563881539d2cd4433e502436ad87d512 ]

Ensure this irq runs as fast as possible.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index ad6630e3cc77..3c9c3a6f7ac8 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -928,6 +928,7 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	struct rcar_i2c_priv *priv;
 	struct i2c_adapter *adap;
 	struct device *dev = &pdev->dev;
+	unsigned long irqflags = 0;
 	int ret;
 
 	/* Otherwise logic will break because some bytes must always use PIO */
@@ -976,6 +977,9 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 
 	rcar_i2c_write(priv, ICSAR, 0); /* Gen2: must be 0 if not using slave */
 
+	if (priv->devtype < I2C_RCAR_GEN3)
+		irqflags |= IRQF_NO_THREAD;
+
 	if (priv->devtype == I2C_RCAR_GEN3) {
 		priv->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
 		if (!IS_ERR(priv->rstc)) {
@@ -995,7 +999,7 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 		priv->flags |= ID_P_HOST_NOTIFY;
 
 	priv->irq = platform_get_irq(pdev, 0);
-	ret = devm_request_irq(dev, priv->irq, rcar_i2c_irq, 0, dev_name(dev), priv);
+	ret = devm_request_irq(dev, priv->irq, rcar_i2c_irq, irqflags, dev_name(dev), priv);
 	if (ret < 0) {
 		dev_err(dev, "cannot get irq %d\n", priv->irq);
 		goto out_pm_disable;
-- 
2.30.2



