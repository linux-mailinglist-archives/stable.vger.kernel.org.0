Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDE4594890
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239606AbiHOXLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353048AbiHOXKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:10:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2398768D;
        Mon, 15 Aug 2022 13:00:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCD5BB80EAD;
        Mon, 15 Aug 2022 19:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0711BC433D6;
        Mon, 15 Aug 2022 19:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593598;
        bh=VfIR43MIeNQHB6wAy90NxPLlLzEU7ZpOOBFLTwYX8/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHyTzYYsSBwgctD7x9OSwko8lKXL1RjAuovQ9ojRIDFB+7AM8ki9p1adNivcVi3pn
         KBu6B6+N3It6YbnhiZAbk2hACuHrONxYsHDPJ3U7OBSGMELtF6YUC7HEwaqw7TWPvZ
         QeOYeEI31/3STiIA0ZDJwQ08okp4UAU0BWB7xeA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0294/1157] io_uring: define a prep and issue handler for each opcode
Date:   Mon, 15 Aug 2022 19:54:10 +0200
Message-Id: <20220815180451.391660601@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 0702e5364f643bc86683d9f585edfe76dbabae39 ]

Rather than have two giant switches for doing request preparation and
then for doing request issue, add a prep and issue handler for each
of them in the io_op_defs[] request definition.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 838 +++++++++++++++++++-------------------------
 1 file changed, 365 insertions(+), 473 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b63956975109..f429b68d1fc2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1110,231 +1110,13 @@ struct io_op_def {
 	unsigned		iopoll : 1;
 	/* size of async data needed, if any */
 	unsigned short		async_size;
-};
 
