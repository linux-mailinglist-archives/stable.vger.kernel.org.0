Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E1B60FEC6
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237008AbiJ0RIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237049AbiJ0RIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:08:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AA91A16F1
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:08:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B11CAB824DB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E79C433D6;
        Thu, 27 Oct 2022 17:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890495;
        bh=lBabu0UTUXZV7POlqh99kJ+4NibutfIaeTBQ74dhJX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivYFpXelUCn0bx3Qo5o1zxnLddOQQxT3TIoA9xbuX08/cdTzAW+nXxjl9c26Q9kS0
         jXBXLXMCcybq8SUFrxmfezu3CIceDo3e27AJLuwFbd8d/TeTJnrJJP4l/QpHZhNSwE
         ddvjasUycrhOagdTpOai9mZOikc6LRjL63SLssKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Reichl <preichl@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 13/53] xfs: Replace function declaration by actual definition
Date:   Thu, 27 Oct 2022 18:56:01 +0200
Message-Id: <20221027165050.313816654@linuxfoundation.org>
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

commit 1cc95e6f0d7cfd61c9d3c5cdd4e7345b173f764f upstream.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: fix typo in subject line]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_qm_syscalls.c |  140 ++++++++++++++++++++++-------------------------
 1 file changed, 66 insertions(+), 74 deletions(-)

--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -19,12 +19,72 @@
 #include "xfs_qm.h"
 #include "xfs_icache.h"
 
-STATIC int xfs_qm_log_quotaoff(struct xfs_mount *mp,
-					struct xfs_qoff_logitem **qoffstartp,
-					uint flags);
-STATIC int xfs_qm_log_quotaoff_end(struct xfs_mount *mp,
-					struct xfs_qoff_logitem *startqoff,
-					uint flags);
+STATIC int
+xfs_qm_log_quotaoff(
+	struct xfs_mount	*mp,
+	struct xfs_qoff_logitem	**qoffstartp,
+	uint			flags)
+{
+	struct xfs_trans	*tp;
+	int			error;
+	struct xfs_qoff_logitem	*qoffi;
+
+	*qoffstartp = NULL;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
+	if (error)
+		goto out;
+
+	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
+	xfs_trans_log_quotaoff_item(tp, qoffi);
+
+	spin_lock(&mp->m_sb_lock);
+	mp->m_sb.sb_qflags = (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
+	spin_unlock(&mp->m_sb_lock);
+
+	xfs_log_sb(tp);
+
+	/*
+	 * We have to make sure that the transaction is secure on disk before we
+	 * return and actually stop quota accounting. So, make it synchronous.
+	 * We don't care about quotoff's performance.
+	 */
+	xfs_trans_set_sync(tp);
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out;
+
+	*qoffstartp = qoffi;
+out:
+	return error;
+}
+
+STATIC int
+xfs_qm_log_quotaoff_end(
+	struct xfs_mount	*mp,
+	struct xfs_qoff_logitem	*startqoff,
+	uint			flags)
+{
+	struct xfs_trans	*tp;
+	int			error;
+	struct xfs_qoff_logitem	*qoffi;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
+	qoffi = xfs_trans_get_qoff_item(tp, startqoff,
+					flags & XFS_ALL_QUOTA_ACCT);
+	xfs_trans_log_quotaoff_item(tp, qoffi);
+
+	/*
+	 * We have to make sure that the transaction is secure on disk before we
+	 * return and actually stop quota accounting. So, make it synchronous.
+	 * We don't care about quotoff's performance.
+	 */
+	xfs_trans_set_sync(tp);
+	return xfs_trans_commit(tp);
+}
 
 /*
  * Turn off quota accounting and/or enforcement for all udquots and/or
@@ -541,74 +601,6 @@ out_unlock:
 	return error;
 }
 
-STATIC int
-xfs_qm_log_quotaoff_end(
-	struct xfs_mount	*mp,
-	struct xfs_qoff_logitem	*startqoff,
-	uint			flags)
-{
-	struct xfs_trans	*tp;
-	int			error;
-	struct xfs_qoff_logitem	*qoffi;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
-	if (error)
-		return error;
-
-	qoffi = xfs_trans_get_qoff_item(tp, startqoff,
-					flags & XFS_ALL_QUOTA_ACCT);
-	xfs_trans_log_quotaoff_item(tp, qoffi);
-
-	/*
-	 * We have to make sure that the transaction is secure on disk before we
-	 * return and actually stop quota accounting. So, make it synchronous.
-	 * We don't care about quotoff's performance.
-	 */
-	xfs_trans_set_sync(tp);
-	return xfs_trans_commit(tp);
-}
-
-
-STATIC int
-xfs_qm_log_quotaoff(
-	struct xfs_mount	*mp,
-	struct xfs_qoff_logitem	**qoffstartp,
-	uint			flags)
-{
-	struct xfs_trans	*tp;
-	int			error;
-	struct xfs_qoff_logitem	*qoffi;
-
-	*qoffstartp = NULL;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
-	if (error)
-		goto out;
-
-	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
-	xfs_trans_log_quotaoff_item(tp, qoffi);
-
-	spin_lock(&mp->m_sb_lock);
-	mp->m_sb.sb_qflags = (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
-	spin_unlock(&mp->m_sb_lock);
-
-	xfs_log_sb(tp);
-
-	/*
-	 * We have to make sure that the transaction is secure on disk before we
-	 * return and actually stop quota accounting. So, make it synchronous.
-	 * We don't care about quotoff's performance.
-	 */
-	xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp);
-	if (error)
-		goto out;
-
-	*qoffstartp = qoffi;
-out:
-	return error;
-}
-
 /* Fill out the quota context. */
 static void
 xfs_qm_scall_getquota_fill_qc(


