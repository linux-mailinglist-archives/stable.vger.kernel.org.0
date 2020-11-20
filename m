Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC0E2BA7F9
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbgKTLDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:03:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727782AbgKTLDt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:03:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E298C206E3;
        Fri, 20 Nov 2020 11:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870228;
        bh=rNIkynq+602ULSeogxN1VWJWoqxVJ4zEQYcT7pgIooI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vy+KS7Q2V+Oc30QTOpqx9bu8ebdFC/DtOmfWBBT2wyKC9T6/LgenmvToaVlbg6U8M
         UpWsqEgvxTtIW3EoUtJQgiFEVQ4jJnNo4j6eA8K1X9ERrrO/9wl7vRvGmcsPRv8fHM
         KNBUbB0iphOJdBhcVbuLI4E0+MNfYvgSBhjIF3Rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Xu <wen.xu@gatech.edu>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 11/15] xfs: validate cached inodes are free when allocated
Date:   Fri, 20 Nov 2020 12:03:09 +0100
Message-Id: <20201120104540.115699799@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104539.534424264@linuxfoundation.org>
References: <20201120104539.534424264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit afca6c5b2595fc44383919fba740c194b0b76aff upstream

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
[sudip: use ip->i_d.di_mode instead of VFS_I(ip)->i_mode]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_icache.c |   73 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 48 insertions(+), 25 deletions(-)

--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -135,6 +135,46 @@ xfs_inode_free(
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
+		if (ip->i_d.di_mode != 0) {
+			xfs_warn(ip->i_mount,
+"Corruption detected! Free inode 0x%llx not marked free! (mode 0x%x)",
+				ip->i_ino, ip->i_d.di_mode);
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
+	if (ip->i_d.di_mode == 0)
+		return -ENOENT;
+
+	return 0;
+}
+
+/*
  * Check the validity of the inode we just found it the cache
  */
 static int
@@ -183,12 +223,12 @@ xfs_iget_cache_hit(
 	}
 
 	/*
-	 * If lookup is racing with unlink return an error immediately.
+	 * Check the inode free state is valid. This also detects lookup
+	 * racing with unlinks.
 	 */
-	if (ip->i_d.di_mode == 0 && !(flags & XFS_IGET_CREATE)) {
-		error = -ENOENT;
+	error = xfs_iget_check_free_state(ip, flags);
+	if (error)
 		goto out_error;
-	}
 
 	/*
 	 * If IRECLAIMABLE is set, we've torn down the VFS inode already.
@@ -300,29 +340,12 @@ xfs_iget_cache_miss(
 
 
 	/*
-	 * If we are allocating a new inode, then check what was returned is
-	 * actually a free, empty inode. If we are not allocating an inode,
-	 * the check we didn't find a free inode.
+	 * Check the inode free state is valid. This also detects lookup
+	 * racing with unlinks.
 	 */
-	if (flags & XFS_IGET_CREATE) {
-		if (ip->i_d.di_mode != 0) {
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
-	} else if (ip->i_d.di_mode == 0) {
-		error = -ENOENT;
+	error = xfs_iget_check_free_state(ip, flags);
+	if (error)
 		goto out_destroy;
-	}
 
 	/*
 	 * Preload the radix tree so we can insert safely under the


