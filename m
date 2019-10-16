Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F33D926C
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 15:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404211AbfJPN1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 09:27:50 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50669 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730468AbfJPN1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 09:27:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 48F0722054;
        Wed, 16 Oct 2019 09:27:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 16 Oct 2019 09:27:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=pg5VOM
        BbF2KXCnv0GKiq+iECUGiY4K3U8h0+VJAmgv8=; b=NLMv8Az/8p2jQygwUOYjpW
        IYVYGRLKfy+OH4oQGWZPH/itnWIfeid5IYq8ZRzssJR0o7KA/FBsDRZbLA/KZg3q
        D0PEhmcoQJ6Ik1R9vzhnyDu3RfGwpZg10PuDe2bkIytpErDHpWZnzbgkD137lgfl
        qTNk6hDYO7L5pFTrig3AeFUv0OA8KNT+2PzYoZmjvApjHsecrgNx2A2LIlE1FZKc
        OZuQ+5d/Epv1PfZTkXymw4L++l0uXewZX6emPb8vtjmjHSJkd+KArnIO9c1uhxK0
        J7Q5MCtXskzChHenYzY5mnZEUOVGBbP83OZ8sWhMPZUVABjVlO5azGsdjXUHrDJQ
        ==
X-ME-Sender: <xms:1BqnXRdyGdx6bUvykHDCW5Lw3oZSRYdRVCwm_M17MghsaN-aYmp0Qg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeehgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepvddtledrudefiedrvdefiedrleegnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:1BqnXdXne1aCo4ZgAKVP7qq0Ro1_a-w2D6rIghYBPy2uFcVqCRrbzg>
    <xmx:1BqnXVFrXktqd9WRKBTsHhd9fwTRvyIoiqGk--CJ99toZkL5EzRjHg>
    <xmx:1BqnXfeN7qGSzlq4fpVW2yJWubQ3_qj5EN5eVrFcKjzvv0iJ234Bog>
    <xmx:1RqnXSBGIn0i2m81mesPmYpeZ0fNmOzmpEKSIO8ujJN1X2BBkVKEZg>
Received: from localhost (unknown [209.136.236.94])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3FF16D6006C;
        Wed, 16 Oct 2019 09:27:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: allocate new inode in NOFS context" failed to apply to 4.19-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com,
        zsojka@seznam.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 16 Oct 2019 06:27:46 -0700
Message-ID: <157123246618677@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 11a19a90870ea5496a8ded69b86f5b476b6d3355 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Mon, 9 Sep 2019 10:12:04 -0400
Subject: [PATCH] btrfs: allocate new inode in NOFS context

A user reported a lockdep splat

 ======================================================
 WARNING: possible circular locking dependency detected
 5.2.11-gentoo #2 Not tainted
 ------------------------------------------------------
 kswapd0/711 is trying to acquire lock:
 000000007777a663 (sb_internal){.+.+}, at: start_transaction+0x3a8/0x500

but task is already holding lock:
 000000000ba86300 (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x0/0x30

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (fs_reclaim){+.+.}:
 kmem_cache_alloc+0x1f/0x1c0
 btrfs_alloc_inode+0x1f/0x260
 alloc_inode+0x16/0xa0
 new_inode+0xe/0xb0
 btrfs_new_inode+0x70/0x610
 btrfs_symlink+0xd0/0x420
 vfs_symlink+0x9c/0x100
 do_symlinkat+0x66/0xe0
 do_syscall_64+0x55/0x1c0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (sb_internal){.+.+}:
 __sb_start_write+0xf6/0x150
 start_transaction+0x3a8/0x500
 btrfs_commit_inode_delayed_inode+0x59/0x110
 btrfs_evict_inode+0x19e/0x4c0
 evict+0xbc/0x1f0
 inode_lru_isolate+0x113/0x190
 __list_lru_walk_one.isra.4+0x5c/0x100
 list_lru_walk_one+0x32/0x50
 prune_icache_sb+0x36/0x80
 super_cache_scan+0x14a/0x1d0
 do_shrink_slab+0x131/0x320
 shrink_node+0xf7/0x380
 balance_pgdat+0x2d5/0x640
 kswapd+0x2ba/0x5e0
 kthread+0x147/0x160
 ret_from_fork+0x24/0x30

other info that might help us debug this:

 Possible unsafe locking scenario:

 CPU0 CPU1
 ---- ----
 lock(fs_reclaim);
 lock(sb_internal);
 lock(fs_reclaim);
 lock(sb_internal);
*** DEADLOCK ***

 3 locks held by kswapd0/711:
 #0: 000000000ba86300 (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x0/0x30
 #1: 000000004a5100f8 (shrinker_rwsem){++++}, at: shrink_node+0x9a/0x380
 #2: 00000000f956fa46 (&type->s_umount_key#30){++++}, at: super_cache_scan+0x35/0x1d0

stack backtrace:
 CPU: 7 PID: 711 Comm: kswapd0 Not tainted 5.2.11-gentoo #2
 Hardware name: Dell Inc. Precision Tower 3620/0MWYPT, BIOS 2.4.2 09/29/2017
 Call Trace:
 dump_stack+0x85/0xc7
 print_circular_bug.cold.40+0x1d9/0x235
 __lock_acquire+0x18b1/0x1f00
 lock_acquire+0xa6/0x170
 ? start_transaction+0x3a8/0x500
 __sb_start_write+0xf6/0x150
 ? start_transaction+0x3a8/0x500
 start_transaction+0x3a8/0x500
 btrfs_commit_inode_delayed_inode+0x59/0x110
 btrfs_evict_inode+0x19e/0x4c0
 ? var_wake_function+0x20/0x20
 evict+0xbc/0x1f0
 inode_lru_isolate+0x113/0x190
 ? discard_new_inode+0xc0/0xc0
 __list_lru_walk_one.isra.4+0x5c/0x100
 ? discard_new_inode+0xc0/0xc0
 list_lru_walk_one+0x32/0x50
 prune_icache_sb+0x36/0x80
 super_cache_scan+0x14a/0x1d0
 do_shrink_slab+0x131/0x320
 shrink_node+0xf7/0x380
 balance_pgdat+0x2d5/0x640
 kswapd+0x2ba/0x5e0
 ? __wake_up_common_lock+0x90/0x90
 kthread+0x147/0x160
 ? balance_pgdat+0x640/0x640
 ? __kthread_create_on_node+0x160/0x160
 ret_from_fork+0x24/0x30

This is because btrfs_new_inode() calls new_inode() under the
transaction.  We could probably move the new_inode() outside of this but
for now just wrap it in memalloc_nofs_save().

Reported-by: Zdenek Sojka <zsojka@seznam.cz>
Fixes: 712e36c5f2a7 ("btrfs: use GFP_KERNEL in btrfs_alloc_inode")
CC: stable@vger.kernel.org # 4.16+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a0546401bc0a..0f2754eaa05b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6305,13 +6305,16 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	u32 sizes[2];
 	int nitems = name ? 2 : 1;
 	unsigned long ptr;
+	unsigned int nofs_flag;
 	int ret;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return ERR_PTR(-ENOMEM);
 
+	nofs_flag = memalloc_nofs_save();
 	inode = new_inode(fs_info->sb);
+	memalloc_nofs_restore(nofs_flag);
 	if (!inode) {
 		btrfs_free_path(path);
 		return ERR_PTR(-ENOMEM);

