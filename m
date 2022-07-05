Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FD7566BE6
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbiGEMJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235145AbiGEMIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3AD186EA;
        Tue,  5 Jul 2022 05:07:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FD6BB817D4;
        Tue,  5 Jul 2022 12:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1769C341CB;
        Tue,  5 Jul 2022 12:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022871;
        bh=eUPnbsN5qey8yJk67Dttb6PR2gid9MnycznwxnZhKRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVaHatahqxDzvzXI/JVsqMnh27k3gTx7SLhKC1gCEJUwv43OPqm0I2A7GM+EFgjDO
         9pTnOGEM4zPdYcZD98R/Fm61cNiCLsYh1Wf5kzebdo+5TeyuJLKlxJDSE7/ItE2PWO
         s22T9nswU9zd1kGVdO6z2EgfoCVNHk8RaUqRcxQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 41/84] xfs: use current->journal_info for detecting transaction recursion
Date:   Tue,  5 Jul 2022 13:58:04 +0200
Message-Id: <20220705115616.520277372@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 756b1c343333a5aefcc26b0409f3fd16f72281bf upstream.

Because the iomap code using PF_MEMALLOC_NOFS to detect transaction
recursion in XFS is just wrong. Remove it from the iomap code and
replace it with XFS specific internal checks using
current->journal_info instead.

[djwong: This change also realigns the lifetime of NOFS flag changes to
match the incore transaction, instead of the inconsistent scheme we have
now.]

Fixes: 9070733b4efa ("xfs: abstract PF_FSTRANS to PF_MEMALLOC_NOFS")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/buffered-io.c    |    7 -------
 fs/xfs/libxfs/xfs_btree.c |   12 ++++++++++--
 fs/xfs/xfs_aops.c         |   17 +++++++++++++++--
 fs/xfs/xfs_trans.c        |   20 +++++---------------
 fs/xfs/xfs_trans.h        |   30 ++++++++++++++++++++++++++++++
 5 files changed, 60 insertions(+), 26 deletions(-)

--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1461,13 +1461,6 @@ iomap_do_writepage(struct page *page, st
 		goto redirty;
 
 	/*
-	 * Given that we do not allow direct reclaim to call us, we should
-	 * never be called in a recursive filesystem reclaim context.
-	 */
-	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC_NOFS))
-		goto redirty;
-
-	/*
 	 * Is this page beyond the end of the file?
 	 *
 	 * The page index is less than the end_index, adjust the end_offset
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2811,7 +2811,7 @@ xfs_btree_split_worker(
 	struct xfs_btree_split_args	*args = container_of(work,
 						struct xfs_btree_split_args, work);
 	unsigned long		pflags;
-	unsigned long		new_pflags = PF_MEMALLOC_NOFS;
+	unsigned long		new_pflags = 0;
 
 	/*
 	 * we are in a transaction context here, but may also be doing work
@@ -2823,12 +2823,20 @@ xfs_btree_split_worker(
 		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
 
 	current_set_flags_nested(&pflags, new_pflags);
+	xfs_trans_set_context(args->cur->bc_tp);
 
 	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
 					 args->key, args->curp, args->stat);
-	complete(args->done);
 
+	xfs_trans_clear_context(args->cur->bc_tp);
 	current_restore_flags_nested(&pflags, new_pflags);
+
+	/*
+	 * Do not access args after complete() has run here. We don't own args
+	 * and the owner may run and free args before we return here.
+	 */
+	complete(args->done);
+
 }
 
 /*
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -62,7 +62,7 @@ xfs_setfilesize_trans_alloc(
 	 * We hand off the transaction to the completion thread now, so
 	 * clear the flag here.
 	 */
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+	xfs_trans_clear_context(tp);
 	return 0;
 }
 
