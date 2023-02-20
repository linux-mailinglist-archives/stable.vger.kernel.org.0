Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA55469CD59
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbjBTNsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbjBTNsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:48:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDD21D91B
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:48:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19527B80D4B
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2B0C433D2;
        Mon, 20 Feb 2023 13:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900903;
        bh=a8Gzswu7mhnCqELJzXunuL3NSB/ZNHph9c0fS/eY76I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ownwpZxwYLVEqy81EgZ8/bllwO59A8M8z0ht3Mi7B2FN79Sf1AXmtoSa4WJhBQdbj
         drhQG1PL0A28Ne4UKxbYZSVeY10oJ6Bpg5FeGtFBzGHfFQ5d5pFlKkTDr+LT7R3pLE
         aDOesfYEOPIBv7N8UgRtF3CDsezz/cqlDy4soFwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 112/156] xfs: proper replay of deferred ops queued during log recovery
Date:   Mon, 20 Feb 2023 14:35:56 +0100
Message-Id: <20230220133607.208733475@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
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

commit e6fff81e487089e47358a028526a9f63cdbcd503 upstream.

When we replay unfinished intent items that have been recovered from the
log, it's possible that the replay will cause the creation of more
deferred work items.  As outlined in commit 509955823cc9c ("xfs: log
recovery should replay deferred ops in order"), later work items have an
implicit ordering dependency on earlier work items.  Therefore, recovery
must replay the items (both recovered and created) in the same order
that they would have been during normal operation.

For log recovery, we enforce this ordering by using an empty transaction
to collect deferred ops that get created in the process of recovering a
log intent item to prevent them from being committed before the rest of
the recovered intent items.  After we finish committing all the
recovered log items, we allocate a transaction with an enormous block
reservation, splice our huge list of created deferred ops into that
transaction, and commit it, thereby finishing all those ops.

This is /really/ hokey -- it's the one place in XFS where we allow
nested transactions; the splicing of the defer ops list is is inelegant
and has to be done twice per recovery function; and the broken way we
handle inode pointers and block reservations cause subtle use-after-free
and allocator problems that will be fixed by this patch and the two
patches after it.

Therefore, replace the hokey empty transaction with a structure designed
to capture each chain of deferred ops that are created as part of
recovering a single unfinished log intent.  Finally, refactor the loop
that replays those chains to do so using one transaction per chain.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_defer.c  |   89 ++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h  |   19 +++++
 fs/xfs/xfs_bmap_item.c     |   18 +----
 fs/xfs/xfs_bmap_item.h     |    3 
 fs/xfs/xfs_extfree_item.c  |    9 +-
 fs/xfs/xfs_extfree_item.h  |    4 -
 fs/xfs/xfs_log_recover.c   |  151 +++++++++++++++++++++++++--------------------
 fs/xfs/xfs_refcount_item.c |   18 +----
 fs/xfs/xfs_refcount_item.h |    3 
 fs/xfs/xfs_rmap_item.c     |    8 +-
 fs/xfs/xfs_rmap_item.h     |    3 
 11 files changed, 213 insertions(+), 112 deletions(-)

--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -563,14 +563,89 @@ xfs_defer_move(
  *
  * Create and log intent items for all the work that we're capturing so that we
  * can be assured that the items will get replayed if the system goes down
- * before log recovery gets a chance to finish the work it put off.  Then we
- * move the chain from stp to dtp.
+ * before log recovery gets a chance to finish the work it put off.  The entire
+ * deferred ops state is transferred to the capture structure and the
+ * transaction is then ready for the caller to commit it.  If there are no
+ * intent items to capture, this function returns NULL.
+ */
+static struct xfs_defer_capture *
+xfs_defer_ops_capture(
+	struct xfs_trans		*tp)
+{
+	struct xfs_defer_capture	*dfc;
+
+	if (list_empty(&tp->t_dfops))
+		return NULL;
+
+	/* Create an object to capture the defer ops. */
+	dfc = kmem_zalloc(sizeof(*dfc), KM_NOFS);
+	INIT_LIST_HEAD(&dfc->dfc_list);
+	INIT_LIST_HEAD(&dfc->dfc_dfops);
+
+	xfs_defer_create_intents(tp);
+
+	/* Move the dfops chain and transaction state to the capture struct. */
+	list_splice_init(&tp->t_dfops, &dfc->dfc_dfops);
+	dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
+	tp->t_flags &= ~XFS_TRANS_LOWMODE;
+
+	return dfc;
+}
+
+/* Release all resources that we used to capture deferred ops. */
+void
+xfs_defer_ops_release(
+	struct xfs_mount		*mp,
+	struct xfs_defer_capture	*dfc)
+{
+	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
+	kmem_free(dfc);
+}
+
+/*
+ * Capture any deferred ops and commit the transaction.  This is the last step
+ * needed to finish a log intent item that we recovered from the log.
+ */
+int
+xfs_defer_ops_capture_and_commit(
+	struct xfs_trans		*tp,
+	struct list_head		*capture_list)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_defer_capture	*dfc;
+	int				error;
+
+	/* If we don't capture anything, commit transaction and exit. */
+	dfc = xfs_defer_ops_capture(tp);
+	if (!dfc)
+		return xfs_trans_commit(tp);
+
+	/* Commit the transaction and add the capture structure to the list. */
+	error = xfs_trans_commit(tp);
+	if (error) {
+		xfs_defer_ops_release(mp, dfc);
+		return error;
+	}
+
+	list_add_tail(&dfc->dfc_list, capture_list);
+	return 0;
+}
+
+/*
+ * Attach a chain of captured deferred ops to a new transaction and free the
+ * capture structure.
  */
 void
-xfs_defer_capture(
-	struct xfs_trans	*dtp,
-	struct xfs_trans	*stp)
+xfs_defer_ops_continue(
+	struct xfs_defer_capture	*dfc,
+	struct xfs_trans		*tp)
 {
-	xfs_defer_create_intents(stp);
-	xfs_defer_move(dtp, stp);
+	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
+
+	/* Move captured dfops chain and state to the transaction. */
+	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
+	tp->t_flags |= dfc->dfc_tpflags;
+
+	kmem_free(dfc);
 }
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -7,6 +7,7 @@
 #define	__XFS_DEFER_H__
 
 struct xfs_defer_op_type;
+struct xfs_defer_capture;
 
 /*
  * Header for deferred operation list.
@@ -62,9 +63,25 @@ extern const struct xfs_defer_op_type xf
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 
 /*
+ * This structure enables a dfops user to detach the chain of deferred
+ * operations from a transaction so that they can be continued later.
+ */
+struct xfs_defer_capture {
+	/* List of other capture structures. */
+	struct list_head	dfc_list;
+
+	/* Deferred ops state saved from the transaction. */
+	struct list_head	dfc_dfops;
+	unsigned int		dfc_tpflags;
+};
+
+/*
  * Functions to capture a chain of deferred operations and continue them later.
  * This doesn't normally happen except log recovery.
  */
-void xfs_defer_capture(struct xfs_trans *dtp, struct xfs_trans *stp);
+int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
+		struct list_head *capture_list);
+void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp);
+void xfs_defer_ops_release(struct xfs_mount *mp, struct xfs_defer_capture *d);
 
 #endif /* __XFS_DEFER_H__ */
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -425,8 +425,8 @@ const struct xfs_defer_op_type xfs_bmap_
  */
 int
 xfs_bui_recover(
-	struct xfs_trans		*parent_tp,
-	struct xfs_bui_log_item		*buip)
+	struct xfs_bui_log_item		*buip,
+	struct list_head		*capture_list)
 {
 	int				error = 0;
 	unsigned int			bui_type;
@@ -442,7 +442,7 @@ xfs_bui_recover(
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip = NULL;
 	struct xfs_bmbt_irec		irec;
-	struct xfs_mount		*mp = parent_tp->t_mountp;
+	struct xfs_mount		*mp = buip->bui_item.li_mountp;
 
 	ASSERT(!test_bit(XFS_BUI_RECOVERED, &buip->bui_flags));
 
@@ -491,12 +491,7 @@ xfs_bui_recover(
 			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
 	if (error)
 		return error;
-	/*
-	 * Recovery stashes all deferred ops during intent processing and
-	 * finishes them on completion. Transfer current dfops state to this
-	 * transaction and transfer the result back before we return.
-	 */
-	xfs_defer_move(tp, parent_tp);
+
 	budp = xfs_trans_get_bud(tp, buip);
 
 	/* Grab the inode. */
@@ -541,15 +536,12 @@ xfs_bui_recover(
 	}
 
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
-	xfs_defer_capture(parent_tp, tp);
-	error = xfs_trans_commit(tp);
+	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
-
 	return error;
 
 err_inode:
-	xfs_defer_move(parent_tp, tp);
 	xfs_trans_cancel(tp);
 	if (ip) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -77,6 +77,7 @@ extern struct kmem_zone	*xfs_bud_zone;
 struct xfs_bui_log_item *xfs_bui_init(struct xfs_mount *);
 void xfs_bui_item_free(struct xfs_bui_log_item *);
 void xfs_bui_release(struct xfs_bui_log_item *);
-int xfs_bui_recover(struct xfs_trans *parent_tp, struct xfs_bui_log_item *buip);
+int xfs_bui_recover(struct xfs_bui_log_item *buip,
+		struct list_head *capture_list);
 
 #endif	/* __XFS_BMAP_ITEM_H__ */
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -586,9 +586,10 @@ const struct xfs_defer_op_type xfs_agfl_
  */
 int
 xfs_efi_recover(
-	struct xfs_mount	*mp,
-	struct xfs_efi_log_item	*efip)
+	struct xfs_efi_log_item	*efip,
+	struct list_head	*capture_list)
 {
+	struct xfs_mount	*mp = efip->efi_item.li_mountp;
 	struct xfs_efd_log_item	*efdp;
 	struct xfs_trans	*tp;
 	int			i;
@@ -637,8 +638,8 @@ xfs_efi_recover(
 	}
 
 	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
-	error = xfs_trans_commit(tp);
-	return error;
+
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 abort_error:
 	xfs_trans_cancel(tp);
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -84,7 +84,7 @@ int			xfs_efi_copy_format(xfs_log_iovec_
 void			xfs_efi_item_free(struct xfs_efi_log_item *);
 void			xfs_efi_release(struct xfs_efi_log_item *);
 
-int			xfs_efi_recover(struct xfs_mount *mp,
-					struct xfs_efi_log_item *efip);
+int			xfs_efi_recover(struct xfs_efi_log_item *efip,
+					struct list_head *capture_list);
 
 #endif	/* __XFS_EXTFREE_ITEM_H__ */
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4587,9 +4587,9 @@ xlog_recover_process_data(
 /* Recover the EFI if necessary. */
 STATIC int
 xlog_recover_process_efi(
-	struct xfs_mount		*mp,
 	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
+	struct xfs_log_item		*lip,
+	struct list_head		*capture_list)
 {
 	struct xfs_efi_log_item		*efip;
 	int				error;
@@ -4602,7 +4602,7 @@ xlog_recover_process_efi(
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
-	error = xfs_efi_recover(mp, efip);
+	error = xfs_efi_recover(efip, capture_list);
 	spin_lock(&ailp->ail_lock);
 
 	return error;
@@ -4627,9 +4627,9 @@ xlog_recover_cancel_efi(
 /* Recover the RUI if necessary. */
 STATIC int
 xlog_recover_process_rui(
-	struct xfs_mount		*mp,
 	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
+	struct xfs_log_item		*lip,
+	struct list_head		*capture_list)
 {
 	struct xfs_rui_log_item		*ruip;
 	int				error;
@@ -4642,7 +4642,7 @@ xlog_recover_process_rui(
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
-	error = xfs_rui_recover(mp, ruip);
+	error = xfs_rui_recover(ruip, capture_list);
 	spin_lock(&ailp->ail_lock);
 
 	return error;
@@ -4667,9 +4667,9 @@ xlog_recover_cancel_rui(
 /* Recover the CUI if necessary. */
 STATIC int
 xlog_recover_process_cui(
-	struct xfs_trans		*parent_tp,
 	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
+	struct xfs_log_item		*lip,
+	struct list_head		*capture_list)
 {
 	struct xfs_cui_log_item		*cuip;
 	int				error;
@@ -4682,7 +4682,7 @@ xlog_recover_process_cui(
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
-	error = xfs_cui_recover(parent_tp, cuip);
+	error = xfs_cui_recover(cuip, capture_list);
 	spin_lock(&ailp->ail_lock);
 
 	return error;
@@ -4707,9 +4707,9 @@ xlog_recover_cancel_cui(
 /* Recover the BUI if necessary. */
 STATIC int
 xlog_recover_process_bui(
-	struct xfs_trans		*parent_tp,
 	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
+	struct xfs_log_item		*lip,
+	struct list_head		*capture_list)
 {
 	struct xfs_bui_log_item		*buip;
 	int				error;
@@ -4722,7 +4722,7 @@ xlog_recover_process_bui(
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
-	error = xfs_bui_recover(parent_tp, buip);
+	error = xfs_bui_recover(buip, capture_list);
 	spin_lock(&ailp->ail_lock);
 
 	return error;
@@ -4761,37 +4761,65 @@ static inline bool xlog_item_is_intent(s
 /* Take all the collected deferred ops and finish them in order. */
 static int
 xlog_finish_defer_ops(
-	struct xfs_trans	*parent_tp)
+	struct xfs_mount	*mp,
+	struct list_head	*capture_list)
 {
-	struct xfs_mount	*mp = parent_tp->t_mountp;
+	struct xfs_defer_capture *dfc, *next;
 	struct xfs_trans	*tp;
 	int64_t			freeblks;
-	uint			resblks;
-	int			error;
+	uint64_t		resblks;
+	int			error = 0;
 
-	/*
-	 * We're finishing the defer_ops that accumulated as a result of
-	 * recovering unfinished intent items during log recovery.  We
-	 * reserve an itruncate transaction because it is the largest
-	 * permanent transaction type.  Since we're the only user of the fs
-	 * right now, take 93% (15/16) of the available free blocks.  Use
-	 * weird math to avoid a 64-bit division.
-	 */
-	freeblks = percpu_counter_sum(&mp->m_fdblocks);
-	if (freeblks <= 0)
-		return -ENOSPC;
-	resblks = min_t(int64_t, UINT_MAX, freeblks);
-	resblks = (resblks * 15) >> 4;
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
-			0, XFS_TRANS_RESERVE, &tp);
-	if (error)
-		return error;
-	/* transfer all collected dfops to this transaction */
-	xfs_defer_move(tp, parent_tp);
+	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
+		/*
+		 * We're finishing the defer_ops that accumulated as a result
+		 * of recovering unfinished intent items during log recovery.
+		 * We reserve an itruncate transaction because it is the
+		 * largest permanent transaction type.  Since we're the only
+		 * user of the fs right now, take 93% (15/16) of the available
+		 * free blocks.  Use weird math to avoid a 64-bit division.
+		 */
+		freeblks = percpu_counter_sum(&mp->m_fdblocks);
+		if (freeblks <= 0)
+			return -ENOSPC;
+
+		resblks = min_t(uint64_t, UINT_MAX, freeblks);
+		resblks = (resblks * 15) >> 4;
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
+				0, XFS_TRANS_RESERVE, &tp);
+		if (error)
+			return error;
+
+		/*
+		 * Transfer to this new transaction all the dfops we captured
+		 * from recovering a single intent item.
+		 */
+		list_del_init(&dfc->dfc_list);
+		xfs_defer_ops_continue(dfc, tp);
+
+		error = xfs_trans_commit(tp);
+		if (error)
+			return error;
+	}
 
-	return xfs_trans_commit(tp);
+	ASSERT(list_empty(capture_list));
+	return 0;
 }
 
+/* Release all the captured defer ops and capture structures in this list. */
+static void
+xlog_abort_defer_ops(
+	struct xfs_mount		*mp,
+	struct list_head		*capture_list)
+{
+	struct xfs_defer_capture	*dfc;
+	struct xfs_defer_capture	*next;
+
+	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
+		list_del_init(&dfc->dfc_list);
+		xfs_defer_ops_release(mp, dfc);
+	}
+}
 /*
  * When this is called, all of the log intent items which did not have
  * corresponding log done items should be in the AIL.  What we do now
@@ -4812,35 +4840,23 @@ STATIC int
 xlog_recover_process_intents(
 	struct xlog		*log)
 {
-	struct xfs_trans	*parent_tp;
+	LIST_HEAD(capture_list);
 	struct xfs_ail_cursor	cur;
 	struct xfs_log_item	*lip;
 	struct xfs_ail		*ailp;
-	int			error;
+	int			error = 0;
 #if defined(DEBUG) || defined(XFS_WARN)
 	xfs_lsn_t		last_lsn;
 #endif
 
-	/*
-	 * The intent recovery handlers commit transactions to complete recovery
-	 * for individual intents, but any new deferred operations that are
-	 * queued during that process are held off until the very end. The
-	 * purpose of this transaction is to serve as a container for deferred
-	 * operations. Each intent recovery handler must transfer dfops here
-	 * before its local transaction commits, and we'll finish the entire
-	 * list below.
-	 */
-	error = xfs_trans_alloc_empty(log->l_mp, &parent_tp);
-	if (error)
-		return error;
-
 	ailp = log->l_ailp;
 	spin_lock(&ailp->ail_lock);
-	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
 #if defined(DEBUG) || defined(XFS_WARN)
 	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
 #endif
-	while (lip != NULL) {
+	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	     lip != NULL;
+	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
 		/*
 		 * We're done when we see something other than an intent.
 		 * There should be no intents left in the AIL now.
@@ -4862,35 +4878,40 @@ xlog_recover_process_intents(
 
 		/*
 		 * NOTE: If your intent processing routine can create more
-		 * deferred ops, you /must/ attach them to the dfops in this
-		 * routine or else those subsequent intents will get
+		 * deferred ops, you /must/ attach them to the capture list in
+		 * the recover routine or else those subsequent intents will be
 		 * replayed in the wrong order!
 		 */
 		switch (lip->li_type) {
 		case XFS_LI_EFI:
-			error = xlog_recover_process_efi(log->l_mp, ailp, lip);
+			error = xlog_recover_process_efi(ailp, lip, &capture_list);
 			break;
 		case XFS_LI_RUI:
-			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
+			error = xlog_recover_process_rui(ailp, lip, &capture_list);
 			break;
 		case XFS_LI_CUI:
-			error = xlog_recover_process_cui(parent_tp, ailp, lip);
+			error = xlog_recover_process_cui(ailp, lip, &capture_list);
 			break;
 		case XFS_LI_BUI:
-			error = xlog_recover_process_bui(parent_tp, ailp, lip);
+			error = xlog_recover_process_bui(ailp, lip, &capture_list);
 			break;
 		}
 		if (error)
-			goto out;
-		lip = xfs_trans_ail_cursor_next(ailp, &cur);
+			break;
 	}
-out:
+
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->ail_lock);
-	if (!error)
-		error = xlog_finish_defer_ops(parent_tp);
-	xfs_trans_cancel(parent_tp);
+	if (error)
+		goto err;
+
+	error = xlog_finish_defer_ops(log->l_mp, &capture_list);
+	if (error)
+		goto err;
 
+	return 0;
+err:
+	xlog_abort_defer_ops(log->l_mp, &capture_list);
 	return error;
 }
 
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -439,8 +439,8 @@ const struct xfs_defer_op_type xfs_refco
  */
 int
 xfs_cui_recover(
-	struct xfs_trans		*parent_tp,
-	struct xfs_cui_log_item		*cuip)
+	struct xfs_cui_log_item		*cuip,
+	struct list_head		*capture_list)
 {
 	int				i;
 	int				error = 0;
@@ -456,7 +456,7 @@ xfs_cui_recover(
 	xfs_extlen_t			new_len;
 	struct xfs_bmbt_irec		irec;
 	bool				requeue_only = false;
-	struct xfs_mount		*mp = parent_tp->t_mountp;
+	struct xfs_mount		*mp = cuip->cui_item.li_mountp;
 
 	ASSERT(!test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags));
 
@@ -511,12 +511,7 @@ xfs_cui_recover(
 			mp->m_refc_maxlevels * 2, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
-	/*
-	 * Recovery stashes all deferred ops during intent processing and
-	 * finishes them on completion. Transfer current dfops state to this
-	 * transaction and transfer the result back before we return.
-	 */
-	xfs_defer_move(tp, parent_tp);
+
 	cudp = xfs_trans_get_cud(tp, cuip);
 
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
@@ -574,13 +569,10 @@ xfs_cui_recover(
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
-	xfs_defer_capture(parent_tp, tp);
-	error = xfs_trans_commit(tp);
-	return error;
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 abort_error:
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	xfs_defer_move(parent_tp, tp);
 	xfs_trans_cancel(tp);
 	return error;
 }
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -80,6 +80,7 @@ extern struct kmem_zone	*xfs_cud_zone;
 struct xfs_cui_log_item *xfs_cui_init(struct xfs_mount *, uint);
 void xfs_cui_item_free(struct xfs_cui_log_item *);
 void xfs_cui_release(struct xfs_cui_log_item *);
-int xfs_cui_recover(struct xfs_trans *parent_tp, struct xfs_cui_log_item *cuip);
+int xfs_cui_recover(struct xfs_cui_log_item *cuip,
+		struct list_head *capture_list);
 
 #endif	/* __XFS_REFCOUNT_ITEM_H__ */
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -483,9 +483,10 @@ const struct xfs_defer_op_type xfs_rmap_
  */
 int
 xfs_rui_recover(
-	struct xfs_mount		*mp,
-	struct xfs_rui_log_item		*ruip)
+	struct xfs_rui_log_item		*ruip,
+	struct list_head		*capture_list)
 {
+	struct xfs_mount		*mp = ruip->rui_item.li_mountp;
 	int				i;
 	int				error = 0;
 	struct xfs_map_extent		*rmap;
@@ -592,8 +593,7 @@ xfs_rui_recover(
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
-	error = xfs_trans_commit(tp);
-	return error;
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 abort_error:
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -82,6 +82,7 @@ int xfs_rui_copy_format(struct xfs_log_i
 		struct xfs_rui_log_format *dst_rui_fmt);
 void xfs_rui_item_free(struct xfs_rui_log_item *);
 void xfs_rui_release(struct xfs_rui_log_item *);
-int xfs_rui_recover(struct xfs_mount *mp, struct xfs_rui_log_item *ruip);
+int xfs_rui_recover(struct xfs_rui_log_item *ruip,
+		struct list_head *capture_list);
 
 #endif	/* __XFS_RMAP_ITEM_H__ */


