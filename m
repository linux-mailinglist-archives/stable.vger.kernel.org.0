Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D579820617A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392486AbgFWUnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392478AbgFWUnH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:43:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3FD12053B;
        Tue, 23 Jun 2020 20:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944987;
        bh=Hujp0Lv2r1Kw5z4R/aHZVV41Lsz/IsjSjII/Lr4698g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5R20S5tsDZJGAARDadB3OikAADIDQ/5W5exPHVBzbU/892W/Am87oSRXEVKelj5+
         zKVfGsojVdEQLkYD4Zq5OAleY4ir34JpPySnqp/ydnhr0vY8eVSTE9vgJlOhqArxAX
         V/qDw4C6dYBOQAAlajlwnTNl86FwjUmc2nGSJYYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        David Miller <davem@davemloft.net>,
        Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Ziqian SUN (Zamir)" <zsun@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 203/206] kretprobe: Prevent triggering kretprobe from within kprobe_flush_task
Date:   Tue, 23 Jun 2020 21:58:51 +0200
Message-Id: <20200623195327.027956628@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

[ Upstream commit 9b38cc704e844e41d9cf74e647bff1d249512cb3 ]

Ziqian reported lockup when adding retprobe on _raw_spin_lock_irqsave.
My test was also able to trigger lockdep output:

 ============================================
 WARNING: possible recursive locking detected
 5.6.0-rc6+ #6 Not tainted
 --------------------------------------------
 sched-messaging/2767 is trying to acquire lock:
 ffffffff9a492798 (&(kretprobe_table_locks[i].lock)){-.-.}, at: kretprobe_hash_lock+0x52/0xa0

 but task is already holding lock:
 ffffffff9a491a18 (&(kretprobe_table_locks[i].lock)){-.-.}, at: kretprobe_trampoline+0x0/0x50

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&(kretprobe_table_locks[i].lock));
   lock(&(kretprobe_table_locks[i].lock));

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 1 lock held by sched-messaging/2767:
  #0: ffffffff9a491a18 (&(kretprobe_table_locks[i].lock)){-.-.}, at: kretprobe_trampoline+0x0/0x50

 stack backtrace:
 CPU: 3 PID: 2767 Comm: sched-messaging Not tainted 5.6.0-rc6+ #6
 Call Trace:
  dump_stack+0x96/0xe0
  __lock_acquire.cold.57+0x173/0x2b7
  ? native_queued_spin_lock_slowpath+0x42b/0x9e0
  ? lockdep_hardirqs_on+0x590/0x590
  ? __lock_acquire+0xf63/0x4030
  lock_acquire+0x15a/0x3d0
  ? kretprobe_hash_lock+0x52/0xa0
  _raw_spin_lock_irqsave+0x36/0x70
  ? kretprobe_hash_lock+0x52/0xa0
  kretprobe_hash_lock+0x52/0xa0
  trampoline_handler+0xf8/0x940
  ? kprobe_fault_handler+0x380/0x380
  ? find_held_lock+0x3a/0x1c0
  kretprobe_trampoline+0x25/0x50
  ? lock_acquired+0x392/0xbc0
  ? _raw_spin_lock_irqsave+0x50/0x70
  ? __get_valid_kprobe+0x1f0/0x1f0
  ? _raw_spin_unlock_irqrestore+0x3b/0x40
  ? finish_task_switch+0x4b9/0x6d0
  ? __switch_to_asm+0x34/0x70
  ? __switch_to_asm+0x40/0x70

The code within the kretprobe handler checks for probe reentrancy,
so we won't trigger any _raw_spin_lock_irqsave probe in there.

The problem is in outside kprobe_flush_task, where we call:

  kprobe_flush_task
    kretprobe_table_lock
      raw_spin_lock_irqsave
        _raw_spin_lock_irqsave

where _raw_spin_lock_irqsave triggers the kretprobe and installs
kretprobe_trampoline handler on _raw_spin_lock_irqsave return.

The kretprobe_trampoline handler is then executed with already
locked kretprobe_table_locks, and first thing it does is to
lock kretprobe_table_locks ;-) the whole lockup path like:

  kprobe_flush_task
    kretprobe_table_lock
      raw_spin_lock_irqsave
        _raw_spin_lock_irqsave ---> probe triggered, kretprobe_trampoline installed

        ---> kretprobe_table_locks locked

        kretprobe_trampoline
          trampoline_handler
            kretprobe_hash_lock(current, &head, &flags);  <--- deadlock

Adding kprobe_busy_begin/end helpers that mark code with fake
probe installed to prevent triggering of another kprobe within
this code.

