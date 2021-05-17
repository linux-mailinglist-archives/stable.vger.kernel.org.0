Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921D8382F75
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238898AbhEQOQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239025AbhEQOOp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:14:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A236960724;
        Mon, 17 May 2021 14:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260542;
        bh=yRFeOinnOjzarbibYKIB02kOpdk9rdZEju9uqBDVv80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfzPhXNPuQC0L4TsXZYJfnhgC1crmtNQ3f4YgTJGmUUEuOMuQN2U7jE4cTQjmgSlc
         2nXgalxXIvETIQe65E4qYPKs2W5+1xDZQyfnOQccNnmaSrv+9C/9WQP6nSALJZglF/
         j/RJLg2UayuSYC6UGQXPBc/kHWeEcomOCLORAf1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 128/363] f2fs: fix to allow migrating fully valid segment
Date:   Mon, 17 May 2021 15:59:54 +0200
Message-Id: <20210517140306.945030794@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 7dede88659df38f96128ab3922c50dde2d29c574 ]

F2FS_IOC_FLUSH_DEVICE/F2FS_IOC_RESIZE_FS needs to migrate all blocks of
target segment to other place, no matter the segment has partially or fully
valid blocks.

However, after commit 803e74be04b3 ("f2fs: stop GC when the victim becomes
fully valid"), we may skip migration due to target segment is fully valid,
result in failing the ioctl interface, fix this.

Fixes: 803e74be04b3 ("f2fs: stop GC when the victim becomes fully valid")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h    |  2 +-
 fs/f2fs/file.c    |  9 +++++----
 fs/f2fs/gc.c      | 21 ++++++++++++---------
 fs/f2fs/segment.c |  2 +-
 fs/f2fs/super.c   |  2 +-
 5 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index e2d302ae3a46..cccdfb1a40ab 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3547,7 +3547,7 @@ void f2fs_destroy_post_read_wq(struct f2fs_sb_info *sbi);
 int f2fs_start_gc_thread(struct f2fs_sb_info *sbi);
 void f2fs_stop_gc_thread(struct f2fs_sb_info *sbi);
 block_t f2fs_start_bidx_of_node(unsigned int node_ofs, struct inode *inode);
-int f2fs_gc(struct f2fs_sb_info *sbi, bool sync, bool background,
+int f2fs_gc(struct f2fs_sb_info *sbi, bool sync, bool background, bool force,
 			unsigned int segno);
 void f2fs_build_gc_manager(struct f2fs_sb_info *sbi);
 int f2fs_resize_fs(struct f2fs_sb_info *sbi, __u64 block_count);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index d26ff2ae3f5e..1863944f4073 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1658,7 +1658,7 @@ next_alloc:
 		if (has_not_enough_free_secs(sbi, 0,
 			GET_SEC_FROM_SEG(sbi, overprovision_segments(sbi)))) {
 			down_write(&sbi->gc_lock);
-			err = f2fs_gc(sbi, true, false, NULL_SEGNO);
+			err = f2fs_gc(sbi, true, false, false, NULL_SEGNO);
 			if (err && err != -ENODATA && err != -EAGAIN)
 				goto out_err;
 		}
@@ -2489,7 +2489,7 @@ static int f2fs_ioc_gc(struct file *filp, unsigned long arg)
 		down_write(&sbi->gc_lock);
 	}
 
-	ret = f2fs_gc(sbi, sync, true, NULL_SEGNO);
+	ret = f2fs_gc(sbi, sync, true, false, NULL_SEGNO);
 out:
 	mnt_drop_write_file(filp);
 	return ret;
@@ -2525,7 +2525,8 @@ do_more:
 		down_write(&sbi->gc_lock);
 	}
 
