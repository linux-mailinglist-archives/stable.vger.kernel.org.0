Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348B42E99DB
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbhADQEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:04:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbhADQEA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:04:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76EF122473;
        Mon,  4 Jan 2021 16:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776199;
        bh=56E5cNjWk2QLFnVKuRCWxNh62W8kVyGMhWdYq4hQeDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zMwP7sPSwKo9uCaRA+/bSPfntxxopFFEzBR4QqguYfQzjyCyiI+cOJnPDZChcv7MH
         hMrtsu3ePvynVE+ppZhpPxZ/9pWa3yCcR75pv1vhU+ocX3kYIPAyDUyjTh1UUIfn1E
         0L5EYxU2sCU5x1I7jlrTqjCbwk9VNKNsdOu4Ey3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+03beeb595f074db9cfd1@syzkaller.appspotmail.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 38/63] io_uring: check kthread stopped flag when sq thread is unparked
Date:   Mon,  4 Jan 2021 16:57:31 +0100
Message-Id: <20210104155710.668728286@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

commit 65b2b213484acd89a3c20dbb524e52a2f3793b78 upstream.

syzbot reports following issue:
INFO: task syz-executor.2:12399 can't die for more than 143 seconds.
task:syz-executor.2  state:D stack:28744 pid:12399 ppid:  8504 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3773 [inline]
 __schedule+0x893/0x2170 kernel/sched/core.c:4522
 schedule+0xcf/0x270 kernel/sched/core.c:4600
 schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1847
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
 kthread_stop+0x17a/0x720 kernel/kthread.c:596
 io_put_sq_data fs/io_uring.c:7193 [inline]
 io_sq_thread_stop+0x452/0x570 fs/io_uring.c:7290
 io_finish_async fs/io_uring.c:7297 [inline]
 io_sq_offload_create fs/io_uring.c:8015 [inline]
 io_uring_create fs/io_uring.c:9433 [inline]
 io_uring_setup+0x19b7/0x3730 fs/io_uring.c:9507
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45deb9
Code: Unable to access opcode bytes at RIP 0x45de8f.
RSP: 002b:00007f174e51ac78 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000008640 RCX: 000000000045deb9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 00000000000050e5
RBP: 000000000118bf58 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007ffed9ca723f R14: 00007f174e51b9c0 R15: 000000000118bf2c
INFO: task syz-executor.2:12399 blocked for more than 143 seconds.
      Not tainted 5.10.0-rc3-next-20201110-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

Currently we don't have a reproducer yet, but seems that there is a
race in current codes:
=> io_put_sq_data
      ctx_list is empty now.       |
==> kthread_park(sqd->thread);     |
                                   | T1: sq thread is parked now.
==> kthread_stop(sqd->thread);     |
    KTHREAD_SHOULD_STOP is set now.|
===> kthread_unpark(k);            |
                                   | T2: sq thread is now unparkd, run again.
                                   |
                                   | T3: sq thread is now preempted out.
                                   |
===> wake_up_process(k);           |
                                   |
                                   | T4: Since sqd ctx_list is empty, needs_sched will be true,
                                   | then sq thread sets task state to TASK_INTERRUPTIBLE,
                                   | and schedule, now sq thread will never be waken up.
===> wait_for_completion           |

I have artificially used mdelay() to simulate above race, will get same
stack like this syzbot report, but to be honest, I'm not sure this code
race triggers syzbot report.

To fix this possible code race, when sq thread is unparked, need to check
whether sq thread has been stopped.

Reported-by: syzbot+03beeb595f074db9cfd1@syzkaller.appspotmail.com
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6802,8 +6802,16 @@ static int io_sq_thread(void *data)
 		 * kthread parking. This synchronizes the thread vs users,
 		 * the users are synchronized on the sqd->ctx_lock.
 		 */
-		if (kthread_should_park())
+		if (kthread_should_park()) {
 			kthread_parkme();
+			/*
+			 * When sq thread is unparked, in case the previous park operation
+			 * comes from io_put_sq_data(), which means that sq thread is going
+			 * to be stopped, so here needs to have a check.
+			 */
+			if (kthread_should_stop())
+				break;
+		}
 
 		if (unlikely(!list_empty(&sqd->ctx_new_list)))
 			io_sqd_init_new(sqd);


