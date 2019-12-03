Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7723111CAE
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbfLCWqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:46:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729197AbfLCWq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:46:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9295F20656;
        Tue,  3 Dec 2019 22:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413188;
        bh=7QYR8y6K6uZLmyOpyZwuVHPrreRRG21ggFJfE/RRb+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBMuZzUp4beG3vC6Xj8Ew3wyOxmchOnsyz0m1mvbTTbZ3mNxgHLS0c6UHoUGKmjew
         /Ttfsqe9Suc5WL4UMkEP+p0gweTLPHD6zZ4Yt26u47XWK9ptXP6VwzPU2ygxsUWzfJ
         6UbrlxydpggD8SvhM2adwcI60P5aKJZkZ4ZLdBBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 031/321] can: rx-offload: can_rx_offload_offload_one(): use ERR_PTR() to propagate error value in case of errors
Date:   Tue,  3 Dec 2019 23:31:37 +0100
Message-Id: <20191203223428.734698187@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit d763ab3044f0bf50bd0e6179f6b2cf1c125d1d94 ]

Before this patch can_rx_offload_offload_one() returns a pointer to a
skb containing the read CAN frame or a NULL pointer.

However the meaning of the NULL pointer is ambiguous, it can either mean
the requested mailbox is empty or there was an error.

This patch fixes this situation by returning:
- pointer to skb on success
- NULL pointer if mailbox is empty
- ERR_PTR() in case of an error

All users of can_rx_offload_offload_one() have been adopted, no
functional change intended.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rx-offload.c | 86 ++++++++++++++++++++++++++++++------
 1 file changed, 73 insertions(+), 13 deletions(-)

diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index 16af09c71cfed..1b3ce70c55bc7 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -116,39 +116,95 @@ static int can_rx_offload_compare(struct sk_buff *a, struct sk_buff *b)
 	return cb_b->timestamp - cb_a->timestamp;
 }
 
-static struct sk_buff *can_rx_offload_offload_one(struct can_rx_offload *offload, unsigned int n)
+/**
+ * can_rx_offload_offload_one() - Read one CAN frame from HW
+ * @offload: pointer to rx_offload context
+ * @n: number of mailbox to read
+ *
+ * The task of this function is to read a CAN frame from mailbox @n
+ * from the device and return the mailbox's content as a struct
+ * sk_buff.
+ *
+ * If the struct can_rx_offload::skb_queue exceeds the maximal queue
+ * length (struct can_rx_offload::skb_queue_len_max) or no skb can be
+ * allocated, the mailbox contents is discarded by reading it into an
+ * overflow buffer. This way the mailbox is marked as free by the
+ * driver.
+ *
+ * Return: A pointer to skb containing the CAN frame on success.
+ *
+ *         NULL if the mailbox @n is empty.
+ *
+ *         ERR_PTR() in case of an error
+ */
+static struct sk_buff *
+can_rx_offload_offload_one(struct can_rx_offload *offload, unsigned int n)
 {
-	struct sk_buff *skb = NULL;
+	struct sk_buff *skb = NULL, *skb_error = NULL;
 	struct can_rx_offload_cb *cb;
 	struct can_frame *cf;
 	int ret;
 
-	/* If queue is full or skb not available, read to discard mailbox */
 	if (likely(skb_queue_len(&offload->skb_queue) <
-		   offload->skb_queue_len_max))
+		   offload->skb_queue_len_max)) {
 		skb = alloc_can_skb(offload->dev, &cf);
+		if (unlikely(!skb))
+			skb_error = ERR_PTR(-ENOMEM);	/* skb alloc failed */
+	} else {
+		skb_error = ERR_PTR(-ENOBUFS);		/* skb_queue is full */
+	}
 
-	if (!skb) {
+	/* If queue is full or skb not available, drop by reading into
+	 * overflow buffer.
+	 */
+	if (unlikely(skb_error)) {
 		struct can_frame cf_overflow;
 		u32 timestamp;
 
 		ret = offload->mailbox_read(offload, &cf_overflow,
 					    &timestamp, n);
-		if (ret) {
-			offload->dev->stats.rx_dropped++;
-			offload->dev->stats.rx_fifo_errors++;
-		}
 
-		return NULL;
+		/* Mailbox was empty. */
+		if (unlikely(!ret))
+			return NULL;
+
+		/* Mailbox has been read and we're dropping it or
+		 * there was a problem reading the mailbox.
+		 *
+		 * Increment error counters in any case.
+		 */
+		offload->dev->stats.rx_dropped++;
+		offload->dev->stats.rx_fifo_errors++;
+
+		/* There was a problem reading the mailbox, propagate
+		 * error value.
+		 */
+		if (unlikely(ret < 0))
+			return ERR_PTR(ret);
+
+		return skb_error;
 	}
 
 	cb = can_rx_offload_get_cb(skb);
 	ret = offload->mailbox_read(offload, cf, &cb->timestamp, n);
-	if (!ret) {
+
+	/* Mailbox was empty. */
+	if (unlikely(!ret)) {
 		kfree_skb(skb);
 		return NULL;
 	}
 
+	/* There was a problem reading the mailbox, propagate error value. */
+	if (unlikely(ret < 0)) {
+		kfree_skb(skb);
+
+		offload->dev->stats.rx_dropped++;
+		offload->dev->stats.rx_fifo_errors++;
+
+		return ERR_PTR(ret);
+	}
+
+	/* Mailbox was read. */
 	return skb;
 }
 
@@ -168,7 +224,7 @@ int can_rx_offload_irq_offload_timestamp(struct can_rx_offload *offload, u64 pen
 			continue;
 
 		skb = can_rx_offload_offload_one(offload, i);
-		if (!skb)
+		if (IS_ERR_OR_NULL(skb))
 			break;
 
 		__skb_queue_add_sort(&skb_queue, skb, can_rx_offload_compare);
@@ -199,7 +255,11 @@ int can_rx_offload_irq_offload_fifo(struct can_rx_offload *offload)
 	struct sk_buff *skb;
 	int received = 0;
 
-	while ((skb = can_rx_offload_offload_one(offload, 0))) {
+	while (1) {
+		skb = can_rx_offload_offload_one(offload, 0);
+		if (IS_ERR_OR_NULL(skb))
+			break;
+
 		skb_queue_tail(&offload->skb_queue, skb);
 		received++;
 	}
-- 
2.20.1



