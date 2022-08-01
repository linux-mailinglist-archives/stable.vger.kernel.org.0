Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F7E586920
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbiHAL5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbiHAL4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:56:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E8E402CB;
        Mon,  1 Aug 2022 04:51:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A72CB8116B;
        Mon,  1 Aug 2022 11:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE14BC433B5;
        Mon,  1 Aug 2022 11:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354699;
        bh=NWrui8DzMfCCP+fxtwZlxKyUsZEro2Gzf4ZABtc5isA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2+sdEpYibT4bCSg4yhosLu+bfW2coPw1pQ6yD06XVacTt0cLHym9zT8f1x8bAVUi
         gJwwfoe7mc2nkad4Lcwj4dJ9nSMNqcnByuRzU1YyyAEoZYRiSkVP960sD5gM3Yv1cK
         H9SaU8IE/V/AvJUUJmFHrLUQHMNKYrcAePZ9KpBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 54/65] xfs: xfs_log_force_lsn isnt passed a LSN
Date:   Mon,  1 Aug 2022 13:47:11 +0200
Message-Id: <20220801114135.932039522@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 5f9b4b0de8dc2fb8eb655463b438001c111570fe upstream.

[backported from CIL scalability series for dependency]

In doing an investigation into AIL push stalls, I was looking at the
log force code to see if an async CIL push could be done instead.
This lead me to xfs_log_force_lsn() and looking at how it works.

xfs_log_force_lsn() is only called from inode synchronisation
contexts such as fsync(), and it takes the ip->i_itemp->ili_last_lsn
value as the LSN to sync the log to. This gets passed to
xlog_cil_force_lsn() via xfs_log_force_lsn() to flush the CIL to the
journal, and then used by xfs_log_force_lsn() to flush the iclogs to
the journal.

The problem is that ip->i_itemp->ili_last_lsn does not store a
log sequence number. What it stores is passed to it from the
->iop_committing method, which is called by xfs_log_commit_cil().
The value this passes to the iop_committing method is the CIL
context sequence number that the item was committed to.

As it turns out, xlog_cil_force_lsn() converts the sequence to an
actual commit LSN for the related context and returns that to
xfs_log_force_lsn(). xfs_log_force_lsn() overwrites it's "lsn"
variable that contained a sequence with an actual LSN and then uses
that to sync the iclogs.

This caused me some confusion for a while, even though I originally
wrote all this code a decade ago. ->iop_committing is only used by
a couple of log item types, and only inode items use the sequence
number it is passed.

Let's clean up the API, CIL structures and inode log item to call it
a sequence number, and make it clear that the high level code is
using CIL sequence numbers and not on-disk LSNs for integrity
synchronisation purposes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_types.h |    1 +
 fs/xfs/xfs_buf_item.c     |    2 +-
 fs/xfs/xfs_dquot_item.c   |    2 +-
 fs/xfs/xfs_file.c         |   14 +++++++-------
 fs/xfs/xfs_inode.c        |   10 +++++-----
 fs/xfs/xfs_inode_item.c   |    4 ++--
 fs/xfs/xfs_inode_item.h   |    2 +-
 fs/xfs/xfs_log.c          |   27 ++++++++++++++-------------
 fs/xfs/xfs_log.h          |    4 +---
 fs/xfs/xfs_log_cil.c      |   30 +++++++++++-------------------
 fs/xfs/xfs_log_priv.h     |   15 +++++++--------
 fs/xfs/xfs_trans.c        |    6 +++---
 fs/xfs/xfs_trans.h        |    4 ++--
 13 files changed, 56 insertions(+), 65 deletions(-)

--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -21,6 +21,7 @@ typedef int32_t		xfs_suminfo_t;	/* type
 typedef uint32_t	xfs_rtword_t;	/* word type for bitmap manipulations */
 
 typedef int64_t		xfs_lsn_t;	/* log sequence number */
+typedef int64_t		xfs_csn_t;	/* CIL sequence number */
 
 typedef uint32_t	xfs_dablk_t;	/* dir/attr block number (in file) */
 typedef uint32_t	xfs_dahash_t;	/* dir/attr hash value */
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -632,7 +632,7 @@ xfs_buf_item_release(
 STATIC void
 xfs_buf_item_committing(
 	struct xfs_log_item	*lip,
-	xfs_lsn_t		commit_lsn)
+	xfs_csn_t		seq)
 {
 	return xfs_buf_item_release(lip);
 }
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -188,7 +188,7 @@ xfs_qm_dquot_logitem_release(
 STATIC void
 xfs_qm_dquot_logitem_committing(
 	struct xfs_log_item	*lip,
-	xfs_lsn_t		commit_lsn)
+	xfs_csn_t		seq)
 {
 	return xfs_qm_dquot_logitem_release(lip);
 }
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -118,8 +118,8 @@ xfs_dir_fsync(
 	return xfs_log_force_inode(ip);
 }
 
