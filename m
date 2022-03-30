Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CDD4ECA63
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 19:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349205AbiC3RQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 13:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349203AbiC3RQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 13:16:10 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC6E387A3
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 10:14:25 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id 9so22390062iou.5
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 10:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IDpsEkElS2DGneoJEOSrfwppr49QLsb4g1ikE9IVb/4=;
        b=BBqIhsMa3+3h0LwcSR2yUT/+vsDOZhDb0ZI9KmABkZH1CcUS5uA1fXL9RQJTHY705j
         YP7so5EUhtvaqbqmXGFeORgAnNc2nY5GHgNmA7sXJsG7HnwDGEVqpjrIF6hocawRltjN
         Ne8Pi3cMSqY1jnD7Aesn8JEcippQl6BdLKiSlejPZqZTLhL2lmnHQDYXRzh8Tb6y6n0q
         YPaP+XE/wOC7JiVCWbpFZWhcacS4RcND+wXmvZffTPc/NRofj1pdAlPKiQKlD/79X66c
         W9qq9Z2Pkml2z9XaOufdTapYMBAHlPiG++2Zsuykzp/hkE+QblZ71U+rRa8tzX+DFONu
         HVkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IDpsEkElS2DGneoJEOSrfwppr49QLsb4g1ikE9IVb/4=;
        b=3t2787TY/PQlRpGvQ43i+/ptxkJ/mYwgljDAB0/jWwFKiFy/sdS9yXdXYG+lLobjWy
         goJfiuzxVNfxnkxGDWGW/n6+y2aHJX415SsMUTsM2aSwKj5hKmJJXOgBAJ+B3S94q5G6
         naStxXNcRdZeSZ8kyTFoeLr0G7fgedaKi4WYmOHCv8ToecyAk6sfzqsdqu5cMkUS4+td
         LX1tFY+WdhPJ6+YdoSCUr9Pu8C/MBqqsqAohmoMDzapw7aMMyuWifRfuO61MTX/Ndtrm
         okpWuZCpytqrutGyapd+ZHTytbg+q/bYE5X/ISCKhOH3/V4twOyziPgzQoLKBCDnR+8w
         Y9Ow==
X-Gm-Message-State: AOAM531r4iLAFDTkarbaW7eDaWrDBtXz6HnnD1Jfhx2ci7WxJqWGqqJp
        zRtWlC5VY6V47otVVZGK1amk3x6MUAxHdR5h
X-Google-Smtp-Source: ABdhPJxXZB1cyVaJCAquXtU6XEtRsgm0Yhp2FNZjTlAPfRiNxhvg6MeITPCrko7oB5yz9wl+tSme8A==
X-Received: by 2002:a5d:948a:0:b0:645:b742:87c0 with SMTP id v10-20020a5d948a000000b00645b74287c0mr11962326ioj.79.1648660464821;
        Wed, 30 Mar 2022 10:14:24 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b24-20020a5d8d98000000b006409ad493fbsm11588920ioj.21.2022.03.30.10.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 10:14:24 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 5/5] io_uring: defer file assignment for links
Date:   Wed, 30 Mar 2022 11:14:16 -0600
Message-Id: <20220330171416.152538-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220330171416.152538-1-axboe@kernel.dk>
References: <20220330171416.152538-1-axboe@kernel.dk>
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
 fs/io_uring.c | 43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 84433dc57914..e73e333d4705 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -915,7 +915,11 @@ struct io_kiocb {
 	unsigned int			flags;
 
 	u64				user_data;
-	u32				result;
+	/* fd before execution, if valid, result after execution */
+	union {
+		u32			result;
+		s32			fd;
+	};
 	u32				cflags;
 
 	struct io_ring_ctx		*ctx;
@@ -7208,6 +7212,23 @@ static void io_clean_op(struct io_kiocb *req)
 	req->flags &= ~IO_REQ_CLEAN_FLAGS;
 }
 
+static bool io_assign_file(struct io_kiocb *req)
+{
+	if (req->file || !io_op_defs[req->opcode].needs_file)
+		return true;
+
+	req->file = io_file_get(req->ctx, req, req->fd,
+					req->flags & REQ_F_FIXED_FILE);
+	if (req->file) {
+		req->result = 0;
+		return 0;
+	}
+
+	req_set_fail(req);
+	req->result = -EBADF;
+	return false;
+}
+
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 {
 	const struct cred *creds = NULL;
@@ -7218,6 +7239,8 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (!io_op_defs[req->opcode].audit_skip)
 		audit_uring_entry(req->opcode);
+	if (unlikely(!io_assign_file(req)))
+		return -EBADF;
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
@@ -7362,10 +7385,11 @@ static struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
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
@@ -7377,14 +7401,18 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
+	if (!io_assign_file(req)) {
+		work->flags |= IO_WQ_WORK_CANCEL;
+		err = -EBADF;
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
@@ -7720,6 +7748,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (io_op_defs[opcode].needs_file) {
 		struct io_submit_state *state = &ctx->submit_state;
 
+		req->fd = READ_ONCE(sqe->fd);
+
 		/*
 		 * Plug now if we have more than 2 IO left after this, and the
 		 * target is potentially a read/write to block based storage.
@@ -7729,11 +7759,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			state->need_plug = false;
 			blk_start_plug_nr_ios(&state->plug, state->submit_nr);
 		}
-
-		req->file = io_file_get(ctx, req, READ_ONCE(sqe->fd),
-					(sqe_flags & IOSQE_FIXED_FILE));
-		if (unlikely(!req->file))
-			return -EBADF;
 	}
 
 	personality = READ_ONCE(sqe->personality);
-- 
2.35.1

