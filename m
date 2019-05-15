Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23CC31ED93
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbfEOLLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729523AbfEOLLG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D81A02168B;
        Wed, 15 May 2019 11:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918665;
        bh=CZXEDNXR1uK4tcN4Z5rMxiRIxYRz+FGYQdZeaJXEPY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKR/4VSpg3yer0c8BsNeve1EQLkV0NJ8xvcaO7VePq7sUR/hfkEGIbcZrSdwOuOYR
         KN30gT+DtSqJdAyvDq7cAFeQAYQ89EYJXejPqNtXgsgMu/yNp1i0VOLWmGmIdR1c4h
         00Zdpn2+ldV1xyOHQmnf0rxvQX4vHQCinYRYJAfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jon Masters <jcm@redhat.com>,
        Waiman Long <longman9394@gmail.com>,
        Dave Stewart <david.c.stewart@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 219/266] x86/speculation: Prepare for conditional IBPB in switch_mm()
Date:   Wed, 15 May 2019 12:55:26 +0200
Message-Id: <20190515090730.400738894@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 4c71a2b6fd7e42814aa68a6dec88abf3b42ea573 upstream.

The IBPB speculation barrier is issued from switch_mm() when the kernel
switches to a user space task with a different mm than the user space task
which ran last on the same CPU.

An additional optimization is to avoid IBPB when the incoming task can be
ptraced by the outgoing task. This optimization only works when switching
directly between two user space tasks. When switching from a kernel task to
a user space task the optimization fails because the previous task cannot
be accessed anymore. So for quite some scenarios the optimization is just
adding overhead.

The upcoming conditional IBPB support will issue IBPB only for user space
tasks which have the TIF_SPEC_IB bit set. This requires to handle the
following cases:

  1) Switch from a user space task (potential attacker) which has
     TIF_SPEC_IB set to a user space task (potential victim) which has
     TIF_SPEC_IB not set.

  2) Switch from a user space task (potential attacker) which has
     TIF_SPEC_IB not set to a user space task (potential victim) which has
     TIF_SPEC_IB set.

This needs to be optimized for the case where the IBPB can be avoided when
only kernel threads ran in between user space tasks which belong to the
same process.

The current check whether two tasks belong to the same context is using the
tasks context id. While correct, it's simpler to use the mm pointer because
it allows to mangle the TIF_SPEC_IB bit into it. The context id based
mechanism requires extra storage, which creates worse code.

When a task is scheduled out its TIF_SPEC_IB bit is mangled as bit 0 into
the per CPU storage which is used to track the last user space mm which was
running on a CPU. This bit can be used together with the TIF_SPEC_IB bit of
the incoming task to make the decision whether IBPB needs to be issued or
not to cover the two cases above.

As conditional IBPB is going to be the default, remove the dubious ptrace
check for the IBPB always case and simply issue IBPB always when the
process changes.

