Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD5F2E400D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387479AbgL1Ore (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:47:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502808AbgL1OXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:23:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90D32206E5;
        Mon, 28 Dec 2020 14:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165398;
        bh=0sPQwrbSMMI3HQbhaGGImWtCf5NHsbUmzmfLgkEjfRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m0HxB/EDnIndJ6RJb2dGZdp4Yj9DnU8aK0Ih/Enc8Q6IAhNiXh4B0Vv8pUTm10SQ2
         gGAbELojM4/J0tOvl4NVZmH84neqZTdFUEk16OIgCdVjG/N9U8kk1+1NVKPGNbyn9F
         T7zqcgz8zcwxq1J6BCwhtcSB6XKtdfk+VJReD/mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 518/717] io_uring: hold uring_lock while completing failed polled io in io_wq_submit_work()
Date:   Mon, 28 Dec 2020 13:48:36 +0100
Message-Id: <20201228125045.774596353@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

commit c07e6719511e77c4b289f62bfe96423eb6ea061d upstream.

io_iopoll_complete() does not hold completion_lock to complete polled io,
so in io_wq_submit_work(), we can not call io_req_complete() directly, to
complete polled io, otherwise there maybe concurrent access to cqring,
defer_list, etc, which is not safe. Commit dad1b1242fd5 ("io_uring: always
let io_iopoll_complete() complete polled io") has fixed this issue, but
Pavel reported that IOPOLL apart from rw can do buf reg/unreg requests(
IORING_OP_PROVIDE_BUFFERS or IORING_OP_REMOVE_BUFFERS), so the fix is not
good.

Given that io_iopoll_complete() is always called under uring_lock, so here
for polled io, we can also get uring_lock to fix this issue.

Fixes: dad1b1242fd5 ("io_uring: always let io_iopoll_complete() complete polled io")
Cc: <stable@vger.kernel.org> # 5.5+
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
[axboe: don't deref 'req' after completing it']
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6081,19 +6081,28 @@ static struct io_wq_work *io_wq_submit_w
 	}
 
 	if (ret) {
+		struct io_ring_ctx *lock_ctx = NULL;
+
+		if (req->ctx->flags & IORING_SETUP_IOPOLL)
+			lock_ctx = req->ctx;
+
 		/*
-		 * io_iopoll_complete() does not hold completion_lock to complete
-		 * polled io, so here for polled io, just mark it done and still let
-		 * io_iopoll_complete() complete it.
+		 * io_iopoll_complete() does not hold completion_lock to
+		 * complete polled io, so here for polled io, we can not call
+		 * io_req_complete() directly, otherwise there maybe concurrent
+		 * access to cqring, defer_list, etc, which is not safe. Given
+		 * that io_iopoll_complete() is always called under uring_lock,
+		 * so here for polled io, we also get uring_lock to complete
+		 * it.
 		 */
-		if (req->ctx->flags & IORING_SETUP_IOPOLL) {
-			struct kiocb *kiocb = &req->rw.kiocb;
+		if (lock_ctx)
+			mutex_lock(&lock_ctx->uring_lock);
+
+		req_set_fail_links(req);
+		io_req_complete(req, ret);
 
-			kiocb_done(kiocb, ret, NULL);
-		} else {
-			req_set_fail_links(req);
-			io_req_complete(req, ret);
-		}
+		if (lock_ctx)
+			mutex_unlock(&lock_ctx->uring_lock);
 	}
 
 	return io_steal_work(req);


