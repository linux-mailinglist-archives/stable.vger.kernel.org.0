Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B2753E624
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbiFFO2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239675AbiFFO2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:28:54 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6A4C6874;
        Mon,  6 Jun 2022 07:28:52 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 8AC5E1F935;
        Mon,  6 Jun 2022 14:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654525731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xHB9BeEAsJwVqWAQOVbHgDN/rZ7SyfbGWh7QuoIHytE=;
        b=Iw4wL7iDiXoR2wRjnSZavxj8PTZ3boWmW63TD1G3Ves5PNg6fhESW4K3JjLaNHHZ4DaN/+
        T+U1cCrmW1nnkpGdMangYhFrk89kcnA6/ZdcnycjnskkzYGmMJpqLbZ8vDHRXEsgsOE3IQ
        D3F9EEuZlxWpN7lf5JvMQY0QRI/7Y44=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654525731;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xHB9BeEAsJwVqWAQOVbHgDN/rZ7SyfbGWh7QuoIHytE=;
        b=vgy9RC5kglMEg7vO8Dp2vRfswUmXWauAQZrcUvdGCltKLwbbAAsXqVa8UXEBjwp/d6MGIY
        R4bkWgH6HTKlvPCw==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 632E12C143;
        Mon,  6 Jun 2022 14:28:51 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 0B2C5A0635; Mon,  6 Jun 2022 16:28:51 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 2/2] ext4: Fix race when reusing xattr blocks
Date:   Mon,  6 Jun 2022 16:28:47 +0200
Message-Id: <20220606142850.15489-2-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220606142215.17962-1-jack@suse.cz>
References: <20220606142215.17962-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4696; h=from:subject; bh=mVB07CeDcJFtWIlB7q8z3DzT+aPZnQRwmdNSjlKzszM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBing8fDLVUs1ib7is/vKRrK/9E8CxdclvrUNa6TvYe 9gihuE6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYp4PHwAKCRCcnaoHP2RA2aVYB/ 9+TzmmQYbvSOe5hzmAmFpExO/LyMI5u6v3Qz55rr26x8UG/Ka1vsVr3hlLUsOWlMDftBumi5wA/njS /eECjhkM0Ey/sfBUsgAVYnuZr5H3Oo2lTAWKaAEelGYT0Smgay6PYAXFe3ZBQuAd9p3VE6plTtc0Dn f2Aqe+9weouC+PcjphLzRKWTYAdl7ww++OfnuOvjGv45veU+C4XVOqKeoKRR5R3++f9ItaovrFXSSm iqVou9SJ95ztS/OxnrR0NWk3+WTCmj/wTtGc5PBCffxEaAMG14+UMVIIU1t0uiX61+iQN3w+nrHyPY vOqAegejMjdYj8Fr5WkSNCoqetq3be
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

CPU1					CPU2
ext4_xattr_block_set()			ext4_xattr_release_block()
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
in the jbd2 code. Fix the problem by waiting for users of the mbcache
entry (so xattr block reuse gets canceled) before we free xattr block to
prevent the issue with racing ext4_journal_get_write_access() call.

CC: stable@vger.kernel.org
Fixes: 82939d7999df ("ext4: convert to mbcache2")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/xattr.c | 40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 042325349098..4eeeb3db618f 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1241,17 +1241,29 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 	hash = le32_to_cpu(BHDR(bh)->h_hash);
 	ref = le32_to_cpu(BHDR(bh)->h_refcount);
 	if (ref == 1) {
+		struct mb_cache_entry *ce = NULL;
+
 		ea_bdebug(bh, "refcount now=0; freeing");
 		/*
 		 * This must happen under buffer lock for
 		 * ext4_xattr_block_set() to reliably detect freed block
 		 */
 		if (ea_block_cache)
-			mb_cache_entry_delete(ea_block_cache, hash,
-					      bh->b_blocknr);
+			ce = mb_cache_entry_invalidate(ea_block_cache, hash,
+						       bh->b_blocknr);
 		get_bh(bh);
 		unlock_buffer(bh);
 
+		if (ce) {
+			/*
+			 * Wait for outstanding users of xattr entry so that we
+			 * know they don't try to reuse xattr block before we
+			 * free it - that revokes the block from the journal
+			 * which upsets jbd2_journal_get_write_access()
+			 */
+			mb_cache_entry_wait_unused(ce);
+			mb_cache_entry_put(ea_block_cache, ce);
+		}
 		if (ext4_has_feature_ea_inode(inode->i_sb))
 			ext4_xattr_inode_dec_ref_all(handle, inode, bh,
 						     BFIRST(bh),
@@ -1847,7 +1859,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 	struct buffer_head *new_bh = NULL;
 	struct ext4_xattr_search s_copy = bs->s;
 	struct ext4_xattr_search *s = &s_copy;
-	struct mb_cache_entry *ce = NULL;
+	struct mb_cache_entry *ce = NULL, *old_ce = NULL;
 	int error = 0;
 	struct mb_cache *ea_block_cache = EA_BLOCK_CACHE(inode);
 	struct inode *ea_inode = NULL, *tmp_inode;
@@ -1871,11 +1883,15 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			/*
 			 * This must happen under buffer lock for
 			 * ext4_xattr_block_set() to reliably detect modified
-			 * block
+			 * block. We keep ourselves entry reference so that
+			 * we can wait for outstanding users of the entry
+			 * before freeing the xattr block.
 			 */
-			if (ea_block_cache)
-				mb_cache_entry_delete(ea_block_cache, hash,
-						      bs->bh->b_blocknr);
+			if (ea_block_cache) {
+				old_ce = mb_cache_entry_invalidate(
+						ea_block_cache, hash,
+						bs->bh->b_blocknr);
+			}
 			ea_bdebug(bs->bh, "modifying in-place");
 			error = ext4_xattr_set_entry(i, s, handle, inode,
 						     true /* is_block */);
@@ -2127,6 +2143,14 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 	if (bs->bh && bs->bh != new_bh) {
 		struct ext4_xattr_inode_array *ea_inode_array = NULL;
 
+		/*
+		 * Wait for outstanding users of xattr entry so that we know
+		 * they don't try to reuse xattr block before we free it - that
+		 * revokes the block from the journal which upsets
+		 * jbd2_journal_get_write_access()
+		 */
+		if (old_ce)
+			mb_cache_entry_wait_unused(old_ce);
 		ext4_xattr_release_block(handle, inode, bs->bh,
 					 &ea_inode_array,
 					 0 /* extra_credits */);
@@ -2151,6 +2175,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 	}
 	if (ce)
 		mb_cache_entry_put(ea_block_cache, ce);
+	if (old_ce)
+		mb_cache_entry_put(ea_block_cache, old_ce);
 	brelse(new_bh);
 	if (!(bs->bh && s->base == bs->bh->b_data))
 		kfree(s->base);
-- 
2.35.3