-static xfs_lsn_t
-xfs_fsync_lsn(
+static xfs_csn_t
+xfs_fsync_seq(
 	struct xfs_inode	*ip,
 	bool			datasync)
 {
@@ -127,7 +127,7 @@ xfs_fsync_lsn(
 		return 0;
 	if (datasync && !(ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
 		return 0;
-	return ip->i_itemp->ili_last_lsn;
+	return ip->i_itemp->ili_commit_seq;
 }
 
 /*
@@ -150,12 +150,12 @@ xfs_fsync_flush_log(
 	int			*log_flushed)
 {
 	int			error = 0;
-	xfs_lsn_t		lsn;
+	xfs_csn_t		seq;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	lsn = xfs_fsync_lsn(ip, datasync);
-	if (lsn) {
-		error = xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC,
+	seq = xfs_fsync_seq(ip, datasync);
+	if (seq) {
+		error = xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
 					  log_flushed);
 
 		spin_lock(&ip->i_itemp->ili_lock);
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2754,7 +2754,7 @@ xfs_iunpin(
 	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
 
 	/* Give the log a push to start the unpinning I/O */
-	xfs_log_force_lsn(ip->i_mount, ip->i_itemp->ili_last_lsn, 0, NULL);
+	xfs_log_force_seq(ip->i_mount, ip->i_itemp->ili_commit_seq, 0, NULL);
 
 }
 
@@ -3716,16 +3716,16 @@ int
 xfs_log_force_inode(
 	struct xfs_inode	*ip)
 {
-	xfs_lsn_t		lsn = 0;
+	xfs_csn_t		seq = 0;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	if (xfs_ipincount(ip))
-		lsn = ip->i_itemp->ili_last_lsn;
+		seq = ip->i_itemp->ili_commit_seq;
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
-	if (!lsn)
+	if (!seq)
 		return 0;
-	return xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC, NULL);
+	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC, NULL);
 }
 
 /*
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -617,9 +617,9 @@ xfs_inode_item_committed(
 STATIC void
 xfs_inode_item_committing(
 	struct xfs_log_item	*lip,
-	xfs_lsn_t		commit_lsn)
+	xfs_csn_t		seq)
 {
-	INODE_ITEM(lip)->ili_last_lsn = commit_lsn;
+	INODE_ITEM(lip)->ili_commit_seq = seq;
 	return xfs_inode_item_release(lip);
 }
 
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -33,7 +33,7 @@ struct xfs_inode_log_item {
 	unsigned int		ili_fields;	   /* fields to be logged */
 	unsigned int		ili_fsync_fields;  /* logged since last fsync */
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
-	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
+	xfs_csn_t		ili_commit_seq;	   /* last transaction commit */
 };
 
 static inline int xfs_inode_clean(struct xfs_inode *ip)
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3210,14 +3210,13 @@ out_error:
 }
 
 static int
