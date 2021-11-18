Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4902D455D40
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 15:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhKROGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 09:06:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232011AbhKROGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 09:06:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17AD461AE3;
        Thu, 18 Nov 2021 14:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637244218;
        bh=5JmjA0BfbAVuXMYud8lAkIh8XP7L+aVSuIS1djvzb6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3yTsixKHdHKnQjG5n8rVzqyTStJQ5O4Ogk/pufT3PbT/8QDSj9V8JTvUXk125XSf
         lEPx0UKFTZHKUzDvg4YrY+JduudhA93o/+0GG4zVi3j+0A6MK049JjL1X8FbSCKNWx
         PmLio0b0SlqZclnzjJgEqcB4wy9cIbaBltNyuRms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.14.20
Date:   Thu, 18 Nov 2021 15:03:27 +0100
Message-Id: <1637244207102123@kroah.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <1637244207253142@kroah.com>
References: <1637244207253142@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index f4773aee95c4..0e14a3a30d07 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 14
-SUBLEVEL = 19
+SUBLEVEL = 20
 EXTRAVERSION =
 NAME = Opossums on Parade
 
diff --git a/arch/alpha/include/asm/processor.h b/arch/alpha/include/asm/processor.h
index 090499c99c1c..6100431da07a 100644
--- a/arch/alpha/include/asm/processor.h
+++ b/arch/alpha/include/asm/processor.h
@@ -42,7 +42,7 @@ extern void start_thread(struct pt_regs *, unsigned long, unsigned long);
 struct task_struct;
 extern void release_thread(struct task_struct *);
 
-unsigned long __get_wchan(struct task_struct *p);
+unsigned long get_wchan(struct task_struct *p);
 
 #define KSTK_EIP(tsk) (task_pt_regs(tsk)->pc)
 
diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 5f8527081da9..a5123ea426ce 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -376,11 +376,12 @@ thread_saved_pc(struct task_struct *t)
 }
 
 unsigned long
-__get_wchan(struct task_struct *p)
+get_wchan(struct task_struct *p)
 {
 	unsigned long schedule_frame;
 	unsigned long pc;
-
+	if (!p || p == current || task_is_running(p))
+		return 0;
 	/*
 	 * This one depends on the frame size of schedule().  Do a
 	 * "disass schedule" in gdb to find the frame size.  Also, the
diff --git a/arch/arc/include/asm/processor.h b/arch/arc/include/asm/processor.h
index 04a5268e592b..e4031ecd3c8c 100644
--- a/arch/arc/include/asm/processor.h
+++ b/arch/arc/include/asm/processor.h
@@ -70,7 +70,7 @@ struct task_struct;
 extern void start_thread(struct pt_regs * regs, unsigned long pc,
 			 unsigned long usp);
 
-extern unsigned int __get_wchan(struct task_struct *p);
+extern unsigned int get_wchan(struct task_struct *p);
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/arc/kernel/stacktrace.c b/arch/arc/kernel/stacktrace.c
index db96cc878389..1b9576d21e24 100644
--- a/arch/arc/kernel/stacktrace.c
+++ b/arch/arc/kernel/stacktrace.c
@@ -15,7 +15,7 @@
  *      = specifics of data structs where trace is saved(CONFIG_STACKTRACE etc)
  *
  *  vineetg: March 2009
- *  -Implemented correct versions of thread_saved_pc() and __get_wchan()
+ *  -Implemented correct versions of thread_saved_pc() and get_wchan()
  *
  *  rajeshwarr: 2008
  *  -Initial implementation
@@ -248,7 +248,7 @@ void show_stack(struct task_struct *tsk, unsigned long *sp, const char *loglvl)
  * Of course just returning schedule( ) would be pointless so unwind until
  * the function is not in schedular code
  */
-unsigned int __get_wchan(struct task_struct *tsk)
+unsigned int get_wchan(struct task_struct *tsk)
 {
 	return arc_unwind_core(tsk, NULL, __get_first_nonsched, NULL);
 }
diff --git a/arch/arm/include/asm/processor.h b/arch/arm/include/asm/processor.h
index 6af68edfa53a..9e6b97286307 100644
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -84,7 +84,7 @@ struct task_struct;
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
 
-unsigned long __get_wchan(struct task_struct *p);
+unsigned long get_wchan(struct task_struct *p);
 
 #define task_pt_regs(p) \
 	((struct pt_regs *)(THREAD_START_SP + task_stack_page(p)) - 1)
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 261be96fa0c3..fc9e8b37eaa8 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -283,11 +283,13 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	return 0;
 }
 
