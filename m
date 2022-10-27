Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4AB760FEC8
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236948AbiJ0RI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237043AbiJ0RIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:08:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37ACF19C06E
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:08:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8583B82641
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B27AC433D7;
        Thu, 27 Oct 2022 17:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890500;
        bh=4fJUDvK2/jYq+QBvoV8tC+bOXOlKWyyjHZt9dn9AsOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3thEx+tmDJ50x+3SCVPfUyCDO13YtQnYSi64SEDCY5jsRz43kZNaPPOyNWDxkT7t
         fRQnJ8a/+UbrInQgciNPR9+h9GWDbOBLDTbGlWI56YOpz411dQFKNhyV3zx9b88jUm
         MNrvOAtQUa8eOZQMtBCudKjMaRgSY8NnIdWKFlZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 15/53] xfs: fix unmount hang and memory leak on shutdown during quotaoff
Date:   Thu, 27 Oct 2022 18:56:03 +0200
Message-Id: <20221027165050.397911804@linuxfoundation.org>
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

From: Brian Foster <bfoster@redhat.com>

commit 8a62714313391b9b2297d67c341b35edbf46c279 upstream.

AIL removal of the quotaoff start intent and free of both quotaoff
intents is currently limited to the ->iop_committed() handler of the
end intent. This executes when the end intent is committed to the
on-disk log and marks the completion of the operation. The problem
with this is it assumes the success of the operation. If a shutdown
or other error occurs during the quotaoff, it's possible for the
quotaoff task to exit without removing the start intent from the
AIL. This results in an unmount hang as the AIL cannot be emptied.
Further, no other codepath frees the intents and so this is also a
memory leak vector.

First, update the high level quotaoff error path to directly remove
and free the quotaoff start intent if it still exists in the AIL at
the time of the error. Next, update both of the start and end
quotaoff intents with an ->iop_release() callback to properly handle
transaction abort.

This means that If the quotaoff start transaction aborts, it frees
the start intent in the transaction commit path. If the filesystem
shuts down before the end transaction allocates, the quotaoff
sequence removes and frees the start intent. If the end transaction
aborts, it removes the start intent and frees both. This ensures
that a shutdown does not result in a hung unmount and that memory is
not leaked regardless of when a quotaoff error occurs.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot_item.c  |   15 +++++++++++++++
 fs/xfs/xfs_qm_syscalls.c |   13 +++++++------
 2 files changed, 22 insertions(+), 6 deletions(-)

--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -315,17 +315,32 @@ xfs_qm_qoffend_logitem_committed(
 	return (xfs_lsn_t)-1;
 }
 
+STATIC void
+xfs_qm_qoff_logitem_release(
+	struct xfs_log_item	*lip)
+{
+	struct xfs_qoff_logitem	*qoff = QOFF_ITEM(lip);
+
+	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
+		if (qoff->qql_start_lip)
+			xfs_qm_qoff_logitem_relse(qoff->qql_start_lip);
+		xfs_qm_qoff_logitem_relse(qoff);
+	}
+}
+
 static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
 	.iop_size	= xfs_qm_qoff_logitem_size,
 	.iop_format	= xfs_qm_qoff_logitem_format,
 	.iop_committed	= xfs_qm_qoffend_logitem_committed,
 	.iop_push	= xfs_qm_qoff_logitem_push,
+	.iop_release	= xfs_qm_qoff_logitem_release,
 };
 
 static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
 	.iop_size	= xfs_qm_qoff_logitem_size,
 	.iop_format	= xfs_qm_qoff_logitem_format,
 	.iop_push	= xfs_qm_qoff_logitem_push,
+	.iop_release	= xfs_qm_qoff_logitem_release,
 };
 
 /*
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -29,8 +29,6 @@ xfs_qm_log_quotaoff(
 	int			error;
 	struct xfs_qoff_logitem	*qoffi;
 
-	*qoffstartp = NULL;
-
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
 	if (error)
 		goto out;
@@ -62,7 +60,7 @@ out:
 STATIC int
 xfs_qm_log_quotaoff_end(
 	struct xfs_mount	*mp,
-	struct xfs_qoff_logitem	*startqoff,
+	struct xfs_qoff_logitem	**startqoff,
 	uint			flags)
 {
 	struct xfs_trans	*tp;
@@ -73,9 +71,10 @@ xfs_qm_log_quotaoff_end(
 	if (error)
 		return error;
 
-	qoffi = xfs_trans_get_qoff_item(tp, startqoff,
+	qoffi = xfs_trans_get_qoff_item(tp, *startqoff,
 					flags & XFS_ALL_QUOTA_ACCT);
 	xfs_trans_log_quotaoff_item(tp, qoffi);
+	*startqoff = NULL;
 
 	/*
 	 * We have to make sure that the transaction is secure on disk before we
@@ -103,7 +102,7 @@ xfs_qm_scall_quotaoff(
 	uint			dqtype;
 	int			error;
 	uint			inactivate_flags;
-	struct xfs_qoff_logitem	*qoffstart;
+	struct xfs_qoff_logitem	*qoffstart = NULL;
 
 	/*
 	 * No file system can have quotas enabled on disk but not in core.
@@ -228,7 +227,7 @@ xfs_qm_scall_quotaoff(
 	 * So, we have QUOTAOFF start and end logitems; the start
 	 * logitem won't get overwritten until the end logitem appears...
 	 */
-	error = xfs_qm_log_quotaoff_end(mp, qoffstart, flags);
+	error = xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
 	if (error) {
 		/* We're screwed now. Shutdown is the only option. */
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
@@ -261,6 +260,8 @@ xfs_qm_scall_quotaoff(
 	}
 
 out_unlock:
+	if (error && qoffstart)
+		xfs_qm_qoff_logitem_relse(qoffstart);
 	mutex_unlock(&q->qi_quotaofflock);
 	return error;
 }


