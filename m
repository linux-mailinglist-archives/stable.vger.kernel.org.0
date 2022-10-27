Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429CC60FEC3
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbiJ0RIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237047AbiJ0RIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:08:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903471A0453
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:08:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EF91610AB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECEAC433D6;
        Thu, 27 Oct 2022 17:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890487;
        bh=Nlot8naSzvuQrWHDMa8PqegMiZWOX11WbyzuL40XVbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wi2VP2sI1ZQaJy3ss2QaycQTCmixHUUgmIhpV7quAqqz3lBLyrS4cD+pylzJJ9mz3
         nnW3gHPyDHXnbULniWkkrx0VK8P/ZIDmaYAre3uMLahjBNXMSH7zM/f24sd+pxcV5V
         LR9P+esg62Y9TynK+DXnlupCdIeOlBRIkiwICaAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Reichl <preichl@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 10/53] xfs: remove the xfs_disk_dquot_t and xfs_dquot_t
Date:   Thu, 27 Oct 2022 18:55:58 +0200
Message-Id: <20221027165050.210922639@linuxfoundation.org>
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

From: Pavel Reichl <preichl@redhat.com>

commit aefe69a45d84901c702f87672ec1e93de1d03f73 upstream.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: fix some of the comments]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |    8 +--
 fs/xfs/libxfs/xfs_format.h     |   10 ++--
 fs/xfs/libxfs/xfs_trans_resv.c |    2 
 fs/xfs/xfs_dquot.c             |   18 +++----
 fs/xfs/xfs_dquot.h             |   98 ++++++++++++++++++++---------------------
 fs/xfs/xfs_log_recover.c       |    5 +-
 fs/xfs/xfs_qm.c                |   30 ++++++------
 fs/xfs/xfs_qm_bhv.c            |    6 +-
 fs/xfs/xfs_trans_dquot.c       |   44 +++++++++---------
 9 files changed, 112 insertions(+), 109 deletions(-)

