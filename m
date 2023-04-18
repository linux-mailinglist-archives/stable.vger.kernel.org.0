Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B116E6251
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbjDRMbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbjDRMbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:31:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E5AD31E
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:31:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AB6D631BF
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCAAC4339B;
        Tue, 18 Apr 2023 12:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821074;
        bh=Pl9WqIak3kcbPx9luMTU802INQ76BBjywadVkN27+hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQFduvn1/yjbB6ypgsKM+IdSTXbZkUkpL/kQOgwLkgcmvZ2sNqfoWPWQwaLazwvfh
         RhA4T/+tCTFe2+Q/jNEtjUh6LmGBYC/CceG722NGDEQBr2XBTHU/d83tFA2ienMZsF
         g8tLpFBfGhSF6uQWs8A34RcxQeGJSrKj0QfNUBN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 82/92] xfs: only check the superblock version for dinode size calculation
Date:   Tue, 18 Apr 2023 14:21:57 +0200
Message-Id: <20230418120307.647615045@linuxfoundation.org>
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

commit e9e2eae89ddb658ea332295153fdca78c12c1e0d upstream.

The size of the dinode structure is only dependent on the file system
version, so instead of checking the individual inode version just use
the newly added xfs_sb_version_has_large_dinode helper, and simplify
various calling conventions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  |    5 ++---
 fs/xfs/libxfs/xfs_bmap.c       |   10 ++++------
 fs/xfs/libxfs/xfs_format.h     |   16 ++++++++--------
 fs/xfs/libxfs/xfs_ialloc.c     |    2 +-
 fs/xfs/libxfs/xfs_inode_buf.c  |    2 +-
 fs/xfs/libxfs/xfs_inode_fork.c |    2 +-
 fs/xfs/libxfs/xfs_inode_fork.h |    9 ++-------
 fs/xfs/libxfs/xfs_log_format.h |   10 ++++------
 fs/xfs/xfs_inode_item.c        |    4 ++--
 fs/xfs/xfs_log_recover.c       |    2 +-
 fs/xfs/xfs_symlink.c           |    2 +-
 11 files changed, 27 insertions(+), 37 deletions(-)

