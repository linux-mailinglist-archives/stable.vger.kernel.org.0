Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F025F53B3
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiJELiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiJELiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:38:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB3B78BF7;
        Wed,  5 Oct 2022 04:35:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F2D961656;
        Wed,  5 Oct 2022 11:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD00C43144;
        Wed,  5 Oct 2022 11:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969708;
        bh=rBENtrbxF/c5JYGI/sptVfXgZ0feS/ok9A0VRbiROU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDKMUit1uV1+lCcGZbJl/T6YSp1PQ5mXANGMOt4BrHOJAvxZ0CkJvzJRgo9GJQjIZ
         8zWWGbxqGZ+smyhKiTxqa3PEB9O4+xiFD+JJsvl1uhkkv4wFaA2+oUFQNINwNtK5lL
         q+0MGORLxpmYsAmIe9ZeIl2lvQmCaN8hjCaGXltc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 44/51] xfs: fix memory corruption during remote attr value buffer invalidation
Date:   Wed,  5 Oct 2022 13:32:32 +0200
Message-Id: <20221005113212.314687809@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit e8db2aafcedb7d88320ab83f1000f1606b26d4d7 upstream.

[Replaced XFS_IS_CORRUPT() calls with ASSERT() for 5.4.y backport]

While running generic/103, I observed what looks like memory corruption
and (with slub debugging turned on) a slub redzone warning on i386 when
inactivating an inode with a 64k remote attr value.

On a v5 filesystem, maximally sized remote attr values require one block
more than 64k worth of space to hold both the remote attribute value
header (64 bytes).  On a 4k block filesystem this results in a 68k
buffer; on a 64k block filesystem, this would be a 128k buffer.  Note
that even though we'll never use more than 65,600 bytes of this buffer,
XFS_MAX_BLOCKSIZE is 64k.

This is a problem because the definition of struct xfs_buf_log_format
allows for XFS_MAX_BLOCKSIZE worth of dirty bitmap (64k).  On i386 when we
invalidate a remote attribute, xfs_trans_binval zeroes all 68k worth of
the dirty map, writing right off the end of the log item and corrupting
memory.  We've gotten away with this on x86_64 for years because the
compiler inserts a u32 padding on the end of struct xfs_buf_log_format.

Fortunately for us, remote attribute values are written to disk with
xfs_bwrite(), which is to say that they are not logged.  Fix the problem
by removing all places where we could end up creating a buffer log item
for a remote attribute value and leave a note explaining why.  Next,
replace the open-coded buffer invalidation with a call to the helper we
created in the previous patch that does better checking for bad metadata
before marking the buffer stale.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr_remote.c |   37 ++++++++++++++++++++++++++-----
 fs/xfs/xfs_attr_inactive.c      |   47 +++++++++++-----------------------------
 2 files changed, 44 insertions(+), 40 deletions(-)

--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -25,6 +25,23 @@
 #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
 
 /*
+ * Remote Attribute Values
+ * =======================
+ *
+ * Remote extended attribute values are conceptually simple -- they're written
+ * to data blocks mapped by an inode's attribute fork, and they have an upper
+ * size limit of 64k.  Setting a value does not involve the XFS log.
+ *
+ * However, on a v5 filesystem, maximally sized remote attr values require one
+ * block more than 64k worth of space to hold both the remote attribute value
+ * header (64 bytes).  On a 4k block filesystem this results in a 68k buffer;
+ * on a 64k block filesystem, this would be a 128k buffer.  Note that the log
+ * format can only handle a dirty buffer of XFS_MAX_BLOCKSIZE length (64k).
+ * Therefore, we /must/ ensure that remote attribute value buffers never touch
+ * the logging system and therefore never have a log item.
+ */
+
+/*
  * Each contiguous block has a header, so it is not just a simple attribute
  * length to FSB conversion.
  */
