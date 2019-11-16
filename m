Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A743FF11E
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731337AbfKPQJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:09:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:56966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730304AbfKPPtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:49:24 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1436B20895;
        Sat, 16 Nov 2019 15:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919363;
        bh=aTkknpA7PYRoAKFfak6Ht2aOudN4LbMl57GR686Cthc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HiSn6CX6Flc1ZqurXRpd3Ht+5k9vpSH2lVrxK76P1kf+bNU2ynTbYgQsxhkWPfuWD
         IKuc1FZX+Fw3WmimYIvmWIjs7ErdifrcIB9wsd9dfI4OvrSUZPAxoCQlN+5mydodJ1
         FzAqcAe9MBfK17z4yAnxcgkasn1fUvwg9xt5QmWQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 085/150] i2c: uniphier-f: fix occasional timeout error
Date:   Sat, 16 Nov 2019 10:46:23 -0500
Message-Id: <20191116154729.9573-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit 39226aaa85f002d695e3cafade3309e12ffdaecd ]

Currently, a timeout error could happen at a repeated START condition.

For a (non-repeated) START condition, the controller starts sending
data when the UNIPHIER_FI2C_CR_STA bit is set. However, for a repeated
START condition, the hardware starts running when the slave address is
written to the TX FIFO - the write to the UNIPHIER_FI2C_CR register is
actually unneeded.

Because the hardware is already running before the IRQ is enabled for
a repeated START, the driver may miss the IRQ event. In most cases,
this problem does not show up since modern CPUs are much faster than
the I2C transfer. However, it is still possible that a context switch
happens after the controller starts, but before the IRQ register is
set up.

To fix this,

 - Do not write UNIPHIER_FI2C_CR for repeated START conditions.

 - Enable IRQ *before* writing the slave address to the TX FIFO.

 - Disable IRQ for the current CPU while queuing up the TX FIFO;
   If the CPU is interrupted by some task, the interrupt handler
   might be invoked due to the empty TX FIFO before completing the
   setup.

Fixes: 6a62974b667f ("i2c: uniphier_f: add UniPhier FIFO-builtin I2C driver")
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-uniphier-f.c | 33 ++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-uniphier-f.c b/drivers/i2c/busses/i2c-uniphier-f.c
index b9a0690b4fd73..bbd5b137aa216 100644
--- a/drivers/i2c/busses/i2c-uniphier-f.c
+++ b/drivers/i2c/busses/i2c-uniphier-f.c
@@ -260,6 +260,8 @@ static irqreturn_t uniphier_fi2c_interrupt(int irq, void *dev_id)
 static void uniphier_fi2c_tx_init(struct uniphier_fi2c_priv *priv, u16 addr)
 {
 	priv->enabled_irqs |= UNIPHIER_FI2C_INT_TE;
+	uniphier_fi2c_set_irqs(priv);
+
 	/* do not use TX byte counter */
 	writel(0, priv->membase + UNIPHIER_FI2C_TBC);
 	/* set slave address */
@@ -292,6 +294,8 @@ static void uniphier_fi2c_rx_init(struct uniphier_fi2c_priv *priv, u16 addr)
 		priv->enabled_irqs |= UNIPHIER_FI2C_INT_RF;
 	}
 
+	uniphier_fi2c_set_irqs(priv);
+
 	/* set slave address with RD bit */
 	writel(UNIPHIER_FI2C_DTTX_CMD | UNIPHIER_FI2C_DTTX_RD | addr << 1,
 	       priv->membase + UNIPHIER_FI2C_DTTX);
@@ -315,14 +319,16 @@ static void uniphier_fi2c_recover(struct uniphier_fi2c_priv *priv)
 }
 
 static int uniphier_fi2c_master_xfer_one(struct i2c_adapter *adap,
-					 struct i2c_msg *msg, bool stop)
+					 struct i2c_msg *msg, bool repeat,
+					 bool stop)
 {
 	struct uniphier_fi2c_priv *priv = i2c_get_adapdata(adap);
 	bool is_read = msg->flags & I2C_M_RD;
 	unsigned long time_left, flags;
 
-	dev_dbg(&adap->dev, "%s: addr=0x%02x, len=%d, stop=%d\n",
-		is_read ? "receive" : "transmit", msg->addr, msg->len, stop);
+	dev_dbg(&adap->dev, "%s: addr=0x%02x, len=%d, repeat=%d, stop=%d\n",
+		is_read ? "receive" : "transmit", msg->addr, msg->len,
+		repeat, stop);
 
 	priv->len = msg->len;
 	priv->buf = msg->buf;
@@ -338,16 +344,24 @@ static int uniphier_fi2c_master_xfer_one(struct i2c_adapter *adap,
 	writel(UNIPHIER_FI2C_RST_TBRST | UNIPHIER_FI2C_RST_RBRST,
 	       priv->membase + UNIPHIER_FI2C_RST);	/* reset TX/RX FIFO */
 
+	spin_lock_irqsave(&priv->lock, flags);
+
 	if (is_read)
 		uniphier_fi2c_rx_init(priv, msg->addr);
 	else
 		uniphier_fi2c_tx_init(priv, msg->addr);
 
-	uniphier_fi2c_set_irqs(priv);
-
 	dev_dbg(&adap->dev, "start condition\n");
-	writel(UNIPHIER_FI2C_CR_MST | UNIPHIER_FI2C_CR_STA,
-	       priv->membase + UNIPHIER_FI2C_CR);
+	/*
+	 * For a repeated START condition, writing a slave address to the FIFO
+	 * kicks the controller. So, the UNIPHIER_FI2C_CR register should be
+	 * written only for a non-repeated START condition.
+	 */
+	if (!repeat)
+		writel(UNIPHIER_FI2C_CR_MST | UNIPHIER_FI2C_CR_STA,
+		       priv->membase + UNIPHIER_FI2C_CR);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	time_left = wait_for_completion_timeout(&priv->comp, adap->timeout);
 
@@ -408,6 +422,7 @@ static int uniphier_fi2c_master_xfer(struct i2c_adapter *adap,
 				     struct i2c_msg *msgs, int num)
 {
 	struct i2c_msg *msg, *emsg = msgs + num;
+	bool repeat = false;
 	int ret;
 
 	ret = uniphier_fi2c_check_bus_busy(adap);
@@ -418,9 +433,11 @@ static int uniphier_fi2c_master_xfer(struct i2c_adapter *adap,
 		/* Emit STOP if it is the last message or I2C_M_STOP is set. */
 		bool stop = (msg + 1 == emsg) || (msg->flags & I2C_M_STOP);
 
-		ret = uniphier_fi2c_master_xfer_one(adap, msg, stop);
+		ret = uniphier_fi2c_master_xfer_one(adap, msg, repeat, stop);
 		if (ret)
 			return ret;
+
+		repeat = !stop;
 	}
 
 	return num;
-- 
2.20.1

