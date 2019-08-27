Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2D39E183
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730773AbfH0H7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729951AbfH0H7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:59:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89CE7217F5;
        Tue, 27 Aug 2019 07:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892739;
        bh=5v+LE2CFUhor7motpMyaw12UaTOlwc6cVyNRiwey90c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VgVjN4m3hiVJ3/x2snRMVc00Udc8nSrd3xZ4vbmN1TDzvTwB1gi/TvOe2DSRbzzzv
         US9t1yBqw3zkS2JAH5ocWP9N1WtMOGD2GTJfW6Ta3PlUwqSrezsThsIicM9Wwz8+4E
         AwfDkp7cPsQ8UHc4bUgOou0rTlOk74Zo/OraSbmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 94/98] xfs: always rejoin held resources during defer roll
Date:   Tue, 27 Aug 2019 09:51:13 +0200
Message-Id: <20190827072723.294158483@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 710d707d2fa9cf4c2aa9def129e71e99513466ea upstream.

During testing of xfs/141 on a V4 filesystem, I observed some
inconsistent behavior with regards to resources that are held (i.e.
remain locked) across a defer roll.  The transaction roll always gives
the defer roll function a new transaction, even if committing the old
transaction fails.  However, the defer roll function only rejoins the
held resources if the transaction commit succeedied.  This means that
callers of defer roll have to figure out whether the held resources are
attached to the transaction being passed back.

Worse yet, if the defer roll was part of a defer finish call, we have a
third possibility: the defer finish could pass back a dirty transaction
with dirty held resources and an error code.

The only sane way to handle all of these scenarios is to require that
the code that held the resource either cancel the transaction before
unlocking and releasing the resources, or use functions that detach
resources from a transaction properly (e.g.  xfs_trans_brelse) if they
need to drop the reference before committing or cancelling the
transaction.

