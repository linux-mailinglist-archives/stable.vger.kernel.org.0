Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A6E6E6259
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbjDRMb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjDRMby (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:31:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68E2C165
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:31:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6DEB63213
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D773BC433D2;
        Tue, 18 Apr 2023 12:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821085;
        bh=4k0o3iNo+mY3ZRtLAQP3PgtfWvPWSWPFLiym2k4mCac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iqg56Wxyu6fVjD7jGZzSsWdd40CpBPXVHpZ7U+Nypy+3JYUBb/+SyNmWh8JQdpjhc
         ruHIr/ysWmCC0i5VSo2TIAaccYX0r2yBSdhwBI/rAPp7NZKdWfcKq8SVyQ2KAUiDMU
         WiFWR+iXMoOCvapgJDQiKPOzw9cCT6tO9G49uW9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 85/92] xfs: remove the di_version field from struct icdinode
Date:   Tue, 18 Apr 2023 14:22:00 +0200
Message-Id: <20230418120307.759041938@linuxfoundation.org>
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

commit 6471e9c5e7a109a952be8e3e80b8d9e262af239d upstream.

We know the version is 3 if on a v5 file system.   For earlier file
systems formats we always upgrade the remaining v1 inodes to v2 and
thus only use v2 inodes.  Use the xfs_sb_version_has_large_dinode
helper to check if we deal with small or large dinodes, and thus
remove the need for the di_version field in struct icdinode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   16 ++++++----------
 fs/xfs/libxfs/xfs_inode_buf.h |    1 -
 fs/xfs/xfs_bmap_util.c        |   16 ++++++++--------
 fs/xfs/xfs_inode.c            |   16 ++--------------
 fs/xfs/xfs_inode_item.c       |    8 +++-----
 fs/xfs/xfs_ioctl.c            |    5 ++---
 fs/xfs/xfs_iops.c             |    2 +-
 fs/xfs/xfs_itable.c           |    2 +-
 fs/xfs/xfs_log_recover.c      |    2 +-
 9 files changed, 24 insertions(+), 44 deletions(-)

