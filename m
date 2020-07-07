Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07C1217126
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbgGGPYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:24:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729674AbgGGPYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:24:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF7A420663;
        Tue,  7 Jul 2020 15:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135477;
        bh=djgJv5sPGtFSvjLrP1dLw1yMBUcbSp0t7Xs692s/lq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZagKn0gGBfTMyxashLJd6+P2Xf6vmj4SckOJb6vmmGMU+ClDgmOQiXziDsoAv84EX
         O18pevPw4EYZUlbDGAX9YOETuMemLidxy0xmThXw/wqpBOfODlY+2IbPShldLKk07L
         XCu3FfmtGrvtNjw7PEVWAkKojbds+3rgJYHQUud4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 027/112] io_uring: fix {SQ,IO}POLL with unsupported opcodes
Date:   Tue,  7 Jul 2020 17:16:32 +0200
Message-Id: <20200707145802.280728361@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 3232dd02af65f2d01be641120d2a710176b0c7a7 ]

IORING_SETUP_IOPOLL is defined only for read/write, other opcodes should
be disallowed, otherwise it'll get an error as below. Also refuse
open/close with SQPOLL, as the polling thread wouldn't know which file
table to use.

RIP: 0010:io_iopoll_getevents+0x111/0x5a0
Call Trace:
 ? _raw_spin_unlock_irqrestore+0x24/0x40
 ? do_send_sig_info+0x64/0x90
 io_iopoll_reap_events.part.0+0x5e/0xa0
 io_ring_ctx_wait_and_kill+0x132/0x1c0
 io_uring_release+0x20/0x30
 __fput+0xcd/0x230
 ____fput+0xe/0x10
 task_work_run+0x67/0xa0
 do_exit+0x353/0xb10
 ? handle_mm_fault+0xd4/0x200
 ? syscall_trace_enter+0x18c/0x2c0
 do_group_exit+0x43/0xa0
 __x64_sys_exit_group+0x18/0x20
 do_syscall_64+0x60/0x1e0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
[axboe: allow provide/remove buffers and files update]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4ab1728de247c..bb74e45941af2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2748,6 +2748,8 @@ static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 
 	sp->file_in = NULL;
 	sp->off_in = READ_ONCE(sqe->splice_off_in);
@@ -2910,6 +2912,8 @@ static int io_fallocate_prep(struct io_kiocb *req,
 {
 	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags)
 		return -EINVAL;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 
 	req->sync.off = READ_ONCE(sqe->off);
 	req->sync.len = READ_ONCE(sqe->addr);
@@ -2935,6 +2939,8 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	const char __user *fname;
 	int ret;
 
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
@@ -2968,6 +2974,8 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	size_t len;
 	int ret;
 
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
@@ -3207,6 +3215,8 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 #if defined(CONFIG_EPOLL)
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 
 	req->epoll.epfd = READ_ONCE(sqe->fd);
 	req->epoll.op = READ_ONCE(sqe->len);
@@ -3251,6 +3261,8 @@ static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
 	if (sqe->ioprio || sqe->buf_index || sqe->off)
 		return -EINVAL;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 
 	req->madvise.addr = READ_ONCE(sqe->addr);
 	req->madvise.len = READ_ONCE(sqe->len);
@@ -3285,6 +3297,8 @@ static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (sqe->ioprio || sqe->buf_index || sqe->addr)
 		return -EINVAL;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 
 	req->fadvise.offset = READ_ONCE(sqe->off);
 	req->fadvise.len = READ_ONCE(sqe->len);
@@ -3322,6 +3336,8 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	unsigned lookup_flags;
 	int ret;
 
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
@@ -3402,6 +3418,8 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	 */
 	req->work.flags |= IO_WQ_WORK_NO_CANCEL;
 
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
 	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
 	    sqe->rw_flags || sqe->buf_index)
 		return -EINVAL;
-- 
2.25.1



