Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9A13106647
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfKVFtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:49:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:54052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727240AbfKVFtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:49:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F4CC2070A;
        Fri, 22 Nov 2019 05:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401786;
        bh=Oap2jNUbq3rKFle6ah4oXkW8U1ptzQq0PB/FE0fLVF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFH6KoSTvJB+BNGggHfakMFbGJQP8AD6Qp16q8xWpT1CHWyZ4MkXl+a/pd9woFaGy
         YH2QvvltmA7XPEEOrCLkH07/XDhySPtBv8DO+WWMA18wUiRNPam6tOilG7eCHbqIHc
         KoYv0S/7iqXv6YEuXiPCcQl4CUrgcRszhs8xW7GA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 034/219] xfs: zero length symlinks are not valid
Date:   Fri, 22 Nov 2019 00:46:06 -0500
Message-Id: <20191122054911.1750-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 43feeea88c9cb2955b9f7ba8152ec5abeea42810 ]

A log recovery failure has been reproduced where a symlink inode has
a zero length in extent form. It was caused by a shutdown during a
combined fstress+fsmark workload.

The underlying problem is the issue in xfs_inactive_symlink(): the
inode is unlocked between the symlink inactivation/truncation and
the inode being freed. This opens a window for the inode to be
written to disk before it xfs_ifree() removes it from the unlinked
list, marks it free in the inobt and zeros the mode.

For shortform inodes, the fix is simple. xfs_ifree() clears the data
fork state, so there's no need to do it in xfs_inactive_symlink().
This means the shortform fork verifier will not see a zero length
data fork as it mirrors the inode size through to xfs_ifree()), and
hence if the inode gets written back and the fork verifiers are run
they will still see a fork that matches the on-disk inode size.

For extent form (remote) symlinks, it is a little more tricky. Here
we explicitly set the inode size to zero, so the above race can lead
to zero length symlinks on disk. Because the inode is unlinked at
this point (i.e. on the unlinked list) and unreferenced, it can
never be seen again by a user. Hence when we set the inode size to
zeor, also change the type to S_IFREG. xfs_ifree() expects S_IFREG
inodes to be of zero length, and so this avoids all the problems of
zero length symlinks ever hitting the disk. It also avoids the
problem of needing to handle zero length symlink inodes in log
recovery to replay the extent free intents and the remaining
deferops to free the extents the symlink used.

Also add a couple of asserts to warn us if zero length symlinks end
up in either the symlink create or inactivation paths.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_symlink_remote.c | 14 +++++++++----
 fs/xfs/xfs_symlink.c               | 33 +++++++++++++++---------------
 2 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 95374ab2dee73..77d80106f989a 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -199,7 +199,10 @@ xfs_symlink_local_to_remote(
 					ifp->if_bytes - 1);
 }
 
-/* Verify the consistency of an inline symlink. */
+/*
+ * Verify the in-memory consistency of an inline symlink data fork. This
+ * does not do on-disk format checks.
+ */
 xfs_failaddr_t
 xfs_symlink_shortform_verify(
 	struct xfs_inode	*ip)
@@ -215,9 +218,12 @@ xfs_symlink_shortform_verify(
 	size = ifp->if_bytes;
 	endp = sfp + size;
 
-	/* Zero length symlinks can exist while we're deleting a remote one. */
-	if (size == 0)
-		return NULL;
+	/*
+	 * Zero length symlinks should never occur in memory as they are
+	 * never alllowed to exist on disk.
+	 */
+	if (!size)
+		return __this_address;
 
 	/* No negative sizes or overly long symlink targets. */
 	if (size < 0 || size > XFS_SYMLINK_MAXLEN)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index a3e98c64b6e38..b2c1177c717ff 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -192,6 +192,7 @@ xfs_symlink(
 	pathlen = strlen(target_path);
 	if (pathlen >= XFS_SYMLINK_MAXLEN)      /* total string too long */
 		return -ENAMETOOLONG;
+	ASSERT(pathlen > 0);
 
 	udqp = gdqp = NULL;
 	prid = xfs_get_initial_prid(dp);
@@ -378,6 +379,12 @@ xfs_symlink(
 
 /*
  * Free a symlink that has blocks associated with it.
+ *
+ * Note: zero length symlinks are not allowed to exist. When we set the size to
+ * zero, also change it to a regular file so that it does not get written to
+ * disk as a zero length symlink. The inode is on the unlinked list already, so
+ * userspace cannot find this inode anymore, so this change is not user visible
+ * but allows us to catch corrupt zero-length symlinks in the verifiers.
  */
 STATIC int
 xfs_inactive_symlink_rmt(
@@ -412,13 +419,14 @@ xfs_inactive_symlink_rmt(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	/*
-	 * Lock the inode, fix the size, and join it to the transaction.
-	 * Hold it so in the normal path, we still have it locked for
-	 * the second transaction.  In the error paths we need it
+	 * Lock the inode, fix the size, turn it into a regular file and join it
+	 * to the transaction.  Hold it so in the normal path, we still have it
+	 * locked for the second transaction.  In the error paths we need it
 	 * held so the cancel won't rele it, see below.
 	 */
 	size = (int)ip->i_d.di_size;
 	ip->i_d.di_size = 0;
+	VFS_I(ip)->i_mode = (VFS_I(ip)->i_mode & ~S_IFMT) | S_IFREG;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	/*
 	 * Find the block(s) so we can inval and unmap them.
@@ -494,17 +502,10 @@ xfs_inactive_symlink(
 		return -EIO;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-	/*
-	 * Zero length symlinks _can_ exist.
-	 */
 	pathlen = (int)ip->i_d.di_size;
-	if (!pathlen) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		return 0;
-	}
+	ASSERT(pathlen);
 
-	if (pathlen < 0 || pathlen > XFS_SYMLINK_MAXLEN) {
+	if (pathlen <= 0 || pathlen > XFS_SYMLINK_MAXLEN) {
 		xfs_alert(mp, "%s: inode (0x%llx) bad symlink length (%d)",
 			 __func__, (unsigned long long)ip->i_ino, pathlen);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -512,12 +513,12 @@ xfs_inactive_symlink(
 		return -EFSCORRUPTED;
 	}
 
+	/*
+	 * Inline fork state gets removed by xfs_difree() so we have nothing to
+	 * do here in that case.
+	 */
 	if (ip->i_df.if_flags & XFS_IFINLINE) {
-		if (ip->i_df.if_bytes > 0) 
-			xfs_idata_realloc(ip, -(ip->i_df.if_bytes),
-					  XFS_DATA_FORK);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		ASSERT(ip->i_df.if_bytes == 0);
 		return 0;
 	}
 
-- 
2.20.1

