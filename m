Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAB9B10BE13
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730526AbfK0Uvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:51:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730519AbfK0Uvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:51:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2832B21850;
        Wed, 27 Nov 2019 20:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887903;
        bh=NjWy5znEkoWXqsJzxRB5cmvhQBP3xr8ifrgF/0d3lR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJ9feTuZMp0dR3VBrbKEQOMG6SYWXAliVWa0ovxYus+yj96FH8T8N+NrAf77SxLC0
         JKCjV6SEENcciUcIpJDRhvi0NbHzLRPmmRSV87P3VGnXqD8D4//swaOIVgNLyJ8c6G
         kHzZz6PBbeQX43rZhpj7qFtxTuh7qepbqJzda6xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 098/211] i2c: uniphier-f: make driver robust against concurrency
Date:   Wed, 27 Nov 2019 21:30:31 +0100
Message-Id: <20191127203102.959083592@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit f1fdcbbdf45d9609f3d4063b67e9ea941ba3a58f ]

This is unlikely to happen, but it is possible for a CPU to enter
the interrupt handler just after wait_for_completion_timeout() has
expired. If this happens, the hardware is accessed from multiple
contexts concurrently.

Disable the IRQ after wait_for_completion_timeout(), and do nothing
from the handler when the IRQ is disabled.

Fixes: 6a62974b667f ("i2c: uniphier_f: add UniPhier FIFO-builtin I2C driver")
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-uniphier-f.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-uniphier-f.c b/drivers/i2c/busses/i2c-uniphier-f.c
index bc26ec822e268..b9a0690b4fd73 100644
--- a/drivers/i2c/busses/i2c-uniphier-f.c
+++ b/drivers/i2c/busses/i2c-uniphier-f.c
@@ -98,6 +98,7 @@ struct uniphier_fi2c_priv {
 	unsigned int flags;
 	unsigned int busy_cnt;
 	unsigned int clk_cycle;
+	spinlock_t lock;	/* IRQ synchronization */
 };
 
 static void uniphier_fi2c_fill_txfifo(struct uniphier_fi2c_priv *priv,
@@ -162,7 +163,10 @@ static irqreturn_t uniphier_fi2c_interrupt(int irq, void *dev_id)
 	struct uniphier_fi2c_priv *priv = dev_id;
 	u32 irq_status;
 
+	spin_lock(&priv->lock);
+
 	irq_status = readl(priv->membase + UNIPHIER_FI2C_INT);
+	irq_status &= priv->enabled_irqs;
 
 	dev_dbg(&priv->adap.dev,
 		"interrupt: enabled_irqs=%04x, irq_status=%04x\n",
@@ -230,6 +234,8 @@ static irqreturn_t uniphier_fi2c_interrupt(int irq, void *dev_id)
 		goto handled;
 	}
 
+	spin_unlock(&priv->lock);
+
 	return IRQ_NONE;
 
 data_done:
@@ -246,6 +252,8 @@ static irqreturn_t uniphier_fi2c_interrupt(int irq, void *dev_id)
 handled:
 	uniphier_fi2c_clear_irqs(priv);
 
+	spin_unlock(&priv->lock);
+
 	return IRQ_HANDLED;
 }
 
@@ -311,7 +319,7 @@ static int uniphier_fi2c_master_xfer_one(struct i2c_adapter *adap,
 {
 	struct uniphier_fi2c_priv *priv = i2c_get_adapdata(adap);
 	bool is_read = msg->flags & I2C_M_RD;
-	unsigned long time_left;
+	unsigned long time_left, flags;
 
 	dev_dbg(&adap->dev, "%s: addr=0x%02x, len=%d, stop=%d\n",
 		is_read ? "receive" : "transmit", msg->addr, msg->len, stop);
@@ -342,6 +350,12 @@ static int uniphier_fi2c_master_xfer_one(struct i2c_adapter *adap,
 	       priv->membase + UNIPHIER_FI2C_CR);
 
 	time_left = wait_for_completion_timeout(&priv->comp, adap->timeout);
+
+	spin_lock_irqsave(&priv->lock, flags);
+	priv->enabled_irqs = 0;
+	uniphier_fi2c_set_irqs(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
 	if (!time_left) {
 		dev_err(&adap->dev, "transaction timeout.\n");
 		uniphier_fi2c_recover(priv);
@@ -546,6 +560,7 @@ static int uniphier_fi2c_probe(struct platform_device *pdev)
 
 	priv->clk_cycle = clk_rate / bus_speed;
 	init_completion(&priv->comp);
+	spin_lock_init(&priv->lock);
 	priv->adap.owner = THIS_MODULE;
 	priv->adap.algo = &uniphier_fi2c_algo;
 	priv->adap.dev.parent = dev;
-- 
2.20.1



