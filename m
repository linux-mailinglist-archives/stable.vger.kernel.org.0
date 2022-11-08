Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFC4621359
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiKHNt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbiKHNt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:49:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B685E5C
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:49:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C90961596
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC54C433C1;
        Tue,  8 Nov 2022 13:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915365;
        bh=3Z/04EcQBnV5yb+bNbMfnCEgeFHTJ/KXYg8anu0JTNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhPeIWLPdk88Dc5dZ2CAA1dvELKhLflgf17z7oX9+CYCT7pvQAMZI3KqC5yJRXX/N
         6n6A/ADdgRR+dmSQ0xenKe57XQ9urNK7t7Df6Wud8SBo+/S9GZ+w/IZgVZsSNJ2PsS
         4sp1jepNaOfDiGxMRtgtpdQElQmuFpDfLeKg5aSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 39/74] xfs: gut error handling in xfs_trans_unreserve_and_mod_sb()
Date:   Tue,  8 Nov 2022 14:39:07 +0100
Message-Id: <20221108133335.335644067@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dave Chinner <david@fromorbit.com>

commit dc3ffbb14060c943469d5e12900db3a60bc3fa64 upstream.

The error handling in xfs_trans_unreserve_and_mod_sb() is largely
incorrect - rolling back the changes in the transaction if only one
counter underruns makes all the other counters incorrect. We still
allow the change to proceed and committing the transaction, except
now we have multiple incorrect counters instead of a single
underflow.

Further, we don't actually report the error to the caller, so this
is completely silent except on debug kernels that will assert on
failure before we even get to the rollback code.  Hence this error
handling is broken, untested, and largely unnecessary complexity.

Just remove it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_trans.c |  163 ++++++-----------------------------------------------
 1 file changed, 20 insertions(+), 143 deletions(-)

--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -532,57 +532,9 @@ xfs_trans_apply_sb_deltas(
 				  sizeof(sbp->sb_frextents) - 1);
 }
 
-STATIC int
-xfs_sb_mod8(
-	uint8_t			*field,
-	int8_t			delta)
-{
-	int8_t			counter = *field;
-
-	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
-	*field = counter;
-	return 0;
-}
-
-STATIC int
-xfs_sb_mod32(
-	uint32_t		*field,
-	int32_t			delta)
-{
-	int32_t			counter = *field;
-
-	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
-	*field = counter;
-	return 0;
-}
-
-STATIC int
-xfs_sb_mod64(
-	uint64_t		*field,
-	int64_t			delta)
-{
-	int64_t			counter = *field;
-
-	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
-	*field = counter;
-	return 0;
-}
-
 /*
- * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations
- * and apply superblock counter changes to the in-core superblock.  The
+ * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations and
+ * apply superblock counter changes to the in-core superblock.  The
  * t_res_fdblocks_delta and t_res_frextents_delta fields are explicitly NOT
  * applied to the in-core superblock.  The idea is that that has already been
  * done.
@@ -627,20 +579,17 @@ xfs_trans_unreserve_and_mod_sb(
 	/* apply the per-cpu counters */
 	if (blkdelta) {
 		error = xfs_mod_fdblocks(mp, blkdelta, rsvd);
-		if (error)
-			goto out;
+		ASSERT(!error);
 	}
 
 	if (idelta) {
 		error = xfs_mod_icount(mp, idelta);
-		if (error)
-			goto out_undo_fdblocks;
+		ASSERT(!error);
 	}
 
 	if (ifreedelta) {
 		error = xfs_mod_ifree(mp, ifreedelta);
-		if (error)
-			goto out_undo_icount;
+		ASSERT(!error);
 	}
 
 	if (rtxdelta == 0 && !(tp->t_flags & XFS_TRANS_SB_DIRTY))