--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -456,7 +456,7 @@ xfs_attr_shortform_bytesfit(
 	int			offset;
 
 	/* rounded down */
-	offset = (XFS_LITINO(mp, dp->i_d.di_version) - bytes) >> 3;
+	offset = (XFS_LITINO(mp) - bytes) >> 3;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_DEV) {
 		minforkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
@@ -523,8 +523,7 @@ xfs_attr_shortform_bytesfit(
 	minforkoff = roundup(minforkoff, 8) >> 3;
 
 	/* attr fork btree root can have at least this many key/ptr pairs */
-	maxforkoff = XFS_LITINO(mp, dp->i_d.di_version) -
-			XFS_BMDR_SPACE_CALC(MINABTPTRS);
+	maxforkoff = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	maxforkoff = maxforkoff >> 3;	/* rounded down */
 
 	if (offset >= maxforkoff)
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -192,14 +192,12 @@ xfs_default_attroffset(
 	struct xfs_mount	*mp = ip->i_mount;
 	uint			offset;
 
-	if (mp->m_sb.sb_inodesize == 256) {
-		offset = XFS_LITINO(mp, ip->i_d.di_version) -
-				XFS_BMDR_SPACE_CALC(MINABTPTRS);
-	} else {
+	if (mp->m_sb.sb_inodesize == 256)
+		offset = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
+	else
 		offset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
-	}
 
-	ASSERT(offset < XFS_LITINO(mp, ip->i_d.di_version));
+	ASSERT(offset < XFS_LITINO(mp));
 	return offset;
 }
 
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -963,8 +963,12 @@ typedef enum xfs_dinode_fmt {
 /*
  * Inode size for given fs.
  */
-#define XFS_LITINO(mp, version) \
-	((int)(((mp)->m_sb.sb_inodesize) - xfs_dinode_size(version)))
+#define XFS_DINODE_SIZE(sbp) \
+	(xfs_sb_version_has_v3inode(sbp) ? \
+		sizeof(struct xfs_dinode) : \
+		offsetof(struct xfs_dinode, di_crc))
+#define XFS_LITINO(mp) \
+	((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb))
 
 /*
  * Inode data & attribute fork sizes, per inode.
@@ -973,13 +977,9 @@ typedef enum xfs_dinode_fmt {
 #define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
 
 #define XFS_DFORK_DSIZE(dip,mp) \
-	(XFS_DFORK_Q(dip) ? \
-		XFS_DFORK_BOFF(dip) : \
-		XFS_LITINO(mp, (dip)->di_version))
+	(XFS_DFORK_Q(dip) ? XFS_DFORK_BOFF(dip) : XFS_LITINO(mp))
 #define XFS_DFORK_ASIZE(dip,mp) \
-	(XFS_DFORK_Q(dip) ? \
-		XFS_LITINO(mp, (dip)->di_version) - XFS_DFORK_BOFF(dip) : \
-		0)
+	(XFS_DFORK_Q(dip) ? XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : 0)
 #define XFS_DFORK_SIZE(dip,mp,w) \
 	((w) == XFS_DATA_FORK ? \
 		XFS_DFORK_DSIZE(dip, mp) : \
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -339,7 +339,7 @@ xfs_ialloc_inode_init(
 		xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
 		for (i = 0; i < M_IGEO(mp)->inodes_per_cluster; i++) {
 			int	ioffset = i << mp->m_sb.sb_inodelog;
-			uint	isize = xfs_dinode_size(version);
+			uint	isize = XFS_DINODE_SIZE(&mp->m_sb);
 
 			free = xfs_make_iptr(mp, fbuf, i);
 			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -417,7 +417,7 @@ xfs_dinode_verify_forkoff(
 	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
 	case XFS_DINODE_FMT_EXTENTS:    /* fall through ... */
 	case XFS_DINODE_FMT_BTREE:
-		if (dip->di_forkoff >= (XFS_LITINO(mp, dip->di_version) >> 3))
+		if (dip->di_forkoff >= (XFS_LITINO(mp) >> 3))
 			return __this_address;
 		break;
 	default:
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -183,7 +183,7 @@ xfs_iformat_local(
 	 */
 	if (unlikely(size > XFS_DFORK_SIZE(dip, ip->i_mount, whichfork))) {
 		xfs_warn(ip->i_mount,
-	"corrupt inode %Lu (bad size %d for local fork, size = %d).",
+	"corrupt inode %Lu (bad size %d for local fork, size = %zd).",
 			(unsigned long long) ip->i_ino, size,
 			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork));
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -46,14 +46,9 @@ struct xfs_ifork {
 			(ip)->i_afp : \
 			(ip)->i_cowfp))
 #define XFS_IFORK_DSIZE(ip) \
-	(XFS_IFORK_Q(ip) ? \
-		XFS_IFORK_BOFF(ip) : \
-		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version))
+	(XFS_IFORK_Q(ip) ? XFS_IFORK_BOFF(ip) : XFS_LITINO((ip)->i_mount))
 #define XFS_IFORK_ASIZE(ip) \
-	(XFS_IFORK_Q(ip) ? \
-		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version) - \
-			XFS_IFORK_BOFF(ip) : \
-		0)
+	(XFS_IFORK_Q(ip) ? XFS_LITINO((ip)->i_mount) - XFS_IFORK_BOFF(ip) : 0)
 #define XFS_IFORK_SIZE(ip,w) \
 	((w) == XFS_DATA_FORK ? \
 		XFS_IFORK_DSIZE(ip) : \
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -424,12 +424,10 @@ struct xfs_log_dinode {
 	/* structure must be padded to 64 bit alignment */
 };
 
-static inline uint xfs_log_dinode_size(int version)
-{
-	if (version == 3)
-		return sizeof(struct xfs_log_dinode);
-	return offsetof(struct xfs_log_dinode, di_next_unlinked);
-}
+#define xfs_log_dinode_size(mp)						\
+	(xfs_sb_version_has_v3inode(&(mp)->m_sb) ?			\
+		sizeof(struct xfs_log_dinode) :				\
+		offsetof(struct xfs_log_dinode, di_next_unlinked))
 
 /*
  * Buffer Log Format defintions
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -125,7 +125,7 @@ xfs_inode_item_size(
 
 	*nvecs += 2;
 	*nbytes += sizeof(struct xfs_inode_log_format) +
-		   xfs_log_dinode_size(ip->i_d.di_version);
+		   xfs_log_dinode_size(ip->i_mount);
 
 	xfs_inode_item_data_fork_size(iip, nvecs, nbytes);
 	if (XFS_IFORK_Q(ip))
@@ -370,7 +370,7 @@ xfs_inode_item_format_core(
 
 	dic = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_ICORE);
 	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);
-	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_d.di_version));
+	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_mount));
 }
 
 /*
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3089,7 +3089,7 @@ xlog_recover_inode_pass2(
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
-	isize = xfs_log_dinode_size(ldip->di_version);
+	isize = xfs_log_dinode_size(mp);
 	if (unlikely(item->ri_buf[1].i_len > isize)) {
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
 				     XFS_ERRLEVEL_LOW, mp, ldip,
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -201,7 +201,7 @@ xfs_symlink(
 	 * The symlink will fit into the inode data fork?
 	 * There can't be any attributes so we get the whole variable part.
 	 */
-	if (pathlen <= XFS_LITINO(mp, dp->i_d.di_version))
+	if (pathlen <= XFS_LITINO(mp))
 		fs_blocks = 0;
 	else
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);


