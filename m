Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91EC29B699
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796878AbgJ0PWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:22:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797302AbgJ0PWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:22:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2916C2076D;
        Tue, 27 Oct 2020 15:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812166;
        bh=fKvzga+9w0+RzEiih/miXAu8KUpWpFxvN+mox+OFqmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GvZwLhyEqwOuVrrZtPbJP0VzYUThfiFiXJsi3X4UJTDQFL2iSsMajdCUEcemRr+NO
         3zTINzZWHL6idUGaRnN8lPQUYrQb8TDToJ6yIeMyZDrTESnhaPc1Zky3JQq34kq4RV
         9H0ZEkRj66Z2tc/DDZFSTySxgxqg5W6bpMbWkHEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 116/757] lockdep: Revert "lockdep: Use raw_cpu_*() for per-cpu variables"
Date:   Tue, 27 Oct 2020 14:46:06 +0100
Message-Id: <20201027135456.010560721@linuxfoundation.org>
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

[ Upstream commit baffd723e44dc3d7f84f0b8f1fe1ece00ddd2710 ]

The thinking in commit:

  fddf9055a60d ("lockdep: Use raw_cpu_*() for per-cpu variables")

is flawed. While it is true that when we're migratable both CPUs will
have a 0 value, it doesn't hold that when we do get migrated in the
middle of a raw_cpu_op(), the old CPU will still have 0 by the time we
get around to reading it on the new CPU.

Luckily, the reason for that commit (s390 using preempt_disable()
instead of preempt_disable_notrace() in their percpu code), has since
been fixed by commit:

  1196f12a2c96 ("s390: don't trace preemption in percpu macros")

An audit of arch/*/include/asm/percpu*.h shows there are no other
architectures affected by this particular issue.

Fixes: fddf9055a60d ("lockdep: Use raw_cpu_*() for per-cpu variables")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/20201005095958.GJ2651@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/lockdep.h | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index b1227be47496c..1130f271de669 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -512,19 +512,19 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 #define lock_map_release(l)			lock_release(l, _THIS_IP_)
 
 #ifdef CONFIG_PROVE_LOCKING
-# define might_lock(lock) 						\
+# define might_lock(lock)						\
 do {									\
 	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
 	lock_acquire(&(lock)->dep_map, 0, 0, 0, 1, NULL, _THIS_IP_);	\
 	lock_release(&(lock)->dep_map, _THIS_IP_);			\
 } while (0)
-# define might_lock_read(lock) 						\
+# define might_lock_read(lock)						\
 do {									\
 	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
 	lock_acquire(&(lock)->dep_map, 0, 0, 1, 1, NULL, _THIS_IP_);	\
 	lock_release(&(lock)->dep_map, _THIS_IP_);			\
 } while (0)
-# define might_lock_nested(lock, subclass) 				\
+# define might_lock_nested(lock, subclass)				\
 do {									\
 	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
 	lock_acquire(&(lock)->dep_map, subclass, 0, 1, 1, NULL,		\
@@ -536,29 +536,21 @@ DECLARE_PER_CPU(int, hardirqs_enabled);
 DECLARE_PER_CPU(int, hardirq_context);
 DECLARE_PER_CPU(unsigned int, lockdep_recursion);
 
-/*
- * The below lockdep_assert_*() macros use raw_cpu_read() to access the above
- * per-cpu variables. This is required because this_cpu_read() will potentially
- * call into preempt/irq-disable and that obviously isn't right. This is also
- * correct because when IRQs are enabled, it doesn't matter if we accidentally
- * read the value from our previous CPU.
- */
-
-#define __lockdep_enabled	(debug_locks && !raw_cpu_read(lockdep_recursion))
+#define __lockdep_enabled	(debug_locks && !this_cpu_read(lockdep_recursion))
 
 #define lockdep_assert_irqs_enabled()					\
 do {									\
-	WARN_ON_ONCE(__lockdep_enabled && !raw_cpu_read(hardirqs_enabled)); \
+	WARN_ON_ONCE(__lockdep_enabled && !this_cpu_read(hardirqs_enabled)); \
 } while (0)
 
 #define lockdep_assert_irqs_disabled()					\
 do {									\
-	WARN_ON_ONCE(__lockdep_enabled && raw_cpu_read(hardirqs_enabled)); \
+	WARN_ON_ONCE(__lockdep_enabled && this_cpu_read(hardirqs_enabled)); \
 } while (0)
 
 #define lockdep_assert_in_irq()						\
 do {									\
-	WARN_ON_ONCE(__lockdep_enabled && !raw_cpu_read(hardirq_context)); \
+	WARN_ON_ONCE(__lockdep_enabled && !this_cpu_read(hardirq_context)); \
 } while (0)
 
 #define lockdep_assert_preemption_enabled()				\
@@ -566,7 +558,7 @@ do {									\
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_COUNT)	&&		\
 		     __lockdep_enabled			&&		\
 		     (preempt_count() != 0		||		\
-		      !raw_cpu_read(hardirqs_enabled)));		\
+		      !this_cpu_read(hardirqs_enabled)));		\
 } while (0)
 
 #define lockdep_assert_preemption_disabled()				\
@@ -574,7 +566,7 @@ do {									\
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_COUNT)	&&		\
 		     __lockdep_enabled			&&		\
 		     (preempt_count() == 0		&&		\
-		      raw_cpu_read(hardirqs_enabled)));			\
+		      this_cpu_read(hardirqs_enabled)));		\
 } while (0)
 
 #else
-- 
2.25.1



