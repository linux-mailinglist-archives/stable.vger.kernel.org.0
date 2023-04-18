Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B376E624F
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbjDRMbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbjDRMbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:31:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C5DC676
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:31:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95B65631FB
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4F9C433EF;
        Tue, 18 Apr 2023 12:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821072;
        bh=q5argzPEaClpJQEMbplI8xlCdFHDVW1Foo1B0xfKLaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p1smbpHlCFKJoFvEHHXOvPijMXnfgSMD/Ytyd23S8StabDTo2kmBiJNwd/7w4gMx/
         4gDYQUixQypBQmk55sV4/4csxDXdIbRj5en4oxeLvGyy3hXoWbZQr7tJC57R/rdN+S
         kaNdghX2hGLq26rvIs8uapSrpTlJlYl3W2bdAkSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 81/92] xfs: add a new xfs_sb_version_has_v3inode helper
Date:   Tue, 18 Apr 2023 14:21:56 +0200
Message-Id: <20230418120307.616641452@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit b81b79f4eda2ea98ae5695c0b6eb384c8d90b74d upstream.

Add a new wrapper to check if a file system supports the v3 inode format
with a larger dinode core.  Previously we used xfs_sb_version_hascrc for
that, which is technically correct but a little confusing to read.

Also move xfs_dinode_good_version next to xfs_sb_version_has_v3inode
so that we have one place that documents the superblock version to
inode version relationship.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_format.h     |   17 +++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.c     |    4 ++--
 fs/xfs/libxfs/xfs_inode_buf.c  |   17 +++--------------
 fs/xfs/libxfs/xfs_inode_buf.h  |    2 --
 fs/xfs/libxfs/xfs_trans_resv.c |    2 +-
 fs/xfs/xfs_buf_item.c          |    2 +-
 fs/xfs/xfs_log_recover.c       |    2 +-
 7 files changed, 25 insertions(+), 21 deletions(-)

--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -497,6 +497,23 @@ static inline bool xfs_sb_version_hascrc
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
 
+/*
+ * v5 file systems support V3 inodes only, earlier file systems support
+ * v2 and v1 inodes.
+ */
+static inline bool xfs_sb_version_has_v3inode(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
+}
+
+static inline bool xfs_dinode_good_version(struct xfs_sb *sbp,
+		uint8_t version)
+{
+	if (xfs_sb_version_has_v3inode(sbp))
+		return version == 3;
+	return version == 1 || version == 2;
+}
+
 static inline bool xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -303,7 +303,7 @@ xfs_ialloc_inode_init(
 	 * That means for v3 inode we log the entire buffer rather than just the
 	 * inode cores.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		version = 3;
 		ino = XFS_AGINO_TO_INO(mp, agno, XFS_AGB_TO_AGINO(mp, agbno));
 
@@ -2818,7 +2818,7 @@ xfs_ialloc_setup_geometry(
 	 * cannot change the behavior.
 	 */
 	igeo->inode_cluster_size_raw = XFS_INODE_BIG_CLUSTER_SIZE;
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		int	new_size = igeo->inode_cluster_size_raw;
 
 		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -44,17 +44,6 @@ xfs_inobp_check(
 }
 #endif
 
-bool
-xfs_dinode_good_version(
-	struct xfs_mount *mp,
-	__u8		version)
-{
-	if (xfs_sb_version_hascrc(&mp->m_sb))
-		return version == 3;
-
-	return version == 1 || version == 2;
-}
-
 /*
  * If we are doing readahead on an inode buffer, we might be in log recovery
  * reading an inode allocation buffer that hasn't yet been replayed, and hence
@@ -93,7 +82,7 @@ xfs_inode_buf_verify(
 		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
 		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
 		di_ok = xfs_verify_magic16(bp, dip->di_magic) &&
-			xfs_dinode_good_version(mp, dip->di_version) &&
+			xfs_dinode_good_version(&mp->m_sb, dip->di_version) &&
 			xfs_verify_agino_or_null(mp, agno, unlinked_ino);
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP))) {
@@ -454,7 +443,7 @@ xfs_dinode_verify(
 
 	/* Verify v3 integrity information first */
 	if (dip->di_version >= 3) {
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
+		if (!xfs_sb_version_has_v3inode(&mp->m_sb))
 			return __this_address;
 		if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
 				      XFS_DINODE_CRC_OFF))
@@ -629,7 +618,7 @@ xfs_iread(
 
 	/* shortcut IO on inode allocation if possible */
 	if ((iget_flags & XFS_IGET_CREATE) &&
-	    xfs_sb_version_hascrc(&mp->m_sb) &&
+	    xfs_sb_version_has_v3inode(&mp->m_sb) &&
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		/* initialise the on-disk inode core */
 		memset(&ip->i_d, 0, sizeof(ip->i_d));
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -59,8 +59,6 @@ void	xfs_inode_from_disk(struct xfs_inod
 void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
 			       struct xfs_dinode *to);
 
-bool	xfs_dinode_good_version(struct xfs_mount *mp, __u8 version);
-
 #if defined(DEBUG)
 void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 #else
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -187,7 +187,7 @@ xfs_calc_inode_chunk_res(
 			       XFS_FSB_TO_B(mp, 1));
 	if (alloc) {
 		/* icreate tx uses ordered buffers */
-		if (xfs_sb_version_hascrc(&mp->m_sb))
+		if (xfs_sb_version_has_v3inode(&mp->m_sb))
 			return res;
 		size = XFS_FSB_TO_B(mp, 1);
 	}
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -328,7 +328,7 @@ xfs_buf_item_format(
 	 * occurs during recovery.
 	 */
 	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
-		if (xfs_sb_version_hascrc(&lip->li_mountp->m_sb) ||
+		if (xfs_sb_version_has_v3inode(&lip->li_mountp->m_sb) ||
 		    !((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
 		      xfs_log_item_in_current_chkpt(lip)))
 			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3018,7 +3018,7 @@ xlog_recover_inode_pass2(
 	 * superblock flag to determine whether we need to look at di_flushiter
 	 * to skip replay when the on disk inode is newer than the log one
 	 */
-	if (!xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (!xfs_sb_version_has_v3inode(&mp->m_sb) &&
 	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
 		/*
 		 * Deal with the wrap case, DI_MAX_FLUSH is less


