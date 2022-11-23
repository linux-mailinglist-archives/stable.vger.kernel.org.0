Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DA663549D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237154AbiKWJKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbiKWJKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:10:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05C917407
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:10:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30535B81EEB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D77C433C1;
        Wed, 23 Nov 2022 09:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194600;
        bh=wpMwjw4ZepM7rjo3QZxh8DIYaOVXxtm4fPRYBGEIn/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euEd7CobhuCGUe8PVHXg09gNSRmbouByCn2IZ0ajzAswbvTCSK726EdBO81GpMR1f
         RdGL3XDuqzLsAlPD8s3BQiLjW8Cmb0lrUQttIYuLhEfSXgCR2a0wY7esDonxudPk8R
         5ydJXjw8OtHzYuvJqEsVEmTv4iOv0poYVKPMRpSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 001/156] xfs: preserve rmapbt swapext block reservation from freed blocks
Date:   Wed, 23 Nov 2022 09:49:18 +0100
Message-Id: <20221123084557.882657394@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit f74681ba2006434be195402e0b15fc5763cddd7e upstream.

[Slightly modify xfs_trans_alloc() to fix a merge conflict due to missing
 "atomic_inc(&mp->m_active_trans)" statement in v5.9 kernel]

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
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_shared.h |    1 +
 fs/xfs/xfs_bmap_util.c     |   18 +++++++++---------
 fs/xfs/xfs_trans.c         |   19 ++++++++++++++++++-
 3 files changed, 28 insertions(+), 10 deletions(-)

--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -65,6 +65,7 @@ void	xfs_log_get_max_trans_res(struct xf
 #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
 #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
 #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
+#define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
 /*
  * LOWMODE is used by the allocator to activate the lowspace algorithm - when
  * free space is running low the extent allocator may choose to allocate an
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1740,6 +1740,7 @@ xfs_swap_extents(
 	int			lock_flags;
 	uint64_t		f;
 	int			resblks = 0;
+	unsigned int		flags = 0;
 
 	/*
 	 * Lock the inodes against other IO, page faults and truncate to
@@ -1795,17 +1796,16 @@ xfs_swap_extents(
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
@@ -273,6 +274,8 @@ xfs_trans_alloc(
 	 */
 	WARN_ON(resp->tr_logres > 0 &&
 		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
+	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) ||
+	       xfs_sb_version_haslazysbcount(&mp->m_sb));
 	atomic_inc(&mp->m_active_trans);
 
 	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
@@ -368,6 +371,20 @@ xfs_trans_mod_sb(
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


