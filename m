Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2AF5F53B6
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiJELiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiJELiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:38:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9596C72FFA;
        Wed,  5 Oct 2022 04:35:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67E55B81DC2;
        Wed,  5 Oct 2022 11:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18E6C433D7;
        Wed,  5 Oct 2022 11:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969692;
        bh=j8qDiqd4007TTVXR5GQqV4oL8mrRzRo/CNbjxYNi3ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F08dObQkVzId/ETV1b2KTWPvAqOKrn/LHdP0dbk4nHpiroD1+YKo62owGkoiYKhZr
         pwSBwAIX1jgmSEcIDWP9I/97SYPmisIuf0X5tM7zzkOifyYwq7CdJtIWYqBCAjwOy3
         QwnrNPpVzrdwh+64M8cj6f68lAXOpHGjoTpqxtRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 46/51] xfs: streamline xfs_attr3_leaf_inactive
Date:   Wed,  5 Oct 2022 13:32:34 +0200
Message-Id: <20221005113212.390334261@linuxfoundation.org>
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

commit 0bb9d159bd018b271e783d3b2d3bc82fa0727321 upstream.

Now that we know we don't have to take a transaction to stale the incore
buffers for a remote value, get rid of the unnecessary memory allocation
in the leaf walker and call the rmt_stale function directly.  Flatten
the loop while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.h |    9 ---
 fs/xfs/xfs_attr_inactive.c    |  103 ++++++++++++------------------------------
 2 files changed, 30 insertions(+), 82 deletions(-)

--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -39,15 +39,6 @@ struct xfs_attr3_icleaf_hdr {
 	} freemap[XFS_ATTR_LEAF_MAPSIZE];
 };
 
-/*
- * Used to keep a list of "remote value" extents when unlinking an inode.
- */
-typedef struct xfs_attr_inactive_list {
-	xfs_dablk_t	valueblk;	/* block number of value bytes */
-	int		valuelen;	/* number of bytes in value */
-} xfs_attr_inactive_list_t;
-
-
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -37,8 +37,6 @@ xfs_attr3_rmt_stale(
 	int			blkcnt)
 {
 	struct xfs_bmbt_irec	map;
-	xfs_dablk_t		tblkno;
-	int			tblkcnt;
 	int			nmap;
 	int			error;
 
@@ -46,14 +44,12 @@ xfs_attr3_rmt_stale(
 	 * Roll through the "value", invalidating the attribute value's
 	 * blocks.
 	 */
-	tblkno = blkno;
-	tblkcnt = blkcnt;
-	while (tblkcnt > 0) {
+	while (blkcnt > 0) {
 		/*
 		 * Try to remember where we decided to put the value.
 		 */
 		nmap = 1;
-		error = xfs_bmapi_read(dp, (xfs_fileoff_t)tblkno, tblkcnt,
+		error = xfs_bmapi_read(dp, (xfs_fileoff_t)blkno, blkcnt,
 				       &map, &nmap, XFS_BMAPI_ATTRFORK);
 		if (error)
 			return error;
@@ -68,8 +64,8 @@ xfs_attr3_rmt_stale(
 		if (error)
 			return error;
 
-		tblkno += map.br_blockcount;
-		tblkcnt -= map.br_blockcount;
+		blkno += map.br_blockcount;
+		blkcnt -= map.br_blockcount;
 	}
 
 	return 0;
@@ -83,84 +79,45 @@ xfs_attr3_rmt_stale(
  */
 STATIC int
 xfs_attr3_leaf_inactive(
-	struct xfs_trans	**trans,
-	struct xfs_inode	*dp,
-	struct xfs_buf		*bp)
+	struct xfs_trans		**trans,
+	struct xfs_inode		*dp,
+	struct xfs_buf			*bp)
 {
-	struct xfs_attr_leafblock *leaf;
-	struct xfs_attr3_icleaf_hdr ichdr;
-	struct xfs_attr_leaf_entry *entry;
+	struct xfs_attr3_icleaf_hdr	ichdr;
+	struct xfs_mount		*mp = bp->b_mount;
+	struct xfs_attr_leafblock	*leaf = bp->b_addr;
+	struct xfs_attr_leaf_entry	*entry;
 	struct xfs_attr_leaf_name_remote *name_rmt;
-	struct xfs_attr_inactive_list *list;
-	struct xfs_attr_inactive_list *lp;
-	int			error;
-	int			count;
-	int			size;
-	int			tmp;
-	int			i;
-	struct xfs_mount	*mp = bp->b_mount;
+	int				error;
+	int				i;
 
-	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
 
 	/*
-	 * Count the number of "remote" value extents.
+	 * Find the remote value extents for this leaf and invalidate their
+	 * incore buffers.
 	 */
-	count = 0;
 	entry = xfs_attr3_leaf_entryp(leaf);
 	for (i = 0; i < ichdr.count; entry++, i++) {
-		if (be16_to_cpu(entry->nameidx) &&
-		    ((entry->flags & XFS_ATTR_LOCAL) == 0)) {
-			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
-			if (name_rmt->valueblk)
-				count++;
-		}
-	}
+		int		blkcnt;
 
-	/*
-	 * If there are no "remote" values, we're done.
-	 */
-	if (count == 0) {
-		xfs_trans_brelse(*trans, bp);
-		return 0;
-	}
+		if (!entry->nameidx || (entry->flags & XFS_ATTR_LOCAL))
+			continue;
 
-	/*
-	 * Allocate storage for a list of all the "remote" value extents.
-	 */
-	size = count * sizeof(xfs_attr_inactive_list_t);
-	list = kmem_alloc(size, 0);
-
-	/*
-	 * Identify each of the "remote" value extents.
-	 */
-	lp = list;
-	entry = xfs_attr3_leaf_entryp(leaf);
-	for (i = 0; i < ichdr.count; entry++, i++) {
-		if (be16_to_cpu(entry->nameidx) &&
-		    ((entry->flags & XFS_ATTR_LOCAL) == 0)) {
-			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
-			if (name_rmt->valueblk) {
-				lp->valueblk = be32_to_cpu(name_rmt->valueblk);
-				lp->valuelen = xfs_attr3_rmt_blocks(dp->i_mount,
-						    be32_to_cpu(name_rmt->valuelen));
-				lp++;
-			}
-		}
-	}
-	xfs_trans_brelse(*trans, bp);	/* unlock for trans. in freextent() */
-
-	/*
-	 * Invalidate each of the "remote" value extents.
-	 */
-	error = 0;
-	for (lp = list, i = 0; i < count; i++, lp++) {
-		tmp = xfs_attr3_rmt_stale(dp, lp->valueblk, lp->valuelen);
-		if (error == 0)
-			error = tmp;	/* save only the 1st errno */
+		name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
+		if (!name_rmt->valueblk)
+			continue;
+
+		blkcnt = xfs_attr3_rmt_blocks(dp->i_mount,
+				be32_to_cpu(name_rmt->valuelen));
+		error = xfs_attr3_rmt_stale(dp,
+				be32_to_cpu(name_rmt->valueblk), blkcnt);
+		if (error)
+			goto err;
 	}
 
-	kmem_free(list);
+	xfs_trans_brelse(*trans, bp);
+err:
 	return error;
 }
 


