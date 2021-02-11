Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90102318E7F
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhBKP2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:28:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230407AbhBKPYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:24:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0CFF64EDF;
        Thu, 11 Feb 2021 15:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055850;
        bh=e/SV40VPBlsUlwcHTzsHcKsnGW76XkUS6dZkh9sRgdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Um4zfSRdGEvDyQLhodWapjWmCqDJAbjxsnKMOvxnHgXra0+SM66a7D3iAqxyCe7hz
         KlxuVnuD3cuzRMObMXTE2q4vmEWkg/6wjlHVcXKtobgVGzIHzsL4ao+ZcFVAU0hbzL
         XSLjBYmub73wqHRXo9l2WTbJIzSf6MsaPSsYhj1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.10 04/54] io_uring: pass files into kill timeouts/poll
Date:   Thu, 11 Feb 2021 16:01:48 +0100
Message-Id: <20210211150153.078434896@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 6b81928d4ca8668513251f9c04cdcb9d38ef51c7 ]

Make io_poll_remove_all() and io_kill_timeouts() to match against files
as well. A preparation patch, effectively not used by now.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1508,14 +1508,15 @@ static bool io_task_match(struct io_kioc
 /*
  * Returns true if we found and killed one or more timeouts
  */
-static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk)
+static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
+			     struct files_struct *files)
 {
 	struct io_kiocb *req, *tmp;
 	int canceled = 0;
 
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
-		if (io_task_match(req, tsk)) {
+		if (io_match_task(req, tsk, files)) {
 			io_kill_timeout(req);
 			canceled++;
 		}
@@ -5312,7 +5313,8 @@ static bool io_poll_remove_one(struct io
 /*
  * Returns true if we found and killed one or more poll requests
  */
-static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk)
+static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
+			       struct files_struct *files)
 {
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
@@ -5324,7 +5326,7 @@ static bool io_poll_remove_all(struct io
 
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
-			if (io_task_match(req, tsk))
+			if (io_match_task(req, tsk, files))
 				posted += io_poll_remove_one(req);
 		}
 	}
@@ -8485,8 +8487,8 @@ static void io_ring_ctx_wait_and_kill(st
 		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	mutex_unlock(&ctx->uring_lock);
 
-	io_kill_timeouts(ctx, NULL);
-	io_poll_remove_all(ctx, NULL);
+	io_kill_timeouts(ctx, NULL, NULL);
+	io_poll_remove_all(ctx, NULL, NULL);
 
 	if (ctx->io_wq)
 		io_wq_cancel_cb(ctx->io_wq, io_cancel_ctx_cb, ctx, true);
@@ -8721,8 +8723,8 @@ static void __io_uring_cancel_task_reque
 			}
 		}
 
-		ret |= io_poll_remove_all(ctx, task);
-		ret |= io_kill_timeouts(ctx, task);
+		ret |= io_poll_remove_all(ctx, task, NULL);
+		ret |= io_kill_timeouts(ctx, task, NULL);
 		if (!ret)
 			break;
 		io_run_task_work();


