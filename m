Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5513533E3AF
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhCQA5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231260AbhCQA4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE42C64FA7;
        Wed, 17 Mar 2021 00:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942608;
        bh=+CwnKyllOnrKa6GKwufWTwtdhNse9QcWlCOa11yIUbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzB3UF37P6VKgKGYhzI8+Hq+qs4GiWpUC2lfz5VqnvQ+hIIQxoeV2ohu9a/VTFnLE
         BEDN19BCf206lLXjWUpOk3Y+FQDsvSCgEapAc3APF4lNNspcQZhCo7vzoFWta3Gz4H
         8AswIufCYRf9OUIDheivU1tmh0yF76++ZpjwEEgDSGHjDrQjxxGYKa/YsUwDHfQT6N
         yhP+Pxh31J5QczA0IgtWWOQKbn4ZVIQGEfpj8FOu0QCT5mdH/dfCZfpDF0kiXkdG5X
         h0dcADjO9Sdzeljrp7C8+vz3y26vXQoSP/Rkn/OJJyU+AUdLlhWTrO5oMaJigIugiM
         XdZpQ3/5ejh6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 58/61] io_uring: cancel deferred requests in try_cancel
Date:   Tue, 16 Mar 2021 20:55:32 -0400
Message-Id: <20210317005536.724046-58-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit e1915f76a8981f0a750cf56515df42582a37c4b0 ]

As io_uring_cancel_files() and others let SQO to run between
io_uring_try_cancel_requests(), SQO may generate new deferred requests,
so it's safer to try to cancel them in it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 241313278e5a..89708ffc1c2b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8848,11 +8848,11 @@ static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 	return ret;
 }
 
-static void io_cancel_defer_files(struct io_ring_ctx *ctx,
+static bool io_cancel_defer_files(struct io_ring_ctx *ctx,
 				  struct task_struct *task,
 				  struct files_struct *files)
 {
-	struct io_defer_entry *de = NULL;
+	struct io_defer_entry *de;
 	LIST_HEAD(list);
 
 	spin_lock_irq(&ctx->completion_lock);
@@ -8863,6 +8863,8 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 		}
 	}
 	spin_unlock_irq(&ctx->completion_lock);
+	if (list_empty(&list))
+		return false;
 
 	while (!list_empty(&list)) {
 		de = list_first_entry(&list, struct io_defer_entry, list);
@@ -8872,6 +8874,7 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 		io_req_complete(de->req, -ECANCELED);
 		kfree(de);
 	}
+	return true;
 }
 
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
@@ -8898,6 +8901,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 			}
 		}
 
+		ret |= io_cancel_defer_files(ctx, task, files);
 		ret |= io_poll_remove_all(ctx, task, files);
 		ret |= io_kill_timeouts(ctx, task, files);
 		ret |= io_run_task_work();
@@ -8976,8 +8980,6 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 		io_sq_thread_park(ctx->sq_data);
 	}
 
-	io_cancel_defer_files(ctx, task, files);
-
 	io_uring_cancel_files(ctx, task, files);
 	if (!files)
 		io_uring_try_cancel_requests(ctx, task, NULL);
-- 
2.30.1

