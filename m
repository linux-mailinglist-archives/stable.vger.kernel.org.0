Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABBF9DFF1
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbfH0H6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:58:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729839AbfH0H6x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:58:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC4822186A;
        Tue, 27 Aug 2019 07:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892732;
        bh=GqSYQTpOQZW/k2Gtj63pp/L1eMIfnLgrC3rlUt4h8CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=it03nY2lLWsXh89a25D/iSh7NDe1Hfi6vlPAoO5YQ5sWqpjRzlG35XuHgQ2tImyRv
         JIfEeujpoHqoy/ae32K6wU2Pzi6yJyam5TQCuTe2iqMMCm3J5MhyTeu5+yL1Jmq8ll
         ATGXD1V/qQBF+ub4w/5JulpjDuSF1NWEKI3z6yaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 92/98] xfs: Add attibute set and helper functions
Date:   Tue, 27 Aug 2019 09:51:11 +0200
Message-Id: <20190827072723.195701407@linuxfoundation.org>
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

commit 2f3cd8091963810d85e6a5dd6ed1247e10e9e6f2 upstream.

This patch adds xfs_attr_set_args and xfs_bmap_set_attrforkoff.
These sub-routines set the attributes specified in @args.
We will use this later for setting parent pointers as a deferred
attribute operation.

[dgc: remove attr fork init code from xfs_attr_set_args().]
[dgc: xfs_attr_try_sf_addname() NULLs args.trans after commit.]
[dgc: correct sf add error handling.]

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 151 +++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_attr.h |   1 +
 fs/xfs/libxfs/xfs_bmap.c |  49 ++++++++-----
 fs/xfs/libxfs/xfs_bmap.h |   1 +
 4 files changed, 115 insertions(+), 87 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index c15a1debec907..25431ddba1fab 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -215,9 +215,80 @@ xfs_attr_try_sf_addname(
 		xfs_trans_set_sync(args->trans);
 
 	error2 = xfs_trans_commit(args->trans);
+	args->trans = NULL;
 	return error ? error : error2;
 }
 
+/*
+ * Set the attribute specified in @args.
+ */
+int
+xfs_attr_set_args(
+	struct xfs_da_args	*args,
+	struct xfs_buf          **leaf_bp)
+{
+	struct xfs_inode	*dp = args->dp;
+	int			error;
+
+	/*
+	 * If the attribute list is non-existent or a shortform list,
+	 * upgrade it to a single-leaf-block attribute list.
+	 */
+	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
+	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
+	     dp->i_d.di_anextents == 0)) {
+
+		/*
+		 * Build initial attribute list (if required).
+		 */
+		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
+			xfs_attr_shortform_create(args);
+
+		/*
+		 * Try to add the attr to the attribute list in the inode.
+		 */
+		error = xfs_attr_try_sf_addname(dp, args);
+		if (error != -ENOSPC)
+			return error;
+
+		/*
+		 * It won't fit in the shortform, transform to a leaf block.
+		 * GROT: another possible req'mt for a double-split btree op.
+		 */
+		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+		if (error)
+			return error;
+
+		/*
+		 * Prevent the leaf buffer from being unlocked so that a
+		 * concurrent AIL push cannot grab the half-baked leaf
+		 * buffer and run into problems with the write verifier.
+		 */
+		xfs_trans_bhold(args->trans, *leaf_bp);
+
+		error = xfs_defer_finish(&args->trans);
+		if (error)
+			return error;
+
+		/*
+		 * Commit the leaf transformation.  We'll need another
+		 * (linked) transaction to add the new attribute to the
+		 * leaf.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, dp);
+		if (error)
+			return error;
+		xfs_trans_bjoin(args->trans, *leaf_bp);
+		*leaf_bp = NULL;
+	}
+
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+		error = xfs_attr_leaf_addname(args);
+	else
+		error = xfs_attr_node_addname(args);
+	return error;
+}
+
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
@@ -282,73 +353,17 @@ xfs_attr_set(
 	error = xfs_trans_reserve_quota_nblks(args.trans, dp, args.total, 0,
 				rsvd ? XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
 				       XFS_QMOPT_RES_REGBLKS);
-	if (error) {
-		xfs_iunlock(dp, XFS_ILOCK_EXCL);
-		xfs_trans_cancel(args.trans);
-		return error;
-	}
+	if (error)
+		goto out_trans_cancel;
 
 	xfs_trans_ijoin(args.trans, dp, 0);
-
-	/*
-	 * If the attribute list is non-existent or a shortform list,
-	 * upgrade it to a single-leaf-block attribute list.
-	 */
-	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
-	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
-	     dp->i_d.di_anextents == 0)) {
-
-		/*
-		 * Build initial attribute list (if required).
-		 */
-		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
-			xfs_attr_shortform_create(&args);
-
-		/*
-		 * Try to add the attr to the attribute list in
-		 * the inode.
-		 */
-		error = xfs_attr_try_sf_addname(dp, &args);
-		if (error != -ENOSPC) {
-			xfs_iunlock(dp, XFS_ILOCK_EXCL);
-			return error;
-		}
-
-		/*
-		 * It won't fit in the shortform, transform to a leaf block.
-		 * GROT: another possible req'mt for a double-split btree op.
-		 */
-		error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
-		if (error)
-			goto out;
-		/*
-		 * Prevent the leaf buffer from being unlocked so that a
-		 * concurrent AIL push cannot grab the half-baked leaf
-		 * buffer and run into problems with the write verifier.
-		 */
-		xfs_trans_bhold(args.trans, leaf_bp);
-		error = xfs_defer_finish(&args.trans);
-		if (error)
-			goto out;
-
-		/*
-		 * Commit the leaf transformation.  We'll need another (linked)
-		 * transaction to add the new attribute to the leaf, which
-		 * means that we have to hold & join the leaf buffer here too.
-		 */
-		error = xfs_trans_roll_inode(&args.trans, dp);
-		if (error)
-			goto out;
-		xfs_trans_bjoin(args.trans, leaf_bp);
-		leaf_bp = NULL;
-	}
-
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
-		error = xfs_attr_leaf_addname(&args);
-	else
-		error = xfs_attr_node_addname(&args);
+	error = xfs_attr_set_args(&args, &leaf_bp);
 	if (error)
