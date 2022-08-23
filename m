Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DEE59E2B4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353473AbiHWKPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353330AbiHWKNX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:13:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B025772867;
        Tue, 23 Aug 2022 01:59:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BCCE61524;
        Tue, 23 Aug 2022 08:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC2AC433C1;
        Tue, 23 Aug 2022 08:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245166;
        bh=KCJgGOsG7JIve/c6zy0V7gbx6eKV2MhqDYu1kgomsXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJSqwUd+gcqNFSkq85VTfZV5U0sckgtQhRie9rOONVavJTcyojrOHusOFuwPvRAQ0
         tNIR9Cu+hx+8lyaKeVRg2Wic6b4oHe/Ic7EpqHuRF6BrAXIgiAyP5BhCqFZcpPgzeu
         qChBZjQsmXF/RkFm7Ef/i2sH2pporUeeZaxnOtb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 237/244] xfs: reserve quota for dir expansion when linking/unlinking files
Date:   Tue, 23 Aug 2022 10:26:36 +0200
Message-Id: <20220823080107.495015228@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 871b9316e7a778ff97bdc34fdb2f2977f616651d ]

XFS does not reserve quota for directory expansion when linking or
unlinking children from a directory.  This means that we don't reject
the expansion with EDQUOT when we're at or near a hard limit, which
means that unprivileged userspace can use link()/unlink() to exceed
quota.

The fix for this is nuanced -- link operations don't always expand the
directory, and we allow a link to proceed with no space reservation if
we don't need to add a block to the directory to handle the addition.
Unlink operations generally do not expand the directory (you'd have to
free a block and then cause a btree split) and we can defer the
directory block freeing if there is no space reservation.

Moreover, there is a further bug in that we do not trigger the blockgc
workers to try to clear space when we're out of quota.

To fix both cases, create a new xfs_trans_alloc_dir function that
allocates the transaction, locks and joins the inodes, and reserves
quota for the directory.  If there isn't sufficient space or quota,
we'll switch the caller to reservationless mode.  This should prevent
quota usage overruns with the least restriction in functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |   46 ++++++++++------------------
 fs/xfs/xfs_trans.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h |    3 +
 3 files changed, 106 insertions(+), 29 deletions(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1223,7 +1223,7 @@ xfs_link(
 {
 	xfs_mount_t		*mp = tdp->i_mount;
 	xfs_trans_t		*tp;
-	int			error;
+	int			error, nospace_error = 0;
 	int			resblks;
 
 	trace_xfs_link(tdp, target_name);
@@ -1242,19 +1242,11 @@ xfs_link(
 		goto std_return;
 
 	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, resblks, 0, 0, &tp);
-	if (error == -ENOSPC) {
-		resblks = 0;
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0, &tp);
-	}
+	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
+			&tp, &nospace_error);
 	if (error)
 		goto std_return;
 
-	xfs_lock_two_inodes(sip, XFS_ILOCK_EXCL, tdp, XFS_ILOCK_EXCL);
-
-	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
-
 	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
 			XFS_IEXT_DIR_MANIP_CNT(mp));
 	if (error)
@@ -1312,6 +1304,8 @@ xfs_link(
  error_return:
 	xfs_trans_cancel(tp);
  std_return:
+	if (error == -ENOSPC && nospace_error)
+		error = nospace_error;
 	return error;
 }
 