--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -194,16 +194,14 @@ xfs_inode_from_disk(
 	struct xfs_icdinode	*to = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
-
 	/*
 	 * Convert v1 inodes immediately to v2 inode format as this is the
 	 * minimum inode version format we support in the rest of the code.
+	 * They will also be unconditionally written back to disk as v2 inodes.
 	 */
-	to->di_version = from->di_version;
-	if (to->di_version == 1) {
+	if (unlikely(from->di_version == 1)) {
 		set_nlink(inode, be16_to_cpu(from->di_onlink));
 		to->di_projid = 0;
-		to->di_version = 2;
 	} else {
 		set_nlink(inode, be32_to_cpu(from->di_nlink));
 		to->di_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
@@ -241,7 +239,7 @@ xfs_inode_from_disk(
 	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
 	to->di_flags	= be16_to_cpu(from->di_flags);
 
-	if (to->di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
 		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
@@ -263,7 +261,6 @@ xfs_inode_to_disk(
 	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 	to->di_onlink = 0;
 
-	to->di_version = from->di_version;
 	to->di_format = from->di_format;
 	to->di_uid = cpu_to_be32(i_uid_read(inode));
 	to->di_gid = cpu_to_be32(i_gid_read(inode));
@@ -292,7 +289,8 @@ xfs_inode_to_disk(
 	to->di_dmstate = cpu_to_be16(from->di_dmstate);
 	to->di_flags = cpu_to_be16(from->di_flags);
 
-	if (from->di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
+		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
@@ -304,6 +302,7 @@ xfs_inode_to_disk(
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
 		to->di_flushiter = 0;
 	} else {
+		to->di_version = 2;
 		to->di_flushiter = cpu_to_be16(from->di_flushiter);
 	}
 }
@@ -623,7 +622,6 @@ xfs_iread(
 		/* initialise the on-disk inode core */
 		memset(&ip->i_d, 0, sizeof(ip->i_d));
 		VFS_I(ip)->i_generation = prandom_u32();
-		ip->i_d.di_version = 3;
 		return 0;
 	}
 
@@ -665,7 +663,6 @@ xfs_iread(
 		 * Partial initialisation of the in-core inode. Just the bits
 		 * that xfs_ialloc won't overwrite or relies on being correct.
 		 */
-		ip->i_d.di_version = dip->di_version;
 		VFS_I(ip)->i_generation = be32_to_cpu(dip->di_gen);
 		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
 
@@ -679,7 +676,6 @@ xfs_iread(
 		VFS_I(ip)->i_mode = 0;
 	}
 
-	ASSERT(ip->i_d.di_version >= 2);
 	ip->i_delayed_blks = 0;
 
 	/*
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -16,7 +16,6 @@ struct xfs_dinode;
  * format specific structures at the appropriate time.
  */
 struct xfs_icdinode {
-	int8_t		di_version;	/* inode version */
 	int8_t		di_format;	/* format of di_c data */
 	uint16_t	di_flushiter;	/* incremented on flush */
 	uint32_t	di_projid;	/* owner's project id */
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1624,12 +1624,12 @@ xfs_swap_extent_forks(
 	 * event of a crash. Set the owner change log flags now and leave the
 	 * bmbt scan as the last step.
 	 */
-	if (ip->i_d.di_version == 3 &&
-	    ip->i_d.di_format == XFS_DINODE_FMT_BTREE)
-		(*target_log_flags) |= XFS_ILOG_DOWNER;
-	if (tip->i_d.di_version == 3 &&
-	    tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
-		(*src_log_flags) |= XFS_ILOG_DOWNER;
+	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
+		if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE)
+			(*target_log_flags) |= XFS_ILOG_DOWNER;
+		if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
+			(*src_log_flags) |= XFS_ILOG_DOWNER;
+	}
 
 	/*
 	 * Swap the data forks of the inodes
@@ -1664,7 +1664,7 @@ xfs_swap_extent_forks(
 		(*src_log_flags) |= XFS_ILOG_DEXT;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		ASSERT(ip->i_d.di_version < 3 ||
+		ASSERT(!xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) ||
 		       (*src_log_flags & XFS_ILOG_DOWNER));
 		(*src_log_flags) |= XFS_ILOG_DBROOT;
 		break;
@@ -1676,7 +1676,7 @@ xfs_swap_extent_forks(
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		(*target_log_flags) |= XFS_ILOG_DBROOT;
-		ASSERT(tip->i_d.di_version < 3 ||
+		ASSERT(!xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) ||
 		       (*target_log_flags & XFS_ILOG_DOWNER));
 		break;
 	}
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -795,15 +795,6 @@ xfs_ialloc(
 		return error;
 	ASSERT(ip != NULL);
 	inode = VFS_I(ip);
-
-	/*
-	 * We always convert v1 inodes to v2 now - we only support filesystems
-	 * with >= v2 inode capability, so there is no reason for ever leaving
-	 * an inode in v1 format.
-	 */
-	if (ip->i_d.di_version == 1)
-		ip->i_d.di_version = 2;
-
 	inode->i_mode = mode;
 	set_nlink(inode, nlink);
 	inode->i_uid = current_fsuid();
@@ -841,7 +832,7 @@ xfs_ialloc(
 	ip->i_d.di_dmstate = 0;
 	ip->i_d.di_flags = 0;
 
-	if (ip->i_d.di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		inode_set_iversion(inode, 1);
 		ip->i_d.di_flags2 = 0;
 		ip->i_d.di_cowextsize = 0;
@@ -849,7 +840,6 @@ xfs_ialloc(
 		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
 	}
 
-
 	flags = XFS_ILOG_CORE;
 	switch (mode & S_IFMT) {
 	case S_IFIFO:
@@ -1110,7 +1100,6 @@ xfs_bumplink(
 {
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
-	ASSERT(ip->i_d.di_version > 1);
 	inc_nlink(VFS_I(ip));
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
@@ -3822,7 +3811,6 @@ xfs_iflush_int(
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
 	ASSERT(iip != NULL && iip->ili_fields != 0);
-	ASSERT(ip->i_d.di_version > 1);
 
 	/* set *dip = inode's place in the buffer */
 	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
@@ -3883,7 +3871,7 @@ xfs_iflush_int(
 	 * backwards compatibility with old kernels that predate logging all
 	 * inode changes.
 	 */
-	if (ip->i_d.di_version < 3)
+	if (!xfs_sb_version_has_v3inode(&mp->m_sb))
 		ip->i_d.di_flushiter++;
 
 	/* Check the inline fork data before we write out. */
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -305,8 +305,6 @@ xfs_inode_to_log_dinode(
 	struct inode		*inode = VFS_I(ip);
 
 	to->di_magic = XFS_DINODE_MAGIC;
-
-	to->di_version = from->di_version;
 	to->di_format = from->di_format;
 	to->di_uid = i_uid_read(inode);
 	to->di_gid = i_gid_read(inode);
@@ -339,7 +337,8 @@ xfs_inode_to_log_dinode(
 	/* log a dummy value to ensure log structure is fully initialised */
 	to->di_next_unlinked = NULLAGINO;
 
-	if (from->di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
+		to->di_version = 3;
 		to->di_changecount = inode_peek_iversion(inode);
 		to->di_crtime.t_sec = from->di_crtime.t_sec;
 		to->di_crtime.t_nsec = from->di_crtime.t_nsec;
@@ -351,6 +350,7 @@ xfs_inode_to_log_dinode(
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
 		to->di_flushiter = 0;
 	} else {
+		to->di_version = 2;
 		to->di_flushiter = from->di_flushiter;
 	}
 }
@@ -395,8 +395,6 @@ xfs_inode_item_format(
 	struct xfs_log_iovec	*vecp = NULL;
 	struct xfs_inode_log_format *ilf;
 
-	ASSERT(ip->i_d.di_version > 1);
-
 	ilf = xlog_prepare_iovec(lv, &vecp, XLOG_REG_TYPE_IFORMAT);
 	ilf->ilf_type = XFS_LI_INODE;
 	ilf->ilf_ino = ip->i_ino;
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1299,7 +1299,7 @@ xfs_ioctl_setattr_xflags(
 
 	/* diflags2 only valid for v3 inodes. */
 	di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
-	if (di_flags2 && ip->i_d.di_version < 3)
+	if (di_flags2 && !xfs_sb_version_has_v3inode(&mp->m_sb))
 		return -EINVAL;
 
 	ip->i_d.di_flags = xfs_flags2diflags(ip, fa->fsx_xflags);
@@ -1638,7 +1638,6 @@ xfs_ioctl_setattr(
 			olddquot = xfs_qm_vop_chown(tp, ip,
 						&ip->i_pdquot, pdqp);
 		}
-		ASSERT(ip->i_d.di_version > 1);
 		ip->i_d.di_projid = fa->fsx_projid;
 	}
 
@@ -1651,7 +1650,7 @@ xfs_ioctl_setattr(
 		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
 	else
 		ip->i_d.di_extsize = 0;
-	if (ip->i_d.di_version == 3 &&
+	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
 	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
 		ip->i_d.di_cowextsize = fa->fsx_cowextsize >>
 				mp->m_sb.sb_blocklog;
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -517,7 +517,7 @@ xfs_vn_getattr(
 	stat->blocks =
 		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
 
-	if (ip->i_d.di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		if (request_mask & STATX_BTIME) {
 			stat->result_mask |= STATX_BTIME;
 			stat->btime.tv_sec = ip->i_d.di_crtime.t_sec;
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -110,7 +110,7 @@ xfs_bulkstat_one_int(
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
 	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
 
-	if (dic->di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
 			buf->bs_cowextsize_blks = dic->di_cowextsize;
 	}
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2879,8 +2879,8 @@ xfs_recover_inode_owner_change(
 		return -ENOMEM;
 
 	/* instantiate the inode */
+	ASSERT(dip->di_version >= 3);
 	xfs_inode_from_disk(ip, dip);
-	ASSERT(ip->i_d.di_version >= 3);
 
 	error = xfs_iformat_fork(ip, dip);
 	if (error)


