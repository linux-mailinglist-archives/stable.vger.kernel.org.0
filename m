Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05DD020BDA
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 17:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfEPP6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:58:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43342 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727162AbfEPP6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:50 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImM-0006zQ-OX; Thu, 16 May 2019 16:58:46 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001QK-0M; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "Casey Schaufler" <casey.schaufler@intel.com>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Dave Stewart" <david.c.stewart@intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jon Masters" <jcm@redhat.com>,
        "Waiman Long" <longman9394@gmail.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "Andrea Arcangeli" <aarcange@redhat.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        "Asit Mallick" <asit.k.mallick@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Kees Cook" <keescook@chromium.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Jiri Kosina" <jkosina@suse.cz>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.580742350@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 50/86] x86/process: Consolidate and simplify
 switch_to_xtra() code
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

commit ff16701a29cba3aafa0bd1656d766813b2d0a811 upstream.

Move the conditional invocation of __switch_to_xtra() into an inline
function so the logic can be shared between 32 and 64 bit.

Remove the handthrough of the TSS pointer and retrieve the pointer directly
in the bitmap handling function. Use this_cpu_ptr() instead of the
per_cpu() indirection.

This is a preparatory change so integration of conditional indirect branch
speculation optimization happens only in one place.

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
Link: https://lkml.kernel.org/r/20181125185005.280855518@linutronix.de
[bwh: Backported to 3.16:
 - Use init_tss instead of cpu_tss_rw
 - __switch_to() still uses the tss variable, so don't delete it
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -6,9 +6,6 @@
 struct task_struct; /* one of the stranger aspects of C forward declarations */
 __visible struct task_struct *__switch_to(struct task_struct *prev,
 					   struct task_struct *next);
-struct tss_struct;
-void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
-		      struct tss_struct *tss);
 
 #ifdef CONFIG_X86_32
 
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -32,6 +32,8 @@
 #include <asm/tlbflush.h>
 #include <asm/spec-ctrl.h>
 
+#include "process.h"
+
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
  * no more per-task TSS's. The TSS size is kept cacheline-aligned
@@ -197,11 +199,12 @@ int set_tsc_mode(unsigned int val)
 	return 0;
 }
 
-static inline void switch_to_bitmap(struct tss_struct *tss,
-				    struct thread_struct *prev,
+static inline void switch_to_bitmap(struct thread_struct *prev,
 				    struct thread_struct *next,
 				    unsigned long tifp, unsigned long tifn)
 {
+	struct tss_struct *tss = this_cpu_ptr(&init_tss);
+
 	if (tifn & _TIF_IO_BITMAP) {
 		/*
 		 * Copy the relevant range of the IO bitmap.
@@ -388,8 +391,7 @@ void speculation_ctrl_update(unsigned lo
 	preempt_enable();
 }
 
-void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
-		      struct tss_struct *tss)
+void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev, *next;
 	unsigned long tifp, tifn;
@@ -399,7 +401,7 @@ void __switch_to_xtra(struct task_struct
 
 	tifn = ACCESS_ONCE(task_thread_info(next_p)->flags);
 	tifp = ACCESS_ONCE(task_thread_info(prev_p)->flags);
-	switch_to_bitmap(tss, prev, next, tifp, tifn);
+	switch_to_bitmap(prev, next, tifp, tifn);
 
 	propagate_user_return_notify(prev_p, next_p);
 
--- /dev/null
+++ b/arch/x86/kernel/process.h
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Code shared between 32 and 64 bit
+
+void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p);
+
+/*
+ * This needs to be inline to optimize for the common case where no extra
+ * work needs to be done.
+ */
+static inline void switch_to_extra(struct task_struct *prev,
+				   struct task_struct *next)
+{
+	unsigned long next_tif = task_thread_info(next)->flags;
+	unsigned long prev_tif = task_thread_info(prev)->flags;
+
+	/*
+	 * __switch_to_xtra() handles debug registers, i/o bitmaps,
+	 * speculation mitigations etc.
+	 */
+	if (unlikely(next_tif & _TIF_WORK_CTXSW_NEXT ||
+		     prev_tif & _TIF_WORK_CTXSW_PREV))
+		__switch_to_xtra(prev, next);
+}
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -55,6 +55,8 @@
 #include <asm/debugreg.h>
 #include <asm/switch_to.h>
 
+#include "process.h"
+
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 asmlinkage void ret_from_kernel_thread(void) __asm__("ret_from_kernel_thread");
 
@@ -298,12 +300,7 @@ __switch_to(struct task_struct *prev_p,
 	task_thread_info(prev_p)->saved_preempt_count = this_cpu_read(__preempt_count);
 	this_cpu_write(__preempt_count, task_thread_info(next_p)->saved_preempt_count);
 
-	/*
-	 * Now maybe handle debug registers and/or IO bitmaps
-	 */
-	if (unlikely(task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW_PREV ||
-		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
-		__switch_to_xtra(prev_p, next_p, tss);
+	switch_to_extra(prev_p, next_p);
 
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -51,6 +51,8 @@
 #include <asm/switch_to.h>
 #include <asm/xen/hypervisor.h>
 
+#include "process.h"
+
 asmlinkage extern void ret_from_fork(void);
 
 __visible DEFINE_PER_CPU_USER_MAPPED(unsigned long, old_rsp);
@@ -428,12 +430,7 @@ __switch_to(struct task_struct *prev_p,
 		  (unsigned long)task_stack_page(next_p) +
 		  THREAD_SIZE - KERNEL_STACK_OFFSET);
 
-	/*
-	 * Now maybe reload the debug registers and handle I/O bitmaps
-	 */
-	if (unlikely(task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT ||
-		     task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW_PREV))
-		__switch_to_xtra(prev_p, next_p, tss);
+	switch_to_extra(prev_p, next_p);
 
 #ifdef CONFIG_XEN
 	/*

