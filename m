Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF2220C4D
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfEPQDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:03:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42512 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726733AbfEPP6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:43 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImG-0006zW-Kk; Thu, 16 May 2019 16:58:40 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001QW-47; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        "Asit Mallick" <asit.k.mallick@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Kees Cook" <keescook@chromium.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "Andrea Arcangeli" <aarcange@redhat.com>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "Casey Schaufler" <casey.schaufler@intel.com>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Dave Stewart" <david.c.stewart@intel.com>,
        "Jon Masters" <jcm@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Waiman Long" <longman9394@gmail.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.299520756@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 52/86] x86/speculation: Prepare for conditional IBPB
 in switch_mm()
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
[bwh: Backported to 3.16:
 - Drop changes in initialize_tlbstate_and_flush()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -257,6 +257,8 @@ do {									\
 } while (0)
 
 DECLARE_STATIC_KEY_FALSE(switch_to_cond_stibp);
+DECLARE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
+DECLARE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_NOSPEC_BRANCH_H_ */
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -268,6 +268,12 @@ void native_flush_tlb_others(const struc
 struct tlb_state {
 	struct mm_struct *active_mm;
 	int state;
+
+	/* Last user mm for optimizing IBPB */
+	union {
+		struct mm_struct	*last_user_mm;
+		unsigned long		last_user_mm_ibpb;
+	};
 };
 DECLARE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate);
 
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -53,6 +53,10 @@ u64 x86_amd_ls_cfg_ssbd_mask;
 
 /* Control conditional STIPB in switch_to() */
 DEFINE_STATIC_KEY_FALSE(switch_to_cond_stibp);
+/* Control conditional IBPB in switch_mm() */
+DEFINE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
+/* Control unconditional IBPB in switch_mm() */
+DEFINE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
 #ifdef CONFIG_X86_32
 
@@ -382,7 +386,17 @@ spectre_v2_user_select_mitigation(enum s
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
@@ -929,10 +943,15 @@ static char *stibp_state(void)
 
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
@@ -34,6 +33,12 @@ DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb
  *	Implement flush IPI by CALL_FUNCTION_VECTOR, Alex Shi
  */
 
+/*
+ * Use bit 0 to mangle the TIF_SPEC_IB state into the mm pointer which is
+ * stored in cpu_tlb_state.last_user_mm_ibpb.
+ */
+#define LAST_USER_MM_IBPB	0x1UL
+
 struct flush_tlb_info {
 	struct mm_struct *flush_mm;
 	unsigned long flush_start;
@@ -96,17 +101,87 @@ void switch_mm(struct mm_struct *prev, s
 	local_irq_restore(flags);
 }
 
-static bool ibpb_needed(struct task_struct *tsk)
+static inline unsigned long mm_mangle_tif_spec_ib(struct task_struct *next)
+{
+	unsigned long next_tif = task_thread_info(next)->flags;
+	unsigned long ibpb = (next_tif >> TIF_SPEC_IB) & LAST_USER_MM_IBPB;
+
+	return (unsigned long)next->mm | ibpb;
+}
+
+static void cond_ibpb(struct task_struct *next)
 {
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
-	return (tsk && tsk->mm &&
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
@@ -119,15 +194,8 @@ void switch_mm_irqs_off(struct mm_struct
 		 * Avoid user/user BTB poisoning by flushing the branch
 		 * predictor when switching between processes. This stops
 		 * one process from doing Spectre-v2 attacks on another.
-		 *
-		 * As an optimization, flush indirect branches only when
-		 * switching into a processes that can't be ptrace by the
-		 * current one (as in such case, attacker has much more
-		 * convenient way how to tamper with the next process than
-		 * branch buffer poisoning).
 		 */
-		if (static_cpu_has(X86_FEATURE_USE_IBPB) && ibpb_needed(tsk))
-			indirect_branch_prediction_barrier();
+		cond_ibpb(tsk);
 
 		this_cpu_write(cpu_tlbstate.state, TLBSTATE_OK);
 		this_cpu_write(cpu_tlbstate.active_mm, next);

