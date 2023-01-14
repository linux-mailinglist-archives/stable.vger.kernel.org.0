Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3D866AABF
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjANJwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjANJwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:52:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BE7195
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 01:52:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D905B80765
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 09:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469E2C433EF;
        Sat, 14 Jan 2023 09:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673689933;
        bh=Xl+DEw8e4SnOB0rW5XYdqFUPaa5NUDlscAxnNTPrgvA=;
        h=Subject:To:Cc:From:Date:From;
        b=1zT87UP/PivKtGn6lAlVT4oCsEnqIL+Wj+raDBgyiRtL+1cHobS9uPzibEQJxQgMx
         iu2O2tIlhzTvVX1qJ6ECH/lkjHfYM01+Z2i6rHL/8Ut/VtQ4Y1lItqaHo/5DUb92GT
         McxKuCAUFWp6SkMurBhWrtQAFsEYvWvVkgeTjyJs=
Subject: FAILED: patch "[PATCH] io_uring: lock overflowing for IOPOLL" failed to apply to 5.15-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Jan 2023 10:51:57 +0100
Message-ID: <1673689917176116@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

544d163d659d ("io_uring: lock overflowing for IOPOLL")
a8cf95f93610 ("io_uring: fix overflow handling regression")
fa18fa2272c7 ("io_uring: inline __io_req_complete_put()")
f9d567c75ec2 ("io_uring: inline __io_req_complete_post()")
52120f0fadcb ("io_uring: add allow_overflow to io_post_aux_cqe")
e6130eba8a84 ("io_uring: add support for passing fixed file descriptors")
253993210bd8 ("io_uring: introduce locking helpers for CQE posting")
305bef988708 ("io_uring: hide eventfd assumptions in eventfd paths")
d9dee4302a7c ("io_uring: remove ->flush_cqes optimisation")
a830ffd28780 ("io_uring: move io_eventfd_signal()")
9046c6415be6 ("io_uring: reshuffle io_uring/io_uring.h")
d142c3ec8d16 ("io_uring: remove extra io_commit_cqring()")
68494a65d0e2 ("io_uring: introduce io_req_cqe_overflow()")
faf88dde060f ("io_uring: don't inline __io_get_cqe()")
d245bca6375b ("io_uring: don't expose io_fill_cqe_aux()")
aa1e90f64ee5 ("io_uring: move small helpers to headers")
aa1e90f64ee5 ("io_uring: move small helpers to headers")
aa1e90f64ee5 ("io_uring: move small helpers to headers")
aa1e90f64ee5 ("io_uring: move small helpers to headers")
aa1e90f64ee5 ("io_uring: move small helpers to headers")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 544d163d659d45a206d8929370d5a2984e546cb7 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 12 Jan 2023 13:08:56 +0000
Subject: [PATCH] io_uring: lock overflowing for IOPOLL
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

syzbot reports an issue with overflow filling for IOPOLL:

WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
CPU: 0 PID: 28 Comm: kworker/u4:1 Not tainted 6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Workqueue: events_unbound io_ring_exit_work
Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863

There is no real problem for normal IOPOLL as flush is also called with
uring_lock taken, but it's getting more complicated for IOPOLL|SQPOLL,
for which __io_cqring_overflow_flush() happens from the CQ waiting path.

Reported-and-tested-by: syzbot+6805087452d72929404e@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 8227af2e1c0f..9c3ddd46a1ad 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1062,7 +1062,11 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 			continue;
 
 		req->cqe.flags = io_put_kbuf(req, 0);
-		io_fill_cqe_req(req->ctx, req);
+		if (unlikely(!__io_fill_cqe_req(ctx, req))) {
+			spin_lock(&ctx->completion_lock);
+			io_req_cqe_overflow(req);
+			spin_unlock(&ctx->completion_lock);
+		}
 	}
 
 	if (unlikely(!nr_events))

