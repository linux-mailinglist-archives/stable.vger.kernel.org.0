Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC662304A7D
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731060AbhAZFE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:04:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731311AbhAYSyF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:54:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CD7B207B3;
        Mon, 25 Jan 2021 18:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600803;
        bh=tMsN7WI89I8mcmQSi7wFx4hjdxK2ff4GiOYeyT/o/Rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wGV5cER1JWz/Ink2FzyNPz8idrUh0NKNy0QBiXDIglhvvaeVrSEVkCSX8FwNDOliB
         sh8DoDoA/2g/ANMR4mTBiY3u9AMCCuDt/283aeSjq3170CfDRnVSAQC0JopZhsog9q
         EuBKWpGA8/WufSgsskLUIT1nInljy5Lj7wPhRAOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 5.10 127/199] io_uring: fix SQPOLL IORING_OP_CLOSE cancelation state
Date:   Mon, 25 Jan 2021 19:39:09 +0100
Message-Id: <20210125183221.575377995@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 607ec89ed18f49ca59689572659b9c0076f1991f upstream.

IORING_OP_CLOSE is special in terms of cancelation, since it has an
intermediate state where we've removed the file descriptor but hasn't
closed the file yet. For that reason, it's currently marked with
IO_WQ_WORK_NO_CANCEL to prevent cancelation. This ensures that the op
is always run even if canceled, to prevent leaving us with a live file
but an fd that is gone. However, with SQPOLL, since a cancel request
doesn't carry any resources on behalf of the request being canceled, if
we cancel before any of the close op has been run, we can end up with
io-wq not having the ->files assigned. This can result in the following
oops reported by Joseph:

BUG: kernel NULL pointer dereference, address: 00000000000000d8
PGD 800000010b76f067 P4D 800000010b76f067 PUD 10b462067 PMD 0
Oops: 0000 [#1] SMP PTI
CPU: 1 PID: 1788 Comm: io_uring-sq Not tainted 5.11.0-rc4 #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
RIP: 0010:__lock_acquire+0x19d/0x18c0
Code: 00 00 8b 1d fd 56 dd 08 85 db 0f 85 43 05 00 00 48 c7 c6 98 7b 95 82 48 c7 c7 57 96 93 82 e8 9a bc f5 ff 0f 0b e9 2b 05 00 00 <48> 81 3f c0 ca 67 8a b8 00 00 00 00 41 0f 45 c0 89 04 24 e9 81 fe
RSP: 0018:ffffc90001933828 EFLAGS: 00010002
RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000000d8
RBP: 0000000000000246 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff888106e8a140 R15: 00000000000000d8
FS:  0000000000000000(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000000d8 CR3: 0000000106efa004 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_acquire+0x31a/0x440
 ? close_fd_get_file+0x39/0x160
 ? __lock_acquire+0x647/0x18c0
 _raw_spin_lock+0x2c/0x40
 ? close_fd_get_file+0x39/0x160
 close_fd_get_file+0x39/0x160
 io_issue_sqe+0x1334/0x14e0
 ? lock_acquire+0x31a/0x440
 ? __io_free_req+0xcf/0x2e0
 ? __io_free_req+0x175/0x2e0
 ? find_held_lock+0x28/0xb0
 ? io_wq_submit_work+0x7f/0x240
 io_wq_submit_work+0x7f/0x240
 io_wq_cancel_cb+0x161/0x580
 ? io_wqe_wake_worker+0x114/0x360
 ? io_uring_get_socket+0x40/0x40
 io_async_find_and_cancel+0x3b/0x140
 io_issue_sqe+0xbe1/0x14e0
 ? __lock_acquire+0x647/0x18c0
 ? __io_queue_sqe+0x10b/0x5f0
 __io_queue_sqe+0x10b/0x5f0
 ? io_req_prep+0xdb/0x1150
 ? mark_held_locks+0x6d/0xb0
 ? mark_held_locks+0x6d/0xb0
 ? io_queue_sqe+0x235/0x4b0
 io_queue_sqe+0x235/0x4b0
 io_submit_sqes+0xd7e/0x12a0
 ? _raw_spin_unlock_irq+0x24/0x30
 ? io_sq_thread+0x3ae/0x940
 io_sq_thread+0x207/0x940
 ? do_wait_intr_irq+0xc0/0xc0
 ? __ia32_sys_io_uring_enter+0x650/0x650
 kthread+0x134/0x180
 ? kthread_create_worker_on_cpu+0x90/0x90
 ret_from_fork+0x1f/0x30

Fix this by moving the IO_WQ_WORK_NO_CANCEL until _after_ we've modified
the fdtable. Canceling before this point is totally fine, and running
it in the io-wq context _after_ that point is also fine.

For 5.12, we'll handle this internally and get rid of the no-cancel
flag, as IORING_OP_CLOSE is the only user of it.

Cc: stable@vger.kernel.org
Fixes: b5dba59e0cf7 ("io_uring: add support for IORING_OP_CLOSE")
Reported-by: "Abaci <abaci@linux.alibaba.com>"
Reviewed-and-tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4250,7 +4250,6 @@ static int io_close_prep(struct io_kiocb
 	 * io_wq_work.flags, so initialize io_wq_work firstly.
 	 */
 	io_req_init_async(req);
-	req->work.flags |= IO_WQ_WORK_NO_CANCEL;
 
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
 		return -EINVAL;
@@ -4283,6 +4282,8 @@ static int io_close(struct io_kiocb *req
 
 	/* if the file has a flush method, be safe and punt to async */
 	if (close->put_file->f_op->flush && force_nonblock) {
+		/* not safe to cancel at this point */
+		req->work.flags |= IO_WQ_WORK_NO_CANCEL;
 		/* was never set, but play safe */
 		req->flags &= ~REQ_F_NOWAIT;
 		/* avoid grabbing files - we don't need the files */


