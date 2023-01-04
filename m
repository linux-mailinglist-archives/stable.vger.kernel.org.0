Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B681165D6E0
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbjADPHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237663AbjADPHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:07:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509B71CFE9
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:07:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE510615CD
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 15:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC699C433F1;
        Wed,  4 Jan 2023 15:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672844854;
        bh=jish2wTde0y0SLeJbRvbci8cHl46SuFM5jr/zm6unqc=;
        h=Subject:To:Cc:From:Date:From;
        b=UPQrVHpxa6OpihUyWfPWSTeNziwneoRr1M2nUKJ7jpmlG8O6z7iowiQZq9Xe6quet
         ZKPwHx3gOgapowWqMrYZ8dQxUy8JgU9RtoMgGBiwVjtRrIfDnGE/dmHePd2iclxps8
         OQKuLUGw+FBTcNAR+m37ktWmx4GWmrfuPYcduqtU=
Subject: FAILED: patch "[PATCH] ext4: fix deadlock due to mbcache entry corruption" failed to apply to 5.15-stable tree
To:     jack@suse.cz, adilger@dilger.ca, jpiotrowski@linux.microsoft.com,
        t-lo@linux.microsoft.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 16:07:31 +0100
Message-ID: <1672844851195248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

a44e84a9b776 ("ext4: fix deadlock due to mbcache entry corruption")
307af6c87937 ("mbcache: automatically delete entries from cache on freeing")
65f8b80053a1 ("ext4: fix race when reusing xattr blocks")
fd48e9acdf26 ("ext4: unindent codeblock in ext4_xattr_block_set()")
6bc0d63dad7f ("ext4: remove EA inode entry from mbcache on inode eviction")
3dc96bba65f5 ("mbcache: add functions to delete entry if unused")
58318914186c ("mbcache: don't reclaim used entries")
4efd9f0d120c ("ext4: use kmemdup() to replace kmalloc + memcpy")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a44e84a9b7764c72896f7241a0ec9ac7e7ef38dd Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 23 Nov 2022 20:39:50 +0100
Subject: [PATCH] ext4: fix deadlock due to mbcache entry corruption

When manipulating xattr blocks, we can deadlock infinitely looping
inside ext4_xattr_block_set() where we constantly keep finding xattr
block for reuse in mbcache but we are unable to reuse it because its
reference count is too big. This happens because cache entry for the
xattr block is marked as reusable (e_reusable set) although its
reference count is too big. When this inconsistency happens, this
inconsistent state is kept indefinitely and so ext4_xattr_block_set()
keeps retrying indefinitely.

The inconsistent state is caused by non-atomic update of e_reusable bit.
e_reusable is part of a bitfield and e_reusable update can race with
update of e_referenced bit in the same bitfield resulting in loss of one
of the updates. Fix the problem by using atomic bitops instead.

This bug has been around for many years, but it became *much* easier
to hit after commit 65f8b80053a1 ("ext4: fix race when reusing xattr
blocks").

Cc: stable@vger.kernel.org
Fixes: 6048c64b2609 ("mbcache: add reusable flag to cache entries")
Fixes: 65f8b80053a1 ("ext4: fix race when reusing xattr blocks")
Reported-and-tested-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Reported-by: Thilo Fromm <t-lo@linux.microsoft.com>
Link: https://lore.kernel.org/r/c77bf00f-4618-7149-56f1-b8d1664b9d07@linux.microsoft.com/
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/20221123193950.16758-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 4d1c701f0eec..6bdd502527f8 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1281,7 +1281,7 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 				ce = mb_cache_entry_get(ea_block_cache, hash,
 							bh->b_blocknr);
 				if (ce) {
-					ce->e_reusable = 1;
+					set_bit(MBE_REUSABLE_B, &ce->e_flags);
 					mb_cache_entry_put(ea_block_cache, ce);
 				}
 			}
@@ -2043,7 +2043,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 				}
 				BHDR(new_bh)->h_refcount = cpu_to_le32(ref);
 				if (ref == EXT4_XATTR_REFCOUNT_MAX)
-					ce->e_reusable = 0;
+					clear_bit(MBE_REUSABLE_B, &ce->e_flags);
 				ea_bdebug(new_bh, "reusing; refcount now=%d",
 					  ref);
 				ext4_xattr_block_csum_set(inode, new_bh);
diff --git a/fs/mbcache.c b/fs/mbcache.c
index e272ad738faf..2a4b8b549e93 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -100,8 +100,9 @@ int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
 	atomic_set(&entry->e_refcnt, 2);
 	entry->e_key = key;
 	entry->e_value = value;
-	entry->e_reusable = reusable;
-	entry->e_referenced = 0;
+	entry->e_flags = 0;
+	if (reusable)
+		set_bit(MBE_REUSABLE_B, &entry->e_flags);
 	head = mb_cache_entry_head(cache, key);
 	hlist_bl_lock(head);
 	hlist_bl_for_each_entry(dup, dup_node, head, e_hash_list) {
@@ -165,7 +166,8 @@ static struct mb_cache_entry *__entry_find(struct mb_cache *cache,
 	while (node) {
 		entry = hlist_bl_entry(node, struct mb_cache_entry,
 				       e_hash_list);
-		if (entry->e_key == key && entry->e_reusable &&
+		if (entry->e_key == key &&
+		    test_bit(MBE_REUSABLE_B, &entry->e_flags) &&
 		    atomic_inc_not_zero(&entry->e_refcnt))
 			goto out;
 		node = node->next;
@@ -284,7 +286,7 @@ EXPORT_SYMBOL(mb_cache_entry_delete_or_get);
 void mb_cache_entry_touch(struct mb_cache *cache,
 			  struct mb_cache_entry *entry)
 {
-	entry->e_referenced = 1;
+	set_bit(MBE_REFERENCED_B, &entry->e_flags);
 }
 EXPORT_SYMBOL(mb_cache_entry_touch);
 
@@ -309,9 +311,9 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
 		entry = list_first_entry(&cache->c_list,
 					 struct mb_cache_entry, e_list);
 		/* Drop initial hash reference if there is no user */
-		if (entry->e_referenced ||
+		if (test_bit(MBE_REFERENCED_B, &entry->e_flags) ||
 		    atomic_cmpxchg(&entry->e_refcnt, 1, 0) != 1) {
-			entry->e_referenced = 0;
+			clear_bit(MBE_REFERENCED_B, &entry->e_flags);
 			list_move_tail(&entry->e_list, &cache->c_list);
 			continue;
 		}
diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
index 2da63fd7b98f..97e64184767d 100644
--- a/include/linux/mbcache.h
+++ b/include/linux/mbcache.h
@@ -10,6 +10,12 @@
 
 struct mb_cache;
 
+/* Cache entry flags */
+enum {
+	MBE_REFERENCED_B = 0,
+	MBE_REUSABLE_B
+};
+
 struct mb_cache_entry {
 	/* List of entries in cache - protected by cache->c_list_lock */
 	struct list_head	e_list;
@@ -26,8 +32,7 @@ struct mb_cache_entry {
 	atomic_t		e_refcnt;
 	/* Key in hash - stable during lifetime of the entry */
 	u32			e_key;
-	u32			e_referenced:1;
-	u32			e_reusable:1;
+	unsigned long		e_flags;
 	/* User provided value - stable during lifetime of the entry */
 	u64			e_value;
 };

