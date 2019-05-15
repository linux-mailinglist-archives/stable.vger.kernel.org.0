Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 612F11F27C
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbfEOLLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:11:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729538AbfEOLLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23A962084F;
        Wed, 15 May 2019 11:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918672;
        bh=nLP5alnns8TN9xP24VV+pZjoydCx2K0Thsww2XBVqMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXO0nhLgVSGryQOjGECfjggwt6VR/xiyJW/J6lGQw74K9pQuu5bgqA4WDaHRMp874
         Op75g9jKIVNAIschH7YCn+aDXEUa1mnvGqfm1sJDHKIjDh9i9bvDwJbR13z4Vefgo6
         tt8dydDnFSUhloVfbfoF9u393/vF5LxJBVd2o6U4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
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
Subject: [PATCH 4.4 222/266] x86/speculation: Prevent stale SPEC_CTRL msr content
Date:   Wed, 15 May 2019 12:55:29 +0200
Message-Id: <20190515090730.504905487@linuxfoundation.org>
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
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/spec-ctrl.h   |    6 +-----
 arch/x86/include/asm/thread_info.h |    4 +++-
 arch/x86/kernel/cpu/bugs.c         |   18 +++++++-----------
 arch/x86/kernel/process.c          |   30 +++++++++++++++++++++++++++++-
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
@@ -97,6 +97,7 @@ struct thread_info {
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
 #define TIF_SPEC_IB		9	/* Indirect branch speculation mitigation */
+#define TIF_SPEC_FORCE_UPDATE	10	/* Force speculation MSR update in context switch */
 #define TIF_USER_RETURN_NOTIFY	11	/* notify kernel of userspace return */
 #define TIF_UPROBE		12	/* breakpointed or singlestepping */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
@@ -123,6 +124,7 @@ struct thread_info {
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_SPEC_IB		(1 << TIF_SPEC_IB)
+#define _TIF_SPEC_FORCE_UPDATE	(1 << TIF_SPEC_FORCE_UPDATE)
 #define _TIF_USER_RETURN_NOTIFY	(1 << TIF_USER_RETURN_NOTIFY)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
@@ -152,7 +154,7 @@ struct thread_info {
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW_BASE						\
 	(_TIF_IO_BITMAP|_TIF_NOTSC|_TIF_BLOCKSTEP|			\
-	 _TIF_SSBD)
+	 _TIF_SSBD | _TIF_SPEC_FORCE_UPDATE)
 
 /*
  * Avoid calls to __switch_to_xtra() on UP as STIBP is not evaluated.
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -701,14 +701,10 @@ static void ssb_select_mitigation(void)
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
@@ -718,7 +714,7 @@ static void task_update_spec_tif(struct
 	 * This can only happen for SECCOMP mitigation. For PRCTL it's
 	 * always the current task.
 	 */
-	if (tsk == current && update)
+	if (tsk == current)
 		speculation_ctrl_update_current();
 }
 
@@ -734,16 +730,16 @@ static int ssb_prctl_set(struct task_str
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
@@ -365,6 +365,18 @@ static __always_inline void __speculatio
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
@@ -373,6 +385,14 @@ void speculation_ctrl_update(unsigned lo
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
@@ -401,7 +421,15 @@ void __switch_to_xtra(struct task_struct
 	if ((tifp ^ tifn) & _TIF_NOTSC)
 		cr4_toggle_bits(X86_CR4_TSD);
 
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


