Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51A85EA3BA
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbiIZLbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235030AbiIZLbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:31:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150DB6C771;
        Mon, 26 Sep 2022 03:42:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27EA160B6A;
        Mon, 26 Sep 2022 10:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B2AC433C1;
        Mon, 26 Sep 2022 10:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188924;
        bh=qOPvn88nOro9NoNR2AMFhwam0Y5ciogiY1gY09c+10k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOa0ouj5otfvNWIEOXu9Rze9Z6W7fdZarG63DJ1E3AMt+GWpNnak1z+g/HtkLPoJq
         trkPvW0M4tHsXSOyTVwwWr9ALZ8mcseijlso6YqxodOJm5tnHH5yxb0FzvKMoGVjLk
         852UzebVKpSvlSw7HCoilab0a7ONag7qbDGqIZyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 017/207] block: remove QUEUE_FLAG_DEAD
Date:   Mon, 26 Sep 2022 12:10:06 +0200
Message-Id: <20220926100807.246193057@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 1f90307e5f0d7bc9a336ead528f616a5df8e5944 ]

Disallow setting the blk-mq state on any queue that is already dying as
setting the state even then is a bad idea, and remove the now unused
QUEUE_FLAG_DEAD flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20220619060552.1850436-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 8fe4ce5836e9 ("scsi: core: Fix a use-after-free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c       | 3 ---
 block/blk-mq-debugfs.c | 8 +++-----
 include/linux/blkdev.h | 2 --
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index cc6fbcb6d252..76f070c3a3b0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -313,9 +313,6 @@ void blk_cleanup_queue(struct request_queue *q)
 	 * after draining finished.
 	 */
 	blk_freeze_queue(q);
-
-	blk_queue_flag_set(QUEUE_FLAG_DEAD, q);
-
 	blk_sync_queue(q);
 	if (queue_is_mq(q)) {
 		blk_mq_cancel_work_sync(q);
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 61f179e5f151..28adb01f6441 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -116,7 +116,6 @@ static const char *const blk_queue_flag_name[] = {
 	QUEUE_FLAG_NAME(NOXMERGES),
 	QUEUE_FLAG_NAME(ADD_RANDOM),
 	QUEUE_FLAG_NAME(SAME_FORCE),
-	QUEUE_FLAG_NAME(DEAD),
 	QUEUE_FLAG_NAME(INIT_DONE),
 	QUEUE_FLAG_NAME(STABLE_WRITES),
 	QUEUE_FLAG_NAME(POLL),
@@ -151,11 +150,10 @@ static ssize_t queue_state_write(void *data, const char __user *buf,
 	char opbuf[16] = { }, *op;
 
 	/*
-	 * The "state" attribute is removed after blk_cleanup_queue() has called
-	 * blk_mq_free_queue(). Return if QUEUE_FLAG_DEAD has been set to avoid
-	 * triggering a use-after-free.
+	 * The "state" attribute is removed when the queue is removed.  Don't
+	 * allow setting the state on a dying queue to avoid a use-after-free.
 	 */
-	if (blk_queue_dead(q))
+	if (blk_queue_dying(q))
 		return -ENOENT;
 
 	if (count >= sizeof(opbuf)) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 62e3ff52ab03..76f77eed58c3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -559,7 +559,6 @@ struct request_queue {
 #define QUEUE_FLAG_NOXMERGES	9	/* No extended merges */
 #define QUEUE_FLAG_ADD_RANDOM	10	/* Contributes to random pool */
 #define QUEUE_FLAG_SAME_FORCE	12	/* force complete on same CPU */
-#define QUEUE_FLAG_DEAD		13	/* queue tear-down finished */
 #define QUEUE_FLAG_INIT_DONE	14	/* queue is initialized */
 #define QUEUE_FLAG_STABLE_WRITES 15	/* don't modify blks until WB is done */
 #define QUEUE_FLAG_POLL		16	/* IO polling enabled if set */
@@ -587,7 +586,6 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_dying(q)	test_bit(QUEUE_FLAG_DYING, &(q)->queue_flags)
 #define blk_queue_has_srcu(q)	test_bit(QUEUE_FLAG_HAS_SRCU, &(q)->queue_flags)
-#define blk_queue_dead(q)	test_bit(QUEUE_FLAG_DEAD, &(q)->queue_flags)
 #define blk_queue_init_done(q)	test_bit(QUEUE_FLAG_INIT_DONE, &(q)->queue_flags)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_noxmerges(q)	\
-- 
2.35.1



