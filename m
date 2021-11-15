Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8159645114C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243764AbhKOTDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:03:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:35154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243384AbhKOTA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:00:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8A8D63269;
        Mon, 15 Nov 2021 18:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000042;
        bh=dLckuDg+pvGBjmVJdNtZvGWd4dviiyvmOnJpukd86sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4nTBBzLjOVdlIoSYfS6HuUElew4QzYvRx4mqZZBEHGjqYAY22hYwhxXucA/vpAmQ
         AyTt3/raVmPXh73nAAnhNHNBPv4QNIqR/Z/3l4WyYca02W6wr/XnlDETeiNGJZgOCt
         cIMjVbIUg/VdmGBraenI6VzN7r5+RzmsNcoeYAQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 5.14 516/849] sched: Add wrapper for get_wchan() to keep task blocked
Date:   Mon, 15 Nov 2021 17:59:59 +0100
Message-Id: <20211115165437.737684749@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 42a20f86dc19f9282d974df0ba4d226c865ab9dd ]

Having a stable wchan means the process must be blocked and for it to
stay that way while performing stack unwinding.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk> [arm]
Tested-by: Mark Rutland <mark.rutland@arm.com> [arm64]
Link: https://lkml.kernel.org/r/20211008111626.332092234@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/asm/processor.h      |  2 +-
 arch/alpha/kernel/process.c             |  5 ++---
 arch/arc/include/asm/processor.h        |  2 +-
 arch/arc/kernel/stacktrace.c            |  4 ++--
 arch/arm/include/asm/processor.h        |  2 +-
 arch/arm/kernel/process.c               |  4 +---
 arch/arm64/include/asm/processor.h      |  2 +-
 arch/arm64/kernel/process.c             |  4 +---
 arch/csky/include/asm/processor.h       |  2 +-
 arch/csky/kernel/stacktrace.c           |  5 ++---
 arch/h8300/include/asm/processor.h      |  2 +-
 arch/h8300/kernel/process.c             |  5 +----
 arch/hexagon/include/asm/processor.h    |  2 +-
 arch/hexagon/kernel/process.c           |  4 +---
 arch/ia64/include/asm/processor.h       |  2 +-
 arch/ia64/kernel/process.c              |  5 +----
 arch/m68k/include/asm/processor.h       |  2 +-
 arch/m68k/kernel/process.c              |  4 +---
 arch/microblaze/include/asm/processor.h |  2 +-
 arch/microblaze/kernel/process.c        |  2 +-
 arch/mips/include/asm/processor.h       |  2 +-
 arch/mips/kernel/process.c              |  8 +++-----
 arch/nds32/include/asm/processor.h      |  2 +-
 arch/nds32/kernel/process.c             |  7 +------
 arch/nios2/include/asm/processor.h      |  2 +-
 arch/nios2/kernel/process.c             |  5 +----
 arch/openrisc/include/asm/processor.h   |  2 +-
 arch/openrisc/kernel/process.c          |  2 +-
 arch/parisc/include/asm/processor.h     |  2 +-
 arch/parisc/kernel/process.c            |  5 +----
 arch/powerpc/include/asm/processor.h    |  2 +-
 arch/powerpc/kernel/process.c           |  9 +++------
 arch/riscv/include/asm/processor.h      |  2 +-
 arch/riscv/kernel/stacktrace.c          | 12 +++++-------
 arch/s390/include/asm/processor.h       |  2 +-
 arch/s390/kernel/process.c              |  4 ++--
 arch/sh/include/asm/processor_32.h      |  2 +-
 arch/sh/kernel/process_32.c             |  5 +----
 arch/sparc/include/asm/processor_32.h   |  2 +-
 arch/sparc/include/asm/processor_64.h   |  2 +-
 arch/sparc/kernel/process_32.c          |  5 +----
 arch/sparc/kernel/process_64.c          |  5 +----
 arch/um/include/asm/processor-generic.h |  2 +-
 arch/um/kernel/process.c                |  5 +----
 arch/x86/include/asm/processor.h        |  2 +-
 arch/x86/kernel/process.c               |  5 +----
 arch/xtensa/include/asm/processor.h     |  2 +-
 arch/xtensa/kernel/process.c            |  5 +----
 include/linux/sched.h                   |  1 +
 kernel/sched/core.c                     | 19 +++++++++++++++++++
 50 files changed, 80 insertions(+), 112 deletions(-)

