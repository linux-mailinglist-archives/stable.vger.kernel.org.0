Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0B7D9EF4
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438456AbfJPV7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438450AbfJPV7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:16 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDF0E218DE;
        Wed, 16 Oct 2019 21:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263156;
        bh=M7Z3dwqYM06dpw77YIA4d26k0+89rU26bzG1+CYvuY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUYZeDbd55pVf5w5kQNvhvLMb+7GfHoV25z6kQqi7c4NuHd7m9zEAD+sXdm6b3GNZ
         lpuO81j7WX7po5Wk3qrXUZR5/TXZLs0qRDQOJ0sYyPPZSdhpx49wm+9K3GGFs8/vVs
         DvksPbqRHihwbB7+dduIulxCTx8OtD6j9RrdkX9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.3 084/112] btrfs: allocate new inode in NOFS context
Date:   Wed, 16 Oct 2019 14:51:16 -0700
Message-Id: <20191016214904.868190389@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 11a19a90870ea5496a8ded69b86f5b476b6d3355 upstream.

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
---
 fs/btrfs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6276,13 +6276,16 @@ static struct inode *btrfs_new_inode(str
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


