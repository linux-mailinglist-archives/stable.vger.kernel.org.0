Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D558B15765E
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbgBJMmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:42:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730175AbgBJMmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:42:11 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DC7821739;
        Mon, 10 Feb 2020 12:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338530;
        bh=AyQSEYvegNu1Fb7bnvoK/WzAV6v/dvNilSNKqB61r44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UupmilbBJkXFkjshMj9XL+uvSFQA3gSD630F1WGVAgxVwiJPmL038nLvYdVYMysga
         0P0CX9ua3JHO1Eb3ZH0E6ALv1vL345jhXblAVbl01ct9gSa23w6PAQCJjZpaL2XlBQ
         VxPqdtxPmc2MqzBECib+EgiN1aifNMGYScMPd4vc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mark Papadakis <markuspapadakis@icloud.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 354/367] io_uring: enable option to only trigger eventfd for async completions
Date:   Mon, 10 Feb 2020 04:34:27 -0800
Message-Id: <20200210122455.155382765@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f2842ab5b72d7ee5f7f8385c2d4f32c133f5837b ]

If an application is using eventfd notifications with poll to know when
new SQEs can be issued, it's expecting the following read/writes to
complete inline. And with that, it knows that there are events available,
and don't want spurious wakeups on the eventfd for those requests.

This adds IORING_REGISTER_EVENTFD_ASYNC, which works just like
IORING_REGISTER_EVENTFD, except it only triggers notifications for events
that happen from async completions (IRQ, or io-wq worker completions).
Any completions inline from the submission itself will not trigger
notifications.

Suggested-by: Mark Papadakis <markuspapadakis@icloud.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c                 | 17 ++++++++++++++++-
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 95fc5c5a85968..131087782bec9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -188,6 +188,7 @@ struct io_ring_ctx {
 		bool			account_mem;
 		bool			cq_overflow_flushed;
 		bool			drain_next;
+		bool			eventfd_async;
 
 		/*
 		 * Ring buffer of indices into array of io_uring_sqe, which is
@@ -735,13 +736,20 @@ static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 	return &rings->cqes[tail & ctx->cq_mask];
 }
 
+static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
+{
+	if (!ctx->eventfd_async)
+		return true;
+	return io_wq_current_is_worker() || in_interrupt();
+}
+
 static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 	if (waitqueue_active(&ctx->sqo_wait))
 		wake_up(&ctx->sqo_wait);
-	if (ctx->cq_ev_fd)
+	if (ctx->cq_ev_fd && io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
 }
 
@@ -5486,10 +5494,17 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = io_sqe_files_update(ctx, arg, nr_args);
 		break;
 	case IORING_REGISTER_EVENTFD:
+	case IORING_REGISTER_EVENTFD_ASYNC:
 		ret = -EINVAL;
 		if (nr_args != 1)
 			break;
 		ret = io_eventfd_register(ctx, arg);
+		if (ret)
+			break;
+		if (opcode == IORING_REGISTER_EVENTFD_ASYNC)
+			ctx->eventfd_async = 1;
+		else
+			ctx->eventfd_async = 0;
 		break;
 	case IORING_UNREGISTER_EVENTFD:
 		ret = -EINVAL;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 55cfcb71606db..88693fed2c4b4 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -175,6 +175,7 @@ struct io_uring_params {
 #define IORING_REGISTER_EVENTFD		4
 #define IORING_UNREGISTER_EVENTFD	5
 #define IORING_REGISTER_FILES_UPDATE	6
+#define IORING_REGISTER_EVENTFD_ASYNC	7
 
 struct io_uring_files_update {
 	__u32 offset;
-- 
2.20.1