diff --git a/arch/alpha/include/asm/processor.h b/arch/alpha/include/asm/processor.h
index 6100431da07a3..090499c99c1c1 100644
--- a/arch/alpha/include/asm/processor.h
+++ b/arch/alpha/include/asm/processor.h
@@ -42,7 +42,7 @@ extern void start_thread(struct pt_regs *, unsigned long, unsigned long);
 struct task_struct;
 extern void release_thread(struct task_struct *);
 
-unsigned long get_wchan(struct task_struct *p);
+unsigned long __get_wchan(struct task_struct *p);
 
 #define KSTK_EIP(tsk) (task_pt_regs(tsk)->pc)
 
diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index a5123ea426ce5..5f8527081da92 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -376,12 +376,11 @@ thread_saved_pc(struct task_struct *t)
 }
 
 unsigned long
-get_wchan(struct task_struct *p)
+__get_wchan(struct task_struct *p)
 {
 	unsigned long schedule_frame;
 	unsigned long pc;
-	if (!p || p == current || task_is_running(p))
-		return 0;
+
 	/*
 	 * This one depends on the frame size of schedule().  Do a
 	 * "disass schedule" in gdb to find the frame size.  Also, the
diff --git a/arch/arc/include/asm/processor.h b/arch/arc/include/asm/processor.h
index e4031ecd3c8c1..04a5268e592b9 100644
--- a/arch/arc/include/asm/processor.h
+++ b/arch/arc/include/asm/processor.h
@@ -70,7 +70,7 @@ struct task_struct;
 extern void start_thread(struct pt_regs * regs, unsigned long pc,
 			 unsigned long usp);
 
-extern unsigned int get_wchan(struct task_struct *p);
+extern unsigned int __get_wchan(struct task_struct *p);
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/arc/kernel/stacktrace.c b/arch/arc/kernel/stacktrace.c
index 1b9576d21e244..db96cc8783891 100644
--- a/arch/arc/kernel/stacktrace.c
+++ b/arch/arc/kernel/stacktrace.c
@@ -15,7 +15,7 @@
  *      = specifics of data structs where trace is saved(CONFIG_STACKTRACE etc)
  *
  *  vineetg: March 2009
- *  -Implemented correct versions of thread_saved_pc() and get_wchan()
+ *  -Implemented correct versions of thread_saved_pc() and __get_wchan()
  *
  *  rajeshwarr: 2008
  *  -Initial implementation
@@ -248,7 +248,7 @@ void show_stack(struct task_struct *tsk, unsigned long *sp, const char *loglvl)
  * Of course just returning schedule( ) would be pointless so unwind until
  * the function is not in schedular code
  */
-unsigned int get_wchan(struct task_struct *tsk)
+unsigned int __get_wchan(struct task_struct *tsk)
 {
 	return arc_unwind_core(tsk, NULL, __get_first_nonsched, NULL);
 }
diff --git a/arch/arm/include/asm/processor.h b/arch/arm/include/asm/processor.h
index 9e6b972863077..6af68edfa53ab 100644
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -84,7 +84,7 @@ struct task_struct;
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
 
-unsigned long get_wchan(struct task_struct *p);
+unsigned long __get_wchan(struct task_struct *p);
 
 #define task_pt_regs(p) \
 	((struct pt_regs *)(THREAD_START_SP + task_stack_page(p)) - 1)
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index fc9e8b37eaa84..261be96fa0c30 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -283,13 +283,11 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	return 0;
 }
 
-unsigned long get_wchan(struct task_struct *p)
+unsigned long __get_wchan(struct task_struct *p)
 {
 	struct stackframe frame;
 	unsigned long stack_page;
 	int count = 0;
-	if (!p || p == current || task_is_running(p))
-		return 0;
 
 	frame.fp = thread_saved_fp(p);
 	frame.sp = thread_saved_sp(p);
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index b6517fd03d7b6..922355eb7eefa 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -251,7 +251,7 @@ struct task_struct;
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
 
-unsigned long get_wchan(struct task_struct *p);
+unsigned long __get_wchan(struct task_struct *p);
 
 void set_task_sctlr_el1(u64 sctlr);
 
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index c858b857c1ecf..46995c972ff5f 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -544,13 +544,11 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
 	return last;
 }
 
