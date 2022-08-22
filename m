Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0024859BD5F
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 12:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbiHVKJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 06:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbiHVKJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 06:09:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22A2386
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 03:09:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4564DB80EDD
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 10:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E98EC433D6;
        Mon, 22 Aug 2022 10:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661162957;
        bh=/TyLCFSAXkJb1f2m3gI4hmB6bGNIEBN8gYD7VygEU+Q=;
        h=Subject:To:Cc:From:Date:From;
        b=xa30vLQAv09JD3EFMHWM7do1uqNen/Ue6fdPqjJDDpezsdkxVZNXnKXLofOZUPRCg
         sPgSNmA5Rq6LFlDJdyEH3kzeU9OLGt7yg5ToNnWbeyub0W0QXBGXEfRssSAsg8A7b6
         jjbFMj4KYh3rqzVnkOUzdtCiQ+OMgqTckphFSv64=
Subject: FAILED: patch "[PATCH] fs/ntfs3: Enable FALLOC_FL_INSERT_RANGE" failed to apply to 5.15-stable tree
To:     almaz.alexandrovich@paragon-software.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 12:09:14 +0200
Message-ID: <16611629546826@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e4d2f4fd5341064d2b3c5158da69421a581e7ec1 Mon Sep 17 00:00:00 2001
From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Date: Tue, 21 Jun 2022 12:49:52 +0300
Subject: [PATCH] fs/ntfs3: Enable FALLOC_FL_INSERT_RANGE

Changed logic in ntfs_fallocate - more clear checks in beginning
instead of the middle of function and added FALLOC_FL_INSERT_RANGE.
Fixes xfstest generic/064
Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 27c32692513c..bdffe4b8554b 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -533,21 +533,35 @@ static int ntfs_truncate(struct inode *inode, loff_t new_size)
 static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 {
 	struct inode *inode = file->f_mapping->host;
+	struct address_space *mapping = inode->i_mapping;
 	struct super_block *sb = inode->i_sb;
 	struct ntfs_sb_info *sbi = sb->s_fs_info;
 	struct ntfs_inode *ni = ntfs_i(inode);
 	loff_t end = vbo + len;
 	loff_t vbo_down = round_down(vbo, PAGE_SIZE);
-	loff_t i_size;
+	bool is_supported_holes = is_sparsed(ni) || is_compressed(ni);
+	loff_t i_size, new_size;
+	bool map_locked;
 	int err;
 
 	/* No support for dir. */
 	if (!S_ISREG(inode->i_mode))
 		return -EOPNOTSUPP;
 
-	/* Return error if mode is not supported. */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
-		     FALLOC_FL_COLLAPSE_RANGE)) {
+	/*
+	 * vfs_fallocate checks all possible combinations of mode.
+	 * Do additional checks here before ntfs_set_state(dirty).
+	 */
+	if (mode & FALLOC_FL_PUNCH_HOLE) {
+		if (!is_supported_holes)
+			return -EOPNOTSUPP;
+	} else if (mode & FALLOC_FL_COLLAPSE_RANGE) {
+	} else if (mode & FALLOC_FL_INSERT_RANGE) {
+		if (!is_supported_holes)
+			return -EOPNOTSUPP;
+	} else if (mode &
+		   ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
+		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE)) {
 		ntfs_inode_warn(inode, "fallocate(0x%x) is not supported",
 				mode);
 		return -EOPNOTSUPP;
@@ -557,6 +571,8 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 
 	inode_lock(inode);
 	i_size = inode->i_size;
+	new_size = max(end, i_size);
+	map_locked = false;
 
 	if (WARN_ON(ni->ni_flags & NI_FLAG_COMPRESSED_MASK)) {
 		/* Should never be here, see ntfs_file_open. */
@@ -564,38 +580,27 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 		goto out;
 	}
 
+	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE |
+		    FALLOC_FL_INSERT_RANGE)) {
+		inode_dio_wait(inode);
+		filemap_invalidate_lock(mapping);
+		map_locked = true;
+	}
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		u32 frame_size;
 		loff_t mask, vbo_a, end_a, tmp;
 
