Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4039729B7F5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760155AbgJ0P3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:29:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797570AbgJ0PYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:24:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1868A20657;
        Tue, 27 Oct 2020 15:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812259;
        bh=MWD72lq/RX0FTsOyrs7GrNbXm2Q1C2AnImudrBnMYto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LBGF2KoKseP22z1T+LaL3B8LHjBLUiWV3hBm8lxGxYipAtdvh08T2CEy0YEGzrK4L
         KJa/PIWbWlVs+fWDvBjrJiMW3OF0BZos68CWDVgFdUUhVrOppM1kBvSpDBU25NdTB/
         OtJtU+QalZ4UV1FvD+kSha1FrsMHig+u9tweiZi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 115/757] lockdep: Fix lockdep recursion
Date:   Tue, 27 Oct 2020 14:46:05 +0100
Message-Id: <20201027135455.965692377@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 4d004099a668c41522242aa146a38cc4eb59cb1e ]

Steve reported that lockdep_assert*irq*(), when nested inside lockdep
itself, will trigger a false-positive.

One example is the stack-trace code, as called from inside lockdep,
triggering tracing, which in turn calls RCU, which then uses
lockdep_assert_irqs_disabled().

Fixes: a21ee6055c30 ("lockdep: Change hardirq{s_enabled,_context} to per-cpu variables")
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/lockdep.h  | 13 ++++--
 kernel/locking/lockdep.c | 99 ++++++++++++++++++++++++----------------
 2 files changed, 67 insertions(+), 45 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 6a584b3e5c74f..b1227be47496c 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -534,6 +534,7 @@ do {									\
 
 DECLARE_PER_CPU(int, hardirqs_enabled);
 DECLARE_PER_CPU(int, hardirq_context);
+DECLARE_PER_CPU(unsigned int, lockdep_recursion);
 
 /*
  * The below lockdep_assert_*() macros use raw_cpu_read() to access the above
@@ -543,25 +544,27 @@ DECLARE_PER_CPU(int, hardirq_context);
  * read the value from our previous CPU.
  */
 
+#define __lockdep_enabled	(debug_locks && !raw_cpu_read(lockdep_recursion))
+
 #define lockdep_assert_irqs_enabled()					\
 do {									\
-	WARN_ON_ONCE(debug_locks && !raw_cpu_read(hardirqs_enabled));	\
+	WARN_ON_ONCE(__lockdep_enabled && !raw_cpu_read(hardirqs_enabled)); \
 } while (0)
 
 #define lockdep_assert_irqs_disabled()					\
 do {									\
-	WARN_ON_ONCE(debug_locks && raw_cpu_read(hardirqs_enabled));	\
+	WARN_ON_ONCE(__lockdep_enabled && raw_cpu_read(hardirqs_enabled)); \
 } while (0)
 
 #define lockdep_assert_in_irq()						\
 do {									\
-	WARN_ON_ONCE(debug_locks && !raw_cpu_read(hardirq_context));	\
+	WARN_ON_ONCE(__lockdep_enabled && !raw_cpu_read(hardirq_context)); \
 } while (0)
 
 #define lockdep_assert_preemption_enabled()				\
 do {									\
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_COUNT)	&&		\
-		     debug_locks			&&		\
+		     __lockdep_enabled			&&		\
 		     (preempt_count() != 0		||		\
 		      !raw_cpu_read(hardirqs_enabled)));		\
 } while (0)
@@ -569,7 +572,7 @@ do {									\
 #define lockdep_assert_preemption_disabled()				\
 do {									\
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_COUNT)	&&		\
-		     debug_locks			&&		\
+		     __lockdep_enabled			&&		\
 		     (preempt_count() == 0		&&		\
 		      raw_cpu_read(hardirqs_enabled)));			\
 } while (0)
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index a430fbb01eb16..85d15f0362dc5 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -76,6 +76,23 @@ module_param(lock_stat, int, 0644);
 #define lock_stat 0
 #endif
 
