Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B726724BABB
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730324AbgHTMQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:16:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730262AbgHTJ4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:56:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E28820885;
        Thu, 20 Aug 2020 09:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917405;
        bh=GhFvoRWDwdlAIbItK878bl23oh/B9FZs/fvE3PNlG3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKgJ7+wOxPwjF4Z+8zCtI8LwTifg6RStLn2tVg0bgqIG/njZ9ASS0bC8V8TyPSOA5
         6dPEjOwC4awkNeLyg4rL0uMGsYBWJtJAkVQJTo4XlaByf/6ZkGiKVpbbmq3G3BhzHs
         D2ybEKUWyxIcmbOV58SCQC9XKsJ29w7DMd3pE358=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Xu <wen.xu@gatech.edu>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 002/212] xfs: validate cached inodes are free when allocated
Date:   Thu, 20 Aug 2020 11:19:35 +0200
Message-Id: <20200820091602.380738506@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit afca6c5b2595fc44383919fba740c194b0b76aff ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_icache.c | 73 +++++++++++++++++++++++++++++----------------
 1 file changed, 48 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 57ec10809f4bf..69c112ddb544d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -307,6 +307,46 @@ xfs_reinit_inode(
 	return error;
 }
 
+/*
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
 /*
  * Check the validity of the inode we just found it the cache
  */
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
@@ -473,29 +513,12 @@ xfs_iget_cache_miss(
 
 
 	/*
-	 * If we are allocating a new inode, then check what was returned is
-	 * actually a free, empty inode. If we are not allocating an inode,
-	 * the check we didn't find a free inode.
+	 * Check the inode free state is valid. This also detects lookup
+	 * racing with unlinks.
 	 */
-	if (flags & XFS_IGET_CREATE) {
-		if (VFS_I(ip)->i_mode != 0) {
-			xfs_warn(mp,
-"Corruption detected! Free inode 0x%llx not marked free on disk",
-				ino);
-			error = -EFSCORRUPTED;
-			goto out_destroy;
-		}
-		if (ip->i_d.di_nblocks != 0) {
-			xfs_warn(mp,
-"Corruption detected! Free inode 0x%llx has blocks allocated!",
-				ino);
-			error = -EFSCORRUPTED;
-			goto out_destroy;
-		}
-	} else if (VFS_I(ip)->i_mode == 0) {
-		error = -ENOENT;
+	error = xfs_iget_check_free_state(ip, flags);
+	if (error)
 		goto out_destroy;
-	}
 
 	/*
 	 * Preload the radix tree so we can insert safely under the
-- 
2.25.1



