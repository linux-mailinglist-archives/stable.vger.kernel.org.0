Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCC85F53A0
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiJELhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiJELgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:36:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA539178B1;
        Wed,  5 Oct 2022 04:34:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2373B61656;
        Wed,  5 Oct 2022 11:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312CDC433D6;
        Wed,  5 Oct 2022 11:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969657;
        bh=nInTyQACV3CY1ciFEyiiev7nDSZpeoPFRNvmRpNvuX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yYxuoqhqFDQPfEYRI4mTTTPQeHQetLnquq0xOQooKr83QXHN29QSb0insiHqO6AA3
         TsxVh+UMQozLzJrMFBNaPMMcS36fK4VAEnblurTew7MiufVRk10zpH4EdBBMkIXWoN
         3SqPAkkHbWSXKoLVbpexYpCA4dGZNgn3Xz/GbNUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 40/51] xfs: truncate should remove all blocks, not just to the end of the page cache
Date:   Wed,  5 Oct 2022 13:32:28 +0200
Message-Id: <20221005113212.143617510@linuxfoundation.org>
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

commit 4bbb04abb4ee2e1f7d65e52557ba1c4038ea43ed upstream.

xfs_itruncate_extents_flags() is supposed to unmap every block in a file
from EOF onwards.  Oddly, it uses s_maxbytes as the upper limit to the
bunmapi range, even though s_maxbytes reflects the highest offset the
pagecache can support, not the highest offset that XFS supports.

The result of this confusion is that if you create a 20T file on a
64-bit machine, mount the filesystem on a 32-bit machine, and remove the
file, we leak everything above 16T.  Fix this by capping the bunmapi
request at the maximum possible block offset, not s_maxbytes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1513,7 +1513,6 @@ xfs_itruncate_extents_flags(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp = *tpp;
 	xfs_fileoff_t		first_unmap_block;
-	xfs_fileoff_t		last_block;
 	xfs_filblks_t		unmap_len;
 	int			error = 0;
 	int			done = 0;
@@ -1536,21 +1535,22 @@ xfs_itruncate_extents_flags(
 	 * the end of the file (in a crash where the space is allocated
 	 * but the inode size is not yet updated), simply remove any
 	 * blocks which show up between the new EOF and the maximum
-	 * possible file size.  If the first block to be removed is
-	 * beyond the maximum file size (ie it is the same as last_block),
-	 * then there is nothing to do.
+	 * possible file size.
+	 *
+	 * We have to free all the blocks to the bmbt maximum offset, even if
+	 * the page cache can't scale that far.
 	 */
 	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
-	last_block = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
-	if (first_unmap_block == last_block)
+	if (first_unmap_block >= XFS_MAX_FILEOFF) {
+		WARN_ON_ONCE(first_unmap_block > XFS_MAX_FILEOFF);
 		return 0;
+	}
 
-	ASSERT(first_unmap_block < last_block);
-	unmap_len = last_block - first_unmap_block + 1;
-	while (!done) {
+	unmap_len = XFS_MAX_FILEOFF - first_unmap_block + 1;
+	while (unmap_len > 0) {
 		ASSERT(tp->t_firstblock == NULLFSBLOCK);
-		error = xfs_bunmapi(tp, ip, first_unmap_block, unmap_len, flags,
-				    XFS_ITRUNC_MAX_EXTENTS, &done);
+		error = __xfs_bunmapi(tp, ip, first_unmap_block, &unmap_len,
+				flags, XFS_ITRUNC_MAX_EXTENTS);
 		if (error)
 			goto out;
 
@@ -1570,7 +1570,7 @@ xfs_itruncate_extents_flags(
 	if (whichfork == XFS_DATA_FORK) {
 		/* Remove all pending CoW reservations. */
 		error = xfs_reflink_cancel_cow_blocks(ip, &tp,
-				first_unmap_block, last_block, true);
+				first_unmap_block, XFS_MAX_FILEOFF, true);
 		if (error)
 			goto out;
 