+DEFINE_PER_CPU(unsigned int, lockdep_recursion);
+EXPORT_PER_CPU_SYMBOL_GPL(lockdep_recursion);
+
+static inline bool lockdep_enabled(void)
+{
+	if (!debug_locks)
+		return false;
+
+	if (raw_cpu_read(lockdep_recursion))
+		return false;
+
+	if (current->lockdep_recursion)
+		return false;
+
+	return true;
+}
+
 /*
  * lockdep_lock: protects the lockdep graph, the hashes and the
  *               class/list/hash allocators.
@@ -93,7 +110,7 @@ static inline void lockdep_lock(void)
 
 	arch_spin_lock(&__lock);
 	__owner = current;
-	current->lockdep_recursion++;
+	__this_cpu_inc(lockdep_recursion);
 }
 
 static inline void lockdep_unlock(void)
@@ -101,7 +118,7 @@ static inline void lockdep_unlock(void)
 	if (debug_locks && DEBUG_LOCKS_WARN_ON(__owner != current))
 		return;
 
-	current->lockdep_recursion--;
+	__this_cpu_dec(lockdep_recursion);
 	__owner = NULL;
 	arch_spin_unlock(&__lock);
 }
@@ -393,10 +410,15 @@ void lockdep_init_task(struct task_struct *task)
 	task->lockdep_recursion = 0;
 }
 
+static __always_inline void lockdep_recursion_inc(void)
+{
+	__this_cpu_inc(lockdep_recursion);
+}
+
 static __always_inline void lockdep_recursion_finish(void)
 {
-	if (WARN_ON_ONCE((--current->lockdep_recursion) & LOCKDEP_RECURSION_MASK))
-		current->lockdep_recursion = 0;
+	if (WARN_ON_ONCE(__this_cpu_dec_return(lockdep_recursion)))
+		__this_cpu_write(lockdep_recursion, 0);
 }
 
 void lockdep_set_selftest_task(struct task_struct *task)
@@ -3659,7 +3681,7 @@ void lockdep_hardirqs_on_prepare(unsigned long ip)
 	if (unlikely(in_nmi()))
 		return;
 
-	if (unlikely(current->lockdep_recursion & LOCKDEP_RECURSION_MASK))
+	if (unlikely(__this_cpu_read(lockdep_recursion)))
 		return;
 
 	if (unlikely(lockdep_hardirqs_enabled())) {
@@ -3695,7 +3717,7 @@ void lockdep_hardirqs_on_prepare(unsigned long ip)
 
 	current->hardirq_chain_key = current->curr_chain_key;
 
-	current->lockdep_recursion++;
+	lockdep_recursion_inc();
 	__trace_hardirqs_on_caller();
 	lockdep_recursion_finish();
 }
@@ -3728,7 +3750,7 @@ void noinstr lockdep_hardirqs_on(unsigned long ip)
 		goto skip_checks;
 	}
 
-	if (unlikely(current->lockdep_recursion & LOCKDEP_RECURSION_MASK))
+	if (unlikely(__this_cpu_read(lockdep_recursion)))
 		return;
 
 	if (lockdep_hardirqs_enabled()) {
@@ -3781,7 +3803,7 @@ void noinstr lockdep_hardirqs_off(unsigned long ip)
 	if (in_nmi()) {
 		if (!IS_ENABLED(CONFIG_TRACE_IRQFLAGS_NMI))
 			return;
-	} else if (current->lockdep_recursion & LOCKDEP_RECURSION_MASK)
+	} else if (__this_cpu_read(lockdep_recursion))
 		return;
 
 	/*
@@ -3814,7 +3836,7 @@ void lockdep_softirqs_on(unsigned long ip)
 {
 	struct irqtrace_events *trace = &current->irqtrace;
 
-	if (unlikely(!debug_locks || current->lockdep_recursion))
+	if (unlikely(!lockdep_enabled()))
 		return;
 
 	/*
@@ -3829,7 +3851,7 @@ void lockdep_softirqs_on(unsigned long ip)
 		return;
 	}
 
-	current->lockdep_recursion++;
+	lockdep_recursion_inc();
 	/*
 	 * We'll do an OFF -> ON transition:
 	 */
