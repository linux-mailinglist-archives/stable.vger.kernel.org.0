Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9691CF369
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 13:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbgELLeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 07:34:24 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:43583 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726187AbgELLeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 07:34:24 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id B364069A;
        Tue, 12 May 2020 07:34:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 12 May 2020 07:34:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=oVQFp9
        8VFky8z6gR1MDGDw7cRU+U+hAi9wsmC57ix7A=; b=HhJznCl8/92kl3TZ8Ctva7
        K0/5NCHH9viq+zkF06fg3Li9M7myB7dwQ1BYxuHxd4adrvu1lc7Bfy6fDetYOlw6
        o3M/zizZf0xSkOOuFT9BFPAinEPZqnGSU5hMulxq0n1kAg41OONzEVF+tMBRCkuV
        XM/uvdOL/X//WF2xC41Q/G9pnkJpaddJ1cEz72VYwwyvescFjstizwGAO3lc5lkU
        805eeAm8TLDCcoj9ssYr9RhtGWA7Wr5PRtMSOjsVJXGyliXCJprVhXOSmekcpdu8
        d2OD20aAnxGQHyufIlnq9WUrirfYLImGZs5nvHKkQDl1wi9p5acxGNvLvabW+XuA
        ==
X-ME-Sender: <xms:vom6Xvjtot2Fb2DGAl7isKLvKpeEjres9J6hVWHGaxcgwFjnfDOaOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrledvgdeflecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:v4m6XsA-wnh69NbJEsUChy4YN0AQkbhsb1yRmCQWRo9TSaAbpNmYhQ>
    <xmx:v4m6XvGPdT-PT7Ne4_00Vski_AOYhgrhdxDDWN2hZHNtuFALbxb52Q>
    <xmx:v4m6XsQ7cJkruVyMaS10OeGT8GF7zuAWc6FlApTf4MLsDSslzhCEjQ>
    <xmx:v4m6XpuJh_d2uq2F65XkC5tvauJJWbjN_3VjoCYKoJ0eC5nNI1wRNVGtSIQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B27093280063;
        Tue, 12 May 2020 07:34:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: don't use 'fd' for openat/openat2/statx" failed to apply to 5.6-stable tree
To:     axboe@kernel.dk, mk@cm4all.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 12 May 2020 13:34:21 +0200
Message-ID: <1589283261161116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 63ff822358b276137059520cf16e587e8073e80f Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 7 May 2020 14:56:15 -0600
Subject: [PATCH] io_uring: don't use 'fd' for openat/openat2/statx

We currently make some guesses as when to open this fd, but in reality
we have no business (or need) to do so at all. In fact, it makes certain
things fail, like O_PATH.

Remove the fd lookup from these opcodes, we're just passing the 'fd' to
generic helpers anyway. With that, we can also remove the special casing
of fd values in io_req_needs_file(), and the 'fd_non_neg' check that
we have. And we can ensure that we only read sqe->fd once.

This fixes O_PATH usage with openat/openat2, and ditto statx path side
oddities.

Cc: stable@vger.kernel.org: # v5.6
Reported-by: Max Kellermann <mk@cm4all.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dd680eb153cb..979d9f977409 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -680,8 +680,6 @@ struct io_op_def {
 	unsigned		needs_mm : 1;
 	/* needs req->file assigned */
 	unsigned		needs_file : 1;
-	/* needs req->file assigned IFF fd is >= 0 */
-	unsigned		fd_non_neg : 1;
 	/* hash wq insertion if file is a regular file */
 	unsigned		hash_reg_file : 1;
 	/* unbound wq insertion if file is a non-regular file */
@@ -784,8 +782,6 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 	},
 	[IORING_OP_OPENAT] = {
-		.needs_file		= 1,
-		.fd_non_neg		= 1,
 		.file_table		= 1,
 		.needs_fs		= 1,
 	},
@@ -799,8 +795,6 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_STATX] = {
 		.needs_mm		= 1,
-		.needs_file		= 1,
-		.fd_non_neg		= 1,
 		.needs_fs		= 1,
 		.file_table		= 1,
 	},
@@ -837,8 +831,6 @@ static const struct io_op_def io_op_defs[] = {
 		.buffer_select		= 1,
 	},
 	[IORING_OP_OPENAT2] = {
-		.needs_file		= 1,
-		.fd_non_neg		= 1,
 		.file_table		= 1,
 		.needs_fs		= 1,
 	},
@@ -5368,15 +5360,6 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 	io_steal_work(req, workptr);
 }
 
-static int io_req_needs_file(struct io_kiocb *req, int fd)
-{
-	if (!io_op_defs[req->opcode].needs_file)
-		return 0;
-	if ((fd == -1 || fd == AT_FDCWD) && io_op_defs[req->opcode].fd_non_neg)
-		return 0;
-	return 1;
-}
-
 static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
 					      int index)
 {
@@ -5414,14 +5397,11 @@ static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 }
 
 static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
-			   int fd, unsigned int flags)
+			   int fd)
 {
 	bool fixed;
 
-	if (!io_req_needs_file(req, fd))
-		return 0;
-
-	fixed = (flags & IOSQE_FIXED_FILE);
+	fixed = (req->flags & REQ_F_FIXED_FILE) != 0;
 	if (unlikely(!fixed && req->needs_fixed_file))
 		return -EBADF;
 
@@ -5798,7 +5778,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		       struct io_submit_state *state, bool async)
 {
 	unsigned int sqe_flags;
-	int id, fd;
+	int id;
 
 	/*
 	 * All io need record the previous position, if LINK vs DARIN,
@@ -5850,8 +5830,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 					IOSQE_ASYNC | IOSQE_FIXED_FILE |
 					IOSQE_BUFFER_SELECT | IOSQE_IO_LINK);
 
-	fd = READ_ONCE(sqe->fd);
-	return io_req_set_file(state, req, fd, sqe_flags);
+	if (!io_op_defs[req->opcode].needs_file)
+		return 0;
+
+	return io_req_set_file(state, req, READ_ONCE(sqe->fd));
 }
 
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,

