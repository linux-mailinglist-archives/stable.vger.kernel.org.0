Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0EA4318DFF
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhBKPTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:19:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:52050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229994AbhBKPNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:13:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FA9A64EE0;
        Thu, 11 Feb 2021 15:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055854;
        bh=gkjjU0cWn6r6mUnqxWF0zNwercMq0Vi2f+VeWqVeNkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sv8X69y4nkCg9uV0NJpVq1p5jcRD9VwTqem0FIUiUoMlLvy93OdT0jwuMp4y2dzmY
         0PZYsO+knQcM01bhQ2voMghz+NiyAB2yIX+euOsfXrOfmjTSNaenVo7/6+/FP0znY3
         +c+xH9w+F4DTb7uBHY3MB9gLGqx45615xLYL4d9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot+c0d52d0b3c0c3ffb9525@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 06/54] io_uring: fix files cancellation
Date:   Thu, 11 Feb 2021 16:01:50 +0100
Message-Id: <20210211150153.157105213@linuxfoundation.org>
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

[ Upstream commit bee749b187ac57d1faf00b2ab356ff322230fce8 ]

io_uring_cancel_files()'s task check condition mistakenly got flipped.

1. There can't be a request in the inflight list without
IO_WQ_WORK_FILES, kill this check to keep the whole condition simpler.
2. Also, don't call the function for files==NULL to not do such a check,
all that staff is already handled well by its counter part,
__io_uring_cancel_task_requests().

With that just flip the task check.

Also, it iowq-cancels all request of current task there, don't forget to
set right ->files into struct io_task_cancel.

Fixes: c1973b38bf639 ("io_uring: cancel only requests of current task")
Reported-by: syzbot+c0d52d0b3c0c3ffb9525@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8571,15 +8571,14 @@ static void io_uring_cancel_files(struct
 				  struct files_struct *files)
 {
 	while (!list_empty_careful(&ctx->inflight_list)) {
-		struct io_task_cancel cancel = { .task = task, .files = NULL, };
+		struct io_task_cancel cancel = { .task = task, .files = files };
 		struct io_kiocb *req;
 		DEFINE_WAIT(wait);
 		bool found = false;
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
-			if (req->task == task &&
-			    (req->work.flags & IO_WQ_WORK_FILES) &&
+			if (req->task != task ||
 			    req->work.identity->files != files)
 				continue;
 			found = true;
@@ -8665,10 +8664,11 @@ static void io_uring_cancel_task_request
 
 	io_cancel_defer_files(ctx, task, files);
 	io_cqring_overflow_flush(ctx, true, task, files);
-	io_uring_cancel_files(ctx, task, files);
 
 	if (!files)
 		__io_uring_cancel_task_requests(ctx, task);
+	else
+		io_uring_cancel_files(ctx, task, files);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);


