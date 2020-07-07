Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84CD2171DA
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgGGP0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:26:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728717AbgGGP0R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:26:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C48232065D;
        Tue,  7 Jul 2020 15:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135576;
        bh=cJWeeKKPGUJksknMROnR55vt55tUDqvpZ5yiYzzjj1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Thl9i5M2a5SLivjl3VM1wb9AjI7wGbzvE2ORoXabHq+PVF6Xs7qbT5zB08nBD7Q98
         326vAWOAT/ZvjT+i1brk6FPa9CpdTnoE4z9oy6+XC05JmHNm2G/f/+CDa+VtB6++nP
         IB2HRf0aBWkN1g4LzLMA4AYx1i/dEWOd/T6llWWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 055/112] xfs: fix use-after-free on CIL context on shutdown
Date:   Tue,  7 Jul 2020 17:17:00 +0200
Message-Id: <20200707145803.616756482@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit c7f87f3984cfa1e6d32806a715f35c5947ad9c09 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_log_cil.c  | 10 +++++-----
 fs/xfs/xfs_log_priv.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b43f0e8f43f2e..9ed90368ab311 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -671,7 +671,8 @@ xlog_cil_push_work(
 	/*
 	 * Wake up any background push waiters now this context is being pushed.
 	 */
-	wake_up_all(&ctx->push_wait);
+	if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
+		wake_up_all(&cil->xc_push_wait);
 
 	/*
 	 * Check if we've anything to push. If there is nothing, then we don't
@@ -743,13 +744,12 @@ xlog_cil_push_work(
 
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
@@ -937,7 +937,7 @@ xlog_cil_push_background(
 	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
 		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
 		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
-		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
+		xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
 		return;
 	}
 
@@ -1216,12 +1216,12 @@ xlog_cil_init(
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
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index ec22c7a3867f1..75a62870b63af 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -240,7 +240,6 @@ struct xfs_cil_ctx {
 	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
 	struct list_head	iclog_entry;
 	struct list_head	committing;	/* ctx committing list */
-	wait_queue_head_t	push_wait;	/* background push throttle */
 	struct work_struct	discard_endio_work;
 };
 
@@ -274,6 +273,7 @@ struct xfs_cil {
 	wait_queue_head_t	xc_commit_wait;
 	xfs_lsn_t		xc_current_sequence;
 	struct work_struct	xc_push_work;
+	wait_queue_head_t	xc_push_wait;	/* background push throttle */
 } ____cacheline_aligned_in_smp;
 
 /*
-- 
2.25.1



