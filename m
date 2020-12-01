Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E9C2C9BCD
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389886AbgLAJMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:12:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389940AbgLAJMQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:12:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D8102224D;
        Tue,  1 Dec 2020 09:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813895;
        bh=vPFBtAFdA6fMp1yzGLdk7czWqLJzOKMggrq2W7MEUIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKS4TG4PrToy8gEvf0Y7aP/A2fWryD3wEb+rif2mYsefXPcqr3QephrG1krsqr1DV
         khvBVS4KdhaaSUg7sZSuDuqArdENKT3snw64goMwTNmJA+0Tnz0LTuUIXRFY/1Sf4J
         LLEsrNZ62miEAkyFogsuR2bQOQFaFyk5Ely6t1ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 096/152] s390/qeth: fix af_iucv notification race
Date:   Tue,  1 Dec 2020 09:53:31 +0100
Message-Id: <20201201084724.429272200@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 8908f36d20d8ba610d3a7d110b3049b5853b9bb1 ]

The two expected notification sequences are
1. TX_NOTIFY_PENDING with a subsequent TX_NOTIFY_DELAYED_*, when
   our TX completion code first observed the pending TX and the QAOB
   then completes at a later time; or
2. TX_NOTIFY_OK, when qeth_qdio_handle_aob() picked up the QAOB
   completion before our TX completion code even noticed that the TX
   was pending.

But as qeth_iqd_tx_complete() and qeth_qdio_handle_aob() can run
concurrently, we may end up with a race that results in a sequence of
TX_NOTIFY_DELAYED_* followed by TX_NOTIFY_PENDING. Which would confuse
the af_iucv code in its tracking of pending transmits.

Rework the notification code, so that qeth_qdio_handle_aob() defers its
notification if the TX completion code is still active.

