Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084631AC5F7
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408648AbgDPObZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:31:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34120 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388296AbgDPObT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 10:31:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587047477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QTWMpbTktAVYk+SbLJpTXF8mGx9KiEfJHn3C7GjisGs=;
        b=P1eQSXPUKJMOQpJOfeRv058N7M9FZ+rzNojpI0GYlxznp9c5qnul4JiJc/ahk8x4LeyjyV
        HjwRTS+tH2aBiHeXV97Z+ox5Ix4jSOtBrdhc4mNGlaSuSD67ahw7+RqzOf1S8UgNqbbZeH
        prQp6B6FcJ42zRd3XyS69EvRCihemgo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-5XOMxQSkN2SrvotDeDjguw-1; Thu, 16 Apr 2020 10:31:12 -0400
X-MC-Unique: 5XOMxQSkN2SrvotDeDjguw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46FDB13FA;
        Thu, 16 Apr 2020 14:31:11 +0000 (UTC)
Received: from krava (unknown [10.40.195.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 809395E241;
        Thu, 16 Apr 2020 14:31:07 +0000 (UTC)
Date:   Thu, 16 Apr 2020 16:31:04 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "bibo,mao" <bibo.mao@intel.com>,
        "Ziqian SUN (Zamir)" <zsun@redhat.com>, stable@vger.kernel.org
Subject: [PATCHv2] kretprobe: Prevent triggering kretprobe from within
 kprobe_flush_task
Message-ID: <20200416143104.GA400699@krava>
References: <20200408164641.3299633-1-jolsa@kernel.org>
 <20200409234101.8814f3cbead69337ac5a33fa@kernel.org>
 <20200409184451.GG3309111@krava>
 <20200409201336.GH3309111@krava>
 <20200410093159.0d7000a08fd76c2eaf1398f8@kernel.org>
 <20200414160338.GE208694@krava>
 <20200415090507.GG208694@krava>
 <20200416105506.904b7847a1b621b75463076d@kernel.org>
 <20200416091320.GA322899@krava>
 <20200416224250.7a53fb581e50aa32df75a0cf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416224250.7a53fb581e50aa32df75a0cf@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Fixes: ef53d9c5e4da ('kprobes: improve kretprobe scalability with hashed locking')
Cc: stable@vger.kernel.org
Reported-by: "Ziqian SUN (Zamir)" <zsun@redhat.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 16 +++-------------
 include/linux/kprobes.h        |  4 ++++
 kernel/kprobes.c               | 24 ++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 13 deletions(-)

v2 changes: updated changelog with Fixes/Ack and Cc stable

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 4d7022a740ab..a12adbe1559d 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -753,16 +753,11 @@ asm(
 NOKPROBE_SYMBOL(kretprobe_trampoline);
 STACK_FRAME_NON_STANDARD(kretprobe_trampoline);
 
-static struct kprobe kretprobe_kprobe = {
-	.addr = (void *)kretprobe_trampoline,
-};
-
 /*
  * Called from kretprobe_trampoline
  */
 __used __visible void *trampoline_handler(struct pt_regs *regs)
 {
-	struct kprobe_ctlblk *kcb;
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
 	struct hlist_node *tmp;
@@ -772,16 +767,12 @@ __used __visible void *trampoline_handler(struct pt_regs *regs)
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
@@ -857,7 +848,7 @@ __used __visible void *trampoline_handler(struct pt_regs *regs)
 			__this_cpu_write(current_kprobe, &ri->rp->kp);
 			ri->ret_addr = correct_ret_addr;
 			ri->rp->handler(ri, regs);
-			__this_cpu_write(current_kprobe, &kretprobe_kprobe);
+			__this_cpu_write(current_kprobe, &kprobe_busy);
 		}
 
 		recycle_rp_inst(ri, &empty_rp);
@@ -873,8 +864,7 @@ __used __visible void *trampoline_handler(struct pt_regs *regs)
 
 	kretprobe_hash_unlock(current, &flags);
 
-	__this_cpu_write(current_kprobe, NULL);
-	preempt_enable();
+	kprobe_busy_end();
 
 	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 04bdaf01112c..645fd401c856 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -350,6 +350,10 @@ static inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
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
index 2625c241ac00..75bb4a8458e7 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1236,6 +1236,26 @@ __releases(hlist_lock)
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
@@ -1253,6 +1273,8 @@ void kprobe_flush_task(struct task_struct *tk)
 		/* Early boot.  kretprobe_table_locks not yet initialized. */
 		return;
 
+	kprobe_busy_begin();
+
 	INIT_HLIST_HEAD(&empty_rp);
 	hash = hash_ptr(tk, KPROBE_HASH_BITS);
 	head = &kretprobe_inst_table[hash];
@@ -1266,6 +1288,8 @@ void kprobe_flush_task(struct task_struct *tk)
 		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
+
+	kprobe_busy_end();
 }
 NOKPROBE_SYMBOL(kprobe_flush_task);
 
-- 
2.18.2

