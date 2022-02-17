Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1941A4BACF9
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 23:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiBQW7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 17:59:54 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiBQW7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 17:59:48 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7223C28199A
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 14:59:30 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id h125so6271445pgc.3
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 14:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ec9ysQtCokgEK2y8Q18JKH56MFd+lzjJNAwfO6jU5gg=;
        b=TjnOAZ0IoX52pFBp2Kgs7ujLKleAL59kDw772RojwpbHkNeuJPCmgb4dy+STiEaMBB
         qKkVRb5sDfA4Tv5astO6FA4YVfDxc9B4UqMMAa40I22ljEq4HogEcCrmWjLmfLCSwEMH
         n5qIkCPTS2gW8883E1LgQCajn661O7PIfAitCk96U6B1oTyry52QLSiqbu02eLmzgXjx
         kWRPnDIDUhbquXZR4cSuGV0qfKKkN24FpaQF0QpROl1eT/Ik+Gsoc42AajqrFMjyRkl1
         2y52VyXrS5kTvvaxcerbKtFpnotco/aVrz++9aMMhsivcIOJSWBiKqf/HAYA885gY6lf
         psmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ec9ysQtCokgEK2y8Q18JKH56MFd+lzjJNAwfO6jU5gg=;
        b=PefFLIzqlDNRjNxUiBUJmzkP6APw87Gpzw6RVTKcUOugPX1tVg/UywYiht7oHym4l1
         SInvd0gB5f8ZRRbG3HG0RqsLAaW0J1vqXyvg3Jbgz0w63JRgSSic2SdqIhW/aMwqzr7k
         qEp/+ZnGoFuTxR0YscD1zeXUYa7Q09xpGtcNGXERk2VefK4kdJCA2jzprs82INl4xEpd
         wIlaLGyVS2eBl+K1yA32LGN+LUt5DyBOFEAjEnuiFpAD9nCTwKrRihy9KUrBmW4g9/jA
         T/aRL5GVUQB/Q7kkYiXvM15/pTSwc8knazd/J+g9FsUdkg824I/nlh4GOlF6IEhJ5RKn
         0RrQ==
X-Gm-Message-State: AOAM532o+yX49lsjHBJM5ik42411UFD86xis8XuC9w9MZ9+M8GldZGpj
        WX3GO+i8mtAaR6EVmR29Bdsphr8RYNeU+w==
X-Google-Smtp-Source: ABdhPJzP5YnlomRcP4Op2GvhtFmPJOQxH+ot21VndXizhPY0ysjihBjBL4jDlCjEOvKKg0ojeEXfqQ==
X-Received: by 2002:a62:e317:0:b0:4ca:25ee:d633 with SMTP id g23-20020a62e317000000b004ca25eed633mr4935288pfh.23.1645138769634;
        Thu, 17 Feb 2022 14:59:29 -0800 (PST)
Received: from lrumancik-glaptop2.roam.corp.google.com ([2601:647:4701:18d0:9e69:6ca2:e1cf:4ed2])
        by smtp.gmail.com with ESMTPSA id b16sm593260pfv.192.2022.02.17.14.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 14:59:29 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     Zhang Yi <yi.zhang@huawei.com>, Theodore Ts'o <tytso@mit.edu>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH for 5.4 2/3] ext4: check for inconsistent extents between index and leaf block
Date:   Thu, 17 Feb 2022 14:59:13 -0800
Message-Id: <20220217225914.40363-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
In-Reply-To: <20220217225914.40363-1-leah.rumancik@gmail.com>
References: <20220217225914.40363-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

commit 9c6e071913792d80894cd0be98cc3c4b770e26d3 upstream.

