Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 896D897E0E
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 17:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbfHUPF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 11:05:59 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:45809 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727918AbfHUPF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Aug 2019 11:05:58 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 46D9w173vvz9v105;
        Wed, 21 Aug 2019 17:05:53 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=eod0gXNe; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id Vwq00iVmMvOk; Wed, 21 Aug 2019 17:05:53 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 46D9w15r14z9v104;
        Wed, 21 Aug 2019 17:05:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1566399953; bh=3s4/1CenBEAPpHpMM7UHacKq7H2XNGMGF2S+PN3leiU=;
        h=From:Subject:To:Cc:Date:From;
        b=eod0gXNeM5oGzFjPXNUjAIA1RD3BvyXSvJMJTUcjKbWG+w42bwDAKpyOi3QuTmk60
         SWcOdvzt3ngvKRJxOXN3IWwOzk4wdXXnJakVmo1Frd0nJlVjfZ9YfoMY/T/lmnlG//
         mlU48Eq1rhuhNMEnCbZ4cGR0/Xj2Ah39wwkAhSOs=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 1CDA08B7F6;
        Wed, 21 Aug 2019 17:05:56 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id aA7bqXOM0T42; Wed, 21 Aug 2019 17:05:56 +0200 (CEST)
Received: from pc16032vm.idsi0.si.c-s.fr (po15451.idsi0.si.c-s.fr [172.25.230.101])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id DF1C18B7EE;
        Wed, 21 Aug 2019 17:05:55 +0200 (CEST)
Received: by pc16032vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id B50CC6B6EE; Wed, 21 Aug 2019 15:05:55 +0000 (UTC)
Message-Id: <c3157c8e8e0e7588312b40c853f65c02fe6c957a.1566399731.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2] btrfs: fix allocation of bitmap pages.
To:     erhard_f@mailbox.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, stable@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Date:   Wed, 21 Aug 2019 15:05:55 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Various notifications of type "BUG kmalloc-4096 () : Redzone
overwritten" have been observed recently in various parts of
the kernel. After some time, it has been made a relation with
the use of BTRFS filesystem.

[   22.809700] BUG kmalloc-4096 (Tainted: G        W        ): Redzone overwritten
[   22.809971] -----------------------------------------------------------------------------

[   22.810286] INFO: 0xbe1a5921-0xfbfc06cd. First byte 0x0 instead of 0xcc
[   22.810866] INFO: Allocated in __load_free_space_cache+0x588/0x780 [btrfs] age=22 cpu=0 pid=224
[   22.811193] 	__slab_alloc.constprop.26+0x44/0x70
[   22.811345] 	kmem_cache_alloc_trace+0xf0/0x2ec
[   22.811588] 	__load_free_space_cache+0x588/0x780 [btrfs]
[   22.811848] 	load_free_space_cache+0xf4/0x1b0 [btrfs]
[   22.812090] 	cache_block_group+0x1d0/0x3d0 [btrfs]
[   22.812321] 	find_free_extent+0x680/0x12a4 [btrfs]
[   22.812549] 	btrfs_reserve_extent+0xec/0x220 [btrfs]
[   22.812785] 	btrfs_alloc_tree_block+0x178/0x5f4 [btrfs]
[   22.813032] 	__btrfs_cow_block+0x150/0x5d4 [btrfs]
[   22.813262] 	btrfs_cow_block+0x194/0x298 [btrfs]
[   22.813484] 	commit_cowonly_roots+0x44/0x294 [btrfs]
[   22.813718] 	btrfs_commit_transaction+0x63c/0xc0c [btrfs]
[   22.813973] 	close_ctree+0xf8/0x2a4 [btrfs]
[   22.814107] 	generic_shutdown_super+0x80/0x110
[   22.814250] 	kill_anon_super+0x18/0x30
[   22.814437] 	btrfs_kill_super+0x18/0x90 [btrfs]
[   22.814590] INFO: Freed in proc_cgroup_show+0xc0/0x248 age=41 cpu=0 pid=83
[   22.814841] 	proc_cgroup_show+0xc0/0x248
[   22.814967] 	proc_single_show+0x54/0x98
[   22.815086] 	seq_read+0x278/0x45c
[   22.815190] 	__vfs_read+0x28/0x17c
[   22.815289] 	vfs_read+0xa8/0x14c
[   22.815381] 	ksys_read+0x50/0x94
[   22.815475] 	ret_from_syscall+0x0/0x38

