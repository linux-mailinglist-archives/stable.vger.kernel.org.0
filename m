Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BA22C099A
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733227AbgKWNJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:09:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732832AbgKWMsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:48:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBD352168B;
        Mon, 23 Nov 2020 12:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135688;
        bh=Q00tPwNHBkRAF65fZ9qVOUkTiu+Zlk3ZANn06colzNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4JU5UZrkm45Z/k/F8u99tBLcc6UjWiQptfolwF67FmN1kzuJ6W2ccWIJY0BykvZn
         XdCuEnT49cpEHFTe94ewVBIhkPPiLK42+R6tnvCh9bRkbKAD9Y7sruqa+NISVGRhsZ
         kw5s8GBRSBYEi32qEalb0H+wX1biItqEbwxH14mE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 160/252] xfs: fix the minrecs logic when dealing with inode root child blocks
Date:   Mon, 23 Nov 2020 13:21:50 +0100
Message-Id: <20201123121843.311564983@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit e95b6c3ef1311dd7b20467d932a24b6d0fd88395 ]

The comment and logic in xchk_btree_check_minrecs for dealing with
inode-rooted btrees isn't quite correct.  While the direct children of
the inode root are allowed to have fewer records than what would
normally be allowed for a regular ondisk btree block, this is only true
if there is only one child block and the number of records don't fit in
the inode root.

Fixes: 08a3a692ef58 ("xfs: btree scrub should check minrecs")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/btree.c | 45 ++++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index f52a7b8256f96..debf392e05156 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -452,32 +452,41 @@ xchk_btree_check_minrecs(
 	int			level,
 	struct xfs_btree_block	*block)
 {
-	unsigned int		numrecs;
-	int			ok_level;
-
-	numrecs = be16_to_cpu(block->bb_numrecs);
+	struct xfs_btree_cur	*cur = bs->cur;
+	unsigned int		root_level = cur->bc_nlevels - 1;
+	unsigned int		numrecs = be16_to_cpu(block->bb_numrecs);
 
 	/* More records than minrecs means the block is ok. */
-	if (numrecs >= bs->cur->bc_ops->get_minrecs(bs->cur, level))
+	if (numrecs >= cur->bc_ops->get_minrecs(cur, level))
 		return;
 
 	/*
-	 * Certain btree blocks /can/ have fewer than minrecs records.  Any
-	 * level greater than or equal to the level of the highest dedicated
-	 * btree block are allowed to violate this constraint.
-	 *
-	 * For a btree rooted in a block, the btree root can have fewer than
-	 * minrecs records.  If the btree is rooted in an inode and does not
-	 * store records in the root, the direct children of the root and the
-	 * root itself can have fewer than minrecs records.
+	 * For btrees rooted in the inode, it's possible that the root block
+	 * contents spilled into a regular ondisk block because there wasn't
+	 * enough space in the inode root.  The number of records in that
+	 * child block might be less than the standard minrecs, but that's ok
+	 * provided that there's only one direct child of the root.
 	 */
-	ok_level = bs->cur->bc_nlevels - 1;
-	if (bs->cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
-		ok_level--;
-	if (level >= ok_level)
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    level == cur->bc_nlevels - 2) {
+		struct xfs_btree_block	*root_block;
+		struct xfs_buf		*root_bp;
+		int			root_maxrecs;
+
+		root_block = xfs_btree_get_block(cur, root_level, &root_bp);
+		root_maxrecs = cur->bc_ops->get_dmaxrecs(cur, root_level);
+		if (be16_to_cpu(root_block->bb_numrecs) != 1 ||
+		    numrecs <= root_maxrecs)
+			xchk_btree_set_corrupt(bs->sc, cur, level);
 		return;
+	}
 
-	xchk_btree_set_corrupt(bs->sc, bs->cur, level);
+	/*
+	 * Otherwise, only the root level is allowed to have fewer than minrecs
+	 * records or keyptrs.
+	 */
+	if (level < root_level)
+		xchk_btree_set_corrupt(bs->sc, cur, level);
 }
 
 /*
-- 
2.27.0



