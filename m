Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A49A69CDD4
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbjBTNxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbjBTNxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:53:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB761CAE3
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:53:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FE5260E9E
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE97C433EF;
        Mon, 20 Feb 2023 13:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901195;
        bh=8EE43zvpSRjdiTlF9uhdglv+RXgGlE0oQvRVXAt1SdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IgaS5KyTVZnNAJ48TqPRzSMoHcJZdhGrGYkM1scDfxNlPrJGxCDStFXn53AN5Q6Z3
         ezQLMGjrmsMq51H2Y6RNl6LVHh3h6QDVftl/y86rsznHDx09sFA73SIBdD7Oy7V8ZE
         CEJUH1KlQiK7nypYUHOHLw7fXpCW3V2QsYsBKLgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 26/83] xfs: detect self referencing btree sibling pointers
Date:   Mon, 20 Feb 2023 14:35:59 +0100
Message-Id: <20230220133554.601578231@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
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

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit dc04db2aa7c9307e740d6d0e173085301c173b1a ]

To catch the obvious graph cycle problem and hence potential endless
looping.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c | 140 ++++++++++++++++++++++++++++----------
 1 file changed, 105 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2983954817135..5bec048343b0c 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -51,6 +51,52 @@ xfs_btree_magic(
 	return magic;
 }
 
+static xfs_failaddr_t
+xfs_btree_check_lblock_siblings(
+	struct xfs_mount	*mp,
+	struct xfs_btree_cur	*cur,
+	int			level,
+	xfs_fsblock_t		fsb,
+	xfs_fsblock_t		sibling)
+{
+	if (sibling == NULLFSBLOCK)
+		return NULL;
+	if (sibling == fsb)
+		return __this_address;
+	if (level >= 0) {
+		if (!xfs_btree_check_lptr(cur, sibling, level + 1))
+			return __this_address;
+	} else {
+		if (!xfs_verify_fsbno(mp, sibling))
+			return __this_address;
+	}
+
+	return NULL;
+}
+
+static xfs_failaddr_t
+xfs_btree_check_sblock_siblings(
+	struct xfs_mount	*mp,
+	struct xfs_btree_cur	*cur,
+	int			level,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_agblock_t		sibling)
+{
+	if (sibling == NULLAGBLOCK)
+		return NULL;
+	if (sibling == agbno)
+		return __this_address;
+	if (level >= 0) {
+		if (!xfs_btree_check_sptr(cur, sibling, level + 1))
+			return __this_address;
+	} else {
+		if (!xfs_verify_agbno(mp, agno, sibling))
+			return __this_address;
+	}
+	return NULL;
+}
+
 /*
  * Check a long btree block header.  Return the address of the failing check,
  * or NULL if everything is ok.
@@ -65,6 +111,8 @@ __xfs_btree_check_lblock(
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_btnum_t		btnum = cur->bc_btnum;
 	int			crc = xfs_has_crc(mp);
+	xfs_failaddr_t		fa;
+	xfs_fsblock_t		fsb = NULLFSBLOCK;
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -83,16 +131,16 @@ __xfs_btree_check_lblock(
 	if (be16_to_cpu(block->bb_numrecs) >
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
-	if (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
-	    !xfs_btree_check_lptr(cur, be64_to_cpu(block->bb_u.l.bb_leftsib),
-			level + 1))
-		return __this_address;
-	if (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
-	    !xfs_btree_check_lptr(cur, be64_to_cpu(block->bb_u.l.bb_rightsib),
-			level + 1))
-		return __this_address;
 
-	return NULL;
+	if (bp)
+		fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
+
+	fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
+			be64_to_cpu(block->bb_u.l.bb_leftsib));
+	if (!fa)
+		fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
+				be64_to_cpu(block->bb_u.l.bb_rightsib));
+	return fa;
 }
 
 /* Check a long btree block header. */
@@ -130,6 +178,9 @@ __xfs_btree_check_sblock(
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_btnum_t		btnum = cur->bc_btnum;
 	int			crc = xfs_has_crc(mp);
+	xfs_failaddr_t		fa;
+	xfs_agblock_t		agbno = NULLAGBLOCK;
+	xfs_agnumber_t		agno = NULLAGNUMBER;
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -146,16 +197,18 @@ __xfs_btree_check_sblock(
 	if (be16_to_cpu(block->bb_numrecs) >
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
-	if (block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_btree_check_sptr(cur, be32_to_cpu(block->bb_u.s.bb_leftsib),
-			level + 1))
-		return __this_address;
-	if (block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_btree_check_sptr(cur, be32_to_cpu(block->bb_u.s.bb_rightsib),
-			level + 1))
-		return __this_address;
 
-	return NULL;
+	if (bp) {
+		agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
+		agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
+	}
+
+	fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno, agbno,
+			be32_to_cpu(block->bb_u.s.bb_leftsib));
+	if (!fa)
+		fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno,
+				 agbno, be32_to_cpu(block->bb_u.s.bb_rightsib));
+	return fa;
 }
 
 /* Check a short btree block header. */
@@ -4265,6 +4318,21 @@ xfs_btree_visit_block(
 	if (xfs_btree_ptr_is_null(cur, &rptr))
 		return -ENOENT;
 
+	/*
+	 * We only visit blocks once in this walk, so we have to avoid the
+	 * internal xfs_btree_lookup_get_block() optimisation where it will
+	 * return the same block without checking if the right sibling points
+	 * back to us and creates a cyclic reference in the btree.
+	 */
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		if (be64_to_cpu(rptr.l) == XFS_DADDR_TO_FSB(cur->bc_mp,
+							xfs_buf_daddr(bp)))
+			return -EFSCORRUPTED;
+	} else {
+		if (be32_to_cpu(rptr.s) == xfs_daddr_to_agbno(cur->bc_mp,
+							xfs_buf_daddr(bp)))
+			return -EFSCORRUPTED;
+	}
 	return xfs_btree_lookup_get_block(cur, level, &rptr, &block);
 }
 
@@ -4439,20 +4507,21 @@ xfs_btree_lblock_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	xfs_fsblock_t		fsb;
+	xfs_failaddr_t		fa;
 
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
 		return __this_address;
 
 	/* sibling pointer verification */
-	if (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
-	    !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_leftsib)))
-		return __this_address;
-	if (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
-	    !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_rightsib)))
-		return __this_address;
-
-	return NULL;
+	fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
+	fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
+			be64_to_cpu(block->bb_u.l.bb_leftsib));
+	if (!fa)
+		fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
+				be64_to_cpu(block->bb_u.l.bb_rightsib));
+	return fa;
 }
 
 /**
@@ -4493,7 +4562,9 @@ xfs_btree_sblock_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-	xfs_agblock_t		agno;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	xfs_failaddr_t		fa;
 
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
@@ -4501,14 +4572,13 @@ xfs_btree_sblock_verify(
 
 	/* sibling pointer verification */
 	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
-	if (block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_verify_agbno(mp, agno, be32_to_cpu(block->bb_u.s.bb_leftsib)))
-		return __this_address;
-	if (block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_verify_agbno(mp, agno, be32_to_cpu(block->bb_u.s.bb_rightsib)))
-		return __this_address;
-
-	return NULL;
+	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
+	fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
+			be32_to_cpu(block->bb_u.s.bb_leftsib));
+	if (!fa)
+		fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
+				be32_to_cpu(block->bb_u.s.bb_rightsib));
+	return fa;
 }
 
 /*
-- 
2.39.0