Commit 69d2480456d1 ("btrfs: use copy_page for copying pages instead
of memcpy") changed the way bitmap blocks are copied. But allthough
bitmaps have the size of a page, they were allocated with kzalloc().

Most of the time, kzalloc() allocates aligned blocks of memory, so
copy_page() can be used. But when some debug options like SLAB_DEBUG
are activated, kzalloc() may return unaligned pointer.

On powerpc, memcpy(), copy_page() and other copying functions use
'dcbz' instruction which provides an entire zeroed cacheline to avoid
memory read when the intention is to overwrite a full line. Functions
like memcpy() are writen to care about partial cachelines at the start
and end of the destination, but copy_page() assumes it gets pages. As
pages are naturally cache aligned, copy_page() doesn't care about
partial lines. This means that when copy_page() is called with a
misaligned pointer, a few leading bytes are zeroed.

To fix it, allocate bitmaps through kmem_cache instead of using kzalloc()
The cache pool is created with PAGE_SIZE alignment constraint.

Reported-by: Erhard F. <erhard_f@mailbox.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=204371
Fixes: 69d2480456d1 ("btrfs: use copy_page for copying pages instead of memcpy")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
v2: Using kmem_cache instead of get_zeroed_page() in order to benefit from SLAB debugging features like redzone.
---
 fs/btrfs/ctree.h            |  1 +
 fs/btrfs/free-space-cache.c | 17 ++++++++++-------
 fs/btrfs/inode.c            |  7 +++++++
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 299e11e6c554..26abb95becc9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -43,6 +43,7 @@ extern struct kmem_cache *btrfs_trans_handle_cachep;
 extern struct kmem_cache *btrfs_bit_radix_cachep;
 extern struct kmem_cache *btrfs_path_cachep;
 extern struct kmem_cache *btrfs_free_space_cachep;
+extern struct kmem_cache *btrfs_bitmap_cachep;
 struct btrfs_ordered_sum;
 struct btrfs_ref;
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 062be9dde4c6..9a708e7920a0 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -764,7 +764,8 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 		} else {
 			ASSERT(num_bitmaps);
 			num_bitmaps--;
-			e->bitmap = kzalloc(PAGE_SIZE, GFP_NOFS);
+			e->bitmap = kmem_cache_zalloc(btrfs_bitmap_cachep,
+						      GFP_NOFS);
 			if (!e->bitmap) {
 				kmem_cache_free(
 					btrfs_free_space_cachep, e);
@@ -1881,7 +1882,7 @@ static void free_bitmap(struct btrfs_free_space_ctl *ctl,
 			struct btrfs_free_space *bitmap_info)
 {
 	unlink_free_space(ctl, bitmap_info);
-	kfree(bitmap_info->bitmap);
+	kmem_cache_free(btrfs_bitmap_cachep, bitmap_info->bitmap);
 	kmem_cache_free(btrfs_free_space_cachep, bitmap_info);
 	ctl->total_bitmaps--;
 	ctl->op->recalc_thresholds(ctl);
@@ -2135,7 +2136,7 @@ static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
 		}
 
 		/* allocate the bitmap */
-		info->bitmap = kzalloc(PAGE_SIZE, GFP_NOFS);
+		info->bitmap = kmem_cache_zalloc(btrfs_bitmap_cachep, GFP_NOFS);
 		spin_lock(&ctl->tree_lock);
 		if (!info->bitmap) {
 			ret = -ENOMEM;
@@ -2146,7 +2147,8 @@ static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
 
 out:
 	if (info) {
-		kfree(info->bitmap);
+		if (info->bitmap)
+			kmem_cache_free(btrfs_bitmap_cachep, info->bitmap);
 		kmem_cache_free(btrfs_free_space_cachep, info);
 	}
 
@@ -2802,7 +2804,7 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 	if (entry->bytes == 0) {
 		ctl->free_extents--;
 		if (entry->bitmap) {
-			kfree(entry->bitmap);
+			kmem_cache_free(btrfs_bitmap_cachep, entry->bitmap);
 			ctl->total_bitmaps--;
 			ctl->op->recalc_thresholds(ctl);
 		}
@@ -3606,7 +3608,7 @@ int test_add_free_space_entry(struct btrfs_block_group_cache *cache,
 	}
 
 	if (!map) {
-		map = kzalloc(PAGE_SIZE, GFP_NOFS);
+		map = kmem_cache_zalloc(btrfs_bitmap_cachep, GFP_NOFS);
 		if (!map) {
 			kmem_cache_free(btrfs_free_space_cachep, info);
 			return -ENOMEM;
@@ -3635,7 +3637,8 @@ int test_add_free_space_entry(struct btrfs_block_group_cache *cache,
 
 	if (info)
 		kmem_cache_free(btrfs_free_space_cachep, info);
-	kfree(map);
+	if (map)
+		kmem_cache_free(btrfs_bitmap_cachep, map);
 	return 0;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ee582a36653d..da470af9d328 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -74,6 +74,7 @@ static struct kmem_cache *btrfs_inode_cachep;
 struct kmem_cache *btrfs_trans_handle_cachep;
 struct kmem_cache *btrfs_path_cachep;
 struct kmem_cache *btrfs_free_space_cachep;
+struct kmem_cache *btrfs_bitmap_cachep;
 
 static int btrfs_setsize(struct inode *inode, struct iattr *attr);
 static int btrfs_truncate(struct inode *inode, bool skip_writeback);
@@ -9380,6 +9381,7 @@ void __cold btrfs_destroy_cachep(void)
 	kmem_cache_destroy(btrfs_trans_handle_cachep);
 	kmem_cache_destroy(btrfs_path_cachep);
 	kmem_cache_destroy(btrfs_free_space_cachep);
+	kmem_cache_destroy(btrfs_bitmap_cachep);
 }
 
 int __init btrfs_init_cachep(void)
@@ -9409,6 +9411,11 @@ int __init btrfs_init_cachep(void)
 	if (!btrfs_free_space_cachep)
 		goto fail;
 
+	btrfs_bitmap_cachep = kmem_cache_create("btrfs_bitmap", PAGE_SIZE,
+						PAGE_SIZE, SLAB_RED_ZONE, NULL);
+	if (!btrfs_bitmap_cachep)
+		goto fail;
+
 	return 0;
 fail:
 	btrfs_destroy_cachep();
-- 
2.13.3