In order to make this so, change the defer roll code to join held
resources to the new transaction unconditionally and fix all the bhold
callers to release the held buffers correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
[mcgrof: fixes kz#204223 ]
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c  | 35 ++++++++++++-----------------------
 fs/xfs/libxfs/xfs_attr.h  |  2 +-
 fs/xfs/libxfs/xfs_defer.c | 14 +++++++++-----
 fs/xfs/xfs_dquot.c        | 17 +++++++++--------
 4 files changed, 31 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 844ed87b19007..6410d3e00ce07 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -224,10 +224,10 @@ xfs_attr_try_sf_addname(
  */
 int
 xfs_attr_set_args(
-	struct xfs_da_args	*args,
-	struct xfs_buf          **leaf_bp)
+	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_buf          *leaf_bp = NULL;
 	int			error;
 
 	/*
@@ -255,7 +255,7 @@ xfs_attr_set_args(
 		 * It won't fit in the shortform, transform to a leaf block.
 		 * GROT: another possible req'mt for a double-split btree op.
 		 */
-		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
 		if (error)
 			return error;
 
@@ -263,23 +263,16 @@ xfs_attr_set_args(
 		 * Prevent the leaf buffer from being unlocked so that a
 		 * concurrent AIL push cannot grab the half-baked leaf
 		 * buffer and run into problems with the write verifier.
+		 * Once we're done rolling the transaction we can release
+		 * the hold and add the attr to the leaf.
 		 */
-		xfs_trans_bhold(args->trans, *leaf_bp);
-
+		xfs_trans_bhold(args->trans, leaf_bp);
 		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-
-		/*
-		 * Commit the leaf transformation.  We'll need another
-		 * (linked) transaction to add the new attribute to the
-		 * leaf.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
+		xfs_trans_bhold_release(args->trans, leaf_bp);
+		if (error) {
+			xfs_trans_brelse(args->trans, leaf_bp);
 			return error;
-		xfs_trans_bjoin(args->trans, *leaf_bp);
-		*leaf_bp = NULL;
+		}
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
@@ -322,7 +315,6 @@ xfs_attr_set(
 	int			flags)
 {
 	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_buf		*leaf_bp = NULL;
 	struct xfs_da_args	args;
 	struct xfs_trans_res	tres;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
@@ -381,9 +373,9 @@ xfs_attr_set(
 		goto out_trans_cancel;
 
 	xfs_trans_ijoin(args.trans, dp, 0);
-	error = xfs_attr_set_args(&args, &leaf_bp);
+	error = xfs_attr_set_args(&args);
 	if (error)
-		goto out_release_leaf;
+		goto out_trans_cancel;
 	if (!args.trans) {
 		/* shortform attribute has already been committed */
 		goto out_unlock;
@@ -408,9 +400,6 @@ xfs_attr_set(
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return error;
 
-out_release_leaf:
-	if (leaf_bp)
-		xfs_trans_brelse(args.trans, leaf_bp);
 out_trans_cancel:
 	if (args.trans)
 		xfs_trans_cancel(args.trans);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index bdf52a333f3f9..cc04ee0aacfbe 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -140,7 +140,7 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 		 unsigned char *value, int *valuelenp, int flags);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 unsigned char *value, int valuelen, int flags);
-int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp);
+int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index e792b167150a0..c52beee31836a 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -266,13 +266,15 @@ xfs_defer_trans_roll(
 
 	trace_xfs_defer_trans_roll(tp, _RET_IP_);
 
-	/* Roll the transaction. */
+	/*
+	 * Roll the transaction.  Rolling always given a new transaction (even
+	 * if committing the old one fails!) to hand back to the caller, so we
+	 * join the held resources to the new transaction so that we always
+	 * return with the held resources joined to @tpp, no matter what
+	 * happened.
+	 */
 	error = xfs_trans_roll(tpp);
 	tp = *tpp;
-	if (error) {
-		trace_xfs_defer_trans_roll_error(tp, error);
-		return error;
-	}
 
 	/* Rejoin the joined inodes. */
 	for (i = 0; i < ipcount; i++)
@@ -284,6 +286,8 @@ xfs_defer_trans_roll(
 		xfs_trans_bhold(tp, bplist[i]);
 	}
 
+	if (error)
+		trace_xfs_defer_trans_roll_error(tp, error);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 87e6dd5326d5d..a1af984e4913e 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -277,7 +277,8 @@ xfs_dquot_set_prealloc_limits(struct xfs_dquot *dqp)
 
 /*
  * Ensure that the given in-core dquot has a buffer on disk backing it, and
- * return the buffer. This is called when the bmapi finds a hole.
+ * return the buffer locked and held. This is called when the bmapi finds a
+ * hole.
  */
 STATIC int
 xfs_dquot_disk_alloc(
@@ -355,13 +356,14 @@ xfs_dquot_disk_alloc(
 	 * If everything succeeds, the caller of this function is returned a
 	 * buffer that is locked and held to the transaction.  The caller
 	 * is responsible for unlocking any buffer passed back, either
-	 * manually or by committing the transaction.
+	 * manually or by committing the transaction.  On error, the buffer is
+	 * released and not passed back.
 	 */
 	xfs_trans_bhold(tp, bp);
 	error = xfs_defer_finish(tpp);
-	tp = *tpp;
 	if (error) {
-		xfs_buf_relse(bp);
+		xfs_trans_bhold_release(*tpp, bp);
+		xfs_trans_brelse(*tpp, bp);
 		return error;
 	}
 	*bpp = bp;
@@ -521,7 +523,6 @@ xfs_qm_dqread_alloc(
 	struct xfs_buf		**bpp)
 {
 	struct xfs_trans	*tp;
-	struct xfs_buf		*bp;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
@@ -529,7 +530,7 @@ xfs_qm_dqread_alloc(
 	if (error)
 		goto err;
 
-	error = xfs_dquot_disk_alloc(&tp, dqp, &bp);
+	error = xfs_dquot_disk_alloc(&tp, dqp, bpp);
 	if (error)
 		goto err_cancel;
 
@@ -539,10 +540,10 @@ xfs_qm_dqread_alloc(
 		 * Buffer was held to the transaction, so we have to unlock it
 		 * manually here because we're not passing it back.
 		 */
-		xfs_buf_relse(bp);
+		xfs_buf_relse(*bpp);
+		*bpp = NULL;
 		goto err;
 	}
-	*bpp = bp;
 	return 0;
 
 err_cancel:
-- 
2.20.1



