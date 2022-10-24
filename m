Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A1760BA96
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbiJXUiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234450AbiJXUiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:38:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606561057B;
        Mon, 24 Oct 2022 11:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62B6561336;
        Mon, 24 Oct 2022 12:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770CDC4347C;
        Mon, 24 Oct 2022 12:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615912;
        bh=PdSMTXpGDBNF8BPLxa+/LnaNU12LyI7yEIxPMmhuyBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWbmuF2qcsKfG9lWH6XTPzQqaLtDX5eoK/eyvFrEqMTKv8s6UATQ9Wns5ASApJCpj
         Jlnt5lmbxASSTe11FuV550/rQuM3WSAgG7iXtk1lg8Eys1+F4bJUVWCbtFdnsLTigo
         9OSaE9bVryouiRrJ/r55FEZ5V/+aEDehpsq9uweQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 398/530] f2fs: fix to account FS_CP_DATA_IO correctly
Date:   Mon, 24 Oct 2022 13:32:22 +0200
Message-Id: <20221024113103.098138937@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 2917299d45c0..02840dadde5d 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1062,7 +1062,8 @@ void f2fs_remove_dirty_inode(struct inode *inode)
 	spin_unlock(&sbi->inode_lock[type]);
 }
 
-int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type)
+int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type,
+						bool from_cp)
 {
 	struct list_head *head;
 	struct inode *inode;
@@ -1097,11 +1098,15 @@ int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type)
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
@@ -1230,7 +1235,7 @@ static int block_operations(struct f2fs_sb_info *sbi)
 	/* write all the dirty dentry pages */
 	if (get_pages(sbi, F2FS_DIRTY_DENTS)) {
 		f2fs_unlock_all(sbi);
-		err = f2fs_sync_dirty_inodes(sbi, DIR_INODE);
+		err = f2fs_sync_dirty_inodes(sbi, DIR_INODE, true);
 		if (err)
 			return err;
 		cond_resched();
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 4cf522120cb1..cfa6e1322e46 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2862,7 +2862,7 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
 	}
 	unlock_page(page);
 	if (!S_ISDIR(inode->i_mode) && !IS_NOQUOTA(inode) &&
-			!F2FS_I(inode)->cp_task && allow_balance)
+			!F2FS_I(inode)->wb_task && allow_balance)
 		f2fs_balance_fs(sbi, need_balance_fs);
 
 	if (unlikely(f2fs_cp_error(sbi))) {
@@ -3160,7 +3160,7 @@ static inline bool __should_serialize_io(struct inode *inode,
 					struct writeback_control *wbc)
 {
 	/* to avoid deadlock in path of data flush */
-	if (F2FS_I(inode)->cp_task)
+	if (F2FS_I(inode)->wb_task)
 		return false;
 
 	if (!S_ISREG(inode->i_mode))
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 4caac78e2034..a144471c5316 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -749,6 +749,7 @@ struct f2fs_inode_info {
 	unsigned int clevel;		/* maximum level of given file name */
 	struct task_struct *task;	/* lookup and create consistency */
 	struct task_struct *cp_task;	/* separate cp/wb IO stats*/
+	struct task_struct *wb_task;	/* indicate inode is in context of writeback */
 	nid_t i_xattr_nid;		/* node id that contains xattrs */
 	loff_t	last_disk_size;		/* lastly written file size */
 	spinlock_t i_size_lock;		/* protect last_disk_size */
@@ -3573,7 +3574,8 @@ int f2fs_recover_orphan_inodes(struct f2fs_sb_info *sbi);
 int f2fs_get_valid_checkpoint(struct f2fs_sb_info *sbi);
 void f2fs_update_dirty_page(struct inode *inode, struct page *page);
 void f2fs_remove_dirty_inode(struct inode *inode);
-int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type);
+int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type,
+								bool from_cp);
 void f2fs_wait_on_all_pages(struct f2fs_sb_info *sbi, int type);
 u64 f2fs_get_sectors_written(struct f2fs_sb_info *sbi);
 int f2fs_write_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index e98c90bd8ef6..af810b2d5d90 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -575,7 +575,7 @@ void f2fs_balance_fs_bg(struct f2fs_sb_info *sbi, bool from_bg)
 		mutex_lock(&sbi->flush_lock);
 
 		blk_start_plug(&plug);
-		f2fs_sync_dirty_inodes(sbi, FILE_INODE);
+		f2fs_sync_dirty_inodes(sbi, FILE_INODE, false);
 		blk_finish_plug(&plug);
 
 		mutex_unlock(&sbi->flush_lock);
-- 
2.35.1



