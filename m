Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8792471F4
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391320AbgHQSf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:35:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730970AbgHQP7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:59:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 212D620729;
        Mon, 17 Aug 2020 15:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679969;
        bh=UZaydpNz1Q69C0BREPFQqsuxJqrmrHnJRIZerPmnJTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ryu0RuyTaJBCp9UikOHcuGmaFy4H4aw45cx+lCCSG4h1n5Wp4DAXkGRY4gjoz7S2U
         /V7dKSFJPxGqJgNWUB7KjiOnO/6A5b11Ke19xS7uhw+Pb9p9XS9fJ3UivSUDOkX5/x
         gzUFbVeLGPuS6A8caHxLYjzC/ncEAjJJXN513JLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guoyu Huang <hgy5945@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.7 389/393] io_uring: Fix NULL pointer dereference in loop_rw_iter()
Date:   Mon, 17 Aug 2020 17:17:19 +0200
Message-Id: <20200817143838.470727101@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoyu Huang <hgy5945@gmail.com>

commit 2dd2111d0d383df104b144e0d1f6b5a00cb7cd88 upstream.

loop_rw_iter() does not check whether the file has a read or
write function. This can lead to NULL pointer dereference
when the user passes in a file descriptor that does not have
read or write function.

The crash log looks like this:

[   99.834071] BUG: kernel NULL pointer dereference, address: 0000000000000000
[   99.835364] #PF: supervisor instruction fetch in kernel mode
[   99.836522] #PF: error_code(0x0010) - not-present page
[   99.837771] PGD 8000000079d62067 P4D 8000000079d62067 PUD 79d8c067 PMD 0
[   99.839649] Oops: 0010 [#2] SMP PTI
[   99.840591] CPU: 1 PID: 333 Comm: io_wqe_worker-0 Tainted: G      D           5.8.0 #2
[   99.842622] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
[   99.845140] RIP: 0010:0x0
[   99.845840] Code: Bad RIP value.
[   99.846672] RSP: 0018:ffffa1c7c01ebc08 EFLAGS: 00010202
[   99.848018] RAX: 0000000000000000 RBX: ffff92363bd67300 RCX: ffff92363d461208
[   99.849854] RDX: 0000000000000010 RSI: 00007ffdbf696bb0 RDI: ffff92363bd67300
[   99.851743] RBP: ffffa1c7c01ebc40 R08: 0000000000000000 R09: 0000000000000000
[   99.853394] R10: ffffffff9ec692a0 R11: 0000000000000000 R12: 0000000000000010
[   99.855148] R13: 0000000000000000 R14: ffff92363d461208 R15: ffffa1c7c01ebc68
[   99.856914] FS:  0000000000000000(0000) GS:ffff92363dd00000(0000) knlGS:0000000000000000
[   99.858651] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   99.860032] CR2: ffffffffffffffd6 CR3: 000000007ac66000 CR4: 00000000000006e0
[   99.861979] Call Trace:
[   99.862617]  loop_rw_iter.part.0+0xad/0x110
[   99.863838]  io_write+0x2ae/0x380
[   99.864644]  ? kvm_sched_clock_read+0x11/0x20
[   99.865595]  ? sched_clock+0x9/0x10
[   99.866453]  ? sched_clock_cpu+0x11/0xb0
[   99.867326]  ? newidle_balance+0x1d4/0x3c0
[   99.868283]  io_issue_sqe+0xd8f/0x1340
[   99.869216]  ? __switch_to+0x7f/0x450
[   99.870280]  ? __switch_to_asm+0x42/0x70
[   99.871254]  ? __switch_to_asm+0x36/0x70
[   99.872133]  ? lock_timer_base+0x72/0xa0
[   99.873155]  ? switch_mm_irqs_off+0x1bf/0x420
[   99.874152]  io_wq_submit_work+0x64/0x180
[   99.875192]  ? kthread_use_mm+0x71/0x100
[   99.876132]  io_worker_handle_work+0x267/0x440
[   99.877233]  io_wqe_worker+0x297/0x350
[   99.878145]  kthread+0x112/0x150
[   99.878849]  ? __io_worker_unuse+0x100/0x100
[   99.879935]  ? kthread_park+0x90/0x90
[   99.880874]  ret_from_fork+0x22/0x30
[   99.881679] Modules linked in:
[   99.882493] CR2: 0000000000000000
[   99.883324] ---[ end trace 4453745f4673190b ]---
[   99.884289] RIP: 0010:0x0
[   99.884837] Code: Bad RIP value.
[   99.885492] RSP: 0018:ffffa1c7c01ebc08 EFLAGS: 00010202
[   99.886851] RAX: 0000000000000000 RBX: ffff92363acd7f00 RCX: ffff92363d461608
[   99.888561] RDX: 0000000000000010 RSI: 00007ffe040d9e10 RDI: ffff92363acd7f00
[   99.890203] RBP: ffffa1c7c01ebc40 R08: 0000000000000000 R09: 0000000000000000
[   99.891907] R10: ffffffff9ec692a0 R11: 0000000000000000 R12: 0000000000000010
[   99.894106] R13: 0000000000000000 R14: ffff92363d461608 R15: ffffa1c7c01ebc68
[   99.896079] FS:  0000000000000000(0000) GS:ffff92363dd00000(0000) knlGS:0000000000000000
[   99.898017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   99.899197] CR2: ffffffffffffffd6 CR3: 000000007ac66000 CR4: 00000000000006e0

Fixes: 32960613b7c3 ("io_uring: correctly handle non ->{read,write}_iter() file_operations")
Cc: stable@vger.kernel.org
Signed-off-by: Guoyu Huang <hgy5945@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2614,8 +2614,10 @@ static int io_read(struct io_kiocb *req,
 
 		if (req->file->f_op->read_iter)
 			ret2 = call_read_iter(req->file, kiocb, &iter);
-		else
+		else if (req->file->f_op->read)
 			ret2 = loop_rw_iter(READ, req->file, kiocb, &iter);
+		else
+			ret2 = -EINVAL;
 
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || ret2 != -EAGAIN) {
@@ -2729,8 +2731,10 @@ static int io_write(struct io_kiocb *req
 
 		if (req->file->f_op->write_iter)
 			ret2 = call_write_iter(req->file, kiocb, &iter);
-		else
+		else if (req->file->f_op->write)
 			ret2 = loop_rw_iter(WRITE, req->file, kiocb, &iter);
+		else
+			ret2 = -EINVAL;
 
 		if (!force_nonblock)
 			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;


