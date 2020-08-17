Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDE624758F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732001AbgHQTZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:25:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730424AbgHQPeR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:34:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F9CC233A0;
        Mon, 17 Aug 2020 15:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678457;
        bh=TCCSz+S+U5IHwb6xshIPEPPiqhskPjSrLxVfgqd7zAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbPlyvjqsehqCPvxWC8s/gXzoYDICYr+XK98l8aYIVPKwCwteuqOOGUu/XLGdtHve
         VqJCXJOh4IXpuxsXTIDWknqNg5WuNSSeAdPrHRkh+J33Qwq5AfvvNv5y3f/IMCFdHf
         LxWVlLUj1LSTqpDW73zJ1w1kOrVdm9asMWRah8VY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 340/464] s390/qeth: tolerate pre-filled RX buffer
Date:   Mon, 17 Aug 2020 17:14:53 +0200
Message-Id: <20200817143850.060957102@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit eff73e16ee116f6eafa2be48fab42659a27cb453 ]

When preparing a buffer for RX refill, tolerate that it already has a
pool_entry attached. Otherwise we could easily leak such a pool_entry
when re-driving the RX refill after an error (from eg. do_qdio()).

This needs some minor adjustment in the code that drains RX buffer(s)
prior to RX refill and during teardown, so that ->pool_entry is NULLed
accordingly.

Fixes: 4a71df50047f ("qeth: new qeth device driver")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_main.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 88e998de2d032..c8e57007c4238 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -204,12 +204,17 @@ EXPORT_SYMBOL_GPL(qeth_threads_running);
 void qeth_clear_working_pool_list(struct qeth_card *card)
 {
 	struct qeth_buffer_pool_entry *pool_entry, *tmp;
+	struct qeth_qdio_q *queue = card->qdio.in_q;
+	unsigned int i;
 
 	QETH_CARD_TEXT(card, 5, "clwrklst");
 	list_for_each_entry_safe(pool_entry, tmp,
 			    &card->qdio.in_buf_pool.entry_list, list){
 			list_del(&pool_entry->list);
 	}
+
+	for (i = 0; i < ARRAY_SIZE(queue->bufs); i++)
+		queue->bufs[i].pool_entry = NULL;
 }
 EXPORT_SYMBOL_GPL(qeth_clear_working_pool_list);
 
@@ -2951,7 +2956,7 @@ static struct qeth_buffer_pool_entry *qeth_find_free_buffer_pool_entry(
 static int qeth_init_input_buffer(struct qeth_card *card,
 		struct qeth_qdio_buffer *buf)
 {
-	struct qeth_buffer_pool_entry *pool_entry;
+	struct qeth_buffer_pool_entry *pool_entry = buf->pool_entry;
 	int i;
 
 	if ((card->options.cq == QETH_CQ_ENABLED) && (!buf->rx_skb)) {
@@ -2962,9 +2967,13 @@ static int qeth_init_input_buffer(struct qeth_card *card,
 			return -ENOMEM;
 	}
 
-	pool_entry = qeth_find_free_buffer_pool_entry(card);
-	if (!pool_entry)
-		return -ENOBUFS;
+	if (!pool_entry) {
+		pool_entry = qeth_find_free_buffer_pool_entry(card);
+		if (!pool_entry)
+			return -ENOBUFS;
+
+		buf->pool_entry = pool_entry;
+	}
 
 	/*
 	 * since the buffer is accessed only from the input_tasklet
@@ -2972,8 +2981,6 @@ static int qeth_init_input_buffer(struct qeth_card *card,
 	 * the QETH_IN_BUF_REQUEUE_THRESHOLD we should never run  out off
 	 * buffers
 	 */
-
-	buf->pool_entry = pool_entry;
 	for (i = 0; i < QETH_MAX_BUFFER_ELEMENTS(card); ++i) {
 		buf->buffer->element[i].length = PAGE_SIZE;
 		buf->buffer->element[i].addr =
@@ -5802,6 +5809,7 @@ static unsigned int qeth_rx_poll(struct qeth_card *card, int budget)
 		if (done) {
 			QETH_CARD_STAT_INC(card, rx_bufs);
 			qeth_put_buffer_pool_entry(card, buffer->pool_entry);
+			buffer->pool_entry = NULL;
 			qeth_queue_input_buffer(card, card->rx.b_index);
 			card->rx.b_count--;
 
-- 
2.25.1



