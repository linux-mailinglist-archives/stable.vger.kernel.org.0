Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C20735408B
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240059AbhDEJSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:18:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240264AbhDEJS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:18:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFC9A6128B;
        Mon,  5 Apr 2021 09:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614299;
        bh=yFG7JqOy7Bs5pwNhT4VtoiE6IoQGPZDsaawi+SQa4ZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9JWi76FlRuzx7yGGGAG1W2U4nsPqxZLnhuxu4RoQvwdOE9izxH2U3HZjwDltg0wE
         mhmLRuvEeNSy2aCr3RRo0O9EWLLY7xEsgEq43RnxDOoKal3twZHedx+XFQhUQOYiot
         dTVyIzc64uTGg9USSsE2c0RKBSr5vP/uH4iPmyNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e3a3f84f5cecf61f0583@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.11 150/152] io_uring: do ctx sqd ejection in a clear context
Date:   Mon,  5 Apr 2021 10:54:59 +0200
Message-Id: <20210405085039.090899235@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit a185f1db59f13de73aa470559030e90e50b34d93 upstream.

WARNING: CPU: 1 PID: 27907 at fs/io_uring.c:7147 io_sq_thread_park+0xb5/0xd0 fs/io_uring.c:7147
CPU: 1 PID: 27907 Comm: iou-sqp-27905 Not tainted 5.12.0-rc4-syzkaller #0
RIP: 0010:io_sq_thread_park+0xb5/0xd0 fs/io_uring.c:7147
Call Trace:
 io_ring_ctx_wait_and_kill+0x214/0x700 fs/io_uring.c:8619
 io_uring_release+0x3e/0x50 fs/io_uring.c:8646
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 io_run_task_work fs/io_uring.c:2238 [inline]
 io_run_task_work fs/io_uring.c:2228 [inline]
 io_uring_try_cancel_requests+0x8ec/0xc60 fs/io_uring.c:8770
 io_uring_cancel_sqpoll+0x1cf/0x290 fs/io_uring.c:8974
 io_sqpoll_cancel_cb+0x87/0xb0 fs/io_uring.c:8907
 io_run_task_work_head+0x58/0xb0 fs/io_uring.c:1961
 io_sq_thread+0x3e2/0x18d0 fs/io_uring.c:6763
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

May happen that last ctx ref is killed in io_uring_cancel_sqpoll(), so
fput callback (i.e. io_uring_release()) is enqueued through task_work,
and run by same cancellation. As it's deeply nested we can't do parking
or taking sqd->lock there, because its state is unclear. So avoid
ctx ejection from sqd list from io_ring_ctx_wait_and_kill() and do it
in a clear context in io_ring_exit_work().

Fixes: f6d54255f423 ("io_uring: halt SQO submission on ctx exit")
Reported-by: syzbot+e3a3f84f5cecf61f0583@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/e90df88b8ff2cabb14a7534601d35d62ab4cb8c7.1616496707.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8738,6 +8738,14 @@ static __poll_t io_uring_poll(struct fil
 	if (!io_sqring_full(ctx))
 		mask |= EPOLLOUT | EPOLLWRNORM;
 
+	/* prevent SQPOLL from submitting new requests */
+	if (ctx->sq_data) {
+		io_sq_thread_park(ctx->sq_data);
+		list_del_init(&ctx->sqd_list);
+		io_sqd_update_thread_idle(ctx->sq_data);
+		io_sq_thread_unpark(ctx->sq_data);
+	}
+
 	/*
 	 * Don't flush cqring overflow list here, just do a simple check.
 	 * Otherwise there could possible be ABBA deadlock:
@@ -8816,14 +8824,6 @@ static void io_ring_ctx_wait_and_kill(st
 		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	mutex_unlock(&ctx->uring_lock);
 
-	/* prevent SQPOLL from submitting new requests */
-	if (ctx->sq_data) {
-		io_sq_thread_park(ctx->sq_data);
-		list_del_init(&ctx->sqd_list);
-		io_sqd_update_thread_idle(ctx->sq_data);
-		io_sq_thread_unpark(ctx->sq_data);
-	}
-
 	io_kill_timeouts(ctx, NULL, NULL);
 	io_poll_remove_all(ctx, NULL, NULL);
 


