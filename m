Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B365316CA
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240460AbiEWRTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240106AbiEWRRh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:17:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2539A71D88;
        Mon, 23 May 2022 10:17:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 994D0608C3;
        Mon, 23 May 2022 17:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9810EC385A9;
        Mon, 23 May 2022 17:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326198;
        bh=EH69Z5XiNYzDbxjM0ck1W39n8wl/6fzKXeS4geIBYDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H71RF3+ebAxMuIk+S2R4iDHFFdFzaVIoCZQVoszqUUh3iYIdXN51el85mlvobCvSe
         lKNCXsxZ4pffyTLxtSSmIJMF6f2IB4E12diU+wBPCDHWCKEe2uUvlK+Aat88C9Xwfu
         SAJZQEIl6gk6JeonFEpdGqVZUf2Xn6v/m0UKIRow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Gwendal Grignou <gwendal@chromium.org>
Subject: [PATCH 5.4 60/68] block: return ELEVATOR_DISCARD_MERGE if possible
Date:   Mon, 23 May 2022 19:05:27 +0200
Message-Id: <20220523165812.360622432@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 866663b7b52d2da267b28e12eed89ee781b8fed1 upstream.

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
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-iosched.c    |    3 +++
 block/blk-merge.c      |   15 ---------------
 block/elevator.c       |    3 +++
 block/mq-deadline.c    |    2 ++
 include/linux/blkdev.h |   16 ++++++++++++++++
 5 files changed, 24 insertions(+), 15 deletions(-)

--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2251,6 +2251,9 @@ static int bfq_request_merge(struct requ
 	__rq = bfq_find_rq_fmerge(bfqd, bio, q);
 	if (__rq && elv_bio_merge_ok(__rq, bio)) {
 		*req = __rq;
+
+		if (blk_discard_mergable(__rq))
+			return ELEVATOR_DISCARD_MERGE;
 		return ELEVATOR_FRONT_MERGE;
 	}
 
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -721,21 +721,6 @@ static void blk_account_io_merge(struct
 		part_stat_unlock();
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
 
 static enum elv_merge blk_try_req_merge(struct request *req,
 					struct request *next)
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -337,6 +337,9 @@ enum elv_merge elv_merge(struct request_
 	__rq = elv_rqhash_find(q, bio->bi_iter.bi_sector);
 	if (__rq && elv_bio_merge_ok(__rq, bio)) {
 		*req = __rq;
+
+		if (blk_discard_mergable(__rq))
+			return ELEVATOR_DISCARD_MERGE;
 		return ELEVATOR_BACK_MERGE;
 	}
 
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -452,6 +452,8 @@ static int dd_request_merge(struct reque
 
 		if (elv_bio_merge_ok(__rq, bio)) {
 			*rq = __rq;
+			if (blk_discard_mergable(__rq))
+				return ELEVATOR_DISCARD_MERGE;
 			return ELEVATOR_FRONT_MERGE;
 		}
 	}
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1409,6 +1409,22 @@ static inline int queue_limit_discard_al
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


