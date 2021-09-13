Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578FD408E43
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241181AbhIMNci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:32:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241743AbhIMNa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:30:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9111961108;
        Mon, 13 Sep 2021 13:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539500;
        bh=wv1Y4mrKh+5yXEcKtaJVPZYqAzJ6UYaNjiylbSyYrnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHXMG/0ddOe+xa99odVlLSuhz8ealSQWsHenmBJA0qBskMIpAFtqRAOxVHy/mbaTN
         onlTNQ5dEzefuymw+dXBCcs4SVa9Bmzyn2VZ+vKeh3GZ0rnKFywrW+w3l67B1dzITM
         dtw/lmlZTXICOBW5xGrBX+UXfaWb/lrupKAs5wjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/236] block: return ELEVATOR_DISCARD_MERGE if possible
Date:   Mon, 13 Sep 2021 15:12:33 +0200
Message-Id: <20210913131101.987232905@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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
index c91dca641eb4..8ea37328ca84 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2251,6 +2251,9 @@ static int bfq_request_merge(struct request_queue *q, struct request **req,
 	__rq = bfq_find_rq_fmerge(bfqd, bio, q);
 	if (__rq && elv_bio_merge_ok(__rq, bio)) {
 		*req = __rq;
+
+		if (blk_discard_mergable(__rq))
+			return ELEVATOR_DISCARD_MERGE;
 		return ELEVATOR_FRONT_MERGE;
 	}
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 110db636d230..26f4bcc10de9 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -702,22 +702,6 @@ static void blk_account_io_merge_request(struct request *req)
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
index 293c5c81397a..2a525863d4e9 100644
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
index 2b9635d0dcba..e4e90761eab3 100644
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
index 542471b76f41..8aae375864b6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1534,6 +1534,22 @@ static inline int queue_limit_discard_alignment(struct queue_limits *lim, sector
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



