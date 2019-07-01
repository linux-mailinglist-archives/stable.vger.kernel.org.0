Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 451C620BE7
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfEPP7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:59:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43408 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727173AbfEPP6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:51 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImN-0006zN-0z; Thu, 16 May 2019 16:58:47 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001Qk-6m; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Kees Cook" <keescook@chromium.org>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        "Asit Mallick" <asit.k.mallick@intel.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Andrea Arcangeli" <aarcange@redhat.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Dave Stewart" <david.c.stewart@intel.com>,
        "Jon Masters" <jcm@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Waiman Long" <longman9394@gmail.com>,
        "Casey Schaufler" <casey.schaufler@intel.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Tim Chen" <tim.c.chen@linux.intel.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.919360148@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 55/86] x86/speculation: Prevent stale SPEC_CTRL msr
 content
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

commit 6d991ba509ebcfcc908e009d1db51972a4f7a064 upstream.

The seccomp speculation control operates on all tasks of a process, but
only the current task of a process can update the MSR immediately. For the
other threads the update is deferred to the next context switch.

This creates the following situation with Process A and B:

Process A task 2 and Process B task 1 are pinned on CPU1. Process A task 2
does not have the speculation control TIF bit set. Process B task 1 has the
speculation control TIF bit set.

CPU0					CPU1
					MSR bit is set
					ProcB.T1 schedules out
					ProcA.T2 schedules in
					MSR bit is cleared
ProcA.T1
  seccomp_update()
  set TIF bit on ProcA.T2
					ProcB.T1 schedules in
					MSR is not updated  <-- FAIL

This happens because the context switch code tries to avoid the MSR update
if the speculation control TIF bits of the incoming and the outgoing task
are the same. In the worst case ProcB.T1 and ProcA.T2 are the only tasks
scheduling back and forth on CPU1, which keeps the MSR stale forever.

In theory this could be remedied by IPIs, but chasing the remote task which
could be migrated is complex and full of races.

The straight forward solution is to avoid the asychronous update of the TIF
bit and defer it to the next context switch. The speculation control state
is stored in task_struct::atomic_flags by the prctl and seccomp updates
already.

Add a new TIF_SPEC_FORCE_UPDATE bit and set this after updating the
atomic_flags. Check the bit on context switch and force a synchronous
update of the speculation control if set. Use the same mechanism for
updating the current task.

Reported-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1811272247140.1875@nanos.tec.linutronix.de
[bwh: Backported to 3.16:
 - Assign the first available thread_info flag
 - Exclude _TIF_SPEC_FORCE_UPDATE from _TIF_WORK_MASK and _TIF_ALLWORK_MASK]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/spec-ctrl.h   |  6 +-----
 arch/x86/include/asm/thread_info.h |  4 +++-
 arch/x86/kernel/cpu/bugs.c         | 18 +++++++-----------
 arch/x86/kernel/process.c          | 30 +++++++++++++++++++++++++++++-
 4 files changed, 40 insertions(+), 18 deletions(-)

--- a/arch/x86/include/asm/spec-ctrl.h
+++ b/arch/x86/include/asm/spec-ctrl.h
@@ -83,10 +83,6 @@ static inline void speculative_store_byp
 #endif
 
 extern void speculation_ctrl_update(unsigned long tif);
-
-static inline void speculation_ctrl_update_current(void)
-{
-	speculation_ctrl_update(current_thread_info()->flags);
-}
+extern void speculation_ctrl_update_current(void);
 
 #endif
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -80,6 +80,7 @@ struct thread_info {
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
 #define TIF_USER_RETURN_NOTIFY	11	/* notify kernel of userspace return */
 #define TIF_UPROBE		12	/* breakpointed or singlestepping */
+#define TIF_SPEC_FORCE_UPDATE	13	/* Force speculation MSR update in context switch */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* IA32 compatibility process */
 #define TIF_FORK		18	/* ret_from_fork */
@@ -107,6 +108,7 @@ struct thread_info {
 #define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
 #define _TIF_USER_RETURN_NOTIFY	(1 << TIF_USER_RETURN_NOTIFY)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
+#define _TIF_SPEC_FORCE_UPDATE	(1 << TIF_SPEC_FORCE_UPDATE)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
@@ -136,11 +138,12 @@ struct thread_info {
 	(0x0000FFFF &							\
 	 ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|			\
 	   _TIF_SINGLESTEP|_TIF_SSBD|_TIF_SECCOMP|_TIF_SYSCALL_EMU|	\
-	   _TIF_SPEC_IB))
+	   _TIF_SPEC_IB|_TIF_SPEC_FORCE_UPDATE))
 
 /* work to do on any return to user space */
 #define _TIF_ALLWORK_MASK						\
