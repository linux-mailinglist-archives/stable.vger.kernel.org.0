Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F6F30C03A
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhBBNv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:51:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232948AbhBBNuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:50:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7368264FA8;
        Tue,  2 Feb 2021 13:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273361;
        bh=/yZ5ukdPQ4qFx3f9JFWACvXo73LQzZAXJ7pGgjDewPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AAOu8uW8aGBMNw7PaI2/0hkpNCo5kCexCX7eNWPCjbm4W74dOlbAmy5O6JJanDNk9
         DeUziR3oHJCqISm5D9uabUgLgOfmbhdiYkiAZdnc8iVrDWCVQ1NZrI4HK6wnC/2ka4
         wWNOCX9XOdWjbF9DqlM+5TqW3ecWHTMUY5lM3s8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 047/142] io_uring: fix wqe->lock/completion_lock deadlock
Date:   Tue,  2 Feb 2021 14:36:50 +0100
Message-Id: <20210202132959.668196463@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 907d1df30a51cc1a1d25414a00cde0494b83df7b upstream.

Joseph reports following deadlock:

CPU0:
...
io_kill_linked_timeout  // &ctx->completion_lock
io_commit_cqring
__io_queue_deferred
__io_queue_async_work
io_wq_enqueue
io_wqe_enqueue  // &wqe->lock

CPU1:
...
__io_uring_files_cancel
io_wq_cancel_cb
io_wqe_cancel_pending_work  // &wqe->lock
io_cancel_task_cb  // &ctx->completion_lock

Only __io_queue_deferred() calls queue_async_work() while holding
ctx->completion_lock, enqueue drained requests via io_req_task_queue()
instead.

Cc: stable@vger.kernel.org # 5.9+
Reported-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -972,6 +972,7 @@ static int io_setup_async_rw(struct io_k
 			     const struct iovec *fast_iov,
 			     struct iov_iter *iter, bool force);
 static void io_req_drop_files(struct io_kiocb *req);
+static void io_req_task_queue(struct io_kiocb *req);
 
 static struct kmem_cache *req_cachep;
 
@@ -1502,18 +1503,11 @@ static void __io_queue_deferred(struct i
 	do {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
 						struct io_defer_entry, list);
-		struct io_kiocb *link;
 
 		if (req_need_defer(de->req, de->seq))
 			break;
 		list_del_init(&de->list);
-		/* punt-init is done before queueing for defer */
-		link = __io_queue_async_work(de->req);
-		if (link) {
-			__io_queue_linked_timeout(link);
-			/* drop submission reference */
-			io_put_req_deferred(link, 1);
-		}
+		io_req_task_queue(de->req);
 		kfree(de);
 	} while (!list_empty(&ctx->defer_list));
 }


