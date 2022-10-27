Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850D660FEC7
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbiJ0RIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237049AbiJ0RIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:08:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D796B19C062
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:08:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81537B825F3
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A564AC433D6;
        Thu, 27 Oct 2022 17:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890498;
        bh=+iqGqpGit21vzScy6MS2XROA/bDGFNjOYAEb7/ZQ1GU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0gOUGQEvicsy/tWAZZLYbt89i7pB4FVFc+bLl3zwtGboM9ZPMUwpti+9pwkbK2bYR
         uFf6K2GnRDDrBCh8PE56lBW/2+0I/kpgshPjdIpvJIV/jiZAbnZzZeKheXJtinKcmK
         4qFjH5Qzq+sNXVXWOwW/tPmbku9QAOlJjhnr8vKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 14/53] xfs: factor out quotaoff intent AIL removal and memory free
Date:   Thu, 27 Oct 2022 18:56:02 +0200
Message-Id: <20221027165050.349049164@linuxfoundation.org>
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

commit 854f82b1f6039a418b7d1407513f8640e05fd73f upstream.

AIL removal of the quotaoff start intent and free of both intents is
hardcoded to the ->iop_committed() handler of the end intent. Factor
out the start intent handling code so it can be used in a future
patch to properly handle quotaoff errors. Use xfs_trans_ail_remove()
instead of the _delete() variant to acquire the AIL lock and also
handle cases where an intent might not reside in the AIL at the
time of a failure.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot_item.c |   29 ++++++++++++++++++++---------
 fs/xfs/xfs_dquot_item.h |    1 +
 2 files changed, 21 insertions(+), 9 deletions(-)

--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -307,18 +307,10 @@ xfs_qm_qoffend_logitem_committed(
 {
 	struct xfs_qoff_logitem	*qfe = QOFF_ITEM(lip);
 	struct xfs_qoff_logitem	*qfs = qfe->qql_start_lip;
-	struct xfs_ail		*ailp = qfs->qql_item.li_ailp;
 
-	/*
-	 * Delete the qoff-start logitem from the AIL.
-	 * xfs_trans_ail_delete() drops the AIL lock.
-	 */
-	spin_lock(&ailp->ail_lock);
-	xfs_trans_ail_delete(ailp, &qfs->qql_item, SHUTDOWN_LOG_IO_ERROR);
+	xfs_qm_qoff_logitem_relse(qfs);
 
-	kmem_free(qfs->qql_item.li_lv_shadow);
 	kmem_free(lip->li_lv_shadow);
-	kmem_free(qfs);
 	kmem_free(qfe);
 	return (xfs_lsn_t)-1;
 }
@@ -337,6 +329,25 @@ static const struct xfs_item_ops xfs_qm_
 };
 
 /*
+ * Delete the quotaoff intent from the AIL and free it. On success,
+ * this should only be called for the start item. It can be used for
+ * either on shutdown or abort.
+ */
+void
+xfs_qm_qoff_logitem_relse(
+	struct xfs_qoff_logitem	*qoff)
+{
+	struct xfs_log_item	*lip = &qoff->qql_item;
+
+	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags) ||
+	       test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
+	       XFS_FORCED_SHUTDOWN(lip->li_mountp));
+	xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
+	kmem_free(lip->li_lv_shadow);
+	kmem_free(qoff);
+}
+
+/*
  * Allocate and initialize an quotaoff item of the correct quota type(s).
  */
 struct xfs_qoff_logitem *
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -28,6 +28,7 @@ void xfs_qm_dquot_logitem_init(struct xf
 struct xfs_qoff_logitem	*xfs_qm_qoff_logitem_init(struct xfs_mount *mp,
 		struct xfs_qoff_logitem *start,
 		uint flags);
+void xfs_qm_qoff_logitem_relse(struct xfs_qoff_logitem *);
 struct xfs_qoff_logitem	*xfs_trans_get_qoff_item(struct xfs_trans *tp,
 		struct xfs_qoff_logitem *startqoff,
 		uint flags);