-		goto out;
+		goto out_release_leaf;
+	if (!args.trans) {
+		/* shortform attribute has already been committed */
+		goto out_unlock;
+	}
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -365,17 +380,17 @@ xfs_attr_set(
 	 */
 	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
 	error = xfs_trans_commit(args.trans);
+out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-
 	return error;
 
-out:
+out_release_leaf:
 	if (leaf_bp)
 		xfs_trans_brelse(args.trans, leaf_bp);
+out_trans_cancel:
 	if (args.trans)
 		xfs_trans_cancel(args.trans);
-	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	return error;
+	goto out_unlock;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 033ff8c478e2e..f608ac8f306f9 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -140,6 +140,7 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 		 unsigned char *value, int *valuelenp, int flags);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 unsigned char *value, int valuelen, int flags);
+int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ab2465bc413af..06a7da8dbda5c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1019,6 +1019,34 @@ xfs_bmap_add_attrfork_local(
 	return -EFSCORRUPTED;
 }
 
+/* Set an inode attr fork off based on the format */
+int
+xfs_bmap_set_attrforkoff(
+	struct xfs_inode	*ip,
+	int			size,
+	int			*version)
+{
+	switch (ip->i_d.di_format) {
+	case XFS_DINODE_FMT_DEV:
+		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
+		break;
+	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_EXTENTS:
+	case XFS_DINODE_FMT_BTREE:
+		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
+		if (!ip->i_d.di_forkoff)
+			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
+		else if ((ip->i_mount->m_flags & XFS_MOUNT_ATTR2) && version)
+			*version = 2;
+		break;
+	default:
+		ASSERT(0);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /*
  * Convert inode from non-attributed to attributed.
  * Must not be in a transaction, ip must not be locked.
@@ -1070,26 +1098,9 @@ xfs_bmap_add_attrfork(
 
 	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-	switch (ip->i_d.di_format) {
-	case XFS_DINODE_FMT_DEV:
-		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
-		break;
-	case XFS_DINODE_FMT_LOCAL:
-	case XFS_DINODE_FMT_EXTENTS:
-	case XFS_DINODE_FMT_BTREE:
-		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
-		if (!ip->i_d.di_forkoff)
-			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
-		else if (mp->m_flags & XFS_MOUNT_ATTR2)
-			version = 2;
-		break;
-	default:
-		ASSERT(0);
-		error = -EINVAL;
+	error = xfs_bmap_set_attrforkoff(ip, size, &version);
+	if (error)
 		goto trans_cancel;
-	}
-
 	ASSERT(ip->i_afp == NULL);
 	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
 	ip->i_afp->if_flags = XFS_IFEXTENTS;
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index b6e9b639e731a..488dc8860fd7c 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -183,6 +183,7 @@ void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
 void	xfs_trim_extent_eof(struct xfs_bmbt_irec *, struct xfs_inode *);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
+int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
 void	__xfs_bmap_add_free(struct xfs_trans *tp, xfs_fsblock_t bno,
 		xfs_filblks_t len, struct xfs_owner_info *oinfo,
-- 
2.20.1



