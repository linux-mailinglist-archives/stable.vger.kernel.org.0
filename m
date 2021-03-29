Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B7A34C9D3
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhC2Id5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234424AbhC2IdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 296BB6196F;
        Mon, 29 Mar 2021 08:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006700;
        bh=+udfzFjqFFO2JcOYBj1aQkxXltHi8KMwJRaCMQ1erek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CosklNXgDhgzSlRi0er+XQF9pFXsCLj/VrYzSONEVmh3a5OKfcrzRloM8mCfuAy2P
         kuXD0UjaQhxZRMqY9oIrStlTjd3/JqtIn6epKk9GkJgS2k8iQoRsJ/8qQo7u+eMRf3
         fxui6uUTPSm9Z0tsWVK6EbiLJeeRm/3L0AwqT5iA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 058/254] io_uring: cancel deferred requests in try_cancel
Date:   Mon, 29 Mar 2021 09:56:14 +0200
Message-Id: <20210329075635.080522123@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ef078182e7ca..c3cfaa367138 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8861,11 +8861,11 @@ static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
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
@@ -8876,6 +8876,8 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 		}
 	}
 	spin_unlock_irq(&ctx->completion_lock);
+	if (list_empty(&list))
+		return false;
 
 	while (!list_empty(&list)) {
 		de = list_first_entry(&list, struct io_defer_entry, list);
@@ -8885,6 +8887,7 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 		io_req_complete(de->req, -ECANCELED);
 		kfree(de);
 	}
+	return true;
 }
 
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
@@ -8912,6 +8915,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 			}
 		}
 
+		ret |= io_cancel_defer_files(ctx, task, files);
 		ret |= io_poll_remove_all(ctx, task, files);
 		ret |= io_kill_timeouts(ctx, task, files);
 		ret |= io_run_task_work();
@@ -8992,8 +8996,6 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 		io_sq_thread_park(ctx->sq_data);
 	}
 
-	io_cancel_defer_files(ctx, task, files);
-
 	io_uring_cancel_files(ctx, task, files);
 	if (!files)
 		io_uring_try_cancel_requests(ctx, task, NULL);
-- 
2.30.1



