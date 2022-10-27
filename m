Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F136103BD
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 23:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbiJ0VDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 17:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbiJ0VC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 17:02:56 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED3327CCC;
        Thu, 27 Oct 2022 13:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666904106; x=1698440106;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=mIJ1UjHUl1LHjcRTu0hF28yrgVye5hZR5zRGYyF7qnQ=;
  b=BLl/b71lLBqLh4lyDeb3Ciwq76s5CYFaQ2bQ2Z5cwVPdcPA4KKOdJ/I4
   TNzE5932hgqr5ckmgO/oZXH+1WNLFHsT14Ilq1YU+CBBH9QEf4HWGdu2t
   0wkmISlIk2htEIlqKqfQx76u1Z+9V0oiCLM3m3xro+Bg8WQDpSVLYzJz7
   E=;
X-IronPort-AV: E=Sophos;i="5.95,218,1661817600"; 
   d="scan'208";a="236704482"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 20:55:04 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com (Postfix) with ESMTPS id 3ED56416A0;
        Thu, 27 Oct 2022 20:55:02 +0000 (UTC)
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 27 Oct 2022 20:55:01 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.161.14) by
 EX19D030UWB002.ant.amazon.com (10.13.139.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Thu, 27 Oct 2022 20:55:01 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <surajjs@amazon.com>, <sjitindarsingh@gmail.com>,
        <cascardo@canonical.com>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <jpoimboe@kernel.org>,
        <peterz@infradead.org>, <x86@kernel.org>
Subject: [PATCH 4.14 12/34] x86/entry: Add kernel IBRS implementation
Date:   Thu, 27 Oct 2022 13:54:52 -0700
Message-ID: <20221027205452.17271-4-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221027205452.17271-1-surajjs@amazon.com>
References: <20221027204801.13146-1-surajjs@amazon.com>
 <20221027205452.17271-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D39UWA003.ant.amazon.com (10.43.160.235) To
 EX19D030UWB002.ant.amazon.com (10.13.139.182)
X-Spam-Status: No, score=-12.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit 2dbb887e875b1de3ca8f40ddf26bcfe55798c609 upstream.

Implement Kernel IBRS - currently the only known option to mitigate RSB
underflow speculation issues on Skylake hardware.

Note: since IBRS_ENTER requires fuller context established than
UNTRAIN_RET, it must be placed after it. However, since UNTRAIN_RET
itself implies a RET, it must come after IBRS_ENTER. This means
IBRS_ENTER needs to also move UNTRAIN_RET.

Note 2: KERNEL_IBRS is sub-optimal for XenPV.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: conflict at arch/x86/entry/entry_64_compat.S]
[cascardo: conflict fixups, no ANNOTATE_NOENDBR]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ bp: Adjust context ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
---
 arch/x86/entry/calling.h           | 58 ++++++++++++++++++++++++++++++
 arch/x86/entry/entry_64.S          | 33 +++++++++++++++++
 arch/x86/entry/entry_64_compat.S   | 12 ++++++-
 arch/x86/include/asm/cpufeatures.h |  2 +-
 4 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 273b562af8fa..ef759951fd0f 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -6,6 +6,8 @@
 #include <asm/percpu.h>
 #include <asm/asm-offsets.h>
 #include <asm/processor-flags.h>