-static const struct io_op_def io_op_defs[] = {
-	[IORING_OP_NOP] = {
-		.audit_skip		= 1,
-		.iopoll			= 1,
-	},
-	[IORING_OP_READV] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollin			= 1,
-		.buffer_select		= 1,
-		.needs_async_setup	= 1,
-		.plug			= 1,
-		.audit_skip		= 1,
-		.ioprio			= 1,
-		.iopoll			= 1,
-		.async_size		= sizeof(struct io_async_rw),
-	},
-	[IORING_OP_WRITEV] = {
-		.needs_file		= 1,
-		.hash_reg_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollout		= 1,
-		.needs_async_setup	= 1,
-		.plug			= 1,
-		.audit_skip		= 1,
-		.ioprio			= 1,
-		.iopoll			= 1,
-		.async_size		= sizeof(struct io_async_rw),
-	},
-	[IORING_OP_FSYNC] = {
-		.needs_file		= 1,
-		.audit_skip		= 1,
-	},
-	[IORING_OP_READ_FIXED] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollin			= 1,
-		.plug			= 1,
-		.audit_skip		= 1,
-		.ioprio			= 1,
-		.iopoll			= 1,
-		.async_size		= sizeof(struct io_async_rw),
-	},
-	[IORING_OP_WRITE_FIXED] = {
-		.needs_file		= 1,
-		.hash_reg_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollout		= 1,
-		.plug			= 1,
-		.audit_skip		= 1,
-		.ioprio			= 1,
-		.iopoll			= 1,
-		.async_size		= sizeof(struct io_async_rw),
-	},
-	[IORING_OP_POLL_ADD] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.audit_skip		= 1,
-	},
-	[IORING_OP_POLL_REMOVE] = {
-		.audit_skip		= 1,
-	},
-	[IORING_OP_SYNC_FILE_RANGE] = {
-		.needs_file		= 1,
-		.audit_skip		= 1,
-	},
-	[IORING_OP_SENDMSG] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollout		= 1,
-		.needs_async_setup	= 1,
-		.ioprio			= 1,
-		.async_size		= sizeof(struct io_async_msghdr),
-	},
-	[IORING_OP_RECVMSG] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollin			= 1,
-		.buffer_select		= 1,
-		.needs_async_setup	= 1,
-		.ioprio			= 1,
-		.async_size		= sizeof(struct io_async_msghdr),
-	},
-	[IORING_OP_TIMEOUT] = {
-		.audit_skip		= 1,
-		.async_size		= sizeof(struct io_timeout_data),
-	},
-	[IORING_OP_TIMEOUT_REMOVE] = {
-		/* used by timeout updates' prep() */
-		.audit_skip		= 1,
-	},
-	[IORING_OP_ACCEPT] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollin			= 1,
-		.poll_exclusive		= 1,
-		.ioprio			= 1,	/* used for flags */
-	},
-	[IORING_OP_ASYNC_CANCEL] = {
-		.audit_skip		= 1,
-	},
-	[IORING_OP_LINK_TIMEOUT] = {
-		.audit_skip		= 1,
-		.async_size		= sizeof(struct io_timeout_data),
-	},
-	[IORING_OP_CONNECT] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollout		= 1,
-		.needs_async_setup	= 1,
-		.async_size		= sizeof(struct io_async_connect),
-	},
-	[IORING_OP_FALLOCATE] = {
-		.needs_file		= 1,
-	},
-	[IORING_OP_OPENAT] = {},
-	[IORING_OP_CLOSE] = {},
-	[IORING_OP_FILES_UPDATE] = {
-		.audit_skip		= 1,
-		.iopoll			= 1,
-	},
-	[IORING_OP_STATX] = {
-		.audit_skip		= 1,
-	},
-	[IORING_OP_READ] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollin			= 1,
-		.buffer_select		= 1,
-		.plug			= 1,
-		.audit_skip		= 1,
-		.ioprio			= 1,
-		.iopoll			= 1,
-		.async_size		= sizeof(struct io_async_rw),
-	},
-	[IORING_OP_WRITE] = {
-		.needs_file		= 1,
-		.hash_reg_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollout		= 1,
-		.plug			= 1,
-		.audit_skip		= 1,
-		.ioprio			= 1,
-		.iopoll			= 1,
-		.async_size		= sizeof(struct io_async_rw),
-	},
-	[IORING_OP_FADVISE] = {
-		.needs_file		= 1,
-		.audit_skip		= 1,
-	},
-	[IORING_OP_MADVISE] = {},
-	[IORING_OP_SEND] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollout		= 1,
-		.audit_skip		= 1,
-		.ioprio			= 1,
-	},
-	[IORING_OP_RECV] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollin			= 1,
-		.buffer_select		= 1,
-		.audit_skip		= 1,
-		.ioprio			= 1,
-	},
-	[IORING_OP_OPENAT2] = {
-	},
-	[IORING_OP_EPOLL_CTL] = {
-		.unbound_nonreg_file	= 1,
-		.audit_skip		= 1,
-	},
-	[IORING_OP_SPLICE] = {
-		.needs_file		= 1,
-		.hash_reg_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.audit_skip		= 1,
-	},
-	[IORING_OP_PROVIDE_BUFFERS] = {
-		.audit_skip		= 1,
-		.iopoll			= 1,
-	},
-	[IORING_OP_REMOVE_BUFFERS] = {
-		.audit_skip		= 1,
-		.iopoll			= 1,
-	},
-	[IORING_OP_TEE] = {
-		.needs_file		= 1,
-		.hash_reg_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.audit_skip		= 1,
-	},
-	[IORING_OP_SHUTDOWN] = {
-		.needs_file		= 1,
-	},
-	[IORING_OP_RENAMEAT] = {},
-	[IORING_OP_UNLINKAT] = {},
-	[IORING_OP_MKDIRAT] = {},
-	[IORING_OP_SYMLINKAT] = {},
-	[IORING_OP_LINKAT] = {},
-	[IORING_OP_MSG_RING] = {
-		.needs_file		= 1,
-		.iopoll			= 1,
-	},
-	[IORING_OP_FSETXATTR] = {
-		.needs_file = 1
-	},
-	[IORING_OP_SETXATTR] = {},
-	[IORING_OP_FGETXATTR] = {
-		.needs_file = 1
-	},
-	[IORING_OP_GETXATTR] = {},
-	[IORING_OP_SOCKET] = {
-		.audit_skip		= 1,
-	},
-	[IORING_OP_URING_CMD] = {
-		.needs_file		= 1,
-		.plug			= 1,
-		.needs_async_setup	= 1,
-		.async_size		= uring_cmd_pdu_size(1),
-	},
+	int (*prep)(struct io_kiocb *, const struct io_uring_sqe *);
+	int (*issue)(struct io_kiocb *, unsigned int);
 };
 
