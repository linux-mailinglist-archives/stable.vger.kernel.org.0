Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB551A5157
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgDKMRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:17:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728357AbgDKMRH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:17:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09B1020644;
        Sat, 11 Apr 2020 12:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607426;
        bh=sOaLMFOL/RchZl07OG3R65rKKk295g6klee+RYJl+Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fh7mG6dF+0VIn8mIFzZ3Ia6REJnC0dpKkx7rT1ml/k21WvM2YMBoexB0d1d4jG45r
         bkS+H5OutcUPGlh/Vbcyjx5uSPMYwiKEvDz4CCO6OF/PaUQCMcxSfkHzFgeL23Qysy
         rV4UjWyrQ88Jl9TBwdb6JycLN707C0MsWx7Vsmwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 15/41] s390: prevent leaking kernel address in BEAR
Date:   Sat, 11 Apr 2020 14:09:24 +0200
Message-Id: <20200411115505.155325655@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115504.124035693@linuxfoundation.org>
References: <20200411115504.124035693@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit 0b38b5e1d0e2f361e418e05c179db05bb688bbd6 upstream.

When userspace executes a syscall or gets interrupted,
BEAR contains a kernel address when returning to userspace.
This make it pretty easy to figure out where the kernel is
mapped even with KASLR enabled. To fix this, add lpswe to
lowcore and always execute it there, so userspace sees only
the lowcore address of lpswe. For this we have to extend
both critical_cleanup and the SWITCH_ASYNC macro to also check
for lpswe addresses in lowcore.

Fixes: b2d24b97b2a9 ("s390/kernel: add support for kernel address space layout randomization (KASLR)")
Cc: <stable@vger.kernel.org> # v5.2+
Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/lowcore.h   |    4 +-
 arch/s390/include/asm/processor.h |    1 
 arch/s390/include/asm/setup.h     |    7 ++++
 arch/s390/kernel/asm-offsets.c    |    2 +
 arch/s390/kernel/entry.S          |   65 ++++++++++++++++++++++----------------
 arch/s390/kernel/process.c        |    1 
 arch/s390/kernel/setup.c          |    3 +
 arch/s390/kernel/smp.c            |    2 +
 arch/s390/mm/vmem.c               |    4 ++
 9 files changed, 62 insertions(+), 27 deletions(-)

