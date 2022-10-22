Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5DF6088E1
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbiJVIXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiJVIWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:22:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA73171CEC;
        Sat, 22 Oct 2022 00:59:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07A32B82E33;
        Sat, 22 Oct 2022 07:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5FDC433D6;
        Sat, 22 Oct 2022 07:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425545;
        bh=8x1GVGNt9XiIQqkjtVfsiusz1SyAaluOtV/zS6uMHq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJ4aGTaBAE/Uzls8qK7/k7w7iu+szCDdKrwRdutQmRipgAThU1mvDDz8YH3SvLlpL
         95Z2R9r9F6b+FXoKBLVRiL5HEdBIyhTGwOgfrS6Mr2ZLe7i6vwvFE7QqXadX0FsUoN
         8EGJyuNib+x3hvB3RXbLm6YHiNIBwdOqpwCkdIUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 537/717] f2fs: fix to account FS_CP_DATA_IO correctly
Date:   Sat, 22 Oct 2022 09:26:56 +0200
Message-Id: <20221022072522.076491149@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit d80afefb17e01aa0c46a8eebc01882e0ebd8b0f6 ]

f2fs_inode_info.cp_task was introduced for FS_CP_DATA_IO accounting
since commit b0af6d491a6b ("f2fs: add app/fs io stat").

However, cp_task usage coverage has been increased due to below
commits:
commit 040d2bb318d1 ("f2fs: fix to avoid deadloop if data_flush is on")
commit 186857c5a14a ("f2fs: fix potential recursive call when enabling data_flush")

So that, if data_flush mountoption is on, when data flush was
triggered from background, the IO from data flush will be accounted
as checkpoint IO type incorrectly.

In order to fix this issue, this patch splits cp_task into two:
a) cp_task: used for IO accounting
b) wb_task: used to avoid deadlock

Fixes: 040d2bb318d1 ("f2fs: fix to avoid deadloop if data_flush is on")
Fixes: 186857c5a14a ("f2fs: fix potential recursive call when enabling data_flush")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 13 +++++++++----
 fs/f2fs/data.c       |  4 ++--
 fs/f2fs/f2fs.h       |  4 +++-
 fs/f2fs/segment.c    |  2 +-
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 2a1930cfd513..5c77ae07150d 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1063,7 +1063,8 @@ void f2fs_remove_dirty_inode(struct inode *inode)
 	spin_unlock(&sbi->inode_lock[type]);
 }
 
-int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type)
+int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type,
+						bool from_cp)
 {
 	struct list_head *head;
 	struct inode *inode;
@@ -1098,11 +1099,15 @@ int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type)
 	if (inode) {
 		unsigned long cur_ino = inode->i_ino;
 
-		F2FS_I(inode)->cp_task = current;
+		if (from_cp)
+			F2FS_I(inode)->cp_task = current;
+		F2FS_I(inode)->wb_task = current;
 
 		filemap_fdatawrite(inode->i_mapping);
 
-		F2FS_I(inode)->cp_task = NULL;
+		F2FS_I(inode)->wb_task = NULL;
+		if (from_cp)
+			F2FS_I(inode)->cp_task = NULL;
 
 		iput(inode);
 		/* We need to give cpu to another writers. */
@@ -1231,7 +1236,7 @@ static int block_operations(struct f2fs_sb_info *sbi)
 	/* write all the dirty dentry pages */
 	if (get_pages(sbi, F2FS_DIRTY_DENTS)) {
 		f2fs_unlock_all(sbi);
-		err = f2fs_sync_dirty_inodes(sbi, DIR_INODE);
+		err = f2fs_sync_dirty_inodes(sbi, DIR_INODE, true);
 		if (err)
 			return err;
 		cond_resched();
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index f2a272613477..d3768115e3b8 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2843,7 +2843,7 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
 	}
 	unlock_page(page);
 	if (!S_ISDIR(inode->i_mode) && !IS_NOQUOTA(inode) &&
-			!F2FS_I(inode)->cp_task && allow_balance)
+			!F2FS_I(inode)->wb_task && allow_balance)
 		f2fs_balance_fs(sbi, need_balance_fs);
 
 	if (unlikely(f2fs_cp_error(sbi))) {
@@ -3141,7 +3141,7 @@ static inline bool __should_serialize_io(struct inode *inode,
 					struct writeback_control *wbc)
 {
 	/* to avoid deadlock in path of data flush */
-	if (F2FS_I(inode)->cp_task)
+	if (F2FS_I(inode)->wb_task)
 		return false;
 
 	if (!S_ISREG(inode->i_mode))
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f9d5110bbcd8..7896cbadbcd7 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -784,6 +784,7 @@ struct f2fs_inode_info {
 	unsigned int clevel;		/* maximum level of given file name */
 	struct task_struct *task;	/* lookup and create consistency */
 	struct task_struct *cp_task;	/* separate cp/wb IO stats*/
+	struct task_struct *wb_task;	/* indicate inode is in context of writeback */
 	nid_t i_xattr_nid;		/* node id that contains xattrs */
 	loff_t	last_disk_size;		/* lastly written file size */
 	spinlock_t i_size_lock;		/* protect last_disk_size */
@@ -3710,7 +3711,8 @@ int f2fs_recover_orphan_inodes(struct f2fs_sb_info *sbi);
 int f2fs_get_valid_checkpoint(struct f2fs_sb_info *sbi);
 void f2fs_update_dirty_folio(struct inode *inode, struct folio *folio);
 void f2fs_remove_dirty_inode(struct inode *inode);
-int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type);
+int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type,
+								bool from_cp);
 void f2fs_wait_on_all_pages(struct f2fs_sb_info *sbi, int type);
 u64 f2fs_get_sectors_written(struct f2fs_sb_info *sbi);
 int f2fs_write_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 52df19a0638b..b740ff81024e 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -469,7 +469,7 @@ void f2fs_balance_fs_bg(struct f2fs_sb_info *sbi, bool from_bg)
 		mutex_lock(&sbi->flush_lock);
 
 		blk_start_plug(&plug);
-		f2fs_sync_dirty_inodes(sbi, FILE_INODE);
+		f2fs_sync_dirty_inodes(sbi, FILE_INODE, false);
 		blk_finish_plug(&plug);
 
 		mutex_unlock(&sbi->flush_lock);
-- 
2.35.1