-unsigned long __get_wchan(struct task_struct *p)
+unsigned long get_wchan(struct task_struct *p)
 {
 	struct stackframe frame;
 	unsigned long stack_page;
 	int count = 0;
+	if (!p || p == current || task_is_running(p))
+		return 0;
 
 	frame.fp = thread_saved_fp(p);
 	frame.sp = thread_saved_sp(p);
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 922355eb7eef..b6517fd03d7b 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -251,7 +251,7 @@ struct task_struct;
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
 
-unsigned long __get_wchan(struct task_struct *p);
+unsigned long get_wchan(struct task_struct *p);
 
 void set_task_sctlr_el1(u64 sctlr);
 
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 46995c972ff5..c858b857c1ec 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -544,11 +544,13 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
 	return last;
 }
 
-unsigned long __get_wchan(struct task_struct *p)
+unsigned long get_wchan(struct task_struct *p)
 {
 	struct stackframe frame;
 	unsigned long stack_page, ret = 0;
 	int count = 0;
+	if (!p || p == current || task_is_running(p))
+		return 0;
 
 	stack_page = (unsigned long)try_get_task_stack(p);
 	if (!stack_page)
diff --git a/arch/csky/include/asm/processor.h b/arch/csky/include/asm/processor.h
index 817dd60ff152..9e933021fe8e 100644
--- a/arch/csky/include/asm/processor.h
+++ b/arch/csky/include/asm/processor.h
@@ -81,7 +81,7 @@ static inline void release_thread(struct task_struct *dead_task)
 
 extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 
-unsigned long __get_wchan(struct task_struct *p);
+unsigned long get_wchan(struct task_struct *p);
 
 #define KSTK_EIP(tsk)		(task_pt_regs(tsk)->pc)
 #define KSTK_ESP(tsk)		(task_pt_regs(tsk)->usp)
diff --git a/arch/csky/kernel/stacktrace.c b/arch/csky/kernel/stacktrace.c
index 9f78f5d21511..1b280ef08004 100644
--- a/arch/csky/kernel/stacktrace.c
+++ b/arch/csky/kernel/stacktrace.c
@@ -111,11 +111,12 @@ static bool save_wchan(unsigned long pc, void *arg)
 	return false;
 }
 
-unsigned long __get_wchan(struct task_struct *task)
+unsigned long get_wchan(struct task_struct *task)
 {
 	unsigned long pc = 0;
 
-	walk_stackframe(task, NULL, save_wchan, &pc);
+	if (likely(task && task != current && !task_is_running(task)))
+		walk_stackframe(task, NULL, save_wchan, &pc);
 	return pc;
 }
 
diff --git a/arch/h8300/include/asm/processor.h b/arch/h8300/include/asm/processor.h
index 141a23eb62b7..a060b41b2d31 100644
--- a/arch/h8300/include/asm/processor.h
+++ b/arch/h8300/include/asm/processor.h
@@ -105,7 +105,7 @@ static inline void release_thread(struct task_struct *dead_task)
 {
 }
 
