Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD9F55D3F3
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237528AbiF0Lsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238311AbiF0LsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0576CF59B;
        Mon, 27 Jun 2022 04:40:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97F5960C16;
        Mon, 27 Jun 2022 11:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F15C36AED;
        Mon, 27 Jun 2022 11:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330028;
        bh=i7tt2QLqXksiiPiErEk6fj3nMFk3l0zF4KVChldBfBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=osz4fYd4M1WpzbVIPB36anxbpLTW67wZDAXKzvnh7hSWF2tdtCaGK8iDU1DWMf3iY
         ynd3I5izycfX8Hn90XDOkbTdWh7/hIFzMEethyLvKv4xvv/8X5Aw52iBOXeaq8SafC
         TFUQKZ/MfSBQdGQb/4wB8fqyMRTTuSfWt+Cl/hCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3e3f419f4a7816471838@syzkaller.appspotmail.com,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 060/181] block: disable the elevator int del_gendisk
Date:   Mon, 27 Jun 2022 13:20:33 +0200
Message-Id: <20220627111946.306640058@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 50e34d78815e474d410f342fbe783b18192ca518 ]

The elevator is only used for file system requests, which are stopped in
del_gendisk.  Move disabling the elevator and freeing the scheduler tags
to the end of del_gendisk instead of doing that work in disk_release and
blk_cleanup_queue to avoid a use after free on q->tag_set from
disk_release as the tag_set might not be alive at that point.

Move the blk_qos_exit call as well, as it just depends on the elevator
exit and would be the only reason to keep the not exactly cheap queue
freeze in disk_release.

Fixes: e155b0c238b2 ("blk-mq: Use shared tags for shared sbitmap support")
Reported-by: syzbot+3e3f419f4a7816471838@syzkaller.appspotmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: syzbot+3e3f419f4a7816471838@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20220614074827.458955-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 13 -------------
 block/genhd.c    | 39 +++++++++++----------------------------
 2 files changed, 11 insertions(+), 41 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 84f7b7884d07..a7329475aba2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -322,19 +322,6 @@ void blk_cleanup_queue(struct request_queue *q)
 		blk_mq_exit_queue(q);
 	}
 
-	/*
-	 * In theory, request pool of sched_tags belongs to request queue.
-	 * However, the current implementation requires tag_set for freeing
-	 * requests, so free the pool now.
-	 *
-	 * Queue has become frozen, there can't be any in-queue requests, so
-	 * it is safe to free requests now.
-	 */
-	mutex_lock(&q->sysfs_lock);
-	if (q->elevator)
-		blk_mq_sched_free_rqs(q);
-	mutex_unlock(&q->sysfs_lock);
-
 	/* @q is and will stay empty, shutdown and put */
 	blk_put_queue(q);
 }
diff --git a/block/genhd.c b/block/genhd.c
index 3008ec213654..13daac1a9aef 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -652,6 +652,17 @@ void del_gendisk(struct gendisk *disk)
 
 	blk_sync_queue(q);
 	blk_flush_integrity();
+	blk_mq_cancel_work_sync(q);
+
+	blk_mq_quiesce_queue(q);
+	if (q->elevator) {
+		mutex_lock(&q->sysfs_lock);
+		elevator_exit(q);
+		mutex_unlock(&q->sysfs_lock);
+	}
+	rq_qos_exit(q);
+	blk_mq_unquiesce_queue(q);
+
 	/*
 	 * Allow using passthrough request again after the queue is torn down.
 	 */
@@ -1120,31 +1131,6 @@ static const struct attribute_group *disk_attr_groups[] = {
 	NULL
 };
 
-static void disk_release_mq(struct request_queue *q)
-{
-	blk_mq_cancel_work_sync(q);
-
-	/*
-	 * There can't be any non non-passthrough bios in flight here, but
-	 * requests stay around longer, including passthrough ones so we
-	 * still need to freeze the queue here.
-	 */
-	blk_mq_freeze_queue(q);
-
-	/*
-	 * Since the I/O scheduler exit code may access cgroup information,
-	 * perform I/O scheduler exit before disassociating from the block
-	 * cgroup controller.
-	 */
-	if (q->elevator) {
-		mutex_lock(&q->sysfs_lock);
-		elevator_exit(q);
-		mutex_unlock(&q->sysfs_lock);
-	}
-	rq_qos_exit(q);
-	__blk_mq_unfreeze_queue(q, true);
-}
-
 /**
  * disk_release - releases all allocated resources of the gendisk
  * @dev: the device representing this disk
@@ -1166,9 +1152,6 @@ static void disk_release(struct device *dev)
 	might_sleep();
 	WARN_ON_ONCE(disk_live(disk));
 
-	if (queue_is_mq(disk->queue))
-		disk_release_mq(disk->queue);
-
 	blkcg_exit_queue(disk->queue);
 
 	disk_release_events(disk);
-- 
2.35.1