Using these helpers in kprobe_flush_task, so the probe recursion
protection check is hit and the probe is never set to prevent
above lockup.

Link: http://lkml.kernel.org/r/158927059835.27680.7011202830041561604.stgit@devnote2

Fixes: ef53d9c5e4da ("kprobes: improve kretprobe scalability with hashed locking")
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Reported-by: "Ziqian SUN (Zamir)" <zsun@redhat.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 16 +++-------------
 include/linux/kprobes.h        |  4 ++++
 kernel/kprobes.c               | 24 ++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 173e915e11d54..07e290244ca94 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -765,16 +765,11 @@ asm(
 NOKPROBE_SYMBOL(kretprobe_trampoline);
 STACK_FRAME_NON_STANDARD(kretprobe_trampoline);
 
-static struct kprobe kretprobe_kprobe = {
-	.addr = (void *)kretprobe_trampoline,
-};
-
 /*
  * Called from kretprobe_trampoline
  */
 __visible __used void *trampoline_handler(struct pt_regs *regs)
 {
-	struct kprobe_ctlblk *kcb;
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
 	struct hlist_node *tmp;
@@ -784,16 +779,12 @@ __visible __used void *trampoline_handler(struct pt_regs *regs)
 	void *frame_pointer;
 	bool skipped = false;
 
-	preempt_disable();
-
 	/*
 	 * Set a dummy kprobe for avoiding kretprobe recursion.
 	 * Since kretprobe never run in kprobe handler, kprobe must not
 	 * be running at this point.
 	 */
-	kcb = get_kprobe_ctlblk();
-	__this_cpu_write(current_kprobe, &kretprobe_kprobe);
-	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+	kprobe_busy_begin();
 
 	INIT_HLIST_HEAD(&empty_rp);
 	kretprobe_hash_lock(current, &head, &flags);
@@ -872,7 +863,7 @@ __visible __used void *trampoline_handler(struct pt_regs *regs)
 			__this_cpu_write(current_kprobe, &ri->rp->kp);
 			ri->ret_addr = correct_ret_addr;
 			ri->rp->handler(ri, regs);
-			__this_cpu_write(current_kprobe, &kretprobe_kprobe);
+			__this_cpu_write(current_kprobe, &kprobe_busy);
 		}
 
 		recycle_rp_inst(ri, &empty_rp);
@@ -888,8 +879,7 @@ __visible __used void *trampoline_handler(struct pt_regs *regs)
 
 	kretprobe_hash_unlock(current, &flags);
 
-	__this_cpu_write(current_kprobe, NULL);
-	preempt_enable();
+	kprobe_busy_end();
 
 	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 9adb92ad24d3f..9f22652d69bb0 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -363,6 +363,10 @@ static inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
 	return this_cpu_ptr(&kprobe_ctlblk);
 }
 
+extern struct kprobe kprobe_busy;
+void kprobe_busy_begin(void);
+void kprobe_busy_end(void);
+
 kprobe_opcode_t *kprobe_lookup_name(const char *name, unsigned int offset);
 int register_kprobe(struct kprobe *p);
 void unregister_kprobe(struct kprobe *p);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3174fe1bb711b..97de04a52c9fe 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1227,6 +1227,26 @@ __releases(hlist_lock)
 }
 NOKPROBE_SYMBOL(kretprobe_table_unlock);
 
+struct kprobe kprobe_busy = {
+	.addr = (void *) get_kprobe,
+};
+
+void kprobe_busy_begin(void)
+{
+	struct kprobe_ctlblk *kcb;
+
+	preempt_disable();
+	__this_cpu_write(current_kprobe, &kprobe_busy);
+	kcb = get_kprobe_ctlblk();
+	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+}
+
+void kprobe_busy_end(void)
+{
+	__this_cpu_write(current_kprobe, NULL);
+	preempt_enable();
+}
+
 /*
  * This function is called from finish_task_switch when task tk becomes dead,
  * so that we can recycle any function-return probe instances associated
@@ -1244,6 +1264,8 @@ void kprobe_flush_task(struct task_struct *tk)
 		/* Early boot.  kretprobe_table_locks not yet initialized. */
 		return;
 
+	kprobe_busy_begin();
+
 	INIT_HLIST_HEAD(&empty_rp);
 	hash = hash_ptr(tk, KPROBE_HASH_BITS);
 	head = &kretprobe_inst_table[hash];
@@ -1257,6 +1279,8 @@ void kprobe_flush_task(struct task_struct *tk)
 		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
+
+	kprobe_busy_end();
 }
 NOKPROBE_SYMBOL(kprobe_flush_task);
 
-- 
2.25.1