-		if (!(mode & FALLOC_FL_KEEP_SIZE)) {
-			err = -EINVAL;
-			goto out;
-		}
-
-		err = filemap_write_and_wait_range(inode->i_mapping, vbo,
-						   end - 1);
+		err = filemap_write_and_wait_range(mapping, vbo, end - 1);
 		if (err)
 			goto out;
 
-		err = filemap_write_and_wait_range(inode->i_mapping, end,
-						   LLONG_MAX);
+		err = filemap_write_and_wait_range(mapping, end, LLONG_MAX);
 		if (err)
 			goto out;
 
-		inode_dio_wait(inode);
-
 		truncate_pagecache(inode, vbo_down);
 
-		if (!is_sparsed(ni) && !is_compressed(ni)) {
-			/*
-			 * Normal file, can't make hole.
-			 * TODO: Try to find way to save info about hole.
-			 */
-			err = -EOPNOTSUPP;
-			goto out;
-		}
-
 		ni_lock(ni);
 		err = attr_punch_hole(ni, vbo, len, &frame_size);
 		ni_unlock(ni);
@@ -627,17 +632,11 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 			ni_unlock(ni);
 		}
 	} else if (mode & FALLOC_FL_COLLAPSE_RANGE) {
-		if (mode & ~FALLOC_FL_COLLAPSE_RANGE) {
-			err = -EINVAL;
-			goto out;
-		}
-
 		/*
 		 * Write tail of the last page before removed range since
 		 * it will get removed from the page cache below.
 		 */
-		err = filemap_write_and_wait_range(inode->i_mapping, vbo_down,
-						   vbo);
+		err = filemap_write_and_wait_range(mapping, vbo_down, vbo);
 		if (err)
 			goto out;
 
@@ -645,34 +644,45 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 		 * Write data that will be shifted to preserve them
 		 * when discarding page cache below.
 		 */
-		err = filemap_write_and_wait_range(inode->i_mapping, end,
-						   LLONG_MAX);
+		err = filemap_write_and_wait_range(mapping, end, LLONG_MAX);
 		if (err)
 			goto out;
 
-		/* Wait for existing dio to complete. */
-		inode_dio_wait(inode);
-
 		truncate_pagecache(inode, vbo_down);
 
 		ni_lock(ni);
 		err = attr_collapse_range(ni, vbo, len);
 		ni_unlock(ni);
-	} else {
-		/*
-		 * Normal file: Allocate clusters, do not change 'valid' size.
-		 */
-		loff_t new_size = max(end, i_size);
+	} else if (mode & FALLOC_FL_INSERT_RANGE) {
+		/* Check new size. */
+		err = inode_newsize_ok(inode, new_size);
+		if (err)
+			goto out;
+
+		/* Write out all dirty pages. */
+		err = filemap_write_and_wait_range(mapping, vbo_down,
+						   LLONG_MAX);
+		if (err)
+			goto out;
+		truncate_pagecache(inode, vbo_down);
 
+		ni_lock(ni);
+		err = attr_insert_range(ni, vbo, len);
+		ni_unlock(ni);
+	} else {
+		/* Check new size. */
 		err = inode_newsize_ok(inode, new_size);
 		if (err)
 			goto out;
 
+		/*
+		 * Allocate clusters, do not change 'valid' size.
+		 */
 		err = ntfs_set_size(inode, new_size);
 		if (err)
 			goto out;
 
-		if (is_sparsed(ni) || is_compressed(ni)) {
+		if (is_supported_holes) {
 			CLST vcn_v = ni->i_valid >> sbi->cluster_bits;
 			CLST vcn = vbo >> sbi->cluster_bits;
 			CLST cend = bytes_to_cluster(sbi, end);
@@ -720,6 +730,9 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 	}
 
 out:
+	if (map_locked)
+		filemap_invalidate_unlock(mapping);
+
 	if (err == -EFBIG)
 		err = -ENOSPC;
 

