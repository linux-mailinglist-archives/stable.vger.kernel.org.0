Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2723A49A428
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371239AbiAYAHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2365349AbiAXXuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:50:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8BCC0FE69D;
        Mon, 24 Jan 2022 13:44:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56EAAB812A8;
        Mon, 24 Jan 2022 21:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A5FC340E4;
        Mon, 24 Jan 2022 21:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060672;
        bh=KDHPJEHAYeXSMpSHwjV/lw8lFBlxY4PWJ6Lx4gorkLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fr2fn9SmZglpruVbetn7C52DmqVblRKDVIO9takNaKDPKezCivR1FOrikm6yWzNYv
         4QGKreh8wnXM1mnvu4qNv+gdbKrzEOePbJQXP6/iYpCgmIZgvBEw/opsuQDJkLbJtn
         qmzQa/cg/VowC3vIA/2BnWtdbH+bzf9FWfb4ajFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Laibin Qiu <qiulaibin@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 1026/1039] blk-mq: fix tag_get wait task cant be awakened
Date:   Mon, 24 Jan 2022 19:46:55 +0100
Message-Id: <20220124184159.785093232@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laibin Qiu <qiulaibin@huawei.com>

commit 180dccb0dba4f5e84a4a70c1be1d34cbb6528b32 upstream.

In case of shared tags, there might be more than one hctx which
allocates from the same tags, and each hctx is limited to allocate at
most:
        hctx_max_depth = max((bt->sb.depth + users - 1) / users, 4U);

tag idle detection is lazy, and may be delayed for 30sec, so there
could be just one real active hctx(queue) but all others are actually
idle and still accounted as active because of the lazy idle detection.
Then if wake_batch is > hctx_max_depth, driver tag allocation may wait
forever on this real active hctx.

Fix this by recalculating wake_batch when inc or dec active_queues.

Fixes: 0d2602ca30e41 ("blk-mq: improve support for shared tags maps")
Suggested-by: Ming Lei <ming.lei@redhat.com>
Suggested-by: John Garry <john.garry@huawei.com>
Signed-off-by: Laibin Qiu <qiulaibin@huawei.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220113025536.1479653-1-qiulaibin@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq-tag.c      |   40 +++++++++++++++++++++++++++++++++-------
 include/linux/sbitmap.h |   11 +++++++++++
 lib/sbitmap.c           |   25 ++++++++++++++++++++++---
 3 files changed, 66 insertions(+), 10 deletions(-)

--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -17,6 +17,21 @@
 #include "blk-mq-tag.h"
 
 /*
+ * Recalculate wakeup batch when tag is shared by hctx.
+ */
+static void blk_mq_update_wake_batch(struct blk_mq_tags *tags,
+		unsigned int users)
+{
+	if (!users)
+		return;
+
+	sbitmap_queue_recalculate_wake_batch(&tags->bitmap_tags,
+			users);
+	sbitmap_queue_recalculate_wake_batch(&tags->breserved_tags,
+			users);
+}
+
+/*
  * If a previously inactive queue goes active, bump the active user count.
  * We need to do this before try to allocate driver tag, then even if fail
  * to get tag when first time, the other shared-tag users could reserve
@@ -24,18 +39,26 @@
  */
 bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
 {
+	unsigned int users;
+
 	if (blk_mq_is_shared_tags(hctx->flags)) {
 		struct request_queue *q = hctx->queue;
 
-		if (!test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags) &&
-		    !test_and_set_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags))
-			atomic_inc(&hctx->tags->active_queues);
+		if (test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags) ||
+		    test_and_set_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags)) {
+			return true;
+		}
 	} else {
-		if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
-		    !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
-			atomic_inc(&hctx->tags->active_queues);
+		if (test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) ||
+		    test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state)) {
+			return true;
+		}
 	}
 
+	users = atomic_inc_return(&hctx->tags->active_queues);
+
+	blk_mq_update_wake_batch(hctx->tags, users);
+
 	return true;
 }
 
@@ -56,6 +79,7 @@ void blk_mq_tag_wakeup_all(struct blk_mq
 void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
 {
 	struct blk_mq_tags *tags = hctx->tags;
+	unsigned int users;
 
 	if (blk_mq_is_shared_tags(hctx->flags)) {
 		struct request_queue *q = hctx->queue;
@@ -68,7 +92,9 @@ void __blk_mq_tag_idle(struct blk_mq_hw_
 			return;
 	}
 
-	atomic_dec(&tags->active_queues);
+	users = atomic_dec_return(&tags->active_queues);
+
+	blk_mq_update_wake_batch(tags, users);
 
 	blk_mq_tag_wakeup_all(tags, false);
 }
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -416,6 +416,17 @@ static inline void sbitmap_queue_free(st
 }
 
 /**
+ * sbitmap_queue_recalculate_wake_batch() - Recalculate wake batch
+ * @sbq: Bitmap queue to recalculate wake batch.
+ * @users: Number of shares.
+ *
+ * Like sbitmap_queue_update_wake_batch(), this will calculate wake batch
+ * by depth. This interface is for HCTX shared tags or queue shared tags.
+ */
+void sbitmap_queue_recalculate_wake_batch(struct sbitmap_queue *sbq,
+					    unsigned int users);
+
+/**
  * sbitmap_queue_resize() - Resize a &struct sbitmap_queue.
  * @sbq: Bitmap queue to resize.
  * @depth: New number of bits to resize to.
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -457,10 +457,9 @@ int sbitmap_queue_init_node(struct sbitm
 }
 EXPORT_SYMBOL_GPL(sbitmap_queue_init_node);
 
-static void sbitmap_queue_update_wake_batch(struct sbitmap_queue *sbq,
-					    unsigned int depth)
+static inline void __sbitmap_queue_update_wake_batch(struct sbitmap_queue *sbq,
+					    unsigned int wake_batch)
 {
-	unsigned int wake_batch = sbq_calc_wake_batch(sbq, depth);
 	int i;
 
 	if (sbq->wake_batch != wake_batch) {
@@ -476,6 +475,26 @@ static void sbitmap_queue_update_wake_ba
 	}
 }
 
+static void sbitmap_queue_update_wake_batch(struct sbitmap_queue *sbq,
+					    unsigned int depth)
+{
+	unsigned int wake_batch;
+
+	wake_batch = sbq_calc_wake_batch(sbq, depth);
+	__sbitmap_queue_update_wake_batch(sbq, wake_batch);
+}
+
+void sbitmap_queue_recalculate_wake_batch(struct sbitmap_queue *sbq,
+					    unsigned int users)
+{
+	unsigned int wake_batch;
+
+	wake_batch = clamp_val((sbq->sb.depth + users - 1) /
+			users, 4, SBQ_WAKE_BATCH);
+	__sbitmap_queue_update_wake_batch(sbq, wake_batch);
+}
+EXPORT_SYMBOL_GPL(sbitmap_queue_recalculate_wake_batch);
+
 void sbitmap_queue_resize(struct sbitmap_queue *sbq, unsigned int depth)
 {
 	sbitmap_queue_update_wake_batch(sbq, depth);


