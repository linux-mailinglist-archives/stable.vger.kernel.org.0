Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 041291F273
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbfEOLLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729502AbfEOLLB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2017120881;
        Wed, 15 May 2019 11:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918660;
        bh=/FP2QQNc5LkcV9UVCtUNaecoh3TWdaP/PJrRnDtC0e4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PILpWqgmuMFAUa4jdmz+b/rQdi0oYen+PsoQM5oiKDih5Yp6zh8JLledtBDUdZV4r
         jIE2qOyrLmc6upi6+u3XI2aH891ZCov4WmD/F4mM8jXLzCJlXl6NO/SjRz0vcAqFZ7
         sto+GLdQpQxtihH9fpo+qUNBhmFFdip07aQExbgg=
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
Subject: [PATCH 4.4 217/266] x86/process: Consolidate and simplify switch_to_xtra() code
Date:   Wed, 15 May 2019 12:55:24 +0200
Message-Id: <20190515090730.323553185@linuxfoundation.org>
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
[bwh: Backported to 4.4:
 - Use cpu_tss instead of cpu_tss_rw
 - __switch_to() still uses the tss variable, so don't delete it
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/switch_to.h |    3 ---
 arch/x86/kernel/process.c        |   12 +++++++-----
 arch/x86/kernel/process.h        |   24 ++++++++++++++++++++++++
 arch/x86/kernel/process_32.c     |    9 +++------
 arch/x86/kernel/process_64.c     |    9 +++------
 5 files changed, 37 insertions(+), 20 deletions(-)
 create mode 100644 arch/x86/kernel/process.h

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
@@ -33,6 +33,8 @@
 #include <asm/vm86.h>
 #include <asm/spec-ctrl.h>
 
+#include "process.h"
+
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
  * no more per-task TSS's. The TSS size is kept cacheline-aligned
@@ -179,11 +181,12 @@ int set_tsc_mode(unsigned int val)
 	return 0;
 }
 
-static inline void switch_to_bitmap(struct tss_struct *tss,
-				    struct thread_struct *prev,
+static inline void switch_to_bitmap(struct thread_struct *prev,
 				    struct thread_struct *next,
 				    unsigned long tifp, unsigned long tifn)
 {
+	struct tss_struct *tss = this_cpu_ptr(&cpu_tss);
+
 	if (tifn & _TIF_IO_BITMAP) {
 		/*
 		 * Copy the relevant range of the IO bitmap.
@@ -370,8 +373,7 @@ void speculation_ctrl_update(unsigned lo
 	preempt_enable();
 }
 
-void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
-		      struct tss_struct *tss)
+void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev, *next;
 	unsigned long tifp, tifn;
@@ -381,7 +383,7 @@ void __switch_to_xtra(struct task_struct
 
 	tifn = READ_ONCE(task_thread_info(next_p)->flags);
 	tifp = READ_ONCE(task_thread_info(prev_p)->flags);
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
 #include <asm/switch_to.h>
 #include <asm/vm86.h>
 
+#include "process.h"
+
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 asmlinkage void ret_from_kernel_thread(void) __asm__("ret_from_kernel_thread");
 
@@ -279,12 +281,7 @@ __switch_to(struct task_struct *prev_p,
 	if (get_kernel_rpl() && unlikely(prev->iopl != next->iopl))
 		set_iopl_mask(next->iopl);
 
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
@@ -50,6 +50,8 @@
 #include <asm/switch_to.h>
 #include <asm/xen/hypervisor.h>
 
+#include "process.h"
+
 asmlinkage extern void ret_from_fork(void);
 
 __visible DEFINE_PER_CPU(unsigned long, rsp_scratch);
@@ -406,12 +408,7 @@ __switch_to(struct task_struct *prev_p,
 	/* Reload esp0 and ss1.  This changes current_thread_info(). */
 	load_sp0(tss, next);
 
-	/*
-	 * Now maybe reload the debug registers and handle I/O bitmaps
-	 */
-	if (unlikely(task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT ||
-		     task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW_PREV))
-		__switch_to_xtra(prev_p, next_p, tss);
+	switch_to_extra(prev_p, next_p);
 
 #ifdef CONFIG_XEN
 	/*


