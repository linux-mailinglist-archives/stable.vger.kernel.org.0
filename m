Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F265560FED7
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237055AbiJ0RIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237077AbiJ0RIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:08:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DEC1A0453
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:08:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 041C362402
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B02C433C1;
        Thu, 27 Oct 2022 17:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890529;
        bh=RZsqVuGYvlNZWOnIEnGd3SNeyNzEAEbiafN93IyHX4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6hjpvtv4hsCjL8XyOhHyMmrfLhiom7SZF+wpy5ORUh25KEYn+Pe9VcS4sz0EyzQ/
         gIAMz4cTHcGMo51WkV5fo+B+qn+IqUKmjY0m0UOUFX3NTov9xPEFRCgfLBLJiwgCJd
         CyATMrFXnAINP4TFfzXMxTc/LMfDhmckTlsxSAtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 18/53] xfs: Throttle commits on delayed background CIL push
Date:   Thu, 27 Oct 2022 18:56:06 +0200
Message-Id: <20221027165050.522608180@linuxfoundation.org>
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

From: Dave Chinner <dchinner@redhat.com>

commit 0e7ab7efe77451cba4cbecb6c9f5ef83cf32b36b upstream.

In certain situations the background CIL push can be indefinitely
delayed. While we have workarounds from the obvious cases now, it
doesn't solve the underlying issue. This issue is that there is no
upper limit on the CIL where we will either force or wait for
a background push to start, hence allowing the CIL to grow without
bound until it consumes all log space.

To fix this, add a new wait queue to the CIL which allows background
pushes to wait for the CIL context to be switched out. This happens
when the push starts, so it will allow us to block incoming
transaction commit completion until the push has started. This will
only affect processes that are running modifications, and only when
the CIL threshold has been significantly overrun.

This has no apparent impact on performance, and doesn't even trigger
until over 45 million inodes had been created in a 16-way fsmark
test on a 2GB log. That was limiting at 64MB of log space used, so
the active CIL size is only about 3% of the total log in that case.
The concurrent removal of those files did not trigger the background
sleep at all.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log_cil.c  |   37 +++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_log_priv.h |   24 ++++++++++++++++++++++++
 fs/xfs/xfs_trace.h    |    1 +
 3 files changed, 58 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -671,6 +671,11 @@ xlog_cil_push(
 	ASSERT(push_seq <= ctx->sequence);
 
 	/*
+	 * Wake up any background push waiters now this context is being pushed.
+	 */
+	wake_up_all(&ctx->push_wait);
+
+	/*
 	 * Check if we've anything to push. If there is nothing, then we don't
 	 * move on to a new sequence number and so we have to be able to push
 	 * this sequence again later.
@@ -746,6 +751,7 @@ xlog_cil_push(
 	 */
 	INIT_LIST_HEAD(&new_ctx->committing);
 	INIT_LIST_HEAD(&new_ctx->busy_extents);
+	init_waitqueue_head(&new_ctx->push_wait);
 	new_ctx->sequence = ctx->sequence + 1;
 	new_ctx->cil = cil;
 	cil->xc_ctx = new_ctx;
@@ -900,7 +906,7 @@ xlog_cil_push_work(
  */
 static void
 xlog_cil_push_background(
-	struct xlog	*log)
+	struct xlog	*log) __releases(cil->xc_ctx_lock)
 {
 	struct xfs_cil	*cil = log->l_cilp;
 
@@ -914,14 +920,36 @@ xlog_cil_push_background(
 	 * don't do a background push if we haven't used up all the
 	 * space available yet.
 	 */
-	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
+	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log)) {
+		up_read(&cil->xc_ctx_lock);
 		return;
+	}
 
 	spin_lock(&cil->xc_push_lock);
 	if (cil->xc_push_seq < cil->xc_current_sequence) {
 		cil->xc_push_seq = cil->xc_current_sequence;
 		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
 	}
+
+	/*
+	 * Drop the context lock now, we can't hold that if we need to sleep
+	 * because we are over the blocking threshold. The push_lock is still
+	 * held, so blocking threshold sleep/wakeup is still correctly
+	 * serialised here.
+	 */
+	up_read(&cil->xc_ctx_lock);
+
+	/*
+	 * If we are well over the space limit, throttle the work that is being
+	 * done until the push work on this context has begun.
+	 */
+	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
+		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
+		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
+		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
+		return;
+	}
+
 	spin_unlock(&cil->xc_push_lock);
 
 }
