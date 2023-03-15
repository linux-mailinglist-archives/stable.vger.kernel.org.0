Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6A66BB159
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbjCOM0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbjCOM0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:26:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4242F93E18
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:25:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3512AB81E0E
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B10C4339C;
        Wed, 15 Mar 2023 12:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883129;
        bh=ONK1tTCc4oCgLyfRGy3RUFBIlAgQdteq/+PcqTiOdho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0Gm8E6Y3lMFrZeHRHDfBOx0emHP68zdAiJIu010sZvpQKKhrJBS7OXt++q+IABXF
         XXtFusoujdPsl51X8bSkgWba8qLOx+JWNksvZp99cJmiq7jTT578dlZxTa92vRYISU
         leP440tKLo7k/4NY8g6rWeyqCrdE88AubACAm+SM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/145] f2fs: do not bother checkpoint by f2fs_get_node_info
Date:   Wed, 15 Mar 2023 13:11:32 +0100
Message-Id: <20230315115739.897565982@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit a9419b63bf414775e8aeee95d8c4a5e0df690748 ]

This patch tries to mitigate lock contention between f2fs_write_checkpoint and
f2fs_get_node_info along with nat_tree_lock.

The idea is, if checkpoint is currently running, other threads that try to grab
nat_tree_lock would be better to wait for checkpoint.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 3aa51c61cb4a ("f2fs: retry to update the inode page given data corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c |  2 +-
 fs/f2fs/compress.c   |  2 +-
 fs/f2fs/data.c       |  8 ++++----
 fs/f2fs/f2fs.h       |  2 +-
 fs/f2fs/file.c       |  2 +-
 fs/f2fs/gc.c         |  6 +++---
 fs/f2fs/inline.c     |  4 ++--
 fs/f2fs/inode.c      |  2 +-
 fs/f2fs/node.c       | 19 ++++++++++---------
 fs/f2fs/recovery.c   |  2 +-
 fs/f2fs/segment.c    |  2 +-
 11 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 02840dadde5d4..c68f1f8000f17 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -672,7 +672,7 @@ static int recover_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 	/* truncate all the data during iput */
 	iput(inode);
 
-	err = f2fs_get_node_info(sbi, ino, &ni);
+	err = f2fs_get_node_info(sbi, ino, &ni, false);
 	if (err)
 		goto err_out;
 
diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 6adf047259546..4fa62f98cb515 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1275,7 +1275,7 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 
 	psize = (loff_t)(cc->rpages[last_index]->index + 1) << PAGE_SHIFT;
 
-	err = f2fs_get_node_info(fio.sbi, dn.nid, &ni);
+	err = f2fs_get_node_info(fio.sbi, dn.nid, &ni, false);
 	if (err)
 		goto out_put_dnode;
 
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index ee2909267a33b..524d4b49a5209 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1354,7 +1354,7 @@ static int __allocate_data_block(struct dnode_of_data *dn, int seg_type)
 	if (unlikely(is_inode_flag_set(dn->inode, FI_NO_ALLOC)))
 		return -EPERM;
 
-	err = f2fs_get_node_info(sbi, dn->nid, &ni);
+	err = f2fs_get_node_info(sbi, dn->nid, &ni, false);
 	if (err)
 		return err;
 
@@ -1796,7 +1796,7 @@ static int f2fs_xattr_fiemap(struct inode *inode,
 		if (!page)
 			return -ENOMEM;
 
-		err = f2fs_get_node_info(sbi, inode->i_ino, &ni);
+		err = f2fs_get_node_info(sbi, inode->i_ino, &ni, false);
 		if (err) {
 			f2fs_put_page(page, 1);
 			return err;
@@ -1828,7 +1828,7 @@ static int f2fs_xattr_fiemap(struct inode *inode,
 		if (!page)
 			return -ENOMEM;
 
-		err = f2fs_get_node_info(sbi, xnid, &ni);
+		err = f2fs_get_node_info(sbi, xnid, &ni, false);
 		if (err) {
 			f2fs_put_page(page, 1);
 			return err;
@@ -2688,7 +2688,7 @@ int f2fs_do_write_data_page(struct f2fs_io_info *fio)
 		fio->need_lock = LOCK_REQ;
 	}
 
-	err = f2fs_get_node_info(fio->sbi, dn.nid, &ni);
+	err = f2fs_get_node_info(fio->sbi, dn.nid, &ni, false);
 	if (err)
 		goto out_writepage;
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index a144471c53166..80e4f9afe86f7 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3416,7 +3416,7 @@ int f2fs_need_dentry_mark(struct f2fs_sb_info *sbi, nid_t nid);
 bool f2fs_is_checkpointed_node(struct f2fs_sb_info *sbi, nid_t nid);
 bool f2fs_need_inode_block_update(struct f2fs_sb_info *sbi, nid_t ino);
 int f2fs_get_node_info(struct f2fs_sb_info *sbi, nid_t nid,
-						struct node_info *ni);
+				struct node_info *ni, bool checkpoint_context);
 pgoff_t f2fs_get_next_page_offset(struct dnode_of_data *dn, pgoff_t pgofs);
 int f2fs_get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode);
 int f2fs_truncate_inode_blocks(struct inode *inode, pgoff_t from);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 326c1a4c2a6ac..3be34ea4e2998 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1232,7 +1232,7 @@ static int __clone_blkaddrs(struct inode *src_inode, struct inode *dst_inode,
 			if (ret)
 				return ret;
 
-			ret = f2fs_get_node_info(sbi, dn.nid, &ni);
+			ret = f2fs_get_node_info(sbi, dn.nid, &ni, false);
 			if (ret) {
 				f2fs_put_dnode(&dn);
 				return ret;
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index fa1f5fb750b39..615b109570b05 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -944,7 +944,7 @@ static int gc_node_segment(struct f2fs_sb_info *sbi,
 			continue;
 		}
 
-		if (f2fs_get_node_info(sbi, nid, &ni)) {
+		if (f2fs_get_node_info(sbi, nid, &ni, false)) {
 			f2fs_put_page(node_page, 1);
 			continue;
 		}
@@ -1012,7 +1012,7 @@ static bool is_alive(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 	if (IS_ERR(node_page))
 		return false;
 
-	if (f2fs_get_node_info(sbi, nid, dni)) {
+	if (f2fs_get_node_info(sbi, nid, dni, false)) {
 		f2fs_put_page(node_page, 1);
 		return false;
 	}
@@ -1223,7 +1223,7 @@ static int move_data_block(struct inode *inode, block_t bidx,
 
 	f2fs_wait_on_block_writeback(inode, dn.data_blkaddr);
 
-	err = f2fs_get_node_info(fio.sbi, dn.nid, &ni);
+	err = f2fs_get_node_info(fio.sbi, dn.nid, &ni, false);
 	if (err)
 		goto put_out;
 
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index bce1c2ae6d153..e4fc169a07f55 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -146,7 +146,7 @@ int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page)
 	if (err)
 		return err;
 
-	err = f2fs_get_node_info(fio.sbi, dn->nid, &ni);
+	err = f2fs_get_node_info(fio.sbi, dn->nid, &ni, false);
 	if (err) {
 		f2fs_truncate_data_blocks_range(dn, 1);
 		f2fs_put_dnode(dn);
@@ -797,7 +797,7 @@ int f2fs_inline_data_fiemap(struct inode *inode,
 		ilen = start + len;
 	ilen -= start;
 
-	err = f2fs_get_node_info(F2FS_I_SB(inode), inode->i_ino, &ni);
+	err = f2fs_get_node_info(F2FS_I_SB(inode), inode->i_ino, &ni, false);
 	if (err)
 		goto out;
 
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index bd8960f4966bc..2fa0fcffe0c6d 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -888,7 +888,7 @@ void f2fs_handle_failed_inode(struct inode *inode)
 	 * so we can prevent losing this orphan when encoutering checkpoint
 	 * and following suddenly power-off.
 	 */
-	err = f2fs_get_node_info(sbi, inode->i_ino, &ni);
+	err = f2fs_get_node_info(sbi, inode->i_ino, &ni, false);
 	if (err) {
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		set_inode_flag(inode, FI_FREE_NID);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 7f00f3004a665..89a7f6021c369 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -543,7 +543,7 @@ int f2fs_try_to_free_nats(struct f2fs_sb_info *sbi, int nr_shrink)
 }
 
 int f2fs_get_node_info(struct f2fs_sb_info *sbi, nid_t nid,
-						struct node_info *ni)
+				struct node_info *ni, bool checkpoint_context)
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_HOT_DATA);
@@ -576,9 +576,10 @@ int f2fs_get_node_info(struct f2fs_sb_info *sbi, nid_t nid,
 	 * nat_tree_lock. Therefore, we should retry, if we failed to grab here
 	 * while not bothering checkpoint.
 	 */
-	if (!rwsem_is_locked(&sbi->cp_global_sem)) {
+	if (!rwsem_is_locked(&sbi->cp_global_sem) || checkpoint_context) {
 		down_read(&curseg->journal_rwsem);
-	} else if (!down_read_trylock(&curseg->journal_rwsem)) {
+	} else if (rwsem_is_contended(&nm_i->nat_tree_lock) ||
+				!down_read_trylock(&curseg->journal_rwsem)) {
 		up_read(&nm_i->nat_tree_lock);
 		goto retry;
 	}
@@ -891,7 +892,7 @@ static int truncate_node(struct dnode_of_data *dn)
 	int err;
 	pgoff_t index;
 
-	err = f2fs_get_node_info(sbi, dn->nid, &ni);
+	err = f2fs_get_node_info(sbi, dn->nid, &ni, false);
 	if (err)
 		return err;
 
@@ -1290,7 +1291,7 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 		goto fail;
 
 #ifdef CONFIG_F2FS_CHECK_FS
-	err = f2fs_get_node_info(sbi, dn->nid, &new_ni);
+	err = f2fs_get_node_info(sbi, dn->nid, &new_ni, false);
 	if (err) {
 		dec_valid_node_count(sbi, dn->inode, !ofs);
 		goto fail;
@@ -1356,7 +1357,7 @@ static int read_node_page(struct page *page, int op_flags)
 		return LOCKED_PAGE;
 	}
 
-	err = f2fs_get_node_info(sbi, page->index, &ni);
+	err = f2fs_get_node_info(sbi, page->index, &ni, false);
 	if (err)
 		return err;
 
@@ -1607,7 +1608,7 @@ static int __write_node_page(struct page *page, bool atomic, bool *submitted,
 	nid = nid_of_node(page);
 	f2fs_bug_on(sbi, page->index != nid);
 
-	if (f2fs_get_node_info(sbi, nid, &ni))
+	if (f2fs_get_node_info(sbi, nid, &ni, !do_balance))
 		goto redirty_out;
 
 	if (wbc->for_reclaim) {
@@ -2712,7 +2713,7 @@ int f2fs_recover_xattr_data(struct inode *inode, struct page *page)
 		goto recover_xnid;
 
 	/* 1: invalidate the previous xattr nid */
-	err = f2fs_get_node_info(sbi, prev_xnid, &ni);
+	err = f2fs_get_node_info(sbi, prev_xnid, &ni, false);
 	if (err)
 		return err;
 
@@ -2752,7 +2753,7 @@ int f2fs_recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
 	struct page *ipage;
 	int err;
 
-	err = f2fs_get_node_info(sbi, ino, &old_ni);
+	err = f2fs_get_node_info(sbi, ino, &old_ni, false);
 	if (err)
 		return err;
 
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index ed21e34b59c7f..ba7eeb3c27384 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -604,7 +604,7 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 
 	f2fs_wait_on_page_writeback(dn.node_page, NODE, true, true);
 
-	err = f2fs_get_node_info(sbi, dn.nid, &ni);
+	err = f2fs_get_node_info(sbi, dn.nid, &ni, false);
 	if (err)
 		goto err;
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 194c0811fbdfe..58dd4de41986e 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -253,7 +253,7 @@ static int __revoke_inmem_pages(struct inode *inode,
 				goto next;
 			}
 
-			err = f2fs_get_node_info(sbi, dn.nid, &ni);
+			err = f2fs_get_node_info(sbi, dn.nid, &ni, false);
 			if (err) {
 				f2fs_put_dnode(&dn);
 				return err;
-- 
2.39.2