+#include <asm/msr.h>
+#include <asm/nospec-branch.h>
 
 /*
 
@@ -328,6 +330,62 @@ For 32-bit we have the following conventions - kernel is built with
 
 #endif
 
+/*
+ * IBRS kernel mitigation for Spectre_v2.
+ *
+ * Assumes full context is established (PUSH_REGS, CR3 and GS) and it clobbers
+ * the regs it uses (AX, CX, DX). Must be called before the first RET
+ * instruction (NOTE! UNTRAIN_RET includes a RET instruction)
+ *
+ * The optional argument is used to save/restore the current value,
+ * which is used on the paranoid paths.
+ *
+ * Assumes x86_spec_ctrl_{base,current} to have SPEC_CTRL_IBRS set.
+ */
+.macro IBRS_ENTER save_reg
+	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_KERNEL_IBRS
+	movl	$MSR_IA32_SPEC_CTRL, %ecx
+
+.ifnb \save_reg
+	rdmsr
+	shl	$32, %rdx
+	or	%rdx, %rax
+	mov	%rax, \save_reg
+	test	$SPEC_CTRL_IBRS, %eax
+	jz	.Ldo_wrmsr_\@
+	lfence
+	jmp	.Lend_\@
+.Ldo_wrmsr_\@:
+.endif
+
+	movq	PER_CPU_VAR(x86_spec_ctrl_current), %rdx
+	movl	%edx, %eax
+	shr	$32, %rdx
+	wrmsr
+.Lend_\@:
+.endm
+
+/*
+ * Similar to IBRS_ENTER, requires KERNEL GS,CR3 and clobbers (AX, CX, DX)
+ * regs. Must be called after the last RET.
+ */
+.macro IBRS_EXIT save_reg
+	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_KERNEL_IBRS
+	movl	$MSR_IA32_SPEC_CTRL, %ecx
+
+.ifnb \save_reg
+	mov	\save_reg, %rdx
+.else
+	movq	PER_CPU_VAR(x86_spec_ctrl_current), %rdx
+	andl	$(~SPEC_CTRL_IBRS), %edx
+.endif
+
+	movl	%edx, %eax
+	shr	$32, %rdx
+	wrmsr
+.Lend_\@:
+.endm
+
 /*
  * Mitigate Spectre v1 for conditional swapgs code paths.
  *
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index d3472e773b5a..fee102f5a7d5 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -230,6 +230,10 @@ GLOBAL(entry_SYSCALL_64_after_hwframe)
 
 	/* IRQs are off. */
 	movq	%rsp, %rdi
+
+	/* clobbers %rax, make sure it is after saving the syscall nr */
+	IBRS_ENTER
+
 	call	do_syscall_64		/* returns with IRQs disabled */
 
 	TRACE_IRQS_IRETQ		/* we're about to change IF */
@@ -301,6 +305,7 @@ GLOBAL(entry_SYSCALL_64_after_hwframe)
 	 * perf profiles. Nothing jumps here.
 	 */
 syscall_return_via_sysret:
+	IBRS_EXIT
 	POP_REGS pop_rdi=0
 
 	/*
@@ -590,6 +595,7 @@ GLOBAL(retint_user)
 	TRACE_IRQS_IRETQ
 
 GLOBAL(swapgs_restore_regs_and_return_to_usermode)
+	IBRS_EXIT
 #ifdef CONFIG_DEBUG_ENTRY
 	/* Assert that pt_regs indicates user mode. */
 	testb	$3, CS(%rsp)
@@ -1133,6 +1139,9 @@ idtentry machine_check		do_mce			has_error_code=0	paranoid=1
  * Save all registers in pt_regs, and switch gs if needed.
  * Use slow, but surefire "are we in kernel?" check.
  * Return: ebx=0: need swapgs on exit, ebx=1: otherwise
+ *
+ * R14 - old CR3
+ * R15 - old SPEC_CTRL
  */
 ENTRY(paranoid_entry)
 	UNWIND_HINT_FUNC
@@ -1156,6 +1165,12 @@ ENTRY(paranoid_entry)
 	 */
 	FENCE_SWAPGS_KERNEL_ENTRY
 
+	/*
+	 * Once we have CR3 and %GS setup save and set SPEC_CTRL. Just like
+	 * CR3 above, keep the old value in a callee saved register.
+	 */
+	IBRS_ENTER save_reg=%r15
+
 	ret
 END(paranoid_entry)
 
