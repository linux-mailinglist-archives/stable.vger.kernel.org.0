Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B373D3BBF02
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhGEPbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:31:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231948AbhGEPbK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:31:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C25E6198D;
        Mon,  5 Jul 2021 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498913;
        bh=EjbbdsphNaBY7zK3O0JjVNY2MvwcLT3oI7pQ/TJbDWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cc79c67LejdcmyZx/JhWlg1E44UMsy67D+ARNPaGxBoYVkomizIc2lQReS77v0CLY
         RySpfG3C+pv6k0J6VygSjapFqbKoNLeK0Awr3lqWb/6sCW57omcqzwLU0Y4gGgYefD
         LSCcOYEDtHDMTEUJVatDoaBszF8pR9/K9T5hvip1waelHfZlDe/wgDTA0QdpBPpPO9
         gPMJK+cLpT8/xonPey1PqSKkejS7D/8P4S5fpiHVNNPm6OsFBIJ1ULAlaS2WVB1Y7w
         qvveNR/oQqvDrbqvkqzXJXop1ybQfie/ggUkZFCaYVBaFoVzy6U9F7SN4KBynpc/Qz
         fOUjXNeJZHzbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, John Garry <john.garry@huawei.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 13/59] blk-mq: grab rq->refcount before calling ->fn in blk_mq_tagset_busy_iter
Date:   Mon,  5 Jul 2021 11:27:29 -0400
Message-Id: <20210705152815.1520546-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152815.1520546-1-sashal@kernel.org>
References: <20210705152815.1520546-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 2e315dc07df009c3e29d6926871f62a30cfae394 ]

Grab rq->refcount before calling ->fn in blk_mq_tagset_busy_iter(), and
this way will prevent the request from being re-used when ->fn is
running. The approach is same as what we do during handling timeout.

Fix request use-after-free(UAF) related with completion race or queue
releasing:

- If one rq is referred before rq->q is frozen, then queue won't be
frozen before the request is released during iteration.

- If one rq is referred after rq->q is frozen, refcount_inc_not_zero()
will return false, and we won't iterate over this request.

However, still one request UAF not covered: refcount_inc_not_zero() may
read one freed request, and it will be handled in next patch.

Tested-by: John Garry <john.garry@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20210511152236.763464-3-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-tag.c | 44 +++++++++++++++++++++++++++++++++-----------
 block/blk-mq.c     | 14 +++++++++-----
 block/blk-mq.h     |  1 +
 3 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 2a37731e8244..544edf2c56a5 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -199,6 +199,16 @@ struct bt_iter_data {
 	bool reserved;
 };
 
+static struct request *blk_mq_find_and_get_req(struct blk_mq_tags *tags,
+		unsigned int bitnr)
+{
+	struct request *rq = tags->rqs[bitnr];
+
+	if (!rq || !refcount_inc_not_zero(&rq->ref))
+		return NULL;
+	return rq;
+}
+
 static bool bt_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
 {
 	struct bt_iter_data *iter_data = data;
@@ -206,18 +216,22 @@ static bool bt_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
 	struct blk_mq_tags *tags = hctx->tags;
 	bool reserved = iter_data->reserved;
 	struct request *rq;
+	bool ret = true;
 
 	if (!reserved)
 		bitnr += tags->nr_reserved_tags;
-	rq = tags->rqs[bitnr];
-
 	/*
 	 * We can hit rq == NULL here, because the tagging functions
 	 * test and set the bit before assigning ->rqs[].
 	 */
-	if (rq && rq->q == hctx->queue && rq->mq_hctx == hctx)
-		return iter_data->fn(hctx, rq, iter_data->data, reserved);
-	return true;
+	rq = blk_mq_find_and_get_req(tags, bitnr);
+	if (!rq)
+		return true;
+
+	if (rq->q == hctx->queue && rq->mq_hctx == hctx)
+		ret = iter_data->fn(hctx, rq, iter_data->data, reserved);
+	blk_mq_put_rq_ref(rq);
+	return ret;
 }
 
 /**
@@ -264,6 +278,8 @@ static bool bt_tags_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
 	struct blk_mq_tags *tags = iter_data->tags;
 	bool reserved = iter_data->flags & BT_TAG_ITER_RESERVED;
 	struct request *rq;
+	bool ret = true;
+	bool iter_static_rqs = !!(iter_data->flags & BT_TAG_ITER_STATIC_RQS);
 
 	if (!reserved)
 		bitnr += tags->nr_reserved_tags;
@@ -272,16 +288,19 @@ static bool bt_tags_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
 	 * We can hit rq == NULL here, because the tagging functions
 	 * test and set the bit before assigning ->rqs[].
 	 */
