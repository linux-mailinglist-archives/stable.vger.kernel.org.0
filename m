Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D860111CE9
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbfLCWsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:48:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:39324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729152AbfLCWsj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:48:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCC6220656;
        Tue,  3 Dec 2019 22:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413318;
        bh=S26pwKVmaRwpB6XKLTl5ImMz45QuMVHKeFdceT4v8NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfl4LdMG2vkPQYdAaefi/yP68Fqg6F8dQcBk8EmDdxGa+QiduVTdIGl0hrhw/T6rp
         5ihNT+s9wV/Af2n/PtW7fgCAL+Juj7WLukXuj7SbXWXBWCsjQIkkUrDREeHxn/wVTk
         6umpnOv8URAZlzBHIwBeq2wuBN6eRm9/fNYhOx0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 080/321] xfs: zero length symlinks are not valid
Date:   Tue,  3 Dec 2019 23:32:26 +0100
Message-Id: <20191203223431.321777669@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -378,6 +379,12 @@ out_release_inode:
 
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



