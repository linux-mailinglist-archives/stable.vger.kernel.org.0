Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E30B4F22DA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 08:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiDEGF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 02:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiDEGF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 02:05:26 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386F034696F
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 18:50:09 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id br1so3144412qvb.4
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 18:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T3BjVmkgGkYe/LU1hHhklubatEbKEtXNqcy81rt9YRA=;
        b=m/Sba10EVNLIwSJj3xtFzjAndau1a4zHsc7PRZKHPVrllAiiM4Ifpz8l8YYWHwF8EI
         sHAYy/igOupI/Wz2eXLHOvau6WF73Abgh3SxB0cbT7C2RwjqSWmDvmTTQdLoCsBTb2p2
         lomboAXcxH+trKC5rOE2y9sP2LfjToFWc7neFtt/hMReO2Qy1qediFBD2UJURg5sU2H9
         B2iPX9LvSuLf9mtC71uNCObCw0lHyTM/HLydst19GmBsurTgQXraescomEktla7dlkr8
         3/VQFx2Si+ff2HAR/DIrW3R9cvtZyJA6F5CVOzWnIZZ0H76qv85ab5AJi4YTfjoqBmO5
         eQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T3BjVmkgGkYe/LU1hHhklubatEbKEtXNqcy81rt9YRA=;
        b=4PTVau1SWw7PUuYy5OHG8TzLEITcipfCssnUEcZWVNiNLtqdhwDK0qN8KWYmEmqIT7
         NoRHjiKoYagYwJ4Hmrqn7nFcDyTgfveAwz3M/zBI3xGDjjUx92v4qVeV4egoNAuC4CLf
         NnKiLS3a3kF71/IcqxgdiGAQNDUG5AlCiWv5lkw4BTXAGv+LPDQo2pGNlcMTjbw4Nni+
         ESJIKd5HOilarX/yPKl9ntYVIrKiYnLbqueTAn95AMluxLDZQr9nfGo/XhgDyh/3c7uK
         OdnqShFKDV7gBysGlAxTdGpbnuM7tuysLC1DeFTsr7zGi4I9CWQp91a/a6rRMFoAf8ga
         EOaw==
X-Gm-Message-State: AOAM530HvzqCYVHzPySkRqBlyZGyOiQiTmuy+5kuXdVqYYibyRLuo277
        yJLhM3O2umz6GhriNbMoe1oA5cj/6RZ01w==
X-Google-Smtp-Source: ABdhPJwlP5ZCnhXlXjhvytiJKbS52SMei8/Di75c2J/1RH5sB8xbmSlqU46EcbNJQaBbEg8n035XaA==
X-Received: by 2002:a62:e215:0:b0:4fa:87f1:dc16 with SMTP id a21-20020a62e215000000b004fa87f1dc16mr665185pfi.19.1649116599216;
        Mon, 04 Apr 2022 16:56:39 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i7-20020a628707000000b004fa6eb33b02sm13157977pfe.49.2022.04.04.16.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 16:56:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 5/6] io_uring: defer file assignment
Date:   Mon,  4 Apr 2022 17:56:25 -0600
Message-Id: <20220404235626.374753-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404235626.374753-1-axboe@kernel.dk>
References: <20220404235626.374753-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If an application uses direct open or accept, it knows in advance what
direct descriptor value it will get as it picks it itself. This allows
combined requests such as:

sqe = io_uring_get_sqe(ring);
io_uring_prep_openat_direct(sqe, ..., file_slot);
sqe->flags |= IOSQE_IO_LINK | IOSQE_CQE_SKIP_SUCCESS;

sqe = io_uring_get_sqe(ring);
io_uring_prep_read(sqe,file_slot, buf, buf_size, 0);
sqe->flags |= IOSQE_FIXED_FILE;

io_uring_submit(ring);

where we prepare both a file open and read, and only get a completion
event for the read when both have completed successfully.

Currently links are fully prepared before the head is issued, but that
fails if the dependent link needs a file assigned that isn't valid until
the head has completed.

Conversely, if the same chain is performed but the fixed file slot is
already valid, then we would be unexpectedly returning data from the
old file slot rather than the newly opened one. Make sure we're
consistent here.

Allow deferral of file setup, which makes this documented case work.

Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.h    |  1 +
 fs/io_uring.c | 35 +++++++++++++++++++++++++++--------
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index dbecd27656c7..04d374e65e54 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -155,6 +155,7 @@ struct io_wq_work_node *wq_stack_extract(struct io_wq_work_node *stack)
 struct io_wq_work {
 	struct io_wq_work_node list;
 	unsigned flags;
+	int fd;
 };
 
 static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index d9b4b3a71a0f..c2118b07640b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7237,6 +7237,21 @@ static void io_clean_op(struct io_kiocb *req)
 	req->flags &= ~IO_REQ_CLEAN_FLAGS;
 }
 
+static bool io_assign_file(struct io_kiocb *req, bool locked)
+{
+	if (req->file || !io_op_defs[req->opcode].needs_file)
+		return true;
+
+	req->file = io_file_get(req->ctx, req, req->work.fd,
+					req->flags & REQ_F_FIXED_FILE, locked);
+	if (req->file)
+		return true;
+
+	req_set_fail(req);
+	req->result = -EBADF;
+	return false;
+}
+
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 {
 	const struct cred *creds = NULL;
@@ -7247,6 +7262,8 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (!io_op_defs[req->opcode].audit_skip)
 		audit_uring_entry(req->opcode);
+	if (unlikely(!io_assign_file(req, !(issue_flags & IO_URING_F_UNLOCKED))))
+		return -EBADF;
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
@@ -7391,10 +7408,11 @@ static struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
 static void io_wq_submit_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	const struct io_op_def *def = &io_op_defs[req->opcode];
 	unsigned int issue_flags = IO_URING_F_UNLOCKED;
 	bool needs_poll = false;
 	struct io_kiocb *timeout;
-	int ret = 0;
+	int ret = 0, err = -ECANCELED;
 
 	/* one will be dropped by ->io_free_work() after returning to io-wq */
 	if (!(req->flags & REQ_F_REFCOUNT))
@@ -7406,14 +7424,18 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
+	if (!io_assign_file(req, false)) {
+		err = -EBADF;
+		work->flags |= IO_WQ_WORK_CANCEL;
+	}
+
 	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
 	if (work->flags & IO_WQ_WORK_CANCEL) {
-		io_req_task_queue_fail(req, -ECANCELED);
+		io_req_task_queue_fail(req, err);
 		return;
 	}
 
 	if (req->flags & REQ_F_FORCE_ASYNC) {
-		const struct io_op_def *def = &io_op_defs[req->opcode];
 		bool opcode_poll = def->pollin || def->pollout;
 
 		if (opcode_poll && file_can_poll(req->file)) {
@@ -7751,6 +7773,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (io_op_defs[opcode].needs_file) {
 		struct io_submit_state *state = &ctx->submit_state;
 
+		req->work.fd = READ_ONCE(sqe->fd);
+
 		/*
 		 * Plug now if we have more than 2 IO left after this, and the
 		 * target is potentially a read/write to block based storage.
@@ -7760,11 +7784,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			state->need_plug = false;
 			blk_start_plug_nr_ios(&state->plug, state->submit_nr);
 		}
-
-		req->file = io_file_get(ctx, req, READ_ONCE(sqe->fd),
-					(sqe_flags & IOSQE_FIXED_FILE), true);
-		if (unlikely(!req->file))
-			return -EBADF;
 	}
 
 	personality = READ_ONCE(sqe->personality);
-- 
2.35.1

