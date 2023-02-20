Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C331C69CD64
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbjBTNs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbjBTNs6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:48:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64E11E1F6
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:48:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ED9960CBA
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF97C433D2;
        Mon, 20 Feb 2023 13:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900924;
        bh=RJD+ppTFd42OpbNqKJRVSeW43QkcMihbQvAfH5fczNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5ZS4XgAyGVQHTAtyA75yLMuhZnw517NjCjrqN8fKOkvBLD/0kd7KbM8hK07oGBiO
         yBWCkq5gpHVfyJ6ZwY2/k2uHZ5bUvhQXOdG8aqgM8ONPc4MPHJ9by0NNaK5jHnHgcY
         yaalPWOd2lNdOxCyf9r7VFgc1ntanhjhaHKUW1to=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 120/156] xfs: expose the log push threshold
Date:   Mon, 20 Feb 2023 14:36:04 +0100
Message-Id: <20230220133607.582829054@linuxfoundation.org>
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

commit ed1575daf71e4e21d8ae735b6e687c95454aaa17 upstream.

Separate the computation of the log push threshold and the push logic in
xlog_grant_push_ail.  This enables higher level code to determine (for
example) that it is holding on to a logged intent item and the log is so
busy that it is more than 75% full.  In that case, it would be desirable
to move the log item towards the head to release the tail, which we will
cover in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_icreate_item.c |    1 +
 fs/xfs/xfs_log.c          |   40 ++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_log.h          |    2 ++
 3 files changed, 33 insertions(+), 10 deletions(-)

--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -10,6 +10,7 @@
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_icreate_item.h"
+#include "xfs_log_priv.h"
 #include "xfs_log.h"
 
 kmem_zone_t	*xfs_icreate_zone;		/* inode create item zone */
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1537,14 +1537,14 @@ xlog_commit_record(
 }
 
 /*
- * Push on the buffer cache code if we ever use more than 75% of the on-disk
- * log space.  This code pushes on the lsn which would supposedly free up
- * the 25% which we want to leave free.  We may need to adopt a policy which
- * pushes on an lsn which is further along in the log once we reach the high
- * water mark.  In this manner, we would be creating a low water mark.
+ * Compute the LSN that we'd need to push the log tail towards in order to have
+ * (a) enough on-disk log space to log the number of bytes specified, (b) at
+ * least 25% of the log space free, and (c) at least 256 blocks free.  If the
+ * log free space already meets all three thresholds, this function returns
+ * NULLCOMMITLSN.
  */
-STATIC void
-xlog_grant_push_ail(
+xfs_lsn_t
+xlog_grant_push_threshold(
 	struct xlog	*log,
 	int		need_bytes)
 {
@@ -1570,7 +1570,7 @@ xlog_grant_push_ail(
 	free_threshold = max(free_threshold, (log->l_logBBsize >> 2));
 	free_threshold = max(free_threshold, 256);
 	if (free_blocks >= free_threshold)
-		return;
+		return NULLCOMMITLSN;
 
 	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
 						&threshold_block);
@@ -1590,13 +1590,33 @@ xlog_grant_push_ail(
 	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
 		threshold_lsn = last_sync_lsn;
 
+	return threshold_lsn;
+}
+
+/*
+ * Push the tail of the log if we need to do so to maintain the free log space
+ * thresholds set out by xlog_grant_push_threshold.  We may need to adopt a
+ * policy which pushes on an lsn which is further along in the log once we
+ * reach the high water mark.  In this manner, we would be creating a low water
+ * mark.
+ */
+STATIC void
+xlog_grant_push_ail(
+	struct xlog	*log,
+	int		need_bytes)
+{
+	xfs_lsn_t	threshold_lsn;
+
+	threshold_lsn = xlog_grant_push_threshold(log, need_bytes);
+	if (threshold_lsn == NULLCOMMITLSN || XLOG_FORCED_SHUTDOWN(log))
+		return;
+
 	/*
 	 * Get the transaction layer to kick the dirty buffers out to
 	 * disk asynchronously. No point in trying to do this if
 	 * the filesystem is shutting down.
 	 */
-	if (!XLOG_FORCED_SHUTDOWN(log))
-		xfs_ail_push(log->l_ailp, threshold_lsn);
+	xfs_ail_push(log->l_ailp, threshold_lsn);
 }
 
 /*
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -146,4 +146,6 @@ void	xfs_log_quiesce(struct xfs_mount *m
 bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 bool	xfs_log_in_recovery(struct xfs_mount *);
 
+xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
+
 #endif	/* __XFS_LOG_H__ */


