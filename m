Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BF7395919
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 12:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbhEaKmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 06:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhEaKmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 06:42:33 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86421C061761;
        Mon, 31 May 2021 03:40:53 -0700 (PDT)
Date:   Mon, 31 May 2021 10:40:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622457652;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OEKn2YfDoG+r9IgBzmiagsSbWwYPhMvwogUpd3Z5PtA=;
        b=xXKYIbQ57KVcwIX97tg5jf/+LgFPvyrifDj/mN0yiTsLaClCAQLWQmKX0mLW7iNjy2cGVJ
        vDWJPwlHn0+oL6FGJCTW6cI7ZlnpADxOW/jYcIJIE05LfydUS0U48RctR/BwNPLE9dS3mW
        JcYkUV8FVy/fro+QDdyFQuiP/UR2xGb5BNrQW9fBt2yUfb5JgIDmNMRPmdZhX7TMBQ8nFW
        a2nMmG2HLyK3uEr2zPThv8sG5BusCdtKcRuu7ZlmYQL9cb9lyFSWeijIjnBBix59zPUqZu
        Z/ckxdMzgxNvRvAGdp4GBq7Op2pl+4zMDEC2OgDqNZopzGzxqzisf4sEEkaAQg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622457652;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OEKn2YfDoG+r9IgBzmiagsSbWwYPhMvwogUpd3Z5PtA=;
        b=P5HIs61mbnPk0iyu9OL2VXP8YsB8bzItZL4iYJ0HYUioExdU7eTGo7bwEOdQ/rTkZ08E/w
        Og5wLkKXgSyGsCCg==
From:   "tip-bot2 for Frederic Weisbecker" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/urgent] tick/nohz: Only check for RCU deferred wakeup on
 user/guest entry when needed
Cc:     kernel test robot <oliver.sang@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210527113441.465489-1-frederic@kernel.org>
References: <20210527113441.465489-1-frederic@kernel.org>
MIME-Version: 1.0
Message-ID: <162245765140.29796.11626289340020097817.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/urgent branch of tip:

Commit-ID:     f268c3737ecaefcfeecfb4cb5e44958a8976f067
Gitweb:        https://git.kernel.org/tip/f268c3737ecaefcfeecfb4cb5e44958a8976f067
Author:        Frederic Weisbecker <frederic@kernel.org>
AuthorDate:    Thu, 27 May 2021 13:34:41 +02:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Mon, 31 May 2021 10:14:49 +02:00

tick/nohz: Only check for RCU deferred wakeup on user/guest entry when needed

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
---
 include/linux/entry-kvm.h | 3 ++-
 include/linux/tick.h      | 7 +++++++
 kernel/entry/common.c     | 5 +++--
 kernel/time/tick-sched.c  | 1 +
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
index 8b2b1d6..136b8d9 100644
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
index 7340613..1a0ff88 100644
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
index a0b3b04..bf16395 100644
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
index 828b091..6784f27 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -230,6 +230,7 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 
 #ifdef CONFIG_NO_HZ_FULL
 cpumask_var_t tick_nohz_full_mask;
+EXPORT_SYMBOL_GPL(tick_nohz_full_mask);
 bool tick_nohz_full_running;
 EXPORT_SYMBOL_GPL(tick_nohz_full_running);
 static atomic_t tick_dep_mask;