@@ -400,17 +417,25 @@ xfs_attr_rmtval_get(
 			       (map[i].br_startblock != HOLESTARTBLOCK));
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-			error = xfs_trans_read_buf(mp, args->trans,
-						   mp->m_ddev_targp,
-						   dblkno, dblkcnt, 0, &bp,
-						   &xfs_attr3_rmt_buf_ops);
-			if (error)
+			bp = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt, 0,
+					&xfs_attr3_rmt_buf_ops);
+			if (!bp)
+				return -ENOMEM;
+			error = bp->b_error;
+			if (error) {
+				xfs_buf_ioerror_alert(bp, __func__);
+				xfs_buf_relse(bp);
+
+				/* bad CRC means corrupted metadata */
+				if (error == -EFSBADCRC)
+					error = -EFSCORRUPTED;
 				return error;
+			}
 
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
 							&offset, &valuelen,
 							&dst);
-			xfs_trans_brelse(args->trans, bp);
+			xfs_buf_relse(bp);
 			if (error)
 				return error;
 
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -25,22 +25,20 @@
 #include "xfs_error.h"
 
 /*
- * Look at all the extents for this logical region,
- * invalidate any buffers that are incore/in transactions.
+ * Invalidate any incore buffers associated with this remote attribute value
+ * extent.   We never log remote attribute value buffers, which means that they
+ * won't be attached to a transaction and are therefore safe to mark stale.
+ * The actual bunmapi will be taken care of later.
  */
 STATIC int
-xfs_attr3_leaf_freextent(
-	struct xfs_trans	**trans,
+xfs_attr3_rmt_stale(
 	struct xfs_inode	*dp,
 	xfs_dablk_t		blkno,
 	int			blkcnt)
 {
 	struct xfs_bmbt_irec	map;
-	struct xfs_buf		*bp;
 	xfs_dablk_t		tblkno;
-	xfs_daddr_t		dblkno;
 	int			tblkcnt;
-	int			dblkcnt;
 	int			nmap;
 	int			error;
 
@@ -57,35 +55,18 @@ xfs_attr3_leaf_freextent(
 		nmap = 1;
 		error = xfs_bmapi_read(dp, (xfs_fileoff_t)tblkno, tblkcnt,
 				       &map, &nmap, XFS_BMAPI_ATTRFORK);
-		if (error) {
+		if (error)
 			return error;
-		}
 		ASSERT(nmap == 1);
-		ASSERT(map.br_startblock != DELAYSTARTBLOCK);
 
 		/*
-		 * If it's a hole, these are already unmapped
-		 * so there's nothing to invalidate.
+		 * Mark any incore buffers for the remote value as stale.  We
+		 * never log remote attr value buffers, so the buffer should be
+		 * easy to kill.
 		 */
-		if (map.br_startblock != HOLESTARTBLOCK) {
-
-			dblkno = XFS_FSB_TO_DADDR(dp->i_mount,
-						  map.br_startblock);
-			dblkcnt = XFS_FSB_TO_BB(dp->i_mount,
-						map.br_blockcount);
-			bp = xfs_trans_get_buf(*trans,
-					dp->i_mount->m_ddev_targp,
-					dblkno, dblkcnt, 0);
-			if (!bp)
-				return -ENOMEM;
-			xfs_trans_binval(*trans, bp);
-			/*
-			 * Roll to next transaction.
-			 */
-			error = xfs_trans_roll_inode(trans, dp);
-			if (error)
-				return error;
-		}
+		error = xfs_attr_rmtval_stale(dp, &map, 0);
+		if (error)
+			return error;
 
 		tblkno += map.br_blockcount;
 		tblkcnt -= map.br_blockcount;
@@ -174,9 +155,7 @@ xfs_attr3_leaf_inactive(
 	 */
 	error = 0;
 	for (lp = list, i = 0; i < count; i++, lp++) {
-		tmp = xfs_attr3_leaf_freextent(trans, dp,
-				lp->valueblk, lp->valuelen);
-
+		tmp = xfs_attr3_rmt_stale(dp, lp->valueblk, lp->valuelen);
 		if (error == 0)
 			error = tmp;	/* save only the 1st errno */
 	}


