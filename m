Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC82669CD79
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbjBTNtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbjBTNtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:49:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAF11E1CE
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:49:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDEE860EA9
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13A7C433EF;
        Mon, 20 Feb 2023 13:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900973;
        bh=18vrFJHS/eJo2Ai4VxeYJUNrh/K1loikG4WPYnK21ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLhbxg0+eoynMV6qSFz2B4K15FrHATDXaSjRRUWIhd+oatpEZZb6zByoEmYPr/8RS
         kosdy40nrQmI92iM7nOGTp9lPBQMbx7muE0U5ikdu/IpHZVm8+jFQNe+U4raaRSDY+
         Yt46kF9TqZLp2g93boGnzVihXpZj5mg8Zk8pM8eY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 109/156] xfs: refactor xfs_defer_finish_noroll
Date:   Mon, 20 Feb 2023 14:35:53 +0100
Message-Id: <20230220133607.069980582@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit bb47d79750f1a68a75d4c7defc2da934ba31de14 upstream.

Split out a helper that operates on a single xfs_defer_pending structure
to untangle the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_defer.c |  128 +++++++++++++++++++++-------------------------
 1 file changed, 59 insertions(+), 69 deletions(-)

--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -360,6 +360,53 @@ xfs_defer_cancel_list(
 }
 
 /*
+ * Log an intent-done item for the first pending intent, and finish the work
+ * items.
+ */
+static int
+xfs_defer_finish_one(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	void				*state = NULL;
+	struct list_head		*li, *n;
+	int				error;
+
+	trace_xfs_defer_pending_finish(tp->t_mountp, dfp);
+
+	dfp->dfp_done = ops->create_done(tp, dfp->dfp_intent, dfp->dfp_count);
+	list_for_each_safe(li, n, &dfp->dfp_work) {
+		list_del(li);
+		dfp->dfp_count--;
+		error = ops->finish_item(tp, li, dfp->dfp_done, &state);
+		if (error == -EAGAIN) {
+			/*
+			 * Caller wants a fresh transaction; put the work item
+			 * back on the list and log a new log intent item to
+			 * replace the old one.  See "Requesting a Fresh
+			 * Transaction while Finishing Deferred Work" above.
+			 */
+			list_add(li, &dfp->dfp_work);
+			dfp->dfp_count++;
+			dfp->dfp_done = NULL;
+			xfs_defer_create_intent(tp, dfp, false);
+		}
+
+		if (error)
+			goto out;
+	}
+
+	/* Done with the dfp, free it. */
+	list_del(&dfp->dfp_list);
+	kmem_free(dfp);
+out:
+	if (ops->finish_cleanup)
+		ops->finish_cleanup(tp, state, error);
+	return error;
+}
+
+/*
  * Finish all the pending work.  This involves logging intent items for
  * any work items that wandered in since the last transaction roll (if
  * one has even happened), rolling the transaction, and finishing the
@@ -372,11 +419,7 @@ xfs_defer_finish_noroll(
 	struct xfs_trans		**tp)
 {
 	struct xfs_defer_pending	*dfp;
-	struct list_head		*li;
-	struct list_head		*n;
-	void				*state;
 	int				error = 0;
-	const struct xfs_defer_op_type	*ops;
 	LIST_HEAD(dop_pending);
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -385,83 +428,30 @@ xfs_defer_finish_noroll(
 
 	/* Until we run out of pending work to finish... */
 	while (!list_empty(&dop_pending) || !list_empty(&(*tp)->t_dfops)) {
-		/* log intents and pull in intake items */
 		xfs_defer_create_intents(*tp);
 		list_splice_tail_init(&(*tp)->t_dfops, &dop_pending);
 
-		/*
-		 * Roll the transaction.
-		 */
 		error = xfs_defer_trans_roll(tp);
 		if (error)
-			goto out;
+			goto out_shutdown;
 
-		/* Log an intent-done item for the first pending item. */
 		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
 				       dfp_list);
-		ops = defer_op_types[dfp->dfp_type];
-		trace_xfs_defer_pending_finish((*tp)->t_mountp, dfp);
-		dfp->dfp_done = ops->create_done(*tp, dfp->dfp_intent,
-				dfp->dfp_count);
-
-		/* Finish the work items. */
-		state = NULL;
-		list_for_each_safe(li, n, &dfp->dfp_work) {
-			list_del(li);
-			dfp->dfp_count--;
-			error = ops->finish_item(*tp, li, dfp->dfp_done,
-					&state);
-			if (error == -EAGAIN) {
-				/*
-				 * Caller wants a fresh transaction;
-				 * put the work item back on the list
-				 * and jump out.
-				 */
-				list_add(li, &dfp->dfp_work);
-				dfp->dfp_count++;
-				break;
-			} else if (error) {
-				/*
-				 * Clean up after ourselves and jump out.
-				 * xfs_defer_cancel will take care of freeing
-				 * all these lists and stuff.
-				 */
-				if (ops->finish_cleanup)
-					ops->finish_cleanup(*tp, state, error);
-				goto out;
-			}
-		}
-		if (error == -EAGAIN) {
-			/*
-			 * Caller wants a fresh transaction, so log a new log
-			 * intent item to replace the old one and roll the
-			 * transaction.  See "Requesting a Fresh Transaction
-			 * while Finishing Deferred Work" above.
-			 */
-			dfp->dfp_done = NULL;
-			xfs_defer_create_intent(*tp, dfp, false);
-		} else {
-			/* Done with the dfp, free it. */
-			list_del(&dfp->dfp_list);
-			kmem_free(dfp);
-		}
-
-		if (ops->finish_cleanup)
-			ops->finish_cleanup(*tp, state, error);
-	}
-
-out:
-	if (error) {
-		xfs_defer_trans_abort(*tp, &dop_pending);
-		xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
-		trace_xfs_defer_finish_error(*tp, error);
-		xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
-		xfs_defer_cancel(*tp);
-		return error;
+		error = xfs_defer_finish_one(*tp, dfp);
+		if (error && error != -EAGAIN)
+			goto out_shutdown;
 	}
 
 	trace_xfs_defer_finish_done(*tp, _RET_IP_);
 	return 0;
+
+out_shutdown:
+	xfs_defer_trans_abort(*tp, &dop_pending);
+	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
+	trace_xfs_defer_finish_error(*tp, error);
+	xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
+	xfs_defer_cancel(*tp);
+	return error;
 }
 
 int


