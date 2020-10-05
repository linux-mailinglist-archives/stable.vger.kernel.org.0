Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBE1283AE9
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgJEPi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbgJEPbE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:31:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B193C20637;
        Mon,  5 Oct 2020 15:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911863;
        bh=ImEhQ30IKXrbOT93ut3lbUL+NDPrKMxvv3NMQ6ig72Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=flTqJn6a8Y1RNcCuWE6RyKmppUzI5dzyI+LJc4xhryPHNXZW1db5ndGQMYJPZU47c
         2rm7H3uDZ6QpIKfDN7dJCuYbcAfUS89NI/4j+xfQpqcbnZEnJERohAgvHVKjinELJH
         ubGz5DAF1PgaqAsH829IerdfBsxYXZyFJd8wqfBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+81b3883093f772addf6d@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 01/85] io_uring: always delete double poll wait entry on match
Date:   Mon,  5 Oct 2020 17:25:57 +0200
Message-Id: <20201005142114.805252222@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 8706e04ed7d6c95004d42b22a4db97d5b2eb73b2 upstream.

syzbot reports a crash with tty polling, which is using the double poll
handling:

general protection fault, probably for non-canonical address 0xdffffc0000000009: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000048-0x000000000000004f]
CPU: 0 PID: 6874 Comm: syz-executor749 Not tainted 5.9.0-rc6-next-20200924-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_poll_get_single fs/io_uring.c:4778 [inline]
RIP: 0010:io_poll_double_wake+0x51/0x510 fs/io_uring.c:4845
Code: fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 9e 03 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 5d 08 48 8d 7b 48 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 06 0f 8e 63 03 00 00 0f b6 6b 48 bf 06 00 00
RSP: 0018:ffffc90001c1fb70 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000004
RDX: 0000000000000009 RSI: ffffffff81d9b3ad RDI: 0000000000000048
RBP: dffffc0000000000 R08: ffff8880a3cac798 R09: ffffc90001c1fc60
R10: fffff52000383f73 R11: 0000000000000000 R12: 0000000000000004
R13: ffff8880a3cac798 R14: ffff8880a3cac7a0 R15: 0000000000000004
FS:  0000000001f98880(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f18886916c0 CR3: 0000000094c5a000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __wake_up_common+0x147/0x650 kernel/sched/wait.c:93
 __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:123
 tty_ldisc_hangup+0x1cf/0x680 drivers/tty/tty_ldisc.c:735
 __tty_hangup.part.0+0x403/0x870 drivers/tty/tty_io.c:625
 __tty_hangup drivers/tty/tty_io.c:575 [inline]
 tty_vhangup+0x1d/0x30 drivers/tty/tty_io.c:698
 pty_close+0x3f5/0x550 drivers/tty/pty.c:79
 tty_release+0x455/0xf60 drivers/tty/tty_io.c:1679
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:165 [inline]
 exit_to_user_mode_prepare+0x1e2/0x1f0 kernel/entry/common.c:192
 syscall_exit_to_user_mode+0x7a/0x2c0 kernel/entry/common.c:267
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x401210

which is due to a failure in removing the double poll wait entry if we
hit a wakeup match. This can cause multiple invocations of the wakeup,
which isn't safe.

Cc: stable@vger.kernel.org # v5.8
Reported-by: syzbot+81b3883093f772addf6d@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4310,6 +4310,8 @@ static int io_poll_double_wake(struct wa
 	if (mask && !(mask & poll->events))
 		return 0;
 
+	list_del_init(&wait->entry);
+
 	if (poll && poll->head) {
 		bool done;
 


