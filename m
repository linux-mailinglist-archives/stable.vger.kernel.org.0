Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30996E624E
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjDRMbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbjDRMbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:31:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C889764
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:31:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5943C631D0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DADDC433D2;
        Tue, 18 Apr 2023 12:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821066;
        bh=CfZnNNx6Lk7/15qVX7m9KnNigpQx5AdRzxYZEvcRqWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VF73Fkgc1Awc4EUutPHnZMA0ar0S1zRhS1wB+e97lL16nANU7r/zukRZrVvoQoy0v
         Pbm8zrrjnvGHvHsseYA6ZXYq3KlA9y9NloO70xWavSPC1hB1+mYdmHvYxMzD/cGLh/
         aFTme3Xzrd4lgpyD+61f1ojUXKkG6Dv6jqlcGijs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 79/92] xfs: remove the icdinode di_uid/di_gid members
Date:   Tue, 18 Apr 2023 14:21:54 +0200
Message-Id: <20230418120307.541245086@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 542951592c99ff7b15c050954c051dd6dd6c0f97 upstream.

Use the Linux inode i_uid/i_gid members everywhere and just convert
from/to the scalar value when reading or writing the on-disk inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   10 ++++------
 fs/xfs/libxfs/xfs_inode_buf.h |    2 --
 fs/xfs/xfs_dquot.c            |    4 ++--
 fs/xfs/xfs_inode.c            |   14 ++++----------
 fs/xfs/xfs_inode_item.c       |    4 ++--
 fs/xfs/xfs_ioctl.c            |    6 +++---
 fs/xfs/xfs_iops.c             |    6 +-----
 fs/xfs/xfs_itable.c           |    4 ++--
 fs/xfs/xfs_qm.c               |   40 +++++++++++++++++++++++++---------------
 fs/xfs/xfs_quota.h            |    4 ++--
 fs/xfs/xfs_symlink.c          |    4 +---
 11 files changed, 46 insertions(+), 52 deletions(-)

--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -222,10 +222,8 @@ xfs_inode_from_disk(
 	}
 
 	to->di_format = from->di_format;