-unsigned long __get_wchan(struct task_struct *p);
+unsigned long get_wchan(struct task_struct *p);
 
 #define	KSTK_EIP(tsk)	\
 	({			 \
diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index 8833fa4f5d51..2ac27e4248a4 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -128,12 +128,15 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
 	return 0;
 }
 
-unsigned long __get_wchan(struct task_struct *p)
+unsigned long get_wchan(struct task_struct *p)
 {
 	unsigned long fp, pc;
 	unsigned long stack_page;
 	int count = 0;
 
+	if (!p || p == current || task_is_running(p))
+		return 0;
+
 	stack_page = (unsigned long)p;
 	fp = ((struct pt_regs *)p->thread.ksp)->er6;
 	do {
diff --git a/arch/hexagon/include/asm/processor.h b/arch/hexagon/include/asm/processor.h
index 615f7e49968e..9f0cc99420be 100644
--- a/arch/hexagon/include/asm/processor.h
+++ b/arch/hexagon/include/asm/processor.h
@@ -64,7 +64,7 @@ struct thread_struct {
 extern void release_thread(struct task_struct *dead_task);
 
 /* Get wait channel for task P.  */
-extern unsigned long __get_wchan(struct task_struct *p);
+extern unsigned long get_wchan(struct task_struct *p);
 
 /*  The following stuff is pretty HEXAGON specific.  */
 
diff --git a/arch/hexagon/kernel/process.c b/arch/hexagon/kernel/process.c
index 232dfd8956aa..6a6835fb4242 100644
--- a/arch/hexagon/kernel/process.c
+++ b/arch/hexagon/kernel/process.c
@@ -130,11 +130,13 @@ void flush_thread(void)
  * is an identification of the point at which the scheduler
  * was invoked by a blocked thread.
  */
-unsigned long __get_wchan(struct task_struct *p)
+unsigned long get_wchan(struct task_struct *p)
 {
 	unsigned long fp, pc;
 	unsigned long stack_page;
 	int count = 0;
+	if (!p || p == current || task_is_running(p))
+		return 0;
 
 	stack_page = (unsigned long)task_stack_page(p);
 	fp = ((struct hexagon_switch_stack *)p->thread.switch_sp)->fp;
diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index 45365c2ef598..2d8bcdc27d7f 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -330,7 +330,7 @@ struct task_struct;
 #define release_thread(dead_task)
 
 /* Get wait channel for task P.  */
-extern unsigned long __get_wchan (struct task_struct *p);
+extern unsigned long get_wchan (struct task_struct *p);
 
 /* Return instruction pointer of blocked task TSK.  */
 #define KSTK_EIP(tsk)					\
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 834df24a88f1..e56d63f4abf9 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -523,12 +523,15 @@ exit_thread (struct task_struct *tsk)
 }
 
 unsigned long
-__get_wchan (struct task_struct *p)
+get_wchan (struct task_struct *p)
 {
 	struct unw_frame_info info;
 	unsigned long ip;
 	int count = 0;
 
+	if (!p || p == current || task_is_running(p))
+		return 0;
+
 	/*
 	 * Note: p may not be a blocked task (it could be current or
 	 * another process running on some other CPU.  Rather than
diff --git a/arch/m68k/include/asm/processor.h b/arch/m68k/include/asm/processor.h
index bacec548cb3c..3750819ac5a1 100644
--- a/arch/m68k/include/asm/processor.h
+++ b/arch/m68k/include/asm/processor.h
@@ -125,7 +125,7 @@ static inline void release_thread(struct task_struct *dead_task)
 {
 }
 
-unsigned long __get_wchan(struct task_struct *p);
+unsigned long get_wchan(struct task_struct *p);
 
 #define	KSTK_EIP(tsk)	\
     ({			\
diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index d2357cba09ab..db49f9091711 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -263,11 +263,13 @@ int dump_fpu (struct pt_regs *regs, struct user_m68kfp_struct *fpu)
 }
 EXPORT_SYMBOL(dump_fpu);
 
-unsigned long __get_wchan(struct task_struct *p)
+unsigned long get_wchan(struct task_struct *p)
 {
 	unsigned long fp, pc;
 	unsigned long stack_page;
 	int count = 0;
+	if (!p || p == current || task_is_running(p))
+		return 0;
 
 	stack_page = (unsigned long)task_stack_page(p);
 	fp = ((struct switch_stack *)p->thread.ksp)->a6;
diff --git a/arch/microblaze/include/asm/processor.h b/arch/microblaze/include/asm/processor.h
index 7e9e92670df3..06c6e493590a 100644
--- a/arch/microblaze/include/asm/processor.h
+++ b/arch/microblaze/include/asm/processor.h
@@ -68,7 +68,7 @@ static inline void release_thread(struct task_struct *dead_task)
 {
 }
 
-unsigned long __get_wchan(struct task_struct *p);
+unsigned long get_wchan(struct task_struct *p);
 
 /* The size allocated for kernel stacks. This _must_ be a power of two! */
 # define KERNEL_STACK_SIZE	0x2000
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 5e2b91c1e8ce..62aa237180b6 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -112,7 +112,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp, unsigned long arg,
 	return 0;
 }
 
-unsigned long __get_wchan(struct task_struct *p)
+unsigned long get_wchan(struct task_struct *p)
 {
 /* TBD (used by procfs) */
 	return 0;
diff --git a/arch/mips/include/asm/processor.h b/arch/mips/include/asm/processor.h
index 252ed38ce8c5..0c3550c82b72 100644
--- a/arch/mips/include/asm/processor.h
+++ b/arch/mips/include/asm/processor.h
@@ -369,7 +369,7 @@ static inline void flush_thread(void)
 {
 }
 
-unsigned long __get_wchan(struct task_struct *p);
+unsigned long get_wchan(struct task_struct *p);
 
 #define __KSTK_TOS(tsk) ((unsigned long)task_stack_page(tsk) + \
 			 THREAD_SIZE - 32 - sizeof(struct pt_regs))
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 637e6207e350..73c8e7990a97 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -511,7 +511,7 @@ static int __init frame_info_init(void)
 
 	/*
 	 * Without schedule() frame info, result given by
-	 * thread_saved_pc() and __get_wchan() are not reliable.
+	 * thread_saved_pc() and get_wchan() are not reliable.
 	 */
 	if (schedule_mfi.pc_offset < 0)
 		printk("Can't analyze schedule() prologue at %p\n", schedule);
@@ -652,9 +652,9 @@ unsigned long unwind_stack(struct task_struct *task, unsigned long *sp,
 #endif
 
 /*
- * __get_wchan - a maintenance nightmare^W^Wpain in the ass ...
+ * get_wchan - a maintenance nightmare^W^Wpain in the ass ...
  */
-unsigned long __get_wchan(struct task_struct *task)
+unsigned long get_wchan(struct task_struct *task)
 {
 	unsigned long pc = 0;
 #ifdef CONFIG_KALLSYMS
@@ -662,6 +662,8 @@ unsigned long __get_wchan(struct task_struct *task)
 	unsigned long ra = 0;
 #endif
 
+	if (!task || task == current || task_is_running(task))
+		goto out;
 	if (!task_stack_page(task))
 		goto out;
 
diff --git a/arch/nds32/include/asm/processor.h b/arch/nds32/include/asm/processor.h
index e6bfc74972bb..b82369c7659d 100644
--- a/arch/nds32/include/asm/processor.h
+++ b/arch/nds32/include/asm/processor.h
@@ -83,7 +83,7 @@ extern struct task_struct *last_task_used_math;
 /* Prepare to copy thread state - unlazy all lazy status */
 #define prepare_to_copy(tsk)	do { } while (0)
 
-unsigned long __get_wchan(struct task_struct *p);
+unsigned long get_wchan(struct task_struct *p);
 
 #define cpu_relax()			barrier()
 
diff --git a/arch/nds32/kernel/process.c b/arch/nds32/kernel/process.c
index 49fab9e39cbf..391895b54d13 100644
--- a/arch/nds32/kernel/process.c
+++ b/arch/nds32/kernel/process.c
@@ -233,12 +233,15 @@ int dump_fpu(struct pt_regs *regs, elf_fpregset_t * fpu)
 
 EXPORT_SYMBOL(dump_fpu);
 
-unsigned long __get_wchan(struct task_struct *p)
+unsigned long get_wchan(struct task_struct *p)
 {
 	unsigned long fp, lr;
 	unsigned long stack_start, stack_end;
 	int count = 0;
 
+	if (!p || p == current || task_is_running(p))
+		return 0;
+
 	if (IS_ENABLED(CONFIG_FRAME_POINTER)) {
 		stack_start = (unsigned long)end_of_stack(p);
 		stack_end = (unsigned long)task_stack_page(p) + THREAD_SIZE;
@@ -255,3 +258,5 @@ unsigned long __get_wchan(struct task_struct *p)
 	}
 	return 0;
 }
+
+EXPORT_SYMBOL(get_wchan);
diff --git a/arch/nios2/include/asm/processor.h b/arch/nios2/include/asm/processor.h
index b8125dfbcad2..94bcb86f679f 100644
--- a/arch/nios2/include/asm/processor.h
+++ b/arch/nios2/include/asm/processor.h
@@ -69,7 +69,7 @@ static inline void release_thread(struct task_struct *dead_task)
 {
 }
 
-extern unsigned long __get_wchan(struct task_struct *p);
+extern unsigned long get_wchan(struct task_struct *p);
 
 #define task_pt_regs(p) \
 	((struct pt_regs *)(THREAD_SIZE + task_stack_page(p)) - 1)
diff --git a/arch/nios2/kernel/process.c b/arch/nios2/kernel/process.c
index f8ea522a1588..9ff37ba2bb60 100644
--- a/arch/nios2/kernel/process.c
+++ b/arch/nios2/kernel/process.c
@@ -217,12 +217,15 @@ void dump(struct pt_regs *fp)
 	pr_emerg("\n\n");
 }
 
-unsigned long __get_wchan(struct task_struct *p)
+unsigned long get_wchan(struct task_struct *p)
 {
 	unsigned long fp, pc;
 	unsigned long stack_page;
 	int count = 0;
 
+	if (!p || p == current || task_is_running(p))
+		return 0;
+
 	stack_page = (unsigned long)p;
 	fp = ((struct switch_stack *)p->thread.ksp)->fp;	/* ;dgt2 */
 	do {
diff --git a/arch/openrisc/include/asm/processor.h b/arch/openrisc/include/asm/processor.h
index aa1699c18add..ad53b3184885 100644
--- a/arch/openrisc/include/asm/processor.h
+++ b/arch/openrisc/include/asm/processor.h
@@ -73,7 +73,7 @@ struct thread_struct {
 
 void start_thread(struct pt_regs *regs, unsigned long nip, unsigned long sp);
 void release_thread(struct task_struct *);
-unsigned long __get_wchan(struct task_struct *p);
+unsigned long get_wchan(struct task_struct *p);
 
 #define cpu_relax()     barrier()
 
diff --git a/arch/openrisc/kernel/process.c b/arch/openrisc/kernel/process.c
index eeea6d54b198..eb62429681fc 100644
--- a/arch/openrisc/kernel/process.c
+++ b/arch/openrisc/kernel/process.c
@@ -265,7 +265,7 @@ void dump_elf_thread(elf_greg_t *dest, struct pt_regs* regs)
 	dest[35] = 0;
 }
 
-unsigned long __get_wchan(struct task_struct *p)
+unsigned long get_wchan(struct task_struct *p)
 {
 	/* TODO */
 
diff --git a/arch/parisc/include/asm/processor.h b/arch/parisc/include/asm/processor.h
index 5e5ceb5b9631..b5fbcd2c1780 100644
--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -277,7 +277,7 @@ struct mm_struct;
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
 
-extern unsigned long __get_wchan(struct task_struct *p);
+extern unsigned long get_wchan(struct task_struct *p);
 
 #define KSTK_EIP(tsk)	((tsk)->thread.regs.iaoq[0])
 #define KSTK_ESP(tsk)	((tsk)->thread.regs.gr[30])
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index 05e89d4fa911..184ec3c1eae4 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -243,12 +243,15 @@ copy_thread(unsigned long clone_flags, unsigned long usp,
 }
 
 unsigned long
-__get_wchan(struct task_struct *p)
+get_wchan(struct task_struct *p)
 {
 	struct unwind_frame_info info;
 	unsigned long ip;
 	int count = 0;
 
+	if (!p || p == current || task_is_running(p))
+		return 0;
+
 	/*
 	 * These bracket the sleeping functions..
 	 */
diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index e39bd0ff69f3..f348e564f7dd 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -300,7 +300,7 @@ struct thread_struct {
 
 #define task_pt_regs(tsk)	((tsk)->thread.regs)
 
-unsigned long __get_wchan(struct task_struct *p);
+unsigned long get_wchan(struct task_struct *p);
 
 #define KSTK_EIP(tsk)  ((tsk)->thread.regs? (tsk)->thread.regs->nip: 0)
 #define KSTK_ESP(tsk)  ((tsk)->thread.regs? (tsk)->thread.regs->gpr[1]: 0)
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 247ef0b9bfa4..185beb290580 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -2111,11 +2111,14 @@ int validate_sp(unsigned long sp, struct task_struct *p,
 
 EXPORT_SYMBOL(validate_sp);
 
-static unsigned long ___get_wchan(struct task_struct *p)
+static unsigned long __get_wchan(struct task_struct *p)
 {
 	unsigned long ip, sp;
 	int count = 0;
 
+	if (!p || p == current || task_is_running(p))
+		return 0;
+
 	sp = p->thread.ksp;
 	if (!validate_sp(sp, p, STACK_FRAME_OVERHEAD))
 		return 0;
@@ -2134,14 +2137,14 @@ static unsigned long ___get_wchan(struct task_struct *p)
 	return 0;
 }
 
-unsigned long __get_wchan(struct task_struct *p)
+unsigned long get_wchan(struct task_struct *p)
 {
 	unsigned long ret;
 
 	if (!try_get_task_stack(p))
 		return 0;
 
-	ret = ___get_wchan(p);
+	ret = __get_wchan(p);
 
 	put_task_stack(p);
 
diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/processor.h
index 086821b44def..021ed64ee608 100644
--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -58,7 +58,7 @@ static inline void release_thread(struct task_struct *dead_task)
 {
 }
 
-extern unsigned long __get_wchan(struct task_struct *p);
+extern unsigned long get_wchan(struct task_struct *p);
 
 
 static inline void wait_for_interrupt(void)
diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 0fcdc0233fac..315db3d0229b 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -128,14 +128,16 @@ static bool save_wchan(void *arg, unsigned long pc)
 	return true;
 }
 
-unsigned long __get_wchan(struct task_struct *task)
+unsigned long get_wchan(struct task_struct *task)
 {
 	unsigned long pc = 0;
 
-	if (!try_get_task_stack(task))
-		return 0;
-	walk_stackframe(task, NULL, save_wchan, &pc);
-	put_task_stack(task);
+	if (likely(task && task != current && !task_is_running(task))) {
+		if (!try_get_task_stack(task))
+			return 0;
+		walk_stackframe(task, NULL, save_wchan, &pc);
+		put_task_stack(task);
+	}
 	return pc;
 }
 
diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index f54c152bf2bf..879b8e3f609c 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -192,7 +192,7 @@ static inline void release_thread(struct task_struct *tsk) { }
 void guarded_storage_release(struct task_struct *tsk);
 void gs_load_bc_cb(struct pt_regs *regs);
 
-unsigned long __get_wchan(struct task_struct *p);
+unsigned long get_wchan(struct task_struct *p);
 #define task_pt_regs(tsk) ((struct pt_regs *) \
         (task_stack_page(tsk) + THREAD_SIZE) - 1)
 #define KSTK_EIP(tsk)	(task_pt_regs(tsk)->psw.addr)
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index e5dd46b1bff8..350e94d0cac2 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -181,12 +181,12 @@ void execve_tail(void)
 	asm volatile("sfpc %0" : : "d" (0));
 }
 
-unsigned long __get_wchan(struct task_struct *p)
+unsigned long get_wchan(struct task_struct *p)
 {
 	struct unwind_state state;
 	unsigned long ip = 0;
 
-	if (!task_stack_page(p))
+	if (!p || p == current || task_is_running(p) || !task_stack_page(p))
 		return 0;
 
 	if (!try_get_task_stack(p))
diff --git a/arch/sh/include/asm/processor_32.h b/arch/sh/include/asm/processor_32.h
index 45240ec6b85a..aa92cc933889 100644
--- a/arch/sh/include/asm/processor_32.h
+++ b/arch/sh/include/asm/processor_32.h
@@ -180,7 +180,7 @@ static inline void show_code(struct pt_regs *regs)
 }
 #endif
 
-extern unsigned long __get_wchan(struct task_struct *p);
+extern unsigned long get_wchan(struct task_struct *p);
 
 #define KSTK_EIP(tsk)  (task_pt_regs(tsk)->pc)
 #define KSTK_ESP(tsk)  (task_pt_regs(tsk)->regs[15])
diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
index 1c28e3cddb60..717de05c81f4 100644
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -182,10 +182,13 @@ __switch_to(struct task_struct *prev, struct task_struct *next)
 	return prev;
 }
 
-unsigned long __get_wchan(struct task_struct *p)
+unsigned long get_wchan(struct task_struct *p)
 {
 	unsigned long pc;
 
+	if (!p || p == current || task_is_running(p))
+		return 0;
+
 	/*
 	 * The same comment as on the Alpha applies here, too ...
 	 */
diff --git a/arch/sparc/include/asm/processor_32.h b/arch/sparc/include/asm/processor_32.h
index 647bf0ac7beb..b6242f7771e9 100644
--- a/arch/sparc/include/asm/processor_32.h
+++ b/arch/sparc/include/asm/processor_32.h
@@ -89,7 +89,7 @@ static inline void start_thread(struct pt_regs * regs, unsigned long pc,
 /* Free all resources held by a thread. */
 #define release_thread(tsk)		do { } while(0)
 
-unsigned long __get_wchan(struct task_struct *);
+unsigned long get_wchan(struct task_struct *);
 
 #define task_pt_regs(tsk) ((tsk)->thread.kregs)
 #define KSTK_EIP(tsk)  ((tsk)->thread.kregs->pc)
diff --git a/arch/sparc/include/asm/processor_64.h b/arch/sparc/include/asm/processor_64.h
index ae851e8fce4c..5cf145f18f36 100644
--- a/arch/sparc/include/asm/processor_64.h
+++ b/arch/sparc/include/asm/processor_64.h
@@ -183,7 +183,7 @@ do { \
 /* Free all resources held by a thread. */
 #define release_thread(tsk)		do { } while (0)
 
-unsigned long __get_wchan(struct task_struct *task);
+unsigned long get_wchan(struct task_struct *task);
 
 #define task_pt_regs(tsk) (task_thread_info(tsk)->kregs)
 #define KSTK_EIP(tsk)  (task_pt_regs(tsk)->tpc)
diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
index 29a2f396f860..93983d6d431d 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -368,7 +368,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
 	return 0;
 }
 
-unsigned long __get_wchan(struct task_struct *task)
+unsigned long get_wchan(struct task_struct *task)
 {
 	unsigned long pc, fp, bias = 0;
 	unsigned long task_base = (unsigned long) task;
@@ -376,6 +376,9 @@ unsigned long __get_wchan(struct task_struct *task)
 	struct reg_window32 *rw;
 	int count = 0;
 
+	if (!task || task == current || task_is_running(task))
+		goto out;
+
 	fp = task_thread_info(task)->ksp + bias;
 	do {
 		/* Bogus frame pointer? */
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index fa8db86e561c..d33c58a58d4f 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -666,7 +666,7 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 	return 0;
 }
 
-unsigned long __get_wchan(struct task_struct *task)
+unsigned long get_wchan(struct task_struct *task)
 {
 	unsigned long pc, fp, bias = 0;
 	struct thread_info *tp;
@@ -674,6 +674,9 @@ unsigned long __get_wchan(struct task_struct *task)
         unsigned long ret = 0;
 	int count = 0; 
 
+	if (!task || task == current || task_is_running(task))
+		goto out;
+
 	tp = task_thread_info(task);
 	bias = STACK_BIAS;
 	fp = task_thread_info(task)->ksp + bias;
diff --git a/arch/um/include/asm/processor-generic.h b/arch/um/include/asm/processor-generic.h
index 579692a40a55..b5cf0ed116d9 100644
--- a/arch/um/include/asm/processor-generic.h
+++ b/arch/um/include/asm/processor-generic.h
@@ -106,6 +106,6 @@ extern struct cpuinfo_um boot_cpu_data;
 #define cache_line_size()	(boot_cpu_data.cache_alignment)
 
 #define KSTK_REG(tsk, reg) get_thread_reg(reg, &tsk->thread.switch_buf)
-extern unsigned long __get_wchan(struct task_struct *p);
+extern unsigned long get_wchan(struct task_struct *p);
 
 #endif
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 82107373ac7e..457a38db368b 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -364,11 +364,14 @@ unsigned long arch_align_stack(unsigned long sp)
 }
 #endif
 
-unsigned long __get_wchan(struct task_struct *p)
+unsigned long get_wchan(struct task_struct *p)
 {
 	unsigned long stack_page, sp, ip;
 	bool seen_sched = 0;
 
+	if ((p == NULL) || (p == current) || task_is_running(p))
+		return 0;
+
 	stack_page = (unsigned long) task_stack_page(p);
 	/* Bail if the process has no kernel stack for some reason */
 	if (stack_page == 0)
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 6f9ed2e800f2..d2c11378c783 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -588,7 +588,7 @@ static inline void load_sp0(unsigned long sp0)
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
 
-unsigned long __get_wchan(struct task_struct *p);
+unsigned long get_wchan(struct task_struct *p);
 
 /*
  * Generic CPUID function
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 2fe1810e922a..f2f733bcb2b9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -43,7 +43,6 @@
 #include <asm/io_bitmap.h>
 #include <asm/proto.h>
 #include <asm/frame.h>
-#include <asm/unwind.h>
 
 #include "process.h"
 
@@ -944,22 +943,60 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)
  * because the task might wake up and we might look at a stack
  * changing under us.
  */
-unsigned long __get_wchan(struct task_struct *p)
+unsigned long get_wchan(struct task_struct *p)
 {
-	struct unwind_state state;
-	unsigned long addr = 0;
+	unsigned long start, bottom, top, sp, fp, ip, ret = 0;
+	int count = 0;
 
-	for (unwind_start(&state, p, NULL, NULL); !unwind_done(&state);
-	     unwind_next_frame(&state)) {
-		addr = unwind_get_return_address(&state);
-		if (!addr)
-			break;
-		if (in_sched_functions(addr))
-			continue;
-		break;
-	}
+	if (p == current || task_is_running(p))
+		return 0;
+
+	if (!try_get_task_stack(p))
+		return 0;
+
+	start = (unsigned long)task_stack_page(p);
+	if (!start)
+		goto out;
+
+	/*
+	 * Layout of the stack page:
+	 *
+	 * ----------- topmax = start + THREAD_SIZE - sizeof(unsigned long)
+	 * PADDING
+	 * ----------- top = topmax - TOP_OF_KERNEL_STACK_PADDING
+	 * stack
+	 * ----------- bottom = start
+	 *
+	 * The tasks stack pointer points at the location where the
+	 * framepointer is stored. The data on the stack is:
+	 * ... IP FP ... IP FP
+	 *
+	 * We need to read FP and IP, so we need to adjust the upper
+	 * bound by another unsigned long.
+	 */
+	top = start + THREAD_SIZE - TOP_OF_KERNEL_STACK_PADDING;
+	top -= 2 * sizeof(unsigned long);
+	bottom = start;
+
+	sp = READ_ONCE(p->thread.sp);
+	if (sp < bottom || sp > top)
+		goto out;
+
+	fp = READ_ONCE_NOCHECK(((struct inactive_task_frame *)sp)->bp);
+	do {
+		if (fp < bottom || fp > top)
+			goto out;
+		ip = READ_ONCE_NOCHECK(*(unsigned long *)(fp + sizeof(unsigned long)));
+		if (!in_sched_functions(ip)) {
+			ret = ip;
+			goto out;
+		}
+		fp = READ_ONCE_NOCHECK(*(unsigned long *)fp);
+	} while (count++ < 16 && !task_is_running(p));
 
-	return addr;
+out:
+	put_task_stack(p);
+	return ret;
 }
 
 long do_arch_prctl_common(struct task_struct *task, int option,
diff --git a/arch/xtensa/include/asm/processor.h b/arch/xtensa/include/asm/processor.h
index ad15fbc57283..7f63aca6a0d3 100644
--- a/arch/xtensa/include/asm/processor.h
+++ b/arch/xtensa/include/asm/processor.h
@@ -215,7 +215,7 @@ struct mm_struct;
 /* Free all resources held by a thread. */
 #define release_thread(thread) do { } while(0)
 
-extern unsigned long __get_wchan(struct task_struct *p);
+extern unsigned long get_wchan(struct task_struct *p);
 
 #define KSTK_EIP(tsk)		(task_pt_regs(tsk)->pc)
 #define KSTK_ESP(tsk)		(task_pt_regs(tsk)->areg[1])
diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
index 47f933fed870..060165340612 100644
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -298,12 +298,15 @@ int copy_thread(unsigned long clone_flags, unsigned long usp_thread_fn,
  * These bracket the sleeping functions..
  */
 
-unsigned long __get_wchan(struct task_struct *p)
+unsigned long get_wchan(struct task_struct *p)
 {
 	unsigned long sp, pc;
 	unsigned long stack_page = (unsigned long) task_stack_page(p);
 	int count = 0;
 
+	if (!p || p == current || task_is_running(p))
+		return 0;
+
 	sp = p->thread.sp;
 	pc = MAKE_PC_FROM_RA(p->thread.ra, p->thread.sp);
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ee118cf0697..8e10c7accdbc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2030,7 +2030,6 @@ static inline void set_task_cpu(struct task_struct *p, unsigned int cpu)
 #endif /* CONFIG_SMP */
 
 extern bool sched_task_on_rq(struct task_struct *p);
-extern unsigned long get_wchan(struct task_struct *p);
 
 /*
  * In order to reduce various lock holder preemption latencies provide an
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5ea5b6d8b2a9..9289da7f0ac4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1960,25 +1960,6 @@ bool sched_task_on_rq(struct task_struct *p)
 	return task_on_rq_queued(p);
 }
 
-unsigned long get_wchan(struct task_struct *p)
-{
-	unsigned long ip = 0;
-	unsigned int state;
-
-	if (!p || p == current)
-		return 0;
-
-	/* Only get wchan if task is blocked and we can keep it that way. */
-	raw_spin_lock_irq(&p->pi_lock);
-	state = READ_ONCE(p->__state);
-	smp_rmb(); /* see try_to_wake_up() */
-	if (state != TASK_RUNNING && state != TASK_WAKING && !p->on_rq)
-		ip = __get_wchan(p);
-	raw_spin_unlock_irq(&p->pi_lock);
-
-	return ip;
-}
-
 static inline void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (!(flags & ENQUEUE_NOCLOCK))
