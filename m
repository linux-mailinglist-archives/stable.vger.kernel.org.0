Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2A45407CC
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347082AbiFGRwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349159AbiFGRue (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:50:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E760A11825;
        Tue,  7 Jun 2022 10:37:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D69761534;
        Tue,  7 Jun 2022 17:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEEEC385A5;
        Tue,  7 Jun 2022 17:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623474;
        bh=jR5s3Ypb1MTMNYEF/AV9ntqzryfF/tWSuG1hMJfGYz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2a96sKNSECWAcgUs4aherwNYQk3jP/Bpkv3HvEh0Fez8u3qoK5N5SinSwKBFwZfhI
         632yw92RIap9mn884/VMZkoM1WrH4BEODcHYrt59nqnVFq0SFbZ53VP6QavkOsd+2s
         azT62n9TM9n2RnT+AUjUcMofMAMBTcV/fPQGtIKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 432/452] xfs: fix chown leaking delalloc quota blocks when fssetxattr fails
Date:   Tue,  7 Jun 2022 19:04:49 +0200
Message-Id: <20220607164921.428582341@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 1aecf3734a95f3c167d1495550ca57556d33f7ec upstream.

While refactoring the quota code to create a function to allocate inode
change transactions, I noticed that xfs_qm_vop_chown_reserve does more
than just make reservations: it also *modifies* the incore counts
directly to handle the owner id change for the delalloc blocks.

I then observed that the fssetxattr code continues validating input
arguments after making the quota reservation but before dirtying the
transaction.  If the routine decides to error out, it fails to undo the
accounting switch!  This leads to incorrect quota reservation and
failure down the line.

We can fix this by making the reservation function do only that -- for
the new dquot, it reserves ondisk and delalloc blocks to the
transaction, and the old dquot hangs on to its incore reservation for
now.  Once we actually switch the dquots, we can then update the incore
reservations because we've dirtied the transaction and it's too late to
turn back now.

No fixes tag because this has been broken since the start of git.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_qm.c |   92 +++++++++++++++++++++-----------------------------------
 1 file changed, 35 insertions(+), 57 deletions(-)

--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1786,6 +1786,29 @@ xfs_qm_vop_chown(
 	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_ICOUNT, 1);
 
 	/*
+	 * Back when we made quota reservations for the chown, we reserved the
+	 * ondisk blocks + delalloc blocks with the new dquot.  Now that we've
+	 * switched the dquots, decrease the new dquot's block reservation
+	 * (having already bumped up the real counter) so that we don't have
+	 * any reservation to give back when we commit.
+	 */
+	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_RES_BLKS,
+			-ip->i_delayed_blks);
+
+	/*
+	 * Give the incore reservation for delalloc blocks back to the old
+	 * dquot.  We don't normally handle delalloc quota reservations
+	 * transactionally, so just lock the dquot and subtract from the
+	 * reservation.  Dirty the transaction because it's too late to turn
+	 * back now.
+	 */
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	xfs_dqlock(prevdq);
+	ASSERT(prevdq->q_blk.reserved >= ip->i_delayed_blks);
+	prevdq->q_blk.reserved -= ip->i_delayed_blks;
+	xfs_dqunlock(prevdq);
+
+	/*
 	 * Take an extra reference, because the inode is going to keep
 	 * this dquot pointer even after the trans_commit.
 	 */
@@ -1807,84 +1830,39 @@ xfs_qm_vop_chown_reserve(
 	uint			flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	uint64_t		delblks;
 	unsigned int		blkflags;
-	struct xfs_dquot	*udq_unres = NULL;
-	struct xfs_dquot	*gdq_unres = NULL;
-	struct xfs_dquot	*pdq_unres = NULL;
 	struct xfs_dquot	*udq_delblks = NULL;
 	struct xfs_dquot	*gdq_delblks = NULL;
 	struct xfs_dquot	*pdq_delblks = NULL;
-	int			error;
-
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
-	delblks = ip->i_delayed_blks;
 	blkflags = XFS_IS_REALTIME_INODE(ip) ?
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    i_uid_read(VFS_I(ip)) != udqp->q_id) {
+	    i_uid_read(VFS_I(ip)) != udqp->q_id)
 		udq_delblks = udqp;
-		/*
-		 * If there are delayed allocation blocks, then we have to
-		 * unreserve those from the old dquot, and add them to the
-		 * new dquot.
-		 */
-		if (delblks) {
-			ASSERT(ip->i_udquot);
-			udq_unres = ip->i_udquot;
-		}
-	}
+
 	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
-	    i_gid_read(VFS_I(ip)) != gdqp->q_id) {
+	    i_gid_read(VFS_I(ip)) != gdqp->q_id)
 		gdq_delblks = gdqp;
-		if (delblks) {
-			ASSERT(ip->i_gdquot);
-			gdq_unres = ip->i_gdquot;
-		}
-	}
 
 	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
-	    ip->i_d.di_projid != pdqp->q_id) {
+	    ip->i_d.di_projid != pdqp->q_id)
 		pdq_delblks = pdqp;
-		if (delblks) {
-			ASSERT(ip->i_pdquot);
-			pdq_unres = ip->i_pdquot;
-		}
-	}
-
-	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
-				udq_delblks, gdq_delblks, pdq_delblks,
-				ip->i_d.di_nblocks, 1, flags | blkflags);
-	if (error)
-		return error;
 
 	/*
-	 * Do the delayed blks reservations/unreservations now. Since, these
-	 * are done without the help of a transaction, if a reservation fails
-	 * its previous reservations won't be automatically undone by trans
-	 * code. So, we have to do it manually here.
+	 * Reserve enough quota to handle blocks on disk and reserved for a
+	 * delayed allocation.  We'll actually transfer the delalloc
+	 * reservation between dquots at chown time, even though that part is
+	 * only semi-transactional.
 	 */
-	if (delblks) {
-		/*
-		 * Do the reservations first. Unreservation can't fail.
-		 */
-		ASSERT(udq_delblks || gdq_delblks || pdq_delblks);
-		ASSERT(udq_unres || gdq_unres || pdq_unres);
-		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-			    udq_delblks, gdq_delblks, pdq_delblks,
-			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
-		if (error)
-			return error;
-		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-				udq_unres, gdq_unres, pdq_unres,
-				-((xfs_qcnt_t)delblks), 0, blkflags);
-	}
-
-	return 0;
+	return xfs_trans_reserve_quota_bydquots(tp, ip->i_mount, udq_delblks,
+			gdq_delblks, pdq_delblks,
+			ip->i_d.di_nblocks + ip->i_delayed_blks,
+			1, blkflags | flags);
 }
 
 int


