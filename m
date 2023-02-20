Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10BD369CDCB
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbjBTNwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbjBTNwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:52:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642B383F0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:52:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5E8C60E8A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055FCC433EF;
        Mon, 20 Feb 2023 13:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901171;
        bh=fRaTsy8T/K1Kqw3KuvFw7NcE6kjQ1T/Ube78iGCrQyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2XN/P1QL5dE1Qt5t46jd6qpulcQ/f0oR1d/zXRy3HsCBthEjS35h40foWhpfw4V8
         lSp56+YV/A8uG6oKx/ldIIjO/Zk6WrrRMJTnROc/uvgSxJDua2H/fJp8K022NGwiVT
         fJSeF6QG/vhF0rl9MrFDg7MYobk3M8tMJwkjERss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <oliver.sang@intel.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 29/83] xfs: avoid unnecessary runtime sibling pointer endian conversions
Date:   Mon, 20 Feb 2023 14:36:02 +0100
Message-Id: <20230220133554.692656858@linuxfoundation.org>
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

[ Upstream commit 5672225e8f2a872a22b0cecedba7a6644af1fb84 ]

Commit dc04db2aa7c9 has caused a small aim7 regression, showing a
small increase in CPU usage in __xfs_btree_check_sblock() as a
result of the extra checking.

This is likely due to the endian conversion of the sibling poitners
being unconditional instead of relying on the compiler to endian
convert the NULL pointer at compile time and avoiding the runtime
conversion for this common case.

Rework the checks so that endian conversion of the sibling pointers
is only done if they are not null as the original code did.

.... and these need to be "inline" because the compiler completely
fails to inline them automatically like it should be doing.

$ size fs/xfs/libxfs/xfs_btree.o*
   text	   data	    bss	    dec	    hex	filename
  51874	    240	      0	  52114	   cb92 fs/xfs/libxfs/xfs_btree.o.orig
  51562	    240	      0	  51802	   ca5a fs/xfs/libxfs/xfs_btree.o.inline

Just when you think the tools have advanced sufficiently we don't
have to care about stuff like this anymore, along comes a reminder
that *our tools still suck*.

Fixes: dc04db2aa7c9 ("xfs: detect self referencing btree sibling pointers")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c | 47 +++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5bec048343b0c..b4b5bf4bfed7f 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -51,16 +51,31 @@ xfs_btree_magic(
 	return magic;
 }
 
-static xfs_failaddr_t
+/*
+ * These sibling pointer checks are optimised for null sibling pointers. This
+ * happens a lot, and we don't need to byte swap at runtime if the sibling
+ * pointer is NULL.
+ *
+ * These are explicitly marked at inline because the cost of calling them as
+ * functions instead of inlining them is about 36 bytes extra code per call site
+ * on x86-64. Yes, gcc-11 fails to inline them, and explicit inlining of these
+ * two sibling check functions reduces the compiled code size by over 300
+ * bytes.
+ */
+static inline xfs_failaddr_t
 xfs_btree_check_lblock_siblings(
 	struct xfs_mount	*mp,
 	struct xfs_btree_cur	*cur,
 	int			level,
 	xfs_fsblock_t		fsb,
-	xfs_fsblock_t		sibling)
+	__be64			dsibling)
 {
-	if (sibling == NULLFSBLOCK)
+	xfs_fsblock_t		sibling;
+
+	if (dsibling == cpu_to_be64(NULLFSBLOCK))
 		return NULL;
+
+	sibling = be64_to_cpu(dsibling);
 	if (sibling == fsb)
 		return __this_address;
 	if (level >= 0) {
@@ -74,17 +89,21 @@ xfs_btree_check_lblock_siblings(
 	return NULL;
 }
 
-static xfs_failaddr_t
+static inline xfs_failaddr_t
 xfs_btree_check_sblock_siblings(
 	struct xfs_mount	*mp,
 	struct xfs_btree_cur	*cur,
 	int			level,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
-	xfs_agblock_t		sibling)
+	__be32			dsibling)
 {
-	if (sibling == NULLAGBLOCK)
+	xfs_agblock_t		sibling;
+
+	if (dsibling == cpu_to_be32(NULLAGBLOCK))
 		return NULL;
+
+	sibling = be32_to_cpu(dsibling);
 	if (sibling == agbno)
 		return __this_address;
 	if (level >= 0) {
@@ -136,10 +155,10 @@ __xfs_btree_check_lblock(
 		fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 
 	fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
-			be64_to_cpu(block->bb_u.l.bb_leftsib));
+			block->bb_u.l.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
-				be64_to_cpu(block->bb_u.l.bb_rightsib));
+				block->bb_u.l.bb_rightsib);
 	return fa;
 }
 
@@ -204,10 +223,10 @@ __xfs_btree_check_sblock(
 	}
 
 	fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno, agbno,
-			be32_to_cpu(block->bb_u.s.bb_leftsib));
+			block->bb_u.s.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno,
-				 agbno, be32_to_cpu(block->bb_u.s.bb_rightsib));
+				 agbno, block->bb_u.s.bb_rightsib);
 	return fa;
 }
 
@@ -4517,10 +4536,10 @@ xfs_btree_lblock_verify(
 	/* sibling pointer verification */
 	fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 	fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
-			be64_to_cpu(block->bb_u.l.bb_leftsib));
+			block->bb_u.l.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
-				be64_to_cpu(block->bb_u.l.bb_rightsib));
+				block->bb_u.l.bb_rightsib);
 	return fa;
 }
 
@@ -4574,10 +4593,10 @@ xfs_btree_sblock_verify(
 	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
 	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
 	fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
-			be32_to_cpu(block->bb_u.s.bb_leftsib));
+			block->bb_u.s.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
-				be32_to_cpu(block->bb_u.s.bb_rightsib));
+				block->bb_u.s.bb_rightsib);
 	return fa;
 }
 
-- 
2.39.0



