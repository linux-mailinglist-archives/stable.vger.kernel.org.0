Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C335BAAC8
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiIPKTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbiIPKSq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:18:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097F7AFAE0;
        Fri, 16 Sep 2022 03:12:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB5E6B8254A;
        Fri, 16 Sep 2022 10:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F4DC4347C;
        Fri, 16 Sep 2022 10:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323129;
        bh=31cipC14mZdElOYJ3XaK0RkFetdmF8bn+WnQfJyPShA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJgfZUpm0J6mNvyBTPHBDu7Abi9OEetaOYJlM+2pkSG/oXJe4n/ukaagANFBwJKlQ
         OjQ/ajUwrri9BVe8qbHNoRksrIMvx2h7DOKcKW7urTRYhgt1q3jg3tYeO921S1rXGC
         EspJddEvZoDUzJMTky9Y4tnyXyUn7CLnArDPcQkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Waiman Long <longman@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/35] lockdep: Fix -Wunused-parameter for _THIS_IP_
Date:   Fri, 16 Sep 2022 12:08:30 +0200
Message-Id: <20220916100447.248166318@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100446.916515275@linuxfoundation.org>
References: <20220916100446.916515275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit 8b023accc8df70e72f7704d29fead7ca914d6837 ]

While looking into a bug related to the compiler's handling of addresses
of labels, I noticed some uses of _THIS_IP_ seemed unused in lockdep.
Drive by cleanup.