@@ -1038,9 +1066,9 @@ xfs_log_commit_cil(
 		if (lip->li_ops->iop_committing)
 			lip->li_ops->iop_committing(lip, xc_commit_lsn);
 	}
-	xlog_cil_push_background(log);
 
-	up_read(&cil->xc_ctx_lock);
+	/* xlog_cil_push_background() releases cil->xc_ctx_lock */
+	xlog_cil_push_background(log);
 }
 
 /*
@@ -1199,6 +1227,7 @@ xlog_cil_init(
 
 	INIT_LIST_HEAD(&ctx->committing);
 	INIT_LIST_HEAD(&ctx->busy_extents);
+	init_waitqueue_head(&ctx->push_wait);
 	ctx->sequence = 1;
 	ctx->cil = cil;
 	cil->xc_ctx = ctx;
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -247,6 +247,7 @@ struct xfs_cil_ctx {
 	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
 	struct list_head	iclog_entry;
 	struct list_head	committing;	/* ctx committing list */
+	wait_queue_head_t	push_wait;	/* background push throttle */
 	struct work_struct	discard_endio_work;
 };
 
@@ -344,10 +345,33 @@ struct xfs_cil {
  *   buffer window (32MB) as measurements have shown this to be roughly the
  *   point of diminishing performance increases under highly concurrent
  *   modification workloads.
+ *
+ * To prevent the CIL from overflowing upper commit size bounds, we introduce a
+ * new threshold at which we block committing transactions until the background
+ * CIL commit commences and switches to a new context. While this is not a hard
+ * limit, it forces the process committing a transaction to the CIL to block and
+ * yeild the CPU, giving the CIL push work a chance to be scheduled and start
+ * work. This prevents a process running lots of transactions from overfilling
+ * the CIL because it is not yielding the CPU. We set the blocking limit at
+ * twice the background push space threshold so we keep in line with the AIL
+ * push thresholds.
+ *
+ * Note: this is not a -hard- limit as blocking is applied after the transaction
+ * is inserted into the CIL and the push has been triggered. It is largely a
+ * throttling mechanism that allows the CIL push to be scheduled and run. A hard
+ * limit will be difficult to implement without introducing global serialisation
+ * in the CIL commit fast path, and it's not at all clear that we actually need
+ * such hard limits given the ~7 years we've run without a hard limit before
+ * finding the first situation where a checkpoint size overflow actually
+ * occurred. Hence the simple throttle, and an ASSERT check to tell us that
+ * we've overrun the max size.
  */
 #define XLOG_CIL_SPACE_LIMIT(log)	\
 	min_t(int, (log)->l_logsize >> 3, BBTOB(XLOG_TOTAL_REC_SHIFT(log)) << 4)
 
+#define XLOG_CIL_BLOCKING_SPACE_LIMIT(log)	\
+	(XLOG_CIL_SPACE_LIMIT(log) * 2)
+
 /*
  * ticket grant locks, queues and accounting have their own cachlines
  * as these are quite hot and can be operated on concurrently.
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1011,6 +1011,7 @@ DEFINE_LOGGRANT_EVENT(xfs_log_regrant_re
 DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub);
+DEFINE_LOGGRANT_EVENT(xfs_log_cil_wait);
 
 DECLARE_EVENT_CLASS(xfs_log_item_class,
 	TP_PROTO(struct xfs_log_item *lip),


