Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E5960FECD
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237061AbiJ0RIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237054AbiJ0RId (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:08:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC085199F5E
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:08:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4152623E8
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4CCC433D6;
        Thu, 27 Oct 2022 17:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890511;
        bh=W0mm+2kd9bh11jYR09cIXEh7IsWI77aGRkhvDxV+j20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHE0acKF+0SL+Iw8yQ6eW96nZ8axrQvY4askpkWzqTlp0Xiv5ovib7mLAZzIjiehp
         fhKkNAG/aAG6qsFktT2tXzcQgYNKmfNluJp+RhLq2yeIxi/IPKM/ZdMO61HRA3M1wG
         70Xw51U633xiKM7i70vS0LNWa6JWdE6jJ/e4m1Wg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 04/53] xfs: add a function to deal with corrupt buffers post-verifiers
Date:   Thu, 27 Oct 2022 18:55:52 +0200
Message-Id: <20221027165049.991596098@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 8d57c21600a514d7a9237327c2496ae159bab5bb upstream.

Add a helper function to get rid of buffers that we have decided are
corrupt after the verifiers have run.  This function is intended to
handle metadata checks that can't happen in the verifiers, such as
inter-block relationship checking.  Note that we now mark the buffer
stale so that it will not end up on any LRU and will be purged on
release.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_alloc.c     |    2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c |    6 +++---
 fs/xfs/libxfs/xfs_btree.c     |    2 +-
 fs/xfs/libxfs/xfs_da_btree.c  |   10 +++++-----
 fs/xfs/libxfs/xfs_dir2_leaf.c |    2 +-
 fs/xfs/libxfs/xfs_dir2_node.c |    6 +++---
 fs/xfs/xfs_attr_inactive.c    |    6 +++---
 fs/xfs/xfs_attr_list.c        |    2 +-
 fs/xfs/xfs_buf.c              |   22 ++++++++++++++++++++++
 fs/xfs/xfs_buf.h              |    2 ++
 fs/xfs/xfs_error.c            |    2 ++
 fs/xfs/xfs_inode.c            |    4 ++--
 12 files changed, 46 insertions(+), 20 deletions(-)

