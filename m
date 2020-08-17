Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1124324766A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgHQP2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729980AbgHQP2A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:28:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 645C923442;
        Mon, 17 Aug 2020 15:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678080;
        bh=HPpur3AcZsnKoew8nx57JsgJtcKgbmaF7FrVy1/AC7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8TwWaonn3PJGjiPF4cbDsfqFxO8OaVrj+4IJlybVZud1DSCWVFjDyG7eHN0KH+FE
         Iw794CdYYNyHH6ujVUEtiIOgrMx/CCB1w95s6Q4plW+TQsnLJUCizOTdOA4m//Cs5s
         Z+5UFWrn1RSXRhHiYTE1ihmM6Y7e+WiThtQTKFdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 211/464] xfs: preserve rmapbt swapext block reservation from freed blocks
Date:   Mon, 17 Aug 2020 17:12:44 +0200
Message-Id: <20200817143843.918936064@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit f74681ba2006434be195402e0b15fc5763cddd7e ]

The rmapbt extent swap algorithm remaps individual extents between
the source inode and the target to trigger reverse mapping metadata
updates. If either inode straddles a format or other bmap allocation
boundary, the individual unmap and map cycles can trigger repeated
bmap block allocations and frees as the extent count bounces back
and forth across the boundary. While net block usage is bound across
the swap operation, this behavior can prematurely exhaust the
transaction block reservation because it continuously drains as the
transaction rolls. Each allocation accounts against the reservation
and each free returns to global free space on transaction roll.

The previous workaround to this problem attempted to detect this
boundary condition and provide surplus block reservation to
acommodate it. This is insufficient because more remaps can occur
than implied by the extent counts; if start offset boundaries are
not aligned between the two inodes, for example.

To address this problem more generically and dynamically, add a
transaction accounting mode that returns freed blocks to the
transaction reservation instead of the superblock counters on
transaction roll and use it when the rmapbt based algorithm is
active. This allows the chain of remap transactions to preserve the
block reservation based own its own frees and prevent premature
exhaustion regardless of the remap pattern. Note that this is only
safe for superblocks with lazy sb accounting, but the latter is
required for v5 supers and the rmap feature depends on v5.

Fixes: b3fed434822d0 ("xfs: account format bouncing into rmapbt swapext tx reservation")
Root-caused-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_shared.h |  1 +
 fs/xfs/xfs_bmap_util.c     | 18 +++++++++---------
 fs/xfs/xfs_trans.c         | 19 ++++++++++++++++++-
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c45acbd3add94..708feb8eac766 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -65,6 +65,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
 #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
 #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
+#define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
 /*
  * LOWMODE is used by the allocator to activate the lowspace algorithm - when
  * free space is running low the extent allocator may choose to allocate an
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f37f5cc4b19ff..afdc7f8e0e701 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1567,6 +1567,7 @@ xfs_swap_extents(
 	int			lock_flags;
 	uint64_t		f;
 	int			resblks = 0;
+	unsigned int		flags = 0;
 
 	/*
 	 * Lock the inodes against other IO, page faults and truncate to
@@ -1630,17 +1631,16 @@ xfs_swap_extents(
 		resblks +=  XFS_SWAP_RMAP_SPACE_RES(mp, tipnext, w);
 
 		/*
-		 * Handle the corner case where either inode might straddle the
-		 * btree format boundary. If so, the inode could bounce between
-		 * btree <-> extent format on unmap -> remap cycles, freeing and
-		 * allocating a bmapbt block each time.
+		 * If either inode straddles a bmapbt block allocation boundary,
+		 * the rmapbt algorithm triggers repeated allocs and frees as
+		 * extents are remapped. This can exhaust the block reservation
+		 * prematurely and cause shutdown. Return freed blocks to the
+		 * transaction reservation to counter this behavior.
 		 */
-		if (ipnext == (XFS_IFORK_MAXEXT(ip, w) + 1))
-			resblks += XFS_IFORK_MAXEXT(ip, w);
-		if (tipnext == (XFS_IFORK_MAXEXT(tip, w) + 1))
-			resblks += XFS_IFORK_MAXEXT(tip, w);
+		flags |= XFS_TRANS_RES_FDBLKS;
 	}
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, flags,
+				&tp);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3c94e5ff43160..0ad72a83edac4 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -107,7 +107,8 @@ xfs_trans_dup(
 
 	ntp->t_flags = XFS_TRANS_PERM_LOG_RES |
 		       (tp->t_flags & XFS_TRANS_RESERVE) |
-		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT);
+		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT) |
+		       (tp->t_flags & XFS_TRANS_RES_FDBLKS);
 	/* We gave our writer reference to the new transaction */
 	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
 	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
@@ -272,6 +273,8 @@ xfs_trans_alloc(
 	 */
 	WARN_ON(resp->tr_logres > 0 &&
 		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
+	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) ||
+	       xfs_sb_version_haslazysbcount(&mp->m_sb));
 
 	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
 	tp->t_flags = flags;
@@ -365,6 +368,20 @@ xfs_trans_mod_sb(
 			tp->t_blk_res_used += (uint)-delta;
 			if (tp->t_blk_res_used > tp->t_blk_res)
 				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		} else if (delta > 0 && (tp->t_flags & XFS_TRANS_RES_FDBLKS)) {
+			int64_t	blkres_delta;
+
+			/*
+			 * Return freed blocks directly to the reservation
+			 * instead of the global pool, being careful not to
+			 * overflow the trans counter. This is used to preserve
+			 * reservation across chains of transaction rolls that
+			 * repeatedly free and allocate blocks.
+			 */
+			blkres_delta = min_t(int64_t, delta,
+					     UINT_MAX - tp->t_blk_res);
+			tp->t_blk_res += blkres_delta;
+			delta -= blkres_delta;
 		}
 		tp->t_fdblocks_delta += delta;
 		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
-- 
2.25.1



