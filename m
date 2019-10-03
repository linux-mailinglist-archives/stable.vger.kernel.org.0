Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA0CCA851
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390860AbfJCQZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:25:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390464AbfJCQXE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:23:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB46B2054F;
        Thu,  3 Oct 2019 16:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119783;
        bh=dEBjpshsCeuXcjuGoGoCjRXuaWCERKqzYhfR42WBux4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=omyur6dod/l5yGmIu8M0emOlrlhGCxg40H+UeelZz5jvup2LYk1CeJbE2b9wwhCKZ
         QeC/Jq7wwpdqdYRFVvTlXLK9WM2h41LJT6Ee5tQgscf23Yg+n+3+lKPpd2IbjYmI+u
         aLdUrzUt1UEP6UQ7hrPFhdPm2h0DV+ieZNcgZujo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Erhard F." <erhard_f@mailbox.org>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 190/211] btrfs: fix allocation of free space cache v1 bitmap pages
Date:   Thu,  3 Oct 2019 17:54:16 +0200
Message-Id: <20191003154528.483267215@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 3acd48507dc43eeeb0a1fe965b8bad91cab904a7 upstream.

Various notifications of type "BUG kmalloc-4096 () : Redzone
overwritten" have been observed recently in various parts of the kernel.
After some time, it has been made a relation with the use of BTRFS
filesystem and with SLUB_DEBUG turned on.

[   22.809700] BUG kmalloc-4096 (Tainted: G        W        ): Redzone overwritten

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

Commit 69d2480456d1 ("btrfs: use copy_page for copying pages instead of
memcpy") changed the way bitmap blocks are copied. But allthough bitmaps
have the size of a page, they were allocated with kzalloc().

Most of the time, kzalloc() allocates aligned blocks of memory, so
copy_page() can be used. But when some debug options like SLAB_DEBUG are
activated, kzalloc() may return unaligned pointer.

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
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204371
Fixes: 69d2480456d1 ("btrfs: use copy_page for copying pages instead of memcpy")
Cc: stable@vger.kernel.org # 4.19+
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Reviewed-by: David Sterba <dsterba@suse.com>
[ rename to btrfs_free_space_bitmap ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ctree.h            |    1 +
 fs/btrfs/free-space-cache.c |   18 +++++++++++-------
 fs/btrfs/inode.c            |    8 ++++++++
 3 files changed, 20 insertions(+), 7 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -39,6 +39,7 @@ extern struct kmem_cache *btrfs_trans_ha
 extern struct kmem_cache *btrfs_bit_radix_cachep;
 extern struct kmem_cache *btrfs_path_cachep;
 extern struct kmem_cache *btrfs_free_space_cachep;
+extern struct kmem_cache *btrfs_free_space_bitmap_cachep;
 struct btrfs_ordered_sum;
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -763,7 +763,8 @@ static int __load_free_space_cache(struc
 		} else {
 			ASSERT(num_bitmaps);
 			num_bitmaps--;
-			e->bitmap = kzalloc(PAGE_SIZE, GFP_NOFS);
+			e->bitmap = kmem_cache_zalloc(
+					btrfs_free_space_bitmap_cachep, GFP_NOFS);
 			if (!e->bitmap) {
 				kmem_cache_free(
 					btrfs_free_space_cachep, e);
@@ -1864,7 +1865,7 @@ static void free_bitmap(struct btrfs_fre
 			struct btrfs_free_space *bitmap_info)
 {
 	unlink_free_space(ctl, bitmap_info);
-	kfree(bitmap_info->bitmap);
+	kmem_cache_free(btrfs_free_space_bitmap_cachep, bitmap_info->bitmap);
 	kmem_cache_free(btrfs_free_space_cachep, bitmap_info);
 	ctl->total_bitmaps--;
 	ctl->op->recalc_thresholds(ctl);
@@ -2118,7 +2119,8 @@ new_bitmap:
 		}
 
 		/* allocate the bitmap */
-		info->bitmap = kzalloc(PAGE_SIZE, GFP_NOFS);
+		info->bitmap = kmem_cache_zalloc(btrfs_free_space_bitmap_cachep,
+						 GFP_NOFS);
 		spin_lock(&ctl->tree_lock);
 		if (!info->bitmap) {
 			ret = -ENOMEM;
@@ -2130,7 +2132,8 @@ new_bitmap:
 out:
 	if (info) {
 		if (info->bitmap)
-			kfree(info->bitmap);
+			kmem_cache_free(btrfs_free_space_bitmap_cachep,
+					info->bitmap);
 		kmem_cache_free(btrfs_free_space_cachep, info);
 	}
 
@@ -2786,7 +2789,8 @@ out:
 	if (entry->bytes == 0) {
 		ctl->free_extents--;
 		if (entry->bitmap) {
-			kfree(entry->bitmap);
+			kmem_cache_free(btrfs_free_space_bitmap_cachep,
+					entry->bitmap);
 			ctl->total_bitmaps--;
 			ctl->op->recalc_thresholds(ctl);
 		}
@@ -3594,7 +3598,7 @@ again:
 	}
 
 	if (!map) {
-		map = kzalloc(PAGE_SIZE, GFP_NOFS);
+		map = kmem_cache_zalloc(btrfs_free_space_bitmap_cachep, GFP_NOFS);
 		if (!map) {
 			kmem_cache_free(btrfs_free_space_cachep, info);
 			return -ENOMEM;
@@ -3624,7 +3628,7 @@ again:
 	if (info)
 		kmem_cache_free(btrfs_free_space_cachep, info);
 	if (map)
-		kfree(map);
+		kmem_cache_free(btrfs_free_space_bitmap_cachep, map);
 	return 0;
 }
 
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -72,6 +72,7 @@ static struct kmem_cache *btrfs_inode_ca
 struct kmem_cache *btrfs_trans_handle_cachep;
 struct kmem_cache *btrfs_path_cachep;
 struct kmem_cache *btrfs_free_space_cachep;
+struct kmem_cache *btrfs_free_space_bitmap_cachep;
 
 #define S_SHIFT 12
 static const unsigned char btrfs_type_by_mode[S_IFMT >> S_SHIFT] = {
@@ -9361,6 +9362,7 @@ void __cold btrfs_destroy_cachep(void)
 	kmem_cache_destroy(btrfs_trans_handle_cachep);
 	kmem_cache_destroy(btrfs_path_cachep);
 	kmem_cache_destroy(btrfs_free_space_cachep);
+	kmem_cache_destroy(btrfs_free_space_bitmap_cachep);
 }
 
 int __init btrfs_init_cachep(void)
@@ -9390,6 +9392,12 @@ int __init btrfs_init_cachep(void)
 	if (!btrfs_free_space_cachep)
 		goto fail;
 
+	btrfs_free_space_bitmap_cachep = kmem_cache_create("btrfs_free_space_bitmap",
+							PAGE_SIZE, PAGE_SIZE,
+							SLAB_RED_ZONE, NULL);
+	if (!btrfs_free_space_bitmap_cachep)
+		goto fail;
+
 	return 0;
 fail:
 	btrfs_destroy_cachep();


