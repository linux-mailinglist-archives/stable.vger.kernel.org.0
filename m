Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6439726F141
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgIRCt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728177AbgIRCIx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA63D238E3;
        Fri, 18 Sep 2020 02:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394932;
        bh=4PwkSFMWOCQJC7zaA2ks7y7nlNVb9NCmESc2CwFrQGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BM0IjNWg18JLKTrAfN+59lJmzhBT/pcd64pvng8B1TJBQnvFf6xIyM9hX/YuzqOJf
         vYDJEimO8bILCasUR0SHIGBi2XJ2SXyGiZwC3fbfSleVTTzb3R5O/nubR1HaSLBO8T
         PxXpwGqloNjtVjayydLdQCR8d9pIcDSR3rzSideo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Omar Sandoval <osandov@osandov.com>,
        Brian Foster <bfoster@redhat.com>,
        Sasha Levin <sashal@kernel.org>, xfs@oss.sgi.com
Subject: [PATCH AUTOSEL 4.19 042/206] xfs: fix log reservation overflows when allocating large rt extents
Date:   Thu, 17 Sep 2020 22:05:18 -0400
Message-Id: <20200918020802.2065198-42-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit b1de6fc7520fe12949c070af0e8c0e4044cd3420 ]

Omar Sandoval reported that a 4G fallocate on the realtime device causes
filesystem shutdowns due to a log reservation overflow that happens when
we log the rtbitmap updates.  Factor rtbitmap/rtsummary updates into the
the tr_write and tr_itruncate log reservation calculation.

"The following reproducer results in a transaction log overrun warning
for me:

    mkfs.xfs -f -r rtdev=/dev/vdc -d rtinherit=1 -m reflink=0 /dev/vdb
    mount -o rtdev=/dev/vdc /dev/vdb /mnt
    fallocate -l 4G /mnt/foo

Reported-by: Omar Sandoval <osandov@osandov.com>
Tested-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 96 +++++++++++++++++++++++++++-------
 1 file changed, 77 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index f99a7aefe4184..2b3cc5a8ced1b 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -197,6 +197,24 @@ xfs_calc_inode_chunk_res(
 	return res;
 }
 
+/*
+ * Per-extent log reservation for the btree changes involved in freeing or
+ * allocating a realtime extent.  We have to be able to log as many rtbitmap
+ * blocks as needed to mark inuse MAXEXTLEN blocks' worth of realtime extents,
+ * as well as the realtime summary block.
+ */
+unsigned int
+xfs_rtalloc_log_count(
+	struct xfs_mount	*mp,
+	unsigned int		num_ops)
+{
+	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
+	unsigned int		rtbmp_bytes;
+
+	rtbmp_bytes = (MAXEXTLEN / mp->m_sb.sb_rextsize) / NBBY;
+	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
+}
+
 /*
  * Various log reservation values.
  *
@@ -219,13 +237,21 @@ xfs_calc_inode_chunk_res(
 
 /*
  * In a write transaction we can allocate a maximum of 2
- * extents.  This gives:
+ * extents.  This gives (t1):
  *    the inode getting the new extents: inode size
  *    the inode's bmap btree: max depth * block size
  *    the agfs of the ags from which the extents are allocated: 2 * sector
  *    the superblock free block counter: sector size
  *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
- * And the bmap_finish transaction can free bmap blocks in a join:
+ * Or, if we're writing to a realtime file (t2):
+ *    the inode getting the new extents: inode size
+ *    the inode's bmap btree: max depth * block size
+ *    the agfs of the ags from which the extents are allocated: 2 * sector
+ *    the superblock free block counter: sector size
+ *    the realtime bitmap: ((MAXEXTLEN / rtextsize) / NBBY) bytes
+ *    the realtime summary: 1 block
+ *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
+ * And the bmap_finish transaction can free bmap blocks in a join (t3):
  *    the agfs of the ags containing the blocks: 2 * sector size
  *    the agfls of the ags containing the blocks: 2 * sector size
  *    the super block free block counter: sector size
@@ -235,40 +261,72 @@ STATIC uint
 xfs_calc_write_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		max((xfs_calc_inode_res(mp, 1) +
+	unsigned int		t1, t2, t3;
+	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
+
+	t1 = xfs_calc_inode_res(mp, 1) +
+	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), blksz) +
+	     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
+
+	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
+		t2 = xfs_calc_inode_res(mp, 1) +
 		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
-				      XFS_FSB_TO_B(mp, 1)) +
+				     blksz) +
 		     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
-				      XFS_FSB_TO_B(mp, 1))));
+		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 1), blksz) +
+		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1), blksz);
+	} else {
+		t2 = 0;
+	}
+
+	t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
+
+	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
 }
 
 /*
- * In truncating a file we free up to two extents at once.  We can modify:
+ * In truncating a file we free up to two extents at once.  We can modify (t1):
  *    the inode being truncated: inode size
  *    the inode's bmap btree: (max depth + 1) * block size
- * And the bmap_finish transaction can free the blocks and bmap blocks:
+ * And the bmap_finish transaction can free the blocks and bmap blocks (t2):
  *    the agf for each of the ags: 4 * sector size
  *    the agfl for each of the ags: 4 * sector size
  *    the super block to reflect the freed blocks: sector size
  *    worst case split in allocation btrees per extent assuming 4 extents:
  *		4 exts * 2 trees * (2 * max depth - 1) * block size
+ * Or, if it's a realtime file (t3):
+ *    the agf for each of the ags: 2 * sector size
+ *    the agfl for each of the ags: 2 * sector size
+ *    the super block to reflect the freed blocks: sector size
+ *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
+ *    the realtime summary: 2 exts * 1 block
+ *    worst case split in allocation btrees per extent assuming 2 extents:
+ *		2 exts * 2 trees * (2 * max depth - 1) * block size
  */
 STATIC uint
 xfs_calc_itruncate_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		max((xfs_calc_inode_res(mp, 1) +
-		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1,
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int		t1, t2, t3;
+	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
+
+	t1 = xfs_calc_inode_res(mp, 1) +
+	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1, blksz);
+
+	t2 = xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4), blksz);
+
+	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
+		t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 2), blksz) +
+		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
+	} else {
+		t3 = 0;
+	}
+
+	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
 }
 
 /*
-- 
2.25.1

