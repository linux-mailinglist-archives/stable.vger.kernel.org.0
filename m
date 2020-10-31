Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A15C2A16CF
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgJaLna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728033AbgJaLn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:43:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FBB3205F4;
        Sat, 31 Oct 2020 11:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144608;
        bh=4SYmQY0XqmMZ8EtpEzH13QmT2dIBP7+4fOfa0Bik/q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9Ti0mDslLb9K1WVfb51PffmRgpLmaZHCWL9ZZAAwz57ol2POWu2/Pawuq9aqhRZk
         rfoTORN5y5NCveCzz/7r5m7rz8dSLu+weGEeUR1eTnOYdQdhPtosuDTcc76bAzrKXE
         ShAJI18nr0EM0GvPXLwyfC5KnqokYEY0C2hnK5EQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 13/74] io_uring: no need to call xa_destroy() on empty xarray
Date:   Sat, 31 Oct 2020 12:35:55 +0100
Message-Id: <20201031113500.684973036@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit ca6484cd308a671811bf39f3119e81966eb476e3 upstream.

The kernel test robot reports this lockdep issue:

[child1:659] mbind (274) returned ENOSYS, marking as inactive.
[child1:659] mq_timedsend (279) returned ENOSYS, marking as inactive.
[main] 10175 iterations. [F:7781 S:2344 HI:2397]
[   24.610601]
[   24.610743] ================================
[   24.611083] WARNING: inconsistent lock state
[   24.611437] 5.9.0-rc7-00017-g0f2122045b9462 #5 Not tainted
[   24.611861] --------------------------------
[   24.612193] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
[   24.612660] ksoftirqd/0/7 [HC0[0]:SC1[3]:HE0:SE0] takes:
[   24.613086] f00ed998 (&xa->xa_lock#4){+.?.}-{2:2}, at: xa_destroy+0x43/0xc1
[   24.613642] {SOFTIRQ-ON-W} state was registered at:
[   24.614024]   lock_acquire+0x20c/0x29b
[   24.614341]   _raw_spin_lock+0x21/0x30
[   24.614636]   io_uring_add_task_file+0xe8/0x13a
[   24.614987]   io_uring_create+0x535/0x6bd
[   24.615297]   io_uring_setup+0x11d/0x136
[   24.615606]   __ia32_sys_io_uring_setup+0xd/0xf
[   24.615977]   do_int80_syscall_32+0x53/0x6c
[   24.616306]   restore_all_switch_stack+0x0/0xb1
[   24.616677] irq event stamp: 939881
[   24.616968] hardirqs last  enabled at (939880): [<8105592d>] __local_bh_enable_ip+0x13c/0x145
[   24.617642] hardirqs last disabled at (939881): [<81b6ace3>] _raw_spin_lock_irqsave+0x1b/0x4e
[   24.618321] softirqs last  enabled at (939738): [<81b6c7c8>] __do_softirq+0x3f0/0x45a
[   24.618924] softirqs last disabled at (939743): [<81055741>] run_ksoftirqd+0x35/0x61
[   24.619521]
[   24.619521] other info that might help us debug this:
[   24.620028]  Possible unsafe locking scenario:
[   24.620028]
[   24.620492]        CPU0
[   24.620685]        ----
[   24.620894]   lock(&xa->xa_lock#4);
[   24.621168]   <Interrupt>
[   24.621381]     lock(&xa->xa_lock#4);
[   24.621695]
[   24.621695]  *** DEADLOCK ***
[   24.621695]
[   24.622154] 1 lock held by ksoftirqd/0/7:
[   24.622468]  #0: 823bfb94 (rcu_callback){....}-{0:0}, at: rcu_process_callbacks+0xc0/0x155
[   24.623106]
[   24.623106] stack backtrace:
[   24.623454] CPU: 0 PID: 7 Comm: ksoftirqd/0 Not tainted 5.9.0-rc7-00017-g0f2122045b9462 #5
[   24.624090] Call Trace:
[   24.624284]  ? show_stack+0x40/0x46
[   24.624551]  dump_stack+0x1b/0x1d
[   24.624809]  print_usage_bug+0x17a/0x185
[   24.625142]  mark_lock+0x11d/0x1db
[   24.625474]  ? print_shortest_lock_dependencies+0x121/0x121
[   24.625905]  __lock_acquire+0x41e/0x7bf
[   24.626206]  lock_acquire+0x20c/0x29b
[   24.626517]  ? xa_destroy+0x43/0xc1
[   24.626810]  ? lock_acquire+0x20c/0x29b
[   24.627110]  _raw_spin_lock_irqsave+0x3e/0x4e
[   24.627450]  ? xa_destroy+0x43/0xc1
[   24.627725]  xa_destroy+0x43/0xc1
[   24.627989]  __io_uring_free+0x57/0x71
[   24.628286]  ? get_pid+0x22/0x22
[   24.628544]  __put_task_struct+0xf2/0x163
[   24.628865]  put_task_struct+0x1f/0x2a
[   24.629161]  delayed_put_task_struct+0xe2/0xe9
[   24.629509]  rcu_process_callbacks+0x128/0x155
[   24.629860]  __do_softirq+0x1a3/0x45a
[   24.630151]  run_ksoftirqd+0x35/0x61
[   24.630443]  smpboot_thread_fn+0x304/0x31a
[   24.630763]  kthread+0x124/0x139
[   24.631016]  ? sort_range+0x18/0x18
[   24.631290]  ? kthread_create_worker_on_cpu+0x17/0x17
[   24.631682]  ret_from_fork+0x1c/0x28

which is complaining about xa_destroy() grabbing the xa lock in an
IRQ disabling fashion, whereas the io_uring uses cases aren't interrupt
safe. This is really an xarray issue, since it should not assume the
lock type. But for our use case, since we know the xarray is empty at
this point, there's no need to actually call xa_destroy(). So just get
rid of it.

Fixes: 0f2122045b94 ("io_uring: don't rely on weak ->files references")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7536,7 +7536,6 @@ void __io_uring_free(struct task_struct
 	struct io_uring_task *tctx = tsk->io_uring;
 
 	WARN_ON_ONCE(!xa_empty(&tctx->xa));
-	xa_destroy(&tctx->xa);
 	kfree(tctx);
 	tsk->io_uring = NULL;
 }