--- a/arch/s390/include/asm/lowcore.h
+++ b/arch/s390/include/asm/lowcore.h
@@ -141,7 +141,9 @@ struct lowcore {
 
 	/* br %r1 trampoline */
 	__u16	br_r1_trampoline;		/* 0x0400 */
-	__u8	pad_0x0402[0x0e00-0x0402];	/* 0x0402 */
+	__u32	return_lpswe;			/* 0x0402 */
+	__u32	return_mcck_lpswe;		/* 0x0406 */
+	__u8	pad_0x040a[0x0e00-0x040a];	/* 0x040a */
 
 	/*
 	 * 0xe00 contains the address of the IPL Parameter Information
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -162,6 +162,7 @@ typedef struct thread_struct thread_stru
 #define INIT_THREAD {							\
 	.ksp = sizeof(init_stack) + (unsigned long) &init_stack,	\
 	.fpu.regs = (void *) init_task.thread.fpu.fprs,			\
+	.last_break = 1,						\
 }
 
 /*
--- a/arch/s390/include/asm/setup.h
+++ b/arch/s390/include/asm/setup.h
@@ -8,6 +8,7 @@
 
 #include <linux/bits.h>
 #include <uapi/asm/setup.h>
+#include <linux/build_bug.h>
 
 #define EP_OFFSET		0x10008
 #define EP_STRING		"S390EP"
@@ -157,6 +158,12 @@ static inline unsigned long kaslr_offset
 	return __kaslr_offset;
 }
 
+static inline u32 gen_lpswe(unsigned long addr)
+{
+	BUILD_BUG_ON(addr > 0xfff);
+	return 0xb2b20000 | addr;
+}
+
 #else /* __ASSEMBLY__ */
 
 #define IPL_DEVICE	(IPL_DEVICE_OFFSET)
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -125,6 +125,8 @@ int main(void)
 	OFFSET(__LC_EXT_DAMAGE_CODE, lowcore, external_damage_code);
 	OFFSET(__LC_MCCK_FAIL_STOR_ADDR, lowcore, failing_storage_address);
 	OFFSET(__LC_LAST_BREAK, lowcore, breaking_event_addr);
+	OFFSET(__LC_RETURN_LPSWE, lowcore, return_lpswe);
+	OFFSET(__LC_RETURN_MCCK_LPSWE, lowcore, return_mcck_lpswe);
 	OFFSET(__LC_RST_OLD_PSW, lowcore, restart_old_psw);
 	OFFSET(__LC_EXT_OLD_PSW, lowcore, external_old_psw);
 	OFFSET(__LC_SVC_OLD_PSW, lowcore, svc_old_psw);
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -115,26 +115,29 @@ _LPP_OFFSET	= __LC_LPP
 
 	.macro	SWITCH_ASYNC savearea,timer
 	tmhh	%r8,0x0001		# interrupting from user ?
-	jnz	1f
+	jnz	2f
 	lgr	%r14,%r9
+	cghi	%r14,__LC_RETURN_LPSWE
+	je	0f
 	slg	%r14,BASED(.Lcritical_start)
 	clg	%r14,BASED(.Lcritical_length)
-	jhe	0f
+	jhe	1f
+0:
 	lghi	%r11,\savearea		# inside critical section, do cleanup
 	brasl	%r14,cleanup_critical
 	tmhh	%r8,0x0001		# retest problem state after cleanup
-	jnz	1f
-0:	lg	%r14,__LC_ASYNC_STACK	# are we already on the target stack?
+	jnz	2f
+1:	lg	%r14,__LC_ASYNC_STACK	# are we already on the target stack?
 	slgr	%r14,%r15
 	srag	%r14,%r14,STACK_SHIFT
-	jnz	2f
+	jnz	3f
 	CHECK_STACK \savearea
 	aghi	%r15,-(STACK_FRAME_OVERHEAD + __PT_SIZE)
-	j	3f
-1:	UPDATE_VTIME %r14,%r15,\timer
+	j	4f
+2:	UPDATE_VTIME %r14,%r15,\timer
 	BPENTER __TI_flags(%r12),_TIF_ISOLATE_BP
-2:	lg	%r15,__LC_ASYNC_STACK	# load async stack
-3:	la	%r11,STACK_FRAME_OVERHEAD(%r15)
+3:	lg	%r15,__LC_ASYNC_STACK	# load async stack
+4:	la	%r11,STACK_FRAME_OVERHEAD(%r15)
 	.endm
 
 	.macro UPDATE_VTIME w1,w2,enter_timer
@@ -401,7 +404,7 @@ ENTRY(system_call)
 	stpt	__LC_EXIT_TIMER
 	mvc	__VDSO_ECTG_BASE(16,%r14),__LC_EXIT_TIMER
 	lmg	%r11,%r15,__PT_R11(%r11)
-	lpswe	__LC_RETURN_PSW
+	b	__LC_RETURN_LPSWE(%r0)
 .Lsysc_done:
 
 #
@@ -608,43 +611,50 @@ ENTRY(pgm_check_handler)
 	BPOFF
 	stmg	%r8,%r15,__LC_SAVE_AREA_SYNC
 	lg	%r10,__LC_LAST_BREAK
-	lg	%r12,__LC_CURRENT
+	srag	%r11,%r10,12
+	jnz	0f
+	/* if __LC_LAST_BREAK is < 4096, it contains one of
+	 * the lpswe addresses in lowcore. Set it to 1 (initial state)
+	 * to prevent leaking that address to userspace.
+	 */
+	lghi	%r10,1
+0:	lg	%r12,__LC_CURRENT
 	lghi	%r11,0
 	larl	%r13,cleanup_critical
 	lmg	%r8,%r9,__LC_PGM_OLD_PSW
 	tmhh	%r8,0x0001		# test problem state bit
-	jnz	2f			# -> fault in user space
+	jnz	3f			# -> fault in user space
 #if IS_ENABLED(CONFIG_KVM)
 	# cleanup critical section for program checks in sie64a
 	lgr	%r14,%r9
 	slg	%r14,BASED(.Lsie_critical_start)
 	clg	%r14,BASED(.Lsie_critical_length)
-	jhe	0f
+	jhe	1f
 	lg	%r14,__SF_SIE_CONTROL(%r15)	# get control block pointer
 	ni	__SIE_PROG0C+3(%r14),0xfe	# no longer in SIE
 	lctlg	%c1,%c1,__LC_USER_ASCE		# load primary asce
 	larl	%r9,sie_exit			# skip forward to sie_exit
 	lghi	%r11,_PIF_GUEST_FAULT
 #endif
-0:	tmhh	%r8,0x4000		# PER bit set in old PSW ?
-	jnz	1f			# -> enabled, can't be a double fault
+1:	tmhh	%r8,0x4000		# PER bit set in old PSW ?
+	jnz	2f			# -> enabled, can't be a double fault
 	tm	__LC_PGM_ILC+3,0x80	# check for per exception
 	jnz	.Lpgm_svcper		# -> single stepped svc
-1:	CHECK_STACK __LC_SAVE_AREA_SYNC
+2:	CHECK_STACK __LC_SAVE_AREA_SYNC
 	aghi	%r15,-(STACK_FRAME_OVERHEAD + __PT_SIZE)
-	# CHECK_VMAP_STACK branches to stack_overflow or 4f
-	CHECK_VMAP_STACK __LC_SAVE_AREA_SYNC,4f
-2:	UPDATE_VTIME %r14,%r15,__LC_SYNC_ENTER_TIMER
+	# CHECK_VMAP_STACK branches to stack_overflow or 5f
+	CHECK_VMAP_STACK __LC_SAVE_AREA_SYNC,5f
+3:	UPDATE_VTIME %r14,%r15,__LC_SYNC_ENTER_TIMER
 	BPENTER __TI_flags(%r12),_TIF_ISOLATE_BP
 	lg	%r15,__LC_KERNEL_STACK
 	lgr	%r14,%r12
 	aghi	%r14,__TASK_thread	# pointer to thread_struct
 	lghi	%r13,__LC_PGM_TDB
 	tm	__LC_PGM_ILC+2,0x02	# check for transaction abort
-	jz	3f
+	jz	4f
 	mvc	__THREAD_trap_tdb(256,%r14),0(%r13)
-3:	stg	%r10,__THREAD_last_break(%r14)
-4:	lgr	%r13,%r11
+4:	stg	%r10,__THREAD_last_break(%r14)
+5:	lgr	%r13,%r11
 	la	%r11,STACK_FRAME_OVERHEAD(%r15)
 	stmg	%r0,%r7,__PT_R0(%r11)
 	# clear user controlled registers to prevent speculative use
@@ -663,14 +673,14 @@ ENTRY(pgm_check_handler)
 	stg	%r13,__PT_FLAGS(%r11)
 	stg	%r10,__PT_ARGS(%r11)
 	tm	__LC_PGM_ILC+3,0x80	# check for per exception
-	jz	5f
+	jz	6f
 	tmhh	%r8,0x0001		# kernel per event ?
 	jz	.Lpgm_kprobe
 	oi	__PT_FLAGS+7(%r11),_PIF_PER_TRAP
 	mvc	__THREAD_per_address(8,%r14),__LC_PER_ADDRESS
 	mvc	__THREAD_per_cause(2,%r14),__LC_PER_CODE
 	mvc	__THREAD_per_paid(1,%r14),__LC_PER_ACCESS_ID
-5:	REENABLE_IRQS
+6:	REENABLE_IRQS
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	larl	%r1,pgm_check_table
 	llgh	%r10,__PT_INT_CODE+2(%r11)
@@ -775,7 +785,7 @@ ENTRY(io_int_handler)
 	mvc	__VDSO_ECTG_BASE(16,%r14),__LC_EXIT_TIMER
 .Lio_exit_kernel:
 	lmg	%r11,%r15,__PT_R11(%r11)
-	lpswe	__LC_RETURN_PSW
+	b	__LC_RETURN_LPSWE(%r0)
 .Lio_done:
 
 #
@@ -1214,7 +1224,7 @@ ENTRY(mcck_int_handler)
 	stpt	__LC_EXIT_TIMER
 	mvc	__VDSO_ECTG_BASE(16,%r14),__LC_EXIT_TIMER
 0:	lmg	%r11,%r15,__PT_R11(%r11)
-	lpswe	__LC_RETURN_MCCK_PSW
+	b	__LC_RETURN_MCCK_LPSWE
 
 .Lmcck_panic:
 	lg	%r15,__LC_NODAT_STACK
@@ -1271,6 +1281,8 @@ ENDPROC(stack_overflow)
 #endif
 
 ENTRY(cleanup_critical)
+	cghi	%r9,__LC_RETURN_LPSWE
+	je	.Lcleanup_lpswe
 #if IS_ENABLED(CONFIG_KVM)
 	clg	%r9,BASED(.Lcleanup_table_sie)	# .Lsie_gmap
 	jl	0f
@@ -1424,6 +1436,7 @@ ENDPROC(cleanup_critical)
 	mvc	__LC_RETURN_PSW(16),__PT_PSW(%r9)
 	mvc	0(64,%r11),__PT_R8(%r9)
 	lmg	%r0,%r7,__PT_R0(%r9)
+.Lcleanup_lpswe:
 1:	lmg	%r8,%r9,__LC_RETURN_PSW
 	BR_EX	%r14,%r11
 .Lcleanup_sysc_restore_insn:
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -105,6 +105,7 @@ int copy_thread_tls(unsigned long clone_
 	p->thread.system_timer = 0;
 	p->thread.hardirq_timer = 0;
 	p->thread.softirq_timer = 0;
+	p->thread.last_break = 1;
 
 	frame->sf.back_chain = 0;
 	/* new return point is ret_from_fork */
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -73,6 +73,7 @@
 #include <asm/nospec-branch.h>
 #include <asm/mem_detect.h>
 #include <asm/uv.h>
+#include <asm/asm-offsets.h>
 #include "entry.h"
 
 /*
@@ -457,6 +458,8 @@ static void __init setup_lowcore_dat_off
 	lc->spinlock_index = 0;
 	arch_spin_lock_setup(0);
 	lc->br_r1_trampoline = 0x07f1;	/* br %r1 */
+	lc->return_lpswe = gen_lpswe(__LC_RETURN_PSW);
+	lc->return_mcck_lpswe = gen_lpswe(__LC_RETURN_MCCK_PSW);
 
 	set_prefix((u32)(unsigned long) lc);
 	lowcore_ptr[0] = lc;
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -212,6 +212,8 @@ static int pcpu_alloc_lowcore(struct pcp
 	lc->spinlock_lockval = arch_spin_lockval(cpu);
 	lc->spinlock_index = 0;
 	lc->br_r1_trampoline = 0x07f1;	/* br %r1 */
+	lc->return_lpswe = gen_lpswe(__LC_RETURN_PSW);
+	lc->return_mcck_lpswe = gen_lpswe(__LC_RETURN_MCCK_PSW);
 	if (nmi_alloc_per_cpu(lc))
 		goto out_async;
 	if (vdso_alloc_per_cpu(lc))
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -415,6 +415,10 @@ void __init vmem_map_init(void)
 		     SET_MEMORY_RO | SET_MEMORY_X);
 	__set_memory(__stext_dma, (__etext_dma - __stext_dma) >> PAGE_SHIFT,
 		     SET_MEMORY_RO | SET_MEMORY_X);
+
+	/* we need lowcore executable for our LPSWE instructions */
+	set_memory_x(0, 1);
+
 	pr_info("Write protected kernel read-only data: %luk\n",
 		(unsigned long)(__end_rodata - _stext) >> 10);
 }


