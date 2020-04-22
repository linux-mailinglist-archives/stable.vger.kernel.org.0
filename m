Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DA21B3DD7
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730044AbgDVKTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:19:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729710AbgDVKTH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:19:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCB142070B;
        Wed, 22 Apr 2020 10:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550746;
        bh=aVfigafMAvv1hgwZCshZyIH+wEjppUtP4c/qdhe1li8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADZVMr+r7HcERBqaVOXxHONLX2wWTiV6VLdUpW6zy+CHkAxMRVdD1it70SaUyZEm9
         40Tdo963YJ9H3e4uogjdqMLEHU8XneEBUMaBokUc8CKGuQFvAaXVnvFL8HmreNGTJI
         IbgNSrFuoK0p8zXKkBzOvySNEvooRJA18MdVJLtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sahitya Tummala <stummala@codeaurora.org>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/118] f2fs: fix the panic in do_checkpoint()
Date:   Wed, 22 Apr 2020 11:56:40 +0200
Message-Id: <20200422095038.355618952@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a0eef95b9e0ed..410f5c2c6ef17 100644
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
 	 * invalidate intermediate page cache borrowed from meta inode
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 9046432b87c2d..1a8b68ceaa62f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3185,7 +3185,7 @@ int f2fs_get_valid_checkpoint(struct f2fs_sb_info *sbi);
 void f2fs_update_dirty_page(struct inode *inode, struct page *page);
 void f2fs_remove_dirty_inode(struct inode *inode);
 int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type);
-void f2fs_wait_on_all_pages_writeback(struct f2fs_sb_info *sbi);
+void f2fs_wait_on_all_pages(struct f2fs_sb_info *sbi, int type);
 int f2fs_write_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc);
 void f2fs_init_ino_entry_info(struct f2fs_sb_info *sbi);
 int __init f2fs_create_checkpoint_caches(void);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index ea8dbf1458c99..28441f4971b8d 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1105,7 +1105,7 @@ static void f2fs_put_super(struct super_block *sb)
 	/* our cp_error case, we can wait for any writeback page */
 	f2fs_flush_merged_writes(sbi);
 
-	f2fs_wait_on_all_pages_writeback(sbi);
+	f2fs_wait_on_all_pages(sbi, F2FS_WB_CP_DATA);
 
 	f2fs_bug_on(sbi, sbi->fsync_node_num);
 
-- 
2.20.1



