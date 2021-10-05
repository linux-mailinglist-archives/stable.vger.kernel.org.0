Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8664228D6
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235810AbhJENyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:54:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235717AbhJENx0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:53:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C58F611F2;
        Tue,  5 Oct 2021 13:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441895;
        bh=+w/nfhy4vBx7ITifxhC1p8wHJQYh/36CYL4Ob9FMvHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PiuDtWSdLNusJY7U0PYI05FAdgxxfCOCf+9N1L60muVElEyQRAsiU2fnkiUVDEU3A
         fnkm70eECnxwoGFy8cNjAZfAMm40mwQfq7HePQD0EJmU5jsG5iejQb9fdDyfCBTRKM
         8UwxG0Z+Kb/1FzPSkCG5mFOAskGyMJBIk4rtzyX9dVXSMFixGe/lhrmxozYQrGjQFl
         VNPbC0FpjSndsz2T+xHekzlzU8Z3ph40pv5bEyrh9WtCqlKZNLeXsLrh1/iULiIuaK
         9qZzw9L36VE+csQRN7ZUpyOkyJB2ySF5+Hgr0GClMJNN+kuKeUwBvk1rs8hc5C1VGw
         8tTK0XHTdcrvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 39/40] io_uring: kill fasync
Date:   Tue,  5 Oct 2021 09:50:18 -0400
Message-Id: <20211005135020.214291-39-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 3f008385d46d3cea4a097d2615cd485f2184ba26 ]

We have never supported fasync properly, it would only fire when there
is something polling io_uring making it useless. The original support came
in through the initial io_uring merge for 5.1. Since it's broken and
nobody has reported it, get rid of the fasync bits.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/2f7ca3d344d406d34fa6713824198915c41cea86.1633080236.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 699a08d724c2..9d6c415ac97c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -419,7 +419,6 @@ struct io_ring_ctx {
 		struct wait_queue_head	cq_wait;
 		unsigned		cq_extra;
 		atomic_t		cq_timeouts;
-		struct fasync_struct	*cq_fasync;
 		unsigned		cq_last_tm_flush;
 	} ____cacheline_aligned_in_smp;
 
@@ -1448,10 +1447,8 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 		wake_up(&ctx->sq_data->wait);
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
-	if (waitqueue_active(&ctx->poll_wait)) {
+	if (waitqueue_active(&ctx->poll_wait))
 		wake_up_interruptible(&ctx->poll_wait);
-		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
-	}
 }
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
@@ -1465,10 +1462,8 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 	}
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
-	if (waitqueue_active(&ctx->poll_wait)) {
+	if (waitqueue_active(&ctx->poll_wait))
 		wake_up_interruptible(&ctx->poll_wait);
-		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
-	}
 }
 
 /* Returns true if there are no backlogged entries after the flush */
@@ -8777,13 +8772,6 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
-static int io_uring_fasync(int fd, struct file *file, int on)
-{
-	struct io_ring_ctx *ctx = file->private_data;
-
-	return fasync_helper(fd, file, on, &ctx->cq_fasync);
-}
-
 static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 {
 	const struct cred *creds;
@@ -9567,7 +9555,6 @@ static const struct file_operations io_uring_fops = {
 	.mmap_capabilities = io_uring_nommu_mmap_capabilities,
 #endif
 	.poll		= io_uring_poll,
-	.fasync		= io_uring_fasync,
 #ifdef CONFIG_PROC_FS
 	.show_fdinfo	= io_uring_show_fdinfo,
 #endif
-- 
2.33.0

