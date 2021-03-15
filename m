Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324D233B877
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhCOODe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232796AbhCON74 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04E9A64F0F;
        Mon, 15 Mar 2021 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816778;
        bh=qYSZhbsdiszQduk0+BNPrbuG2cow5pgdsdbLws3nUHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nc8fJGqFruDfMvLVU8xyaw9lvbLoegnakebtivQtSZxWOVfLPv9MEU7O0zitqrs3a
         VV2FkZsKgcENOntUiUlxGrD+NhXSgx6hBE6JI0WaAr92GHSc+VRTvGgS0d0MkfXhEe
         OCHCm0fzE1RP//kxW9wm7vd4WRqdhxWjAbcQDPiY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/290] s390/qeth: dont replace a fully completed async TX buffer
Date:   Mon, 15 Mar 2021 14:53:22 +0100
Message-Id: <20210315135545.589676142@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit db4ffdcef7c9a842e55228c9faef7abf8b72382f ]

For TX buffers that require an additional async notification via QAOB, the
TX completion code can now manage all the necessary processing if the
notification has already occurred (or is occurring concurrently).

In such cases we can avoid replacing the metadata that is associated
with the buffer's slot on the ring, and just keep using the current one.

As qeth_clear_output_buffer() will also handle any kmem cache-allocated
memory that was mapped into the TX buffer, qeth_qdio_handle_aob()
doesn't need to worry about it.

While at it, also remove the unneeded forward declaration for
qeth_init_qdio_out_buf().

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_main.c | 89 ++++++++++++++++++-------------
 1 file changed, 51 insertions(+), 38 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 77cd714978bd..78a866424022 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -75,7 +75,6 @@ static void qeth_notify_skbs(struct qeth_qdio_out_q *queue,
 		enum iucv_tx_notify notification);
 static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error,
 				 int budget);
