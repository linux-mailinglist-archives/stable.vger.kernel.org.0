Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA1F688DB6
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfHJUoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:44:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54808 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726796AbfHJUoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:00 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDV-00053Y-Kn; Sat, 10 Aug 2019 21:43:57 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDN-0003ig-T0; Sat, 10 Aug 2019 21:43:49 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.17941817@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 125/157] x86/speculation: Prepare entry code for
 Spectre v1 swapgs mitigations
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 18ec54fdd6d18d92025af097cd042a75cf0ea24c upstream.

Spectre v1 isn't only about array bounds checks.  It can affect any
conditional checks.  The kernel entry code interrupt, exception, and NMI
handlers all have conditional swapgs checks.  Those may be problematic in
the context of Spectre v1, as kernel code can speculatively run with a user
GS.

For example:

	if (coming from user space)
		swapgs
	mov %gs:<percpu_offset>, %reg
	mov (%reg), %reg1

When coming from user space, the CPU can speculatively skip the swapgs, and
then do a speculative percpu load using the user GS value.  So the user can
speculatively force a read of any kernel value.  If a gadget exists which
uses the percpu value as an address in another load/store, then the
contents of the kernel value may become visible via an L1 side channel
attack.

A similar attack exists when coming from kernel space.  The CPU can
speculatively do the swapgs, causing the user GS to get used for the rest
of the speculative window.

The mitigation is similar to a traditional Spectre v1 mitigation, except:

  a) index masking isn't possible; because the index (percpu offset)
     isn't user-controlled; and

  b) an lfence is needed in both the "from user" swapgs path and the
     "from kernel" non-swapgs path (because of the two attacks described
     above).

The user entry swapgs paths already have SWITCH_TO_KERNEL_CR3, which has a
CR3 write when PTI is enabled.  Since CR3 writes are serializing, the
lfences can be skipped in those cases.

On the other hand, the kernel entry swapgs paths don't depend on PTI.

To avoid unnecessary lfences for the user entry case, create two separate
features for alternative patching:

  X86_FEATURE_FENCE_SWAPGS_USER
  X86_FEATURE_FENCE_SWAPGS_KERNEL

Use these features in entry code to patch in lfences where needed.

