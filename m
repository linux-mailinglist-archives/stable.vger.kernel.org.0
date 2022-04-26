Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E1050F653
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbiDZIrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347102AbiDZIps (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60E56EB3D;
        Tue, 26 Apr 2022 01:37:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CC2AB81CFA;
        Tue, 26 Apr 2022 08:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28B1C385A4;
        Tue, 26 Apr 2022 08:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962237;
        bh=SMg6yoRpfuB3MQX6qBkXeXgNbYB93FuGVON8CNUrC28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EONmBp3cQvWEizASsPMHFQyhZiStyHnGAMKeJQGwv6VFmH4tdjJnQ3EKmZBB0kmEf
         YlLuMbJJE/EdLnnr4+JvRTu6HKyap7MTjwhHO7ebIHHEgjmt3fA8vhyFxGhBwUMTMY
         C11MuszIrP6k57k0xBktf9XANNM6DL1dZzZHlYeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/124] block: simplify the block device syncing code
Date:   Tue, 26 Apr 2022 10:20:04 +0200
Message-Id: <20220426081747.390119497@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 1e03a36bdff4709c1bbf0f57f60ae3f776d51adf ]

Get rid of the indirections and just provide a sync_bdevs
helper for the generic sync code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20211019062530.2174626-8-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c           | 17 ++++++++++++++---
 fs/internal.h          |  6 ------
 fs/sync.c              | 23 ++++-------------------
 include/linux/blkdev.h |  4 ++++
 4 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index 33cac289302e..18abafb135e0 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1017,7 +1017,7 @@ int __invalidate_device(struct block_device *bdev, bool kill_dirty)
 }
 EXPORT_SYMBOL(__invalidate_device);
 
-void iterate_bdevs(void (*func)(struct block_device *, void *), void *arg)
+void sync_bdevs(bool wait)
 {
 	struct inode *inode, *old_inode = NULL;
 
@@ -1048,8 +1048,19 @@ void iterate_bdevs(void (*func)(struct block_device *, void *), void *arg)
 		bdev = I_BDEV(inode);
 
 		mutex_lock(&bdev->bd_disk->open_mutex);
-		if (bdev->bd_openers)
-			func(bdev, arg);
+		if (!bdev->bd_openers) {
+			; /* skip */
+		} else if (wait) {
+			/*
+			 * We keep the error status of individual mapping so
+			 * that applications can catch the writeback error using
+			 * fsync(2). See filemap_fdatawait_keep_errors() for
+			 * details.
+			 */
+			filemap_fdatawait_keep_errors(inode->i_mapping);
+		} else {
+			filemap_fdatawrite(inode->i_mapping);
+		}
 		mutex_unlock(&bdev->bd_disk->open_mutex);
 
 		spin_lock(&blockdev_superblock->s_inode_list_lock);
diff --git a/fs/internal.h b/fs/internal.h
index b5caa16f4645..cdd83d4899bb 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -23,17 +23,11 @@ struct pipe_inode_info;
 #ifdef CONFIG_BLOCK
 extern void __init bdev_cache_init(void);
 
-void iterate_bdevs(void (*)(struct block_device *, void *), void *);
 void emergency_thaw_bdev(struct super_block *sb);
 #else
 static inline void bdev_cache_init(void)
 {
 }
-
-static inline void iterate_bdevs(void (*f)(struct block_device *, void *),
-		void *arg)
-{
-}
 static inline int emergency_thaw_bdev(struct super_block *sb)
 {
 	return 0;
diff --git a/fs/sync.c b/fs/sync.c
index a621089eb07e..3ce8e2137f31 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -78,21 +78,6 @@ static void sync_fs_one_sb(struct super_block *sb, void *arg)
 		sb->s_op->sync_fs(sb, *(int *)arg);
 }
 
-static void fdatawrite_one_bdev(struct block_device *bdev, void *arg)
-{
-	filemap_fdatawrite(bdev->bd_inode->i_mapping);
-}
-
-static void fdatawait_one_bdev(struct block_device *bdev, void *arg)
-{
-	/*
-	 * We keep the error status of individual mapping so that
-	 * applications can catch the writeback error using fsync(2).
-	 * See filemap_fdatawait_keep_errors() for details.
-	 */
-	filemap_fdatawait_keep_errors(bdev->bd_inode->i_mapping);
-}
-
 /*
  * Sync everything. We start by waking flusher threads so that most of
  * writeback runs on all devices in parallel. Then we sync all inodes reliably
@@ -111,8 +96,8 @@ void ksys_sync(void)
 	iterate_supers(sync_inodes_one_sb, NULL);
 	iterate_supers(sync_fs_one_sb, &nowait);
 	iterate_supers(sync_fs_one_sb, &wait);
-	iterate_bdevs(fdatawrite_one_bdev, NULL);
-	iterate_bdevs(fdatawait_one_bdev, NULL);
+	sync_bdevs(false);
+	sync_bdevs(true);
 	if (unlikely(laptop_mode))
 		laptop_sync_completion();
 }
@@ -133,10 +118,10 @@ static void do_sync_work(struct work_struct *work)
 	 */
 	iterate_supers(sync_inodes_one_sb, &nowait);
 	iterate_supers(sync_fs_one_sb, &nowait);
-	iterate_bdevs(fdatawrite_one_bdev, NULL);
+	sync_bdevs(false);
 	iterate_supers(sync_inodes_one_sb, &nowait);
 	iterate_supers(sync_fs_one_sb, &nowait);
-	iterate_bdevs(fdatawrite_one_bdev, NULL);
+	sync_bdevs(false);
 	printk("Emergency Sync complete\n");
 	kfree(work);
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6bbd393e6bcc..aebe67ed7a73 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -2000,6 +2000,7 @@ int truncate_bdev_range(struct block_device *bdev, fmode_t mode, loff_t lstart,
 void invalidate_bdev(struct block_device *bdev);
 int sync_blockdev(struct block_device *bdev);
 int sync_blockdev_nowait(struct block_device *bdev);
+void sync_bdevs(bool wait);
 #else
 static inline void invalidate_bdev(struct block_device *bdev)
 {
@@ -2012,6 +2013,9 @@ static inline int sync_blockdev_nowait(struct block_device *bdev)
 {
 	return 0;
 }
+static inline void sync_bdevs(bool wait)
+{
+}
 #endif
 int fsync_bdev(struct block_device *bdev);
 
-- 
2.35.1



