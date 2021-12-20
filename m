Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BDB47AE8D
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239177AbhLTPB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46056 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239815AbhLTO7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:59:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F02EA6118E;
        Mon, 20 Dec 2021 14:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41A7C36AE9;
        Mon, 20 Dec 2021 14:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012351;
        bh=hwTfC7fKmk+YvCuDekklJf8Xz3A0K0JD9UWGtfF7KXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bTqSDhuoAzb5Vr32C5pCKTMZRnChBy6mWEVd/sIE91go1Iwy8K4FGwVCL9cCYGhgY
         yrLuFHE3/iSA+JIB/UUTtPomBbysXOURzJTBmLaI37yBvz0V+ZsNEA9nCb7GBnzv2I
         UTTnF7rLDJqo4/xeEUF90GQ6OSov8wNTencL8MJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b18b8be69df33a3918e9@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 169/177] io-wq: drop wqe lock before creating new worker
Date:   Mon, 20 Dec 2021 15:35:19 +0100
Message-Id: <20211220143045.761836051@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit d800c65c2d4eccebb27ffb7808e842d5b533823c upstream.

We have two io-wq creation paths:

- On queue enqueue
- When a worker goes to sleep

The latter invokes worker creation with the wqe->lock held, but that can
run into problems if we end up exiting and need to cancel the queued work.
syzbot caught this:

============================================
WARNING: possible recursive locking detected
5.16.0-rc4-syzkaller #0 Not tainted
--------------------------------------------
iou-wrk-6468/6471 is trying to acquire lock:
ffff88801aa98018 (&wqe->lock){+.+.}-{2:2}, at: io_worker_cancel_cb+0xb7/0x210 fs/io-wq.c:187

but task is already holding lock:
ffff88801aa98018 (&wqe->lock){+.+.}-{2:2}, at: io_wq_worker_sleeping+0xb6/0x140 fs/io-wq.c:700

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&wqe->lock);
  lock(&wqe->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by iou-wrk-6468/6471:
 #0: ffff88801aa98018 (&wqe->lock){+.+.}-{2:2}, at: io_wq_worker_sleeping+0xb6/0x140 fs/io-wq.c:700

stack backtrace:
CPU: 1 PID: 6471 Comm: iou-wrk-6468 Not tainted 5.16.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1dc/0x2d8 lib/dump_stack.c:106
 print_deadlock_bug kernel/locking/lockdep.c:2956 [inline]
 check_deadlock kernel/locking/lockdep.c:2999 [inline]
 validate_chain+0x5984/0x8240 kernel/locking/lockdep.c:3788
 __lock_acquire+0x1382/0x2b00 kernel/locking/lockdep.c:5027
 lock_acquire+0x19f/0x4d0 kernel/locking/lockdep.c:5637
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
 io_worker_cancel_cb+0xb7/0x210 fs/io-wq.c:187
 io_wq_cancel_tw_create fs/io-wq.c:1220 [inline]
 io_queue_worker_create+0x3cf/0x4c0 fs/io-wq.c:372
 io_wq_worker_sleeping+0xbe/0x140 fs/io-wq.c:701
 sched_submit_work kernel/sched/core.c:6295 [inline]
 schedule+0x67/0x1f0 kernel/sched/core.c:6323
 schedule_timeout+0xac/0x300 kernel/time/timer.c:1857
 wait_woken+0xca/0x1b0 kernel/sched/wait.c:460
 unix_msg_wait_data net/unix/unix_bpf.c:32 [inline]
 unix_bpf_recvmsg+0x7f9/0xe20 net/unix/unix_bpf.c:77
 unix_stream_recvmsg+0x214/0x2c0 net/unix/af_unix.c:2832
 sock_recvmsg_nosec net/socket.c:944 [inline]
 sock_recvmsg net/socket.c:962 [inline]
 sock_read_iter+0x3a7/0x4d0 net/socket.c:1035
 call_read_iter include/linux/fs.h:2156 [inline]
 io_iter_do_read fs/io_uring.c:3501 [inline]
 io_read fs/io_uring.c:3558 [inline]
 io_issue_sqe+0x144c/0x9590 fs/io_uring.c:6671
 io_wq_submit_work+0x2d8/0x790 fs/io_uring.c:6836
 io_worker_handle_work+0x808/0xdd0 fs/io-wq.c:574
 io_wqe_worker+0x395/0x870 fs/io-wq.c:630
 ret_from_fork+0x1f/0x30

We can safely drop the lock before doing work creation, making the two
contexts the same in that regard.

Reported-by: syzbot+b18b8be69df33a3918e9@syzkaller.appspotmail.com
Fixes: 71a85387546e ("io-wq: check for wq exit after adding new worker task_work")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io-wq.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -395,7 +395,9 @@ static void io_wqe_dec_running(struct io
 	if (atomic_dec_and_test(&acct->nr_running) && io_acct_run_queue(acct)) {
 		atomic_inc(&acct->nr_running);
 		atomic_inc(&wqe->wq->worker_refs);
+		raw_spin_unlock(&wqe->lock);
 		io_queue_worker_create(worker, acct, create_worker_cb);
+		raw_spin_lock(&wqe->lock);
 	}
 }
 