-	if (iter_data->flags & BT_TAG_ITER_STATIC_RQS)
+	if (iter_static_rqs)
 		rq = tags->static_rqs[bitnr];
 	else
-		rq = tags->rqs[bitnr];
+		rq = blk_mq_find_and_get_req(tags, bitnr);
 	if (!rq)
 		return true;
-	if ((iter_data->flags & BT_TAG_ITER_STARTED) &&
-	    !blk_mq_request_started(rq))
-		return true;
-	return iter_data->fn(rq, iter_data->data, reserved);
+
+	if (!(iter_data->flags & BT_TAG_ITER_STARTED) ||
+	    blk_mq_request_started(rq))
+		ret = iter_data->fn(rq, iter_data->data, reserved);
+	if (!iter_static_rqs)
+		blk_mq_put_rq_ref(rq);
+	return ret;
 }
 
 /**
@@ -348,6 +367,9 @@ void blk_mq_all_tag_iter(struct blk_mq_tags *tags, busy_tag_iter_fn *fn,
  *		indicates whether or not @rq is a reserved request. Return
  *		true to continue iterating tags, false to stop.
  * @priv:	Will be passed as second argument to @fn.
+ *
+ * We grab one request reference before calling @fn and release it after
+ * @fn returns.
  */
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		busy_tag_iter_fn *fn, void *priv)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index c86c01bfecdb..debfa5cd8025 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -909,6 +909,14 @@ static bool blk_mq_req_expired(struct request *rq, unsigned long *next)
 	return false;
 }
 
+void blk_mq_put_rq_ref(struct request *rq)
+{
+	if (is_flush_rq(rq, rq->mq_hctx))
+		rq->end_io(rq, 0);
+	else if (refcount_dec_and_test(&rq->ref))
+		__blk_mq_free_request(rq);
+}
+
 static bool blk_mq_check_expired(struct blk_mq_hw_ctx *hctx,
 		struct request *rq, void *priv, bool reserved)
 {
@@ -942,11 +950,7 @@ static bool blk_mq_check_expired(struct blk_mq_hw_ctx *hctx,
 	if (blk_mq_req_expired(rq, next))
 		blk_mq_rq_timed_out(rq, reserved);
 
-	if (is_flush_rq(rq, hctx))
-		rq->end_io(rq, 0);
-	else if (refcount_dec_and_test(&rq->ref))
-		__blk_mq_free_request(rq);
-
+	blk_mq_put_rq_ref(rq);
 	return true;
 }
 
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 9ce64bc4a6c8..556368d2c5b6 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -47,6 +47,7 @@ void blk_mq_add_to_requeue_list(struct request *rq, bool at_head,
 void blk_mq_flush_busy_ctxs(struct blk_mq_hw_ctx *hctx, struct list_head *list);
 struct request *blk_mq_dequeue_from_ctx(struct blk_mq_hw_ctx *hctx,
 					struct blk_mq_ctx *start);
+void blk_mq_put_rq_ref(struct request *rq);
 
 /*
  * Internal helpers for allocating/freeing the request map
-- 
2.30.2