-unsigned long get_wchan(struct task_struct *p)
+unsigned long __get_wchan(struct task_struct *p)
 {
 	struct stackframe frame;
 	unsigned long stack_page, ret = 0;
 	int count = 0;
-	if (!p || p == current || task_is_running(p))
-		return 0;
 
 	stack_page = (unsigned long)try_get_task_stack(p);
 	if (!stack_page)
diff --git a/arch/csky/include/asm/processor.h b/arch/csky/include/asm/processor.h
index 9e933021fe8e0..817dd60ff152d 100644
--- a/arch/csky/include/asm/processor.h
+++ b/arch/csky/include/asm/processor.h
@@ -81,7 +81,7 @@ static inline void release_thread(struct task_struct *dead_task)
 
 extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 
-unsigned long get_wchan(struct task_struct *p);
+unsigned long __get_wchan(struct task_struct *p);
 
 #define KSTK_EIP(tsk)		(task_pt_regs(tsk)->pc)
 #define KSTK_ESP(tsk)		(task_pt_regs(tsk)->usp)
diff --git a/arch/csky/kernel/stacktrace.c b/arch/csky/kernel/stacktrace.c
index 1b280ef080045..9f78f5d215117 100644
--- a/arch/csky/kernel/stacktrace.c
+++ b/arch/csky/kernel/stacktrace.c
@@ -111,12 +111,11 @@ static bool save_wchan(unsigned long pc, void *arg)
 	return false;
 }
 
-unsigned long get_wchan(struct task_struct *task)
+unsigned long __get_wchan(struct task_struct *task)
 {
 	unsigned long pc = 0;
 
-	if (likely(task && task != current && !task_is_running(task)))
-		walk_stackframe(task, NULL, save_wchan, &pc);
+	walk_stackframe(task, NULL, save_wchan, &pc);
 	return pc;
 }
 
diff --git a/arch/h8300/include/asm/processor.h b/arch/h8300/include/asm/processor.h
index a060b41b2d31c..141a23eb62b74 100644
--- a/arch/h8300/include/asm/processor.h
+++ b/arch/h8300/include/asm/processor.h
@@ -105,7 +105,7 @@ static inline void release_thread(struct task_struct *dead_task)
 {
 }
 