-Wunused-parameter:
kernel/locking/lockdep.c:1383:22: warning: unused parameter 'ip'
kernel/locking/lockdep.c:4246:48: warning: unused parameter 'ip'
kernel/locking/lockdep.c:4844:19: warning: unused parameter 'ip'

Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/r/20220314221909.2027027-1-ndesaulniers@google.com
Stable-dep-of: 54c3931957f6 ("tracing: hold caller_addr to hardirq_{enable,disable}_ip")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/entry-common.c |  8 ++++----
 arch/x86/kvm/x86.h               |  2 +-
 include/linux/irqflags.h         |  4 ++--
 include/linux/kvm_host.h         |  2 +-
 kernel/entry/common.c            |  6 +++---
 kernel/locking/lockdep.c         | 22 ++++++++--------------
 kernel/sched/idle.c              |  2 +-
 kernel/trace/trace_preemptirq.c  |  4 ++--
 8 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index 32f9796c4ffe7..60225bc09b017 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -72,7 +72,7 @@ static __always_inline void __exit_to_kernel_mode(struct pt_regs *regs)
 	if (interrupts_enabled(regs)) {
 		if (regs->exit_rcu) {
 			trace_hardirqs_on_prepare();
-			lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+			lockdep_hardirqs_on_prepare();
 			rcu_irq_exit();
 			lockdep_hardirqs_on(CALLER_ADDR0);
 			return;
@@ -117,7 +117,7 @@ static __always_inline void enter_from_user_mode(struct pt_regs *regs)
 static __always_inline void __exit_to_user_mode(void)
 {
 	trace_hardirqs_on_prepare();
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	lockdep_hardirqs_on_prepare();
 	user_enter_irqoff();
 	lockdep_hardirqs_on(CALLER_ADDR0);
 }
@@ -175,7 +175,7 @@ static void noinstr arm64_exit_nmi(struct pt_regs *regs)
 	ftrace_nmi_exit();
 	if (restore) {
 		trace_hardirqs_on_prepare();
-		lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+		lockdep_hardirqs_on_prepare();
 	}
 
 	rcu_nmi_exit();
@@ -211,7 +211,7 @@ static void noinstr arm64_exit_el1_dbg(struct pt_regs *regs)
 
 	if (restore) {
 		trace_hardirqs_on_prepare();
-		lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+		lockdep_hardirqs_on_prepare();
 	}
 
 	rcu_nmi_exit();
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4d6f7a70bdd14..cd0c93ec72fad 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -26,7 +26,7 @@ static __always_inline void kvm_guest_enter_irqoff(void)
 	 */
 	instrumentation_begin();
 	trace_hardirqs_on_prepare();
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	lockdep_hardirqs_on_prepare();
 	instrumentation_end();
 
 	guest_enter_irqoff();
diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index 600c10da321a7..747f40e0c3260 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -20,13 +20,13 @@
 #ifdef CONFIG_PROVE_LOCKING
   extern void lockdep_softirqs_on(unsigned long ip);
   extern void lockdep_softirqs_off(unsigned long ip);
-  extern void lockdep_hardirqs_on_prepare(unsigned long ip);
+  extern void lockdep_hardirqs_on_prepare(void);
   extern void lockdep_hardirqs_on(unsigned long ip);
   extern void lockdep_hardirqs_off(unsigned long ip);
 #else
   static inline void lockdep_softirqs_on(unsigned long ip) { }
   static inline void lockdep_softirqs_off(unsigned long ip) { }
-  static inline void lockdep_hardirqs_on_prepare(unsigned long ip) { }
+  static inline void lockdep_hardirqs_on_prepare(void) { }
   static inline void lockdep_hardirqs_on(unsigned long ip) { }
   static inline void lockdep_hardirqs_off(unsigned long ip) { }
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fb70dd4ff3b60..38b7e9ab48b84 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -436,7 +436,7 @@ static __always_inline void guest_state_enter_irqoff(void)
 {
 	instrumentation_begin();
 	trace_hardirqs_on_prepare();
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	lockdep_hardirqs_on_prepare();
 	instrumentation_end();
 
 	guest_context_enter_irqoff();
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index d5a61d565ad5d..998bdb7b8bf7f 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -124,7 +124,7 @@ static __always_inline void __exit_to_user_mode(void)
 {
 	instrumentation_begin();
 	trace_hardirqs_on_prepare();
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	lockdep_hardirqs_on_prepare();
 	instrumentation_end();
 
 	user_enter_irqoff();
@@ -412,7 +412,7 @@ noinstr void irqentry_exit(struct pt_regs *regs, irqentry_state_t state)
 			instrumentation_begin();
 			/* Tell the tracer that IRET will enable interrupts */
 			trace_hardirqs_on_prepare();
-			lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+			lockdep_hardirqs_on_prepare();
 			instrumentation_end();
 			rcu_irq_exit();
 			lockdep_hardirqs_on(CALLER_ADDR0);
@@ -465,7 +465,7 @@ void noinstr irqentry_nmi_exit(struct pt_regs *regs, irqentry_state_t irq_state)
 	ftrace_nmi_exit();
 	if (irq_state.lockdep) {
 		trace_hardirqs_on_prepare();
-		lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+		lockdep_hardirqs_on_prepare();
 	}
 	instrumentation_end();
 
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 120bbdacd58bb..e6a282bc16652 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1368,7 +1368,7 @@ static struct lock_list *alloc_list_entry(void)
  */
 static int add_lock_to_list(struct lock_class *this,
 			    struct lock_class *links_to, struct list_head *head,
-			    unsigned long ip, u16 distance, u8 dep,
+			    u16 distance, u8 dep,
 			    const struct lock_trace *trace)
 {
 	struct lock_list *entry;
@@ -3121,19 +3121,15 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 * to the previous lock's dependency list:
 	 */
 	ret = add_lock_to_list(hlock_class(next), hlock_class(prev),
-			       &hlock_class(prev)->locks_after,
-			       next->acquire_ip, distance,
-			       calc_dep(prev, next),
-			       *trace);
+			       &hlock_class(prev)->locks_after, distance,
+			       calc_dep(prev, next), *trace);
 
 	if (!ret)
 		return 0;
 
 	ret = add_lock_to_list(hlock_class(prev), hlock_class(next),
-			       &hlock_class(next)->locks_before,
-			       next->acquire_ip, distance,
-			       calc_depb(prev, next),
-			       *trace);
+			       &hlock_class(next)->locks_before, distance,
+			       calc_depb(prev, next), *trace);
 	if (!ret)
 		return 0;
 
@@ -4224,14 +4220,13 @@ static void __trace_hardirqs_on_caller(void)
 
 /**
  * lockdep_hardirqs_on_prepare - Prepare for enabling interrupts
- * @ip:		Caller address
  *
  * Invoked before a possible transition to RCU idle from exit to user or
  * guest mode. This ensures that all RCU operations are done before RCU
  * stops watching. After the RCU transition lockdep_hardirqs_on() has to be
  * invoked to set the final state.
  */
-void lockdep_hardirqs_on_prepare(unsigned long ip)
+void lockdep_hardirqs_on_prepare(void)
 {
 	if (unlikely(!debug_locks))
 		return;
@@ -4828,8 +4823,7 @@ EXPORT_SYMBOL_GPL(__lockdep_no_validate__);
 
 static void
 print_lock_nested_lock_not_held(struct task_struct *curr,
-				struct held_lock *hlock,
-				unsigned long ip)
+				struct held_lock *hlock)
 {
 	if (!debug_locks_off())
 		return;
@@ -5005,7 +4999,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	chain_key = iterate_chain_key(chain_key, hlock_id(hlock));
 
 	if (nest_lock && !__lock_is_held(nest_lock, -1)) {
-		print_lock_nested_lock_not_held(curr, hlock, ip);
+		print_lock_nested_lock_not_held(curr, hlock);
 		return 0;
 	}
 
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index d17b0a5ce6ac3..499a3e286cd05 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -105,7 +105,7 @@ void __cpuidle default_idle_call(void)
 		 * last -- this is very similar to the entry code.
 		 */
 		trace_hardirqs_on_prepare();
-		lockdep_hardirqs_on_prepare(_THIS_IP_);
+		lockdep_hardirqs_on_prepare();
 		rcu_idle_enter();
 		lockdep_hardirqs_on(_THIS_IP_);
 
diff --git a/kernel/trace/trace_preemptirq.c b/kernel/trace/trace_preemptirq.c
index f4938040c2286..95b58bd757ce4 100644
--- a/kernel/trace/trace_preemptirq.c
+++ b/kernel/trace/trace_preemptirq.c
@@ -46,7 +46,7 @@ void trace_hardirqs_on(void)
 		this_cpu_write(tracing_irq_cpu, 0);
 	}
 
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	lockdep_hardirqs_on_prepare();
 	lockdep_hardirqs_on(CALLER_ADDR0);
 }
 EXPORT_SYMBOL(trace_hardirqs_on);
@@ -94,7 +94,7 @@ __visible void trace_hardirqs_on_caller(unsigned long caller_addr)
 		this_cpu_write(tracing_irq_cpu, 0);
 	}
 
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	lockdep_hardirqs_on_prepare();
 	lockdep_hardirqs_on(CALLER_ADDR0);
 }
 EXPORT_SYMBOL(trace_hardirqs_on_caller);
-- 
2.35.1



