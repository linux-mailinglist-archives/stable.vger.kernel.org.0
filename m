Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6BAE681B
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732733AbfJ0VZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732731AbfJ0VZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:25:26 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B299621783;
        Sun, 27 Oct 2019 21:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211526;
        bh=Xaq/uGk6x+nPCvX23EmlOAsKEGWsLjTJVAEPN5co3bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWxE35C+JazvA9uap6H6YAocdZmoieKcS+r0T52mbfFPytSrn40uwCD/T7vDP1aVl
         yGkAix4O3jpckic7PV7jcvmkmghMJ4vXTR2i5SPXEm+IqsB0ure01HJHTIyQRMM84o
         PbXuYjxtc+I9upA87OvWQdWRmnc84tbqWCPZwwFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 138/197] io_uring: Fix broken links with offloading
Date:   Sun, 27 Oct 2019 22:00:56 +0100
Message-Id: <20191027203359.161001599@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit fb5ccc98782f654778cb8d96ba8a998304f9a51f ]

io_sq_thread() processes sqes by 8 without considering links. As a
result, links will be randomely subdivided.

The easiest way to fix it is to call io_get_sqring() inside
io_submit_sqes() as do io_ring_submit().

Downsides:
1. This removes optimisation of not grabbing mm_struct for fixed files
2. It submitting all sqes in one go, without finer-grained sheduling
with cq processing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 58 +++++++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 79f9c9f7b298e..518042cc6628b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -687,6 +687,14 @@ static unsigned io_cqring_events(struct io_cq_ring *ring)
 	return READ_ONCE(ring->r.tail) - READ_ONCE(ring->r.head);
 }
 
+static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
+{
+	struct io_sq_ring *ring = ctx->sq_ring;
+
+	/* make sure SQ entry isn't read before tail */
+	return smp_load_acquire(&ring->r.tail) - ctx->cached_sq_head;
+}
+
 /*
  * Find and free completed poll iocbs
  */
@@ -2268,8 +2276,8 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct sqe_submit *s)
 	return false;
 }
 
-static int io_submit_sqes(struct io_ring_ctx *ctx, struct sqe_submit *sqes,
-			  unsigned int nr, bool has_user, bool mm_fault)
+static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
+			  bool has_user, bool mm_fault)
 {
 	struct io_submit_state state, *statep = NULL;
 	struct io_kiocb *link = NULL;
@@ -2282,6 +2290,11 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, struct sqe_submit *sqes,
 	}
 
 	for (i = 0; i < nr; i++) {
+		struct sqe_submit s;
+
+		if (!io_get_sqring(ctx, &s))
+			break;
+
 		/*
 		 * If previous wasn't linked and we have a linked command,
 		 * that's the end of the chain. Submit the previous link.
@@ -2290,16 +2303,16 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, struct sqe_submit *sqes,
 			io_queue_sqe(ctx, link, &link->submit);
 			link = NULL;
 		}
-		prev_was_link = (sqes[i].sqe->flags & IOSQE_IO_LINK) != 0;
+		prev_was_link = (s.sqe->flags & IOSQE_IO_LINK) != 0;
 
 		if (unlikely(mm_fault)) {
-			io_cqring_add_event(ctx, sqes[i].sqe->user_data,
+			io_cqring_add_event(ctx, s.sqe->user_data,
 						-EFAULT);
 		} else {
-			sqes[i].has_user = has_user;
-			sqes[i].needs_lock = true;
-			sqes[i].needs_fixed_file = true;
-			io_submit_sqe(ctx, &sqes[i], statep, &link);
+			s.has_user = has_user;
+			s.needs_lock = true;
+			s.needs_fixed_file = true;
+			io_submit_sqe(ctx, &s, statep, &link);
 			submitted++;
 		}
 	}
@@ -2314,7 +2327,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, struct sqe_submit *sqes,
 
 static int io_sq_thread(void *data)
 {
-	struct sqe_submit sqes[IO_IOPOLL_BATCH];
 	struct io_ring_ctx *ctx = data;
 	struct mm_struct *cur_mm = NULL;
 	mm_segment_t old_fs;
@@ -2329,8 +2341,8 @@ static int io_sq_thread(void *data)
 
 	timeout = inflight = 0;
 	while (!kthread_should_park()) {
-		bool all_fixed, mm_fault = false;
-		int i;
+		bool mm_fault = false;
+		unsigned int to_submit;
 
 		if (inflight) {
 			unsigned nr_events = 0;
@@ -2363,7 +2375,8 @@ static int io_sq_thread(void *data)
 				timeout = jiffies + ctx->sq_thread_idle;
 		}
 
-		if (!io_get_sqring(ctx, &sqes[0])) {
+		to_submit = io_sqring_entries(ctx);
+		if (!to_submit) {
 			/*
 			 * We're polling. If we're within the defined idle
 			 * period, then let us spin without work before going
@@ -2394,7 +2407,8 @@ static int io_sq_thread(void *data)
 			/* make sure to read SQ tail after writing flags */
 			smp_mb();
 
-			if (!io_get_sqring(ctx, &sqes[0])) {
+			to_submit = io_sqring_entries(ctx);
+			if (!to_submit) {
 				if (kthread_should_park()) {
 					finish_wait(&ctx->sqo_wait, &wait);
 					break;
@@ -2412,19 +2426,8 @@ static int io_sq_thread(void *data)
 			ctx->sq_ring->flags &= ~IORING_SQ_NEED_WAKEUP;
 		}
 
-		i = 0;
-		all_fixed = true;
-		do {
-			if (all_fixed && io_sqe_needs_user(sqes[i].sqe))
-				all_fixed = false;
-
-			i++;
-			if (i == ARRAY_SIZE(sqes))
-				break;
-		} while (io_get_sqring(ctx, &sqes[i]));
-
 		/* Unless all new commands are FIXED regions, grab mm */
-		if (!all_fixed && !cur_mm) {
+		if (!cur_mm) {
 			mm_fault = !mmget_not_zero(ctx->sqo_mm);
 			if (!mm_fault) {
 				use_mm(ctx->sqo_mm);
@@ -2432,8 +2435,9 @@ static int io_sq_thread(void *data)
 			}
 		}
 
-		inflight += io_submit_sqes(ctx, sqes, i, cur_mm != NULL,
-						mm_fault);
+		to_submit = min(to_submit, ctx->sq_entries);
+		inflight += io_submit_sqes(ctx, to_submit, cur_mm != NULL,
+					   mm_fault);
 
 		/* Commit SQ ring head once we've consumed all SQEs */
 		io_commit_sqring(ctx);
-- 
2.20.1



