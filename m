Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8011550F5BE
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbiDZIsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346915AbiDZIpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE7F13F73;
        Tue, 26 Apr 2022 01:36:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DE7DB81CFE;
        Tue, 26 Apr 2022 08:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0497C385A4;
        Tue, 26 Apr 2022 08:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962202;
        bh=HmfFJivqIOqkgG4jXS9YrYHWjOYRZEUNs3qyybS+uNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/RnP+6/gaw56bxAKA22B2+buSwmsmLHmCrr+18fH+BYh2gqh0qyLgOd+X9hNCMPp
         M+mCGOIjvyMRb3NCqNFM+WisIt2ungKfRnLeb22grBCCnT82IHWSMQBKgqjdfrvdUq
         dMH4t20BUQJKopLlpCzoq+/TEkNZ3ytJFY5YZn0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/124] block: remove __sync_blockdev
Date:   Tue, 26 Apr 2022 10:20:03 +0200
Message-Id: <20220426081747.360900178@linuxfoundation.org>
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

[ Upstream commit 70164eb6ccb76ab679b016b4b60123bf4ec6c162 ]

Instead offer a new sync_blockdev_nowait helper for the !wait case.
This new helper is exported as it will grow modular callers in a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20211019062530.2174626-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c           | 11 ++++++-----
 fs/internal.h          |  5 -----
 fs/sync.c              |  7 ++++---
 include/linux/blkdev.h |  5 +++++
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index 485a258b0ab3..33cac289302e 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -184,14 +184,13 @@ int sb_min_blocksize(struct super_block *sb, int size)
 
 EXPORT_SYMBOL(sb_min_blocksize);
 
-int __sync_blockdev(struct block_device *bdev, int wait)
+int sync_blockdev_nowait(struct block_device *bdev)
 {
 	if (!bdev)
 		return 0;
-	if (!wait)
-		return filemap_flush(bdev->bd_inode->i_mapping);
-	return filemap_write_and_wait(bdev->bd_inode->i_mapping);
+	return filemap_flush(bdev->bd_inode->i_mapping);
 }
+EXPORT_SYMBOL_GPL(sync_blockdev_nowait);
 
 /*
  * Write out and wait upon all the dirty data associated with a block
@@ -199,7 +198,9 @@ int __sync_blockdev(struct block_device *bdev, int wait)
  */
 int sync_blockdev(struct block_device *bdev)
 {
-	return __sync_blockdev(bdev, 1);
+	if (!bdev)
+		return 0;
+	return filemap_write_and_wait(bdev->bd_inode->i_mapping);
 }
 EXPORT_SYMBOL(sync_blockdev);
 
diff --git a/fs/internal.h b/fs/internal.h
index 3cd065c8a66b..b5caa16f4645 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -23,7 +23,6 @@ struct pipe_inode_info;
 #ifdef CONFIG_BLOCK
 extern void __init bdev_cache_init(void);
 
-extern int __sync_blockdev(struct block_device *bdev, int wait);
 void iterate_bdevs(void (*)(struct block_device *, void *), void *);
 void emergency_thaw_bdev(struct super_block *sb);
 #else
@@ -31,10 +30,6 @@ static inline void bdev_cache_init(void)
 {
 }
 
-static inline int __sync_blockdev(struct block_device *bdev, int wait)
-{
-	return 0;
-}
 static inline void iterate_bdevs(void (*f)(struct block_device *, void *),
 		void *arg)
 {
diff --git a/fs/sync.c b/fs/sync.c
index 0d6cdc507cb9..a621089eb07e 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -3,6 +3,7 @@
  * High-level sync()-related operations
  */
 
+#include <linux/blkdev.h>
 #include <linux/kernel.h>
 #include <linux/file.h>
 #include <linux/fs.h>
@@ -45,7 +46,7 @@ int sync_filesystem(struct super_block *sb)
 	/*
 	 * Do the filesystem syncing work.  For simple filesystems
 	 * writeback_inodes_sb(sb) just dirties buffers with inodes so we have
-	 * to submit I/O for these buffers via __sync_blockdev().  This also
+	 * to submit I/O for these buffers via sync_blockdev().  This also
 	 * speeds up the wait == 1 case since in that case write_inode()
 	 * methods call sync_dirty_buffer() and thus effectively write one block
 	 * at a time.
@@ -53,14 +54,14 @@ int sync_filesystem(struct super_block *sb)
 	writeback_inodes_sb(sb, WB_REASON_SYNC);
 	if (sb->s_op->sync_fs)
 		sb->s_op->sync_fs(sb, 0);
-	ret = __sync_blockdev(sb->s_bdev, 0);
+	ret = sync_blockdev_nowait(sb->s_bdev);
 	if (ret < 0)
 		return ret;
 
 	sync_inodes_sb(sb);
 	if (sb->s_op->sync_fs)
 		sb->s_op->sync_fs(sb, 1);
-	return __sync_blockdev(sb->s_bdev, 1);
+	return sync_blockdev(sb->s_bdev);
 }
 EXPORT_SYMBOL(sync_filesystem);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 413c0148c0ce..6bbd393e6bcc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1999,6 +1999,7 @@ int truncate_bdev_range(struct block_device *bdev, fmode_t mode, loff_t lstart,
 #ifdef CONFIG_BLOCK
 void invalidate_bdev(struct block_device *bdev);
 int sync_blockdev(struct block_device *bdev);
+int sync_blockdev_nowait(struct block_device *bdev);
 #else
 static inline void invalidate_bdev(struct block_device *bdev)
 {
@@ -2007,6 +2008,10 @@ static inline int sync_blockdev(struct block_device *bdev)
 {
 	return 0;
 }
+static inline int sync_blockdev_nowait(struct block_device *bdev)
+{
+	return 0;
+}
 #endif
 int fsync_bdev(struct block_device *bdev);
 
-- 
2.35.1