Move the storage to a different place in the struct as the original one
created a hole.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Casey Schaufler <casey.schaufler@intel.com>
Cc: Asit Mallick <asit.k.mallick@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jon Masters <jcm@redhat.com>
Cc: Waiman Long <longman9394@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Dave Stewart <david.c.stewart@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Link: https://lkml.kernel.org/r/20181125185005.466447057@linutronix.de
[bwh: Backported to 4.4:
 - Drop changes in initialize_tlbstate_and_flush()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    2 
 arch/x86/include/asm/tlbflush.h      |    8 +-
 arch/x86/kernel/cpu/bugs.c           |   29 +++++++-
 arch/x86/mm/tlb.c                    |  113 ++++++++++++++++++++++++++---------
 4 files changed, 117 insertions(+), 35 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -257,6 +257,8 @@ do {									\
 } while (0)
 
 DECLARE_STATIC_KEY_FALSE(switch_to_cond_stibp);
+DECLARE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
+DECLARE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
 #endif /* __ASSEMBLY__ */
 
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -68,8 +68,12 @@ static inline void invpcid_flush_all_non
 struct tlb_state {
 	struct mm_struct *active_mm;
 	int state;
-	/* last user mm's ctx id */
-	u64 last_ctx_id;
+
+	/* Last user mm for optimizing IBPB */
+	union {
+		struct mm_struct	*last_user_mm;
+		unsigned long		last_user_mm_ibpb;
+	};
 
 	/*
 	 * Access to this CR4 shadow and to H/W CR4 is protected by
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -53,6 +53,10 @@ u64 x86_amd_ls_cfg_ssbd_mask;
 
 /* Control conditional STIPB in switch_to() */
 DEFINE_STATIC_KEY_FALSE(switch_to_cond_stibp);
+/* Control conditional IBPB in switch_mm() */
+DEFINE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
+/* Control unconditional IBPB in switch_mm() */
+DEFINE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
 void __init check_bugs(void)
 {
@@ -319,7 +323,17 @@ spectre_v2_user_select_mitigation(enum s
 	/* Initialize Indirect Branch Prediction Barrier */
 	if (boot_cpu_has(X86_FEATURE_IBPB)) {
 		setup_force_cpu_cap(X86_FEATURE_USE_IBPB);
-		pr_info("Spectre v2 mitigation: Enabling Indirect Branch Prediction Barrier\n");
+
+		switch (mode) {
+		case SPECTRE_V2_USER_STRICT:
+			static_branch_enable(&switch_mm_always_ibpb);
+			break;
+		default:
+			break;
+		}
+
+		pr_info("mitigation: Enabling %s Indirect Branch Prediction Barrier\n",
+			mode == SPECTRE_V2_USER_STRICT ? "always-on" : "conditional");
 	}
 
 	/* If enhanced IBRS is enabled no STIPB required */
@@ -867,10 +881,15 @@ static char *stibp_state(void)
 
 static char *ibpb_state(void)
 {
-	if (boot_cpu_has(X86_FEATURE_USE_IBPB))
-		return ", IBPB";
-	else
-		return "";
+	if (boot_cpu_has(X86_FEATURE_IBPB)) {
+		switch (spectre_v2_user) {
+		case SPECTRE_V2_USER_NONE:
+			return ", IBPB: disabled";
+		case SPECTRE_V2_USER_STRICT:
+			return ", IBPB: always-on";
+		}
+	}
+	return "";
 }
 
 static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr,
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -7,7 +7,6 @@
 #include <linux/module.h>
 #include <linux/cpu.h>
 #include <linux/debugfs.h>
-#include <linux/ptrace.h>
 
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
@@ -31,6 +30,12 @@
  *	Implement flush IPI by CALL_FUNCTION_VECTOR, Alex Shi
  */
 
+/*
+ * Use bit 0 to mangle the TIF_SPEC_IB state into the mm pointer which is
+ * stored in cpu_tlb_state.last_user_mm_ibpb.
+ */
+#define LAST_USER_MM_IBPB	0x1UL
+
 atomic64_t last_mm_ctx_id = ATOMIC64_INIT(1);
 
 struct flush_tlb_info {
@@ -102,17 +107,87 @@ void switch_mm(struct mm_struct *prev, s
 	local_irq_restore(flags);
 }
 
-static bool ibpb_needed(struct task_struct *tsk, u64 last_ctx_id)
+static inline unsigned long mm_mangle_tif_spec_ib(struct task_struct *next)
 {
+	unsigned long next_tif = task_thread_info(next)->flags;
+	unsigned long ibpb = (next_tif >> TIF_SPEC_IB) & LAST_USER_MM_IBPB;
+
+	return (unsigned long)next->mm | ibpb;
+}
+
+static void cond_ibpb(struct task_struct *next)
+{
+	if (!next || !next->mm)
+		return;
+
 	/*
-	 * Check if the current (previous) task has access to the memory
-	 * of the @tsk (next) task. If access is denied, make sure to
-	 * issue a IBPB to stop user->user Spectre-v2 attacks.
-	 *
-	 * Note: __ptrace_may_access() returns 0 or -ERRNO.
+	 * Both, the conditional and the always IBPB mode use the mm
+	 * pointer to avoid the IBPB when switching between tasks of the
+	 * same process. Using the mm pointer instead of mm->context.ctx_id
+	 * opens a hypothetical hole vs. mm_struct reuse, which is more or
+	 * less impossible to control by an attacker. Aside of that it
+	 * would only affect the first schedule so the theoretically
+	 * exposed data is not really interesting.
 	 */
-	return (tsk && tsk->mm && tsk->mm->context.ctx_id != last_ctx_id &&
-		ptrace_may_access_sched(tsk, PTRACE_MODE_SPEC_IBPB));
+	if (static_branch_likely(&switch_mm_cond_ibpb)) {
+		unsigned long prev_mm, next_mm;
+
+		/*
+		 * This is a bit more complex than the always mode because
+		 * it has to handle two cases:
+		 *
+		 * 1) Switch from a user space task (potential attacker)
+		 *    which has TIF_SPEC_IB set to a user space task
+		 *    (potential victim) which has TIF_SPEC_IB not set.
+		 *
+		 * 2) Switch from a user space task (potential attacker)
+		 *    which has TIF_SPEC_IB not set to a user space task
+		 *    (potential victim) which has TIF_SPEC_IB set.
+		 *
+		 * This could be done by unconditionally issuing IBPB when
+		 * a task which has TIF_SPEC_IB set is either scheduled in
+		 * or out. Though that results in two flushes when:
+		 *
+		 * - the same user space task is scheduled out and later
+		 *   scheduled in again and only a kernel thread ran in
+		 *   between.
+		 *
+		 * - a user space task belonging to the same process is
+		 *   scheduled in after a kernel thread ran in between
+		 *
+		 * - a user space task belonging to the same process is
+		 *   scheduled in immediately.
+		 *
+		 * Optimize this with reasonably small overhead for the
+		 * above cases. Mangle the TIF_SPEC_IB bit into the mm
+		 * pointer of the incoming task which is stored in
+		 * cpu_tlbstate.last_user_mm_ibpb for comparison.
+		 */
+		next_mm = mm_mangle_tif_spec_ib(next);
+		prev_mm = this_cpu_read(cpu_tlbstate.last_user_mm_ibpb);
+
+		/*
+		 * Issue IBPB only if the mm's are different and one or
+		 * both have the IBPB bit set.
+		 */
+		if (next_mm != prev_mm &&
+		    (next_mm | prev_mm) & LAST_USER_MM_IBPB)
+			indirect_branch_prediction_barrier();
+
+		this_cpu_write(cpu_tlbstate.last_user_mm_ibpb, next_mm);
+	}
+
+	if (static_branch_unlikely(&switch_mm_always_ibpb)) {
+		/*
+		 * Only flush when switching to a user space task with a
+		 * different context than the user space task which ran
+		 * last on this CPU.
+		 */
+		if (this_cpu_read(cpu_tlbstate.last_user_mm) != next->mm) {
+			indirect_branch_prediction_barrier();
+			this_cpu_write(cpu_tlbstate.last_user_mm, next->mm);
+		}
+	}
 }
 
 void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
@@ -121,30 +196,12 @@ void switch_mm_irqs_off(struct mm_struct
 	unsigned cpu = smp_processor_id();
 
 	if (likely(prev != next)) {
-		u64 last_ctx_id = this_cpu_read(cpu_tlbstate.last_ctx_id);
-
 		/*
 		 * Avoid user/user BTB poisoning by flushing the branch
 		 * predictor when switching between processes. This stops
 		 * one process from doing Spectre-v2 attacks on another.
-		 *
-		 * As an optimization, flush indirect branches only when
-		 * switching into a processes that can't be ptrace by the
-		 * current one (as in such case, attacker has much more
-		 * convenient way how to tamper with the next process than
-		 * branch buffer poisoning).
-		 */
-		if (static_cpu_has(X86_FEATURE_USE_IBPB) &&
-				ibpb_needed(tsk, last_ctx_id))
-			indirect_branch_prediction_barrier();
-
-		/*
-		 * Record last user mm's context id, so we can avoid
-		 * flushing branch buffer with IBPB if we switch back
-		 * to the same user.
 		 */
-		if (next != &init_mm)
-			this_cpu_write(cpu_tlbstate.last_ctx_id, next->context.ctx_id);
+		cond_ibpb(tsk);
 
 		this_cpu_write(cpu_tlbstate.state, TLBSTATE_OK);
 		this_cpu_write(cpu_tlbstate.active_mm, next);


