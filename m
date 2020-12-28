Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E3C2E3E2F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439276AbgL1OZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:25:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439268AbgL1OZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:25:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54E5A206D4;
        Mon, 28 Dec 2020 14:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165468;
        bh=+QVct9MyLaeNCifX8GQtBc8ROXA/1RbiTn2kv0bnhdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eIbDlZiZUJWVD5sGSNsGvbnDpHhKyXaQYXlbjy/3F1Bonlia5BGv8OQmCppYVF1sv
         Mcouw7dp/JUnoTQs0zp3sTFfcQB31CV62UjG82qBHLtU0vg8uanJjMYmt8aZMcHX58
         Eq/QcZ7qov+spiq1yMqrwpBiNppVaJH5pFA6nUWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Fuzz <abaci@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 512/717] io_uring: always let io_iopoll_complete() complete polled io
Date:   Mon, 28 Dec 2020 13:48:30 +0100
Message-Id: <20201228125045.497020421@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

commit dad1b1242fd5717af18ae4ac9d12b9f65849e13a upstream.

Abaci Fuzz reported a double-free or invalid-free BUG in io_commit_cqring():
[   95.504842] BUG: KASAN: double-free or invalid-free in io_commit_cqring+0x3ec/0x8e0
[   95.505921]
[   95.506225] CPU: 0 PID: 4037 Comm: io_wqe_worker-0 Tainted: G    B
W         5.10.0-rc5+ #1
[   95.507434] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[   95.508248] Call Trace:
[   95.508683]  dump_stack+0x107/0x163
[   95.509323]  ? io_commit_cqring+0x3ec/0x8e0
[   95.509982]  print_address_description.constprop.0+0x3e/0x60
[   95.510814]  ? vprintk_func+0x98/0x140
[   95.511399]  ? io_commit_cqring+0x3ec/0x8e0
[   95.512036]  ? io_commit_cqring+0x3ec/0x8e0
[   95.512733]  kasan_report_invalid_free+0x51/0x80
[   95.513431]  ? io_commit_cqring+0x3ec/0x8e0
[   95.514047]  __kasan_slab_free+0x141/0x160
[   95.514699]  kfree+0xd1/0x390
[   95.515182]  io_commit_cqring+0x3ec/0x8e0
[   95.515799]  __io_req_complete.part.0+0x64/0x90
[   95.516483]  io_wq_submit_work+0x1fa/0x260
[   95.517117]  io_worker_handle_work+0xeac/0x1c00
[   95.517828]  io_wqe_worker+0xc94/0x11a0
[   95.518438]  ? io_worker_handle_work+0x1c00/0x1c00
[   95.519151]  ? __kthread_parkme+0x11d/0x1d0
[   95.519806]  ? io_worker_handle_work+0x1c00/0x1c00
[   95.520512]  ? io_worker_handle_work+0x1c00/0x1c00
[   95.521211]  kthread+0x396/0x470
[   95.521727]  ? _raw_spin_unlock_irq+0x24/0x30
[   95.522380]  ? kthread_mod_delayed_work+0x180/0x180
[   95.523108]  ret_from_fork+0x22/0x30
[   95.523684]
[   95.523985] Allocated by task 4035:
[   95.524543]  kasan_save_stack+0x1b/0x40
[   95.525136]  __kasan_kmalloc.constprop.0+0xc2/0xd0
[   95.525882]  kmem_cache_alloc_trace+0x17b/0x310
[   95.533930]  io_queue_sqe+0x225/0xcb0
[   95.534505]  io_submit_sqes+0x1768/0x25f0
[   95.535164]  __x64_sys_io_uring_enter+0x89e/0xd10
[   95.535900]  do_syscall_64+0x33/0x40
[   95.536465]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   95.537199]
[   95.537505] Freed by task 4035:
[   95.538003]  kasan_save_stack+0x1b/0x40
[   95.538599]  kasan_set_track+0x1c/0x30
[   95.539177]  kasan_set_free_info+0x1b/0x30
[   95.539798]  __kasan_slab_free+0x112/0x160
[   95.540427]  kfree+0xd1/0x390
[   95.540910]  io_commit_cqring+0x3ec/0x8e0
[   95.541516]  io_iopoll_complete+0x914/0x1390
[   95.542150]  io_do_iopoll+0x580/0x700
[   95.542724]  io_iopoll_try_reap_events.part.0+0x108/0x200
[   95.543512]  io_ring_ctx_wait_and_kill+0x118/0x340
[   95.544206]  io_uring_release+0x43/0x50
[   95.544791]  __fput+0x28d/0x940
[   95.545291]  task_work_run+0xea/0x1b0
[   95.545873]  do_exit+0xb6a/0x2c60
[   95.546400]  do_group_exit+0x12a/0x320
[   95.546967]  __x64_sys_exit_group+0x3f/0x50
[   95.547605]  do_syscall_64+0x33/0x40
[   95.548155]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

The reason is that once we got a non EAGAIN error in io_wq_submit_work(),
we'll complete req by calling io_req_complete(), which will hold completion_lock
to call io_commit_cqring(), but for polled io, io_iopoll_complete() won't
hold completion_lock to call io_commit_cqring(), then there maybe concurrent
access to ctx->defer_list, double free may happen.

To fix this bug, we always let io_iopoll_complete() complete polled io.

Cc: <stable@vger.kernel.org> # 5.5+
Reported-by: Abaci Fuzz <abaci@linux.alibaba.com>
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6083,8 +6083,19 @@ static struct io_wq_work *io_wq_submit_w
 	}
 
 	if (ret) {
-		req_set_fail_links(req);
-		io_req_complete(req, ret);
+		/*
+		 * io_iopoll_complete() does not hold completion_lock to complete
+		 * polled io, so here for polled io, just mark it done and still let
+		 * io_iopoll_complete() complete it.
+		 */
+		if (req->ctx->flags & IORING_SETUP_IOPOLL) {
+			struct kiocb *kiocb = &req->rw.kiocb;
+
+			kiocb_done(kiocb, ret, NULL);
+		} else {
+			req_set_fail_links(req);
+			io_req_complete(req, ret);
+		}
 	}
 
 	return io_steal_work(req);