+static const struct io_op_def io_op_defs[];
+
 /* requests with any of those set should undergo io_disarm_next() */
 #define IO_DISARM_MASK (REQ_F_ARM_LTIMEOUT | REQ_F_LINK_TIMEOUT | REQ_F_FAIL)
 #define IO_REQ_LINK_FLAGS (REQ_F_LINK | REQ_F_HARDLINK)
@@ -8039,96 +7821,33 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_req_prep_async(struct io_kiocb *req)
 {
+	const struct io_op_def *def = &io_op_defs[req->opcode];
+
+	/* assign early for deferred execution for non-fixed file */
+	if (def->needs_file && !(req->flags & REQ_F_FIXED_FILE))
+		req->file = io_file_get_normal(req, req->cqe.fd);
+	if (!def->needs_async_setup)
+		return 0;
+	if (WARN_ON_ONCE(req_has_async_data(req)))
+		return -EFAULT;
+	if (io_alloc_async_data(req))
+		return -EAGAIN;
+
 	switch (req->opcode) {
-	case IORING_OP_NOP:
-		return io_nop_prep(req, sqe);
 	case IORING_OP_READV:
-	case IORING_OP_READ_FIXED:
-	case IORING_OP_READ:
+		return io_readv_prep_async(req);
 	case IORING_OP_WRITEV:
-	case IORING_OP_WRITE_FIXED:
-	case IORING_OP_WRITE:
-		return io_prep_rw(req, sqe);
-	case IORING_OP_POLL_ADD:
-		return io_poll_add_prep(req, sqe);
-	case IORING_OP_POLL_REMOVE:
-		return io_poll_remove_prep(req, sqe);
-	case IORING_OP_FSYNC:
-		return io_fsync_prep(req, sqe);
-	case IORING_OP_SYNC_FILE_RANGE:
-		return io_sfr_prep(req, sqe);
+		return io_writev_prep_async(req);
 	case IORING_OP_SENDMSG:
-	case IORING_OP_SEND:
-		return io_sendmsg_prep(req, sqe);
+		return io_sendmsg_prep_async(req);
 	case IORING_OP_RECVMSG:
-	case IORING_OP_RECV:
-		return io_recvmsg_prep(req, sqe);
+		return io_recvmsg_prep_async(req);
 	case IORING_OP_CONNECT:
-		return io_connect_prep(req, sqe);
-	case IORING_OP_TIMEOUT:
-		return io_timeout_prep(req, sqe);
-	case IORING_OP_TIMEOUT_REMOVE:
-		return io_timeout_remove_prep(req, sqe);
-	case IORING_OP_ASYNC_CANCEL:
-		return io_async_cancel_prep(req, sqe);
-	case IORING_OP_LINK_TIMEOUT:
-		return io_link_timeout_prep(req, sqe);
-	case IORING_OP_ACCEPT:
-		return io_accept_prep(req, sqe);
-	case IORING_OP_FALLOCATE:
-		return io_fallocate_prep(req, sqe);
-	case IORING_OP_OPENAT:
-		return io_openat_prep(req, sqe);
-	case IORING_OP_CLOSE:
-		return io_close_prep(req, sqe);
-	case IORING_OP_FILES_UPDATE:
-		return io_files_update_prep(req, sqe);
-	case IORING_OP_STATX:
-		return io_statx_prep(req, sqe);
-	case IORING_OP_FADVISE:
-		return io_fadvise_prep(req, sqe);
-	case IORING_OP_MADVISE:
-		return io_madvise_prep(req, sqe);
-	case IORING_OP_OPENAT2:
-		return io_openat2_prep(req, sqe);
-	case IORING_OP_EPOLL_CTL:
-		return io_epoll_ctl_prep(req, sqe);
-	case IORING_OP_SPLICE:
-		return io_splice_prep(req, sqe);
-	case IORING_OP_PROVIDE_BUFFERS:
-		return io_provide_buffers_prep(req, sqe);
-	case IORING_OP_REMOVE_BUFFERS:
-		return io_remove_buffers_prep(req, sqe);
-	case IORING_OP_TEE:
-		return io_tee_prep(req, sqe);
-	case IORING_OP_SHUTDOWN:
-		return io_shutdown_prep(req, sqe);
-	case IORING_OP_RENAMEAT:
-		return io_renameat_prep(req, sqe);
-	case IORING_OP_UNLINKAT:
-		return io_unlinkat_prep(req, sqe);
-	case IORING_OP_MKDIRAT:
-		return io_mkdirat_prep(req, sqe);
-	case IORING_OP_SYMLINKAT:
-		return io_symlinkat_prep(req, sqe);
-	case IORING_OP_LINKAT:
-		return io_linkat_prep(req, sqe);
-	case IORING_OP_MSG_RING:
-		return io_msg_ring_prep(req, sqe);
-	case IORING_OP_FSETXATTR:
-		return io_fsetxattr_prep(req, sqe);
-	case IORING_OP_SETXATTR:
-		return io_setxattr_prep(req, sqe);
-	case IORING_OP_FGETXATTR:
-		return io_fgetxattr_prep(req, sqe);
-	case IORING_OP_GETXATTR:
-		return io_getxattr_prep(req, sqe);
-	case IORING_OP_SOCKET:
-		return io_socket_prep(req, sqe);
+		return io_connect_prep_async(req);
 	case IORING_OP_URING_CMD:
-		return io_uring_cmd_prep(req, sqe);
+		return io_uring_cmd_prep_async(req);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -8136,39 +7855,6 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return -EINVAL;
 }
 
-static int io_req_prep_async(struct io_kiocb *req)
-{
-	const struct io_op_def *def = &io_op_defs[req->opcode];
-
-	/* assign early for deferred execution for non-fixed file */
-	if (def->needs_file && !(req->flags & REQ_F_FIXED_FILE))
-		req->file = io_file_get_normal(req, req->cqe.fd);
-	if (!def->needs_async_setup)
-		return 0;
-	if (WARN_ON_ONCE(req_has_async_data(req)))
-		return -EFAULT;
-	if (io_alloc_async_data(req))
-		return -EAGAIN;
-
-	switch (req->opcode) {
-	case IORING_OP_READV:
-		return io_readv_prep_async(req);
-	case IORING_OP_WRITEV:
-		return io_writev_prep_async(req);
-	case IORING_OP_SENDMSG:
-		return io_sendmsg_prep_async(req);
-	case IORING_OP_RECVMSG:
-		return io_recvmsg_prep_async(req);
-	case IORING_OP_CONNECT:
-		return io_connect_prep_async(req);
-	case IORING_OP_URING_CMD:
-		return io_uring_cmd_prep_async(req);
-	}
-	printk_once(KERN_WARNING "io_uring: prep_async() bad opcode %d\n",
-		    req->opcode);
-	return -EFAULT;
-}
-
 static u32 io_get_sequence(struct io_kiocb *req)
 {
 	u32 seq = req->ctx->cached_sq_head;
@@ -8335,141 +8021,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	if (!def->audit_skip)
 		audit_uring_entry(req->opcode);
 
-	switch (req->opcode) {
-	case IORING_OP_NOP:
-		ret = io_nop(req, issue_flags);
-		break;
-	case IORING_OP_READV:
-	case IORING_OP_READ_FIXED:
-	case IORING_OP_READ:
-		ret = io_read(req, issue_flags);
-		break;
-	case IORING_OP_WRITEV:
-	case IORING_OP_WRITE_FIXED:
-	case IORING_OP_WRITE:
-		ret = io_write(req, issue_flags);
-		break;
-	case IORING_OP_FSYNC:
-		ret = io_fsync(req, issue_flags);
-		break;
-	case IORING_OP_POLL_ADD:
-		ret = io_poll_add(req, issue_flags);
-		break;
-	case IORING_OP_POLL_REMOVE:
-		ret = io_poll_remove(req, issue_flags);
-		break;
-	case IORING_OP_SYNC_FILE_RANGE:
-		ret = io_sync_file_range(req, issue_flags);
-		break;
-	case IORING_OP_SENDMSG:
-		ret = io_sendmsg(req, issue_flags);
-		break;
-	case IORING_OP_SEND:
-		ret = io_send(req, issue_flags);
-		break;
-	case IORING_OP_RECVMSG:
-		ret = io_recvmsg(req, issue_flags);
-		break;
-	case IORING_OP_RECV:
-		ret = io_recv(req, issue_flags);
-		break;
-	case IORING_OP_TIMEOUT:
-		ret = io_timeout(req, issue_flags);
-		break;
-	case IORING_OP_TIMEOUT_REMOVE:
-		ret = io_timeout_remove(req, issue_flags);
-		break;
-	case IORING_OP_ACCEPT:
-		ret = io_accept(req, issue_flags);
-		break;
-	case IORING_OP_CONNECT:
-		ret = io_connect(req, issue_flags);
-		break;
-	case IORING_OP_ASYNC_CANCEL:
-		ret = io_async_cancel(req, issue_flags);
-		break;
-	case IORING_OP_FALLOCATE:
-		ret = io_fallocate(req, issue_flags);
-		break;
-	case IORING_OP_OPENAT:
-		ret = io_openat(req, issue_flags);
-		break;
-	case IORING_OP_CLOSE:
-		ret = io_close(req, issue_flags);
-		break;
-	case IORING_OP_FILES_UPDATE:
-		ret = io_files_update(req, issue_flags);
-		break;
-	case IORING_OP_STATX:
-		ret = io_statx(req, issue_flags);
-		break;
-	case IORING_OP_FADVISE:
-		ret = io_fadvise(req, issue_flags);
-		break;
-	case IORING_OP_MADVISE:
-		ret = io_madvise(req, issue_flags);
-		break;
-	case IORING_OP_OPENAT2:
-		ret = io_openat2(req, issue_flags);
-		break;
-	case IORING_OP_EPOLL_CTL:
-		ret = io_epoll_ctl(req, issue_flags);
-		break;
-	case IORING_OP_SPLICE:
-		ret = io_splice(req, issue_flags);
-		break;
-	case IORING_OP_PROVIDE_BUFFERS:
-		ret = io_provide_buffers(req, issue_flags);
-		break;
-	case IORING_OP_REMOVE_BUFFERS:
-		ret = io_remove_buffers(req, issue_flags);
-		break;
-	case IORING_OP_TEE:
-		ret = io_tee(req, issue_flags);
-		break;
-	case IORING_OP_SHUTDOWN:
-		ret = io_shutdown(req, issue_flags);
-		break;
-	case IORING_OP_RENAMEAT:
-		ret = io_renameat(req, issue_flags);
-		break;
-	case IORING_OP_UNLINKAT:
-		ret = io_unlinkat(req, issue_flags);
-		break;
-	case IORING_OP_MKDIRAT:
-		ret = io_mkdirat(req, issue_flags);
-		break;
-	case IORING_OP_SYMLINKAT:
-		ret = io_symlinkat(req, issue_flags);
-		break;
-	case IORING_OP_LINKAT:
-		ret = io_linkat(req, issue_flags);
-		break;
-	case IORING_OP_MSG_RING:
-		ret = io_msg_ring(req, issue_flags);
-		break;
-	case IORING_OP_FSETXATTR:
-		ret = io_fsetxattr(req, issue_flags);
-		break;
-	case IORING_OP_SETXATTR:
-		ret = io_setxattr(req, issue_flags);
-		break;
-	case IORING_OP_FGETXATTR:
-		ret = io_fgetxattr(req, issue_flags);
-		break;
-	case IORING_OP_GETXATTR:
-		ret = io_getxattr(req, issue_flags);
-		break;
-	case IORING_OP_SOCKET:
-		ret = io_socket(req, issue_flags);
-		break;
-	case IORING_OP_URING_CMD:
-		ret = io_uring_cmd(req, issue_flags);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
+	ret = def->issue(req, issue_flags);
 
 	if (!def->audit_skip)
 		audit_uring_exit(!ret, ret);
@@ -8898,7 +8450,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		req->flags |= REQ_F_CREDS;
 	}
 
-	return io_req_prep(req, sqe);
+	return def->prep(req, sqe);
 }
 
 static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
@@ -13200,8 +12752,343 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 	return ret;
 }
 
