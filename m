Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7646A1D5413
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 17:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgEOPSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 11:18:15 -0400
Received: from [66.170.99.2] ([66.170.99.2]:2916 "EHLO
        sid-build-box.eng.vmware.com" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726263AbgEOPSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 May 2020 11:18:15 -0400
Received: by sid-build-box.eng.vmware.com (Postfix, from userid 1000)
        id 51432BA20C7; Fri, 15 May 2020 20:41:28 +0530 (IST)
From:   Siddharth Chandrasekaran <csiddharth@vmware.com>
To:     gregkh@linuxfoundation.org
Cc:     srostedt@vmware.com, stable@vger.kernel.org, srivatsab@vmware.com,
        csiddharth@vmware.com, siddharth@embedjournal.com,
        dchinner@redhat.com, darrick.wong@oracle.com,
        srivatsa@csail.mit.edu
Subject: [PATCH 4.9 v2] xfs: validate cached inodes are free when allocated
Date:   Fri, 15 May 2020 20:41:09 +0530
Message-Id: <3f8268eea9c4a430273b2202d711f2b1bf0c321b.1589544531.git.csiddharth@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1589544531.git.csiddharth@vmware.com>
References: <cover.1589544531.git.csiddharth@vmware.com>
In-Reply-To: <cover.1589544531.git.csiddharth@vmware.com>
References: <cover.1589544531.git.csiddharth@vmware.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit afca6c5b2595fc44383919fba740c194b0b76aff upstream.

A recent fuzzed filesystem image cached random dcache corruption
when the reproducer was run. This often showed up as panics in
lookup_slow() on a null inode->i_ops pointer when doing pathwalks.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
....
Call Trace:
 lookup_slow+0x44/0x60
 walk_component+0x3dd/0x9f0
 link_path_walk+0x4a7/0x830
 path_lookupat+0xc1/0x470
 filename_lookup+0x129/0x270
 user_path_at_empty+0x36/0x40
 path_listxattr+0x98/0x110
 SyS_listxattr+0x13/0x20
 do_syscall_64+0xf5/0x280
 entry_SYSCALL_64_after_hwframe+0x42/0xb7

but had many different failure modes including deadlocks trying to
lock the inode that was just allocated or KASAN reports of
use-after-free violations.

The cause of the problem was a corrupt INOBT on a v4 fs where the
root inode was marked as free in the inobt record. Hence when we
allocated an inode, it chose the root inode to allocate, found it in
the cache and re-initialised it.

We recently fixed a similar inode allocation issue caused by inobt
record corruption problem in xfs_iget_cache_miss() in commit
ee457001ed6c ("xfs: catch inode allocation state mismatch
corruption"). This change adds similar checks to the cache-hit path
to catch it, and turns the reproducer into a corruption shutdown
situation.

Reported-by: Wen Xu <wen.xu@gatech.edu>
Signed-Off-By: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: fix typos in comment]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Siddharth Chandrasekaran <csiddharth@vmware.com>
---
 fs/xfs/xfs_icache.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 86a4911..d668d30 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -308,6 +308,46 @@ xfs_reinit_inode(
 }
 
 /*
+ * If we are allocating a new inode, then check what was returned is
+ * actually a free, empty inode. If we are not allocating an inode,
+ * then check we didn't find a free inode.
+ *
+ * Returns:
+ *	0		if the inode free state matches the lookup context
+ *	-ENOENT		if the inode is free and we are not allocating
+ *	-EFSCORRUPTED	if there is any state mismatch at all
+ */
+static int
+xfs_iget_check_free_state(
+	struct xfs_inode	*ip,
+	int			flags)
+{
+	if (flags & XFS_IGET_CREATE) {
+		/* should be a free inode */
+		if (VFS_I(ip)->i_mode != 0) {
+			xfs_warn(ip->i_mount,
+"Corruption detected! Free inode 0x%llx not marked free! (mode 0x%x)",
+				ip->i_ino, VFS_I(ip)->i_mode);
+			return -EFSCORRUPTED;
+		}
+
+		if (ip->i_d.di_nblocks != 0) {
+			xfs_warn(ip->i_mount,
+"Corruption detected! Free inode 0x%llx has blocks allocated!",
+				ip->i_ino);
+			return -EFSCORRUPTED;
+		}
+		return 0;
+	}
+
+	/* should be an allocated inode */
+	if (VFS_I(ip)->i_mode == 0)
+		return -ENOENT;
+
+	return 0;
+}
+
+/*
  * Check the validity of the inode we just found it the cache
  */
 static int
@@ -356,12 +396,12 @@ xfs_iget_cache_hit(
 	}
 
 	/*
-	 * If lookup is racing with unlink return an error immediately.
+	 * Check the inode free state is valid. This also detects lookup
+	 * racing with unlinks.
 	 */
-	if (VFS_I(ip)->i_mode == 0 && !(flags & XFS_IGET_CREATE)) {
-		error = -ENOENT;
+	error = xfs_iget_check_free_state(ip, flags);
+	if (error)
 		goto out_error;
-	}
 
 	/*
 	 * If IRECLAIMABLE is set, we've torn down the VFS inode already.
@@ -471,10 +511,13 @@ xfs_iget_cache_miss(
 
 	trace_xfs_iget_miss(ip);
 
-	if ((VFS_I(ip)->i_mode == 0) && !(flags & XFS_IGET_CREATE)) {
-		error = -ENOENT;
+	/*
+	 * Check the inode free state is valid. This also detects lookup
+	 * racing with unlinks.
+	 */
+	error = xfs_iget_check_free_state(ip, flags);
+	if (error)
 		goto out_destroy;
-	}
 
 	/*
 	 * Preload the radix tree so we can insert safely under the
-- 
2.7.4

