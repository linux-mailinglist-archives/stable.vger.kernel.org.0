Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FFD69CD5C
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbjBTNsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbjBTNsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:48:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73191DB9B
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:48:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E77960EA5
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E82C433EF;
        Mon, 20 Feb 2023 13:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900911;
        bh=w4b+MsLaJtVCanV2PokX/sI2wZvFFsRc3kdRc9MHhx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AqKR3kJ4P1K2xf/meMAdwP46WWNuHRJ6dFlJ1zURLX1GgV8tH7ioqgHZSQYpjsfW6
         AyMIODDbxcpfxKwXFaAHcStBo/wNo4z4FSwu1vvXOz6ei9jV1h1VDDRrJbLqBrBhBU
         nwGXAWjRilbajy7tvERc9I4cB1O1JJ0ebU05UqV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 115/156] xfs: clean up bmap intent item recovery checking
Date:   Mon, 20 Feb 2023 14:35:59 +0100
Message-Id: <20230220133607.358484751@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 919522e89f8e71fc6a8f8abe17be4011573c6ea0 upstream.

The bmap intent item checking code in xfs_bui_item_recover is spread all
over the function.  We should check the recovered log item at the top
before we allocate any resources or do anything else, so do that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_bmap_item.c |   38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -434,9 +434,7 @@ xfs_bui_recover(
 	xfs_fsblock_t			startblock_fsb;
 	xfs_fsblock_t			inode_fsb;
 	xfs_filblks_t			count;
-	bool				op_ok;
 	struct xfs_bud_log_item		*budp;
-	enum xfs_bmap_intent_type	type;
 	int				whichfork;
 	xfs_exntst_t			state;
 	struct xfs_trans		*tp;
@@ -462,16 +460,19 @@ xfs_bui_recover(
 			   XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
 	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
 			XFS_INO_TO_FSB(mp, bmap->me_owner)));
-	switch (bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK) {
+	state = (bmap->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
+			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
+	whichfork = (bmap->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
+			XFS_ATTR_FORK : XFS_DATA_FORK;
+	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
+	switch (bui_type) {
 	case XFS_BMAP_MAP:
 	case XFS_BMAP_UNMAP:
-		op_ok = true;
 		break;
 	default:
-		op_ok = false;
-		break;
+		return -EFSCORRUPTED;
 	}
-	if (!op_ok || startblock_fsb == 0 ||
+	if (startblock_fsb == 0 ||
 	    bmap->me_len == 0 ||
 	    inode_fsb == 0 ||
 	    startblock_fsb >= mp->m_sb.sb_dblocks ||
@@ -502,32 +503,17 @@ xfs_bui_recover(
 	if (VFS_I(ip)->i_nlink == 0)
 		xfs_iflags_set(ip, XFS_IRECOVERY);
 
-	/* Process deferred bmap item. */
-	state = (bmap->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
-			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
-	whichfork = (bmap->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
-			XFS_ATTR_FORK : XFS_DATA_FORK;
-	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
-	switch (bui_type) {
-	case XFS_BMAP_MAP:
-	case XFS_BMAP_UNMAP:
-		type = bui_type;
-		break;
-	default:
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
-		error = -EFSCORRUPTED;
-		goto err_inode;
-	}
 	xfs_trans_ijoin(tp, ip, 0);
 
 	count = bmap->me_len;
-	error = xfs_trans_log_finish_bmap_update(tp, budp, type, ip, whichfork,
-			bmap->me_startoff, bmap->me_startblock, &count, state);
+	error = xfs_trans_log_finish_bmap_update(tp, budp, bui_type, ip,
+			whichfork, bmap->me_startoff, bmap->me_startblock,
+			&count, state);
 	if (error)
 		goto err_inode;
 
 	if (count > 0) {
-		ASSERT(type == XFS_BMAP_UNMAP);
+		ASSERT(bui_type == XFS_BMAP_UNMAP);
 		irec.br_startblock = bmap->me_startblock;
 		irec.br_blockcount = count;
 		irec.br_startoff = bmap->me_startoff;