-	to->di_uid = be32_to_cpu(from->di_uid);
-	inode->i_uid = xfs_uid_to_kuid(to->di_uid);
-	to->di_gid = be32_to_cpu(from->di_gid);
-	inode->i_gid = xfs_gid_to_kgid(to->di_gid);
+	inode->i_uid = xfs_uid_to_kuid(be32_to_cpu(from->di_uid));
+	inode->i_gid = xfs_gid_to_kgid(be32_to_cpu(from->di_gid));
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
@@ -278,8 +276,8 @@ xfs_inode_to_disk(
 
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_uid = cpu_to_be32(from->di_uid);
-	to->di_gid = cpu_to_be32(from->di_gid);
+	to->di_uid = cpu_to_be32(xfs_kuid_to_uid(inode->i_uid));
+	to->di_gid = cpu_to_be32(xfs_kgid_to_gid(inode->i_gid));
 	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
 	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
 
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -19,8 +19,6 @@ struct xfs_icdinode {
 	int8_t		di_version;	/* inode version */
 	int8_t		di_format;	/* format of di_c data */
 	uint16_t	di_flushiter;	/* incremented on flush */
-	uint32_t	di_uid;		/* owner's user id */
-	uint32_t	di_gid;		/* owner's group id */
 	uint32_t	di_projid;	/* owner's project id */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -859,9 +859,9 @@ xfs_qm_id_for_quotatype(
 {
 	switch (type) {
 	case XFS_DQ_USER:
-		return ip->i_d.di_uid;
+		return xfs_kuid_to_uid(VFS_I(ip)->i_uid);
 	case XFS_DQ_GROUP:
-		return ip->i_d.di_gid;
+		return xfs_kgid_to_gid(VFS_I(ip)->i_gid);
 	case XFS_DQ_PROJ:
 		return ip->i_d.di_projid;
 	}
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -807,18 +807,15 @@ xfs_ialloc(
 	inode->i_mode = mode;
 	set_nlink(inode, nlink);
 	inode->i_uid = current_fsuid();
-	ip->i_d.di_uid = xfs_kuid_to_uid(inode->i_uid);
 	inode->i_rdev = rdev;
 	ip->i_d.di_projid = prid;
 
 	if (pip && XFS_INHERIT_GID(pip)) {
 		inode->i_gid = VFS_I(pip)->i_gid;
-		ip->i_d.di_gid = pip->i_d.di_gid;
 		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
 			inode->i_mode |= S_ISGID;
 	} else {
 		inode->i_gid = current_fsgid();
-		ip->i_d.di_gid = xfs_kgid_to_gid(inode->i_gid);
 	}
 
 	/*
@@ -826,9 +823,8 @@ xfs_ialloc(
 	 * ID or one of the supplementary group IDs, the S_ISGID bit is cleared
 	 * (and only if the irix_sgid_inherit compatibility variable is set).
 	 */
-	if ((irix_sgid_inherit) &&
-	    (inode->i_mode & S_ISGID) &&
-	    (!in_group_p(xfs_gid_to_kgid(ip->i_d.di_gid))))
+	if (irix_sgid_inherit &&
+	    (inode->i_mode & S_ISGID) && !in_group_p(inode->i_gid))
 		inode->i_mode &= ~S_ISGID;
 
 	ip->i_d.di_size = 0;
@@ -1157,8 +1153,7 @@ xfs_create(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, xfs_kuid_to_uid(current_fsuid()),
-					xfs_kgid_to_gid(current_fsgid()), prid,
+	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
 					XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 					&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1308,8 +1303,7 @@ xfs_create_tmpfile(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, xfs_kuid_to_uid(current_fsuid()),
-				xfs_kgid_to_gid(current_fsgid()), prid,
+	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
 				XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 				&udqp, &gdqp, &pdqp);
 	if (error)
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -308,8 +308,8 @@ xfs_inode_to_log_dinode(
 
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_uid = from->di_uid;
-	to->di_gid = from->di_gid;
+	to->di_uid = xfs_kuid_to_uid(inode->i_uid);
+	to->di_gid = xfs_kgid_to_gid(inode->i_gid);
 	to->di_projid_lo = from->di_projid & 0xffff;
 	to->di_projid_hi = from->di_projid >> 16;
 
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1572,9 +1572,9 @@ xfs_ioctl_setattr(
 	 * because the i_*dquot fields will get updated anyway.
 	 */
 	if (XFS_IS_QUOTA_ON(mp)) {
-		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
-					 ip->i_d.di_gid, fa->fsx_projid,
-					 XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
+		code = xfs_qm_vop_dqalloc(ip, VFS_I(ip)->i_uid,
+				VFS_I(ip)->i_gid, fa->fsx_projid,
+				XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
 		if (code)
 			return code;
 	}
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -666,9 +666,7 @@ xfs_setattr_nonsize(
 		 */
 		ASSERT(udqp == NULL);
 		ASSERT(gdqp == NULL);
-		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(uid),
-					   xfs_kgid_to_gid(gid),
-					   ip->i_d.di_projid,
+		error = xfs_qm_vop_dqalloc(ip, uid, gid, ip->i_d.di_projid,
 					   qflags, &udqp, &gdqp, NULL);
 		if (error)
 			return error;
@@ -737,7 +735,6 @@ xfs_setattr_nonsize(
 				olddquot1 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_udquot, udqp);
 			}
-			ip->i_d.di_uid = xfs_kuid_to_uid(uid);
 			inode->i_uid = uid;
 		}
 		if (!gid_eq(igid, gid)) {
@@ -749,7 +746,6 @@ xfs_setattr_nonsize(
 				olddquot2 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
 			}
-			ip->i_d.di_gid = xfs_kgid_to_gid(gid);
 			inode->i_gid = gid;
 		}
 	}
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -86,8 +86,8 @@ xfs_bulkstat_one_int(
 	 */
 	buf->bs_projectid = ip->i_d.di_projid;
 	buf->bs_ino = ino;
-	buf->bs_uid = dic->di_uid;
-	buf->bs_gid = dic->di_gid;
+	buf->bs_uid = xfs_kuid_to_uid(inode->i_uid);
+	buf->bs_gid = xfs_kgid_to_gid(inode->i_gid);
 	buf->bs_size = dic->di_size;
 
 	buf->bs_nlink = inode->i_nlink;
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -331,16 +331,18 @@ xfs_qm_dqattach_locked(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
-		error = xfs_qm_dqattach_one(ip, ip->i_d.di_uid, XFS_DQ_USER,
-				doalloc, &ip->i_udquot);
+		error = xfs_qm_dqattach_one(ip,
+				xfs_kuid_to_uid(VFS_I(ip)->i_uid),
+				XFS_DQ_USER, doalloc, &ip->i_udquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_udquot);
 	}
 
 	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
-		error = xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
-				doalloc, &ip->i_gdquot);
+		error = xfs_qm_dqattach_one(ip,
+				xfs_kgid_to_gid(VFS_I(ip)->i_gid),
+				XFS_DQ_GROUP, doalloc, &ip->i_gdquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_gdquot);
@@ -1630,8 +1632,8 @@ xfs_qm_dqfree_one(
 int
 xfs_qm_vop_dqalloc(
 	struct xfs_inode	*ip,
-	xfs_dqid_t		uid,
-	xfs_dqid_t		gid,
+	kuid_t			uid,
+	kgid_t			gid,
 	prid_t			prid,
 	uint			flags,
 	struct xfs_dquot	**O_udqpp,
@@ -1639,6 +1641,7 @@ xfs_qm_vop_dqalloc(
 	struct xfs_dquot	**O_pdqpp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	struct inode		*inode = VFS_I(ip);
 	struct xfs_dquot	*uq = NULL;
 	struct xfs_dquot	*gq = NULL;
 	struct xfs_dquot	*pq = NULL;
@@ -1652,7 +1655,7 @@ xfs_qm_vop_dqalloc(
 	xfs_ilock(ip, lockflags);
 
 	if ((flags & XFS_QMOPT_INHERIT) && XFS_INHERIT_GID(ip))
-		gid = ip->i_d.di_gid;
+		gid = inode->i_gid;
 
 	/*
 	 * Attach the dquot(s) to this inode, doing a dquot allocation
@@ -1667,7 +1670,7 @@ xfs_qm_vop_dqalloc(
 	}
 
 	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
-		if (ip->i_d.di_uid != uid) {
+		if (!uid_eq(inode->i_uid, uid)) {
 			/*
 			 * What we need is the dquot that has this uid, and
 			 * if we send the inode to dqget, the uid of the inode
@@ -1678,7 +1681,8 @@ xfs_qm_vop_dqalloc(
 			 * holding ilock.
 			 */
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, uid, XFS_DQ_USER, true, &uq);
+			error = xfs_qm_dqget(mp, xfs_kuid_to_uid(uid),
+					XFS_DQ_USER, true, &uq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				return error;
@@ -1699,9 +1703,10 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
-		if (ip->i_d.di_gid != gid) {
+		if (!gid_eq(inode->i_gid, gid)) {
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, gid, XFS_DQ_GROUP, true, &gq);
+			error = xfs_qm_dqget(mp, xfs_kgid_to_gid(gid),
+					XFS_DQ_GROUP, true, &gq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				goto error_rele;
@@ -1827,7 +1832,8 @@ xfs_qm_vop_chown_reserve(
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    ip->i_d.di_uid != be32_to_cpu(udqp->q_core.d_id)) {
+	    xfs_kuid_to_uid(VFS_I(ip)->i_uid) !=
+			be32_to_cpu(udqp->q_core.d_id)) {
 		udq_delblks = udqp;
 		/*
 		 * If there are delayed allocation blocks, then we have to
@@ -1840,7 +1846,8 @@ xfs_qm_vop_chown_reserve(
 		}
 	}
 	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
-	    ip->i_d.di_gid != be32_to_cpu(gdqp->q_core.d_id)) {
+	    xfs_kgid_to_gid(VFS_I(ip)->i_gid) !=
+			be32_to_cpu(gdqp->q_core.d_id)) {
 		gdq_delblks = gdqp;
 		if (delblks) {
 			ASSERT(ip->i_gdquot);
@@ -1937,14 +1944,17 @@ xfs_qm_vop_create_dqattach(
 
 	if (udqp && XFS_IS_UQUOTA_ON(mp)) {
 		ASSERT(ip->i_udquot == NULL);
-		ASSERT(ip->i_d.di_uid == be32_to_cpu(udqp->q_core.d_id));
+		ASSERT(xfs_kuid_to_uid(VFS_I(ip)->i_uid) ==
+			be32_to_cpu(udqp->q_core.d_id));
 
 		ip->i_udquot = xfs_qm_dqhold(udqp);
 		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
 	if (gdqp && XFS_IS_GQUOTA_ON(mp)) {
 		ASSERT(ip->i_gdquot == NULL);
-		ASSERT(ip->i_d.di_gid == be32_to_cpu(gdqp->q_core.d_id));
+		ASSERT(xfs_kgid_to_gid(VFS_I(ip)->i_gid) ==
+			be32_to_cpu(gdqp->q_core.d_id));
+
 		ip->i_gdquot = xfs_qm_dqhold(gdqp);
 		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -86,7 +86,7 @@ extern int xfs_trans_reserve_quota_bydqu
 		struct xfs_mount *, struct xfs_dquot *,
 		struct xfs_dquot *, struct xfs_dquot *, int64_t, long, uint);
 
-extern int xfs_qm_vop_dqalloc(struct xfs_inode *, xfs_dqid_t, xfs_dqid_t,
+extern int xfs_qm_vop_dqalloc(struct xfs_inode *, kuid_t, kgid_t,
 		prid_t, uint, struct xfs_dquot **, struct xfs_dquot **,
 		struct xfs_dquot **);
 extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
@@ -109,7 +109,7 @@ extern void xfs_qm_unmount_quotas(struct
 
 #else
 static inline int
-xfs_qm_vop_dqalloc(struct xfs_inode *ip, xfs_dqid_t uid, xfs_dqid_t gid,
+xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
 		prid_t prid, uint flags, struct xfs_dquot **udqp,
 		struct xfs_dquot **gdqp, struct xfs_dquot **pdqp)
 {
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -191,9 +191,7 @@ xfs_symlink(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp,
-			xfs_kuid_to_uid(current_fsuid()),
-			xfs_kgid_to_gid(current_fsgid()), prid,
+	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)


