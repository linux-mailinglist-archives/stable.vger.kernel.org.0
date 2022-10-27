Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141A560FEF9
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237105AbiJ0RKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237100AbiJ0RKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:10:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8684D59EBE
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 312B0B82726
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DA5C433D6;
        Thu, 27 Oct 2022 17:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890610;
        bh=xln4DHWQXBhBLOhW/WVbWQqWSUoD3kc3OstLhpm8xCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGPgb0pF4Eyg4dfUWtbCN2UOCDPHi9f33EkgdFYDqPgrnVJrwJS0a35dq91LzsQj3
         T2U6yzOLaWlp0U9pu7XQrT72IpQsf/TLC6/Y3BkZJGY642ed8cxC+LGdPlEtUIdUjB
         lVPVoJwDVSZ/8UnGCLzYjGo1uLJgVatL21YDmbpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Kuai <yukuai3@huawei.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 26/53] xfs: fix use-after-free on CIL context on shutdown
Date:   Thu, 27 Oct 2022 18:56:14 +0200
Message-Id: <20221027165050.807448572@linuxfoundation.org>
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

commit c7f87f3984cfa1e6d32806a715f35c5947ad9c09 upstream.

xlog_wait() on the CIL context can reference a freed context if the
waiter doesn't get scheduled before the CIL context is freed. This
can happen when a task is on the hard throttle and the CIL push
aborts due to a shutdown. This was detected by generic/019:

thread 1			thread 2

__xfs_trans_commit
 xfs_log_commit_cil
  <CIL size over hard throttle limit>
  xlog_wait
   schedule
				xlog_cil_push_work
				wake_up_all
				<shutdown aborts commit>
				xlog_cil_committed
				kmem_free

   remove_wait_queue
    spin_lock_irqsave --> UAF

Fix it by moving the wait queue to the CIL rather than keeping it in
in the CIL context that gets freed on push completion. Because the
wait queue is now independent of the CIL context and we might have
multiple contexts in flight at once, only wake the waiters on the
push throttle when the context we are pushing is over the hard
throttle size threshold.

Fixes: 0e7ab7efe7745 ("xfs: Throttle commits on delayed background CIL push")
Reported-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log_cil.c  |   10 +++++-----
 fs/xfs/xfs_log_priv.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -673,7 +673,8 @@ xlog_cil_push(
 	/*
 	 * Wake up any background push waiters now this context is being pushed.
 	 */
-	wake_up_all(&ctx->push_wait);
+	if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
+		wake_up_all(&cil->xc_push_wait);
 
 	/*
 	 * Check if we've anything to push. If there is nothing, then we don't
@@ -745,13 +746,12 @@ xlog_cil_push(
 
 	/*
 	 * initialise the new context and attach it to the CIL. Then attach
-	 * the current context to the CIL committing lsit so it can be found
+	 * the current context to the CIL committing list so it can be found
 	 * during log forces to extract the commit lsn of the sequence that
 	 * needs to be forced.
 	 */
 	INIT_LIST_HEAD(&new_ctx->committing);
 	INIT_LIST_HEAD(&new_ctx->busy_extents);
-	init_waitqueue_head(&new_ctx->push_wait);
 	new_ctx->sequence = ctx->sequence + 1;
 	new_ctx->cil = cil;
 	cil->xc_ctx = new_ctx;
@@ -946,7 +946,7 @@ xlog_cil_push_background(
 	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
 		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
 		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
-		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
+		xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
 		return;
 	}
 
@@ -1222,12 +1222,12 @@ xlog_cil_init(
 	INIT_LIST_HEAD(&cil->xc_committing);
 	spin_lock_init(&cil->xc_cil_lock);
 	spin_lock_init(&cil->xc_push_lock);
+	init_waitqueue_head(&cil->xc_push_wait);
 	init_rwsem(&cil->xc_ctx_lock);
 	init_waitqueue_head(&cil->xc_commit_wait);
 
 	INIT_LIST_HEAD(&ctx->committing);
 	INIT_LIST_HEAD(&ctx->busy_extents);
-	init_waitqueue_head(&ctx->push_wait);
 	ctx->sequence = 1;
 	ctx->cil = cil;
 	cil->xc_ctx = ctx;
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -247,7 +247,6 @@ struct xfs_cil_ctx {
 	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
 	struct list_head	iclog_entry;
 	struct list_head	committing;	/* ctx committing list */
-	wait_queue_head_t	push_wait;	/* background push throttle */
 	struct work_struct	discard_endio_work;
 };
 
@@ -281,6 +280,7 @@ struct xfs_cil {
 	wait_queue_head_t	xc_commit_wait;
 	xfs_lsn_t		xc_current_sequence;
 	struct work_struct	xc_push_work;
+	wait_queue_head_t	xc_push_wait;	/* background push throttle */
 } ____cacheline_aligned_in_smp;
 
 /*