@@ -2761,6 +2755,7 @@ xfs_remove(
 	xfs_mount_t		*mp = dp->i_mount;
 	xfs_trans_t             *tp = NULL;
 	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
+	int			dontcare;
 	int                     error = 0;
 	uint			resblks;
 
@@ -2778,31 +2773,24 @@ xfs_remove(
 		goto std_return;
 
 	/*
-	 * We try to get the real space reservation first,
-	 * allowing for directory btree deletion(s) implying
-	 * possible bmap insert(s).  If we can't get the space
-	 * reservation then we use 0 instead, and avoid the bmap
-	 * btree insert(s) in the directory code by, if the bmap
-	 * insert tries to happen, instead trimming the LAST
-	 * block from the directory.
+	 * We try to get the real space reservation first, allowing for
+	 * directory btree deletion(s) implying possible bmap insert(s).  If we
+	 * can't get the space reservation then we use 0 instead, and avoid the
+	 * bmap btree insert(s) in the directory code by, if the bmap insert
+	 * tries to happen, instead trimming the LAST block from the directory.
+	 *
+	 * Ignore EDQUOT and ENOSPC being returned via nospace_error because
+	 * the directory code can handle a reservationless update and we don't
+	 * want to prevent a user from trying to free space by deleting things.
 	 */
 	resblks = XFS_REMOVE_SPACE_RES(mp);
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, resblks, 0, 0, &tp);
-	if (error == -ENOSPC) {
-		resblks = 0;
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, 0, 0, 0,
-				&tp);
-	}
+	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
+			&tp, &dontcare);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto std_return;
 	}
 
-	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
-
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-
 	/*
 	 * If we're removing a directory perform some additional validation.
 	 */
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1201,3 +1201,89 @@ out_cancel:
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/*
+ * Allocate an transaction, lock and join the directory and child inodes to it,
+ * and reserve quota for a directory update.  If there isn't sufficient space,
+ * @dblocks will be set to zero for a reservationless directory update and
+ * @nospace_error will be set to a negative errno describing the space
+ * constraint we hit.
+ *
+ * The caller must ensure that the on-disk dquots attached to this inode have
+ * already been allocated and initialized.  The ILOCKs will be dropped when the
+ * transaction is committed or cancelled.
+ */
+int
+xfs_trans_alloc_dir(
+	struct xfs_inode	*dp,
+	struct xfs_trans_res	*resv,
+	struct xfs_inode	*ip,
+	unsigned int		*dblocks,
+	struct xfs_trans	**tpp,
+	int			*nospace_error)
+{
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		resblks;
+	bool			retried = false;
+	int			error;
+
+retry:
+	*nospace_error = 0;
+	resblks = *dblocks;
+	error = xfs_trans_alloc(mp, resv, resblks, 0, 0, &tp);
+	if (error == -ENOSPC) {
+		*nospace_error = error;
+		resblks = 0;
+		error = xfs_trans_alloc(mp, resv, resblks, 0, 0, &tp);
+	}
+	if (error)
+		return error;
+
+	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
+
+	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	error = xfs_qm_dqattach_locked(dp, false);
+	if (error) {
+		/* Caller should have allocated the dquots! */
+		ASSERT(error != -ENOENT);
+		goto out_cancel;
+	}
+
+	error = xfs_qm_dqattach_locked(ip, false);
+	if (error) {
+		/* Caller should have allocated the dquots! */
+		ASSERT(error != -ENOENT);
+		goto out_cancel;
+	}
+
+	if (resblks == 0)
+		goto done;
+
+	error = xfs_trans_reserve_quota_nblks(tp, dp, resblks, 0, false);
+	if (error == -EDQUOT || error == -ENOSPC) {
+		if (!retried) {
+			xfs_trans_cancel(tp);
+			xfs_blockgc_free_quota(dp, 0);
+			retried = true;
+			goto retry;
+		}
+
+		*nospace_error = error;
+		resblks = 0;
+		error = 0;
+	}
+	if (error)
+		goto out_cancel;
+
+done:
+	*tpp = tp;
+	*dblocks = resblks;
+	return 0;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+	return error;
+}
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -265,6 +265,9 @@ int xfs_trans_alloc_icreate(struct xfs_m
 int xfs_trans_alloc_ichange(struct xfs_inode *ip, struct xfs_dquot *udqp,
 		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp, bool force,
 		struct xfs_trans **tpp);
+int xfs_trans_alloc_dir(struct xfs_inode *dp, struct xfs_trans_res *resv,
+		struct xfs_inode *ip, unsigned int *dblocks,
+		struct xfs_trans **tpp, int *nospace_error);
 
 static inline void
 xfs_trans_set_context(