-__xfs_log_force_lsn(
-	struct xfs_mount	*mp,
+xlog_force_lsn(
+	struct xlog		*log,
 	xfs_lsn_t		lsn,
 	uint			flags,
 	int			*log_flushed,
 	bool			already_slept)
 {
-	struct xlog		*log = mp->m_log;
 	struct xlog_in_core	*iclog;
 
 	spin_lock(&log->l_icloglock);
@@ -3250,8 +3249,6 @@ __xfs_log_force_lsn(
 		if (!already_slept &&
 		    (iclog->ic_prev->ic_state == XLOG_STATE_WANT_SYNC ||
 		     iclog->ic_prev->ic_state == XLOG_STATE_SYNCING)) {
-			XFS_STATS_INC(mp, xs_log_force_sleep);
-
 			xlog_wait(&iclog->ic_prev->ic_write_wait,
 					&log->l_icloglock);
 			return -EAGAIN;
@@ -3289,25 +3286,29 @@ out_error:
  * to disk, that thread will wake up all threads waiting on the queue.
  */
 int
-xfs_log_force_lsn(
+xfs_log_force_seq(
 	struct xfs_mount	*mp,
-	xfs_lsn_t		lsn,
+	xfs_csn_t		seq,
 	uint			flags,
 	int			*log_flushed)
 {
+	struct xlog		*log = mp->m_log;
+	xfs_lsn_t		lsn;
 	int			ret;
-	ASSERT(lsn != 0);
+	ASSERT(seq != 0);
 
 	XFS_STATS_INC(mp, xs_log_force);
-	trace_xfs_log_force(mp, lsn, _RET_IP_);
+	trace_xfs_log_force(mp, seq, _RET_IP_);
 
-	lsn = xlog_cil_force_lsn(mp->m_log, lsn);
+	lsn = xlog_cil_force_seq(log, seq);
 	if (lsn == NULLCOMMITLSN)
 		return 0;
 
-	ret = __xfs_log_force_lsn(mp, lsn, flags, log_flushed, false);
-	if (ret == -EAGAIN)
-		ret = __xfs_log_force_lsn(mp, lsn, flags, log_flushed, true);
+	ret = xlog_force_lsn(log, lsn, flags, log_flushed, false);
+	if (ret == -EAGAIN) {
+		XFS_STATS_INC(mp, xs_log_force_sleep);
+		ret = xlog_force_lsn(log, lsn, flags, log_flushed, true);
+	}
 	return ret;
 }
 
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -106,7 +106,7 @@ struct xfs_item_ops;
 struct xfs_trans;
 
 int	  xfs_log_force(struct xfs_mount *mp, uint flags);
-int	  xfs_log_force_lsn(struct xfs_mount *mp, xfs_lsn_t lsn, uint flags,
+int	  xfs_log_force_seq(struct xfs_mount *mp, xfs_csn_t seq, uint flags,
 		int *log_forced);
 int	  xfs_log_mount(struct xfs_mount	*mp,
 			struct xfs_buftarg	*log_target,
@@ -132,8 +132,6 @@ bool	xfs_log_writable(struct xfs_mount *
 struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
 void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
 
-void	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
-				xfs_lsn_t *commit_lsn, bool regrant);
 void	xlog_cil_process_committed(struct list_head *list);
 bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -777,7 +777,7 @@ xlog_cil_push_work(
 	 * that higher sequences will wait for us to write out a commit record
 	 * before they do.
 	 *
-	 * xfs_log_force_lsn requires us to mirror the new sequence into the cil
+	 * xfs_log_force_seq requires us to mirror the new sequence into the cil
 	 * structure atomically with the addition of this sequence to the
 	 * committing list. This also ensures that we can do unlocked checks
 	 * against the current sequence in log forces without risking
@@ -1020,16 +1020,14 @@ xlog_cil_empty(
  * allowed again.
  */
 void
-xfs_log_commit_cil(
-	struct xfs_mount	*mp,
+xlog_cil_commit(
+	struct xlog		*log,
 	struct xfs_trans	*tp,
-	xfs_lsn_t		*commit_lsn,
+	xfs_csn_t		*commit_seq,
 	bool			regrant)
 {
-	struct xlog		*log = mp->m_log;
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_log_item	*lip, *next;
-	xfs_lsn_t		xc_commit_lsn;
 
 	/*
 	 * Do all necessary memory allocation before we lock the CIL.
@@ -1043,10 +1041,6 @@ xfs_log_commit_cil(
 
 	xlog_cil_insert_items(log, tp);
 
-	xc_commit_lsn = cil->xc_ctx->sequence;
-	if (commit_lsn)
-		*commit_lsn = xc_commit_lsn;
-
 	if (regrant && !XLOG_FORCED_SHUTDOWN(log))
 		xfs_log_ticket_regrant(log, tp->t_ticket);
 	else
@@ -1069,8 +1063,10 @@ xfs_log_commit_cil(
 	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
 		xfs_trans_del_item(lip);
 		if (lip->li_ops->iop_committing)
-			lip->li_ops->iop_committing(lip, xc_commit_lsn);
+			lip->li_ops->iop_committing(lip, cil->xc_ctx->sequence);
 	}
+	if (commit_seq)
+		*commit_seq = cil->xc_ctx->sequence;
 
 	/* xlog_cil_push_background() releases cil->xc_ctx_lock */
 	xlog_cil_push_background(log);
@@ -1087,9 +1083,9 @@ xfs_log_commit_cil(
  * iclog flush is necessary following this call.
  */
 xfs_lsn_t
-xlog_cil_force_lsn(
+xlog_cil_force_seq(
 	struct xlog	*log,
-	xfs_lsn_t	sequence)
+	xfs_csn_t	sequence)
 {
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_cil_ctx	*ctx;
@@ -1185,21 +1181,17 @@ bool
 xfs_log_item_in_current_chkpt(
 	struct xfs_log_item *lip)
 {
-	struct xfs_cil_ctx *ctx;
+	struct xfs_cil_ctx *ctx = lip->li_mountp->m_log->l_cilp->xc_ctx;
 
 	if (list_empty(&lip->li_cil))
 		return false;
 
-	ctx = lip->li_mountp->m_log->l_cilp->xc_ctx;
-
 	/*
 	 * li_seq is written on the first commit of a log item to record the
 	 * first checkpoint it is written to. Hence if it is different to the
 	 * current sequence, we're in a new checkpoint.
 	 */
-	if (XFS_LSN_CMP(lip->li_seq, ctx->sequence) != 0)
-		return false;
-	return true;
+	return lip->li_seq == ctx->sequence;
 }
 
 /*
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -230,7 +230,7 @@ struct xfs_cil;
 
 struct xfs_cil_ctx {
 	struct xfs_cil		*cil;
-	xfs_lsn_t		sequence;	/* chkpt sequence # */
+	xfs_csn_t		sequence;	/* chkpt sequence # */
 	xfs_lsn_t		start_lsn;	/* first LSN of chkpt commit */
 	xfs_lsn_t		commit_lsn;	/* chkpt commit record lsn */
 	struct xlog_ticket	*ticket;	/* chkpt ticket */
@@ -268,10 +268,10 @@ struct xfs_cil {
 	struct xfs_cil_ctx	*xc_ctx;
 
 	spinlock_t		xc_push_lock ____cacheline_aligned_in_smp;
-	xfs_lsn_t		xc_push_seq;
+	xfs_csn_t		xc_push_seq;
 	struct list_head	xc_committing;
 	wait_queue_head_t	xc_commit_wait;
-	xfs_lsn_t		xc_current_sequence;
+	xfs_csn_t		xc_current_sequence;
 	struct work_struct	xc_push_work;
 	wait_queue_head_t	xc_push_wait;	/* background push throttle */
 } ____cacheline_aligned_in_smp;
@@ -547,19 +547,18 @@ int	xlog_cil_init(struct xlog *log);
 void	xlog_cil_init_post_recovery(struct xlog *log);
 void	xlog_cil_destroy(struct xlog *log);
 bool	xlog_cil_empty(struct xlog *log);
+void	xlog_cil_commit(struct xlog *log, struct xfs_trans *tp,
+			xfs_csn_t *commit_seq, bool regrant);
 
 /*
  * CIL force routines
  */
-xfs_lsn_t
-xlog_cil_force_lsn(
-	struct xlog *log,
-	xfs_lsn_t sequence);
+xfs_lsn_t xlog_cil_force_seq(struct xlog *log, xfs_csn_t sequence);
 
 static inline void
 xlog_cil_force(struct xlog *log)
 {
-	xlog_cil_force_lsn(log, log->l_cilp->xc_current_sequence);
+	xlog_cil_force_seq(log, log->l_cilp->xc_current_sequence);
 }
 
 /*
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -832,7 +832,7 @@ __xfs_trans_commit(
 	bool			regrant)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	xfs_lsn_t		commit_lsn = -1;
+	xfs_csn_t		commit_seq = 0;
 	int			error = 0;
 	int			sync = tp->t_flags & XFS_TRANS_SYNC;
 
@@ -874,7 +874,7 @@ __xfs_trans_commit(
 		xfs_trans_apply_sb_deltas(tp);
 	xfs_trans_apply_dquot_deltas(tp);
 
-	xfs_log_commit_cil(mp, tp, &commit_lsn, regrant);
+	xlog_cil_commit(mp->m_log, tp, &commit_seq, regrant);
 
 	xfs_trans_free(tp);
 
@@ -883,7 +883,7 @@ __xfs_trans_commit(
 	 * log out now and wait for it.
 	 */
 	if (sync) {
-		error = xfs_log_force_lsn(mp, commit_lsn, XFS_LOG_SYNC, NULL);
+		error = xfs_log_force_seq(mp, commit_seq, XFS_LOG_SYNC, NULL);
 		XFS_STATS_INC(mp, xs_trans_sync);
 	} else {
 		XFS_STATS_INC(mp, xs_trans_async);
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -43,7 +43,7 @@ struct xfs_log_item {
 	struct list_head		li_cil;		/* CIL pointers */
 	struct xfs_log_vec		*li_lv;		/* active log vector */
 	struct xfs_log_vec		*li_lv_shadow;	/* standby vector */
-	xfs_lsn_t			li_seq;		/* CIL commit seq */
+	xfs_csn_t			li_seq;		/* CIL commit seq */
 };
 
 /*
@@ -69,7 +69,7 @@ struct xfs_item_ops {
 	void (*iop_pin)(struct xfs_log_item *);
 	void (*iop_unpin)(struct xfs_log_item *, int remove);
 	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
-	void (*iop_committing)(struct xfs_log_item *, xfs_lsn_t commit_lsn);
+	void (*iop_committing)(struct xfs_log_item *lip, xfs_csn_t seq);
 	void (*iop_release)(struct xfs_log_item *);
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
 	int (*iop_recover)(struct xfs_log_item *lip,