+static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
+{
+	WARN_ON_ONCE(1);
+	return -ECANCELED;
+}
+
+static const struct io_op_def io_op_defs[] = {
+	[IORING_OP_NOP] = {
+		.audit_skip		= 1,
+		.iopoll			= 1,
+		.prep			= io_nop_prep,
+		.issue			= io_nop,
+	},
+	[IORING_OP_READV] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.buffer_select		= 1,
+		.needs_async_setup	= 1,
+		.plug			= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
+		.async_size		= sizeof(struct io_async_rw),
+		.prep			= io_prep_rw,
+		.issue			= io_read,
+	},
+	[IORING_OP_WRITEV] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.needs_async_setup	= 1,
+		.plug			= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
+		.async_size		= sizeof(struct io_async_rw),
+		.prep			= io_prep_rw,
+		.issue			= io_write,
+	},
+	[IORING_OP_FSYNC] = {
+		.needs_file		= 1,
+		.audit_skip		= 1,
+		.prep			= io_fsync_prep,
+		.issue			= io_fsync,
+	},
+	[IORING_OP_READ_FIXED] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.plug			= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
+		.async_size		= sizeof(struct io_async_rw),
+		.prep			= io_prep_rw,
+		.issue			= io_read,
+	},
+	[IORING_OP_WRITE_FIXED] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.plug			= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
+		.async_size		= sizeof(struct io_async_rw),
+		.prep			= io_prep_rw,
+		.issue			= io_write,
+	},
+	[IORING_OP_POLL_ADD] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.audit_skip		= 1,
+		.prep			= io_poll_add_prep,
+		.issue			= io_poll_add,
+	},
+	[IORING_OP_POLL_REMOVE] = {
+		.audit_skip		= 1,
+		.prep			= io_poll_remove_prep,
+		.issue			= io_poll_remove,
+	},
+	[IORING_OP_SYNC_FILE_RANGE] = {
+		.needs_file		= 1,
+		.audit_skip		= 1,
+		.prep			= io_sfr_prep,
+		.issue			= io_sync_file_range,
+	},
+	[IORING_OP_SENDMSG] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.needs_async_setup	= 1,
+		.ioprio			= 1,
+		.async_size		= sizeof(struct io_async_msghdr),
+		.prep			= io_sendmsg_prep,
+		.issue			= io_sendmsg,
+	},
+	[IORING_OP_RECVMSG] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.buffer_select		= 1,
+		.needs_async_setup	= 1,
+		.ioprio			= 1,
+		.async_size		= sizeof(struct io_async_msghdr),
+		.prep			= io_recvmsg_prep,
+		.issue			= io_recvmsg,
+	},
+	[IORING_OP_TIMEOUT] = {
+		.audit_skip		= 1,
+		.async_size		= sizeof(struct io_timeout_data),
+		.prep			= io_timeout_prep,
+		.issue			= io_timeout,
+	},
+	[IORING_OP_TIMEOUT_REMOVE] = {
+		/* used by timeout updates' prep() */
+		.audit_skip		= 1,
+		.prep			= io_timeout_remove_prep,
+		.issue			= io_timeout_remove,
+	},
+	[IORING_OP_ACCEPT] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.poll_exclusive		= 1,
+		.ioprio			= 1,	/* used for flags */
+		.prep			= io_accept_prep,
+		.issue			= io_accept,
+	},
+	[IORING_OP_ASYNC_CANCEL] = {
+		.audit_skip		= 1,
+		.prep			= io_async_cancel_prep,
+		.issue			= io_async_cancel,
+	},
+	[IORING_OP_LINK_TIMEOUT] = {
+		.audit_skip		= 1,
+		.async_size		= sizeof(struct io_timeout_data),
+		.prep			= io_link_timeout_prep,
+		.issue			= io_no_issue,
+	},
+	[IORING_OP_CONNECT] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.needs_async_setup	= 1,
+		.async_size		= sizeof(struct io_async_connect),
+		.prep			= io_connect_prep,
+		.issue			= io_connect,
+	},
+	[IORING_OP_FALLOCATE] = {
+		.needs_file		= 1,
+		.prep			= io_fallocate_prep,
+		.issue			= io_fallocate,
+	},
+	[IORING_OP_OPENAT] = {
+		.prep			= io_openat_prep,
+		.issue			= io_openat,
+	},
+	[IORING_OP_CLOSE] = {
+		.prep			= io_close_prep,
+		.issue			= io_close,
+	},
+	[IORING_OP_FILES_UPDATE] = {
+		.audit_skip		= 1,
+		.iopoll			= 1,
+		.prep			= io_files_update_prep,
+		.issue			= io_files_update,
+	},
+	[IORING_OP_STATX] = {
+		.audit_skip		= 1,
+		.prep			= io_statx_prep,
+		.issue			= io_statx,
+	},
+	[IORING_OP_READ] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.buffer_select		= 1,
+		.plug			= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
+		.async_size		= sizeof(struct io_async_rw),
+		.prep			= io_prep_rw,
+		.issue			= io_read,
+	},
+	[IORING_OP_WRITE] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.plug			= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
+		.async_size		= sizeof(struct io_async_rw),
+		.prep			= io_prep_rw,
+		.issue			= io_write,
+	},
+	[IORING_OP_FADVISE] = {
+		.needs_file		= 1,
+		.audit_skip		= 1,
+		.prep			= io_fadvise_prep,
+		.issue			= io_fadvise,
+	},
+	[IORING_OP_MADVISE] = {
+		.prep			= io_madvise_prep,
+		.issue			= io_madvise,
+	},
+	[IORING_OP_SEND] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.prep			= io_sendmsg_prep,
+		.issue			= io_send,
+	},
+	[IORING_OP_RECV] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.buffer_select		= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.prep			= io_recvmsg_prep,
+		.issue			= io_recv,
+	},
+	[IORING_OP_OPENAT2] = {
+		.prep			= io_openat2_prep,
+		.issue			= io_openat2,
+	},
+	[IORING_OP_EPOLL_CTL] = {
+		.unbound_nonreg_file	= 1,
+		.audit_skip		= 1,
+		.prep			= io_epoll_ctl_prep,
+		.issue			= io_epoll_ctl,
+	},
+	[IORING_OP_SPLICE] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.audit_skip		= 1,
+		.prep			= io_splice_prep,
+		.issue			= io_splice,
+	},
+	[IORING_OP_PROVIDE_BUFFERS] = {
+		.audit_skip		= 1,
+		.iopoll			= 1,
+		.prep			= io_provide_buffers_prep,
+		.issue			= io_provide_buffers,
+	},
+	[IORING_OP_REMOVE_BUFFERS] = {
+		.audit_skip		= 1,
+		.iopoll			= 1,
+		.prep			= io_remove_buffers_prep,
+		.issue			= io_remove_buffers,
+	},
+	[IORING_OP_TEE] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.audit_skip		= 1,
+		.prep			= io_tee_prep,
+		.issue			= io_tee,
+	},
+	[IORING_OP_SHUTDOWN] = {
+		.needs_file		= 1,
+		.prep			= io_shutdown_prep,
+		.issue			= io_shutdown,
+	},
+	[IORING_OP_RENAMEAT] = {
+		.prep			= io_renameat_prep,
+		.issue			= io_renameat,
+	},
+	[IORING_OP_UNLINKAT] = {
+		.prep			= io_unlinkat_prep,
+		.issue			= io_unlinkat,
+	},
+	[IORING_OP_MKDIRAT] = {
+		.prep			= io_mkdirat_prep,
+		.issue			= io_mkdirat,
+	},
+	[IORING_OP_SYMLINKAT] = {
+		.prep			= io_symlinkat_prep,
+		.issue			= io_symlinkat,
+	},
+	[IORING_OP_LINKAT] = {
+		.prep			= io_linkat_prep,
+		.issue			= io_linkat,
+	},
+	[IORING_OP_MSG_RING] = {
+		.needs_file		= 1,
+		.iopoll			= 1,
+		.prep			= io_msg_ring_prep,
+		.issue			= io_msg_ring,
+	},
+	[IORING_OP_FSETXATTR] = {
+		.needs_file = 1,
+		.prep			= io_fsetxattr_prep,
+		.issue			= io_fsetxattr,
+	},
+	[IORING_OP_SETXATTR] = {
+		.prep			= io_setxattr_prep,
+		.issue			= io_setxattr,
+	},
+	[IORING_OP_FGETXATTR] = {
+		.needs_file = 1,
+		.prep			= io_fgetxattr_prep,
+		.issue			= io_fgetxattr,
+	},
+	[IORING_OP_GETXATTR] = {
+		.prep			= io_getxattr_prep,
+		.issue			= io_getxattr,
+	},
+	[IORING_OP_SOCKET] = {
+		.audit_skip		= 1,
+		.prep			= io_socket_prep,
+		.issue			= io_socket,
+	},
+	[IORING_OP_URING_CMD] = {
+		.needs_file		= 1,
+		.plug			= 1,
+		.needs_async_setup	= 1,
+		.async_size		= uring_cmd_pdu_size(1),
+		.prep			= io_uring_cmd_prep,
+		.issue			= io_uring_cmd,
+	},
+};
+
 static int __init io_uring_init(void)
 {
+	int i;
+
 #define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
 	BUILD_BUG_ON(offsetof(stype, ename) != eoffset); \
 	BUILD_BUG_ON(sizeof(etype) != sizeof_field(stype, ename)); \
@@ -13266,6 +13153,11 @@ static int __init io_uring_init(void)
 
 	BUILD_BUG_ON(sizeof(struct io_uring_cmd) > 64);
 
+	for (i = 0; i < ARRAY_SIZE(io_op_defs); i++) {
+		BUG_ON(!io_op_defs[i].prep);
+		BUG_ON(!io_op_defs[i].issue);
+	}
+
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
 				SLAB_ACCOUNT);
 	return 0;
-- 
2.35.1



