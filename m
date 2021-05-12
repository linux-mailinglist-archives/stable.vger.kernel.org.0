Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F050337EDAD
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387953AbhELUlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:41:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383268AbhELTt4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 15:49:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACF9161042;
        Wed, 12 May 2021 19:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620848927;
        bh=UnYEe2B1bivZNwlePRoU4B+/5EMy386SpCPkfCyQzSI=;
        h=From:To:Cc:Subject:Date:From;
        b=T+l6eg9/yZbmlaqBKbsZ4bOkCW91klkMhn23XJR7yu/ZLAdfTZxq4GWYifx/Ii4O3
         K5T2F5oTEqMjbHusDYLUywUMffWGQGQQRz7LUqJ0J7EfDb2XjDvqhL4U+2U51EfTo3
         2lmQb+MwOzXRY8gWecBPhsptoqEOYqR+kvOtxVIxh6d6g6dR6zxOKFne/B9y/y3lC1
         ZZ2pqsMj8GVpbSMeIfCjJXw/47DOX14A4+QL1fpem1BuYDwKsz5fz090Lckqc6bE4N
         XLZUpMdYM5Tmiw/8PwqgCMI+EHew3OJTbMBMWLjWiQXAVNJCzGMDzHgNbCgmNS4pe4
         HWOKJh4504kOA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Yunlei He <heyunlei@hihonor.com>, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.4] f2fs: fix error handling in f2fs_end_enable_verity()
Date:   Wed, 12 May 2021 12:47:14 -0700
Message-Id: <20210512194714.1199896-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 3c0315424f5e3d2a4113c7272367bee1e8e6a174 upstream.

f2fs didn't properly clean up if verity failed to be enabled on a file:

- It left verity metadata (pages past EOF) in the page cache, which
  would be exposed to userspace if the file was later extended.

- It didn't truncate the verity metadata at all (either from cache or
  from disk) if an error occurred while setting the verity bit.

Fix these bugs by adding a call to truncate_inode_pages() and ensuring
that we truncate the verity metadata (both from cache and from disk) in
all error paths.  Also rework the code to cleanly separate the success
path from the error paths, which makes it much easier to understand.

Finally, log a message if f2fs_truncate() fails, since it might
otherwise fail silently.

Reported-by: Yunlei He <heyunlei@hihonor.com>
Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/verity.c | 75 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 54 insertions(+), 21 deletions(-)

diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index a401ef72bc82..7944a08a3977 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -150,40 +150,73 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
 				  size_t desc_size, u64 merkle_tree_size)
 {
 	struct inode *inode = file_inode(filp);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	u64 desc_pos = f2fs_verity_metadata_pos(inode) + merkle_tree_size;
 	struct fsverity_descriptor_location dloc = {
 		.version = cpu_to_le32(1),
 		.size = cpu_to_le32(desc_size),
 		.pos = cpu_to_le64(desc_pos),
 	};
-	int err = 0;
+	int err = 0, err2 = 0;
 
-	if (desc != NULL) {
-		/* Succeeded; write the verity descriptor. */
-		err = pagecache_write(inode, desc, desc_size, desc_pos);
+	/*
+	 * If an error already occurred (which fs/verity/ signals by passing
+	 * desc == NULL), then only clean-up is needed.
+	 */
+	if (desc == NULL)
+		goto cleanup;
 
-		/* Write all pages before clearing FI_VERITY_IN_PROGRESS. */
-		if (!err)
-			err = filemap_write_and_wait(inode->i_mapping);
-	}
+	/* Append the verity descriptor. */
+	err = pagecache_write(inode, desc, desc_size, desc_pos);
+	if (err)
+		goto cleanup;
+
+	/*
+	 * Write all pages (both data and verity metadata).  Note that this must
+	 * happen before clearing FI_VERITY_IN_PROGRESS; otherwise pages beyond
+	 * i_size won't be written properly.  For crash consistency, this also
+	 * must happen before the verity inode flag gets persisted.
+	 */
+	err = filemap_write_and_wait(inode->i_mapping);
+	if (err)
+		goto cleanup;
+
+	/* Set the verity xattr. */
+	err = f2fs_setxattr(inode, F2FS_XATTR_INDEX_VERITY,
+			    F2FS_XATTR_NAME_VERITY, &dloc, sizeof(dloc),
+			    NULL, XATTR_CREATE);
+	if (err)
+		goto cleanup;
 
-	/* If we failed, truncate anything we wrote past i_size. */
-	if (desc == NULL || err)
-		f2fs_truncate(inode);
+	/* Finally, set the verity inode flag. */
+	file_set_verity(inode);
+	f2fs_set_inode_flags(inode);
+	f2fs_mark_inode_dirty_sync(inode, true);
 
 	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
+	return 0;
 
-	if (desc != NULL && !err) {
-		err = f2fs_setxattr(inode, F2FS_XATTR_INDEX_VERITY,
-				    F2FS_XATTR_NAME_VERITY, &dloc, sizeof(dloc),
-				    NULL, XATTR_CREATE);
-		if (!err) {
-			file_set_verity(inode);
-			f2fs_set_inode_flags(inode);
-			f2fs_mark_inode_dirty_sync(inode, true);
-		}
+cleanup:
+	/*
+	 * Verity failed to be enabled, so clean up by truncating any verity
+	 * metadata that was written beyond i_size (both from cache and from
+	 * disk) and clearing FI_VERITY_IN_PROGRESS.
+	 *
+	 * Taking i_gc_rwsem[WRITE] is needed to stop f2fs garbage collection
+	 * from re-instantiating cached pages we are truncating (since unlike
+	 * normal file accesses, garbage collection isn't limited by i_size).
+	 */
+	down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	err2 = f2fs_truncate(inode);
+	if (err2) {
+		f2fs_err(sbi, "Truncating verity metadata failed (errno=%d)",
+			 err2);
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
 	}
-	return err;
+	up_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
+	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
+	return err ?: err2;
 }
 
 static int f2fs_get_verity_descriptor(struct inode *inode, void *buf,
-- 
2.31.1.751.gd2f1c929bd-goog

