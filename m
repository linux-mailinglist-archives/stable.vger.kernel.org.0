Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235D537C5E4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhELPn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:43:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234318AbhELPjZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:39:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9F4F61C73;
        Wed, 12 May 2021 15:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832849;
        bh=9UeP8We+m4Gx6md/+WvfJYb09b3nl5dZm2zWAqiBTBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUaHF9RTpXWEt7YDe6ygbSPCiT3UMlUguMWs5SXnK+6rndg4+AGUSI7XmSluvoFVy
         dIP0gF/sxwiMQC8IsRNLTaslvMOoqgbTmBfHwN6K82Uvy4ug3IZ3oUPgj+3dQogTkT
         PC8VWaPZ2gywJ/+G0PQEoWp613h7++3nPg3gNzNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 441/530] i2c: rcar: protect against supurious interrupts on V3U
Date:   Wed, 12 May 2021 16:49:11 +0200
Message-Id: <20210512144834.270178251@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 9c975c432bc0aa53a90438fc80b369cb35134a48 ]

V3U creates spurious interrupts which we need to handle. This costs time
until BUS_PHASE_DATA can be activated which is problematic for Gen2 SoCs
and earlier. Because of this we introduce two interrupt handlers here
which will call a generic main irq function once the timing critical
stuff is done.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 57 ++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 14 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 3c9c3a6f7ac8..12f6d452c0f7 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -625,20 +625,11 @@ static bool rcar_i2c_slave_irq(struct rcar_i2c_priv *priv)
  * generated. It turned out that taking a spinlock at the beginning of the ISR
  * was already causing repeated messages. Thus, this driver was converted to
  * the now lockless behaviour. Please keep this in mind when hacking the driver.
+ * R-Car Gen3 seems to have this fixed but earlier versions than R-Car Gen2 are
+ * likely affected. Therefore, we have different interrupt handler entries.
  */
-static irqreturn_t rcar_i2c_irq(int irq, void *ptr)
+static irqreturn_t rcar_i2c_irq(int irq, struct rcar_i2c_priv *priv, u32 msr)
 {
-	struct rcar_i2c_priv *priv = ptr;
-	u32 msr;
-
-	/* Clear START or STOP immediately, except for REPSTART after read */
-	if (likely(!(priv->flags & ID_P_REP_AFTER_RD)))
-		rcar_i2c_write(priv, ICMCR, RCAR_BUS_PHASE_DATA);
-
-	msr = rcar_i2c_read(priv, ICMSR);
-
-	/* Only handle interrupts that are currently enabled */
-	msr &= rcar_i2c_read(priv, ICMIER);
 	if (!msr) {
 		if (rcar_i2c_slave_irq(priv))
 			return IRQ_HANDLED;
@@ -682,6 +673,41 @@ out:
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t rcar_i2c_gen2_irq(int irq, void *ptr)
+{
+	struct rcar_i2c_priv *priv = ptr;
+	u32 msr;
+
+	/* Clear START or STOP immediately, except for REPSTART after read */
+	if (likely(!(priv->flags & ID_P_REP_AFTER_RD)))
+		rcar_i2c_write(priv, ICMCR, RCAR_BUS_PHASE_DATA);
+
+	/* Only handle interrupts that are currently enabled */
+	msr = rcar_i2c_read(priv, ICMSR);
+	msr &= rcar_i2c_read(priv, ICMIER);
+
+	return rcar_i2c_irq(irq, priv, msr);
+}
+
+static irqreturn_t rcar_i2c_gen3_irq(int irq, void *ptr)
+{
+	struct rcar_i2c_priv *priv = ptr;
+	u32 msr;
+
+	/* Only handle interrupts that are currently enabled */
+	msr = rcar_i2c_read(priv, ICMSR);
+	msr &= rcar_i2c_read(priv, ICMIER);
+
+	/*
+	 * Clear START or STOP immediately, except for REPSTART after read or
+	 * if a spurious interrupt was detected.
+	 */
+	if (likely(!(priv->flags & ID_P_REP_AFTER_RD) && msr))
+		rcar_i2c_write(priv, ICMCR, RCAR_BUS_PHASE_DATA);
+
+	return rcar_i2c_irq(irq, priv, msr);
+}
+
 static struct dma_chan *rcar_i2c_request_dma_chan(struct device *dev,
 					enum dma_transfer_direction dir,
 					dma_addr_t port_addr)
@@ -929,6 +955,7 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	struct i2c_adapter *adap;
 	struct device *dev = &pdev->dev;
 	unsigned long irqflags = 0;
+	irqreturn_t (*irqhandler)(int irq, void *ptr) = rcar_i2c_gen3_irq;
 	int ret;
 
 	/* Otherwise logic will break because some bytes must always use PIO */
@@ -977,8 +1004,10 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 
 	rcar_i2c_write(priv, ICSAR, 0); /* Gen2: must be 0 if not using slave */
 
-	if (priv->devtype < I2C_RCAR_GEN3)
+	if (priv->devtype < I2C_RCAR_GEN3) {
 		irqflags |= IRQF_NO_THREAD;
+		irqhandler = rcar_i2c_gen2_irq;
+	}
 
 	if (priv->devtype == I2C_RCAR_GEN3) {
 		priv->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
@@ -999,7 +1028,7 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 		priv->flags |= ID_P_HOST_NOTIFY;
 
 	priv->irq = platform_get_irq(pdev, 0);
-	ret = devm_request_irq(dev, priv->irq, rcar_i2c_irq, irqflags, dev_name(dev), priv);
+	ret = devm_request_irq(dev, priv->irq, irqhandler, irqflags, dev_name(dev), priv);
 	if (ret < 0) {
 		dev_err(dev, "cannot get irq %d\n", priv->irq);
 		goto out_pm_disable;
-- 
2.30.2