-	ret = f2fs_gc(sbi, range->sync, true, GET_SEGNO(sbi, range->start));
+	ret = f2fs_gc(sbi, range->sync, true, false,
+				GET_SEGNO(sbi, range->start));
 	if (ret) {
 		if (ret == -EBUSY)
 			ret = -EAGAIN;
@@ -2978,7 +2979,7 @@ static int f2fs_ioc_flush_device(struct file *filp, unsigned long arg)
 		sm->last_victim[GC_CB] = end_segno + 1;
 		sm->last_victim[GC_GREEDY] = end_segno + 1;
 		sm->last_victim[ALLOC_NEXT] = end_segno + 1;
-		ret = f2fs_gc(sbi, true, true, start_segno);
+		ret = f2fs_gc(sbi, true, true, true, start_segno);
 		if (ret == -EAGAIN)
 			ret = 0;
 		else if (ret < 0)
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 39330ad3c44e..b3af76340026 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -112,7 +112,7 @@ do_gc:
 		sync_mode = F2FS_OPTION(sbi).bggc_mode == BGGC_MODE_SYNC;
 
 		/* if return value is not zero, no victim was selected */
-		if (f2fs_gc(sbi, sync_mode, true, NULL_SEGNO))
+		if (f2fs_gc(sbi, sync_mode, true, false, NULL_SEGNO))
 			wait_ms = gc_th->no_gc_sleep_time;
 
 		trace_f2fs_background_gc(sbi->sb, wait_ms,
@@ -1354,7 +1354,8 @@ out:
  * the victim data block is ignored.
  */
 static int gc_data_segment(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
-		struct gc_inode_list *gc_list, unsigned int segno, int gc_type)
+		struct gc_inode_list *gc_list, unsigned int segno, int gc_type,
+		bool force_migrate)
 {
 	struct super_block *sb = sbi->sb;
 	struct f2fs_summary *entry;
@@ -1383,8 +1384,8 @@ next_step:
 		 * race condition along with SSR block allocation.
 		 */
 		if ((gc_type == BG_GC && has_not_enough_free_secs(sbi, 0, 0)) ||
-				get_valid_blocks(sbi, segno, true) ==
-							BLKS_PER_SEC(sbi))
+			(!force_migrate && get_valid_blocks(sbi, segno, true) ==
+							BLKS_PER_SEC(sbi)))
 			return submitted;
 
 		if (check_valid_map(sbi, segno, off) == 0)
@@ -1519,7 +1520,8 @@ static int __get_victim(struct f2fs_sb_info *sbi, unsigned int *victim,
 
 static int do_garbage_collect(struct f2fs_sb_info *sbi,
 				unsigned int start_segno,
-				struct gc_inode_list *gc_list, int gc_type)
+				struct gc_inode_list *gc_list, int gc_type,
+				bool force_migrate)
 {
 	struct page *sum_page;
 	struct f2fs_summary_block *sum;
@@ -1606,7 +1608,8 @@ static int do_garbage_collect(struct f2fs_sb_info *sbi,
 								gc_type);
 		else
 			submitted += gc_data_segment(sbi, sum->entries, gc_list,
-							segno, gc_type);
+							segno, gc_type,
+							force_migrate);
 
 		stat_inc_seg_count(sbi, type, gc_type);
 		migrated++;
@@ -1634,7 +1637,7 @@ skip:
 }
 
 int f2fs_gc(struct f2fs_sb_info *sbi, bool sync,
-			bool background, unsigned int segno)
+			bool background, bool force, unsigned int segno)
 {
 	int gc_type = sync ? FG_GC : BG_GC;
 	int sec_freed = 0, seg_freed = 0, total_freed = 0;
@@ -1696,7 +1699,7 @@ gc_more:
 	if (ret)
 		goto stop;
 
-	seg_freed = do_garbage_collect(sbi, segno, &gc_list, gc_type);
+	seg_freed = do_garbage_collect(sbi, segno, &gc_list, gc_type, force);
 	if (gc_type == FG_GC &&
 		seg_freed == f2fs_usable_segs_in_sec(sbi, segno))
 		sec_freed++;
@@ -1835,7 +1838,7 @@ static int free_segment_range(struct f2fs_sb_info *sbi,
 			.iroot = RADIX_TREE_INIT(gc_list.iroot, GFP_NOFS),
 		};
 
-		do_garbage_collect(sbi, segno, &gc_list, FG_GC);
+		do_garbage_collect(sbi, segno, &gc_list, FG_GC, true);
 		put_gc_inode(&gc_list);
 
 		if (!gc_only && get_valid_blocks(sbi, segno, true)) {
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index c2866561263e..dcba4ac3dd2b 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -504,7 +504,7 @@ void f2fs_balance_fs(struct f2fs_sb_info *sbi, bool need)
 	 */
 	if (has_not_enough_free_secs(sbi, 0, 0)) {
 		down_write(&sbi->gc_lock);
-		f2fs_gc(sbi, false, false, NULL_SEGNO);
+		f2fs_gc(sbi, false, false, false, NULL_SEGNO);
 	}
 }
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 82592b19b4e0..1d010a3a144f 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1865,7 +1865,7 @@ static int f2fs_disable_checkpoint(struct f2fs_sb_info *sbi)
 
 	while (!f2fs_time_over(sbi, DISABLE_TIME)) {
 		down_write(&sbi->gc_lock);
-		err = f2fs_gc(sbi, true, false, NULL_SEGNO);
+		err = f2fs_gc(sbi, true, false, false, NULL_SEGNO);
 		if (err == -ENODATA) {
 			err = 0;
 			break;
-- 
2.30.2



