Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD0A69CDC0
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbjBTNwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbjBTNwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:52:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A941E9C6
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:52:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97EA4B80D44
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C85C433EF;
        Mon, 20 Feb 2023 13:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901142;
        bh=u8WovKdJ/O7fnxaWvY6g1gWUmyAAkwq9eUh09NxaIFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hu726jkIjjSatMNZtc/EhQ796xACgNKYkdz9yyt1jwCNgYBggwgdsiS0OpDnTO/c6
         0O5uYLwubL5GIjiZ06h1v3n66sn0Rmg+1AXd2ysFbojVegcJQRxbRpAtgoVcYOuXeq
         gi8LKiibVRvD662+gby7s/Mrx0n5u2X2jDPjBJuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/83] xfs: validate v5 feature fields
Date:   Mon, 20 Feb 2023 14:36:01 +0100
Message-Id: <20230220133554.662703456@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit f0f5f658065a5af09126ec892e4c383540a1c77f ]

We don't check that the v4 feature flags taht v5 requires to be set
are actually set anywhere. Do this check when we see that the
filesystem is a v5 filesystem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c | 68 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 58 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 72c05485c8706..04e2a57313fa0 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -30,6 +30,47 @@
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
  */
 
+/*
+ * Check that all the V4 feature bits that the V5 filesystem format requires are
+ * correctly set.
+ */
+static bool
+xfs_sb_validate_v5_features(
+	struct xfs_sb	*sbp)
+{
+	/* We must not have any unknown V4 feature bits set */
+	if (sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS)
+		return false;
+
+	/*
+	 * The CRC bit is considered an invalid V4 flag, so we have to add it
+	 * manually to the OKBITS mask.
+	 */
+	if (sbp->sb_features2 & ~(XFS_SB_VERSION2_OKBITS |
+				  XFS_SB_VERSION2_CRCBIT))
+		return false;
+
+	/* Now check all the required V4 feature flags are set. */
+
+#define V5_VERS_FLAGS	(XFS_SB_VERSION_NLINKBIT	| \
+			XFS_SB_VERSION_ALIGNBIT		| \
+			XFS_SB_VERSION_LOGV2BIT		| \
+			XFS_SB_VERSION_EXTFLGBIT	| \
+			XFS_SB_VERSION_DIRV2BIT		| \
+			XFS_SB_VERSION_MOREBITSBIT)
+
+#define V5_FEAT_FLAGS	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
+			XFS_SB_VERSION2_ATTR2BIT	| \
+			XFS_SB_VERSION2_PROJID32BIT	| \
+			XFS_SB_VERSION2_CRCBIT)
+
+	if ((sbp->sb_versionnum & V5_VERS_FLAGS) != V5_VERS_FLAGS)
+		return false;
+	if ((sbp->sb_features2 & V5_FEAT_FLAGS) != V5_FEAT_FLAGS)
+		return false;
+	return true;
+}
+
 /*
  * We support all XFS versions newer than a v4 superblock with V2 directories.
  */
@@ -37,9 +78,19 @@ bool
 xfs_sb_good_version(
 	struct xfs_sb	*sbp)
 {
-	/* all v5 filesystems are supported */
+	/*
+	 * All v5 filesystems are supported, but we must check that all the
+	 * required v4 feature flags are enabled correctly as the code checks
+	 * those flags and not for v5 support.
+	 */
 	if (xfs_sb_is_v5(sbp))
-		return true;
+		return xfs_sb_validate_v5_features(sbp);
+
+	/* We must not have any unknown v4 feature bits set */
+	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
+	    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
+	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
+		return false;
 
 	/* versions prior to v4 are not supported */
 	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
@@ -51,12 +102,6 @@ xfs_sb_good_version(
 	if (!(sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT))
 		return false;
 
-	/* And must not have any unknown v4 feature bits set */
-	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
-	    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
-	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
-		return false;
-
 	/* It's a supported v4 filesystem */
 	return true;
 }
@@ -264,12 +309,15 @@ xfs_validate_sb_common(
 	bool			has_dalign;
 
 	if (!xfs_verify_magic(bp, dsb->sb_magicnum)) {
-		xfs_warn(mp, "bad magic number");
+		xfs_warn(mp,
+"Superblock has bad magic number 0x%x. Not an XFS filesystem?",
+			be32_to_cpu(dsb->sb_magicnum));
 		return -EWRONGFS;
 	}
 
 	if (!xfs_sb_good_version(sbp)) {
-		xfs_warn(mp, "bad version");
+		xfs_warn(mp,
+"Superblock has unknown features enabled or corrupted feature masks.");
 		return -EWRONGFS;
 	}
 
-- 
2.39.0



