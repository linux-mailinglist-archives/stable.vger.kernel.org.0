Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A6C592E24
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 13:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241453AbiHOLZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 07:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbiHOLZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 07:25:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9AE2019B
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 04:25:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7068261163
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 11:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C118C433D6;
        Mon, 15 Aug 2022 11:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660562711;
        bh=8D3v9nxbomHWSieiU3l0JyWVLRYMylpyz5RYrC5sITs=;
        h=Subject:To:Cc:From:Date:From;
        b=B7EwZiaecRVyfUoG637h40h4qebJ7EXHYIKAYExCQfZyLaKwMFX75zQKFca4r7twZ
         +yGqEC/Z+hGOOuHzz809x4jWYO+gtDX+ewSIF1v5lQZ6P6ctp8pV0Bql2WWGYvKETF
         VeXyOmST+jVraGn/pAL5+eSOj8GHZSGLvYhe6zjg=
Subject: FAILED: patch "[PATCH] ext4: fix race when reusing xattr blocks" failed to apply to 4.14-stable tree
To:     jack@suse.cz, ritesh.list@gmail.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 13:24:53 +0200
Message-ID: <16605626931232@kroah.com>
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 65f8b80053a1b2fd602daa6814e62d6fa90e5e9b Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 12 Jul 2022 12:54:24 +0200
Subject: [PATCH] ext4: fix race when reusing xattr blocks

When ext4_xattr_block_set() decides to remove xattr block the following
race can happen:

CPU1                                    CPU2
ext4_xattr_block_set()                  ext4_xattr_release_block()
  new_bh = ext4_xattr_block_cache_find()

                                          lock_buffer(bh);
                                          ref = le32_to_cpu(BHDR(bh)->h_refcount);
                                          if (ref == 1) {
                                            ...
                                            mb_cache_entry_delete();
                                            unlock_buffer(bh);
                                            ext4_free_blocks();
                                              ...
                                              ext4_forget(..., bh, ...);
                                                jbd2_journal_revoke(..., bh);

  ext4_journal_get_write_access(..., new_bh, ...)
    do_get_write_access()
      jbd2_journal_cancel_revoke(..., new_bh);

Later the code in ext4_xattr_block_set() finds out the block got freed
and cancels reusal of the block but the revoke stays canceled and so in
case of block reuse and journal replay the filesystem can get corrupted.
If the race works out slightly differently, we can also hit assertions
in the jbd2 code.

Fix the problem by making sure that once matching mbcache entry is
found, code dropping the last xattr block reference (or trying to modify
xattr block in place) waits until the mbcache entry reference is
dropped. This way code trying to reuse xattr block is protected from
someone trying to drop the last reference to xattr block.

Reported-and-tested-by: Ritesh Harjani <ritesh.list@gmail.com>
CC: stable@vger.kernel.org
Fixes: 82939d7999df ("ext4: convert to mbcache2")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220712105436.32204-5-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index a25942a74929..533216e80fa2 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -439,9 +439,16 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
 /* Remove entry from mbcache when EA inode is getting evicted */
 void ext4_evict_ea_inode(struct inode *inode)
 {
-	if (EA_INODE_CACHE(inode))
-		mb_cache_entry_delete(EA_INODE_CACHE(inode),
-			ext4_xattr_inode_get_hash(inode), inode->i_ino);
+	struct mb_cache_entry *oe;
+
+	if (!EA_INODE_CACHE(inode))
+		return;
+	/* Wait for entry to get unused so that we can remove it */
+	while ((oe = mb_cache_entry_delete_or_get(EA_INODE_CACHE(inode),
+			ext4_xattr_inode_get_hash(inode), inode->i_ino))) {
+		mb_cache_entry_wait_unused(oe);
+		mb_cache_entry_put(EA_INODE_CACHE(inode), oe);
+	}
 }
 
 static int
@@ -1229,6 +1236,7 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 	if (error)
 		goto out;
 
+retry_ref:
 	lock_buffer(bh);
 	hash = le32_to_cpu(BHDR(bh)->h_hash);
 	ref = le32_to_cpu(BHDR(bh)->h_refcount);
@@ -1238,9 +1246,18 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 		 * This must happen under buffer lock for
 		 * ext4_xattr_block_set() to reliably detect freed block
 		 */
-		if (ea_block_cache)
-			mb_cache_entry_delete(ea_block_cache, hash,
-					      bh->b_blocknr);
+		if (ea_block_cache) {
+			struct mb_cache_entry *oe;
+
+			oe = mb_cache_entry_delete_or_get(ea_block_cache, hash,
+							  bh->b_blocknr);
+			if (oe) {
+				unlock_buffer(bh);
+				mb_cache_entry_wait_unused(oe);
+				mb_cache_entry_put(ea_block_cache, oe);
+				goto retry_ref;
+			}
+		}
 		get_bh(bh);
 		unlock_buffer(bh);
 
@@ -1867,9 +1884,20 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			 * ext4_xattr_block_set() to reliably detect modified
 			 * block
 			 */
-			if (ea_block_cache)
-				mb_cache_entry_delete(ea_block_cache, hash,
-						      bs->bh->b_blocknr);
+			if (ea_block_cache) {
+				struct mb_cache_entry *oe;
+
+				oe = mb_cache_entry_delete_or_get(ea_block_cache,
+					hash, bs->bh->b_blocknr);
+				if (oe) {
+					/*
+					 * Xattr block is getting reused. Leave
+					 * it alone.
+					 */
+					mb_cache_entry_put(ea_block_cache, oe);
+					goto clone_block;
+				}
+			}
 			ea_bdebug(bs->bh, "modifying in-place");
 			error = ext4_xattr_set_entry(i, s, handle, inode,
 						     true /* is_block */);
@@ -1885,6 +1913,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 				goto cleanup;
 			goto inserted;
 		}
+clone_block:
 		unlock_buffer(bs->bh);
 		ea_bdebug(bs->bh, "cloning");
 		s->base = kmemdup(BHDR(bs->bh), bs->bh->b_size, GFP_NOFS);
@@ -1990,18 +2019,13 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 				lock_buffer(new_bh);
 				/*
 				 * We have to be careful about races with
-				 * freeing, rehashing or adding references to
-				 * xattr block. Once we hold buffer lock xattr
-				 * block's state is stable so we can check
-				 * whether the block got freed / rehashed or
-				 * not.  Since we unhash mbcache entry under
-				 * buffer lock when freeing / rehashing xattr
-				 * block, checking whether entry is still
-				 * hashed is reliable. Same rules hold for
-				 * e_reusable handling.
+				 * adding references to xattr block. Once we
+				 * hold buffer lock xattr block's state is
+				 * stable so we can check the additional
+				 * reference fits.
 				 */
-				if (hlist_bl_unhashed(&ce->e_hash_list) ||
-				    !ce->e_reusable) {
+				ref = le32_to_cpu(BHDR(new_bh)->h_refcount) + 1;
+				if (ref > EXT4_XATTR_REFCOUNT_MAX) {
 					/*
 					 * Undo everything and check mbcache
 					 * again.
@@ -2016,9 +2040,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 					new_bh = NULL;
 					goto inserted;
 				}
-				ref = le32_to_cpu(BHDR(new_bh)->h_refcount) + 1;
 				BHDR(new_bh)->h_refcount = cpu_to_le32(ref);
-				if (ref >= EXT4_XATTR_REFCOUNT_MAX)
+				if (ref == EXT4_XATTR_REFCOUNT_MAX)
 					ce->e_reusable = 0;
 				ea_bdebug(new_bh, "reusing; refcount now=%d",
 					  ref);

