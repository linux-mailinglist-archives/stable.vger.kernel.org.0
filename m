Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5027866C916
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbjAPQqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbjAPQpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:45:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37070301A6
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:33:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB85BB8107D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E67C433D2;
        Mon, 16 Jan 2023 16:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886796;
        bh=BEMN3xegDDlTJnqRE9rCmHuudTVJFMoXgZsTEyradIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0FhI+wgvp9+F67bZ/JzLiSxTSljlubcyz1i9WrK6+IxL/kjBkXjaHM8cj3knC4g0
         Qaqem0BPmfFDM2HpRv10tOXLNp2qJAg1ZuZvsDT+2JQcTmZ8MkfFEjwInVJ2Eq/P86
         WyJjOhIZxngK+Pvp/GKoV/4wwp27lrYfrCa98HA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: [PATCH 5.4 565/658] ext4: fix race when reusing xattr blocks
Date:   Mon, 16 Jan 2023 16:50:53 +0100
Message-Id: <20230116154935.343714994@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 65f8b80053a1b2fd602daa6814e62d6fa90e5e9b ]

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
Stable-dep-of: a44e84a9b776 ("ext4: fix deadlock due to mbcache entry corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 67 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 24a4396933c0..131de3fcd2be 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -437,9 +437,16 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
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
@@ -1241,6 +1248,7 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 	if (error)
 		goto out;
 
+retry_ref:
 	lock_buffer(bh);
 	hash = le32_to_cpu(BHDR(bh)->h_hash);
 	ref = le32_to_cpu(BHDR(bh)->h_refcount);
@@ -1250,9 +1258,18 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
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
 
@@ -1879,9 +1896,20 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
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
@@ -1897,6 +1925,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 				goto cleanup;
 			goto inserted;
 		}
+clone_block:
 		unlock_buffer(bs->bh);
 		ea_bdebug(bs->bh, "cloning");
 		s->base = kmemdup(BHDR(bs->bh), bs->bh->b_size, GFP_NOFS);
@@ -2002,18 +2031,13 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
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
@@ -2028,9 +2052,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
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
-- 
2.35.1



