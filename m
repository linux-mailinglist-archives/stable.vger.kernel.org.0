Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD11F54B55B
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 18:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245561AbiFNQGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 12:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350666AbiFNQGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 12:06:11 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886D7403F3;
        Tue, 14 Jun 2022 09:06:06 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E569321BBA;
        Tue, 14 Jun 2022 16:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655222764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ht6Whw6ioPLeueQTxC9Ha3h0V8Ww4XjvIrqxSFuLjqw=;
        b=GMisu2vHmv72WyDbujf2KPzsM13U+k9nvHoaWocI0Oc0YhkuV2p+uFNG+oP/YtfDV3SaOR
        IU1oL0KdpzDxFXz43an85TuBXCJYBS+3B3WkJDBBLlOfPxoNh6cADTCoFvZ9D3s05ItnwS
        MlVN/5XiPggkeEMbLHX61U5wlW3r/ic=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655222764;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ht6Whw6ioPLeueQTxC9Ha3h0V8Ww4XjvIrqxSFuLjqw=;
        b=UvyrlFMEupjWSn04+fdi3nd37N+XJ89puaf2z0dKSNQjfHq1G8lMVYBjFSw3D53zYtXJnL
        PzitJrsOt4aEXfDA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id CE62A2C141;
        Tue, 14 Jun 2022 16:06:04 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id DBA6CA0639; Tue, 14 Jun 2022 18:06:03 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 05/10] ext4: Fix race when reusing xattr blocks
Date:   Tue, 14 Jun 2022 18:05:19 +0200
Message-Id: <20220614160603.20566-5-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220614124146.21594-1-jack@suse.cz>
References: <20220614124146.21594-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6212; h=from:subject; bh=7kHxMVOOMAlrU9u0MZrKUFvG7KhECCvLPtZsyfBYjbA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiqLG/VlxcS0Z4cHSmXorZvodXi+80TcEqhLwNQvbQ fowmf/+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYqixvwAKCRCcnaoHP2RA2Tb4CA DiUUxwzy7TB2ijmSd8osUNkhIzjPRi0V1hTGCmndn+C6ftLAW6l5WWrv8l91RPsY0u2IYN9CfzpYZV 2+Q1yuVo6Rbiz0cMznzSb2wzw2sXZ3qhkQH2l1uaK8eXF1p+Euc7o6gJit2+XOjQIoIWhWbju02PTl l364NnQwHPVygjLnSXDpGnmsagZvAkFRXTre/JP29Be+HsJ00N0jnUku8hzmBUmKGPEzRHv+12LfKK bmHkJtiaIzHK0wrf4jXtFWeuVJqFsP87+Jh/SDr63AOetkAVR48Tl+w9J2yXbupHbxyKDhkflD+A3o 2Pd2oJhZVLkL9C008NEN/nitjnYvcC
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Reported-by: Ritesh Harjani <ritesh.list@gmail.com>
CC: stable@vger.kernel.org
Fixes: 82939d7999df ("ext4: convert to mbcache2")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/xattr.c | 67 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index aadfae53d055..0c42c0e22cd2 100644
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
+	while ((oe = mb_cache_entry_try_delete(EA_INODE_CACHE(inode),
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
+			oe = mb_cache_entry_try_delete(ea_block_cache, hash,
+						       bh->b_blocknr);
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
+				oe = mb_cache_entry_try_delete(ea_block_cache,
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
 		s->base = kmalloc(bs->bh->b_size, GFP_NOFS);
@@ -1991,18 +2020,13 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
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
@@ -2017,9 +2041,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
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
2.35.3

