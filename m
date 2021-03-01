Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAB7328ECA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241394AbhCATiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:38:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:49914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234958AbhCATaG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:30:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30B4965262;
        Mon,  1 Mar 2021 17:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619774;
        bh=ipIGFaa63ZOOz2A8qn1nXeE4C3+/9waKTFS9Vm+dzPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjOIcs2JZv+4qIJGorLABFISnj4xAawrjc1e+ux9oF+IVGWm7jZyjFIy9NiKMxGWY
         jjZIE+L15HAxgxsN0bfr3myDMd2c5rsXMBoTOUbHbzKxmjRrEqKB/Nt5lq+2nRQrPq
         XwZOxwywmyBCrDbnfHMk/xKHyh3Aorp5EjZK0+MQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.10 576/663] entry/kvm: Explicitly flush pending rcuog wakeup before last rescheduling point
Date:   Mon,  1 Mar 2021 17:13:44 +0100
Message-Id: <20210301161210.352518905@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

commit 4ae7dc97f726ea95c58ac58af71cc034ad22d7de upstream.

Following the idle loop model, cleanly check for pending rcuog wakeup
before the last rescheduling point upon resuming to guest mode. This
way we can avoid to do it from rcu_user_enter() with the last resort
self-IPI hack that enforces rescheduling.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210131230548.32970-6-frederic@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c        |    1 +
 include/linux/entry-kvm.h |   14 ++++++++++++++
 kernel/rcu/tree.c         |   44 ++++++++++++++++++++++++++++++++++----------
 kernel/rcu/tree_plugin.h  |    1 +
 4 files changed, 50 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1776,6 +1776,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
 bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
 {
+	xfer_to_guest_mode_prepare();
 	return vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu) ||
 		xfer_to_guest_mode_work_pending();
 }
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-kvm.h
@@ -47,6 +47,20 @@ static inline int arch_xfer_to_guest_mod
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
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -670,9 +670,10 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
 
 #ifdef CONFIG_NO_HZ_FULL
 
+#if !defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_KVM_XFER_TO_GUEST_WORK)
 /*
  * An empty function that will trigger a reschedule on
- * IRQ tail once IRQs get re-enabled on userspace resume.
+ * IRQ tail once IRQs get re-enabled on userspace/guest resume.
  */
 static void late_wakeup_func(struct irq_work *work)
 {
@@ -681,6 +682,37 @@ static void late_wakeup_func(struct irq_
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
@@ -694,8 +726,6 @@ static DEFINE_PER_CPU(struct irq_work, l
  */
 noinstr void rcu_user_enter(void)
 {
-	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
-
 	lockdep_assert_irqs_disabled();
 
 	/*
@@ -703,13 +733,7 @@ noinstr void rcu_user_enter(void)
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
 
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2197,6 +2197,7 @@ void rcu_nocb_flush_deferred_wakeup(void
 {
 	do_nocb_deferred_wakeup(this_cpu_ptr(&rcu_data));
 }
+EXPORT_SYMBOL_GPL(rcu_nocb_flush_deferred_wakeup);
 
 void __init rcu_init_nohz(void)
 {


