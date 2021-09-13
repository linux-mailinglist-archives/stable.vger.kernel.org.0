Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523E6408863
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 11:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238731AbhIMJi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 05:38:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238692AbhIMJiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 05:38:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7618560F4C;
        Mon, 13 Sep 2021 09:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631525853;
        bh=14tdKUDFg8Vv+PkgFB8vGwqqW5r2dAxwubaxS9W3YpU=;
        h=Subject:To:Cc:From:Date:From;
        b=JU6kEMiHYknOlvhQDMRekpHkUdUpstBwaBKYX8eKj7sAEA3RfEG96diZUnfLr84As
         mh3sCk7nb8E7nmBIw8bwpSm1fKWa8KzpV1Q4PbfB6Ca5ZYlHW9PRK0L0PEOoGS2JSF
         /eyP7/6zJbQCMdLJHPcMVQDnd0OMloMyVt9XchCU=
Subject: FAILED: patch "[PATCH] io_uring: fix io_try_cancel_userdata race for iowq" failed to apply to 5.14-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Sep 2021 11:37:23 +0200
Message-ID: <163152584324476@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dadebc350da2bef62593b1df007a6e0b90baf42a Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 23 Aug 2021 13:30:44 +0100
Subject: [PATCH] io_uring: fix io_try_cancel_userdata race for iowq

WARNING: CPU: 1 PID: 5870 at fs/io_uring.c:5975 io_try_cancel_userdata+0x30f/0x540 fs/io_uring.c:5975
CPU: 0 PID: 5870 Comm: iou-wrk-5860 Not tainted 5.14.0-rc6-next-20210820-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_try_cancel_userdata+0x30f/0x540 fs/io_uring.c:5975
Call Trace:
 io_async_cancel fs/io_uring.c:6014 [inline]
 io_issue_sqe+0x22d5/0x65a0 fs/io_uring.c:6407
 io_wq_submit_work+0x1dc/0x300 fs/io_uring.c:6511
 io_worker_handle_work+0xa45/0x1840 fs/io-wq.c:533
 io_wqe_worker+0x2cc/0xbb0 fs/io-wq.c:582
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

io_try_cancel_userdata() can be called from io_async_cancel() executing
in the io-wq context, so the warning fires, which is there to alert
anyone accessing task->io_uring->io_wq in a racy way. However,
io_wq_put_and_exit() always first waits for all threads to complete,
so the only detail left is to zero tctx->io_wq after the context is
removed.

note: one little assumption is that when IO_WQ_WORK_CANCEL, the executor
won't touch ->io_wq, because io_wq_destroy() might cancel left pending
requests in such a way.

Cc: stable@vger.kernel.org
Reported-by: syzbot+b0c9d1588ae92866515f@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/dfdd37a80cfa9ffd3e59538929c99cdd55d8699e.1629721757.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 827e60ae4909..6859438c4e09 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5863,7 +5863,7 @@ static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	WARN_ON_ONCE(req->task != current);
+	WARN_ON_ONCE(!io_wq_current_is_worker() && req->task != current);
 
 	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
 	if (ret != -ENOENT)
@@ -6369,6 +6369,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
+	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
 	if (work->flags & IO_WQ_WORK_CANCEL)
 		ret = -ECANCELED;
 
@@ -9184,8 +9185,8 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 		 * Must be after io_uring_del_task_file() (removes nodes under
 		 * uring_lock) to avoid race with io_uring_try_cancel_iowq().
 		 */
-		tctx->io_wq = NULL;
 		io_wq_put_and_exit(wq);
+		tctx->io_wq = NULL;
 	}
 }
 

