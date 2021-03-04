Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253F032C9B3
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242241AbhCDBLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 20:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352097AbhCDAeo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 19:34:44 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C88CC0610D2
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 16:27:33 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id z5so2201099plg.3
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 16:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YmW4+HEOLVC8+6zuBFMtFGdAUA/imkWoN2FjKpIk2LE=;
        b=m7ov9kUQNMXE/zTcaihhRvvarZZ7+wxrLWoiuPhsDOxnNLRMoODHd9Ou1FVu6dgWiK
         ZiKuEfYtaQKaadX7yicLfbeH22NeNvjAcRBidC2SxwN7/TRU6AiHowZ/JVn523+b6MYK
         oiFBQM69prsqGLtm4GKAw+bXmk7+wLtYcx3nIYzkaO3FtaunqJmtZJylp0cApOorqAun
         eN8CPFX9whKu15bT3vAmTGrs3va73St/jiLpEyDIo9tWtkQ9fiHX+F/FrBGnXxOhTwbs
         Yk5NVJt5IqQVG1Quy5w8G+xrUCoSesY0URnV43CMWttGLrhLAU53j1X4n1yQSJSj3H8d
         yPlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YmW4+HEOLVC8+6zuBFMtFGdAUA/imkWoN2FjKpIk2LE=;
        b=c/L9peZ3y7TBySSocdbXwfFAIF59V4TlI+4Su7PaN8n7rjYytoa7kpXwt5FgSLs3eF
         WB8MJeqb4sT9clQ2fV/aeHFp9V61XW1rXlXSzQPrxSMkoSrROkG+AKQJu/zC9HxXnauK
         bwyb4YEza29WfgJ/ynMMS836vvk6oktV/B78ASo9FzS+vF8JOSK7P3fdVAj6oiBaC1N+
         0kSpwuJyVsFPLmq7pGjpK1YW8gvJgaMneLD/fogMRDCbxH2BzaV1JDManvpXldlCXw3i
         I6S27XSDUUlI7mv44w+q4m/UaT6JoBMLnMo5Jg8BOXA4EJNzCS9sxnyPznwxUS4jC21h
         ORJw==
X-Gm-Message-State: AOAM532QF//ak57A19pg5j3/esL/aozD+BvASeO5W/IUare1vZoDUjDh
        WkI3EQZ2pe5pQkfSE7EnHQq6TA==
X-Google-Smtp-Source: ABdhPJybRwsAsR7f1vQsYWLx7gR3AmeQm91ZsmxHXtlkOwTboWxkparXrNxV0oKnllPv+REJ1StfDQ==
X-Received: by 2002:a17:90a:fb47:: with SMTP id iq7mr1698063pjb.159.1614817652871;
        Wed, 03 Mar 2021 16:27:32 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:32 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        syzbot+28abd693db9e92c160d8@syzkaller.appspotmail.com
Subject: [PATCH 23/33] io_uring: ignore double poll add on the same waitqueue head
Date:   Wed,  3 Mar 2021 17:26:50 -0700
Message-Id: <20210304002700.374417-24-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot reports a deadlock, attempting to lock the same spinlock twice:

============================================
WARNING: possible recursive locking detected
5.11.0-syzkaller #0 Not tainted
--------------------------------------------
swapper/1/0 is trying to acquire lock:
ffff88801b2b1130 (&runtime->sleep){..-.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff88801b2b1130 (&runtime->sleep){..-.}-{2:2}, at: io_poll_double_wake+0x25f/0x6a0 fs/io_uring.c:4960

but task is already holding lock:
ffff88801b2b3130 (&runtime->sleep){..-.}-{2:2}, at: __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:137

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&runtime->sleep);
  lock(&runtime->sleep);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by swapper/1/0:
 #0: ffff888147474908 (&group->lock){..-.}-{2:2}, at: _snd_pcm_stream_lock_irqsave+0x9f/0xd0 sound/core/pcm_native.c:170
 #1: ffff88801b2b3130 (&runtime->sleep){..-.}-{2:2}, at: __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:137

stack backtrace:
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0xfa/0x151 lib/dump_stack.c:120
 print_deadlock_bug kernel/locking/lockdep.c:2829 [inline]
 check_deadlock kernel/locking/lockdep.c:2872 [inline]
 validate_chain kernel/locking/lockdep.c:3661 [inline]
 __lock_acquire.cold+0x14c/0x3b4 kernel/locking/lockdep.c:4900
 lock_acquire kernel/locking/lockdep.c:5510 [inline]
 lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 io_poll_double_wake+0x25f/0x6a0 fs/io_uring.c:4960
 __wake_up_common+0x147/0x650 kernel/sched/wait.c:108
 __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:138
 snd_pcm_update_state+0x46a/0x540 sound/core/pcm_lib.c:203
 snd_pcm_update_hw_ptr0+0xa75/0x1a50 sound/core/pcm_lib.c:464
 snd_pcm_period_elapsed+0x160/0x250 sound/core/pcm_lib.c:1805
 dummy_hrtimer_callback+0x94/0x1b0 sound/drivers/dummy.c:378
 __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
 __hrtimer_run_queues+0x609/0xe40 kernel/time/hrtimer.c:1583
 hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1600
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu kernel/softirq.c:422 [inline]
 irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:137 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:111 [inline]
RIP: 0010:acpi_idle_do_entry+0x1c9/0x250 drivers/acpi/processor_idle.c:516
Code: dd 38 6e f8 84 db 75 ac e8 54 32 6e f8 e8 0f 1c 74 f8 e9 0c 00 00 00 e8 45 32 6e f8 0f 00 2d 4e 4a c5 00 e8 39 32 6e f8 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 14 3a 6e f8 48 85 db
RSP: 0018:ffffc90000d47d18 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8880115c3780 RSI: ffffffff89052537 RDI: 0000000000000000
RBP: ffff888141127064 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff81794168 R11: 0000000000000000 R12: 0000000000000001
R13: ffff888141127000 R14: ffff888141127064 R15: ffff888143331804
 acpi_idle_enter+0x361/0x500 drivers/acpi/processor_idle.c:647
 cpuidle_enter_state+0x1b1/0xc80 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:158 [inline]
 cpuidle_idle_call kernel/sched/idle.c:239 [inline]
 do_idle+0x3e1/0x590 kernel/sched/idle.c:300
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:397
 start_secondary+0x274/0x350 arch/x86/kernel/smpboot.c:272
 secondary_startup_64_no_verify+0xb0/0xbb

which is due to the driver doing poll_wait() twice on the same
wait_queue_head. That is perfectly valid, but from checking the rest
of the kernel tree, it's the only driver that does this.

We can handle this just fine, we just need to ignore the second addition
as we'll get woken just fine on the first one.

Cc: stable@vger.kernel.org # 5.8+
Fixes: 18bceab101ad ("io_uring: allow POLL_ADD with double poll_wait() users")
Reported-by: syzbot+28abd693db9e92c160d8@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 549a5c5ee0b5..bdaeda5eefd5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4959,6 +4959,9 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 			pt->error = -EINVAL;
 			return;
 		}
+		/* double add on the same waitqueue head, ignore */
+		if (poll->head == head)
+			return;
 		poll = kmalloc(sizeof(*poll), GFP_ATOMIC);
 		if (!poll) {
 			pt->error = -ENOMEM;
-- 
2.30.1

