Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A273D1F30CF
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgFIBDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 21:03:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727966AbgFHXHl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:07:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC8B420801;
        Mon,  8 Jun 2020 23:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657660;
        bh=xC2bBeky7vffdK3RQMQQEGb98eZ6RKA19Fgaji08iDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rLeKwJohak/vqChoSw7YNZXvSMWiXHasgVsCe6cgQjzLCOQK6ebWWWGw1AU5ioqL3
         WbZ2Vix0pT8juHCLDHYu7+oWPHThQROBu55hWCU+BtJvVTqkckJsbNvbvmhTfo4OTr
         quEr1DWtDUn7JxGkg5IBXmLhovptMFRdfoI2+THs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Airlie <airlied@gmail.com>,
        Brian Foster <bfoster@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 072/274] xfs: more lockdep whackamole with kmem_alloc*
Date:   Mon,  8 Jun 2020 19:02:45 -0400
Message-Id: <20200608230607.3361041-72-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit 6dcde60efd946e38fac8d276a6ca47492103e856 ]

Dave Airlie reported the following lockdep complaint:

>  ======================================================
>  WARNING: possible circular locking dependency detected
>  5.7.0-0.rc5.20200515git1ae7efb38854.1.fc33.x86_64 #1 Not tainted
>  ------------------------------------------------------
>  kswapd0/159 is trying to acquire lock:
>  ffff9b38d01a4470 (&xfs_nondir_ilock_class){++++}-{3:3},
>  at: xfs_ilock+0xde/0x2c0 [xfs]
>
>  but task is already holding lock:
>  ffffffffbbb8bd00 (fs_reclaim){+.+.}-{0:0}, at:
>  __fs_reclaim_acquire+0x5/0x30
>
>  which lock already depends on the new lock.
>
>
>  the existing dependency chain (in reverse order) is:
>
>  -> #1 (fs_reclaim){+.+.}-{0:0}:
>         fs_reclaim_acquire+0x34/0x40
>         __kmalloc+0x4f/0x270
>         kmem_alloc+0x93/0x1d0 [xfs]
>         kmem_alloc_large+0x4c/0x130 [xfs]
>         xfs_attr_copy_value+0x74/0xa0 [xfs]
>         xfs_attr_get+0x9d/0xc0 [xfs]
>         xfs_get_acl+0xb6/0x200 [xfs]
>         get_acl+0x81/0x160
>         posix_acl_xattr_get+0x3f/0xd0
>         vfs_getxattr+0x148/0x170
>         getxattr+0xa7/0x240
>         path_getxattr+0x52/0x80
>         do_syscall_64+0x5c/0xa0
>         entry_SYSCALL_64_after_hwframe+0x49/0xb3
>
>  -> #0 (&xfs_nondir_ilock_class){++++}-{3:3}:
>         __lock_acquire+0x1257/0x20d0
>         lock_acquire+0xb0/0x310
>         down_write_nested+0x49/0x120
>         xfs_ilock+0xde/0x2c0 [xfs]
>         xfs_reclaim_inode+0x3f/0x400 [xfs]
>         xfs_reclaim_inodes_ag+0x20b/0x410 [xfs]
>         xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
>         super_cache_scan+0x190/0x1e0
>         do_shrink_slab+0x184/0x420
>         shrink_slab+0x182/0x290
>         shrink_node+0x174/0x680
>         balance_pgdat+0x2d0/0x5f0
>         kswapd+0x21f/0x510
>         kthread+0x131/0x150
>         ret_from_fork+0x3a/0x50
>
>  other info that might help us debug this:
>
>   Possible unsafe locking scenario:
>
>         CPU0                    CPU1
>         ----                    ----
>    lock(fs_reclaim);
>                                 lock(&xfs_nondir_ilock_class);
>                                 lock(fs_reclaim);
>    lock(&xfs_nondir_ilock_class);
>
>   *** DEADLOCK ***
>
>  4 locks held by kswapd0/159:
>   #0: ffffffffbbb8bd00 (fs_reclaim){+.+.}-{0:0}, at:
>  __fs_reclaim_acquire+0x5/0x30
>   #1: ffffffffbbb7cef8 (shrinker_rwsem){++++}-{3:3}, at:
>  shrink_slab+0x115/0x290
>   #2: ffff9b39f07a50e8
>  (&type->s_umount_key#56){++++}-{3:3}, at: super_cache_scan+0x38/0x1e0
>   #3: ffff9b39f077f258
>  (&pag->pag_ici_reclaim_lock){+.+.}-{3:3}, at:
>  xfs_reclaim_inodes_ag+0x82/0x410 [xfs]

This is a known false positive because inodes cannot simultaneously be
getting reclaimed and the target of a getxattr operation, but lockdep
doesn't know that.  We can (selectively) shut up lockdep until either
it gets smarter or we change inode reclaim not to require the ILOCK by
applying a stupid GFP_NOLOCKDEP bandaid.

Reported-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Tested-by: Dave Airlie <airlied@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/kmem.h                 | 6 +++++-
 fs/xfs/libxfs/xfs_attr_leaf.c | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 6143117770e9..11623489b769 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -19,6 +19,7 @@ typedef unsigned __bitwise xfs_km_flags_t;
 #define KM_NOFS		((__force xfs_km_flags_t)0x0004u)
 #define KM_MAYFAIL	((__force xfs_km_flags_t)0x0008u)
 #define KM_ZERO		((__force xfs_km_flags_t)0x0010u)
+#define KM_NOLOCKDEP	((__force xfs_km_flags_t)0x0020u)
 
 /*
  * We use a special process flag to avoid recursive callbacks into
@@ -30,7 +31,7 @@ kmem_flags_convert(xfs_km_flags_t flags)
 {
 	gfp_t	lflags;
 
-	BUG_ON(flags & ~(KM_NOFS|KM_MAYFAIL|KM_ZERO));
+	BUG_ON(flags & ~(KM_NOFS | KM_MAYFAIL | KM_ZERO | KM_NOLOCKDEP));
 
 	lflags = GFP_KERNEL | __GFP_NOWARN;
 	if (flags & KM_NOFS)
@@ -49,6 +50,9 @@ kmem_flags_convert(xfs_km_flags_t flags)
 	if (flags & KM_ZERO)
 		lflags |= __GFP_ZERO;
 
+	if (flags & KM_NOLOCKDEP)
+		lflags |= __GFP_NOLOCKDEP;
+
 	return lflags;
 }
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 863444e2dda7..1d67cc9f4209 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -489,7 +489,7 @@ xfs_attr_copy_value(
 	}
 
 	if (!args->value) {
-		args->value = kmem_alloc_large(valuelen, 0);
+		args->value = kmem_alloc_large(valuelen, KM_NOLOCKDEP);
 		if (!args->value)
 			return -ENOMEM;
 	}
-- 
2.25.1

