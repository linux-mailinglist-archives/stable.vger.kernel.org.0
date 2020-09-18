Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3519726F475
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgIRDOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgIRCBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1210320853;
        Fri, 18 Sep 2020 02:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394498;
        bh=3QIRnvGoGR32Y22SZT4wMKErdcT9TQCgK//mFViaPYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gA5G9dpZR0K5XH52dFqanmrxLGajHCB1pOMYCllyE38NvpWZl3SNWSI9NY+y5BzSG
         XXDW4mTMyRi99o1WobLdh8vXpO0tNCVDzXJdLgQvGLU/OpeiyEBIhPa52yTnoZwY3H
         rotcf4xTCRVa1DxoZpoItAdLy8l7t8eWvfsGmenw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, xfs@oss.sgi.com
Subject: [PATCH AUTOSEL 5.4 023/330] xfs: properly serialise fallocate against AIO+DIO
Date:   Thu, 17 Sep 2020 21:56:03 -0400
Message-Id: <20200918020110.2063155-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 249bd9087a5264d2b8a974081870e2e27671b4dc ]

AIO+DIO can extend the file size on IO completion, and it holds
no inode locks while the IO is in flight. Therefore, a race
condition exists in file size updates if we do something like this:

aio-thread			fallocate-thread

lock inode
submit IO beyond inode->i_size
unlock inode
.....
				lock inode
				break layouts
				if (off + len > inode->i_size)
					new_size = off + len
				.....
				inode_dio_wait()
				<blocks>
.....
completes
inode->i_size updated
inode_dio_done()
....
				<wakes>
				<does stuff no long beyond EOF>
				if (new_size)
					xfs_vn_setattr(inode, new_size)

Yup, that attempt to extend the file size in the fallocate code
turns into a truncate - it removes the whatever the aio write
allocated and put to disk, and reduced the inode size back down to
where the fallocate operation ends.

Fundamentally, xfs_file_fallocate()  not compatible with racing
AIO+DIO completions, so we need to move the inode_dio_wait() call
up to where the lock the inode and break the layouts.

Secondly, storing the inode size and then using it unchecked without
holding the ILOCK is not safe; we can only do such a thing if we've
locked out and drained all IO and other modification operations,
which we don't do initially in xfs_file_fallocate.

It should be noted that some of the fallocate operations are
compound operations - they are made up of multiple manipulations
that may zero data, and so we may need to flush and invalidate the
file multiple times during an operation. However, we only need to
lock out IO and other space manipulation operations once, as that
lockout is maintained until the entire fallocate operation has been
completed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |  8 +-------
 fs/xfs/xfs_file.c      | 30 ++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c     |  1 +
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0c71acc1b8317..d6d78e1276254 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1039,6 +1039,7 @@ out_trans_cancel:
 	goto out_unlock;
 }
 
+/* Caller must first wait for the completion of any pending DIOs if required. */
 int
 xfs_flush_unmap_range(
 	struct xfs_inode	*ip,
@@ -1050,9 +1051,6 @@ xfs_flush_unmap_range(
 	xfs_off_t		rounding, start, end;
 	int			error;
 
-	/* wait for the completion of any pending DIOs */
-	inode_dio_wait(inode);
-
 	rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_SIZE);
 	start = round_down(offset, rounding);
 	end = round_up(offset + len, rounding) - 1;
@@ -1084,10 +1082,6 @@ xfs_free_file_space(
 	if (len <= 0)	/* if nothing being freed */
 		return 0;
 
-	error = xfs_flush_unmap_range(ip, offset, len);
-	if (error)
-		return error;
-
 	startoffset_fsb = XFS_B_TO_FSB(mp, offset);
 	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 1e2176190c86f..203065a647652 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -818,6 +818,36 @@ xfs_file_fallocate(
 	if (error)
 		goto out_unlock;
 
+	/*
+	 * Must wait for all AIO to complete before we continue as AIO can
+	 * change the file size on completion without holding any locks we
+	 * currently hold. We must do this first because AIO can update both
+	 * the on disk and in memory inode sizes, and the operations that follow
+	 * require the in-memory size to be fully up-to-date.
+	 */
+	inode_dio_wait(inode);
+
+	/*
+	 * Now AIO and DIO has drained we flush and (if necessary) invalidate
+	 * the cached range over the first operation we are about to run.
+	 *
+	 * We care about zero and collapse here because they both run a hole
+	 * punch over the range first. Because that can zero data, and the range
+	 * of invalidation for the shift operations is much larger, we still do
+	 * the required flush for collapse in xfs_prepare_shift().
+	 *
+	 * Insert has the same range requirements as collapse, and we extend the
+	 * file first which can zero data. Hence insert has the same
+	 * flush/invalidate requirements as collapse and so they are both
+	 * handled at the right time by xfs_prepare_shift().
+	 */
+	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
+		    FALLOC_FL_COLLAPSE_RANGE)) {
+		error = xfs_flush_unmap_range(ip, offset, len);
+		if (error)
+			goto out_unlock;
+	}
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index c93c4b7328ef7..60c4526312771 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -622,6 +622,7 @@ xfs_ioc_space(
 	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
 	if (error)
 		goto out_unlock;
+	inode_dio_wait(inode);
 
 	switch (bf->l_whence) {
 	case 0: /*SEEK_SET*/
-- 
2.25.1

