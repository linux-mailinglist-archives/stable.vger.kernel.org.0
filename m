Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC6D6E624C
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjDRMbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbjDRMbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:31:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECC28684
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:31:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9A10631D5
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B346C433D2;
        Tue, 18 Apr 2023 12:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821069;
        bh=l2Rs6pZczwhRPcUMmW2xeDiVj1AeNt9qHT8oQAmVaN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0pXbr4Xww6MpsZKA7pycRgg+6XJqbFXSi9QNsCgLNCehprqiiU1KRLNhXDqSron0j
         4OZTa8mPwNKjxik4gBDj1VdoraC5mfjppvde+ZgiQ4hy4bxn84AhM8W0bcSj0DIdRX
         5tpfnotVxn1nDeSN4QQS+73Pgb0rrMv3D+7GDgo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 80/92] xfs: remove the kuid/kgid conversion wrappers
Date:   Tue, 18 Apr 2023 14:21:55 +0200
Message-Id: <20230418120307.578587196@linuxfoundation.org>
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

commit ba8adad5d036733d240fa8a8f4d055f3d4490562 upstream.

Remove the XFS wrappers for converting from and to the kuid/kgid types.
Mostly this means switching to VFS i_{u,g}id_{read,write} helpers, but
in a few spots the calls to the conversion functions is open coded.
To match the use of sb->s_user_ns in the helpers and other file systems,
sb->s_user_ns is also used in the quota code.  The ACL code already does
the conversion in a grotty layering violation in the VFS xattr code,
so it keeps using init_user_ns for the identity mapping.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    8 ++++----
 fs/xfs/xfs_acl.c              |   12 ++++++++----
 fs/xfs/xfs_dquot.c            |    4 ++--
 fs/xfs/xfs_inode_item.c       |    4 ++--
 fs/xfs/xfs_itable.c           |    4 ++--
 fs/xfs/xfs_linux.h            |   26 --------------------------
 fs/xfs/xfs_qm.c               |   23 +++++++++--------------
 7 files changed, 27 insertions(+), 54 deletions(-)

--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -222,8 +222,8 @@ xfs_inode_from_disk(
 	}
 
 	to->di_format = from->di_format;
