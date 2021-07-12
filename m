Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096AE3C4CD2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241695AbhGLHI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:08:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236498AbhGLHGr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:06:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D48161107;
        Mon, 12 Jul 2021 07:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073438;
        bh=98+jKPDsx6gzzkBz0KUhIUzMLy6eHcgKkYIruxvOOT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BWgxw7zj6erQkJOZIhGOWA5J1khZr2+TO9aEZZ4MNF8OBKtlgzdnzCFt7dMPn6zGE
         DC88ZCuwtvTsFU8zy/LGw5qh4jEnZfaUlxHfiUd1q440+ANzC+37VAkZKp39FideMV
         xwvFYx1XOCDDNjM2tV5O0RTD29eVTyZSvpjAUTS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Valente <paolo.valente@linaro.org>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 241/700] bfq: Remove merged request already in bfq_requests_merged()
Date:   Mon, 12 Jul 2021 08:05:24 +0200
Message-Id: <20210712061001.040383116@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit a921c655f2033dd1ce1379128efe881dda23ea37 ]

Currently, bfq does very little in bfq_requests_merged() and handles all
the request cleanup in bfq_finish_requeue_request() called from
blk_mq_free_request(). That is currently safe only because
blk_mq_free_request() is called shortly after bfq_requests_merged()
while bfqd->lock is still held. However to fix a lock inversion between
bfqd->lock and ioc->lock, we need to call blk_mq_free_request() after
dropping bfqd->lock. That would mean that already merged request could
be seen by other processes inside bfq queues and possibly dispatched to
the device which is wrong. So move cleanup of the request from
bfq_finish_requeue_request() to bfq_requests_merged().

Acked-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210623093634.27879-2-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 41 +++++++++++++----------------------------
 1 file changed, 13 insertions(+), 28 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index bc319931d2b3..9a180c4b9605 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2376,7 +2376,7 @@ static void bfq_requests_merged(struct request_queue *q, struct request *rq,
 		*next_bfqq = bfq_init_rq(next);
 
 	if (!bfqq)
-		return;
+		goto remove;
 
 	/*
 	 * If next and rq belong to the same bfq_queue and next is older
@@ -2399,6 +2399,14 @@ static void bfq_requests_merged(struct request_queue *q, struct request *rq,
 		bfqq->next_rq = rq;
 
 	bfqg_stats_update_io_merged(bfqq_group(bfqq), next->cmd_flags);
+remove:
+	/* Merged request may be in the IO scheduler. Remove it. */
+	if (!RB_EMPTY_NODE(&next->rb_node)) {
+		bfq_remove_request(next->q, next);
+		if (next_bfqq)
+			bfqg_stats_update_io_remove(bfqq_group(next_bfqq),
+						    next->cmd_flags);
+	}
 }
 
 /* Must be called with bfqq != NULL */
@@ -6015,6 +6023,7 @@ static void bfq_finish_requeue_request(struct request *rq)
 {
 	struct bfq_queue *bfqq = RQ_BFQQ(rq);
 	struct bfq_data *bfqd;
+	unsigned long flags;
 
 	/*
 	 * rq either is not associated with any icq, or is an already
@@ -6032,39 +6041,15 @@ static void bfq_finish_requeue_request(struct request *rq)
 					     rq->io_start_time_ns,
 					     rq->cmd_flags);
 
+	spin_lock_irqsave(&bfqd->lock, flags);
 	if (likely(rq->rq_flags & RQF_STARTED)) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&bfqd->lock, flags);
-
 		if (rq == bfqd->waited_rq)
 			bfq_update_inject_limit(bfqd, bfqq);
 
 		bfq_completed_request(bfqq, bfqd);
-		bfq_finish_requeue_request_body(bfqq);
-
-		spin_unlock_irqrestore(&bfqd->lock, flags);
-	} else {
-		/*
-		 * Request rq may be still/already in the scheduler,
-		 * in which case we need to remove it (this should
-		 * never happen in case of requeue). And we cannot
-		 * defer such a check and removal, to avoid
-		 * inconsistencies in the time interval from the end
-		 * of this function to the start of the deferred work.
-		 * This situation seems to occur only in process
-		 * context, as a consequence of a merge. In the
-		 * current version of the code, this implies that the
-		 * lock is held.
-		 */
-
-		if (!RB_EMPTY_NODE(&rq->rb_node)) {
-			bfq_remove_request(rq->q, rq);
-			bfqg_stats_update_io_remove(bfqq_group(bfqq),
-						    rq->cmd_flags);
-		}
-		bfq_finish_requeue_request_body(bfqq);
 	}
+	bfq_finish_requeue_request_body(bfqq);
+	spin_unlock_irqrestore(&bfqd->lock, flags);
 
 	/*
 	 * Reset private fields. In case of a requeue, this allows
-- 
2.30.2



