Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DD92A57C7
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbgKCUwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:52:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731696AbgKCUwa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AEDD22226;
        Tue,  3 Nov 2020 20:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436750;
        bh=hyxzt9qRRw+/nSGT5/670Cuf7JXHIr/LEOXmDgYXJxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIMdRi3RCZCj99ald81oD2jvpbHdcJIM4ObiTO4Lb0rUi6m81j4CEQWmSsCeyHtZd
         XsFTP4zb4VGGGNxPIE2jJvbGmmzzsAaZ8Iz64gduhLwYWuFBc0uBk+y1ZhiTtTbWfo
         3lPYjlAPF9+eiX1clReLM9rBXd3WJS0uyIIP6ijQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangerkun <yangerkun@huawei.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.9 348/391] ext4: do not use extent after put_bh
Date:   Tue,  3 Nov 2020 21:36:39 +0100
Message-Id: <20201103203410.616981887@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

commit d7dce9e08595e80bf8039a81794809c66fe26431 upstream.

ext4_ext_search_right() will read more extent blocks and call put_bh
after we get the information we need.  However, ret_ex will break this
and may cause use-after-free once pagecache has been freed.  Fix it by
copying the extent structure if needed.

Signed-off-by: yangerkun <yangerkun@huawei.com>
Link: https://lore.kernel.org/r/20201028055617.2569255-1-yangerkun@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1472,16 +1472,16 @@ static int ext4_ext_search_left(struct i
 }
 
 /*
- * search the closest allocated block to the right for *logical
- * and returns it at @logical + it's physical address at @phys
- * if *logical is the largest allocated block, the function
- * returns 0 at @phys
- * return value contains 0 (success) or error code
+ * Search the closest allocated block to the right for *logical
+ * and returns it at @logical + it's physical address at @phys.
+ * If not exists, return 0 and @phys is set to 0. We will return
+ * 1 which means we found an allocated block and ret_ex is valid.
+ * Or return a (< 0) error code.
  */
 static int ext4_ext_search_right(struct inode *inode,
 				 struct ext4_ext_path *path,
 				 ext4_lblk_t *logical, ext4_fsblk_t *phys,
-				 struct ext4_extent **ret_ex)
+				 struct ext4_extent *ret_ex)
 {
 	struct buffer_head *bh = NULL;
 	struct ext4_extent_header *eh;
@@ -1575,10 +1575,11 @@ got_index:
 found_extent:
 	*logical = le32_to_cpu(ex->ee_block);
 	*phys = ext4_ext_pblock(ex);
-	*ret_ex = ex;
+	if (ret_ex)
+		*ret_ex = *ex;
 	if (bh)
 		put_bh(bh);
-	return 0;
+	return 1;
 }
 
 /*
@@ -2869,8 +2870,8 @@ again:
 			 */
 			lblk = ex_end + 1;
 			err = ext4_ext_search_right(inode, path, &lblk, &pblk,
-						    &ex);
-			if (err)
+						    NULL);
+			if (err < 0)
 				goto out;
 			if (pblk) {
 				partial.pclu = EXT4_B2C(sbi, pblk);
@@ -4038,7 +4039,7 @@ int ext4_ext_map_blocks(handle_t *handle
 			struct ext4_map_blocks *map, int flags)
 {
 	struct ext4_ext_path *path = NULL;
-	struct ext4_extent newex, *ex, *ex2;
+	struct ext4_extent newex, *ex, ex2;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_fsblk_t newblock = 0, pblk;
 	int err = 0, depth, ret;
@@ -4174,15 +4175,14 @@ int ext4_ext_map_blocks(handle_t *handle
 	if (err)
 		goto out;
 	ar.lright = map->m_lblk;
-	ex2 = NULL;
 	err = ext4_ext_search_right(inode, path, &ar.lright, &ar.pright, &ex2);
-	if (err)
+	if (err < 0)
 		goto out;
 
 	/* Check if the extent after searching to the right implies a
 	 * cluster we can use. */
-	if ((sbi->s_cluster_ratio > 1) && ex2 &&
-	    get_implied_cluster_alloc(inode->i_sb, map, ex2, path)) {
+	if ((sbi->s_cluster_ratio > 1) && err &&
+	    get_implied_cluster_alloc(inode->i_sb, map, &ex2, path)) {
 		ar.len = allocated = map->m_len;
 		newblock = map->m_pblk;
 		goto got_allocated_blocks;