-	((0x0000FFFF & ~(_TIF_SSBD | _TIF_SECCOMP | _TIF_SPEC_IB)) |	\
+	((0x0000FFFF & ~(_TIF_SSBD | _TIF_SECCOMP | _TIF_SPEC_IB |	\
+			 _TIF_SPEC_FORCE_UPDATE)) |			\
 	 _TIF_SYSCALL_TRACEPOINT | _TIF_NOHZ)
 
 /* Only used for 64 bit */
@@ -151,7 +154,7 @@ struct thread_info {
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW_BASE						\
 	(_TIF_IO_BITMAP|_TIF_NOTSC|_TIF_BLOCKSTEP|			\
-	 _TIF_SSBD)
+	 _TIF_SSBD | _TIF_SPEC_FORCE_UPDATE)
 
 /*
  * Avoid calls to __switch_to_xtra() on UP as STIBP is not evaluated.
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -764,14 +764,10 @@ static void ssb_select_mitigation(void)
 #undef pr_fmt
 #define pr_fmt(fmt)     "Speculation prctl: " fmt
 
-static void task_update_spec_tif(struct task_struct *tsk, int tifbit, bool on)
+static void task_update_spec_tif(struct task_struct *tsk)
 {
-	bool update;
-
-	if (on)
-		update = !test_and_set_tsk_thread_flag(tsk, tifbit);
-	else
-		update = test_and_clear_tsk_thread_flag(tsk, tifbit);
+	/* Force the update of the real TIF bits */
+	set_tsk_thread_flag(tsk, TIF_SPEC_FORCE_UPDATE);
 
 	/*
 	 * Immediately update the speculation control MSRs for the current
@@ -781,7 +777,7 @@ static void task_update_spec_tif(struct
 	 * This can only happen for SECCOMP mitigation. For PRCTL it's
 	 * always the current task.
 	 */
-	if (tsk == current && update)
+	if (tsk == current)
 		speculation_ctrl_update_current();
 }
 
@@ -797,16 +793,16 @@ static int ssb_prctl_set(struct task_str
 		if (task_spec_ssb_force_disable(task))
 			return -EPERM;
 		task_clear_spec_ssb_disable(task);
-		task_update_spec_tif(task, TIF_SSBD, false);
+		task_update_spec_tif(task);
 		break;
 	case PR_SPEC_DISABLE:
 		task_set_spec_ssb_disable(task);
-		task_update_spec_tif(task, TIF_SSBD, true);
+		task_update_spec_tif(task);
 		break;
 	case PR_SPEC_FORCE_DISABLE:
 		task_set_spec_ssb_disable(task);
 		task_set_spec_ssb_force_disable(task);
-		task_update_spec_tif(task, TIF_SSBD, true);
+		task_update_spec_tif(task);
 		break;
 	default:
 		return -ERANGE;
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -383,6 +383,18 @@ static __always_inline void __speculatio
 		wrmsrl(MSR_IA32_SPEC_CTRL, msr);
 }
 
+static unsigned long speculation_ctrl_update_tif(struct task_struct *tsk)
+{
+	if (test_and_clear_tsk_thread_flag(tsk, TIF_SPEC_FORCE_UPDATE)) {
+		if (task_spec_ssb_disable(tsk))
+			set_tsk_thread_flag(tsk, TIF_SSBD);
+		else
+			clear_tsk_thread_flag(tsk, TIF_SSBD);
+	}
+	/* Return the updated threadinfo flags*/
+	return task_thread_info(tsk)->flags;
+}
+
 void speculation_ctrl_update(unsigned long tif)
 {
 	/* Forced update. Make sure all relevant TIF flags are different */
@@ -391,6 +403,14 @@ void speculation_ctrl_update(unsigned lo
 	preempt_enable();
 }
 
+/* Called from seccomp/prctl update */
+void speculation_ctrl_update_current(void)
+{
+	preempt_disable();
+	speculation_ctrl_update(speculation_ctrl_update_tif(current));
+	preempt_enable();
+}
+
 void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev, *next;
@@ -423,7 +443,15 @@ void __switch_to_xtra(struct task_struct
 			hard_enable_TSC();
 	}
 
-	__speculation_ctrl_update(tifp, tifn);
+	if (likely(!((tifp | tifn) & _TIF_SPEC_FORCE_UPDATE))) {
+		__speculation_ctrl_update(tifp, tifn);
+	} else {
+		speculation_ctrl_update_tif(prev_p);
+		tifn = speculation_ctrl_update_tif(next_p);
+
+		/* Enforce MSR update to ensure consistent state */
+		__speculation_ctrl_update(~tifn, tifn);
+	}
 }
 
 /*