-static int qeth_init_qdio_out_buf(struct qeth_qdio_out_q *, int);
 
 static void qeth_close_dev_handler(struct work_struct *work)
 {
@@ -517,18 +516,6 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 	buffer = (struct qeth_qdio_out_buffer *) aob->user1;
 	QETH_CARD_TEXT_(card, 5, "%lx", aob->user1);
 
-	/* Free dangling allocations. The attached skbs are handled by
-	 * qeth_cleanup_handled_pending().
-	 */
-	for (i = 0;
-	     i < aob->sb_count && i < QETH_MAX_BUFFER_ELEMENTS(card);
-	     i++) {
-		void *data = phys_to_virt(aob->sba[i]);
-
-		if (data && buffer->is_header[i])
-			kmem_cache_free(qeth_core_header_cache, data);
-	}
-
 	if (aob->aorc) {
 		QETH_CARD_TEXT_(card, 2, "aorc%02X", aob->aorc);
 		new_state = QETH_QDIO_BUF_QAOB_ERROR;
@@ -536,10 +523,9 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 
 	switch (atomic_xchg(&buffer->state, new_state)) {
 	case QETH_QDIO_BUF_PRIMED:
-		/* Faster than TX completion code. */
-		notification = qeth_compute_cq_notification(aob->aorc, 0);
-		qeth_notify_skbs(buffer->q, buffer, notification);
-		atomic_set(&buffer->state, QETH_QDIO_BUF_HANDLED_DELAYED);
+		/* Faster than TX completion code, let it handle the async
+		 * completion for us.
+		 */
 		break;
 	case QETH_QDIO_BUF_PENDING:
 		/* TX completion code is active and will handle the async
@@ -550,6 +536,19 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 		/* TX completion code is already finished. */
 		notification = qeth_compute_cq_notification(aob->aorc, 1);
 		qeth_notify_skbs(buffer->q, buffer, notification);
+
+		/* Free dangling allocations. The attached skbs are handled by
+		 * qeth_cleanup_handled_pending().
+		 */
+		for (i = 0;
+		     i < aob->sb_count && i < QETH_MAX_BUFFER_ELEMENTS(card);
+		     i++) {
+			void *data = phys_to_virt(aob->sba[i]);
+
+			if (data && buffer->is_header[i])
+				kmem_cache_free(qeth_core_header_cache, data);
+		}
+
 		atomic_set(&buffer->state, QETH_QDIO_BUF_HANDLED_DELAYED);
 		break;
 	default:
@@ -5870,9 +5869,13 @@ static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
 				 QDIO_OUTBUF_STATE_FLAG_PENDING)) {
 		WARN_ON_ONCE(card->options.cq != QETH_CQ_ENABLED);
 
-		if (atomic_cmpxchg(&buffer->state, QETH_QDIO_BUF_PRIMED,
-						   QETH_QDIO_BUF_PENDING) ==
-		    QETH_QDIO_BUF_PRIMED) {
+		QETH_CARD_TEXT_(card, 5, "pel%u", bidx);
+
+		switch (atomic_cmpxchg(&buffer->state,
+				       QETH_QDIO_BUF_PRIMED,
+				       QETH_QDIO_BUF_PENDING)) {
+		case QETH_QDIO_BUF_PRIMED:
+			/* We have initial ownership, no QAOB (yet): */
 			qeth_notify_skbs(queue, buffer, TX_NOTIFY_PENDING);
 
 			/* Handle race with qeth_qdio_handle_aob(): */
@@ -5880,39 +5883,49 @@ static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
 					    QETH_QDIO_BUF_NEED_QAOB)) {
 			case QETH_QDIO_BUF_PENDING:
 				/* No concurrent QAOB notification. */
-				break;
+
+				/* Prepare the queue slot for immediate re-use: */
+				qeth_scrub_qdio_buffer(buffer->buffer, queue->max_elements);
+				if (qeth_init_qdio_out_buf(queue, bidx)) {
+					QETH_CARD_TEXT(card, 2, "outofbuf");
+					qeth_schedule_recovery(card);
+				}
+
+				/* Skip clearing the buffer: */
+				return;
 			case QETH_QDIO_BUF_QAOB_OK:
 				qeth_notify_skbs(queue, buffer,
 						 TX_NOTIFY_DELAYED_OK);
-				atomic_set(&buffer->state,
-					   QETH_QDIO_BUF_HANDLED_DELAYED);
+				error = false;
 				break;
 			case QETH_QDIO_BUF_QAOB_ERROR:
 				qeth_notify_skbs(queue, buffer,
 						 TX_NOTIFY_DELAYED_GENERALERROR);
-				atomic_set(&buffer->state,
-					   QETH_QDIO_BUF_HANDLED_DELAYED);
+				error = true;
 				break;
 			default:
 				WARN_ON_ONCE(1);
 			}
-		}
-
-		QETH_CARD_TEXT_(card, 5, "pel%u", bidx);
 
-		/* prepare the queue slot for re-use: */
-		qeth_scrub_qdio_buffer(buffer->buffer, queue->max_elements);
-		if (qeth_init_qdio_out_buf(queue, bidx)) {
-			QETH_CARD_TEXT(card, 2, "outofbuf");
-			qeth_schedule_recovery(card);
+			break;
+		case QETH_QDIO_BUF_QAOB_OK:
+			/* qeth_qdio_handle_aob() already received a QAOB: */
+			qeth_notify_skbs(queue, buffer, TX_NOTIFY_OK);
+			error = false;
+			break;
+		case QETH_QDIO_BUF_QAOB_ERROR:
+			/* qeth_qdio_handle_aob() already received a QAOB: */
+			qeth_notify_skbs(queue, buffer, TX_NOTIFY_GENERALERROR);
+			error = true;
+			break;
+		default:
+			WARN_ON_ONCE(1);
 		}
-
-		return;
-	}
-
-	if (card->options.cq == QETH_CQ_ENABLED)
+	} else if (card->options.cq == QETH_CQ_ENABLED) {
 		qeth_notify_skbs(queue, buffer,
 				 qeth_compute_cq_notification(sflags, 0));
+	}
+
 	qeth_clear_output_buffer(queue, buffer, error, budget);
 }
 
-- 
2.30.1



