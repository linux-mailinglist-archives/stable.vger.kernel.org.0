Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4043A6422
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbhFNLVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:21:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235580AbhFNLSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:18:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49E5E61983;
        Mon, 14 Jun 2021 10:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667862;
        bh=a1vVXO4BhMi8p1+hT0aPqI+yjmYpRbJhk+4TtGG5jSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D43kmP8aglpOpbibuxbHl9vvcXna4TlqV6RETK+vBs5Inq4R22jyAnJ8ygQdDZjCw
         0ObCagqT6EjdQz7aJskqQ+1qF3RjuKYspObKL/FmfbfOr1ATLxdWRQ9qOGeiZb1x/5
         AK/pcq6GVQSUaDvbacdVqYaCKx4u+cET4UF1KNXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.12 070/173] tick/nohz: Only check for RCU deferred wakeup on user/guest entry when needed
Date:   Mon, 14 Jun 2021 12:26:42 +0200
Message-Id: <20210614102700.487718022@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

commit f268c3737ecaefcfeecfb4cb5e44958a8976f067 upstream.

Checking for and processing RCU-nocb deferred wakeup upon user/guest
entry is only relevant when nohz_full runs on the local CPU, otherwise
the periodic tick should take care of it.

Make sure we don't needlessly pollute these fast-paths as a -3%
performance regression on a will-it-scale.per_process_ops has been
reported so far.

Fixes: 47b8ff194c1f (entry: Explicitly flush pending rcuog wakeup before last rescheduling point)
Fixes: 4ae7dc97f726 (entry/kvm: Explicitly flush pending rcuog wakeup before last rescheduling point)
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210527113441.465489-1-frederic@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/entry-kvm.h | 3 ++-
 include/linux/tick.h      | 7 +++++++
 kernel/entry/common.c     | 5 +++--
 kernel/time/tick-sched.c  | 1 +
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
index 8b2b1d68b954..136b8d97d8c0 100644
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-kvm.h
@@ -3,6 +3,7 @@
 #define __LINUX_ENTRYKVM_H
 
 #include <linux/entry-common.h>
+#include <linux/tick.h>
 
 /* Transfer to guest mode work */
 #ifdef CONFIG_KVM_XFER_TO_GUEST_WORK
@@ -57,7 +58,7 @@ int xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu);
 static inline void xfer_to_guest_mode_prepare(void)
 {
 	lockdep_assert_irqs_disabled();
-	rcu_nocb_flush_deferred_wakeup();
+	tick_nohz_user_enter_prepare();
 }
 
 /**
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 7340613c7eff..1a0ff88fa107 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -11,6 +11,7 @@
 #include <linux/context_tracking_state.h>
 #include <linux/cpumask.h>
 #include <linux/sched.h>
+#include <linux/rcupdate.h>
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void __init tick_init(void);
@@ -300,4 +301,10 @@ static inline void tick_nohz_task_switch(void)
 		__tick_nohz_task_switch();
 }
 
+static inline void tick_nohz_user_enter_prepare(void)
+{
+	if (tick_nohz_full_cpu(smp_processor_id()))
+		rcu_nocb_flush_deferred_wakeup();
+}
+
 #endif
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index a0b3b04fb596..bf16395b9e13 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -5,6 +5,7 @@
 #include <linux/highmem.h>
 #include <linux/livepatch.h>
 #include <linux/audit.h>
+#include <linux/tick.h>
 
 #include "common.h"
 
@@ -186,7 +187,7 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 		local_irq_disable_exit_to_user();
 
 		/* Check if any of the above work has queued a deferred wakeup */
-		rcu_nocb_flush_deferred_wakeup();
+		tick_nohz_user_enter_prepare();
 
 		ti_work = READ_ONCE(current_thread_info()->flags);
 	}
@@ -202,7 +203,7 @@ static void exit_to_user_mode_prepare(struct pt_regs *regs)
 	lockdep_assert_irqs_disabled();
 
 	/* Flush pending rcuog wakeup before the last need_resched() check */
-	rcu_nocb_flush_deferred_wakeup();
+	tick_nohz_user_enter_prepare();
 
 	if (unlikely(ti_work & EXIT_TO_USER_MODE_WORK))
 		ti_work = exit_to_user_mode_loop(regs, ti_work);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 828b091501ca..6784f27a3099 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -230,6 +230,7 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 
 #ifdef CONFIG_NO_HZ_FULL
 cpumask_var_t tick_nohz_full_mask;
+EXPORT_SYMBOL_GPL(tick_nohz_full_mask);
 bool tick_nohz_full_running;
 EXPORT_SYMBOL_GPL(tick_nohz_full_running);
 static atomic_t tick_dep_mask;
-- 
2.32.0



