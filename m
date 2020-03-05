Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF5C817ACB2
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgCEROH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:14:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727502AbgCEROE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:14:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55855208CD;
        Thu,  5 Mar 2020 17:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428443;
        bh=REpsYXfZCjqkDDB8VV0pmsaiEOHyUa6o40zKlxKoOQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nAE97QvM7w/N/0PnJjEfkG/ok4C4ALes3PnZZ7T4wMgK4In4EVyV8D0GvkJGsRY4/
         n798FIa9bwfsWfIviUkZTMbvB/zFWqRgIiLVyy4ScUXyZjM0ESWywrt5SCk9BsDNdO
         jzkTuR1zDRyTE3SGtyri3erQPkwt7rimN0CXqVtY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Ewan D . Milne" <emilne@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 39/67] blk-mq: insert passthrough request into hctx->dispatch directly
Date:   Thu,  5 Mar 2020 12:12:40 -0500
Message-Id: <20200305171309.29118-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171309.29118-1-sashal@kernel.org>
References: <20200305171309.29118-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 01e99aeca3979600302913cef3f89076786f32c8 ]

For some reason, device may be in one situation which can't handle
FS request, so STS_RESOURCE is always returned and the FS request
will be added to hctx->dispatch. However passthrough request may
be required at that time for fixing the problem. If passthrough
request is added to scheduler queue, there isn't any chance for
blk-mq to dispatch it given we prioritize requests in hctx->dispatch.
Then the FS IO request may never be completed, and IO hang is caused.

So passthrough request has to be added to hctx->dispatch directly
for fixing the IO hang.

Fix this issue by inserting passthrough request into hctx->dispatch
directly together withing adding FS request to the tail of
hctx->dispatch in blk_mq_dispatch_rq_list(). Actually we add FS request
to tail of hctx->dispatch at default, see blk_mq_request_bypass_insert().

Then it becomes consistent with original legacy IO request
path, in which passthrough request is always added to q->queue_head.

Cc: Dongli Zhang <dongli.zhang@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-flush.c    |  2 +-
 block/blk-mq-sched.c | 22 +++++++++++++++-------
 block/blk-mq.c       | 18 +++++++++++-------
 block/blk-mq.h       |  3 ++-
 4 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 3f977c517960e..5cc775bdb06ac 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -412,7 +412,7 @@ void blk_insert_flush(struct request *rq)
 	 */
 	if ((policy & REQ_FSEQ_DATA) &&
 	    !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
-		blk_mq_request_bypass_insert(rq, false);
+		blk_mq_request_bypass_insert(rq, false, false);
 		return;
 	}
 
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index ca22afd47b3dc..856356b1619e8 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -361,13 +361,19 @@ static bool blk_mq_sched_bypass_insert(struct blk_mq_hw_ctx *hctx,
 				       bool has_sched,
 				       struct request *rq)
 {
-	/* dispatch flush rq directly */
-	if (rq->rq_flags & RQF_FLUSH_SEQ) {
-		spin_lock(&hctx->lock);
-		list_add(&rq->queuelist, &hctx->dispatch);
-		spin_unlock(&hctx->lock);
+	/*
+	 * dispatch flush and passthrough rq directly
+	 *
+	 * passthrough request has to be added to hctx->dispatch directly.
+	 * For some reason, device may be in one situation which can't
+	 * handle FS request, so STS_RESOURCE is always returned and the
+	 * FS request will be added to hctx->dispatch. However passthrough
+	 * request may be required at that time for fixing the problem. If
+	 * passthrough request is added to scheduler queue, there isn't any
+	 * chance to dispatch it given we prioritize requests in hctx->dispatch.
+	 */
+	if ((rq->rq_flags & RQF_FLUSH_SEQ) || blk_rq_is_passthrough(rq))
 		return true;
-	}
 
 	if (has_sched)
 		rq->rq_flags |= RQF_SORTED;
@@ -391,8 +397,10 @@ void blk_mq_sched_insert_request(struct request *rq, bool at_head,
 
 	WARN_ON(e && (rq->tag != -1));
 
-	if (blk_mq_sched_bypass_insert(hctx, !!e, rq))
+	if (blk_mq_sched_bypass_insert(hctx, !!e, rq)) {
+		blk_mq_request_bypass_insert(rq, at_head, false);
 		goto run;
+	}
 
 	if (e && e->type->ops.insert_requests) {
 		LIST_HEAD(list);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 323c9cb28066b..329df7986bf60 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -727,7 +727,7 @@ static void blk_mq_requeue_work(struct work_struct *work)
 		 * merge.
 		 */
 		if (rq->rq_flags & RQF_DONTPREP)
-			blk_mq_request_bypass_insert(rq, false);
+			blk_mq_request_bypass_insert(rq, false, false);
 		else
 			blk_mq_sched_insert_request(rq, true, false, false);
 	}
@@ -1278,7 +1278,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 			q->mq_ops->commit_rqs(hctx);
 
 		spin_lock(&hctx->lock);
-		list_splice_init(list, &hctx->dispatch);
+		list_splice_tail_init(list, &hctx->dispatch);
 		spin_unlock(&hctx->lock);
 
 		/*
@@ -1629,12 +1629,16 @@ void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
  * Should only be used carefully, when the caller knows we want to
  * bypass a potential IO scheduler on the target device.
  */
-void blk_mq_request_bypass_insert(struct request *rq, bool run_queue)
+void blk_mq_request_bypass_insert(struct request *rq, bool at_head,
+				  bool run_queue)
 {
 	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
 
 	spin_lock(&hctx->lock);
-	list_add_tail(&rq->queuelist, &hctx->dispatch);
+	if (at_head)
+		list_add(&rq->queuelist, &hctx->dispatch);
+	else
+		list_add_tail(&rq->queuelist, &hctx->dispatch);
 	spin_unlock(&hctx->lock);
 
 	if (run_queue)
@@ -1824,7 +1828,7 @@ static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 	if (bypass_insert)
 		return BLK_STS_RESOURCE;
 
-	blk_mq_request_bypass_insert(rq, run_queue);
+	blk_mq_request_bypass_insert(rq, false, run_queue);
 	return BLK_STS_OK;
 }
 
@@ -1840,7 +1844,7 @@ static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 
 	ret = __blk_mq_try_issue_directly(hctx, rq, cookie, false, true);
 	if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE)
-		blk_mq_request_bypass_insert(rq, true);
+		blk_mq_request_bypass_insert(rq, false, true);
 	else if (ret != BLK_STS_OK)
 		blk_mq_end_request(rq, ret);
 
@@ -1874,7 +1878,7 @@ void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
 		if (ret != BLK_STS_OK) {
 			if (ret == BLK_STS_RESOURCE ||
 					ret == BLK_STS_DEV_RESOURCE) {
-				blk_mq_request_bypass_insert(rq,
+				blk_mq_request_bypass_insert(rq, false,
 							list_empty(list));
 				break;
 			}
diff --git a/block/blk-mq.h b/block/blk-mq.h
index eaaca8fc1c287..c0fa34378eb2f 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -66,7 +66,8 @@ int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
  */
 void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 				bool at_head);
-void blk_mq_request_bypass_insert(struct request *rq, bool run_queue);
+void blk_mq_request_bypass_insert(struct request *rq, bool at_head,
+				  bool run_queue);
 void blk_mq_insert_requests(struct blk_mq_hw_ctx *hctx, struct blk_mq_ctx *ctx,
 				struct list_head *list);
 
-- 
2.20.1

