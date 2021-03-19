Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1AED341C88
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhCSMVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:21:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231393AbhCSMVH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:21:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 235396146D;
        Fri, 19 Mar 2021 12:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156458;
        bh=ckCEMwkTdHRUK+3A65B6sHIP4/kzvgiVMTUppH3d7tE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C0KeuyBasyPAPk6KdzZ0lg+KdxL4gAFLR7jkVpjWBHJ+80mOZmYS8zmfMAjEFd7tI
         D0opEaWe0zQIh6WAVS6P6jni+WQXPP+aHDrcXSJOdh59dq25dk1ODB/SJwqhrznTPj
         KgC1+rtdZR57ieKqIYnIepz93ZYyWtEkfP/KPL1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 09/31] io_uring: dont keep looping for more events if we cant flush overflow
Date:   Fri, 19 Mar 2021 13:19:03 +0100
Message-Id: <20210319121747.504718297@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
References: <20210319121747.203523570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit ca0a26511c679a797f86589894a4523db36d833e ]

It doesn't make sense to wait for more events to come in, if we can't
even flush the overflow we already have to the ring. Return -EBUSY for
that condition, just like we do for attempts to submit with overflow
pending.

Cc: stable@vger.kernel.org # 5.11
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7621978e9fc8..cab380a337e4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1823,18 +1823,22 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	return all_flushed;
 }
 
-static void io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
+static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 				     struct task_struct *tsk,
 				     struct files_struct *files)
 {
+	bool ret = true;
+
 	if (test_bit(0, &ctx->cq_check_overflow)) {
 		/* iopoll syncs against uring_lock, not completion_lock */
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_lock(&ctx->uring_lock);
-		__io_cqring_overflow_flush(ctx, force, tsk, files);
+		ret = __io_cqring_overflow_flush(ctx, force, tsk, files);
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_unlock(&ctx->uring_lock);
 	}
+
+	return ret;
 }
 
 static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
@@ -7280,11 +7284,16 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
-		io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		/* if we can't even flush overflow, don't wait for more */
+		if (!io_cqring_overflow_flush(ctx, false, NULL, NULL)) {
+			ret = -EBUSY;
+			break;
+		}
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
 		finish_wait(&ctx->wait, &iowq.wq);
+		cond_resched();
 	} while (ret > 0);
 
 	restore_saved_sigmask_unless(ret == -EINTR);
-- 
2.30.1