@@ -125,7 +125,7 @@ xfs_setfilesize_ioend(
 	 * thus we need to mark ourselves as being in a transaction manually.
 	 * Similarly for freeze protection.
 	 */
-	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+	xfs_trans_set_context(tp);
 	__sb_writers_acquired(VFS_I(ip)->i_sb, SB_FREEZE_FS);
 
 	/* we abort the update if there was an IO error */
@@ -577,6 +577,12 @@ xfs_vm_writepage(
 {
 	struct xfs_writepage_ctx wpc = { };
 
+	if (WARN_ON_ONCE(current->journal_info)) {
+		redirty_page_for_writepage(wbc, page);
+		unlock_page(page);
+		return 0;
+	}
+
 	return iomap_writepage(page, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
 
@@ -587,6 +593,13 @@ xfs_vm_writepages(
 {
 	struct xfs_writepage_ctx wpc = { };
 
+	/*
+	 * Writing back data in a transaction context can result in recursive
+	 * transactions. This is bad, so issue a warning and get out of here.
+	 */
+	if (WARN_ON_ONCE(current->journal_info))
+		return 0;
+
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
 	return iomap_writepages(mapping, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -68,6 +68,7 @@ xfs_trans_free(
 	xfs_extent_busy_clear(tp->t_mountp, &tp->t_busy, false);
 
 	trace_xfs_trans_free(tp, _RET_IP_);
+	xfs_trans_clear_context(tp);
 	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_end_intwrite(tp->t_mountp->m_super);
 	xfs_trans_free_dqinfo(tp);
@@ -119,7 +120,8 @@ xfs_trans_dup(
 
 	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
 	tp->t_rtx_res = tp->t_rtx_res_used;
-	ntp->t_pflags = tp->t_pflags;
+
+	xfs_trans_switch_context(tp, ntp);
 
 	/* move deferred ops over to the new tp */
 	xfs_defer_move(ntp, tp);
@@ -153,9 +155,6 @@ xfs_trans_reserve(
 	int			error = 0;
 	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
 
-	/* Mark this thread as being in a transaction */
-	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
-
 	/*
 	 * Attempt to reserve the needed disk blocks by decrementing
 	 * the number needed from the number available.  This will
@@ -163,10 +162,8 @@ xfs_trans_reserve(
 	 */
 	if (blocks > 0) {
 		error = xfs_mod_fdblocks(mp, -((int64_t)blocks), rsvd);
-		if (error != 0) {
-			current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+		if (error != 0)
 			return -ENOSPC;
-		}
 		tp->t_blk_res += blocks;
 	}
 
@@ -240,9 +237,6 @@ undo_blocks:
 		xfs_mod_fdblocks(mp, (int64_t)blocks, rsvd);
 		tp->t_blk_res = 0;
 	}
-
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
-
 	return error;
 }
 
@@ -266,6 +260,7 @@ xfs_trans_alloc(
 	tp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
 	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_start_intwrite(mp->m_super);
+	xfs_trans_set_context(tp);
 
 	/*
 	 * Zero-reservation ("empty") transactions can't modify anything, so
@@ -878,7 +873,6 @@ __xfs_trans_commit(
 
 	xfs_log_commit_cil(mp, tp, &commit_lsn, regrant);
 
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 	xfs_trans_free(tp);
 
 	/*
@@ -910,7 +904,6 @@ out_unreserve:
 			xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
 		tp->t_ticket = NULL;
 	}
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 	xfs_trans_free_items(tp, !!error);
 	xfs_trans_free(tp);
 
@@ -970,9 +963,6 @@ xfs_trans_cancel(
 		tp->t_ticket = NULL;
 	}
 
-	/* mark this thread as no longer being in a transaction */
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
-
 	xfs_trans_free_items(tp, dirty);
 	xfs_trans_free(tp);
 }
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -268,4 +268,34 @@ xfs_trans_item_relog(
 	return lip->li_ops->iop_relog(lip, tp);
 }
 
+static inline void
+xfs_trans_set_context(
+	struct xfs_trans	*tp)
+{
+	ASSERT(current->journal_info == NULL);
+	tp->t_pflags = memalloc_nofs_save();
+	current->journal_info = tp;
+}
+
+static inline void
+xfs_trans_clear_context(
+	struct xfs_trans	*tp)
+{
+	if (current->journal_info == tp) {
+		memalloc_nofs_restore(tp->t_pflags);
+		current->journal_info = NULL;
+	}
+}
+
+static inline void
+xfs_trans_switch_context(
+	struct xfs_trans	*old_tp,
+	struct xfs_trans	*new_tp)
+{
+	ASSERT(current->journal_info == old_tp);
+	new_tp->t_pflags = old_tp->t_pflags;
+	old_tp->t_pflags = 0;
+	current->journal_info = new_tp;
+}
+
 #endif	/* __XFS_TRANS_H__ */


