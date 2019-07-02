Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E00C15CA53
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfGBIDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727267AbfGBIDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:03:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EB5F21855;
        Tue,  2 Jul 2019 08:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054581;
        bh=GZ6x7zr+8FH2xCGjotD8waIYCou0HOtehOKgUnqZdoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vwIVU5kD2j1ZdkG1OEFUQaeX6R55GkFEUJ2eoHCzaqyy92qnNiorqNzDulYybE3wo
         7WCMWOxD6sf4hfjmvzDZeCv+h63QhbzDxh+y7zTvWrzlLfWjQb2wSRUqkoywfikMr+
         2rYh8zUiFSJuPGbGPD/DqH8S7M8WvQko8V3wBdec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Bates <sbates@raithlin.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.1 19/55] io_uring: ensure req->file is cleared on allocation
Date:   Tue,  2 Jul 2019 10:01:27 +0200
Message-Id: <20190702080125.041640340@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 60c112b0ada09826cc4ae6a4e55df677f76f1313 upstream.

Stephen reports:

I hit the following General Protection Fault when testing io_uring via
the io_uring engine in fio. This was on a VM running 5.2-rc5 and the
latest version of fio. The issue occurs for both null_blk and fake NVMe
drives. I have not tested bare metal or real NVMe SSDs. The fio script
used is given below.

[io_uring]
time_based=1
runtime=60
filename=/dev/nvme2n1 (note /dev/nullb0 also fails)
ioengine=io_uring
bs=4k
rw=readwrite
direct=1
fixedbufs=1
sqthread_poll=1
sqthread_poll_cpu=0

general protection fault: 0000 [#1] SMP PTI
CPU: 0 PID: 872 Comm: io_uring-sq Not tainted 5.2.0-rc5-cpacket-io-uring #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
RIP: 0010:fput_many+0x7/0x90
Code: 01 48 85 ff 74 17 55 48 89 e5 53 48 8b 1f e8 a0 f9 ff ff 48 85 db 48 89 df 75 f0 5b 5d f3 c3 0f 1f 40 00 0f 1f 44 00 00 89 f6 <f0> 48 29 77 38 74 01 c3 55 48 89 e5 53 48 89 fb 65 48 \

RSP: 0018:ffffadeb817ebc50 EFLAGS: 00010246
RAX: 0000000000000004 RBX: ffff8f46ad477480 RCX: 0000000000001805
RDX: 0000000000000000 RSI: 0000000000000001 RDI: f18b51b9a39552b5
RBP: ffffadeb817ebc58 R08: ffff8f46b7a318c0 R09: 000000000000015d
R10: ffffadeb817ebce8 R11: 0000000000000020 R12: ffff8f46ad4cd000
R13: 00000000fffffff7 R14: ffffadeb817ebe30 R15: 0000000000000004
FS:  0000000000000000(0000) GS:ffff8f46b7a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055828f0bbbf0 CR3: 0000000232176004 CR4: 00000000003606f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ? fput+0x13/0x20
 io_free_req+0x20/0x40
 io_put_req+0x1b/0x20
 io_submit_sqe+0x40a/0x680
 ? __switch_to_asm+0x34/0x70
 ? __switch_to_asm+0x40/0x70
 io_submit_sqes+0xb9/0x160
 ? io_submit_sqes+0xb9/0x160
 ? __switch_to_asm+0x40/0x70
 ? __switch_to_asm+0x34/0x70
 ? __schedule+0x3f2/0x6a0
 ? __switch_to_asm+0x34/0x70
 io_sq_thread+0x1af/0x470
 ? __switch_to_asm+0x34/0x70
 ? wait_woken+0x80/0x80
 ? __switch_to+0x85/0x410
 ? __switch_to_asm+0x40/0x70
 ? __switch_to_asm+0x34/0x70
 ? __schedule+0x3f2/0x6a0
 kthread+0x105/0x140
 ? io_submit_sqes+0x160/0x160
 ? kthread+0x105/0x140
 ? io_submit_sqes+0x160/0x160
 ? kthread_destroy_worker+0x50/0x50
 ret_from_fork+0x35/0x40

which occurs because using a kernel side submission thread isn't valid
without using fixed files (registered through io_uring_register()). This
causes io_uring to put the request after logging an error, but before
the file field is set in the request. If it happens to be non-zero, we
attempt to fput() garbage.

Fix this by ensuring that req->file is initialized when the request is
allocated.

Cc: stable@vger.kernel.org # 5.1+
Reported-by: Stephen Bates <sbates@raithlin.com>
Tested-by: Stephen Bates <sbates@raithlin.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -533,6 +533,7 @@ static struct io_kiocb *io_get_req(struc
 		state->cur_req++;
 	}
 
+	req->file = NULL;
 	req->ctx = ctx;
 	req->flags = 0;
 	/* one is dropped after submission, the other at completion */
@@ -1684,10 +1685,8 @@ static int io_req_set_file(struct io_rin
 	flags = READ_ONCE(s->sqe->flags);
 	fd = READ_ONCE(s->sqe->fd);
 
-	if (!io_op_needs_file(s->sqe)) {
-		req->file = NULL;
+	if (!io_op_needs_file(s->sqe))
 		return 0;
-	}
 
 	if (flags & IOSQE_FIXED_FILE) {
 		if (unlikely(!ctx->user_files ||


