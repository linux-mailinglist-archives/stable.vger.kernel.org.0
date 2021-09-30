Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC79B41D6DA
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 11:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbhI3Jzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 05:55:55 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33132 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349469AbhI3Jzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 05:55:54 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D046D223D7;
        Thu, 30 Sep 2021 09:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1632995651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=OlSe9HVku8aP2I6Cd6EqCx9yl2w0GSSujbR/3ZH9f2o=;
        b=yY0GZ5t8l1Oj3Mvf6tKUVBkDc9rE36Xf1PqIsN/YqIsb/Me5xNjw1WDrz3urioWglhy7Yu
        S9xp8lpNHIRJGXMAchPxWAp91CF/PvclJzz+mwshspxbkFYzHyZ7kgqJ2sFq3o7HnDGyef
        2SPLONXl3uT+gB/dHIo/BhrghovcKPM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1632995651;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=OlSe9HVku8aP2I6Cd6EqCx9yl2w0GSSujbR/3ZH9f2o=;
        b=Br2SYbz99unVviy0cGSrixm88a0DWcdDC+Bunzuw+OpWYFCHMhbujAk39PpHzFPw5c+8b8
        N28HZ8Mifw0ssCCQ==
Received: from quack2.suse.cz (unknown [10.100.200.198])
        by relay2.suse.de (Postfix) with ESMTP id 76C0EA3B81;
        Thu, 30 Sep 2021 09:54:08 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 7EC8B1E1265; Thu, 30 Sep 2021 11:54:10 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     ocfs2-devel@oss.oracle.com
Cc:     Gang He <ghe@suse.com>, Joseph Qi <joseph.qi@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH] ocfs2: Fix data corruption after conversion from inline format
Date:   Thu, 30 Sep 2021 11:54:05 +0200
Message-Id: <20210930095405.21433-1-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5403; h=from:subject; bh=EGTqdsQlbE1oRmSuK4BOZS4yriZEIEfmxRqC+gJwdK4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBhVYk1iflaaOzXW6jwttlVNGzcLpstiG3TgQY05EbY U2rqvcuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYVWJNQAKCRCcnaoHP2RA2aWtCA Da64UGDUmn61X1sga78SHusskCHmaegVneb3x79YZOAON0W9xyF8UZL5WRo+xJWoK9s/mkCRUMP7cs PkoI5g/ViBO1U+t24ZLI+lY8++aR1ojRs1d5j+CO5YNuNHsjKOrrBj88UhYOKh9ajI5BX0WhuHQnya 2md6Y22GC17e6xTSEkzz5G7LGKJrgyLNdpmaBzdvJjtK8NHEMVKfFkEOfyaR7HXgO0wea5OlimEN/2 OXHFSmrsVAEtc5arH4evbPbsWOJfUXYwmwKJG01XlPhnIJiK2IwBQ9MKl7K9M6+9wFbmR1cyg52E/t Ho3M7x71bTAQSJz8rXWK6sQhqjbADh
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 6dbf7bb55598 ("fs: Don't invalidate page buffers in
block_write_full_page()") uncovered a latent bug in ocfs2 conversion
from inline inode format to a normal inode format. The code in
ocfs2_convert_inline_data_to_extents() attempts to zero out the whole
cluster allocated for file data by grabbing, zeroing, and dirtying all
pages covering this cluster. However these pages are beyond i_size, thus
writeback code generally ignores these dirty pages and no blocks were
ever actually zeroed on the disk. This oversight was fixed by commit
693c241a5f6a ("ocfs2: No need to zero pages past i_size.") for standard
ocfs2 write path, inline conversion path was apparently forgotten; the
commit log also has a reasoning why the zeroing actually is not needed.
After commit 6dbf7bb55598, things became worse as writeback code stopped
invalidating buffers on pages beyond i_size and thus these pages end up
with clean PageDirty bit but with buffers attached to these pages being
still dirty. So when a file is converted from inline format, then
writeback triggers, and then the file is grown so that these pages
become valid, the invalid dirtiness state is preserved,
mark_buffer_dirty() does nothing on these pages (buffers are already
dirty) but page is never written back because it is clean. So data
written to these pages is lost once pages are reclaimed.

Simple reproducer for the problem is:

xfs_io -f -c "pwrite 0 2000" -c "pwrite 2000 2000" -c "fsync" \
  -c "pwrite 4000 2000" ocfs2_file

After unmounting and mounting the fs again, you can observe that end of
'ocfs2_file' has lost its contents.

Fix the problem by not doing the pointless zeroing during conversion
from inline format similarly as in the standard write path.

CC: stable@vger.kernel.org
Fixes: 6dbf7bb55598 ("fs: Don't invalidate page buffers in block_write_full_page()")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/alloc.c | 46 ++++++++++++----------------------------------
 1 file changed, 12 insertions(+), 34 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index f1cc8258d34a..12aead0dabe2 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7045,7 +7045,7 @@ void ocfs2_set_inode_data_inline(struct inode *inode, struct ocfs2_dinode *di)
 int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 					 struct buffer_head *di_bh)
 {
-	int ret, i, has_data, num_pages = 0;
+	int ret,has_data, num_pages = 0;
 	int need_free = 0;
 	u32 bit_off, num;
 	handle_t *handle;
@@ -7054,26 +7054,17 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
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
 
@@ -7093,7 +7084,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 	}
 
 	if (has_data) {
-		unsigned int page_end;
+		unsigned int page_end = min_t(unsigned, PAGE_SIZE,
+							osb->s_clustersize);
 		u64 phys;
 
 		ret = dquot_alloc_space_nodirty(inode,
@@ -7117,15 +7109,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
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
@@ -7136,20 +7121,15 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
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
@@ -7180,8 +7160,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 	}
 
 out_unlock:
-	if (pages)
-		ocfs2_unlock_and_free_pages(pages, num_pages);
+	if (page)
+		ocfs2_unlock_and_free_pages(&page, num_pages);
 
 out_commit:
 	if (ret < 0 && did_quota)
@@ -7205,8 +7185,6 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 out:
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
-free_pages:
-	kfree(pages);
 	return ret;
 }
 
-- 
2.26.2

