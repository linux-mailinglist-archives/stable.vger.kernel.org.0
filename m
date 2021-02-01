Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DCF30B001
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 20:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhBATEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 14:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbhBATE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 14:04:28 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243D9C06174A;
        Mon,  1 Feb 2021 11:03:47 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id m1so233044wml.2;
        Mon, 01 Feb 2021 11:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nsV+h0AspmbblkREq7Z9etoj7dQAOVcy9STr53svlcw=;
        b=TbLiLqcFEvccNvDejv+MrkiIa4SksrrYFOTeViuaEoDNBwhtze7OHtHSpQyu8NVoYq
         MoIK6qYg7526Ru8AjyjTEDg3KKMpJTX8P69X7bhaAwGfMiFb3RxsJIFPNOs4FajTqMLf
         DNzFyJtk2ycJHLmiyiCqryaxvZQGvKT8NiZZQIqOJf2elTMoYnza6EjO9HUBeAwWqXBj
         +0QJVa4WxdcxiOLAyfyNAw5Vn1YBOTfcO04BnZtQEq0APq1zmSKuge8gnjzfxy0sx7uJ
         ORsQ6U2yrJgmRcXLF8PhY5t01PECX0fPSEDxZM4wuBq9dCa0pJrk3Cw79GPE2W0YYBwe
         MtTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nsV+h0AspmbblkREq7Z9etoj7dQAOVcy9STr53svlcw=;
        b=Pe270uTAJD7kl6tooBx4f29leZbi1c/zR0wSh1f/lG5jyMRhabTdMQz4aCA3JZYYd+
         PWzzsdhyHslKfPkDxkDDrJl+5SeoJqwZEfLeI6ax5UKh855d9Ab8uNNGcEqxXIwABaD2
         ggudqEf+W55vzsESrtYm8Hn+aIVeIhm/2tnP4T2uKttG56nA9FIWDCuYuwrU4DWuOcEB
         xl04D6YKmGTsmX1itpYphGW5YwHHqTHjSAA2v7IGFAP7j/lvzuiZ5b1/hDkdhANAZAmG
         8kKFz+BKO7ic+GVVNSkY/LKP12OUT89sycVJakhV3vkydjGgd9Heo1inwSwOWS+EFa5p
         ThUQ==
X-Gm-Message-State: AOAM531K70oA5dkVdXFQ4kTdqMD0ouZk8YLoBPoa4afXf0aDgmwUbmAZ
        Q9h5lpdreFbL3U3xxAtyYzw=
X-Google-Smtp-Source: ABdhPJzRIo5/Vdjo63MwdrSpKHcZiMK+9csIWh8knaTpr+BQlKNIDwjkjiR/MVS6OVRbA7cO/CwbtA==
X-Received: by 2002:a1c:6384:: with SMTP id x126mr306471wmb.52.1612206225762;
        Mon, 01 Feb 2021 11:03:45 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id h14sm182728wmq.45.2021.02.01.11.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 11:03:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org,
        syzbot+81d17233a2b02eafba33@syzkaller.appspotmail.com
Subject: [PATCH 1/6] io_uring: fix inconsistent lock state
Date:   Mon,  1 Feb 2021 18:59:51 +0000
Message-Id: <f8e1c4eb45371000a86eaa24a9fc1b1ad116608a.1612205712.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612205712.git.asml.silence@gmail.com>
References: <cover.1612205712.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/io_uring.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a8bf867b6cf2..f3252ff6542b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1886,8 +1886,8 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 	__io_cqring_fill_event(req, res, 0);
 }
 
-static void io_req_complete_nostate(struct io_kiocb *req, long res,
-				    unsigned int cflags)
+static void io_req_complete_post(struct io_kiocb *req, long res,
+				 unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
@@ -1898,6 +1898,12 @@ static void io_req_complete_nostate(struct io_kiocb *req, long res,
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	io_cqring_ev_posted(ctx);
+}
+
+static inline void io_req_complete_nostate(struct io_kiocb *req, long res,
+					   unsigned int cflags)
+{
+	io_req_complete_post(req, res, cflags);
 	io_put_req(req);
 }
 
@@ -6489,9 +6495,10 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	if (prev) {
 		req_set_fail_links(prev);
 		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
-		io_put_req(prev);
+		io_put_req_deferred(prev, 1);
 	} else {
-		io_req_complete(req, -ETIME);
+		io_req_complete_post(req, -ETIME, 0);
+		io_put_req_deferred(req, 1);
 	}
 	return HRTIMER_NORESTART;
 }
-- 
2.24.0