@@ -1170,9 +1185,19 @@ END(paranoid_entry)
  * to try to handle preemption here.
  *
  * On entry, ebx is "no swapgs" flag (1: don't need swapgs, 0: need it)
+ *
+ * R14 - old CR3
+ * R15 - old SPEC_CTRL
  */
 ENTRY(paranoid_exit)
 	UNWIND_HINT_REGS
+
+	/*
+	 * Must restore IBRS state before both CR3 and %GS since we need access
+	 * to the per-CPU x86_spec_ctrl_shadow variable.
+	 */
+	IBRS_EXIT save_reg=%r15
+
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF_DEBUG
 	testl	%ebx, %ebx			/* swapgs needed? */
@@ -1207,8 +1232,10 @@ ENTRY(error_entry)
 	FENCE_SWAPGS_USER_ENTRY
 	/* We have user CR3.  Change to kernel CR3. */
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
+	IBRS_ENTER
 
 .Lerror_entry_from_usermode_after_swapgs:
+
 	/* Put us onto the real thread stack. */
 	popq	%r12				/* save return addr in %12 */
 	movq	%rsp, %rdi			/* arg0 = pt_regs pointer */
@@ -1271,6 +1298,7 @@ ENTRY(error_entry)
 	SWAPGS
 	FENCE_SWAPGS_USER_ENTRY
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
+	IBRS_ENTER
 
 	/*
 	 * Pretend that the exception came from user mode: set up pt_regs
@@ -1376,6 +1404,8 @@ ENTRY(nmi)
 	PUSH_AND_CLEAR_REGS rdx=(%rdx)
 	ENCODE_FRAME_POINTER
 
+	IBRS_ENTER
+
 	/*
 	 * At this point we no longer need to worry about stack damage
 	 * due to nesting -- we're on the normal thread stack and we're
@@ -1599,6 +1629,9 @@ end_repeat_nmi:
 	movq	$-1, %rsi
 	call	do_nmi
 
+	/* Always restore stashed SPEC_CTRL value (see paranoid_entry) */
+	IBRS_EXIT save_reg=%r15
+
 	RESTORE_CR3 scratch_reg=%r15 save_reg=%r14
 
 	testl	%ebx, %ebx			/* swapgs needed? */
diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index 304e3daf82dd..8cdc3af68c53 100644
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -4,7 +4,6 @@
  *
  * Copyright 2000-2002 Andi Kleen, SuSE Labs.
  */
-#include "calling.h"
 #include <asm/asm-offsets.h>
 #include <asm/current.h>
 #include <asm/errno.h>
@@ -17,6 +16,8 @@
 #include <linux/linkage.h>
 #include <linux/err.h>
 
+#include "calling.h"
+
 	.section .entry.text, "ax"
 
 /*
@@ -106,6 +107,8 @@ ENTRY(entry_SYSENTER_compat)
 	xorl	%r15d, %r15d		/* nospec   r15 */
 	cld
 
+	IBRS_ENTER
+
 	/*
 	 * SYSENTER doesn't filter flags, so we need to clear NT and AC
 	 * ourselves.  To save a few cycles, we can check whether
@@ -250,6 +253,8 @@ GLOBAL(entry_SYSCALL_compat_after_hwframe)
 	 */
 	TRACE_IRQS_OFF
 
+	IBRS_ENTER
+
 	movq	%rsp, %rdi
 	call	do_fast_syscall_32
 	/* XEN PV guests always use IRET path */
@@ -259,6 +264,9 @@ GLOBAL(entry_SYSCALL_compat_after_hwframe)
 	/* Opportunistic SYSRET */
 sysret32_from_system_call:
 	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
+
+	IBRS_EXIT
+
 	movq	RBX(%rsp), %rbx		/* pt_regs->rbx */
 	movq	RBP(%rsp), %rbp		/* pt_regs->rbp */
 	movq	EFLAGS(%rsp), %r11	/* pt_regs->flags (in r11) */
@@ -385,6 +393,8 @@ ENTRY(entry_INT80_compat)
 	 */
 	TRACE_IRQS_OFF
 
+	IBRS_ENTER
+
 	movq	%rsp, %rdi
 	call	do_int80_syscall_32
 .Lsyscall_32_done:
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 2e96129ed68b..b78acf1e70b6 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -202,7 +202,7 @@
 #define X86_FEATURE_PROC_FEEDBACK	( 7*32+ 9) /* AMD ProcFeedbackInterface */
 #define X86_FEATURE_SME			( 7*32+10) /* AMD Secure Memory Encryption */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
-/* FREE!				( 7*32+12) */
+#define X86_FEATURE_KERNEL_IBRS		( 7*32+12) /* "" Set/clear IBRS on kernel entry/exit */
 /* FREE!				( 7*32+13) */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_CDP_L2		( 7*32+15) /* Code and Data Prioritization L2 */
-- 
2.17.1

