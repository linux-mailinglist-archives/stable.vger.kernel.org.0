Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7AA4FD97D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347480AbiDLHUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351689AbiDLHMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA48C29830;
        Mon, 11 Apr 2022 23:51:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 36656CE1C09;
        Tue, 12 Apr 2022 06:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9D7C385A6;
        Tue, 12 Apr 2022 06:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746265;
        bh=LrO/NPznNV1aounXGisBxWbAil2ax0fJhHmdqmv6spY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTQWHqVxF+I24X1oef0toaMtwQ+WAX3vE25Eem6sT1Fy5atbD3kk7kbUCAaS0tHry
         DA8+RaBOksS/2sa9XEdvgh5OxSSgQnzde0/dzm7HS1irya/82l/3HIoKC+jQLITpxt
         +Bh+9JrAa8kSbgRaefp0PWhF3d8gO14am3wx+I8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 219/277] io_uring: defer splice/tee file validity check until command issue
Date:   Tue, 12 Apr 2022 08:30:22 +0200
Message-Id: <20220412062948.379725655@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

commit a3e4bc23d5470b2beb7cc42a86b6a3e75b704c15 upstream.

In preparation for not using the file at prep time, defer checking if this
file refers to a valid io_uring instance until issue time.

This also means we can get rid of the cleanup flag for splice and tee.

Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   49 +++++++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -623,10 +623,10 @@ struct io_epoll {
 
 struct io_splice {
 	struct file			*file_out;
-	struct file			*file_in;
 	loff_t				off_out;
 	loff_t				off_in;
 	u64				len;
+	int				splice_fd_in;
 	unsigned int			flags;
 };
 
@@ -1452,14 +1452,6 @@ static void io_prep_async_work(struct io
 		if (def->unbound_nonreg_file)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
-
-	switch (req->opcode) {
-	case IORING_OP_SPLICE:
-	case IORING_OP_TEE:
-		if (!S_ISREG(file_inode(req->splice.file_in)->i_mode))
-			req->work.flags |= IO_WQ_WORK_UNBOUND;
-		break;
-	}
 }
 
 static void io_prep_async_link(struct io_kiocb *req)
@@ -4027,18 +4019,11 @@ static int __io_splice_prep(struct io_ki
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
-	sp->file_in = NULL;
 	sp->len = READ_ONCE(sqe->len);
 	sp->flags = READ_ONCE(sqe->splice_flags);
-
 	if (unlikely(sp->flags & ~valid_flags))
 		return -EINVAL;
-
-	sp->file_in = io_file_get(req->ctx, req, READ_ONCE(sqe->splice_fd_in),
-				  (sp->flags & SPLICE_F_FD_IN_FIXED));
-	if (!sp->file_in)
-		return -EBADF;
-	req->flags |= REQ_F_NEED_CLEANUP;
+	sp->splice_fd_in = READ_ONCE(sqe->splice_fd_in);
 	return 0;
 }
 
@@ -4053,20 +4038,27 @@ static int io_tee_prep(struct io_kiocb *
 static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_splice *sp = &req->splice;
-	struct file *in = sp->file_in;
 	struct file *out = sp->file_out;
 	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
+	struct file *in;
 	long ret = 0;
 
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
+
+	in = io_file_get(req->ctx, req, sp->splice_fd_in,
+				  (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (!in) {
+		ret = -EBADF;
+		goto done;
+	}
+
 	if (sp->len)
 		ret = do_tee(in, out, sp->len, flags);
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
 		io_put_file(in);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-
+done:
 	if (ret != sp->len)
 		req_set_fail(req);
 	io_req_complete(req, ret);
@@ -4085,15 +4077,22 @@ static int io_splice_prep(struct io_kioc
 static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_splice *sp = &req->splice;
-	struct file *in = sp->file_in;
 	struct file *out = sp->file_out;
 	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
 	loff_t *poff_in, *poff_out;
+	struct file *in;
 	long ret = 0;
 
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
+	in = io_file_get(req->ctx, req, sp->splice_fd_in,
+				  (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (!in) {
+		ret = -EBADF;
+		goto done;
+	}
+
 	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
 	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
 
@@ -4102,8 +4101,7 @@ static int io_splice(struct io_kiocb *re
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
 		io_put_file(in);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-
+done:
 	if (ret != sp->len)
 		req_set_fail(req);
 	io_req_complete(req, ret);
@@ -6649,11 +6647,6 @@ static void io_clean_op(struct io_kiocb
 			kfree(io->free_iov);
 			break;
 			}
-		case IORING_OP_SPLICE:
-		case IORING_OP_TEE:
-			if (!(req->splice.flags & SPLICE_F_FD_IN_FIXED))
-				io_put_file(req->splice.file_in);
-			break;
 		case IORING_OP_OPENAT:
 		case IORING_OP_OPENAT2:
 			if (req->open.filename)


