Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87165EA15C
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbiIZKuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236544AbiIZKsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:48:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C48857255;
        Mon, 26 Sep 2022 03:26:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD406B802C5;
        Mon, 26 Sep 2022 10:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CEDC433D7;
        Mon, 26 Sep 2022 10:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187961;
        bh=dufonf4R35DJKo/jPWcMKghv7Zd7OMUYJ1IDMfRbh6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcnMzeTmmZTdxtwBqjV9irVSyaLd57+DICcZxQIbnREbi4HqNQwbClW1Ho4nDEau3
         5Zop40ah+dF+I4OhFjoM7+q17MXfyaL9SizgM66svrrLdODgrzqeCtaWkXpYVkuuuu
         SqGb2OoX4PL5NNC1EvzUN2tIsggggSByAuRA9Ck0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 117/120] xfs: split the sunit parameter update into two parts
Date:   Mon, 26 Sep 2022 12:12:30 +0200
Message-Id: <20220926100755.208230523@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 4f5b1b3a8fa07dc8ecedfaf539b3deed8931a73e upstream.

If the administrator provided a sunit= mount option, we need to validate
the raw parameter, convert the mount option units (512b blocks) into the
internal unit (fs blocks), and then validate that the (now cooked)
parameter doesn't screw anything up on disk.  The incore inode geometry
computation can depend on the new sunit option, but a subsequent patch
will make validating the cooked value depends on the computed inode
geometry, so break the sunit update into two steps.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_mount.c |  123 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 72 insertions(+), 51 deletions(-)

--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -365,66 +365,76 @@ release_buf:
 }
 
 /*
- * Update alignment values based on mount options and sb values
+ * If we were provided with new sunit/swidth values as mount options, make sure
+ * that they pass basic alignment and superblock feature checks, and convert
+ * them into the same units (FSB) that everything else expects.  This step
+ * /must/ be done before computing the inode geometry.
  */
 STATIC int
-xfs_update_alignment(xfs_mount_t *mp)
+xfs_validate_new_dalign(
+	struct xfs_mount	*mp)
 {
-	xfs_sb_t	*sbp = &(mp->m_sb);
+	if (mp->m_dalign == 0)
+		return 0;
 
-	if (mp->m_dalign) {
+	/*
+	 * If stripe unit and stripe width are not multiples
+	 * of the fs blocksize turn off alignment.
+	 */
+	if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
+	    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
+		xfs_warn(mp,
+	"alignment check failed: sunit/swidth vs. blocksize(%d)",
+			mp->m_sb.sb_blocksize);
+		return -EINVAL;
+	} else {
 		/*
-		 * If stripe unit and stripe width are not multiples
-		 * of the fs blocksize turn off alignment.
+		 * Convert the stripe unit and width to FSBs.
 		 */
-		if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
-		    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
+		mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
+		if (mp->m_dalign && (mp->m_sb.sb_agblocks % mp->m_dalign)) {
 			xfs_warn(mp,
-		"alignment check failed: sunit/swidth vs. blocksize(%d)",
-				sbp->sb_blocksize);
+		"alignment check failed: sunit/swidth vs. agsize(%d)",
+				 mp->m_sb.sb_agblocks);
 			return -EINVAL;
-		} else {
-			/*
-			 * Convert the stripe unit and width to FSBs.
-			 */
-			mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
-			if (mp->m_dalign && (sbp->sb_agblocks % mp->m_dalign)) {
-				xfs_warn(mp,
-			"alignment check failed: sunit/swidth vs. agsize(%d)",
-					 sbp->sb_agblocks);
-				return -EINVAL;
-			} else if (mp->m_dalign) {
-				mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
-			} else {
-				xfs_warn(mp,
-			"alignment check failed: sunit(%d) less than bsize(%d)",
-					 mp->m_dalign, sbp->sb_blocksize);
-				return -EINVAL;
-			}
-		}
-
-		/*
-		 * Update superblock with new values
-		 * and log changes
-		 */
-		if (xfs_sb_version_hasdalign(sbp)) {
-			if (sbp->sb_unit != mp->m_dalign) {
-				sbp->sb_unit = mp->m_dalign;
-				mp->m_update_sb = true;
-			}
-			if (sbp->sb_width != mp->m_swidth) {
-				sbp->sb_width = mp->m_swidth;
-				mp->m_update_sb = true;
-			}
+		} else if (mp->m_dalign) {
+			mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
 		} else {
 			xfs_warn(mp,
-	"cannot change alignment: superblock does not support data alignment");
+		"alignment check failed: sunit(%d) less than bsize(%d)",
+				 mp->m_dalign, mp->m_sb.sb_blocksize);
 			return -EINVAL;
 		}
+	}
+
+	if (!xfs_sb_version_hasdalign(&mp->m_sb)) {
+		xfs_warn(mp,
+"cannot change alignment: superblock does not support data alignment");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Update alignment values based on mount options and sb values. */
+STATIC int
+xfs_update_alignment(
+	struct xfs_mount	*mp)
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+
+	if (mp->m_dalign) {
+		if (sbp->sb_unit == mp->m_dalign &&
+		    sbp->sb_width == mp->m_swidth)
+			return 0;
+
+		sbp->sb_unit = mp->m_dalign;
+		sbp->sb_width = mp->m_swidth;
+		mp->m_update_sb = true;
 	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
 		    xfs_sb_version_hasdalign(&mp->m_sb)) {
-			mp->m_dalign = sbp->sb_unit;
-			mp->m_swidth = sbp->sb_width;
+		mp->m_dalign = sbp->sb_unit;
+		mp->m_swidth = sbp->sb_width;
 	}
 
 	return 0;
@@ -692,12 +702,12 @@ xfs_mountfs(
 	}
 
 	/*
-	 * Check if sb_agblocks is aligned at stripe boundary
-	 * If sb_agblocks is NOT aligned turn off m_dalign since
-	 * allocator alignment is within an ag, therefore ag has
-	 * to be aligned at stripe boundary.
+	 * If we were given new sunit/swidth options, do some basic validation
+	 * checks and convert the incore dalign and swidth values to the
+	 * same units (FSB) that everything else uses.  This /must/ happen
+	 * before computing the inode geometry.
 	 */
-	error = xfs_update_alignment(mp);
+	error = xfs_validate_new_dalign(mp);
 	if (error)
 		goto out;
 
@@ -708,6 +718,17 @@ xfs_mountfs(
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
+	/*
+	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
+	 * is NOT aligned turn off m_dalign since allocator alignment is within
+	 * an ag, therefore ag has to be aligned at stripe boundary.  Note that
+	 * we must compute the free space and rmap btree geometry before doing
+	 * this.
+	 */
+	error = xfs_update_alignment(mp);
+	if (error)
+		goto out;
+
 	/* enable fail_at_unmount as default */
 	mp->m_fail_unmount = true;
 