-unsigned long get_wchan(struct task_struct *p);
+unsigned long __get_wchan(struct task_struct *p);
 
 #define	KSTK_EIP(tsk)	\
 	({			 \
diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index 2ac27e4248a46..8833fa4f5d516 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -128,15 +128,12 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
 	return 0;
 }
 
-unsigned long get_wchan(struct task_struct *p)
+unsigned long __get_wchan(struct task_struct *p)
 {
 	unsigned long fp, pc;
 	unsigned long stack_page;
 	int count = 0;
 
-	if (!p || p == current || task_is_running(p))
-		return 0;
-
 	stack_page = (unsigned long)p;
 	fp = ((struct pt_regs *)p->thread.ksp)->er6;
 	do {
diff --git a/arch/hexagon/include/asm/processor.h b/arch/hexagon/include/asm/processor.h
index 9f0cc99420bee..615f7e49968e6 100644
--- a/arch/hexagon/include/asm/processor.h
+++ b/arch/hexagon/include/asm/processor.h
@@ -64,7 +64,7 @@ struct thread_struct {
 extern void release_thread(struct task_struct *dead_task);
 
 /* Get wait channel for task P.  */
-extern unsigned long get_wchan(struct task_struct *p);
+extern unsigned long __get_wchan(struct task_struct *p);
 
 /*  The following stuff is pretty HEXAGON specific.  */
 
diff --git a/arch/hexagon/kernel/process.c b/arch/hexagon/kernel/process.c
index 6a6835fb42425..232dfd8956aa2 100644
--- a/arch/hexagon/kernel/process.c
+++ b/arch/hexagon/kernel/process.c
@@ -130,13 +130,11 @@ void flush_thread(void)
  * is an identification of the point at which the scheduler
  * was invoked by a blocked thread.
  */
-unsigned long get_wchan(struct task_struct *p)
+unsigned long __get_wchan(struct task_struct *p)
 {
 	unsigned long fp, pc;
 	unsigned long stack_page;
 	int count = 0;
-	if (!p || p == current || task_is_running(p))
-		return 0;
 
 	stack_page = (unsigned long)task_stack_page(p);
 	fp = ((struct hexagon_switch_stack *)p->thread.switch_sp)->fp;
diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index 2d8bcdc27d7f8..45365c2ef5983 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -330,7 +330,7 @@ struct task_struct;
 #define release_thread(dead_task)
 
 /* Get wait channel for task P.  */
-extern unsigned long get_wchan (struct task_struct *p);
+extern unsigned long __get_wchan (struct task_struct *p);
 
 /* Return instruction pointer of blocked task TSK.  */
 #define KSTK_EIP(tsk)					\
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index e56d63f4abf9d..834df24a88f12 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -523,15 +523,12 @@ exit_thread (struct task_struct *tsk)
 }
 
 unsigned long
-get_wchan (struct task_struct *p)
+__get_wchan (struct task_struct *p)
 {
 	struct unw_frame_info info;
 	unsigned long ip;
 	int count = 0;
 
-	if (!p || p == current || task_is_running(p))
-		return 0;
-
 	/*
 	 * Note: p may not be a blocked task (it could be current or
 	 * another process running on some other CPU.  Rather than
diff --git a/arch/m68k/include/asm/processor.h b/arch/m68k/include/asm/processor.h
index 3750819ac5a13..bacec548cb3c6 100644
--- a/arch/m68k/include/asm/processor.h
+++ b/arch/m68k/include/asm/processor.h
@@ -125,7 +125,7 @@ static inline void release_thread(struct task_struct *dead_task)
 {
 }
 
-unsigned long get_wchan(struct task_struct *p);
+unsigned long __get_wchan(struct task_struct *p);
 
 #define	KSTK_EIP(tsk)	\
     ({			\
diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index db49f90917112..d2357cba09abe 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -263,13 +263,11 @@ int dump_fpu (struct pt_regs *regs, struct user_m68kfp_struct *fpu)
 }
 EXPORT_SYMBOL(dump_fpu);
 
-unsigned long get_wchan(struct task_struct *p)
+unsigned long __get_wchan(struct task_struct *p)
 {
 	unsigned long fp, pc;
 	unsigned long stack_page;
 	int count = 0;
-	if (!p || p == current || task_is_running(p))
-		return 0;
 
 	stack_page = (unsigned long)task_stack_page(p);
 	fp = ((struct switch_stack *)p->thread.ksp)->a6;
diff --git a/arch/microblaze/include/asm/processor.h b/arch/microblaze/include/asm/processor.h
index 06c6e493590a2..7e9e92670df33 100644
--- a/arch/microblaze/include/asm/processor.h
+++ b/arch/microblaze/include/asm/processor.h
@@ -68,7 +68,7 @@ static inline void release_thread(struct task_struct *dead_task)
 {
 }
 
-unsigned long get_wchan(struct task_struct *p);
+unsigned long __get_wchan(struct task_struct *p);
 
 /* The size allocated for kernel stacks. This _must_ be a power of two! */
 # define KERNEL_STACK_SIZE	0x2000
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 62aa237180b67..5e2b91c1e8ced 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -112,7 +112,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp, unsigned long arg,
 	return 0;
 }
 
-unsigned long get_wchan(struct task_struct *p)
+unsigned long __get_wchan(struct task_struct *p)
 {
 /* TBD (used by procfs) */
 	return 0;
diff --git a/arch/mips/include/asm/processor.h b/arch/mips/include/asm/processor.h
index 0c3550c82b726..252ed38ce8c5a 100644
--- a/arch/mips/include/asm/processor.h
+++ b/arch/mips/include/asm/processor.h
@@ -369,7 +369,7 @@ static inline void flush_thread(void)
 {
 }
 
-unsigned long get_wchan(struct task_struct *p);
+unsigned long __get_wchan(struct task_struct *p);
 
 #define __KSTK_TOS(tsk) ((unsigned long)task_stack_page(tsk) + \
 			 THREAD_SIZE - 32 - sizeof(struct pt_regs))
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 73c8e7990a973..637e6207e3500 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -511,7 +511,7 @@ static int __init frame_info_init(void)
 
 	/*
 	 * Without schedule() frame info, result given by
-	 * thread_saved_pc() and get_wchan() are not reliable.
+	 * thread_saved_pc() and __get_wchan() are not reliable.
 	 */
 	if (schedule_mfi.pc_offset < 0)
 		printk("Can't analyze schedule() prologue at %p\n", schedule);
@@ -652,9 +652,9 @@ unsigned long unwind_stack(struct task_struct *task, unsigned long *sp,
 #endif
 
 /*
- * get_wchan - a maintenance nightmare^W^Wpain in the ass ...
+ * __get_wchan - a maintenance nightmare^W^Wpain in the ass ...
  */
-unsigned long get_wchan(struct task_struct *task)
+unsigned long __get_wchan(struct task_struct *task)
 {
 	unsigned long pc = 0;
 #ifdef CONFIG_KALLSYMS
@@ -662,8 +662,6 @@ unsigned long get_wchan(struct task_struct *task)
 	unsigned long ra = 0;
 #endif
 
-	if (!task || task == current || task_is_running(task))
-		goto out;
 	if (!task_stack_page(task))
 		goto out;
 
diff --git a/arch/nds32/include/asm/processor.h b/arch/nds32/include/asm/processor.h
index b82369c7659d4..e6bfc74972bb3 100644
--- a/arch/nds32/include/asm/processor.h
+++ b/arch/nds32/include/asm/processor.h
@@ -83,7 +83,7 @@ extern struct task_struct *last_task_used_math;
 /* Prepare to copy thread state - unlazy all lazy status */
 #define prepare_to_copy(tsk)	do { } while (0)
 
-unsigned long get_wchan(struct task_struct *p);
+unsigned long __get_wchan(struct task_struct *p);
 
 #define cpu_relax()			barrier()
 
diff --git a/arch/nds32/kernel/process.c b/arch/nds32/kernel/process.c
index 391895b54d13c..49fab9e39cbff 100644
--- a/arch/nds32/kernel/process.c
+++ b/arch/nds32/kernel/process.c
@@ -233,15 +233,12 @@ int dump_fpu(struct pt_regs *regs, elf_fpregset_t * fpu)
 
 EXPORT_SYMBOL(dump_fpu);
 
-unsigned long get_wchan(struct task_struct *p)
+unsigned long __get_wchan(struct task_struct *p)
 {
 	unsigned long fp, lr;
 	unsigned long stack_start, stack_end;
 	int count = 0;
 
-	if (!p || p == current || task_is_running(p))
-		return 0;
-
 	if (IS_ENABLED(CONFIG_FRAME_POINTER)) {
 		stack_start = (unsigned long)end_of_stack(p);
 		stack_end = (unsigned long)task_stack_page(p) + THREAD_SIZE;
@@ -258,5 +255,3 @@ unsigned long get_wchan(struct task_struct *p)
 	}
 	return 0;
 }
-
-EXPORT_SYMBOL(get_wchan);
diff --git a/arch/nios2/include/asm/processor.h b/arch/nios2/include/asm/processor.h
index 94bcb86f679f5..b8125dfbcad2d 100644
--- a/arch/nios2/include/asm/processor.h
+++ b/arch/nios2/include/asm/processor.h
@@ -69,7 +69,7 @@ static inline void release_thread(struct task_struct *dead_task)
 {
 }
 
-extern unsigned long get_wchan(struct task_struct *p);
+extern unsigned long __get_wchan(struct task_struct *p);
 
 #define task_pt_regs(p) \
 	((struct pt_regs *)(THREAD_SIZE + task_stack_page(p)) - 1)
diff --git a/arch/nios2/kernel/process.c b/arch/nios2/kernel/process.c
index 9ff37ba2bb603..f8ea522a15880 100644
--- a/arch/nios2/kernel/process.c
+++ b/arch/nios2/kernel/process.c
@@ -217,15 +217,12 @@ void dump(struct pt_regs *fp)
 	pr_emerg("\n\n");
 }
 
-unsigned long get_wchan(struct task_struct *p)
+unsigned long __get_wchan(struct task_struct *p)
 {
 	unsigned long fp, pc;
 	unsigned long stack_page;
 	int count = 0;
 
-	if (!p || p == current || task_is_running(p))
-		return 0;
-
 	stack_page = (unsigned long)p;
 	fp = ((struct switch_stack *)p->thread.ksp)->fp;	/* ;dgt2 */
 	do {
diff --git a/arch/openrisc/include/asm/processor.h b/arch/openrisc/include/asm/processor.h
index ad53b31848859..aa1699c18add8 100644
--- a/arch/openrisc/include/asm/processor.h
+++ b/arch/openrisc/include/asm/processor.h
@@ -73,7 +73,7 @@ struct thread_struct {
 
 void start_thread(struct pt_regs *regs, unsigned long nip, unsigned long sp);
 void release_thread(struct task_struct *);
-unsigned long get_wchan(struct task_struct *p);
+unsigned long __get_wchan(struct task_struct *p);
 
 #define cpu_relax()     barrier()
 
diff --git a/arch/openrisc/kernel/process.c b/arch/openrisc/kernel/process.c
index eb62429681fc8..eeea6d54b198c 100644
--- a/arch/openrisc/kernel/process.c
+++ b/arch/openrisc/kernel/process.c
@@ -265,7 +265,7 @@ void dump_elf_thread(elf_greg_t *dest, struct pt_regs* regs)
 	dest[35] = 0;
 }
 
-unsigned long get_wchan(struct task_struct *p)
+unsigned long __get_wchan(struct task_struct *p)
 {
 	/* TODO */
 
diff --git a/arch/parisc/include/asm/processor.h b/arch/parisc/include/asm/processor.h
index b5fbcd2c17808..5e5ceb5b9631f 100644
--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -277,7 +277,7 @@ struct mm_struct;
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
 
-extern unsigned long get_wchan(struct task_struct *p);
+extern unsigned long __get_wchan(struct task_struct *p);
 
 #define KSTK_EIP(tsk)	((tsk)->thread.regs.iaoq[0])
 #define KSTK_ESP(tsk)	((tsk)->thread.regs.gr[30])
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index 184ec3c1eae44..05e89d4fa911a 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -243,15 +243,12 @@ copy_thread(unsigned long clone_flags, unsigned long usp,
 }
 
 unsigned long
-get_wchan(struct task_struct *p)
+__get_wchan(struct task_struct *p)
 {
 	struct unwind_frame_info info;
 	unsigned long ip;
 	int count = 0;
 
-	if (!p || p == current || task_is_running(p))
-		return 0;
-
 	/*
 	 * These bracket the sleeping functions..
 	 */
diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index f348e564f7dd5..e39bd0ff69f3a 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -300,7 +300,7 @@ struct thread_struct {
 
 #define task_pt_regs(tsk)	((tsk)->thread.regs)
 
-unsigned long get_wchan(struct task_struct *p);
+unsigned long __get_wchan(struct task_struct *p);
 
 #define KSTK_EIP(tsk)  ((tsk)->thread.regs? (tsk)->thread.regs->nip: 0)
 #define KSTK_ESP(tsk)  ((tsk)->thread.regs? (tsk)->thread.regs->gpr[1]: 0)
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 185beb2905801..247ef0b9bfa4e 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -2111,14 +2111,11 @@ int validate_sp(unsigned long sp, struct task_struct *p,
 
 EXPORT_SYMBOL(validate_sp);
 
-static unsigned long __get_wchan(struct task_struct *p)
+static unsigned long ___get_wchan(struct task_struct *p)
 {
 	unsigned long ip, sp;
 	int count = 0;
 
-	if (!p || p == current || task_is_running(p))
-		return 0;
-
 	sp = p->thread.ksp;
 	if (!validate_sp(sp, p, STACK_FRAME_OVERHEAD))
 		return 0;
@@ -2137,14 +2134,14 @@ static unsigned long __get_wchan(struct task_struct *p)
 	return 0;
 }
 
-unsigned long get_wchan(struct task_struct *p)
+unsigned long __get_wchan(struct task_struct *p)
 {
 	unsigned long ret;
 
 	if (!try_get_task_stack(p))
 		return 0;
 
-	ret = __get_wchan(p);
+	ret = ___get_wchan(p);
 
 	put_task_stack(p);
 
diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/processor.h
index 021ed64ee608f..086821b44def1 100644
--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -58,7 +58,7 @@ static inline void release_thread(struct task_struct *dead_task)
 {
 }
 
-extern unsigned long get_wchan(struct task_struct *p);
+extern unsigned long __get_wchan(struct task_struct *p);
 
 
 static inline void wait_for_interrupt(void)
diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 315db3d0229bf..0fcdc0233faca 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -128,16 +128,14 @@ static bool save_wchan(void *arg, unsigned long pc)
 	return true;
 }
 
-unsigned long get_wchan(struct task_struct *task)
+unsigned long __get_wchan(struct task_struct *task)
 {
 	unsigned long pc = 0;
 
-	if (likely(task && task != current && !task_is_running(task))) {
-		if (!try_get_task_stack(task))
-			return 0;
-		walk_stackframe(task, NULL, save_wchan, &pc);
-		put_task_stack(task);
-	}
+	if (!try_get_task_stack(task))
+		return 0;
+	walk_stackframe(task, NULL, save_wchan, &pc);
+	put_task_stack(task);
 	return pc;
 }
 
diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index 879b8e3f609cd..f54c152bf2bf9 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -192,7 +192,7 @@ static inline void release_thread(struct task_struct *tsk) { }
 void guarded_storage_release(struct task_struct *tsk);
 void gs_load_bc_cb(struct pt_regs *regs);
 
-unsigned long get_wchan(struct task_struct *p);
+unsigned long __get_wchan(struct task_struct *p);
 #define task_pt_regs(tsk) ((struct pt_regs *) \
         (task_stack_page(tsk) + THREAD_SIZE) - 1)
 #define KSTK_EIP(tsk)	(task_pt_regs(tsk)->psw.addr)
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 350e94d0cac23..e5dd46b1bff8c 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -181,12 +181,12 @@ void execve_tail(void)
 	asm volatile("sfpc %0" : : "d" (0));
 }
 
-unsigned long get_wchan(struct task_struct *p)
+unsigned long __get_wchan(struct task_struct *p)
 {
 	struct unwind_state state;
 	unsigned long ip = 0;
 
-	if (!p || p == current || task_is_running(p) || !task_stack_page(p))
+	if (!task_stack_page(p))
 		return 0;
 
 	if (!try_get_task_stack(p))
diff --git a/arch/sh/include/asm/processor_32.h b/arch/sh/include/asm/processor_32.h
index aa92cc933889d..45240ec6b85a4 100644
--- a/arch/sh/include/asm/processor_32.h
+++ b/arch/sh/include/asm/processor_32.h
@@ -180,7 +180,7 @@ static inline void show_code(struct pt_regs *regs)
 }
 #endif
 
-extern unsigned long get_wchan(struct task_struct *p);
+extern unsigned long __get_wchan(struct task_struct *p);
 
 #define KSTK_EIP(tsk)  (task_pt_regs(tsk)->pc)
 #define KSTK_ESP(tsk)  (task_pt_regs(tsk)->regs[15])
diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
index 717de05c81f49..1c28e3cddb60d 100644
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -182,13 +182,10 @@ __switch_to(struct task_struct *prev, struct task_struct *next)
 	return prev;
 }
 
-unsigned long get_wchan(struct task_struct *p)
+unsigned long __get_wchan(struct task_struct *p)
 {
 	unsigned long pc;
 
-	if (!p || p == current || task_is_running(p))
-		return 0;
-
 	/*
 	 * The same comment as on the Alpha applies here, too ...
 	 */
diff --git a/arch/sparc/include/asm/processor_32.h b/arch/sparc/include/asm/processor_32.h
index b6242f7771e9e..647bf0ac7beb9 100644
--- a/arch/sparc/include/asm/processor_32.h
+++ b/arch/sparc/include/asm/processor_32.h
@@ -89,7 +89,7 @@ static inline void start_thread(struct pt_regs * regs, unsigned long pc,
 /* Free all resources held by a thread. */
 #define release_thread(tsk)		do { } while(0)
 
-unsigned long get_wchan(struct task_struct *);
+unsigned long __get_wchan(struct task_struct *);
 
 #define task_pt_regs(tsk) ((tsk)->thread.kregs)
 #define KSTK_EIP(tsk)  ((tsk)->thread.kregs->pc)
diff --git a/arch/sparc/include/asm/processor_64.h b/arch/sparc/include/asm/processor_64.h
index 5cf145f18f36b..ae851e8fce4c9 100644
--- a/arch/sparc/include/asm/processor_64.h
+++ b/arch/sparc/include/asm/processor_64.h
@@ -183,7 +183,7 @@ do { \
 /* Free all resources held by a thread. */
 #define release_thread(tsk)		do { } while (0)
 
-unsigned long get_wchan(struct task_struct *task);
+unsigned long __get_wchan(struct task_struct *task);
 
 #define task_pt_regs(tsk) (task_thread_info(tsk)->kregs)
 #define KSTK_EIP(tsk)  (task_pt_regs(tsk)->tpc)
diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
index 93983d6d431de..29a2f396f8601 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -368,7 +368,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
 	return 0;
 }
 
-unsigned long get_wchan(struct task_struct *task)
+unsigned long __get_wchan(struct task_struct *task)
 {
 	unsigned long pc, fp, bias = 0;
 	unsigned long task_base = (unsigned long) task;
@@ -376,9 +376,6 @@ unsigned long get_wchan(struct task_struct *task)
 	struct reg_window32 *rw;
 	int count = 0;
 
-	if (!task || task == current || task_is_running(task))
-		goto out;
-
 	fp = task_thread_info(task)->ksp + bias;
 	do {
 		/* Bogus frame pointer? */
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index d33c58a58d4ff..fa8db86e561c7 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -666,7 +666,7 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 	return 0;
 }
 
-unsigned long get_wchan(struct task_struct *task)
+unsigned long __get_wchan(struct task_struct *task)
 {
 	unsigned long pc, fp, bias = 0;
 	struct thread_info *tp;
@@ -674,9 +674,6 @@ unsigned long get_wchan(struct task_struct *task)
         unsigned long ret = 0;
 	int count = 0; 
 
-	if (!task || task == current || task_is_running(task))
-		goto out;
-
 	tp = task_thread_info(task);
 	bias = STACK_BIAS;
 	fp = task_thread_info(task)->ksp + bias;
diff --git a/arch/um/include/asm/processor-generic.h b/arch/um/include/asm/processor-generic.h
index b5cf0ed116d9e..579692a40a556 100644
--- a/arch/um/include/asm/processor-generic.h
+++ b/arch/um/include/asm/processor-generic.h
@@ -106,6 +106,6 @@ extern struct cpuinfo_um boot_cpu_data;
 #define cache_line_size()	(boot_cpu_data.cache_alignment)
 
 #define KSTK_REG(tsk, reg) get_thread_reg(reg, &tsk->thread.switch_buf)
-extern unsigned long get_wchan(struct task_struct *p);
+extern unsigned long __get_wchan(struct task_struct *p);
 
 #endif
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 457a38db368b7..82107373ac7e9 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -364,14 +364,11 @@ unsigned long arch_align_stack(unsigned long sp)
 }
 #endif
 
-unsigned long get_wchan(struct task_struct *p)
+unsigned long __get_wchan(struct task_struct *p)
 {
 	unsigned long stack_page, sp, ip;
 	bool seen_sched = 0;
 
-	if ((p == NULL) || (p == current) || task_is_running(p))
-		return 0;
-
 	stack_page = (unsigned long) task_stack_page(p);
 	/* Bail if the process has no kernel stack for some reason */
 	if (stack_page == 0)
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index d2c11378c7832..6f9ed2e800f21 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -588,7 +588,7 @@ static inline void load_sp0(unsigned long sp0)
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
 
-unsigned long get_wchan(struct task_struct *p);
+unsigned long __get_wchan(struct task_struct *p);
 
 /*
  * Generic CPUID function
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index cd426c3283ee1..266962547b58c 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -943,13 +943,10 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)
  * because the task might wake up and we might look at a stack
  * changing under us.
  */
-unsigned long get_wchan(struct task_struct *p)
+unsigned long __get_wchan(struct task_struct *p)
 {
 	unsigned long entry = 0;
 
-	if (p == current || task_is_running(p))
-		return 0;
-
 	stack_trace_save_tsk(p, &entry, 1, 0);
 	return entry;
 }
diff --git a/arch/xtensa/include/asm/processor.h b/arch/xtensa/include/asm/processor.h
index 7f63aca6a0d34..ad15fbc572838 100644
--- a/arch/xtensa/include/asm/processor.h
+++ b/arch/xtensa/include/asm/processor.h
@@ -215,7 +215,7 @@ struct mm_struct;
 /* Free all resources held by a thread. */
 #define release_thread(thread) do { } while(0)
 
-extern unsigned long get_wchan(struct task_struct *p);
+extern unsigned long __get_wchan(struct task_struct *p);
 
 #define KSTK_EIP(tsk)		(task_pt_regs(tsk)->pc)
 #define KSTK_ESP(tsk)		(task_pt_regs(tsk)->areg[1])
diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
index 0601653406123..47f933fed8700 100644
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -298,15 +298,12 @@ int copy_thread(unsigned long clone_flags, unsigned long usp_thread_fn,
  * These bracket the sleeping functions..
  */
 
-unsigned long get_wchan(struct task_struct *p)
+unsigned long __get_wchan(struct task_struct *p)
 {
 	unsigned long sp, pc;
 	unsigned long stack_page = (unsigned long) task_stack_page(p);
 	int count = 0;
 
-	if (!p || p == current || task_is_running(p))
-		return 0;
-
 	sp = p->thread.sp;
 	pc = MAKE_PC_FROM_RA(p->thread.ra, p->thread.sp);
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8e10c7accdbcc..4ee118cf06971 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2030,6 +2030,7 @@ static inline void set_task_cpu(struct task_struct *p, unsigned int cpu)
 #endif /* CONFIG_SMP */
 
 extern bool sched_task_on_rq(struct task_struct *p);
+extern unsigned long get_wchan(struct task_struct *p);
 
 /*
  * In order to reduce various lock holder preemption latencies provide an
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9289da7f0ac4a..5ea5b6d8b2a94 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1960,6 +1960,25 @@ bool sched_task_on_rq(struct task_struct *p)
 	return task_on_rq_queued(p);
 }
 
+unsigned long get_wchan(struct task_struct *p)
+{
+	unsigned long ip = 0;
+	unsigned int state;
+
+	if (!p || p == current)
+		return 0;
+
+	/* Only get wchan if task is blocked and we can keep it that way. */
+	raw_spin_lock_irq(&p->pi_lock);
+	state = READ_ONCE(p->__state);
+	smp_rmb(); /* see try_to_wake_up() */
+	if (state != TASK_RUNNING && state != TASK_WAKING && !p->on_rq)
+		ip = __get_wchan(p);
+	raw_spin_unlock_irq(&p->pi_lock);
+
+	return ip;
+}
+
 static inline void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (!(flags & ENQUEUE_NOCLOCK))
-- 
2.33.0



