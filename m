Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDB74FD6D3
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347702AbiDLHwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359407AbiDLHnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:43:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1602CE0E;
        Tue, 12 Apr 2022 00:22:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBF25B81B60;
        Tue, 12 Apr 2022 07:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60863C385A1;
        Tue, 12 Apr 2022 07:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748163;
        bh=Qylrq82K99+XKXRELwVPYJ9RsHk08S1/WZzK/wRPeEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dB5/vjq21MwTDHBIqwomgo/HBOTB3Vf4nInJrVx5UzDjvw0OS3hkzd+DOBy4Ej0dJ
         PbJ5xrd6SQTxdEH9eH3uVRlzO3f0QgqhYiHGhqlgktUSW37zZQfVXZrX9ErrjlDJGG
         eXJr+QX/UNfOdCnW6J9oeXpmI1PaZIyIx6ELJhmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 342/343] io_uring: defer file assignment
Date:   Tue, 12 Apr 2022 08:32:40 +0200
Message-Id: <20220412063001.185808860@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 6bf9c47a398911e0ab920e362115153596c80432 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io-wq.h    |    1 +
 fs/io_uring.c |   39 +++++++++++++++++++++++++++++----------
 2 files changed, 30 insertions(+), 10 deletions(-)

--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -155,6 +155,7 @@ struct io_wq_work_node *wq_stack_extract
 struct io_wq_work {
 	struct io_wq_work_node list;
 	unsigned flags;
+	int fd;
 };
 
 static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6745,6 +6745,23 @@ static void io_clean_op(struct io_kiocb
 	req->flags &= ~IO_REQ_CLEAN_FLAGS;
 }
 
+static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
+{
+	if (req->file || !io_op_defs[req->opcode].needs_file)
+		return true;
+
+	if (req->flags & REQ_F_FIXED_FILE)
+		req->file = io_file_get_fixed(req, req->work.fd, issue_flags);
+	else
+		req->file = io_file_get_normal(req, req->work.fd);
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
@@ -6755,6 +6772,8 @@ static int io_issue_sqe(struct io_kiocb
 
 	if (!io_op_defs[req->opcode].audit_skip)
 		audit_uring_entry(req->opcode);
+	if (unlikely(!io_assign_file(req, issue_flags)))
+		return -EBADF;
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
@@ -6896,10 +6915,11 @@ static struct io_wq_work *io_wq_free_wor
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
@@ -6911,14 +6931,18 @@ static void io_wq_submit_work(struct io_
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
+	if (!io_assign_file(req, issue_flags)) {
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
@@ -7249,6 +7273,8 @@ static int io_init_req(struct io_ring_ct
 	if (io_op_defs[opcode].needs_file) {
 		struct io_submit_state *state = &ctx->submit_state;
 
+		req->work.fd = READ_ONCE(sqe->fd);
+
 		/*
 		 * Plug now if we have more than 2 IO left after this, and the
 		 * target is potentially a read/write to block based storage.
@@ -7258,13 +7284,6 @@ static int io_init_req(struct io_ring_ct
 			state->need_plug = false;
 			blk_start_plug_nr_ios(&state->plug, state->submit_nr);
 		}
-
-		if (req->flags & REQ_F_FIXED_FILE)
-			req->file = io_file_get_fixed(req, READ_ONCE(sqe->fd), 0);
-		else
-			req->file = io_file_get_normal(req, READ_ONCE(sqe->fd));
-		if (unlikely(!req->file))
-			return -EBADF;
 	}
 
 	personality = READ_ONCE(sqe->personality);


