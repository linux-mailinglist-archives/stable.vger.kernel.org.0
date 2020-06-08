Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EFB1F2F0B
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733166AbgFIArC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:47:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728903AbgFHXL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:11:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACE9E20C09;
        Mon,  8 Jun 2020 23:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657887;
        bh=c6jaHtTdzzzvmrih3uxZ8mvKcgiUbE+snM8tDjzWFGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szzMRUmN7qqizXeutbjU1wnnQKV3/zf8jtmoY18NQSQqvct5KajZDjqSME88lpzOe
         PJvuX82qrVbMInBiX1476umxe6Cp3w04Q40K9c8du4Fr7coSYaSJyQ1Wzfg/k8rhDh
         wJ+Fx56NACda9mGTYJ6BoDXdd0YOq6hH7noZ4nEU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 243/274] xfs: measure all contiguous previous extents for prealloc size
Date:   Mon,  8 Jun 2020 19:05:36 -0400
Message-Id: <20200608230607.3361041-243-sashal@kernel.org>
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

[ Upstream commit f0322c7cc05eb23ef034775f9b39254cbd4f3678 ]

When we're estimating a new speculative preallocation length for an
extending write, we should walk backwards through the extent list to
determine the number of number of blocks that are physically and
logically contiguous with the write offset, and use that as an input to
the preallocation size computation.

This way, preallocation length is truly measured by the effectiveness of
the allocator in giving us contiguous allocations without being
influenced by the state of a given extent.  This fixes both the problem
where ZERO_RANGE within an EOF can reduce preallocation, and prevents
the unnecessary shrinkage of preallocation when delalloc extents are
turned into unwritten extents.

This was found as a regression in xfs/014 after changing delalloc writes
to create unwritten extents during writeback.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_iomap.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index bb590a267a7f..e3ca124a99e4 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -377,15 +377,17 @@ xfs_iomap_prealloc_size(
 	loff_t			count,
 	struct xfs_iext_cursor	*icur)
 {
+	struct xfs_iext_cursor	ncur = *icur;
+	struct xfs_bmbt_irec	prev, got;
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	struct xfs_bmbt_irec	prev;
-	int			shift = 0;
 	int64_t			freesp;
 	xfs_fsblock_t		qblocks;
-	int			qshift = 0;
 	xfs_fsblock_t		alloc_blocks = 0;
+	xfs_extlen_t		plen;
+	int			shift = 0;
+	int			qshift = 0;
 
 	if (offset + count <= XFS_ISIZE(ip))
 		return 0;
@@ -400,7 +402,7 @@ xfs_iomap_prealloc_size(
 	 */
 	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) ||
 	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
-	    !xfs_iext_peek_prev_extent(ifp, icur, &prev) ||
+	    !xfs_iext_prev_extent(ifp, &ncur, &prev) ||
 	    prev.br_startoff + prev.br_blockcount < offset_fsb)
 		return mp->m_allocsize_blocks;
 
@@ -413,16 +415,28 @@ xfs_iomap_prealloc_size(
 	 * preallocation size.
 	 *
 	 * If the extent is a hole, then preallocation is essentially disabled.
-	 * Otherwise we take the size of the preceding data extent as the basis
-	 * for the preallocation size. If the size of the extent is greater than
-	 * half the maximum extent length, then use the current offset as the
-	 * basis. This ensures that for large files the preallocation size
-	 * always extends to MAXEXTLEN rather than falling short due to things
-	 * like stripe unit/width alignment of real extents.
+	 * Otherwise we take the size of the preceding data extents as the basis
+	 * for the preallocation size. Note that we don't care if the previous
+	 * extents are written or not.
+	 *
+	 * If the size of the extents is greater than half the maximum extent
+	 * length, then use the current offset as the basis. This ensures that
+	 * for large files the preallocation size always extends to MAXEXTLEN
+	 * rather than falling short due to things like stripe unit/width
+	 * alignment of real extents.
 	 */
-	if (prev.br_blockcount <= (MAXEXTLEN >> 1))
-		alloc_blocks = prev.br_blockcount << 1;
-	else
+	plen = prev.br_blockcount;
+	while (xfs_iext_prev_extent(ifp, &ncur, &got)) {
+		if (plen > MAXEXTLEN / 2 ||
+		    isnullstartblock(got.br_startblock) ||
+		    got.br_startoff + got.br_blockcount != prev.br_startoff ||
+		    got.br_startblock + got.br_blockcount != prev.br_startblock)
+			break;
+		plen += got.br_blockcount;
+		prev = got;
+	}
+	alloc_blocks = plen * 2;
+	if (alloc_blocks > MAXEXTLEN)
 		alloc_blocks = XFS_B_TO_FSB(mp, offset);
 	if (!alloc_blocks)
 		goto check_writeio;
-- 
2.25.1

