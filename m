Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9028B37CD55
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238579AbhELQyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:54:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243799AbhELQmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BBE961991;
        Wed, 12 May 2021 16:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835626;
        bh=8TVqaRWtXkycjf8XmVkiEBiZDcz3aCqEO5QImUkOQGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VCqa554ZCduGDm5CLPe5L+W/RnSYdb8SFgy14hVkw9E903ESsewOfP8ORjQQo2q7G
         enNV9TD0OUU9tqrPFmIKTrpMChIQk3mXmOj9ezBOhIlqE/iv1h5YmqNaq40+01WqqT
         fXfUpv0Uecd82BPSvKB6sgwSF8lP8Yr21HYB/jnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Orson Zhai <orson.zhai@unisoc.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 421/677] mailbox: sprd: Introduce refcnt when clients requests/free channels
Date:   Wed, 12 May 2021 16:47:47 +0200
Message-Id: <20210512144851.323665779@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Orson Zhai <orson.zhai@unisoc.com>

[ Upstream commit 9468ab84032f96496e998cfa173cd1d0ac316bcd ]

Unisoc mailbox has no way to be enabled/disabled for any single channel.
They can only be set to startup or shutdown as a whole device at same time.

Add a variable to count references to avoid mailbox FIFO being reset
unexpectedly when clients are requesting or freeing channels.

Also add a lock to dismiss possible conflicts from register r/w in
different startup or shutdown threads. And fix the crash problem when early
interrupts come from channel which has not been requested by client yet.

Fixes: ca27fc26cd22 ("mailbox: sprd: Add Spreadtrum mailbox driver")
Signed-off-by: Orson Zhai <orson.zhai@unisoc.com>
Reviewed-by: Baolin Wang <baolin.wang7@gmail.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/sprd-mailbox.c | 43 +++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/mailbox/sprd-mailbox.c b/drivers/mailbox/sprd-mailbox.c
index 4c325301a2fe..94d9067dc8d0 100644
--- a/drivers/mailbox/sprd-mailbox.c
+++ b/drivers/mailbox/sprd-mailbox.c
@@ -60,6 +60,8 @@ struct sprd_mbox_priv {
 	struct clk		*clk;
 	u32			outbox_fifo_depth;
 
+	struct mutex		lock;
+	u32			refcnt;
 	struct mbox_chan	chan[SPRD_MBOX_CHAN_MAX];
 };
 
@@ -115,7 +117,11 @@ static irqreturn_t sprd_mbox_outbox_isr(int irq, void *data)
 		id = readl(priv->outbox_base + SPRD_MBOX_ID);
 
 		chan = &priv->chan[id];
-		mbox_chan_received_data(chan, (void *)msg);
+		if (chan->cl)
+			mbox_chan_received_data(chan, (void *)msg);
+		else
+			dev_warn_ratelimited(priv->dev,
+				    "message's been dropped at ch[%d]\n", id);
 
 		/* Trigger to update outbox FIFO pointer */
 		writel(0x1, priv->outbox_base + SPRD_MBOX_TRIGGER);
@@ -215,18 +221,22 @@ static int sprd_mbox_startup(struct mbox_chan *chan)
 	struct sprd_mbox_priv *priv = to_sprd_mbox_priv(chan->mbox);
 	u32 val;
 
-	/* Select outbox FIFO mode and reset the outbox FIFO status */
-	writel(0x0, priv->outbox_base + SPRD_MBOX_FIFO_RST);
+	mutex_lock(&priv->lock);
+	if (priv->refcnt++ == 0) {
+		/* Select outbox FIFO mode and reset the outbox FIFO status */
+		writel(0x0, priv->outbox_base + SPRD_MBOX_FIFO_RST);
 
-	/* Enable inbox FIFO overflow and delivery interrupt */
-	val = readl(priv->inbox_base + SPRD_MBOX_IRQ_MSK);
-	val &= ~(SPRD_INBOX_FIFO_OVERFLOW_IRQ | SPRD_INBOX_FIFO_DELIVER_IRQ);
-	writel(val, priv->inbox_base + SPRD_MBOX_IRQ_MSK);
+		/* Enable inbox FIFO overflow and delivery interrupt */
+		val = readl(priv->inbox_base + SPRD_MBOX_IRQ_MSK);
+		val &= ~(SPRD_INBOX_FIFO_OVERFLOW_IRQ | SPRD_INBOX_FIFO_DELIVER_IRQ);
+		writel(val, priv->inbox_base + SPRD_MBOX_IRQ_MSK);
 
-	/* Enable outbox FIFO not empty interrupt */
-	val = readl(priv->outbox_base + SPRD_MBOX_IRQ_MSK);
-	val &= ~SPRD_OUTBOX_FIFO_NOT_EMPTY_IRQ;
-	writel(val, priv->outbox_base + SPRD_MBOX_IRQ_MSK);
+		/* Enable outbox FIFO not empty interrupt */
+		val = readl(priv->outbox_base + SPRD_MBOX_IRQ_MSK);
+		val &= ~SPRD_OUTBOX_FIFO_NOT_EMPTY_IRQ;
+		writel(val, priv->outbox_base + SPRD_MBOX_IRQ_MSK);
+	}
+	mutex_unlock(&priv->lock);
 
 	return 0;
 }
@@ -235,9 +245,13 @@ static void sprd_mbox_shutdown(struct mbox_chan *chan)
 {
 	struct sprd_mbox_priv *priv = to_sprd_mbox_priv(chan->mbox);
 
-	/* Disable inbox & outbox interrupt */
-	writel(SPRD_INBOX_FIFO_IRQ_MASK, priv->inbox_base + SPRD_MBOX_IRQ_MSK);
-	writel(SPRD_OUTBOX_FIFO_IRQ_MASK, priv->outbox_base + SPRD_MBOX_IRQ_MSK);
+	mutex_lock(&priv->lock);
+	if (--priv->refcnt == 0) {
+		/* Disable inbox & outbox interrupt */
+		writel(SPRD_INBOX_FIFO_IRQ_MASK, priv->inbox_base + SPRD_MBOX_IRQ_MSK);
+		writel(SPRD_OUTBOX_FIFO_IRQ_MASK, priv->outbox_base + SPRD_MBOX_IRQ_MSK);
+	}
+	mutex_unlock(&priv->lock);
 }
 
 static const struct mbox_chan_ops sprd_mbox_ops = {
@@ -266,6 +280,7 @@ static int sprd_mbox_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv->dev = dev;
+	mutex_init(&priv->lock);
 
 	/*
 	 * The Spreadtrum mailbox uses an inbox to send messages to the target
-- 
2.30.2



