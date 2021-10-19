Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3214329A2
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 00:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbhJRWRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 18:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRWRv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 18:17:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE80D6112D;
        Mon, 18 Oct 2021 22:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634595340;
        bh=hueLNYj98ZKaYwELlNhSnvgesoXLZzWOy/TnCQXvhZY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=M+v9hQGU07kgX+UNGNagMcmZN208Rjjn3NVpKwmp4EcDNDJWtOPnsmbTKQdpslrGJ
         fktTZNvuHfhRWJrM091WyGyy1We/J70sl0FDHxteQcZ+ACu2qUzy1DLmSZZcfPo+5g
         Ntah3ExPOT/PkGq7oLQIYx8s6gBeb7UdKQVgqqxo=
Date:   Mon, 18 Oct 2021 15:15:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jack@suse.cz, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        Markov.Andrey@Dell.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 06/19] ocfs2: fix data corruption after conversion
 from inline format
Message-ID: <20211018221539.A9JVM0ye7%akpm@linux-foundation.org>
In-Reply-To: <20211018151438.f2246e2656c041b6753a8bdd@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>
Subject: ocfs2: fix data corruption after conversion from inline format

Commit 6dbf7bb55598 ("fs: Don't invalidate page buffers in
block_write_full_page()") uncovered a latent bug in ocfs2 conversion
from inline inode format to a normal inode format.

The code in
ocfs2_convert_inline_data_to_extents() attempts to zero out the whole
cluster allocated for file data by grabbing, zeroing, and dirtying all
pages covering this cluster. However these pages are beyond i_size, thus
writeback code generally ignores these dirty pages and no blocks were
ever actually zeroed on the disk.

This oversight was fixed by commit 693c241a5f6a ("ocfs2: No need to zero
pages past i_size.") for standard ocfs2 write path, inline conversion path
was apparently forgotten; the commit log also has a reasoning why the
zeroing actually is not needed.

After commit 6dbf7bb55598, things became worse as writeback code stopped
invalidating buffers on pages beyond i_size and thus these pages end up
with clean PageDirty bit but with buffers attached to these pages being
still dirty.  So when a file is converted from inline format, then
writeback triggers, and then the file is grown so that these pages become
valid, the invalid dirtiness state is preserved, mark_buffer_dirty() does
nothing on these pages (buffers are already dirty) but page is never
written back because it is clean.  So data written to these pages is lost
once pages are reclaimed.

Simple reproducer for the problem is:

xfs_io -f -c "pwrite 0 2000" -c "pwrite 2000 2000" -c "fsync" \
  -c "pwrite 4000 2000" ocfs2_file

After unmounting and mounting the fs again, you can observe that end of
'ocfs2_file' has lost its contents.

Fix the problem by not doing the pointless zeroing during conversion
from inline format similarly as in the standard write path.

[akpm@linux-foundation.org: fix whitespace, per Joseph]
Link: https://lkml.kernel.org/r/20210930095405.21433-1-jack@suse.cz
Fixes: 6dbf7bb55598 ("fs: Don't invalidate page buffers in block_write_full_page()")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Acked-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: "Markov, Andrey" <Markov.Andrey@Dell.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   46 +++++++++++----------------------------------
 1 file changed, 12 insertions(+), 34 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-fix-data-corruption-after-conversion-from-inline-format
+++ a/fs/ocfs2/alloc.c
@@ -7045,7 +7045,7 @@ void ocfs2_set_inode_data_inline(struct
 int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 					 struct buffer_head *di_bh)
 {
-	int ret, i, has_data, num_pages = 0;
+	int ret, has_data, num_pages = 0;
 	int need_free = 0;
 	u32 bit_off, num;
 	handle_t *handle;
@@ -7054,26 +7054,17 @@ int ocfs2_convert_inline_data_to_extents
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_alloc_context *data_ac = NULL;
-	struct page **pages = NULL;
-	loff_t end = osb->s_clustersize;
+	struct page *page = NULL;
 	struct ocfs2_extent_tree et;
 	int did_quota = 0;
 
 	has_data = i_size_read(inode) ? 1 : 0;
 
 	if (has_data) {
-		pages = kcalloc(ocfs2_pages_per_cluster(osb->sb),
-				sizeof(struct page *), GFP_NOFS);
-		if (pages == NULL) {
-			ret = -ENOMEM;
-			mlog_errno(ret);
-			return ret;
-		}
-
 		ret = ocfs2_reserve_clusters(osb, 1, &data_ac);
 		if (ret) {
 			mlog_errno(ret);
-			goto free_pages;
+			goto out;
 		}
 	}
 
@@ -7093,7 +7084,8 @@ int ocfs2_convert_inline_data_to_extents
 	}
 
 	if (has_data) {
-		unsigned int page_end;
+		unsigned int page_end = min_t(unsigned, PAGE_SIZE,
+							osb->s_clustersize);
 		u64 phys;
 
 		ret = dquot_alloc_space_nodirty(inode,
@@ -7117,15 +7109,8 @@ int ocfs2_convert_inline_data_to_extents
 		 */
 		block = phys = ocfs2_clusters_to_blocks(inode->i_sb, bit_off);
 
-		/*
-		 * Non sparse file systems zero on extend, so no need
-		 * to do that now.
-		 */
-		if (!ocfs2_sparse_alloc(osb) &&
-		    PAGE_SIZE < osb->s_clustersize)
-			end = PAGE_SIZE;
-
-		ret = ocfs2_grab_eof_pages(inode, 0, end, pages, &num_pages);
+		ret = ocfs2_grab_eof_pages(inode, 0, page_end, &page,
+					   &num_pages);
 		if (ret) {
 			mlog_errno(ret);
 			need_free = 1;
@@ -7136,20 +7121,15 @@ int ocfs2_convert_inline_data_to_extents
 		 * This should populate the 1st page for us and mark
 		 * it up to date.
 		 */
-		ret = ocfs2_read_inline_data(inode, pages[0], di_bh);
+		ret = ocfs2_read_inline_data(inode, page, di_bh);
 		if (ret) {
 			mlog_errno(ret);
 			need_free = 1;
 			goto out_unlock;
 		}
 
-		page_end = PAGE_SIZE;
-		if (PAGE_SIZE > osb->s_clustersize)
-			page_end = osb->s_clustersize;
-
-		for (i = 0; i < num_pages; i++)
-			ocfs2_map_and_dirty_page(inode, handle, 0, page_end,
-						 pages[i], i > 0, &phys);
+		ocfs2_map_and_dirty_page(inode, handle, 0, page_end, page, 0,
+					 &phys);
 	}
 
 	spin_lock(&oi->ip_lock);
@@ -7180,8 +7160,8 @@ int ocfs2_convert_inline_data_to_extents
 	}
 
 out_unlock:
-	if (pages)
-		ocfs2_unlock_and_free_pages(pages, num_pages);
+	if (page)
+		ocfs2_unlock_and_free_pages(&page, num_pages);
 
 out_commit:
 	if (ret < 0 && did_quota)
@@ -7205,8 +7185,6 @@ out_commit:
 out:
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
-free_pages:
-	kfree(pages);
 	return ret;
 }
 
_
