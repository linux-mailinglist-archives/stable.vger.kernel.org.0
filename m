Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438C633B6FC
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbhCON7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232299AbhCON6W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 874E364F0D;
        Mon, 15 Mar 2021 13:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816699;
        bh=etdHtidwxzljVrBeF2zHsYOYnaLL7Kn+/lR3nWja0VE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+Djd9pGQlVlFQhZ5HCKYFzVMk1Tcog4fV1vgG5K8nks3XA2C+0ulSgp7vXC3NYdU
         YbMo5fwrx5vTsFwb6/lhi1ygdPPIWO76catM3+ljQfLJH9V9NqAPywi2iU0q7hzexk
         5/9Kgg2w3WfCxc/KIMCJeojpp4tNx7X/YCvU93CE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 072/306] s390/qeth: fix memory leak after failed TX Buffer allocation
Date:   Mon, 15 Mar 2021 14:52:15 +0100
Message-Id: <20210315135510.076202367@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Julian Wiedmann <jwi@linux.ibm.com>

commit e7a36d27f6b9f389e41d8189a8a08919c6835732 upstream.

When qeth_alloc_qdio_queues() fails to allocate one of the buffers that
back an Output Queue, the 'out_freeoutqbufs' path will free all
previously allocated buffers for this queue. But it misses to free the
half-finished queue struct itself.

Move the buffer allocation into qeth_alloc_output_queue(), and deal with
such errors internally.

Fixes: 0da9581ddb0f ("qeth: exploit asynchronous delivery of storage blocks")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/net/qeth_core_main.c |   35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2630,15 +2630,28 @@ static void qeth_free_output_queue(struc
 static struct qeth_qdio_out_q *qeth_alloc_output_queue(void)
 {
 	struct qeth_qdio_out_q *q = kzalloc(sizeof(*q), GFP_KERNEL);
+	unsigned int i;
 
 	if (!q)
 		return NULL;
 
-	if (qdio_alloc_buffers(q->qdio_bufs, QDIO_MAX_BUFFERS_PER_Q)) {
-		kfree(q);
-		return NULL;
+	if (qdio_alloc_buffers(q->qdio_bufs, QDIO_MAX_BUFFERS_PER_Q))
+		goto err_qdio_bufs;
+
+	for (i = 0; i < QDIO_MAX_BUFFERS_PER_Q; i++) {
+		if (qeth_init_qdio_out_buf(q, i))
+			goto err_out_bufs;
 	}
+
 	return q;
+
+err_out_bufs:
+	while (i > 0)
+		kmem_cache_free(qeth_qdio_outbuf_cache, q->bufs[--i]);
+	qdio_free_buffers(q->qdio_bufs, QDIO_MAX_BUFFERS_PER_Q);
+err_qdio_bufs:
+	kfree(q);
+	return NULL;
 }
 
 static void qeth_tx_completion_timer(struct timer_list *timer)
@@ -2651,7 +2664,7 @@ static void qeth_tx_completion_timer(str
 
 static int qeth_alloc_qdio_queues(struct qeth_card *card)
 {
-	int i, j;
+	unsigned int i;
 
 	QETH_CARD_TEXT(card, 2, "allcqdbf");
 
@@ -2685,13 +2698,6 @@ static int qeth_alloc_qdio_queues(struct
 		queue->coalesce_usecs = QETH_TX_COALESCE_USECS;
 		queue->max_coalesced_frames = QETH_TX_MAX_COALESCED_FRAMES;
 		queue->priority = QETH_QIB_PQUE_PRIO_DEFAULT;
-
-		/* give outbound qeth_qdio_buffers their qdio_buffers */
-		for (j = 0; j < QDIO_MAX_BUFFERS_PER_Q; ++j) {
-			WARN_ON(queue->bufs[j]);
-			if (qeth_init_qdio_out_buf(queue, j))
-				goto out_freeoutqbufs;
-		}
 	}
 
 	/* completion */
@@ -2700,13 +2706,6 @@ static int qeth_alloc_qdio_queues(struct
 
 	return 0;
 
-out_freeoutqbufs:
-	while (j > 0) {
-		--j;
-		kmem_cache_free(qeth_qdio_outbuf_cache,
-				card->qdio.out_qs[i]->bufs[j]);
-		card->qdio.out_qs[i]->bufs[j] = NULL;
-	}
 out_freeoutq:
 	while (i > 0) {
 		qeth_free_output_queue(card->qdio.out_qs[--i]);