@@ -648,95 +597,23 @@ xfs_trans_unreserve_and_mod_sb(
 
 	/* apply remaining deltas */
 	spin_lock(&mp->m_sb_lock);
-	if (rtxdelta) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_frextents, rtxdelta);
-		if (error)
-			goto out_undo_ifree;
-	}
-
-	if (tp->t_dblocks_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_dblocks, tp->t_dblocks_delta);
-		if (error)
-			goto out_undo_frextents;
-	}
-	if (tp->t_agcount_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_agcount, tp->t_agcount_delta);
-		if (error)
-			goto out_undo_dblocks;
-	}
-	if (tp->t_imaxpct_delta != 0) {
-		error = xfs_sb_mod8(&mp->m_sb.sb_imax_pct, tp->t_imaxpct_delta);
-		if (error)
-			goto out_undo_agcount;
-	}
-	if (tp->t_rextsize_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_rextsize,
-				     tp->t_rextsize_delta);
-		if (error)
-			goto out_undo_imaxpct;
-	}
-	if (tp->t_rbmblocks_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_rbmblocks,
-				     tp->t_rbmblocks_delta);
-		if (error)
-			goto out_undo_rextsize;
-	}
-	if (tp->t_rblocks_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_rblocks, tp->t_rblocks_delta);
-		if (error)
-			goto out_undo_rbmblocks;
-	}
-	if (tp->t_rextents_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_rextents,
-				     tp->t_rextents_delta);
-		if (error)
-			goto out_undo_rblocks;
-	}
-	if (tp->t_rextslog_delta != 0) {
-		error = xfs_sb_mod8(&mp->m_sb.sb_rextslog,
-				     tp->t_rextslog_delta);
-		if (error)
-			goto out_undo_rextents;
-	}
+	mp->m_sb.sb_frextents += rtxdelta;
+	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
+	mp->m_sb.sb_agcount += tp->t_agcount_delta;
+	mp->m_sb.sb_imax_pct += tp->t_imaxpct_delta;
+	mp->m_sb.sb_rextsize += tp->t_rextsize_delta;
+	mp->m_sb.sb_rbmblocks += tp->t_rbmblocks_delta;
+	mp->m_sb.sb_rblocks += tp->t_rblocks_delta;
+	mp->m_sb.sb_rextents += tp->t_rextents_delta;
+	mp->m_sb.sb_rextslog += tp->t_rextslog_delta;
 	spin_unlock(&mp->m_sb_lock);
-	return;
 
-out_undo_rextents:
-	if (tp->t_rextents_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_rextents, -tp->t_rextents_delta);
-out_undo_rblocks:
-	if (tp->t_rblocks_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_rblocks, -tp->t_rblocks_delta);
-out_undo_rbmblocks:
-	if (tp->t_rbmblocks_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_rbmblocks, -tp->t_rbmblocks_delta);
-out_undo_rextsize:
-	if (tp->t_rextsize_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_rextsize, -tp->t_rextsize_delta);
-out_undo_imaxpct:
-	if (tp->t_rextsize_delta)
-		xfs_sb_mod8(&mp->m_sb.sb_imax_pct, -tp->t_imaxpct_delta);
-out_undo_agcount:
-	if (tp->t_agcount_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_agcount, -tp->t_agcount_delta);
-out_undo_dblocks:
-	if (tp->t_dblocks_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_dblocks, -tp->t_dblocks_delta);
-out_undo_frextents:
-	if (rtxdelta)
-		xfs_sb_mod64(&mp->m_sb.sb_frextents, -rtxdelta);
-out_undo_ifree:
-	spin_unlock(&mp->m_sb_lock);
-	if (ifreedelta)
-		xfs_mod_ifree(mp, -ifreedelta);
-out_undo_icount:
-	if (idelta)
-		xfs_mod_icount(mp, -idelta);
-out_undo_fdblocks:
-	if (blkdelta)
-		xfs_mod_fdblocks(mp, -blkdelta, rsvd);
-out:
-	ASSERT(error == 0);
+	/*
+	 * Debug checks outside of the spinlock so they don't lock up the
+	 * machine if they fail.
+	 */
+	ASSERT(mp->m_sb.sb_imax_pct >= 0);
+	ASSERT(mp->m_sb.sb_rextslog >= 0);
 	return;
 }
 


