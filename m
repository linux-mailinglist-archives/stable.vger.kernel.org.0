Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5D3316869
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 14:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhBJNyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 08:54:38 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:59988 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbhBJNyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 08:54:18 -0500
Date:   Wed, 10 Feb 2021 13:53:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612965212;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9cwRrvjT76sSrp2ibMmziPN8oPePakowNcut7jAjPqM=;
        b=TkTMBbm4GuxAIHC41Aj4ZRuBEoYhpZ54VT2zzDVFC/1lBV6Ssp1fNnrNPMW0UyW3fTsQDG
        dxY0XPV3QNMp6cT03mlBI3nNF6G1xhZrS/4gAbkswIkf5BBzZDXgXIaoXgKVgdHIGDTq4P
        SjmRBEahV/EOmHmzHsBqSG9+J2a9yDcal+2SdXzCLPrZIlT6l4OAX0+h28qWDvjHU/s2e/
        3HPpSwlQjozhoQ6FKxSDiIakeE4xzmry5OCG6I7ikj/SLvOaTKpqyax1KTV1XbpZcvWa7/
        y/b+UiCQYWTclXTBzlIiqWYWKP7n6NTbDCbrOpvYhfbB5XiJtpqgkgbc3UJxWQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612965212;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9cwRrvjT76sSrp2ibMmziPN8oPePakowNcut7jAjPqM=;
        b=L+QK7Okt4CNWQB0o9Gw3UMdEuUBnrUzasjJ1BzF+yMOlm8JIo7UrNXdP5qC+1kC7tPq6lm
        1dbigMuac/ssY7Ag==
From:   "tip-bot2 for Frederic Weisbecker" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/core] entry/kvm: Explicitly flush pending rcuog wakeup
 before last rescheduling point
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210131230548.32970-6-frederic@kernel.org>
References: <20210131230548.32970-6-frederic@kernel.org>
MIME-Version: 1.0
Message-ID: <161296521175.23325.4682669795184175011.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/core branch of tip:

Commit-ID:     14bbd41d5109a8049f3f1b77e994e0213f94f4c0
Gitweb:        https://git.kernel.org/tip/14bbd41d5109a8049f3f1b77e994e0213f94f4c0
Author:        Frederic Weisbecker <frederic@kernel.org>
AuthorDate:    Mon, 01 Feb 2021 00:05:48 +01:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Wed, 10 Feb 2021 14:44:51 +01:00

entry/kvm: Explicitly flush pending rcuog wakeup before last rescheduling point

Following the idle loop model, cleanly check for pending rcuog wakeup
before the last rescheduling point upon resuming to guest mode. This
way we can avoid to do it from rcu_user_enter() with the last resort
self-IPI hack that enforces rescheduling.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210131230548.32970-6-frederic@kernel.org
---
 arch/x86/kvm/x86.c        |  1 +-
 include/linux/entry-kvm.h | 14 ++++++++++++-
 kernel/rcu/tree.c         | 44 +++++++++++++++++++++++++++++---------
 kernel/rcu/tree_plugin.h  |  1 +-
 4 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1b404e4..b967c1c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1782,6 +1782,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
 bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
 {
+	xfer_to_guest_mode_prepare();
 	return vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu) ||
 		xfer_to_guest_mode_work_pending();
 }
diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
index 9b93f85..8b2b1d6 100644
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-kvm.h
@@ -47,6 +47,20 @@ static inline int arch_xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu,
 int xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu);
 
 /**
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
+/**
  * __xfer_to_guest_mode_work_pending - Check if work is pending
  *
  * Returns: True if work pending, False otherwise.
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 2ebc211..ce17b84 100644
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
index 384856e..cdc1b76 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2197,6 +2197,7 @@ void rcu_nocb_flush_deferred_wakeup(void)
 {
 	do_nocb_deferred_wakeup(this_cpu_ptr(&rcu_data));
 }
+EXPORT_SYMBOL_GPL(rcu_nocb_flush_deferred_wakeup);
 
 void __init rcu_init_nohz(void)
 {
