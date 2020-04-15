Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5C01AA3BC
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897017AbgDOLfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408875AbgDOLe6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:34:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0183E20768;
        Wed, 15 Apr 2020 11:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950497;
        bh=9le1PvFkKlbTxjWl55RK+nnvYIn4LST6W/S4enHx7iU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4b0fYM77fcLEXlvuQmcLzBoEQi/r0073qy2eJvkbX42Y8wousSgXtRCsxKiDu9HF
         So4SVcdbTPCuAuIo2AE3cYD5Es4sEM3UyIU78/mnLvZ4zCvp/OoJSj3x/EksuiIzme
         2QzKoGPzY/w1kleL/izHAt1mdII5xI4FtQ/XdLUw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sahitya Tummala <stummala@codeaurora.org>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.6 010/129] f2fs: fix the panic in do_checkpoint()
Date:   Wed, 15 Apr 2020 07:32:45 -0400
Message-Id: <20200415113445.11881-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sahitya Tummala <stummala@codeaurora.org>

[ Upstream commit bf22c3cc8ce71454dddd772284773306a68031d8 ]

There could be a scenario where f2fs_sync_meta_pages() will not
ensure that all F2FS_DIRTY_META pages are submitted for IO. Thus,
resulting in the below panic in do_checkpoint() -

f2fs_bug_on(sbi, get_pages(sbi, F2FS_DIRTY_META) &&
				!f2fs_cp_error(sbi));

This can happen in a low-memory condition, where shrinker could
also be doing the writepage operation (stack shown below)
at the same time when checkpoint is running on another core.

schedule
down_write
f2fs_submit_page_write -> by this time, this page in page cache is tagged
			as PAGECACHE_TAG_WRITEBACK and PAGECACHE_TAG_DIRTY
			is cleared, due to which f2fs_sync_meta_pages()
			cannot sync this page in do_checkpoint() path.
f2fs_do_write_meta_page
__f2fs_write_meta_page
f2fs_write_meta_page
shrink_page_list
shrink_inactive_list
shrink_node_memcg
shrink_node
kswapd

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 16 +++++++---------
 fs/f2fs/f2fs.h       |  2 +-
 fs/f2fs/super.c      |  2 +-
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 44e84ac5c9411..9c88fb3d255a2 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1250,20 +1250,20 @@ static void unblock_operations(struct f2fs_sb_info *sbi)
 	f2fs_unlock_all(sbi);
 }
 
-void f2fs_wait_on_all_pages_writeback(struct f2fs_sb_info *sbi)
+void f2fs_wait_on_all_pages(struct f2fs_sb_info *sbi, int type)
 {
 	DEFINE_WAIT(wait);
 
 	for (;;) {
 		prepare_to_wait(&sbi->cp_wait, &wait, TASK_UNINTERRUPTIBLE);
 
-		if (!get_pages(sbi, F2FS_WB_CP_DATA))
+		if (!get_pages(sbi, type))
 			break;
 
 		if (unlikely(f2fs_cp_error(sbi)))
 			break;
 
-		io_schedule_timeout(5*HZ);
+		io_schedule_timeout(HZ/50);
 	}
 	finish_wait(&sbi->cp_wait, &wait);
 }
@@ -1384,8 +1384,6 @@ static int do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 
 	/* Flush all the NAT/SIT pages */
 	f2fs_sync_meta_pages(sbi, META, LONG_MAX, FS_CP_META_IO);
-	f2fs_bug_on(sbi, get_pages(sbi, F2FS_DIRTY_META) &&
-					!f2fs_cp_error(sbi));
 
 	/*
 	 * modify checkpoint
@@ -1493,11 +1491,11 @@ static int do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 
 	/* Here, we have one bio having CP pack except cp pack 2 page */
 	f2fs_sync_meta_pages(sbi, META, LONG_MAX, FS_CP_META_IO);
-	f2fs_bug_on(sbi, get_pages(sbi, F2FS_DIRTY_META) &&
-					!f2fs_cp_error(sbi));
+	/* Wait for all dirty meta pages to be submitted for IO */
+	f2fs_wait_on_all_pages(sbi, F2FS_DIRTY_META);
 
 	/* wait for previous submitted meta pages writeback */
-	f2fs_wait_on_all_pages_writeback(sbi);
+	f2fs_wait_on_all_pages(sbi, F2FS_WB_CP_DATA);
 
 	/* flush all device cache */
 	err = f2fs_flush_device_cache(sbi);
@@ -1506,7 +1504,7 @@ static int do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 
 	/* barrier and flush checkpoint cp pack 2 page if it can */
 	commit_checkpoint(sbi, ckpt, start_blk);
-	f2fs_wait_on_all_pages_writeback(sbi);
+	f2fs_wait_on_all_pages(sbi, F2FS_WB_CP_DATA);
 
 	/*
 	 * invalidate intermediate page cache borrowed from meta inode which are
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 5355be6b6755c..d39f5de114208 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3308,7 +3308,7 @@ int f2fs_get_valid_checkpoint(struct f2fs_sb_info *sbi);
 void f2fs_update_dirty_page(struct inode *inode, struct page *page);
 void f2fs_remove_dirty_inode(struct inode *inode);
 int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type);
-void f2fs_wait_on_all_pages_writeback(struct f2fs_sb_info *sbi);
+void f2fs_wait_on_all_pages(struct f2fs_sb_info *sbi, int type);
 int f2fs_write_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc);
 void f2fs_init_ino_entry_info(struct f2fs_sb_info *sbi);
 int __init f2fs_create_checkpoint_caches(void);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 65a7a432dfee2..686f5402660ed 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1172,7 +1172,7 @@ static void f2fs_put_super(struct super_block *sb)
 	/* our cp_error case, we can wait for any writeback page */
 	f2fs_flush_merged_writes(sbi);
 
-	f2fs_wait_on_all_pages_writeback(sbi);
+	f2fs_wait_on_all_pages(sbi, F2FS_WB_CP_DATA);
 
 	f2fs_bug_on(sbi, sbi->fsync_node_num);
 
-- 
2.20.1

