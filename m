Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21666333B85
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 12:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbhCJLfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 06:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbhCJLe7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 06:34:59 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36467C061761
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:34:52 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id v15so22941864wrx.4
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RRM3mpG3Dc8xCV556D/wCxQjpf5H994qHluUojN4Jlc=;
        b=osAb5VDh2V7Nw2/t9PLjkvzBirkQUQWt85Xu+aObNF0R0QR3NhOkrbaMDm7EzGvUVl
         Ej8/2uhgnkwmOaeeSx+H2G44EpVYXJYtX/TLSaL0bHiyhvWTXZFHEhhZiJFZOCfzGGuh
         oHAL5NO7DGw0/CX8MT3JCyD4I0APjBJYFPgkqndxvtckirKguz/OZSJtYuSacR4KQFfL
         HXtda6NbtIDawqo68dhj2TZDrkHNbvPeS4vJiM0P+TODYTqYSQ7iFI2WXwDQ0w+WWZaj
         ehLVPo0GLzR5Z4wcGVeh7gj5Wx7K6gkEb3gCBHr7pXzNEODGPYaUwM0lOz2BFR7anDgj
         ObCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RRM3mpG3Dc8xCV556D/wCxQjpf5H994qHluUojN4Jlc=;
        b=nyAxEPSc8nP4fMHDTLMveZWuRyOdlS7IM49x963NLyRBlWhu+ajj9qmOX4XK/Ohouw
         xPLbwkM/doBPYYwJMZIc5xN1KoPlX45mie6xi6FgvxpMjSOECzDUqDFmrizcPJ2/zBs2
         og12KepThNmdoz4dui2z5lx2sFOCTl26d5MBUgJjLN+ku6GMbk0OAwsZApn4H3sqnKzM
         eQBJl9/ljhmNB9WvmCTnQ92jVtplj1qrs6WhQprjXV9z47zh5ZVO84Hrmq2h+pudmWOC
         FcgQRM4J/VNXDSLXFv+1Y1ULsEyS3FzXJ60me/f3RKjcoIOZPQz0ZXhn6bpRnXJL0T1s
         IFcQ==
X-Gm-Message-State: AOAM530oZP1E3gwQT7Yu8Tb74TdgAfwAOoLY3yCwp81IoH7BMq9KkSdG
        2PPCRosIKVVRyyEziOrRPqKZatectYb9zg==
X-Google-Smtp-Source: ABdhPJyQYrLIpSM0QglSa4T+M8cjTTpXdmbAwz1OuMJ6I8ZycGU6K5zssnFXCVxFgElDgaeeHYIuVQ==
X-Received: by 2002:a5d:4523:: with SMTP id j3mr3169212wra.288.1615376090748;
        Wed, 10 Mar 2021 03:34:50 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.55])
        by smtp.gmail.com with ESMTPSA id s18sm25179078wrr.27.2021.03.10.03.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 03:34:50 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+81d17233a2b02eafba33@syzkaller.appspotmail.com
Subject: [PATCH 1/9] io_uring: fix inconsistent lock state
Date:   Wed, 10 Mar 2021 11:30:37 +0000
Message-Id: <780db85414287452e1c4d208b2a1920760cad721.1615375332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615375332.git.asml.silence@gmail.com>
References: <cover.1615375332.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commin 9ae1f8dd372e0e4c020b345cf9e09f519265e981 upstream

WARNING: inconsistent lock state

inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
syz-executor217/8450 [HC1[1]:SC0[0]:HE0:SE1] takes:
ffff888023d6e620 (&fs->lock){?.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff888023d6e620 (&fs->lock){?.+.}-{2:2}, at: io_req_clean_work fs/io_uring.c:1398 [inline]
ffff888023d6e620 (&fs->lock){?.+.}-{2:2}, at: io_dismantle_req+0x66f/0xf60 fs/io_uring.c:2029

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&fs->lock);
  <Interrupt>
    lock(&fs->lock);

 *** DEADLOCK ***

1 lock held by syz-executor217/8450:
 #0: ffff88802417c3e8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x1071/0x1f30 fs/io_uring.c:9442

stack backtrace:
CPU: 1 PID: 8450 Comm: syz-executor217 Not tainted 5.11.0-rc5-next-20210129-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
[...]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 io_req_clean_work fs/io_uring.c:1398 [inline]
 io_dismantle_req+0x66f/0xf60 fs/io_uring.c:2029
 __io_free_req+0x3d/0x2e0 fs/io_uring.c:2046
 io_free_req fs/io_uring.c:2269 [inline]
 io_double_put_req fs/io_uring.c:2392 [inline]
 io_put_req+0xf9/0x570 fs/io_uring.c:2388
 io_link_timeout_fn+0x30c/0x480 fs/io_uring.c:6497
 __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
 __hrtimer_run_queues+0x609/0xe40 kernel/time/hrtimer.c:1583
 hrtimer_interrupt+0x334/0x940 kernel/time/hrtimer.c:1645
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1085 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1102
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_sysvec_on_irqstack arch/x86/include/asm/irq_stack.h:37 [inline]
 run_sysvec_on_irqstack_cond arch/x86/include/asm/irq_stack.h:89 [inline]
 sysvec_apic_timer_interrupt+0xbd/0x100 arch/x86/kernel/apic/apic.c:1096
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:629
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x25/0x40 kernel/locking/spinlock.c:199
 spin_unlock_irq include/linux/spinlock.h:404 [inline]
 io_queue_linked_timeout+0x194/0x1f0 fs/io_uring.c:6525
 __io_queue_sqe+0x328/0x1290 fs/io_uring.c:6594
 io_queue_sqe+0x631/0x10d0 fs/io_uring.c:6639
 io_queue_link_head fs/io_uring.c:6650 [inline]
 io_submit_sqe fs/io_uring.c:6697 [inline]
 io_submit_sqes+0x19b5/0x2720 fs/io_uring.c:6960
 __do_sys_io_uring_enter+0x107d/0x1f30 fs/io_uring.c:9443
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Don't free requests from under hrtimer context (softirq) as it may sleep
or take spinlocks improperly (e.g. non-irq versions).

Cc: stable@vger.kernel.org # 5.6+
Reported-by: syzbot+81d17233a2b02eafba33@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 38bfd168ad3b..a1d08b641d0f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6506,9 +6506,10 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	if (prev) {
 		req_set_fail_links(prev);
 		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
-		io_put_req(prev);
+		io_put_req_deferred(prev, 1);
 	} else {
-		io_req_complete(req, -ETIME);
+		io_cqring_add_event(req, -ETIME, 0);
+		io_put_req_deferred(req, 1);
 	}
 	return HRTIMER_NORESTART;
 }
-- 
2.24.0