--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -35,10 +35,10 @@ xfs_calc_dquots_per_chunk(
 
 xfs_failaddr_t
 xfs_dquot_verify(
-	struct xfs_mount *mp,
-	xfs_disk_dquot_t *ddq,
-	xfs_dqid_t	 id,
-	uint		 type)	  /* used only during quotacheck */
+	struct xfs_mount	*mp,
+	struct xfs_disk_dquot	*ddq,
+	xfs_dqid_t		id,
+	uint			type)	/* used only during quotacheck */
 {
 	/*
 	 * We can encounter an uninitialized dquot buffer for 2 reasons:
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1144,11 +1144,11 @@ static inline void xfs_dinode_put_rdev(s
 
 /*
  * This is the main portion of the on-disk representation of quota
- * information for a user. This is the q_core of the xfs_dquot_t that
+ * information for a user. This is the q_core of the struct xfs_dquot that
  * is kept in kernel memory. We pad this with some more expansion room
  * to construct the on disk structure.
  */
-typedef struct	xfs_disk_dquot {
+struct xfs_disk_dquot {
 	__be16		d_magic;	/* dquot magic = XFS_DQUOT_MAGIC */
 	__u8		d_version;	/* dquot version */
 	__u8		d_flags;	/* XFS_DQ_USER/PROJ/GROUP */
@@ -1171,15 +1171,15 @@ typedef struct	xfs_disk_dquot {
 	__be32		d_rtbtimer;	/* similar to above; for RT disk blocks */
 	__be16		d_rtbwarns;	/* warnings issued wrt RT disk blocks */
 	__be16		d_pad;
-} xfs_disk_dquot_t;
+};
 
 /*
  * This is what goes on disk. This is separated from the xfs_disk_dquot because
  * carrying the unnecessary padding would be a waste of memory.
  */
 typedef struct xfs_dqblk {
-	xfs_disk_dquot_t  dd_diskdq;	/* portion that lives incore as well */
-	char		  dd_fill[4];	/* filling for posterity */
+	struct xfs_disk_dquot	dd_diskdq; /* portion living incore as well */
+	char			dd_fill[4];/* filling for posterity */
 
 	/*
 	 * These two are only present on filesystems with the CRC bits set.
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -776,7 +776,7 @@ xfs_calc_clear_agi_bucket_reservation(
 
 /*
  * Adjusting quota limits.
- *    the xfs_disk_dquot_t: sizeof(struct xfs_disk_dquot)
+ *    the disk quota buffer: sizeof(struct xfs_disk_dquot)
  */
 STATIC uint
 xfs_calc_qm_setqlim_reservation(void)
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -48,7 +48,7 @@ static struct lock_class_key xfs_dquot_p
  */
 void
 xfs_qm_dqdestroy(
-	xfs_dquot_t	*dqp)
+	struct xfs_dquot	*dqp)
 {
 	ASSERT(list_empty(&dqp->q_lru));
 
@@ -113,8 +113,8 @@ xfs_qm_adjust_dqlimits(
  */
 void
 xfs_qm_adjust_dqtimers(
-	xfs_mount_t		*mp,
-	xfs_disk_dquot_t	*d)
+	struct xfs_mount	*mp,
+	struct xfs_disk_dquot	*d)
 {
 	ASSERT(d->d_id);
 
@@ -497,7 +497,7 @@ xfs_dquot_from_disk(
 	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
 
 	/* copy everything from disk dquot to the incore dquot */
-	memcpy(&dqp->q_core, ddqp, sizeof(xfs_disk_dquot_t));
+	memcpy(&dqp->q_core, ddqp, sizeof(struct xfs_disk_dquot));
 
 	/*
 	 * Reservation counters are defined as reservation plus current usage
@@ -989,7 +989,7 @@ xfs_qm_dqput(
  */
 void
 xfs_qm_dqrele(
-	xfs_dquot_t	*dqp)
+	struct xfs_dquot	*dqp)
 {
 	if (!dqp)
 		return;
@@ -1019,7 +1019,7 @@ xfs_qm_dqflush_done(
 	struct xfs_log_item	*lip)
 {
 	xfs_dq_logitem_t	*qip = (struct xfs_dq_logitem *)lip;
-	xfs_dquot_t		*dqp = qip->qli_dquot;
+	struct xfs_dquot	*dqp = qip->qli_dquot;
 	struct xfs_ail		*ailp = lip->li_ailp;
 
 	/*
@@ -1129,7 +1129,7 @@ xfs_qm_dqflush(
 	}
 
 	/* This is the only portion of data that needs to persist */
-	memcpy(ddqp, &dqp->q_core, sizeof(xfs_disk_dquot_t));
+	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
 
 	/*
 	 * Clear the dirty field and remember the flush lsn for later use.
@@ -1187,8 +1187,8 @@ out_unlock:
  */
 void
 xfs_dqlock2(
-	xfs_dquot_t	*d1,
-	xfs_dquot_t	*d2)
+	struct xfs_dquot	*d1,
+	struct xfs_dquot	*d2)
 {
 	if (d1 && d2) {
 		ASSERT(d1 != d2);
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -30,33 +30,36 @@ enum {
 /*
  * The incore dquot structure
  */
-typedef struct xfs_dquot {
-	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
-	struct list_head q_lru;		/* global free list of dquots */
-	struct xfs_mount*q_mount;	/* filesystem this relates to */
-	uint		 q_nrefs;	/* # active refs from inodes */
-	xfs_daddr_t	 q_blkno;	/* blkno of dquot buffer */
-	int		 q_bufoffset;	/* off of dq in buffer (# dquots) */
-	xfs_fileoff_t	 q_fileoffset;	/* offset in quotas file */
-
-	xfs_disk_dquot_t q_core;	/* actual usage & quotas */
-	xfs_dq_logitem_t q_logitem;	/* dquot log item */
-	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
-	xfs_qcnt_t	 q_res_icount;	/* total inos allocd+reserved */
-	xfs_qcnt_t	 q_res_rtbcount;/* total realtime blks used+reserved */
-	xfs_qcnt_t	 q_prealloc_lo_wmark;/* prealloc throttle wmark */
-	xfs_qcnt_t	 q_prealloc_hi_wmark;/* prealloc disabled wmark */
-	int64_t		 q_low_space[XFS_QLOWSP_MAX];
-	struct mutex	 q_qlock;	/* quota lock */
-	struct completion q_flush;	/* flush completion queue */
-	atomic_t          q_pincount;	/* dquot pin count */
-	wait_queue_head_t q_pinwait;	/* dquot pinning wait queue */
-} xfs_dquot_t;
+struct xfs_dquot {
+	uint			dq_flags;
+	struct list_head	q_lru;
+	struct xfs_mount	*q_mount;
+	uint			q_nrefs;
+	xfs_daddr_t		q_blkno;
+	int			q_bufoffset;
+	xfs_fileoff_t		q_fileoffset;
+
+	struct xfs_disk_dquot	q_core;
+	xfs_dq_logitem_t	q_logitem;
+	/* total regular nblks used+reserved */
+	xfs_qcnt_t		q_res_bcount;
+	/* total inos allocd+reserved */
+	xfs_qcnt_t		q_res_icount;
+	/* total realtime blks used+reserved */
+	xfs_qcnt_t		q_res_rtbcount;
+	xfs_qcnt_t		q_prealloc_lo_wmark;
+	xfs_qcnt_t		q_prealloc_hi_wmark;
+	int64_t			q_low_space[XFS_QLOWSP_MAX];
+	struct mutex		q_qlock;
+	struct completion	q_flush;
+	atomic_t		q_pincount;
+	struct wait_queue_head	q_pinwait;
+};
 
 /*
  * Lock hierarchy for q_qlock:
  *	XFS_QLOCK_NORMAL is the implicit default,
- * 	XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
+ *	XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
  */
 enum {
 	XFS_QLOCK_NORMAL = 0,
@@ -64,21 +67,21 @@ enum {
 };
 
 /*
- * Manage the q_flush completion queue embedded in the dquot.  This completion
+ * Manage the q_flush completion queue embedded in the dquot. This completion
  * queue synchronizes processes attempting to flush the in-core dquot back to
  * disk.
  */
-static inline void xfs_dqflock(xfs_dquot_t *dqp)
+static inline void xfs_dqflock(struct xfs_dquot *dqp)
 {
 	wait_for_completion(&dqp->q_flush);
 }
 
-static inline bool xfs_dqflock_nowait(xfs_dquot_t *dqp)
+static inline bool xfs_dqflock_nowait(struct xfs_dquot *dqp)
 {
 	return try_wait_for_completion(&dqp->q_flush);
 }
 
-static inline void xfs_dqfunlock(xfs_dquot_t *dqp)
+static inline void xfs_dqfunlock(struct xfs_dquot *dqp)
 {
 	complete(&dqp->q_flush);
 }
@@ -112,7 +115,7 @@ static inline int xfs_this_quota_on(stru
 	}
 }
 
-static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
+static inline struct xfs_dquot *xfs_inode_dquot(struct xfs_inode *ip, int type)
 {
 	switch (type & XFS_DQ_ALLTYPES) {
 	case XFS_DQ_USER:
@@ -147,31 +150,30 @@ static inline bool xfs_dquot_lowsp(struc
 #define XFS_QM_ISPDQ(dqp)	((dqp)->dq_flags & XFS_DQ_PROJ)
 #define XFS_QM_ISGDQ(dqp)	((dqp)->dq_flags & XFS_DQ_GROUP)
 
-extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
-extern int		xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
-extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
-extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
-					xfs_disk_dquot_t *);
-extern void		xfs_qm_adjust_dqlimits(struct xfs_mount *,
-					       struct xfs_dquot *);
-extern xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
-					uint type);
-extern int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
+void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
+int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf **bpp);
+void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
+void		xfs_qm_adjust_dqtimers(struct xfs_mount *mp,
+						struct xfs_disk_dquot *d);
+void		xfs_qm_adjust_dqlimits(struct xfs_mount *mp,
+						struct xfs_dquot *d);
+xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip, uint type);
+int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
 					uint type, bool can_alloc,
 					struct xfs_dquot **dqpp);
-extern int		xfs_qm_dqget_inode(struct xfs_inode *ip, uint type,
-					bool can_alloc,
-					struct xfs_dquot **dqpp);
-extern int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
+int		xfs_qm_dqget_inode(struct xfs_inode *ip, uint type,
+						bool can_alloc,
+						struct xfs_dquot **dqpp);
+int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
 					uint type, struct xfs_dquot **dqpp);
-extern int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
-					xfs_dqid_t id, uint type,
-					struct xfs_dquot **dqpp);
-extern void		xfs_qm_dqput(xfs_dquot_t *);
+int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
+						xfs_dqid_t id, uint type,
+						struct xfs_dquot **dqpp);
+void		xfs_qm_dqput(struct xfs_dquot *dqp);
 
-extern void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
+void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
 
-extern void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
+void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
 
 static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 {
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2577,6 +2577,7 @@ xlog_recover_do_reg_buffer(
 	int			bit;
 	int			nbits;
 	xfs_failaddr_t		fa;
+	const size_t		size_disk_dquot = sizeof(struct xfs_disk_dquot);
 
 	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
 
@@ -2619,7 +2620,7 @@ xlog_recover_do_reg_buffer(
 					"XFS: NULL dquot in %s.", __func__);
 				goto next;
 			}
-			if (item->ri_buf[i].i_len < sizeof(xfs_disk_dquot_t)) {
+			if (item->ri_buf[i].i_len < size_disk_dquot) {
 				xfs_alert(mp,
 					"XFS: dquot too small (%d) in %s.",
 					item->ri_buf[i].i_len, __func__);
@@ -3250,7 +3251,7 @@ xlog_recover_dquot_pass2(
 		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
 		return -EFSCORRUPTED;
 	}
-	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t)) {
+	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot)) {
 		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
 			item->ri_buf[1].i_len, __func__);
 		return -EFSCORRUPTED;
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -244,14 +244,14 @@ xfs_qm_unmount_quotas(
 
 STATIC int
 xfs_qm_dqattach_one(
-	xfs_inode_t	*ip,
-	xfs_dqid_t	id,
-	uint		type,
-	bool		doalloc,
-	xfs_dquot_t	**IO_idqpp)
+	struct xfs_inode	*ip,
+	xfs_dqid_t		id,
+	uint			type,
+	bool			doalloc,
+	struct xfs_dquot	**IO_idqpp)
 {
-	xfs_dquot_t	*dqp;
-	int		error;
+	struct xfs_dquot	*dqp;
+	int			error;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	error = 0;
@@ -544,8 +544,8 @@ xfs_qm_set_defquota(
 	uint		type,
 	xfs_quotainfo_t	*qinf)
 {
-	xfs_dquot_t		*dqp;
-	struct xfs_def_quota    *defq;
+	struct xfs_dquot	*dqp;
+	struct xfs_def_quota	*defq;
 	struct xfs_disk_dquot	*ddqp;
 	int			error;
 
@@ -1746,14 +1746,14 @@ error_rele:
  * Actually transfer ownership, and do dquot modifications.
  * These were already reserved.
  */
-xfs_dquot_t *
+struct xfs_dquot *
 xfs_qm_vop_chown(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip,
-	xfs_dquot_t	**IO_olddq,
-	xfs_dquot_t	*newdq)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_dquot	**IO_olddq,
+	struct xfs_dquot	*newdq)
 {
-	xfs_dquot_t	*prevdq;
+	struct xfs_dquot	*prevdq;
 	uint		bfield = XFS_IS_REALTIME_INODE(ip) ?
 				 XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
 
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -54,11 +54,11 @@ xfs_fill_statvfs_from_dquot(
  */
 void
 xfs_qm_statvfs(
-	xfs_inode_t		*ip,
+	struct xfs_inode	*ip,
 	struct kstatfs		*statp)
 {
-	xfs_mount_t		*mp = ip->i_mount;
-	xfs_dquot_t		*dqp;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_dquot	*dqp;
 
 	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, false, &dqp)) {
 		xfs_fill_statvfs_from_dquot(statp, dqp);
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -25,8 +25,8 @@ STATIC void	xfs_trans_alloc_dqinfo(xfs_t
  */
 void
 xfs_trans_dqjoin(
-	xfs_trans_t	*tp,
-	xfs_dquot_t	*dqp)
+	struct xfs_trans	*tp,
+	struct xfs_dquot	*dqp)
 {
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 	ASSERT(dqp->q_logitem.qli_dquot == dqp);
@@ -49,8 +49,8 @@ xfs_trans_dqjoin(
  */
 void
 xfs_trans_log_dquot(
-	xfs_trans_t	*tp,
-	xfs_dquot_t	*dqp)
+	struct xfs_trans	*tp,
+	struct xfs_dquot	*dqp)
 {
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
@@ -486,12 +486,12 @@ xfs_trans_apply_dquot_deltas(
  */
 void
 xfs_trans_unreserve_and_mod_dquots(
-	xfs_trans_t		*tp)
+	struct xfs_trans	*tp)
 {
 	int			i, j;
-	xfs_dquot_t		*dqp;
+	struct xfs_dquot	*dqp;
 	struct xfs_dqtrx	*qtrx, *qa;
-	bool                    locked;
+	bool			locked;
 
 	if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
 		return;
@@ -571,21 +571,21 @@ xfs_quota_warn(
  */
 STATIC int
 xfs_trans_dqresv(
-	xfs_trans_t	*tp,
-	xfs_mount_t	*mp,
-	xfs_dquot_t	*dqp,
-	int64_t		nblks,
-	long		ninos,
-	uint		flags)
-{
-	xfs_qcnt_t	hardlimit;
-	xfs_qcnt_t	softlimit;
-	time_t		timer;
-	xfs_qwarncnt_t	warns;
-	xfs_qwarncnt_t	warnlimit;
-	xfs_qcnt_t	total_count;
-	xfs_qcnt_t	*resbcountp;
-	xfs_quotainfo_t	*q = mp->m_quotainfo;
+	struct xfs_trans	*tp,
+	struct xfs_mount	*mp,
+	struct xfs_dquot	*dqp,
+	int64_t			nblks,
+	long			ninos,
+	uint			flags)
+{
+	xfs_qcnt_t		hardlimit;
+	xfs_qcnt_t		softlimit;
+	time_t			timer;
+	xfs_qwarncnt_t		warns;
+	xfs_qwarncnt_t		warnlimit;
+	xfs_qcnt_t		total_count;
+	xfs_qcnt_t		*resbcountp;
+	xfs_quotainfo_t		*q = mp->m_quotainfo;
 	struct xfs_def_quota	*defq;
 
 


