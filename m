Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12D43137D4
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbhBHPcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:32:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:35838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233736AbhBHP1t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:27:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FB9264EEC;
        Mon,  8 Feb 2021 15:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797371;
        bh=Nlxqoox1cau/aUCslJVngJBdF2m/RXdXNHmrJaY6v4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdtvIsGKY84sVVEMd8Ovaur+gaQPf8TZ3npZvHD+rSWkffSjDM2BSZ/OAhixw3uoj
         ctDFdVwBE16GgOHqYSZxis/f2ixWgaNQ48A0UU2ocW8QiJLgacQEYu4kljJEruG8II
         ByWhRqERdY970coXXuf0TAEf6Y7sML6rTRuSfogY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 086/120] io_uring: dont modify identitys files uncess identity is cowed
Date:   Mon,  8 Feb 2021 16:01:13 +0100
Message-Id: <20210208145821.829903133@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

commit d7e10d47691d1702db1cd1edcc689d3031eefc67 upstream.

Abaci Robot reported following panic:
BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 800000010ef3f067 P4D 800000010ef3f067 PUD 10d9df067 PMD 0
Oops: 0002 [#1] SMP PTI
CPU: 0 PID: 1869 Comm: io_wqe_worker-0 Not tainted 5.11.0-rc3+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
RIP: 0010:put_files_struct+0x1b/0x120
Code: 24 18 c7 00 f4 ff ff ff e9 4d fd ff ff 66 90 0f 1f 44 00 00 41 57 41 56 49 89 fe 41 55 41 54 55 53 48 83 ec 08 e8 b5 6b db ff  41 ff 0e 74 13 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f e9 9c
RSP: 0000:ffffc90002147d48 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88810d9a5300 RCX: 0000000000000000
RDX: ffff88810d87c280 RSI: ffffffff8144ba6b RDI: 0000000000000000
RBP: 0000000000000080 R08: 0000000000000001 R09: ffffffff81431500
R10: ffff8881001be000 R11: 0000000000000000 R12: ffff88810ac2f800
R13: ffff88810af38a00 R14: 0000000000000000 R15: ffff8881057130c0
FS:  0000000000000000(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000010dbaa002 CR4: 00000000003706f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __io_clean_op+0x10c/0x2a0
 io_dismantle_req+0x3c7/0x600
 __io_free_req+0x34/0x280
 io_put_req+0x63/0xb0
 io_worker_handle_work+0x60e/0x830
 ? io_wqe_worker+0x135/0x520
 io_wqe_worker+0x158/0x520
 ? __kthread_parkme+0x96/0xc0
 ? io_worker_handle_work+0x830/0x830
 kthread+0x134/0x180
 ? kthread_create_worker_on_cpu+0x90/0x90
 ret_from_fork+0x1f/0x30
Modules linked in:
CR2: 0000000000000000
---[ end trace c358ca86af95b1e7 ]---

I guess case below can trigger above panic: there're two threads which
operates different io_uring ctxs and share same sqthread identity, and
later one thread exits, io_uring_cancel_task_requests() will clear
task->io_uring->identity->files to be NULL in sqpoll mode, then another
ctx that uses same identity will panic.

Indeed we don't need to clear task->io_uring->identity->files here,
io_grab_identity() should handle identity->files changes well, if
task->io_uring->identity->files is not equal to current->files,
io_cow_identity() should handle this changes well.

Cc: stable@vger.kernel.org # 5.5+
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8782,12 +8782,6 @@ static void io_uring_cancel_task_request
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);
-		/*
-		 * If the files that are going away are the ones in the thread
-		 * identity, clear them out.
-		 */
-		if (task->io_uring->identity->files == files)
-			task->io_uring->identity->files = NULL;
 		io_sq_thread_unpark(ctx->sq_data);
 	}
 }


