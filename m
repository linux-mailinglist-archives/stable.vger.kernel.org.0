Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71538259947
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbgIAQha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730150AbgIAP3P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:29:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65E2320684;
        Tue,  1 Sep 2020 15:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974154;
        bh=EpQIbEJixCkileUcO0LlClN6lDlO2BTH7YZHA6fgbkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2CF/fg5mjesa2eErOV6Cry9RDZHyaQaDraXGwSR0UEb/L1rf2FllzwkWhXh5qkB7
         6A4VDbbFVnJSLsZ4+896ntlVfS+QrA07RBFUQCEEht8kQ3IdD13gVbl3c9Mxm7EcPB
         RomNc2gqCJcjc0ghVCUKfDzKbs42JGyfyHMHCgWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/214] xfs: Dont allow logging of XFS_ISTALE inodes
Date:   Tue,  1 Sep 2020 17:08:35 +0200
Message-Id: <20200901150954.648097460@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 96355d5a1f0ee6dcc182c37db4894ec0c29f1692 ]

In tracking down a problem in this patchset, I discovered we are
reclaiming dirty stale inodes. This wasn't discovered until inodes
were always attached to the cluster buffer and then the rcu callback
that freed inodes was assert failing because the inode still had an
active pointer to the cluster buffer after it had been reclaimed.

Debugging the issue indicated that this was a pre-existing issue
resulting from the way the inodes are handled in xfs_inactive_ifree.
When we free a cluster buffer from xfs_ifree_cluster, all the inodes
in cache are marked XFS_ISTALE. Those that are clean have nothing
else done to them and so eventually get cleaned up by background
reclaim. i.e. it is assumed we'll never dirty/relog an inode marked
XFS_ISTALE.

On journal commit dirty stale inodes as are handled by both
buffer and inode log items to run though xfs_istale_done() and
removed from the AIL (buffer log item commit) or the log item will
simply unpin it because the buffer log item will clean it. What happens
to any specific inode is entirely dependent on which log item wins
the commit race, but the result is the same - stale inodes are
clean, not attached to the cluster buffer, and not in the AIL. Hence
inode reclaim can just free these inodes without further care.

However, if the stale inode is relogged, it gets dirtied again and
relogged into the CIL. Most of the time this isn't an issue, because
relogging simply changes the inode's location in the current
checkpoint. Problems arise, however, when the CIL checkpoints
between two transactions in the xfs_inactive_ifree() deferops
processing. This results in the XFS_ISTALE inode being redirtied
and inserted into the CIL without any of the other stale cluster
buffer infrastructure being in place.

Hence on journal commit, it simply gets unpinned, so it remains
dirty in memory. Everything in inode writeback avoids XFS_ISTALE
inodes so it can't be written back, and it is not tracked in the AIL
so there's not even a trigger to attempt to clean the inode. Hence
the inode just sits dirty in memory until inode reclaim comes along,
sees that it is XFS_ISTALE, and goes to reclaim it. This reclaiming
of a dirty inode caused use after free, list corruptions and other
nasty issues later in this patchset.

Hence this patch addresses a violation of the "never log XFS_ISTALE
inodes" caused by the deferops processing rolling a transaction
and relogging a stale inode in xfs_inactive_free. It also adds a
bunch of asserts to catch this problem in debug kernels so that
we don't reintroduce this problem in future.

Reproducer for this issue was generic/558 on a v4 filesystem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_inode.c |  2 ++
 fs/xfs/xfs_icache.c             |  3 ++-
 fs/xfs/xfs_inode.c              | 25 ++++++++++++++++++++++---
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index a9ad90926b873..6c7354abd0aea 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -36,6 +36,7 @@ xfs_trans_ijoin(
 
 	ASSERT(iip->ili_lock_flags == 0);
 	iip->ili_lock_flags = lock_flags;
+	ASSERT(!xfs_iflags_test(ip, XFS_ISTALE));
 
 	/*
 	 * Get a log_item_desc to point at the new item.
@@ -91,6 +92,7 @@ xfs_trans_log_inode(
 
 	ASSERT(ip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(!xfs_iflags_test(ip, XFS_ISTALE));
 
 	/*
 	 * Don't bother with i_lock for the I_DIRTY_TIME check here, as races
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d95dc9b0f0bba..a1135b86e79f9 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1132,7 +1132,7 @@ restart:
 			goto out_ifunlock;
 		xfs_iunpin_wait(ip);
 	}
-	if (xfs_iflags_test(ip, XFS_ISTALE) || xfs_inode_clean(ip)) {
+	if (xfs_inode_clean(ip)) {
 		xfs_ifunlock(ip);
 		goto reclaim;
 	}
@@ -1219,6 +1219,7 @@ reclaim:
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_qm_dqdetach(ip);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	ASSERT(xfs_inode_clean(ip));
 
 	__xfs_inode_free(ip);
 	return error;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 18f4b262e61ce..b339ff93df997 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1761,10 +1761,31 @@ xfs_inactive_ifree(
 		return error;
 	}
 
+	/*
+	 * We do not hold the inode locked across the entire rolling transaction
+	 * here. We only need to hold it for the first transaction that
+	 * xfs_ifree() builds, which may mark the inode XFS_ISTALE if the
+	 * underlying cluster buffer is freed. Relogging an XFS_ISTALE inode
+	 * here breaks the relationship between cluster buffer invalidation and
+	 * stale inode invalidation on cluster buffer item journal commit
+	 * completion, and can result in leaving dirty stale inodes hanging
+	 * around in memory.
+	 *
+	 * We have no need for serialising this inode operation against other
+	 * operations - we freed the inode and hence reallocation is required
+	 * and that will serialise on reallocating the space the deferops need
+	 * to free. Hence we can unlock the inode on the first commit of
+	 * the transaction rather than roll it right through the deferops. This
+	 * avoids relogging the XFS_ISTALE inode.
+	 *
+	 * We check that xfs_ifree() hasn't grown an internal transaction roll
+	 * by asserting that the inode is still locked when it returns.
+	 */
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, 0);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 	error = xfs_ifree(tp, ip);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	if (error) {
 		/*
 		 * If we fail to free the inode, shut down.  The cancel
@@ -1777,7 +1798,6 @@ xfs_inactive_ifree(
 			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
 		}
 		xfs_trans_cancel(tp);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		return error;
 	}
 
@@ -1795,7 +1815,6 @@ xfs_inactive_ifree(
 		xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
 			__func__, error);
 
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 }
 
-- 
2.25.1



