Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B2540E5FB
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345950AbhIPRRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:17:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346608AbhIPRFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:05:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A6DE61B23;
        Thu, 16 Sep 2021 16:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810118;
        bh=Ys4t2QURF02VuGYl3BTJI2RoI+/kgTsM849ivVD48o0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duve4JwgWmF+6bIwZpmM1IJqRJnoYU+PePKjAms9BNT8HIoBRMAEZrCDuXNIOey1c
         XfIL76KOOePQAKtsGN0Xw8Z2ojOrsKjn/FZj8du5GOJ1nTDRqJBylxcioCsZF2j98u
         46NT/kJVxrW1Ee0aIgJgJ/lRGcTd/QkYMreDy0Yk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b0c9d1588ae92866515f@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.14 005/432] io_uring: fix io_try_cancel_userdata race for iowq
Date:   Thu, 16 Sep 2021 17:55:54 +0200
Message-Id: <20210916155810.999709112@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit dadebc350da2bef62593b1df007a6e0b90baf42a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6310,6 +6310,7 @@ static void io_wq_submit_work(struct io_
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
+	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
 	if (work->flags & IO_WQ_WORK_CANCEL)
 		ret = -ECANCELED;
 
@@ -9137,8 +9138,8 @@ static void io_uring_clean_tctx(struct i
 		 * Must be after io_uring_del_task_file() (removes nodes under
 		 * uring_lock) to avoid race with io_uring_try_cancel_iowq().
 		 */
-		tctx->io_wq = NULL;
 		io_wq_put_and_exit(wq);
+		tctx->io_wq = NULL;
 	}
 }
 