Now that we can check out overlapping extents in leaf block and
out-of-order index extents in index block. But the .ee_block in the
first extent of one leaf block should equal to the .ei_block in it's
parent index extent entry. This patch add a check to verify such
inconsistent between the index and leaf block.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://lore.kernel.org/r/20210908120850.4012324-3-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/ext4/extents.c | 59 +++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4f8736b7e497..1ec6d0ccf5ba 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -390,7 +390,8 @@ static int ext4_valid_extent_idx(struct inode *inode,
 
 static int ext4_valid_extent_entries(struct inode *inode,
 				struct ext4_extent_header *eh,
-				ext4_fsblk_t *pblk, int depth)
+				ext4_lblk_t lblk, ext4_fsblk_t *pblk,
+				int depth)
 {
 	unsigned short entries;
 	ext4_lblk_t lblock = 0;
@@ -406,6 +407,14 @@ static int ext4_valid_extent_entries(struct inode *inode,
 		struct ext4_extent *ext = EXT_FIRST_EXTENT(eh);
 		struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
 		ext4_fsblk_t pblock = 0;
+
+		/*
+		 * The logical block in the first entry should equal to
+		 * the number in the index block.
+		 */
+		if (depth != ext_depth(inode) &&
+		    lblk != le32_to_cpu(ext->ee_block))
+			return 0;
 		while (entries) {
 			if (!ext4_valid_extent(inode, ext))
 				return 0;
@@ -423,6 +432,14 @@ static int ext4_valid_extent_entries(struct inode *inode,
 		}
 	} else {
 		struct ext4_extent_idx *ext_idx = EXT_FIRST_INDEX(eh);
+
+		/*
+		 * The logical block in the first entry should equal to
+		 * the number in the parent index block.
+		 */
+		if (depth != ext_depth(inode) &&
+		    lblk != le32_to_cpu(ext_idx->ei_block))
+			return 0;
 		while (entries) {
 			if (!ext4_valid_extent_idx(inode, ext_idx))
 				return 0;
@@ -443,7 +460,7 @@ static int ext4_valid_extent_entries(struct inode *inode,
 
 static int __ext4_ext_check(const char *function, unsigned int line,
 			    struct inode *inode, struct ext4_extent_header *eh,
-			    int depth, ext4_fsblk_t pblk)
+			    int depth, ext4_fsblk_t pblk, ext4_lblk_t lblk)
 {
 	const char *error_msg;
 	int max = 0, err = -EFSCORRUPTED;
@@ -469,7 +486,7 @@ static int __ext4_ext_check(const char *function, unsigned int line,
 		error_msg = "invalid eh_entries";
 		goto corrupted;
 	}
-	if (!ext4_valid_extent_entries(inode, eh, &pblk, depth)) {
+	if (!ext4_valid_extent_entries(inode, eh, lblk, &pblk, depth)) {
 		error_msg = "invalid extent entries";
 		goto corrupted;
 	}
@@ -498,7 +515,7 @@ static int __ext4_ext_check(const char *function, unsigned int line,
 }
 
 #define ext4_ext_check(inode, eh, depth, pblk)			\
-	__ext4_ext_check(__func__, __LINE__, (inode), (eh), (depth), (pblk))
+	__ext4_ext_check(__func__, __LINE__, (inode), (eh), (depth), (pblk), 0)
 
 int ext4_ext_check_inode(struct inode *inode)
 {
@@ -531,12 +548,14 @@ static void ext4_cache_extents(struct inode *inode,
 
 static struct buffer_head *
 __read_extent_tree_block(const char *function, unsigned int line,
-			 struct inode *inode, ext4_fsblk_t pblk, int depth,
-			 int flags)
+			 struct inode *inode, struct ext4_extent_idx *idx,
+			 int depth, int flags)
 {
 	struct buffer_head		*bh;
 	int				err;
+	ext4_fsblk_t			pblk;
 
+	pblk = ext4_idx_pblock(idx);
 	bh = sb_getblk_gfp(inode->i_sb, pblk, __GFP_MOVABLE | GFP_NOFS);
 	if (unlikely(!bh))
 		return ERR_PTR(-ENOMEM);
@@ -552,8 +571,8 @@ __read_extent_tree_block(const char *function, unsigned int line,
 	if (!ext4_has_feature_journal(inode->i_sb) ||
 	    (inode->i_ino !=
 	     le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_journal_inum))) {
-		err = __ext4_ext_check(function, line, inode,
-				       ext_block_hdr(bh), depth, pblk);
+		err = __ext4_ext_check(function, line, inode, ext_block_hdr(bh),
+				       depth, pblk, le32_to_cpu(idx->ei_block));
 		if (err)
 			goto errout;
 	}
@@ -572,8 +591,8 @@ __read_extent_tree_block(const char *function, unsigned int line,
 
 }
 
-#define read_extent_tree_block(inode, pblk, depth, flags)		\
-	__read_extent_tree_block(__func__, __LINE__, (inode), (pblk),   \
+#define read_extent_tree_block(inode, idx, depth, flags)		\
+	__read_extent_tree_block(__func__, __LINE__, (inode), (idx),	\
 				 (depth), (flags))
 
 /*
@@ -620,8 +639,7 @@ int ext4_ext_precache(struct inode *inode)
 			i--;
 			continue;
 		}
-		bh = read_extent_tree_block(inode,
-					    ext4_idx_pblock(path[i].p_idx++),
+		bh = read_extent_tree_block(inode, path[i].p_idx++,
 					    depth - i - 1,
 					    EXT4_EX_FORCE_CACHE);
 		if (IS_ERR(bh)) {
@@ -924,8 +942,7 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 		path[ppos].p_depth = i;
 		path[ppos].p_ext = NULL;
 
-		bh = read_extent_tree_block(inode, path[ppos].p_block, --i,
-					    flags);
+		bh = read_extent_tree_block(inode, path[ppos].p_idx, --i, flags);
 		if (IS_ERR(bh)) {
 			ret = PTR_ERR(bh);
 			goto err;
@@ -1524,7 +1541,6 @@ static int ext4_ext_search_right(struct inode *inode,
 	struct ext4_extent_header *eh;
 	struct ext4_extent_idx *ix;
 	struct ext4_extent *ex;
-	ext4_fsblk_t block;
 	int depth;	/* Note, NOT eh_depth; depth from top of tree */
 	int ee_len;
 
@@ -1591,20 +1607,17 @@ static int ext4_ext_search_right(struct inode *inode,
 	 * follow it and find the closest allocated
 	 * block to the right */
 	ix++;
-	block = ext4_idx_pblock(ix);
 	while (++depth < path->p_depth) {
 		/* subtract from p_depth to get proper eh_depth */
-		bh = read_extent_tree_block(inode, block,
-					    path->p_depth - depth, 0);
+		bh = read_extent_tree_block(inode, ix, path->p_depth - depth, 0);
 		if (IS_ERR(bh))
 			return PTR_ERR(bh);
 		eh = ext_block_hdr(bh);
 		ix = EXT_FIRST_INDEX(eh);
-		block = ext4_idx_pblock(ix);
 		put_bh(bh);
 	}
 
-	bh = read_extent_tree_block(inode, block, path->p_depth - depth, 0);
+	bh = read_extent_tree_block(inode, ix, path->p_depth - depth, 0);
 	if (IS_ERR(bh))
 		return PTR_ERR(bh);
 	eh = ext_block_hdr(bh);
@@ -3126,9 +3139,9 @@ int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 			ext_debug("move to level %d (block %llu)\n",
 				  i + 1, ext4_idx_pblock(path[i].p_idx));
 			memset(path + i + 1, 0, sizeof(*path));
-			bh = read_extent_tree_block(inode,
-				ext4_idx_pblock(path[i].p_idx), depth - i - 1,
-				EXT4_EX_NOCACHE);
+			bh = read_extent_tree_block(inode, path[i].p_idx,
+						    depth - i - 1,
+						    EXT4_EX_NOCACHE);
 			if (IS_ERR(bh)) {
 				/* should we reset i_size? */
 				err = PTR_ERR(bh);
-- 
2.35.1.473.g83b2b277ed-goog