-	inode->i_uid = xfs_uid_to_kuid(be32_to_cpu(from->di_uid));
-	inode->i_gid = xfs_gid_to_kgid(be32_to_cpu(from->di_gid));
+	i_uid_write(inode, be32_to_cpu(from->di_uid));
+	i_gid_write(inode, be32_to_cpu(from->di_gid));
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
@@ -276,8 +276,8 @@ xfs_inode_to_disk(
 
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_uid = cpu_to_be32(xfs_kuid_to_uid(inode->i_uid));
-	to->di_gid = cpu_to_be32(xfs_kgid_to_gid(inode->i_gid));
+	to->di_uid = cpu_to_be32(i_uid_read(inode));
+	to->di_gid = cpu_to_be32(i_gid_read(inode));
 	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
 	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
 
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -66,10 +66,12 @@ xfs_acl_from_disk(
 
 		switch (acl_e->e_tag) {
 		case ACL_USER:
-			acl_e->e_uid = xfs_uid_to_kuid(be32_to_cpu(ace->ae_id));
+			acl_e->e_uid = make_kuid(&init_user_ns,
+						 be32_to_cpu(ace->ae_id));
 			break;
 		case ACL_GROUP:
-			acl_e->e_gid = xfs_gid_to_kgid(be32_to_cpu(ace->ae_id));
+			acl_e->e_gid = make_kgid(&init_user_ns,
+						 be32_to_cpu(ace->ae_id));
 			break;
 		case ACL_USER_OBJ:
 		case ACL_GROUP_OBJ:
@@ -102,10 +104,12 @@ xfs_acl_to_disk(struct xfs_acl *aclp, co
 		ace->ae_tag = cpu_to_be32(acl_e->e_tag);
 		switch (acl_e->e_tag) {
 		case ACL_USER:
-			ace->ae_id = cpu_to_be32(xfs_kuid_to_uid(acl_e->e_uid));
+			ace->ae_id = cpu_to_be32(
+					from_kuid(&init_user_ns, acl_e->e_uid));
 			break;
 		case ACL_GROUP:
-			ace->ae_id = cpu_to_be32(xfs_kgid_to_gid(acl_e->e_gid));
+			ace->ae_id = cpu_to_be32(
+					from_kgid(&init_user_ns, acl_e->e_gid));
 			break;
 		default:
 			ace->ae_id = cpu_to_be32(ACL_UNDEFINED_ID);
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -859,9 +859,9 @@ xfs_qm_id_for_quotatype(
 {
 	switch (type) {
 	case XFS_DQ_USER:
-		return xfs_kuid_to_uid(VFS_I(ip)->i_uid);
+		return i_uid_read(VFS_I(ip));
 	case XFS_DQ_GROUP:
-		return xfs_kgid_to_gid(VFS_I(ip)->i_gid);
+		return i_gid_read(VFS_I(ip));
 	case XFS_DQ_PROJ:
 		return ip->i_d.di_projid;
 	}
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -308,8 +308,8 @@ xfs_inode_to_log_dinode(
 
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_uid = xfs_kuid_to_uid(inode->i_uid);
-	to->di_gid = xfs_kgid_to_gid(inode->i_gid);
+	to->di_uid = i_uid_read(inode);
+	to->di_gid = i_gid_read(inode);
 	to->di_projid_lo = from->di_projid & 0xffff;
 	to->di_projid_hi = from->di_projid >> 16;
 
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -86,8 +86,8 @@ xfs_bulkstat_one_int(
 	 */
 	buf->bs_projectid = ip->i_d.di_projid;
 	buf->bs_ino = ino;
-	buf->bs_uid = xfs_kuid_to_uid(inode->i_uid);
-	buf->bs_gid = xfs_kgid_to_gid(inode->i_gid);
+	buf->bs_uid = i_uid_read(inode);
+	buf->bs_gid = i_gid_read(inode);
 	buf->bs_size = dic->di_size;
 
 	buf->bs_nlink = inode->i_nlink;
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -163,32 +163,6 @@ struct xstats {
 
 extern struct xstats xfsstats;
 
-/* Kernel uid/gid conversion. These are used to convert to/from the on disk
- * uid_t/gid_t types to the kuid_t/kgid_t types that the kernel uses internally.
- * The conversion here is type only, the value will remain the same since we
- * are converting to the init_user_ns. The uid is later mapped to a particular
- * user namespace value when crossing the kernel/user boundary.
- */
-static inline uint32_t xfs_kuid_to_uid(kuid_t uid)
-{
-	return from_kuid(&init_user_ns, uid);
-}
-
-static inline kuid_t xfs_uid_to_kuid(uint32_t uid)
-{
-	return make_kuid(&init_user_ns, uid);
-}
-
-static inline uint32_t xfs_kgid_to_gid(kgid_t gid)
-{
-	return from_kgid(&init_user_ns, gid);
-}
-
-static inline kgid_t xfs_gid_to_kgid(uint32_t gid)
-{
-	return make_kgid(&init_user_ns, gid);
-}
-
 static inline dev_t xfs_to_linux_dev_t(xfs_dev_t dev)
 {
 	return MKDEV(sysv_major(dev) & 0x1ff, sysv_minor(dev));
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -331,8 +331,7 @@ xfs_qm_dqattach_locked(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
-		error = xfs_qm_dqattach_one(ip,
-				xfs_kuid_to_uid(VFS_I(ip)->i_uid),
+		error = xfs_qm_dqattach_one(ip, i_uid_read(VFS_I(ip)),
 				XFS_DQ_USER, doalloc, &ip->i_udquot);
 		if (error)
 			goto done;
@@ -340,8 +339,7 @@ xfs_qm_dqattach_locked(
 	}
 
 	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
-		error = xfs_qm_dqattach_one(ip,
-				xfs_kgid_to_gid(VFS_I(ip)->i_gid),
+		error = xfs_qm_dqattach_one(ip, i_gid_read(VFS_I(ip)),
 				XFS_DQ_GROUP, doalloc, &ip->i_gdquot);
 		if (error)
 			goto done;
@@ -1642,6 +1640,7 @@ xfs_qm_vop_dqalloc(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
+	struct user_namespace	*user_ns = inode->i_sb->s_user_ns;
 	struct xfs_dquot	*uq = NULL;
 	struct xfs_dquot	*gq = NULL;
 	struct xfs_dquot	*pq = NULL;
@@ -1681,7 +1680,7 @@ xfs_qm_vop_dqalloc(
 			 * holding ilock.
 			 */
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, xfs_kuid_to_uid(uid),
+			error = xfs_qm_dqget(mp, from_kuid(user_ns, uid),
 					XFS_DQ_USER, true, &uq);
 			if (error) {
 				ASSERT(error != -ENOENT);
@@ -1705,7 +1704,7 @@ xfs_qm_vop_dqalloc(
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
 		if (!gid_eq(inode->i_gid, gid)) {
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, xfs_kgid_to_gid(gid),
+			error = xfs_qm_dqget(mp, from_kgid(user_ns, gid),
 					XFS_DQ_GROUP, true, &gq);
 			if (error) {
 				ASSERT(error != -ENOENT);
@@ -1832,8 +1831,7 @@ xfs_qm_vop_chown_reserve(
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    xfs_kuid_to_uid(VFS_I(ip)->i_uid) !=
-			be32_to_cpu(udqp->q_core.d_id)) {
+	    i_uid_read(VFS_I(ip)) != be32_to_cpu(udqp->q_core.d_id)) {
 		udq_delblks = udqp;
 		/*
 		 * If there are delayed allocation blocks, then we have to
@@ -1846,8 +1844,7 @@ xfs_qm_vop_chown_reserve(
 		}
 	}
 	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
-	    xfs_kgid_to_gid(VFS_I(ip)->i_gid) !=
-			be32_to_cpu(gdqp->q_core.d_id)) {
+	    i_gid_read(VFS_I(ip)) != be32_to_cpu(gdqp->q_core.d_id)) {
 		gdq_delblks = gdqp;
 		if (delblks) {
 			ASSERT(ip->i_gdquot);
@@ -1944,16 +1941,14 @@ xfs_qm_vop_create_dqattach(
 
 	if (udqp && XFS_IS_UQUOTA_ON(mp)) {
 		ASSERT(ip->i_udquot == NULL);
-		ASSERT(xfs_kuid_to_uid(VFS_I(ip)->i_uid) ==
-			be32_to_cpu(udqp->q_core.d_id));
+		ASSERT(i_uid_read(VFS_I(ip)) == be32_to_cpu(udqp->q_core.d_id));
 
 		ip->i_udquot = xfs_qm_dqhold(udqp);
 		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
 	if (gdqp && XFS_IS_GQUOTA_ON(mp)) {
 		ASSERT(ip->i_gdquot == NULL);
-		ASSERT(xfs_kgid_to_gid(VFS_I(ip)->i_gid) ==
-			be32_to_cpu(gdqp->q_core.d_id));
+		ASSERT(i_gid_read(VFS_I(ip)) == be32_to_cpu(gdqp->q_core.d_id));
 
 		ip->i_gdquot = xfs_qm_dqhold(gdqp);
 		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);


