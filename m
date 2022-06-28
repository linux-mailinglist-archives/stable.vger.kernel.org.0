Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A977055DCD8
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243540AbiF1CU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243487AbiF1CT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:19:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C572409B;
        Mon, 27 Jun 2022 19:19:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB211617CE;
        Tue, 28 Jun 2022 02:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5325FC341CC;
        Tue, 28 Jun 2022 02:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382786;
        bh=Eyq/0HEUhHEVZkYVo6CDJhBrIBckdk1DdqmqCtySsFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=beOd9cNScbX01qr3K6PXDu7fNQnlAbT5lTNjr/TXlh1ZjNh6TPR49SdxQ1v0Os5vj
         HnQ+NVGlzDF+qS5m9uYNVcyHQ1bp1SEVAR3Ew91kgoykPLE/4OgXYbPsTSlGfZY5U/
         URUEqpa7v9fLRWBuHVR+okt30FvP3O/F0PAKJneuYabU1zm20llwcC+G+zghPjLXsP
         f+K/uR6N+/u341LxngVLwYhfcWmEwvLm330rDRUBdrHvplkqvm1sQzF0FUw5nitUGJ
         jHRIO/vBpjX49vq47Mg3WJzSpSbtsC3uu4H5TzcorEhsgWgtUO67mX7h5tpFPg/nWB
         Ub/SXc/Ar/KIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 22/53] block: remove per-disk debugfs files in blk_unregister_queue
Date:   Mon, 27 Jun 2022 22:18:08 -0400
Message-Id: <20220628021839.594423-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit 99d055b4fd4bbb309c6cdb51a0d420669f777944 ]

The block debugfs files are created in blk_register_queue, which is
called by add_disk and use a naming scheme based on the disk_name.
After del_gendisk returns that name can be reused and thus we must not
leave these debugfs files around, otherwise the kernel is unhappy
and spews messages like:

	Directory XXXXX with parent 'block' already present!

and the newly created devices will not have working debugfs files.

Move the unregistration to blk_unregister_queue instead (which matches
the sysfs unregistration) to make sure the debugfs life time rules match
those of the disk name.

As part of the move also make sure the whole debugfs unregistration is
inside a single debugfs_mutex critical section.

Note that this breaks blktests block/002, which checks that the debugfs
directory has not been removed while blktests is running, but that
particular check should simply be removed from the test case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220614074827.458955-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-debugfs.c |  8 --------
 block/blk-mq-debugfs.h |  5 -----
 block/blk-rq-qos.c     |  4 ----
 block/blk-sysfs.c      | 16 ++++++++--------
 4 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 54f292a1d278..ba450708878e 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -842,14 +842,6 @@ void blk_mq_debugfs_register_rqos(struct rq_qos *rqos)
 	debugfs_create_files(rqos->debugfs_dir, rqos, rqos->ops->debugfs_attrs);
 }
 
-void blk_mq_debugfs_unregister_queue_rqos(struct request_queue *q)
-{
-	lockdep_assert_held(&q->debugfs_mutex);
-
-	debugfs_remove_recursive(q->rqos_debugfs_dir);
-	q->rqos_debugfs_dir = NULL;
-}
-
 void blk_mq_debugfs_register_sched_hctx(struct request_queue *q,
 					struct blk_mq_hw_ctx *hctx)
 {
diff --git a/block/blk-mq-debugfs.h b/block/blk-mq-debugfs.h
index 771d45832878..9c7d4b6117d4 100644
--- a/block/blk-mq-debugfs.h
+++ b/block/blk-mq-debugfs.h
@@ -35,7 +35,6 @@ void blk_mq_debugfs_unregister_sched_hctx(struct blk_mq_hw_ctx *hctx);
 
 void blk_mq_debugfs_register_rqos(struct rq_qos *rqos);
 void blk_mq_debugfs_unregister_rqos(struct rq_qos *rqos);
-void blk_mq_debugfs_unregister_queue_rqos(struct request_queue *q);
 #else
 static inline void blk_mq_debugfs_register(struct request_queue *q)
 {
@@ -82,10 +81,6 @@ static inline void blk_mq_debugfs_register_rqos(struct rq_qos *rqos)
 static inline void blk_mq_debugfs_unregister_rqos(struct rq_qos *rqos)
 {
 }
-
-static inline void blk_mq_debugfs_unregister_queue_rqos(struct request_queue *q)
-{
-}
 #endif
 
 #ifdef CONFIG_BLK_DEBUG_FS_ZONED
diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index 249a6f05dd3b..d3a75693adbf 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -294,10 +294,6 @@ void rq_qos_wait(struct rq_wait *rqw, void *private_data,
 
 void rq_qos_exit(struct request_queue *q)
 {
-	mutex_lock(&q->debugfs_mutex);
-	blk_mq_debugfs_unregister_queue_rqos(q);
-	mutex_unlock(&q->debugfs_mutex);
-
 	while (q->rq_qos) {
 		struct rq_qos *rqos = q->rq_qos;
 		q->rq_qos = rqos->next;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 6e4801b217a7..9b905e9443e4 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -779,13 +779,6 @@ static void blk_release_queue(struct kobject *kobj)
 	if (queue_is_mq(q))
 		blk_mq_release(q);
 
-	mutex_lock(&q->debugfs_mutex);
-	blk_trace_shutdown(q);
-	debugfs_remove_recursive(q->debugfs_dir);
-	q->debugfs_dir = NULL;
-	q->sched_debugfs_dir = NULL;
-	mutex_unlock(&q->debugfs_mutex);
-
 	bioset_exit(&q->bio_split);
 
 	if (blk_queue_has_srcu(q))
@@ -946,8 +939,15 @@ void blk_unregister_queue(struct gendisk *disk)
 	/* Now that we've deleted all child objects, we can delete the queue. */
 	kobject_uevent(&q->kobj, KOBJ_REMOVE);
 	kobject_del(&q->kobj);
-
 	mutex_unlock(&q->sysfs_dir_lock);
 
+	mutex_lock(&q->debugfs_mutex);
+	blk_trace_shutdown(q);
+	debugfs_remove_recursive(q->debugfs_dir);
+	q->debugfs_dir = NULL;
+	q->sched_debugfs_dir = NULL;
+	q->rqos_debugfs_dir = NULL;
+	mutex_unlock(&q->debugfs_mutex);
+
 	kobject_put(&disk_to_dev(disk)->kobj);
 }
-- 
2.35.1

