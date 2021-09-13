Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515E5409145
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244685AbhIMOAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245515AbhIMN5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB233619F6;
        Mon, 13 Sep 2021 13:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540179;
        bh=reuRFdh2pKD+uolUaTTtB+/c9zsYWziirPL/pOYmjiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+EbU7UlZg4apoLS16yGqAZtsVivNxDIwfQzfBgL3TAzi5e8awplRMBSjiwt1e364
         Zt1qp1TtVMH+kXC6y+1GlSg8e886M8bqPH1YTdzUsgoorHETMclhE7C9N8LPnUjFmy
         CyJnwgayt7oxfSCNK6/dnc0y25LVZkPHuSFNCRX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 057/300] block: return ELEVATOR_DISCARD_MERGE if possible
Date:   Mon, 13 Sep 2021 15:11:58 +0200
Message-Id: <20210913131111.286734300@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 866663b7b52d2da267b28e12eed89ee781b8fed1 ]

When merging one bio to request, if they are discard IO and the queue
supports multi-range discard, we need to return ELEVATOR_DISCARD_MERGE
because both block core and related drivers(nvme, virtio-blk) doesn't
handle mixed discard io merge(traditional IO merge together with
discard merge) well.

Fix the issue by returning ELEVATOR_DISCARD_MERGE in this situation,
so both blk-mq and drivers just need to handle multi-range discard.

Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Fixes: 2705dfb20947 ("block: fix discard request merge")
Link: https://lore.kernel.org/r/20210729034226.1591070-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c    |  3 +++
 block/blk-merge.c      | 16 ----------------
 block/elevator.c       |  3 +++
 block/mq-deadline.c    |  2 ++
 include/linux/blkdev.h | 16 ++++++++++++++++
 5 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index eccbe2aed7c3..4df33cc08eee 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2333,6 +2333,9 @@ static int bfq_request_merge(struct request_queue *q, struct request **req,
 	__rq = bfq_find_rq_fmerge(bfqd, bio, q);
 	if (__rq && elv_bio_merge_ok(__rq, bio)) {
 		*req = __rq;
+
+		if (blk_discard_mergable(__rq))
+			return ELEVATOR_DISCARD_MERGE;
 		return ELEVATOR_FRONT_MERGE;
 	}
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 410ea45027c9..526953525e35 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -707,22 +707,6 @@ static void blk_account_io_merge_request(struct request *req)
 	}
 }
 
-/*
- * Two cases of handling DISCARD merge:
- * If max_discard_segments > 1, the driver takes every bio
- * as a range and send them to controller together. The ranges
- * needn't to be contiguous.
- * Otherwise, the bios/requests will be handled as same as
- * others which should be contiguous.
- */
-static inline bool blk_discard_mergable(struct request *req)
-{
-	if (req_op(req) == REQ_OP_DISCARD &&
-	    queue_max_discard_segments(req->q) > 1)
-		return true;
-	return false;
-}
-
 static enum elv_merge blk_try_req_merge(struct request *req,
 					struct request *next)
 {
diff --git a/block/elevator.c b/block/elevator.c
index 440699c28119..73e0591acfd4 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -336,6 +336,9 @@ enum elv_merge elv_merge(struct request_queue *q, struct request **req,
 	__rq = elv_rqhash_find(q, bio->bi_iter.bi_sector);
 	if (__rq && elv_bio_merge_ok(__rq, bio)) {
 		*req = __rq;
+
+		if (blk_discard_mergable(__rq))
+			return ELEVATOR_DISCARD_MERGE;
 		return ELEVATOR_BACK_MERGE;
 	}
 
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 8eea2cbf2bf4..8dca7255d04c 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -454,6 +454,8 @@ static int dd_request_merge(struct request_queue *q, struct request **rq,
 
 		if (elv_bio_merge_ok(__rq, bio)) {
 			*rq = __rq;
+			if (blk_discard_mergable(__rq))
+				return ELEVATOR_DISCARD_MERGE;
 			return ELEVATOR_FRONT_MERGE;
 		}
 	}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f69c75bd6d27..9bfb2f65534b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1531,6 +1531,22 @@ static inline int queue_limit_discard_alignment(struct queue_limits *lim, sector
 	return offset << SECTOR_SHIFT;
 }
 
+/*
+ * Two cases of handling DISCARD merge:
+ * If max_discard_segments > 1, the driver takes every bio
+ * as a range and send them to controller together. The ranges
+ * needn't to be contiguous.
+ * Otherwise, the bios/requests will be handled as same as
+ * others which should be contiguous.
+ */
+static inline bool blk_discard_mergable(struct request *req)
+{
+	if (req_op(req) == REQ_OP_DISCARD &&
+	    queue_max_discard_segments(req->q) > 1)
+		return true;
+	return false;
+}
+
 static inline int bdev_discard_alignment(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-- 
2.30.2