--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -685,7 +685,7 @@ xfs_alloc_update_counters(
 	xfs_trans_agblocks_delta(tp, len);
 	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
 		     be32_to_cpu(agf->agf_length))) {
-		xfs_buf_corruption_error(agbp);
+		xfs_buf_mark_corrupt(agbp);
 		return -EFSCORRUPTED;
 	}
 
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2288,7 +2288,7 @@ xfs_attr3_leaf_lookup_int(
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
 	if (ichdr.count >= args->geo->blksize / 8) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
@@ -2307,11 +2307,11 @@ xfs_attr3_leaf_lookup_int(
 			break;
 	}
 	if (!(probe >= 0 && (!ichdr.count || probe < ichdr.count))) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 	if (!(span <= 4 || be32_to_cpu(entry->hashval) == hashval)) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1820,7 +1820,7 @@ xfs_btree_lookup_get_block(
 
 out_bad:
 	*blkp = NULL;
-	xfs_buf_corruption_error(bp);
+	xfs_buf_mark_corrupt(bp);
 	xfs_trans_brelse(cur->bc_tp, bp);
 	return -EFSCORRUPTED;
 }
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -504,7 +504,7 @@ xfs_da3_split(
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.forw) {
 		if (be32_to_cpu(node->hdr.info.forw) != addblk->blkno) {
-			xfs_buf_corruption_error(oldblk->bp);
+			xfs_buf_mark_corrupt(oldblk->bp);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -517,7 +517,7 @@ xfs_da3_split(
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.back) {
 		if (be32_to_cpu(node->hdr.info.back) != addblk->blkno) {
-			xfs_buf_corruption_error(oldblk->bp);
+			xfs_buf_mark_corrupt(oldblk->bp);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -1544,7 +1544,7 @@ xfs_da3_node_lookup_int(
 		}
 
 		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC) {
-			xfs_buf_corruption_error(blk->bp);
+			xfs_buf_mark_corrupt(blk->bp);
 			return -EFSCORRUPTED;
 		}
 
@@ -1559,7 +1559,7 @@ xfs_da3_node_lookup_int(
 
 		/* Tree taller than we can handle; bail out! */
 		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
-			xfs_buf_corruption_error(blk->bp);
+			xfs_buf_mark_corrupt(blk->bp);
 			return -EFSCORRUPTED;
 		}
 
@@ -1567,7 +1567,7 @@ xfs_da3_node_lookup_int(
 		if (blkno == args->geo->leafblk)
 			expected_level = nodehdr.level - 1;
 		else if (expected_level != nodehdr.level) {
-			xfs_buf_corruption_error(blk->bp);
+			xfs_buf_mark_corrupt(blk->bp);
 			return -EFSCORRUPTED;
 		} else
 			expected_level--;
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1344,7 +1344,7 @@ xfs_dir2_leaf_removename(
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	if (be16_to_cpu(bestsp[db]) != oldbest) {
-		xfs_buf_corruption_error(lbp);
+		xfs_buf_mark_corrupt(lbp);
 		return -EFSCORRUPTED;
 	}
 	/*
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -375,7 +375,7 @@ xfs_dir2_leaf_to_node(
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	if (be32_to_cpu(ltp->bestcount) >
 				(uint)dp->i_d.di_size / args->geo->blksize) {
-		xfs_buf_corruption_error(lbp);
+		xfs_buf_mark_corrupt(lbp);
 		return -EFSCORRUPTED;
 	}
 
@@ -449,7 +449,7 @@ xfs_dir2_leafn_add(
 	 * into other peoples memory
 	 */
 	if (index < 0) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
@@ -745,7 +745,7 @@ xfs_dir2_leafn_lookup_for_entry(
 
 	xfs_dir3_leaf_check(dp, bp);
 	if (leafhdr.count <= 0) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -145,7 +145,7 @@ xfs_attr3_node_inactive(
 	 * Since this code is recursive (gasp!) we must protect ourselves.
 	 */
 	if (level > XFS_DA_NODE_MAXDEPTH) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
 		return -EFSCORRUPTED;
 	}
@@ -196,7 +196,7 @@ xfs_attr3_node_inactive(
 			error = xfs_attr3_leaf_inactive(trans, dp, child_bp);
 			break;
 		default:
-			xfs_buf_corruption_error(child_bp);
+			xfs_buf_mark_corrupt(child_bp);
 			xfs_trans_brelse(*trans, child_bp);
 			error = -EFSCORRUPTED;
 			break;
@@ -281,7 +281,7 @@ xfs_attr3_root_inactive(
 		break;
 	default:
 		error = -EFSCORRUPTED;
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		xfs_trans_brelse(*trans, bp);
 		break;
 	}
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -271,7 +271,7 @@ xfs_attr_node_list_lookup(
 	return 0;
 
 out_corruptbuf:
-	xfs_buf_corruption_error(bp);
+	xfs_buf_mark_corrupt(bp);
 	xfs_trans_brelse(tp, bp);
 	return -EFSCORRUPTED;
 }
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1547,6 +1547,28 @@ xfs_buf_zero(
 }
 
 /*
+ * Log a message about and stale a buffer that a caller has decided is corrupt.
+ *
+ * This function should be called for the kinds of metadata corruption that
+ * cannot be detect from a verifier, such as incorrect inter-block relationship
+ * data.  Do /not/ call this function from a verifier function.
+ *
+ * The buffer must be XBF_DONE prior to the call.  Afterwards, the buffer will
+ * be marked stale, but b_error will not be set.  The caller is responsible for
+ * releasing the buffer or fixing it.
+ */
+void
+__xfs_buf_mark_corrupt(
+	struct xfs_buf		*bp,
+	xfs_failaddr_t		fa)
+{
+	ASSERT(bp->b_flags & XBF_DONE);
+
+	xfs_buf_corruption_error(bp);
+	xfs_buf_stale(bp);
+}
+
+/*
  *	Handling of buffer targets (buftargs).
  */
 
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -270,6 +270,8 @@ static inline int xfs_buf_submit(struct
 }
 
 void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize);
+void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
+#define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
 
 /* Buffer Utility Routines */
 extern void *xfs_buf_offset(struct xfs_buf *, size_t);
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -345,6 +345,8 @@ xfs_corruption_error(
  * Complain about the kinds of metadata corruption that we can't detect from a
  * verifier, such as incorrect inter-block relationship data.  Does not set
  * bp->b_error.
+ *
+ * Call xfs_buf_mark_corrupt, not this function.
  */
 void
 xfs_buf_corruption_error(
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2149,7 +2149,7 @@ xfs_iunlink_update_bucket(
 	 * head of the list.
 	 */
 	if (old_value == new_agino) {
-		xfs_buf_corruption_error(agibp);
+		xfs_buf_mark_corrupt(agibp);
 		return -EFSCORRUPTED;
 	}
 
@@ -2283,7 +2283,7 @@ xfs_iunlink(
 	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
 	if (next_agino == agino ||
 	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
-		xfs_buf_corruption_error(agibp);
+		xfs_buf_mark_corrupt(agibp);
 		return -EFSCORRUPTED;
 	}
 


