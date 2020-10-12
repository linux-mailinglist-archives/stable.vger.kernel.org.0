Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C63228B723
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbgJLNk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731469AbgJLNk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:40:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03BE622248;
        Mon, 12 Oct 2020 13:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510034;
        bh=Js5TQrBU5xjWxXwRh0rRbCJpomXLgwXmvB1P/9kWGf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QuVYgwBdGDHPgw8STOI+/x8TfFjxbQs1g4yunqt7yfBg3WIQFrdgUI+e/hcXNz++/
         1CwMWTyZ/VCooZdtKDwc1yyvBm3KZymjeUzwhSpYTd0eTeECy7YyNe0a6ajUfizkTB
         dgD4frAkSd6QQ2U/kobp8n2wmLJBtPUrFZ+Iyz94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinyin Zhu <zhuyinyin@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 05/85] io_uring: Fix resource leaking when kill the process
Date:   Mon, 12 Oct 2020 15:26:28 +0200
Message-Id: <20201012132633.107723770@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yinyin Zhu <zhuyinyin@bytedance.com>

The commit

  1c4404efcf2c0> ("<io_uring: make sure async workqueue is canceled on exit>")

doesn't solve the resource leak problem totally! When kworker is doing a
io task for the io_uring, The process which submitted the io task has
received a SIGKILL signal from the user. Then the io_cancel_async_work
function could have sent a SIGINT signal to the kworker, but the judging
condition is wrong. So it doesn't send a SIGINT signal to the kworker,
then caused the resource leaking problem.

Why the juding condition is wrong? The process is a multi-threaded process,
we call the thread of the process which has submitted the io task Thread1.
So the req->task is the current macro of the Thread1. when all the threads
of the process have done exit procedure, the last thread will call the
io_cancel_async_work, but the last thread may not the Thread1, so the task
is not equal and doesn't send the SIGINT signal. To fix this bug, we alter
the task attribute of the req with struct files_struct. And check the files
instead.

Fixes: 1c4404efcf2c0 ("io_uring: make sure async workqueue is canceled on exit")
Signed-off-by: Yinyin Zhu <zhuyinyin@bytedance.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -340,7 +340,7 @@ struct io_kiocb {
 	u64			user_data;
 	u32			result;
 	u32			sequence;
-	struct task_struct	*task;
+	struct files_struct	*files;
 
 	struct fs_struct	*fs;
 
@@ -514,7 +514,7 @@ static inline void io_queue_async_work(s
 		}
 	}
 
-	req->task = current;
+	req->files = current->files;
 
 	spin_lock_irqsave(&ctx->task_lock, flags);
 	list_add(&req->task_list, &ctx->task_list);
@@ -2382,6 +2382,8 @@ static bool io_add_to_prev_work(struct a
 	if (ret) {
 		struct io_ring_ctx *ctx = req->ctx;
 
+		req->files = current->files;
+
 		spin_lock_irq(&ctx->task_lock);
 		list_add(&req->task_list, &ctx->task_list);
 		req->work_task = NULL;
@@ -3712,7 +3714,7 @@ static int io_uring_fasync(int fd, struc
 }
 
 static void io_cancel_async_work(struct io_ring_ctx *ctx,
-				 struct task_struct *task)
+				 struct files_struct *files)
 {
 	if (list_empty(&ctx->task_list))
 		return;
@@ -3724,7 +3726,7 @@ static void io_cancel_async_work(struct
 		req = list_first_entry(&ctx->task_list, struct io_kiocb, task_list);
 		list_del_init(&req->task_list);
 		req->flags |= REQ_F_CANCEL;
-		if (req->work_task && (!task || req->task == task))
+		if (req->work_task && (!files || req->files == files))
 			send_sig(SIGINT, req->work_task, 1);
 	}
 	spin_unlock_irq(&ctx->task_lock);
@@ -3749,7 +3751,7 @@ static int io_uring_flush(struct file *f
 	struct io_ring_ctx *ctx = file->private_data;
 
 	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
-		io_cancel_async_work(ctx, current);
+		io_cancel_async_work(ctx, data);
 
 	return 0;
 }


