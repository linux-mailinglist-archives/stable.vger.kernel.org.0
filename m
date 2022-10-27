Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0B860FEC5
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbiJ0RIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237008AbiJ0RIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:08:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7145B19DDAD
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:08:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2940DB825F3
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766D1C433D6;
        Thu, 27 Oct 2022 17:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890492;
        bh=VMBeEHSatxdLoyFgvxFNMBjhacFQCa+69pmgWbOiiD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MIY7tyMaZuMeOZ2Onzy6Bo++Kg9c8JvfmBwOwrBQAfTLlGjxCxjrSq9rYORiErljX
         k4b6yL1UvuQE2UoZcvX455AjaUofAF5jumnZ0YlKe2O7gBE18D8S58+aGHDlCgtZSp
         /7eQMbxHNAABTzmLAix5c4uNLbcXSxTTyJKfh1Cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Reichl <preichl@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 12/53] xfs: remove the xfs_qoff_logitem_t typedef
Date:   Thu, 27 Oct 2022 18:56:00 +0200
Message-Id: <20221027165050.282194393@linuxfoundation.org>
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

commit d0bdfb106907e4a3ef4f25f6d27e392abf41f3a0 upstream.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: fix a comment]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_trans_resv.c |    4 ++--
 fs/xfs/xfs_dquot_item.h        |   28 +++++++++++++++-------------
 fs/xfs/xfs_qm_syscalls.c       |   29 ++++++++++++++++-------------
 fs/xfs/xfs_trans_dquot.c       |   12 ++++++------
 4 files changed, 39 insertions(+), 34 deletions(-)

--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -800,7 +800,7 @@ xfs_calc_qm_dqalloc_reservation(
 
 /*
  * Turning off quotas.
- *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
+ *    the quota off logitems: sizeof(struct xfs_qoff_logitem) * 2
  *    the superblock for the quota flags: sector size
  */
 STATIC uint
@@ -813,7 +813,7 @@ xfs_calc_qm_quotaoff_reservation(
 
 /*
  * End of turning off quotas.
- *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
+ *    the quota off logitems: sizeof(struct xfs_qoff_logitem) * 2
  */
 STATIC uint
 xfs_calc_qm_quotaoff_end_reservation(void)
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -12,24 +12,26 @@ struct xfs_mount;
 struct xfs_qoff_logitem;
 
 struct xfs_dq_logitem {
-	struct xfs_log_item	 qli_item;	/* common portion */
+	struct xfs_log_item	qli_item;	/* common portion */
 	struct xfs_dquot	*qli_dquot;	/* dquot ptr */
-	xfs_lsn_t		 qli_flush_lsn;	/* lsn at last flush */
+	xfs_lsn_t		qli_flush_lsn;	/* lsn at last flush */
 };
 
-typedef struct xfs_qoff_logitem {
-	struct xfs_log_item	 qql_item;	/* common portion */
-	struct xfs_qoff_logitem *qql_start_lip; /* qoff-start logitem, if any */
+struct xfs_qoff_logitem {
+	struct xfs_log_item	qql_item;	/* common portion */
+	struct xfs_qoff_logitem *qql_start_lip;	/* qoff-start logitem, if any */
 	unsigned int		qql_flags;
-} xfs_qoff_logitem_t;
+};
 
 
-extern void		   xfs_qm_dquot_logitem_init(struct xfs_dquot *);
-extern xfs_qoff_logitem_t *xfs_qm_qoff_logitem_init(struct xfs_mount *,
-					struct xfs_qoff_logitem *, uint);
-extern xfs_qoff_logitem_t *xfs_trans_get_qoff_item(struct xfs_trans *,
-					struct xfs_qoff_logitem *, uint);
-extern void		   xfs_trans_log_quotaoff_item(struct xfs_trans *,
-					struct xfs_qoff_logitem *);
+void xfs_qm_dquot_logitem_init(struct xfs_dquot *dqp);
+struct xfs_qoff_logitem	*xfs_qm_qoff_logitem_init(struct xfs_mount *mp,
+		struct xfs_qoff_logitem *start,
+		uint flags);
+struct xfs_qoff_logitem	*xfs_trans_get_qoff_item(struct xfs_trans *tp,
+		struct xfs_qoff_logitem *startqoff,
+		uint flags);
+void xfs_trans_log_quotaoff_item(struct xfs_trans *tp,
+		struct xfs_qoff_logitem *qlp);
 
 #endif	/* __XFS_DQUOT_ITEM_H__ */
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -19,9 +19,12 @@
 #include "xfs_qm.h"
 #include "xfs_icache.h"
 
-STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
-STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
-					uint);
+STATIC int xfs_qm_log_quotaoff(struct xfs_mount *mp,
+					struct xfs_qoff_logitem **qoffstartp,
+					uint flags);
+STATIC int xfs_qm_log_quotaoff_end(struct xfs_mount *mp,
+					struct xfs_qoff_logitem *startqoff,
+					uint flags);
 
 /*
  * Turn off quota accounting and/or enforcement for all udquots and/or
@@ -40,7 +43,7 @@ xfs_qm_scall_quotaoff(
 	uint			dqtype;
 	int			error;
 	uint			inactivate_flags;
-	xfs_qoff_logitem_t	*qoffstart;
+	struct xfs_qoff_logitem	*qoffstart;
 
 	/*
 	 * No file system can have quotas enabled on disk but not in core.
@@ -540,13 +543,13 @@ out_unlock:
 
 STATIC int
 xfs_qm_log_quotaoff_end(
-	xfs_mount_t		*mp,
-	xfs_qoff_logitem_t	*startqoff,
+	struct xfs_mount	*mp,
+	struct xfs_qoff_logitem	*startqoff,
 	uint			flags)
 {
-	xfs_trans_t		*tp;
+	struct xfs_trans	*tp;
 	int			error;
-	xfs_qoff_logitem_t	*qoffi;
+	struct xfs_qoff_logitem	*qoffi;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
 	if (error)
@@ -568,13 +571,13 @@ xfs_qm_log_quotaoff_end(
 
 STATIC int
 xfs_qm_log_quotaoff(
-	xfs_mount_t	       *mp,
-	xfs_qoff_logitem_t     **qoffstartp,
-	uint		       flags)
+	struct xfs_mount	*mp,
+	struct xfs_qoff_logitem	**qoffstartp,
+	uint			flags)
 {
-	xfs_trans_t	       *tp;
+	struct xfs_trans	*tp;
 	int			error;
-	xfs_qoff_logitem_t     *qoffi;
+	struct xfs_qoff_logitem	*qoffi;
 
 	*qoffstartp = NULL;
 
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -824,13 +824,13 @@ xfs_trans_reserve_quota_nblks(
 /*
  * This routine is called to allocate a quotaoff log item.
  */
-xfs_qoff_logitem_t *
+struct xfs_qoff_logitem *
 xfs_trans_get_qoff_item(
-	xfs_trans_t		*tp,
-	xfs_qoff_logitem_t	*startqoff,
+	struct xfs_trans	*tp,
+	struct xfs_qoff_logitem	*startqoff,
 	uint			flags)
 {
-	xfs_qoff_logitem_t	*q;
+	struct xfs_qoff_logitem	*q;
 
 	ASSERT(tp != NULL);
 
@@ -852,8 +852,8 @@ xfs_trans_get_qoff_item(
  */
 void
 xfs_trans_log_quotaoff_item(
-	xfs_trans_t		*tp,
-	xfs_qoff_logitem_t	*qlp)
+	struct xfs_trans	*tp,
+	struct xfs_qoff_logitem	*qlp)
 {
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &qlp->qql_item.li_flags);


