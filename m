Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC6E541497
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355759AbiFGUT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355434AbiFGURZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:17:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0CF1D0582;
        Tue,  7 Jun 2022 11:30:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C36AB82381;
        Tue,  7 Jun 2022 18:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967C0C36B0D;
        Tue,  7 Jun 2022 18:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626588;
        bh=Yv6FI+pLlmEH4JkZSVVxyZBCsQLSSOJb/rHYwVeFxq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ZOLsZVd5xdCTFbkMh29ITJjlZSlgcl/+Ih0Agu9fHeXqaa/IrTVXasxHRGNYMAqr
         pZ5pJZObhkAZPuLBHOKuStozG5Q5bbhl4lW3pH7GaohtzHewdxC1uvJxm2qtNbKTEY
         Wnfmo9HcNyZQaZkP1iGWQ7LpdJ61RWVHBRfKDEHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+09ad4050dd3a120bfccd@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 391/772] io_uring: fix assuming triggered poll waitqueue is the single poll
Date:   Tue,  7 Jun 2022 18:59:43 +0200
Message-Id: <20220607165000.534325410@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit d89a4fac0fbc6fe5fc24d1c9a889440dcf410368 ]

syzbot reports a recent regression:

BUG: KASAN: use-after-free in __wake_up_common+0x637/0x650 kernel/sched/wait.c:101
Read of size 8 at addr ffff888011e8a130 by task syz-executor413/3618

CPU: 0 PID: 3618 Comm: syz-executor413 Tainted: G        W         5.17.0-syzkaller-01402-g8565d64430f8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x303 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 __wake_up_common+0x637/0x650 kernel/sched/wait.c:101
 __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:138
 tty_release+0x657/0x1200 drivers/tty/tty_io.c:1781
 __fput+0x286/0x9f0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xaff/0x29d0 kernel/exit.c:806
 do_group_exit+0xd2/0x2f0 kernel/exit.c:936
 __do_sys_exit_group kernel/exit.c:947 [inline]
 __se_sys_exit_group kernel/exit.c:945 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:945
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f439a1fac69

which is due to leaving the request on the waitqueue mistakenly. The
reproducer is using a tty device, which means we end up arming the same
poll queue twice (it uses the same poll waitqueue for both), but in
io_poll_wake() we always just clear REQ_F_SINGLE_POLL regardless of which
entry triggered. This leaves one waitqueue potentially armed after we're
done, which then blows up in tty when the waitqueue is attempted removed.

We have no room to store this information, so simply encode it in the
wait_queue_entry->private where we store the io_kiocb request pointer.

Fixes: 91eac1c69c20 ("io_uring: cache poll/double-poll state with a request flag")
Reported-by: syzbot+09ad4050dd3a120bfccd@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8711d92f4d71..25b0832e0fc3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5632,10 +5632,13 @@ static void io_poll_cancel_req(struct io_kiocb *req)
 	io_poll_execute(req, 0);
 }
 
+#define wqe_to_req(wait)	((void *)((unsigned long) (wait)->private & ~1))
+#define wqe_is_double(wait)	((unsigned long) (wait)->private & 1)
+
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			void *key)
 {
-	struct io_kiocb *req = wait->private;
+	struct io_kiocb *req = wqe_to_req(wait);
 	struct io_poll_iocb *poll = container_of(wait, struct io_poll_iocb,
 						 wait);
 	__poll_t mask = key_to_poll(key);
@@ -5673,7 +5676,10 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 		if (mask && poll->events & EPOLLONESHOT) {
 			list_del_init(&poll->wait.entry);
 			poll->head = NULL;
-			req->flags &= ~REQ_F_SINGLE_POLL;
+			if (wqe_is_double(wait))
+				req->flags &= ~REQ_F_DOUBLE_POLL;
+			else
+				req->flags &= ~REQ_F_SINGLE_POLL;
 		}
 		__io_poll_execute(req, mask);
 	}
@@ -5685,6 +5691,7 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 			    struct io_poll_iocb **poll_ptr)
 {
 	struct io_kiocb *req = pt->req;
+	unsigned long wqe_private = (unsigned long) req;
 
 	/*
 	 * The file being polled uses multiple waitqueues for poll handling
@@ -5710,6 +5717,8 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 			pt->error = -ENOMEM;
 			return;
 		}
+		/* mark as double wq entry */
+		wqe_private |= 1;
 		req->flags |= REQ_F_DOUBLE_POLL;
 		io_init_poll_iocb(poll, first->events, first->wait.func);
 		*poll_ptr = poll;
@@ -5720,7 +5729,7 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 	req->flags |= REQ_F_SINGLE_POLL;
 	pt->nr_entries++;
 	poll->head = head;
-	poll->wait.private = req;
+	poll->wait.private = (void *) wqe_private;
 
 	if (poll->events & EPOLLEXCLUSIVE)
 		add_wait_queue_exclusive(head, &poll->wait);
@@ -5747,7 +5756,6 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	INIT_HLIST_NODE(&req->hash_node);
 	io_init_poll_iocb(poll, mask, io_poll_wake);
 	poll->file = req->file;
-	poll->wait.private = req;
 
 	ipt->pt._key = mask;
 	ipt->req = req;
-- 
2.35.1



