Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97C4B1A2CA
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 20:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbfEJSDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 14:03:23 -0400
Received: from mx.ewheeler.net ([66.155.3.69]:53094 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727709AbfEJSDX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 May 2019 14:03:23 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 May 2019 14:03:22 EDT
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 6279AA0692;
        Fri, 10 May 2019 17:56:53 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id KZQof3t99O87; Fri, 10 May 2019 17:56:52 +0000 (UTC)
Received: from el7-dev.ewi (unknown [209.180.175.76])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 359B3A067D;
        Fri, 10 May 2019 17:56:52 +0000 (UTC)
From:   Eric Wheeler <stable@lists.ewheeler.net>
To:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org (open list:BFQ I/O SCHEDULER),
        linux-kernel@vger.kernel.org (open list)
Cc:     Eric Wheeler <bfq@linux.ewheeler.net>, stable@vger.kernel.org
Subject: [PATCH] bfq: backport: update internal depth state when queue depth changes
Date:   Fri, 10 May 2019 10:56:32 -0700
Message-Id: <1557510992-18506-1-git-send-email-stable@lists.ewheeler.net>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 77f1e0a52d26242b6c2dba019f6ebebfb9ff701e upstream

A previous commit moved the shallow depth and BFQ depth map calculations
to be done at init time, moving it outside of the hotter IO path. This
potentially causes hangs if the users changes the depth of the scheduler
map, by writing to the 'nr_requests' sysfs file for that device.

Add a blk-mq-sched hook that allows blk-mq to inform the scheduler if
the depth changes, so that the scheduler can update its internal state.

Signed-off-by: Eric Wheeler <bfq@linux.ewheeler.net>
Tested-by: Kai Krakow <kai@kaishome.de>
Reported-by: Paolo Valente <paolo.valente@linaro.org>
Fixes: f0635b8a416e ("bfq: calculate shallow depths at init time")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: stable@vger.kernel.org
---
 block/bfq-iosched.c      | 8 +++++++-
 block/blk-mq.c           | 2 ++
 include/linux/elevator.h | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 653100f..0f7cdbc 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5223,7 +5223,7 @@ static unsigned int bfq_update_depths(struct bfq_data *bfqd,
 	return min_shallow;
 }
 
-static int bfq_init_hctx(struct blk_mq_hw_ctx *hctx, unsigned int index)
+static void bfq_depth_updated(struct blk_mq_hw_ctx *hctx)
 {
 	struct bfq_data *bfqd = hctx->queue->elevator->elevator_data;
 	struct blk_mq_tags *tags = hctx->sched_tags;
@@ -5231,6 +5231,11 @@ static int bfq_init_hctx(struct blk_mq_hw_ctx *hctx, unsigned int index)
 
 	min_shallow = bfq_update_depths(bfqd, &tags->bitmap_tags);
 	sbitmap_queue_min_shallow_depth(&tags->bitmap_tags, min_shallow);
+}
+
+static int bfq_init_hctx(struct blk_mq_hw_ctx *hctx, unsigned int index)
+{
+	bfq_depth_updated(hctx);
 	return 0;
 }
 
@@ -5653,6 +5658,7 @@ static ssize_t bfq_low_latency_store(struct elevator_queue *e,
 		.requests_merged	= bfq_requests_merged,
 		.request_merged		= bfq_request_merged,
 		.has_work		= bfq_has_work,
+		.depth_updated		= bfq_depth_updated,
 		.init_hctx		= bfq_init_hctx,
 		.init_sched		= bfq_init_queue,
 		.exit_sched		= bfq_exit_queue,
diff --git a/block/blk-mq.c b/block/blk-mq.c
index e3c39ea..7a57368 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2878,6 +2878,8 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 		}
 		if (ret)
 			break;
+		if (q->elevator && q->elevator->type->ops.mq.depth_updated)
+			q->elevator->type->ops.mq.depth_updated(hctx);
 	}
 
 	if (!ret)
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index a02deea..a2bf4a6 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -99,6 +99,7 @@ struct elevator_mq_ops {
 	void (*exit_sched)(struct elevator_queue *);
 	int (*init_hctx)(struct blk_mq_hw_ctx *, unsigned int);
 	void (*exit_hctx)(struct blk_mq_hw_ctx *, unsigned int);
+	void (*depth_updated)(struct blk_mq_hw_ctx *);
 
 	bool (*allow_merge)(struct request_queue *, struct request *, struct bio *);
 	bool (*bio_merge)(struct blk_mq_hw_ctx *, struct bio *);
-- 
1.8.3.1