The features aren't enabled yet, so there's no functional change.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Dave Hansen <dave.hansen@intel.com>
[bwh: Backported to 3.16:
 - Assign the CPU feature bits from word 7
 - Add FENCE_SWAPGS_KERNEL_ENTRY to NMI entry, since it does not
   use paranoid_entry
 - Add a return after .Lerror_entry_from_usermode_after_swapgs, done
   upstream by commit f10750536fa7 "x86/entry/64: Fix irqflag tracing wrt
   context tracking"
 - Include <asm/cpufeatures.h> in calling.h
 - Adjust filenames, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -47,6 +47,7 @@ For 32-bit we have the following convent
 */
 
 #include <asm/dwarf2.h>
+#include <asm/cpufeatures.h>
 
 #ifdef CONFIG_X86_64
 
@@ -195,6 +196,23 @@ For 32-bit we have the following convent
 	.byte 0xf1
 	.endm
 
+/*
+ * Mitigate Spectre v1 for conditional swapgs code paths.
+ *
+ * FENCE_SWAPGS_USER_ENTRY is used in the user entry swapgs code path, to
+ * prevent a speculative swapgs when coming from kernel space.
+ *
+ * FENCE_SWAPGS_KERNEL_ENTRY is used in the kernel entry non-swapgs code path,
+ * to prevent the swapgs from getting speculatively skipped when coming from
+ * user space.
+ */
+.macro FENCE_SWAPGS_USER_ENTRY
+	ALTERNATIVE "", "lfence", X86_FEATURE_FENCE_SWAPGS_USER
+.endm
+.macro FENCE_SWAPGS_KERNEL_ENTRY
+	ALTERNATIVE "", "lfence", X86_FEATURE_FENCE_SWAPGS_KERNEL
+.endm
+
 #else /* CONFIG_X86_64 */
 
 /*
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -183,7 +183,8 @@
 #define X86_FEATURE_DTHERM	( 7*32+ 7) /* Digital Thermal Sensor */
 #define X86_FEATURE_HW_PSTATE	( 7*32+ 8) /* AMD HW-PState */
 #define X86_FEATURE_PROC_FEEDBACK ( 7*32+ 9) /* AMD ProcFeedbackInterface */
-
+#define X86_FEATURE_FENCE_SWAPGS_USER	( 7*32+10) /* "" LFENCE in user entry SWAPGS path */
+#define X86_FEATURE_FENCE_SWAPGS_KERNEL	( 7*32+11) /* "" LFENCE in kernel entry SWAPGS path */
 #define X86_FEATURE_RETPOLINE	( 7*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
 #define X86_FEATURE_RETPOLINE_AMD ( 7*32+13) /* "" AMD Retpoline mitigation for Spectre variant 2 */
 
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -265,14 +265,19 @@ ENDPROC(native_usergs_sysret64)
 	testl $3, CS-RBP(%rsi)
 	je 1f
 	SWAPGS
+	FENCE_SWAPGS_USER_ENTRY
 	SWITCH_KERNEL_CR3
+	jmpq	2f
+1:
+	FENCE_SWAPGS_KERNEL_ENTRY
+2:
 	/*
 	 * irq_count is used to check if a CPU is already on an interrupt stack
 	 * or not. While this is essentially redundant with preempt_count it is
 	 * a little cheaper to use a separate counter in the PDA (short of
 	 * moving irq_enter into assembly, which would be too much work)
 	 */
-1:	incl PER_CPU_VAR(irq_count)
+	incl PER_CPU_VAR(irq_count)
 	cmovzq PER_CPU_VAR(irq_stack_ptr),%rsp
 	CFI_DEF_CFA_REGISTER	rsi
 
@@ -337,6 +342,13 @@ ENTRY(save_paranoid)
 	movq	%rax, %cr3
 2:
 #endif
+	/*
+	 * The above doesn't do an unconditional CR3 write, even in the PTI
+	 * case.  So do an lfence to prevent GS speculation, regardless of
+	 * whether PTI is enabled.
+	 */
+	FENCE_SWAPGS_KERNEL_ENTRY
+
 	ret
 	CFI_ENDPROC
 END(save_paranoid)
@@ -1452,8 +1464,19 @@ ENTRY(error_entry)
 	 * from user mode due to an IRET fault.
 	 */
 	SWAPGS
+	FENCE_SWAPGS_USER_ENTRY
 
 .Lerror_entry_from_usermode_after_swapgs:
+	/*
+	 * We need to tell lockdep that IRQs are off.  We can't do this until
+	 * we fix gsbase, and we should do it before enter_from_user_mode
+	 * (which can take locks).
+	 */
+	TRACE_IRQS_OFF
+	ret
+
+.Lerror_entry_done_lfence:
+	FENCE_SWAPGS_KERNEL_ENTRY
 .Lerror_entry_done:
 	TRACE_IRQS_OFF
 	ret
@@ -1472,7 +1495,7 @@ ENTRY(error_entry)
 	cmpq %rax,RIP+8(%rsp)
 	je	.Lbstep_iret
 	cmpq $gs_change,RIP+8(%rsp)
-	jne	.Lerror_entry_done
+	jne	.Lerror_entry_done_lfence
 
 	/*
 	 * hack: gs_change can fail with user gsbase.  If this happens, fix up
@@ -1480,6 +1503,7 @@ ENTRY(error_entry)
 	 * gs_change's error handler with kernel gsbase.
 	 */
 	SWAPGS
+	FENCE_SWAPGS_USER_ENTRY
 	jmp .Lerror_entry_done
 
 .Lbstep_iret:
@@ -1493,6 +1517,7 @@ ENTRY(error_entry)
 	 * Switch to kernel gsbase:
 	 */
 	SWAPGS
+	FENCE_SWAPGS_USER_ENTRY
 
 	/*
 	 * Pretend that the exception came from user mode: set up pt_regs
@@ -1601,6 +1626,7 @@ ENTRY(nmi)
 	 * to switch CR3 here.
 	 */
 	cld
+	FENCE_SWAPGS_USER_ENTRY
 	movq	%rsp, %rdx
 	movq	PER_CPU_VAR(kernel_stack), %rsp
 	addq	$KERNEL_STACK_OFFSET, %rsp
@@ -1646,6 +1672,7 @@ ENTRY(nmi)
 	movq	%rax, %cr3
 2:
 #endif
+	FENCE_SWAPGS_KERNEL_ENTRY
 	call	do_nmi
 
 #ifdef CONFIG_PAGE_TABLE_ISOLATION