@@ -3852,7 +3874,7 @@ void lockdep_softirqs_on(unsigned long ip)
  */
 void lockdep_softirqs_off(unsigned long ip)
 {
-	if (unlikely(!debug_locks || current->lockdep_recursion))
+	if (unlikely(!lockdep_enabled()))
 		return;
 
 	/*
@@ -4233,11 +4255,11 @@ void lockdep_init_map_waits(struct lockdep_map *lock, const char *name,
 	if (subclass) {
 		unsigned long flags;
 
-		if (DEBUG_LOCKS_WARN_ON(current->lockdep_recursion))
+		if (DEBUG_LOCKS_WARN_ON(!lockdep_enabled()))
 			return;
 
 		raw_local_irq_save(flags);
-		current->lockdep_recursion++;
+		lockdep_recursion_inc();
 		register_lock_class(lock, subclass, 1);
 		lockdep_recursion_finish();
 		raw_local_irq_restore(flags);
@@ -4920,11 +4942,11 @@ void lock_set_class(struct lockdep_map *lock, const char *name,
 {
 	unsigned long flags;
 
-	if (unlikely(current->lockdep_recursion))
+	if (unlikely(!lockdep_enabled()))
 		return;
 
 	raw_local_irq_save(flags);
-	current->lockdep_recursion++;
+	lockdep_recursion_inc();
 	check_flags(flags);
 	if (__lock_set_class(lock, name, key, subclass, ip))
 		check_chain_key(current);
@@ -4937,11 +4959,11 @@ void lock_downgrade(struct lockdep_map *lock, unsigned long ip)
 {
 	unsigned long flags;
 
-	if (unlikely(current->lockdep_recursion))
+	if (unlikely(!lockdep_enabled()))
 		return;
 
 	raw_local_irq_save(flags);
-	current->lockdep_recursion++;
+	lockdep_recursion_inc();
 	check_flags(flags);
 	if (__lock_downgrade(lock, ip))
 		check_chain_key(current);
@@ -4979,7 +5001,7 @@ static void verify_lock_unused(struct lockdep_map *lock, struct held_lock *hlock
 
 static bool lockdep_nmi(void)
 {
-	if (current->lockdep_recursion & LOCKDEP_RECURSION_MASK)
+	if (raw_cpu_read(lockdep_recursion))
 		return false;
 
 	if (!in_nmi())
@@ -5000,7 +5022,10 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 
 	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
 
-	if (unlikely(current->lockdep_recursion)) {
+	if (!debug_locks)
+		return;
+
+	if (unlikely(!lockdep_enabled())) {
 		/* XXX allow trylock from NMI ?!? */
 		if (lockdep_nmi() && !trylock) {
 			struct held_lock hlock;
@@ -5023,7 +5048,7 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	raw_local_irq_save(flags);
 	check_flags(flags);
 
-	current->lockdep_recursion++;
+	lockdep_recursion_inc();
 	__lock_acquire(lock, subclass, trylock, read, check,
 		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0);
 	lockdep_recursion_finish();
@@ -5037,13 +5062,13 @@ void lock_release(struct lockdep_map *lock, unsigned long ip)
 
 	trace_lock_release(lock, ip);
 
-	if (unlikely(current->lockdep_recursion))
+	if (unlikely(!lockdep_enabled()))
 		return;
 
 	raw_local_irq_save(flags);
 	check_flags(flags);
 
-	current->lockdep_recursion++;
+	lockdep_recursion_inc();
 	if (__lock_release(lock, ip))
 		check_chain_key(current);
 	lockdep_recursion_finish();
@@ -5056,13 +5081,13 @@ noinstr int lock_is_held_type(const struct lockdep_map *lock, int read)
 	unsigned long flags;
 	int ret = 0;
 
-	if (unlikely(current->lockdep_recursion))
+	if (unlikely(!lockdep_enabled()))
 		return 1; /* avoid false negative lockdep_assert_held() */
 
 	raw_local_irq_save(flags);
 	check_flags(flags);
 
-	current->lockdep_recursion++;
+	lockdep_recursion_inc();
 	ret = __lock_is_held(lock, read);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
@@ -5077,13 +5102,13 @@ struct pin_cookie lock_pin_lock(struct lockdep_map *lock)
 	struct pin_cookie cookie = NIL_COOKIE;
 	unsigned long flags;
 
-	if (unlikely(current->lockdep_recursion))
+	if (unlikely(!lockdep_enabled()))
 		return cookie;
 
 	raw_local_irq_save(flags);
 	check_flags(flags);
 
-	current->lockdep_recursion++;
+	lockdep_recursion_inc();
 	cookie = __lock_pin_lock(lock);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
@@ -5096,13 +5121,13 @@ void lock_repin_lock(struct lockdep_map *lock, struct pin_cookie cookie)
 {
 	unsigned long flags;
 
-	if (unlikely(current->lockdep_recursion))
+	if (unlikely(!lockdep_enabled()))
 		return;
 
 	raw_local_irq_save(flags);
 	check_flags(flags);
 
-	current->lockdep_recursion++;
+	lockdep_recursion_inc();
 	__lock_repin_lock(lock, cookie);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
@@ -5113,13 +5138,13 @@ void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie cookie)
 {
 	unsigned long flags;
 
-	if (unlikely(current->lockdep_recursion))
+	if (unlikely(!lockdep_enabled()))
 		return;
 
 	raw_local_irq_save(flags);
 	check_flags(flags);
 
-	current->lockdep_recursion++;
+	lockdep_recursion_inc();
 	__lock_unpin_lock(lock, cookie);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
@@ -5249,15 +5274,12 @@ void lock_contended(struct lockdep_map *lock, unsigned long ip)
 
 	trace_lock_acquired(lock, ip);
 
-	if (unlikely(!lock_stat || !debug_locks))
-		return;
-
-	if (unlikely(current->lockdep_recursion))
+	if (unlikely(!lock_stat || !lockdep_enabled()))
 		return;
 
 	raw_local_irq_save(flags);
 	check_flags(flags);
-	current->lockdep_recursion++;
+	lockdep_recursion_inc();
 	__lock_contended(lock, ip);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
@@ -5270,15 +5292,12 @@ void lock_acquired(struct lockdep_map *lock, unsigned long ip)
 
 	trace_lock_contended(lock, ip);
 
-	if (unlikely(!lock_stat || !debug_locks))
-		return;
-
-	if (unlikely(current->lockdep_recursion))
+	if (unlikely(!lock_stat || !lockdep_enabled()))
 		return;
 
 	raw_local_irq_save(flags);
 	check_flags(flags);
-	current->lockdep_recursion++;
+	lockdep_recursion_inc();
 	__lock_acquired(lock, ip);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
-- 
2.25.1



