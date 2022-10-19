Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800C4604275
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbiJSLDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbiJSLC7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:02:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CCD2496B;
        Wed, 19 Oct 2022 03:32:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A256B82498;
        Wed, 19 Oct 2022 09:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4A1C433D6;
        Wed, 19 Oct 2022 09:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170441;
        bh=fsU/NIhV6UV2C5uJfH6d7QtH0kxG2G+HJD0NXYBrLi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQ3mIr2oiSeR8vo/vRUMb8qd/fgi4bzfz4Odv6ERSS5uZJrdDPaS2Hycssp8hDDv5
         4VNqJuuhvNL9q9DYLh/653gNZXtTO3eAFACbsJ9pr5blVfkggNpmTyPQKMY3CKTIx/
         URqT+DCkjQHuLloH5AMAEw/kg4GpEzd1XF5/pI4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 656/862] f2fs: fix to account FS_CP_DATA_IO correctly
Date:   Wed, 19 Oct 2022 10:32:23 +0200
Message-Id: <20221019083318.937593962@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index f051a73e464a..e04ed60cc9e2 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1061,7 +1061,8 @@ void f2fs_remove_dirty_inode(struct inode *inode)
 	spin_unlock(&sbi->inode_lock[type]);
 }
 
-int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type)
+int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type,
+						bool from_cp)
 {
 	struct list_head *head;
 	struct inode *inode;
@@ -1096,11 +1097,15 @@ int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type)
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
@@ -1229,7 +1234,7 @@ static int block_operations(struct f2fs_sb_info *sbi)
 	/* write all the dirty dentry pages */
 	if (get_pages(sbi, F2FS_DIRTY_DENTS)) {
 		f2fs_unlock_all(sbi);
-		err = f2fs_sync_dirty_inodes(sbi, DIR_INODE);
+		err = f2fs_sync_dirty_inodes(sbi, DIR_INODE, true);
 		if (err)
 			return err;
 		cond_resched();
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index aa3ccddfa037..5e88272d94e4 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2856,7 +2856,7 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
 	}
 	unlock_page(page);
 	if (!S_ISDIR(inode->i_mode) && !IS_NOQUOTA(inode) &&
-			!F2FS_I(inode)->cp_task && allow_balance)
+			!F2FS_I(inode)->wb_task && allow_balance)
 		f2fs_balance_fs(sbi, need_balance_fs);
 
 	if (unlikely(f2fs_cp_error(sbi))) {
@@ -3156,7 +3156,7 @@ static inline bool __should_serialize_io(struct inode *inode,
 					struct writeback_control *wbc)
 {
 	/* to avoid deadlock in path of data flush */
-	if (F2FS_I(inode)->cp_task)
+	if (F2FS_I(inode)->wb_task)
 		return false;
 
 	if (!S_ISREG(inode->i_mode))
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 30fdda714e95..1e57b11ffe2a 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -786,6 +786,7 @@ struct f2fs_inode_info {
 	unsigned int clevel;		/* maximum level of given file name */
 	struct task_struct *task;	/* lookup and create consistency */
 	struct task_struct *cp_task;	/* separate cp/wb IO stats*/
+	struct task_struct *wb_task;	/* indicate inode is in context of writeback */
 	nid_t i_xattr_nid;		/* node id that contains xattrs */
 	loff_t	last_disk_size;		/* lastly written file size */
 	spinlock_t i_size_lock;		/* protect last_disk_size */
@@ -3741,7 +3742,8 @@ int f2fs_recover_orphan_inodes(struct f2fs_sb_info *sbi);
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
index 0de21f82d7bc..84bad18ce13d 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -476,7 +476,7 @@ void f2fs_balance_fs_bg(struct f2fs_sb_info *sbi, bool from_bg)
 		mutex_lock(&sbi->flush_lock);
 
 		blk_start_plug(&plug);
-		f2fs_sync_dirty_inodes(sbi, FILE_INODE);
+		f2fs_sync_dirty_inodes(sbi, FILE_INODE, false);
 		blk_finish_plug(&plug);
 
 		mutex_unlock(&sbi->flush_lock);
-- 
2.35.1



