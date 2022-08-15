Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB1C592E1D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 13:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiHOLZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 07:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241773AbiHOLYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 07:24:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EFB22B2E
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 04:24:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 017C161155
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 11:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05311C433D6;
        Mon, 15 Aug 2022 11:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660562692;
        bh=uOteamPHCSOXUDcNeJPIHAhXV7dUdqyjJenXiSfEee4=;
        h=Subject:To:Cc:From:Date:From;
        b=tKpPvh+pGkomqBjdb3R/ukBgelqNp26MlRet/VrleftN7nRu/DAc4cYJ/+4947KG/
         4iuV+C3bitdRWv1q8BrWGHEFlLszvJjWCYcDyad+cEngEs6Aucn+9hGH6rFBIvxv4t
         RUG9DCB5tI4ZqfEAQp8+et/g9TICJ+Fx1fpN/d2Q=
Subject: FAILED: patch "[PATCH] ext4: unindent codeblock in ext4_xattr_block_set()" failed to apply to 5.4-stable tree
To:     jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 13:24:41 +0200
Message-ID: <1660562681106188@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fd48e9acdf26d0cbd80051de07d4a735d05d29b2 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 12 Jul 2022 12:54:23 +0200
Subject: [PATCH] ext4: unindent codeblock in ext4_xattr_block_set()

Remove unnecessary else (and thus indentation level) from a code block
in ext4_xattr_block_set(). It will also make following code changes
easier. No functional changes.

CC: stable@vger.kernel.org
Fixes: 82939d7999df ("ext4: convert to mbcache2")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220712105436.32204-4-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index d92d50de5a01..a25942a74929 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1850,6 +1850,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 #define header(x) ((struct ext4_xattr_header *)(x))
 
 	if (s->base) {
+		int offset = (char *)s->here - bs->bh->b_data;
+
 		BUFFER_TRACE(bs->bh, "get_write_access");
 		error = ext4_journal_get_write_access(handle, sb, bs->bh,
 						      EXT4_JTR_NONE);
@@ -1882,49 +1884,46 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			if (error)
 				goto cleanup;
 			goto inserted;
-		} else {
-			int offset = (char *)s->here - bs->bh->b_data;
+		}
+		unlock_buffer(bs->bh);
+		ea_bdebug(bs->bh, "cloning");
+		s->base = kmemdup(BHDR(bs->bh), bs->bh->b_size, GFP_NOFS);
+		error = -ENOMEM;
+		if (s->base == NULL)
+			goto cleanup;
+		s->first = ENTRY(header(s->base)+1);
+		header(s->base)->h_refcount = cpu_to_le32(1);
+		s->here = ENTRY(s->base + offset);
+		s->end = s->base + bs->bh->b_size;
 
-			unlock_buffer(bs->bh);
-			ea_bdebug(bs->bh, "cloning");
-			s->base = kmemdup(BHDR(bs->bh), bs->bh->b_size, GFP_NOFS);
-			error = -ENOMEM;
-			if (s->base == NULL)
+		/*
+		 * If existing entry points to an xattr inode, we need
+		 * to prevent ext4_xattr_set_entry() from decrementing
+		 * ref count on it because the reference belongs to the
+		 * original block. In this case, make the entry look
+		 * like it has an empty value.
+		 */
+		if (!s->not_found && s->here->e_value_inum) {
+			ea_ino = le32_to_cpu(s->here->e_value_inum);
+			error = ext4_xattr_inode_iget(inode, ea_ino,
+				      le32_to_cpu(s->here->e_hash),
+				      &tmp_inode);
+			if (error)
 				goto cleanup;
-			s->first = ENTRY(header(s->base)+1);
-			header(s->base)->h_refcount = cpu_to_le32(1);
-			s->here = ENTRY(s->base + offset);
-			s->end = s->base + bs->bh->b_size;
 
-			/*
-			 * If existing entry points to an xattr inode, we need
-			 * to prevent ext4_xattr_set_entry() from decrementing
-			 * ref count on it because the reference belongs to the
-			 * original block. In this case, make the entry look
-			 * like it has an empty value.
-			 */
-			if (!s->not_found && s->here->e_value_inum) {
-				ea_ino = le32_to_cpu(s->here->e_value_inum);
-				error = ext4_xattr_inode_iget(inode, ea_ino,
-					      le32_to_cpu(s->here->e_hash),
-					      &tmp_inode);
-				if (error)
-					goto cleanup;
-
-				if (!ext4_test_inode_state(tmp_inode,
-						EXT4_STATE_LUSTRE_EA_INODE)) {
-					/*
-					 * Defer quota free call for previous
-					 * inode until success is guaranteed.
-					 */
-					old_ea_inode_quota = le32_to_cpu(
-							s->here->e_value_size);
-				}
-				iput(tmp_inode);
-
-				s->here->e_value_inum = 0;
-				s->here->e_value_size = 0;
+			if (!ext4_test_inode_state(tmp_inode,
+					EXT4_STATE_LUSTRE_EA_INODE)) {
+				/*
+				 * Defer quota free call for previous
+				 * inode until success is guaranteed.
+				 */
+				old_ea_inode_quota = le32_to_cpu(
+						s->here->e_value_size);
 			}
+			iput(tmp_inode);
+
+			s->here->e_value_inum = 0;
+			s->here->e_value_size = 0;
 		}
 	} else {
 		/* Allocate a buffer where we construct the new block. */