Fixes: b333293058aa ("qeth: add support for af_iucv HiperSockets transport")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core.h      |  9 ++--
 drivers/s390/net/qeth_core_main.c | 73 ++++++++++++++++++++++---------
 2 files changed, 58 insertions(+), 24 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 6b5cf9ba03e5b..757d6ba817ee1 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -397,10 +397,13 @@ enum qeth_qdio_out_buffer_state {
 	QETH_QDIO_BUF_EMPTY,
 	/* Filled by driver; owned by hardware in order to be sent. */
 	QETH_QDIO_BUF_PRIMED,
-	/* Identified to be pending in TPQ. */
+	/* Discovered by the TX completion code: */
 	QETH_QDIO_BUF_PENDING,
-	/* Found in completion queue. */
-	QETH_QDIO_BUF_IN_CQ,
+	/* Finished by the TX completion code: */
+	QETH_QDIO_BUF_NEED_QAOB,
+	/* Received QAOB notification on CQ: */
+	QETH_QDIO_BUF_QAOB_OK,
+	QETH_QDIO_BUF_QAOB_ERROR,
 	/* Handled via transfer pending / completion queue. */
 	QETH_QDIO_BUF_HANDLED_DELAYED,
 };
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index f22e3653da52d..54a7eefe73d19 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -513,6 +513,7 @@ static void qeth_cleanup_handled_pending(struct qeth_qdio_out_q *q, int bidx,
 static void qeth_qdio_handle_aob(struct qeth_card *card,
 				 unsigned long phys_aob_addr)
 {
+	enum qeth_qdio_out_buffer_state new_state = QETH_QDIO_BUF_QAOB_OK;
 	struct qaob *aob;
 	struct qeth_qdio_out_buffer *buffer;
 	enum iucv_tx_notify notification;
@@ -524,22 +525,6 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 	buffer = (struct qeth_qdio_out_buffer *) aob->user1;
 	QETH_CARD_TEXT_(card, 5, "%lx", aob->user1);
 
-	if (atomic_cmpxchg(&buffer->state, QETH_QDIO_BUF_PRIMED,
-			   QETH_QDIO_BUF_IN_CQ) == QETH_QDIO_BUF_PRIMED) {
-		notification = TX_NOTIFY_OK;
-	} else {
-		WARN_ON_ONCE(atomic_read(&buffer->state) !=
-							QETH_QDIO_BUF_PENDING);
-		atomic_set(&buffer->state, QETH_QDIO_BUF_IN_CQ);
-		notification = TX_NOTIFY_DELAYED_OK;
-	}
-
-	if (aob->aorc != 0)  {
-		QETH_CARD_TEXT_(card, 2, "aorc%02X", aob->aorc);
-		notification = qeth_compute_cq_notification(aob->aorc, 1);
-	}
-	qeth_notify_skbs(buffer->q, buffer, notification);
-
 	/* Free dangling allocations. The attached skbs are handled by
 	 * qeth_cleanup_handled_pending().
 	 */
@@ -551,7 +536,33 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 		if (data && buffer->is_header[i])
 			kmem_cache_free(qeth_core_header_cache, data);
 	}
-	atomic_set(&buffer->state, QETH_QDIO_BUF_HANDLED_DELAYED);
+
+	if (aob->aorc) {
+		QETH_CARD_TEXT_(card, 2, "aorc%02X", aob->aorc);
+		new_state = QETH_QDIO_BUF_QAOB_ERROR;
+	}
+
+	switch (atomic_xchg(&buffer->state, new_state)) {
+	case QETH_QDIO_BUF_PRIMED:
+		/* Faster than TX completion code. */
+		notification = qeth_compute_cq_notification(aob->aorc, 0);
+		qeth_notify_skbs(buffer->q, buffer, notification);
+		atomic_set(&buffer->state, QETH_QDIO_BUF_HANDLED_DELAYED);
+		break;
+	case QETH_QDIO_BUF_PENDING:
+		/* TX completion code is active and will handle the async
+		 * completion for us.
+		 */
+		break;
+	case QETH_QDIO_BUF_NEED_QAOB:
+		/* TX completion code is already finished. */
+		notification = qeth_compute_cq_notification(aob->aorc, 1);
+		qeth_notify_skbs(buffer->q, buffer, notification);
+		atomic_set(&buffer->state, QETH_QDIO_BUF_HANDLED_DELAYED);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
 
 	qdio_release_aob(aob);
 }
@@ -1420,9 +1431,6 @@ static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error,
 	struct qeth_qdio_out_q *queue = buf->q;
 	struct sk_buff *skb;
 
-	/* release may never happen from within CQ tasklet scope */
-	WARN_ON_ONCE(atomic_read(&buf->state) == QETH_QDIO_BUF_IN_CQ);
-
 	if (atomic_read(&buf->state) == QETH_QDIO_BUF_PENDING)
 		qeth_notify_skbs(queue, buf, TX_NOTIFY_GENERALERROR);
 
@@ -5847,9 +5855,32 @@ static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
 
 		if (atomic_cmpxchg(&buffer->state, QETH_QDIO_BUF_PRIMED,
 						   QETH_QDIO_BUF_PENDING) ==
-		    QETH_QDIO_BUF_PRIMED)
+		    QETH_QDIO_BUF_PRIMED) {
 			qeth_notify_skbs(queue, buffer, TX_NOTIFY_PENDING);
 
+			/* Handle race with qeth_qdio_handle_aob(): */
+			switch (atomic_xchg(&buffer->state,
+					    QETH_QDIO_BUF_NEED_QAOB)) {
+			case QETH_QDIO_BUF_PENDING:
+				/* No concurrent QAOB notification. */
+				break;
+			case QETH_QDIO_BUF_QAOB_OK:
+				qeth_notify_skbs(queue, buffer,
+						 TX_NOTIFY_DELAYED_OK);
+				atomic_set(&buffer->state,
+					   QETH_QDIO_BUF_HANDLED_DELAYED);
+				break;
+			case QETH_QDIO_BUF_QAOB_ERROR:
+				qeth_notify_skbs(queue, buffer,
+						 TX_NOTIFY_DELAYED_GENERALERROR);
+				atomic_set(&buffer->state,
+					   QETH_QDIO_BUF_HANDLED_DELAYED);
+				break;
+			default:
+				WARN_ON_ONCE(1);
+			}
+		}
+
 		QETH_CARD_TEXT_(card, 5, "pel%u", bidx);
 
 		/* prepare the queue slot for re-use: */
-- 
2.27.0



