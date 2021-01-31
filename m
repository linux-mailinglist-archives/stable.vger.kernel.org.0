Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83394309F5E
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 00:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhAaXIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 18:08:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhAaXHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 31 Jan 2021 18:07:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BA4564E3B;
        Sun, 31 Jan 2021 23:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612134366;
        bh=xbeqdSJTFKQL09N89i7fGchr5c55MOuzlCw8yty7Y4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxRW/uUffVCtwHqqzMj894TnktckRtXYdLry0jiB/YAkMLmnSFJHk7WMACODCP4DZ
         xvNvtyPUOjYV5b0hbdjs39Uepv/j8tDukb6QJbHtwQMq7YcooEfbP+r2/CjYqCwtfT
         sgYgWSsi0Yxx6puGPlGWMLEG5eGpp3SLsDAFnXonjCBZ6VImiRyK1GuxESp+udcuXB
         F5f3kY5bY3Ow44MOKQ3ULomfO8QeQ72yAcNzSMHeNWxnUmOcCXkWR889dgmoXSIBlI
         pn2zztSs7qWP82MsTVqM9a+8ZNWNTJp0LUI7JW/WheJLJqF9PxYVgNPoBudZNbgcKr
         xaEHbbd290yZA==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5/5] entry/kvm: Explicitly flush pending rcuog wakeup before last rescheduling point
Date:   Mon,  1 Feb 2021 00:05:48 +0100
Message-Id: <20210131230548.32970-6-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210131230548.32970-1-frederic@kernel.org>
References: <20210131230548.32970-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following the idle loop model, cleanly check for pending rcuog wakeup
before the last rescheduling point upon resuming to guest mode. This
way we can avoid to do it from rcu_user_enter() with the last resort
self-IPI hack that enforces rescheduling.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c        |  1 +
 include/linux/entry-kvm.h | 14 +++++++++++++
 kernel/rcu/tree.c         | 44 ++++++++++++++++++++++++++++++---------
 kernel/rcu/tree_plugin.h  |  1 +
 4 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a8969a6dd06..7fd4f70c229b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1773,6 +1773,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
 bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
 {
+	xfer_to_guest_mode_prepare();
 	return vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu) ||
 		xfer_to_guest_mode_work_pending();
 }
diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
index 9b93f8584ff7..8b2b1d68b954 100644
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-kvm.h
@@ -46,6 +46,20 @@ static inline int arch_xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu,
  */
 int xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu);
 
+/**
+ * xfer_to_guest_mode_prepare - Perform last minute preparation work that
+ *				need to be handled while IRQs are disabled
+ *				upon entering to guest.
+ *
+ * Has to be invoked with interrupts disabled before the last call
+ * to xfer_to_guest_mode_work_pending().
+ */
+static inline void xfer_to_guest_mode_prepare(void)
+{
+	lockdep_assert_irqs_disabled();
+	rcu_nocb_flush_deferred_wakeup();
+}
+
 /**
  * __xfer_to_guest_mode_work_pending - Check if work is pending
  *
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 2ebc211fffcb..ce17b8477442 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -678,9 +678,10 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
 
 #ifdef CONFIG_NO_HZ_FULL
 
+#if !defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_KVM_XFER_TO_GUEST_WORK)
 /*
  * An empty function that will trigger a reschedule on
- * IRQ tail once IRQs get re-enabled on userspace resume.
+ * IRQ tail once IRQs get re-enabled on userspace/guest resume.
  */
 static void late_wakeup_func(struct irq_work *work)
 {
@@ -689,6 +690,37 @@ static void late_wakeup_func(struct irq_work *work)
 static DEFINE_PER_CPU(struct irq_work, late_wakeup_work) =
 	IRQ_WORK_INIT(late_wakeup_func);
 
+/*
+ * If either:
+ *
+ * 1) the task is about to enter in guest mode and $ARCH doesn't support KVM generic work
+ * 2) the task is about to enter in user mode and $ARCH doesn't support generic entry.
+ *
+ * In these cases the late RCU wake ups aren't supported in the resched loops and our
+ * last resort is to fire a local irq_work that will trigger a reschedule once IRQs
+ * get re-enabled again.
+ */
+noinstr static void rcu_irq_work_resched(void)
+{
+	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
+
+	if (IS_ENABLED(CONFIG_GENERIC_ENTRY) && !(current->flags & PF_VCPU))
+		return;
+
+	if (IS_ENABLED(CONFIG_KVM_XFER_TO_GUEST_WORK) && (current->flags & PF_VCPU))
+		return;
+
+	instrumentation_begin();
+	if (do_nocb_deferred_wakeup(rdp) && need_resched()) {
+		irq_work_queue(this_cpu_ptr(&late_wakeup_work));
+	}
+	instrumentation_end();
+}
+
+#else
+static inline void rcu_irq_work_resched(void) { }
+#endif
+
 /**
  * rcu_user_enter - inform RCU that we are resuming userspace.
  *
@@ -702,8 +734,6 @@ static DEFINE_PER_CPU(struct irq_work, late_wakeup_work) =
  */
 noinstr void rcu_user_enter(void)
 {
-	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
-
 	lockdep_assert_irqs_disabled();
 
 	/*
@@ -711,13 +741,7 @@ noinstr void rcu_user_enter(void)
 	 * rescheduling opportunity in the entry code. Trigger a self IPI
 	 * that will fire and reschedule once we resume in user/guest mode.
 	 */
-	instrumentation_begin();
-	if (!IS_ENABLED(CONFIG_GENERIC_ENTRY) || (current->flags & PF_VCPU)) {
-		if (do_nocb_deferred_wakeup(rdp) && need_resched())
-			irq_work_queue(this_cpu_ptr(&late_wakeup_work));
-	}
-	instrumentation_end();
-
+	rcu_irq_work_resched();
 	rcu_eqs_enter(true);
 }
 
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 384856e4d13e..cdc1b7651c03 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2197,6 +2197,7 @@ void rcu_nocb_flush_deferred_wakeup(void)
 {
 	do_nocb_deferred_wakeup(this_cpu_ptr(&rcu_data));
 }
+EXPORT_SYMBOL_GPL(rcu_nocb_flush_deferred_wakeup);
 
 void __init rcu_init_nohz(void)
 {
-- 
2.25.1

