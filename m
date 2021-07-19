Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23A83CE3AA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346528AbhGSPiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347653AbhGSPfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E1E96146D;
        Mon, 19 Jul 2021 16:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711153;
        bh=kEE+t5IVqf4H2GextJgMa8qJHrlWZdKvdM2qdkjlFmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWXoxOmldHY0Q/zK5ZBneyqBlMNDym3oDSbIm3q7fnqfW0db5gUzy1rA53sjZK9g4
         NPYBdukH/cCvyvCs14T7pE3ntAc6z6etRCi1G2AwMWg8fv+pBFxj7VPkMAf4/dLBtR
         BfJ8TU3pZHWNUoaReujnQMaepPN+PzpY+woe2DCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 248/351] io_uring: remove not needed PF_EXITING check
Date:   Mon, 19 Jul 2021 16:53:14 +0200
Message-Id: <20210719144953.150925179@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit e5dc480d4ed9884274e95c757fa2d2e9cc1047ee ]

Since cancellation got moved before exit_signals(), there is no one left
who can call io_run_task_work() with PF_EXIING set, so remove the check.
Note that __io_req_task_submit() still needs a similar check.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f7f305ececb1e6044ea649fb983ca754805bb884.1624739600.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 262e6748c88a..eeea6b8c8bee 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2227,12 +2227,6 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
 
 static inline bool io_run_task_work(void)
 {
-	/*
-	 * Not safe to run on exiting task, and the task_work handling will
-	 * not add work to such a task.
-	 */
-	if (unlikely(current->flags & PF_EXITING))
-		return false;
 	if (current->task_works) {
 		__set_current_state(TASK_RUNNING);
 		task_work_run();
@@ -8958,7 +8952,8 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		ret |= io_cancel_defer_files(ctx, task, cancel_all);
 		ret |= io_poll_remove_all(ctx, task, cancel_all);
 		ret |= io_kill_timeouts(ctx, task, cancel_all);
-		ret |= io_run_task_work();
+		if (task)
+			ret |= io_run_task_work();
 		ret |= io_run_ctx_fallback(ctx);
 		if (!ret)
 			break;
-- 
2.30.2



