Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E0857EEF3
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 13:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiGWLO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 07:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234840AbiGWLOY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 07:14:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5282A72B;
        Sat, 23 Jul 2022 04:14:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D182361479;
        Sat, 23 Jul 2022 11:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CE5C341C0;
        Sat, 23 Jul 2022 11:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658574859;
        bh=TT+KIHd47JKNLGgF8OXazeuBA3JQ8bY/pMWB6KiuVUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YIsubUxCGS5QAFop/7NhgkZMj4U/Y9+bvS69r5hsfUOH6poBDoiBlvX5XkgiF7TlL
         wJCHpgxwx7nl3Qi/C6LWiVmQrmeqJ9aPPV4VNPVYBF5q5rQ0VvCc5BI826pZmvAZ0O
         ntlOfWHB/sd793qk35rj/PwsOk74r7+JXRWrNIn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.57
Date:   Sat, 23 Jul 2022 13:14:09 +0200
Message-Id: <165857484915686@kroah.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <1658574849159138@kroah.com>
References: <1658574849159138@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 9f4f3e2ceea6..2c556a127979 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4968,6 +4968,30 @@
 
 	retain_initrd	[RAM] Keep initrd memory after extraction
 
+	retbleed=	[X86] Control mitigation of RETBleed (Arbitrary
+			Speculative Code Execution with Return Instructions)
+			vulnerability.
+
+			off          - no mitigation
+			auto         - automatically select a migitation
+			auto,nosmt   - automatically select a mitigation,
+				       disabling SMT if necessary for
+				       the full mitigation (only on Zen1
+				       and older without STIBP).
+			ibpb	     - mitigate short speculation windows on
+				       basic block boundaries too. Safe, highest
+				       perf impact.
+			unret        - force enable untrained return thunks,
+				       only effective on AMD f15h-f17h
+				       based systems.
+			unret,nosmt  - like unret, will disable SMT when STIBP
+			               is not available.
+
+			Selecting 'auto' will choose a mitigation method at run
+			time according to the CPU.
+
+			Not specifying this option is equivalent to retbleed=auto.
+
 	rfkill.default_state=
 		0	"airplane mode".  All wifi, bluetooth, wimax, gps, fm,
 			etc. communication is blocked by default.
@@ -5314,6 +5338,7 @@
 			eibrs		  - enhanced IBRS
 			eibrs,retpoline   - enhanced IBRS + Retpolines
 			eibrs,lfence      - enhanced IBRS + LFENCE
+			ibrs		  - use IBRS to protect kernel
 
 			Not specifying this option is equivalent to
 			spectre_v2=auto.
diff --git a/Makefile b/Makefile
index 2ce44168b1b5..69bfff4d9c2d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 56
+SUBLEVEL = 57
 EXTRAVERSION =
 NAME = Trick or Treat
 
@@ -687,12 +687,19 @@ endif
 
 ifdef CONFIG_CC_IS_GCC
 RETPOLINE_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-extern -mindirect-branch-register)
+RETPOLINE_CFLAGS	+= $(call cc-option,-mindirect-branch-cs-prefix)
 RETPOLINE_VDSO_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-inline -mindirect-branch-register)
 endif
 ifdef CONFIG_CC_IS_CLANG
 RETPOLINE_CFLAGS	:= -mretpoline-external-thunk
 RETPOLINE_VDSO_CFLAGS	:= -mretpoline
 endif
+
+ifdef CONFIG_RETHUNK
+RETHUNK_CFLAGS         := -mfunction-return=thunk-extern
+RETPOLINE_CFLAGS       += $(RETHUNK_CFLAGS)
+endif
+
 export RETPOLINE_CFLAGS
 export RETPOLINE_VDSO_CFLAGS
 
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index a149a5e9a16a..5aa5e7533b75 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -421,6 +421,14 @@ void __init check_bugs(void)
 	os_check_bugs();
 }
 
+void apply_retpolines(s32 *start, s32 *end)
+{
+}
+
+void apply_returns(s32 *start, s32 *end)
+{
+}
+
 void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
 {
 }
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d0f16b53393..a170cfdae2a7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -459,27 +459,6 @@ config GOLDFISH
 	def_bool y
 	depends on X86_GOLDFISH
 
-config RETPOLINE
-	bool "Avoid speculative indirect branches in kernel"
-	default y
-	help
-	  Compile kernel with the retpoline compiler options to guard against
-	  kernel-to-user data leaks by avoiding speculative indirect
-	  branches. Requires a compiler with -mindirect-branch=thunk-extern
-	  support for full protection. The kernel may run slower.
-
-config CC_HAS_SLS
-	def_bool $(cc-option,-mharden-sls=all)
-
-config SLS
-	bool "Mitigate Straight-Line-Speculation"
-	depends on CC_HAS_SLS && X86_64
-	default n
-	help
-	  Compile the kernel with straight-line-speculation options to guard
-	  against straight line speculation. The kernel image might be slightly
-	  larger.
-
 config X86_CPU_RESCTRL
 	bool "x86 CPU resource control support"
 	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
@@ -2407,6 +2386,88 @@ source "kernel/livepatch/Kconfig"
 
 endmenu
 
+config CC_HAS_SLS
+	def_bool $(cc-option,-mharden-sls=all)
+
+config CC_HAS_RETURN_THUNK
+	def_bool $(cc-option,-mfunction-return=thunk-extern)
+
+menuconfig SPECULATION_MITIGATIONS
+	bool "Mitigations for speculative execution vulnerabilities"
+	default y
+	help
+	  Say Y here to enable options which enable mitigations for
+	  speculative execution hardware vulnerabilities.
+
+	  If you say N, all mitigations will be disabled. You really
+	  should know what you are doing to say so.
+
+if SPECULATION_MITIGATIONS
+
+config PAGE_TABLE_ISOLATION
+	bool "Remove the kernel mapping in user mode"
+	default y
+	depends on (X86_64 || X86_PAE)
+	help
+	  This feature reduces the number of hardware side channels by
+	  ensuring that the majority of kernel addresses are not mapped
+	  into userspace.
+
+	  See Documentation/x86/pti.rst for more details.
+
+config RETPOLINE
+	bool "Avoid speculative indirect branches in kernel"
+	default y
+	help
+	  Compile kernel with the retpoline compiler options to guard against
+	  kernel-to-user data leaks by avoiding speculative indirect
+	  branches. Requires a compiler with -mindirect-branch=thunk-extern
+	  support for full protection. The kernel may run slower.
+
+config RETHUNK
+	bool "Enable return-thunks"
+	depends on RETPOLINE && CC_HAS_RETURN_THUNK
+	default y
+	help
+	  Compile the kernel with the return-thunks compiler option to guard
+	  against kernel-to-user data leaks by avoiding return speculation.
+	  Requires a compiler with -mfunction-return=thunk-extern
+	  support for full protection. The kernel may run slower.
+
+config CPU_UNRET_ENTRY
+	bool "Enable UNRET on kernel entry"
+	depends on CPU_SUP_AMD && RETHUNK
+	default y
+	help
+	  Compile the kernel with support for the retbleed=unret mitigation.
+
+config CPU_IBPB_ENTRY
+	bool "Enable IBPB on kernel entry"
+	depends on CPU_SUP_AMD
+	default y
+	help
+	  Compile the kernel with support for the retbleed=ibpb mitigation.
+
+config CPU_IBRS_ENTRY
+	bool "Enable IBRS on kernel entry"
+	depends on CPU_SUP_INTEL
+	default y
+	help
+	  Compile the kernel with support for the spectre_v2=ibrs mitigation.
+	  This mitigates both spectre_v2 and retbleed at great cost to
+	  performance.
+
+config SLS
+	bool "Mitigate Straight-Line-Speculation"
+	depends on CC_HAS_SLS && X86_64
+	default n
+	help
+	  Compile the kernel with straight-line-speculation options to guard
+	  against straight line speculation. The kernel image might be slightly
+	  larger.
+
+endif
+
 config ARCH_HAS_ADD_PAGES
 	def_bool y
 	depends on X86_64 && ARCH_ENABLE_MEMORY_HOTPLUG
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 300227818206..9c09bbd390ce 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -24,7 +24,7 @@ endif
 
 # How to compile the 16-bit code.  Note we always compile for -march=i386;
 # that way we can complain to the user if the CPU is insufficient.
-REALMODE_CFLAGS	:= -m16 -g -Os -DDISABLE_BRANCH_PROFILING \
+REALMODE_CFLAGS	:= -m16 -g -Os -DDISABLE_BRANCH_PROFILING -D__DISABLE_EXPORTS \
 		   -Wall -Wstrict-prototypes -march=i386 -mregparm=3 \
 		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
 		   -mno-mmx -mno-sse $(call cc-option,-fcf-protection=none)
diff --git a/arch/x86/entry/Makefile b/arch/x86/entry/Makefile
index 7fec5dcf6438..eeadbd7d92cc 100644
--- a/arch/x86/entry/Makefile
+++ b/arch/x86/entry/Makefile
@@ -11,7 +11,7 @@ CFLAGS_REMOVE_common.o		= $(CC_FLAGS_FTRACE)
 
 CFLAGS_common.o			+= -fno-stack-protector
 
-obj-y				:= entry_$(BITS).o thunk_$(BITS).o syscall_$(BITS).o
+obj-y				:= entry.o entry_$(BITS).o thunk_$(BITS).o syscall_$(BITS).o
 obj-y				+= common.o
 
 obj-y				+= vdso/
diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index a4c061fb7c6e..b00a3a95fbfa 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -7,6 +7,8 @@
 #include <asm/asm-offsets.h>
 #include <asm/processor-flags.h>
 #include <asm/ptrace-abi.h>
+#include <asm/msr.h>
+#include <asm/nospec-branch.h>
 
 /*
 
@@ -119,27 +121,19 @@ For 32-bit we have the following conventions - kernel is built with
 	CLEAR_REGS
 .endm
 
-.macro POP_REGS pop_rdi=1 skip_r11rcx=0
+.macro POP_REGS pop_rdi=1
 	popq %r15
 	popq %r14
 	popq %r13
 	popq %r12
 	popq %rbp
 	popq %rbx
-	.if \skip_r11rcx
-	popq %rsi
-	.else
 	popq %r11
-	.endif
 	popq %r10
 	popq %r9
 	popq %r8
 	popq %rax
-	.if \skip_r11rcx
-	popq %rsi
-	.else
 	popq %rcx
-	.endif
 	popq %rdx
 	popq %rsi
 	.if \pop_rdi
@@ -289,6 +283,66 @@ For 32-bit we have the following conventions - kernel is built with
 
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
+#ifdef CONFIG_CPU_IBRS_ENTRY
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
+#endif
+.endm
+
+/*
+ * Similar to IBRS_ENTER, requires KERNEL GS,CR3 and clobbers (AX, CX, DX)
+ * regs. Must be called after the last RET.
+ */
+.macro IBRS_EXIT save_reg
+#ifdef CONFIG_CPU_IBRS_ENTRY
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
+#endif
+.endm
+
 /*
  * Mitigate Spectre v1 for conditional swapgs code paths.
  *
diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
new file mode 100644
index 000000000000..bfb7bcb362bc
--- /dev/null
+++ b/arch/x86/entry/entry.S
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Common place for both 32- and 64-bit entry routines.
+ */
+
+#include <linux/linkage.h>
+#include <asm/export.h>
+#include <asm/msr-index.h>
+
+.pushsection .noinstr.text, "ax"
+
+SYM_FUNC_START(entry_ibpb)
+	movl	$MSR_IA32_PRED_CMD, %ecx
+	movl	$PRED_CMD_IBPB, %eax
+	xorl	%edx, %edx
+	wrmsr
+	RET
+SYM_FUNC_END(entry_ibpb)
+/* For KVM */
+EXPORT_SYMBOL_GPL(entry_ibpb);
+
+.popsection
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 00413e37feee..5bd3baf36d87 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -701,7 +701,6 @@ SYM_CODE_START(__switch_to_asm)
 	movl	%ebx, PER_CPU_VAR(__stack_chk_guard)
 #endif
 
-#ifdef CONFIG_RETPOLINE
 	/*
 	 * When switching from a shallower to a deeper call stack
 	 * the RSB may either underflow or use entries populated
@@ -710,7 +709,6 @@ SYM_CODE_START(__switch_to_asm)
 	 * speculative execution to prevent attack.
 	 */
 	FILL_RETURN_BUFFER %ebx, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_CTXSW
-#endif
 
 	/* Restore flags or the incoming task to restore AC state. */
 	popfl
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 3acf0af49305..763ff243aeca 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -85,7 +85,7 @@
  */
 
 SYM_CODE_START(entry_SYSCALL_64)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_ENTRY
 
 	swapgs
 	/* tss.sp2 is scratch space. */
@@ -110,6 +110,11 @@ SYM_INNER_LABEL(entry_SYSCALL_64_after_hwframe, SYM_L_GLOBAL)
 	movq	%rsp, %rdi
 	/* Sign extend the lower 32bit as syscall numbers are treated as int */
 	movslq	%eax, %rsi
+
+	/* clobbers %rax, make sure it is after saving the syscall nr */
+	IBRS_ENTER
+	UNTRAIN_RET
+
 	call	do_syscall_64		/* returns with IRQs disabled */
 
 	/*
@@ -189,8 +194,8 @@ SYM_INNER_LABEL(entry_SYSCALL_64_after_hwframe, SYM_L_GLOBAL)
 	 * perf profiles. Nothing jumps here.
 	 */
 syscall_return_via_sysret:
-	/* rcx and r11 are already restored (see code above) */
-	POP_REGS pop_rdi=0 skip_r11rcx=1
+	IBRS_EXIT
+	POP_REGS pop_rdi=0
 
 	/*
 	 * Now all regs are restored except RSP and RDI.
@@ -243,7 +248,6 @@ SYM_FUNC_START(__switch_to_asm)
 	movq	%rbx, PER_CPU_VAR(fixed_percpu_data) + stack_canary_offset
 #endif
 
-#ifdef CONFIG_RETPOLINE
 	/*
 	 * When switching from a shallower to a deeper call stack
 	 * the RSB may either underflow or use entries populated
@@ -252,7 +256,6 @@ SYM_FUNC_START(__switch_to_asm)
 	 * speculative execution to prevent attack.
 	 */
 	FILL_RETURN_BUFFER %r12, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_CTXSW
-#endif
 
 	/* restore callee-saved registers */
 	popq	%r15
@@ -315,6 +318,14 @@ SYM_CODE_END(ret_from_fork)
 #endif
 .endm
 
+SYM_CODE_START_LOCAL(xen_error_entry)
+	UNWIND_HINT_FUNC
+	PUSH_AND_CLEAR_REGS save_ret=1
+	ENCODE_FRAME_POINTER 8
+	UNTRAIN_RET
+	RET
+SYM_CODE_END(xen_error_entry)
+
 /**
  * idtentry_body - Macro to emit code calling the C function
  * @cfunc:		C function to be called
@@ -322,7 +333,18 @@ SYM_CODE_END(ret_from_fork)
  */
 .macro idtentry_body cfunc has_error_code:req
 
-	call	error_entry
+	/*
+	 * Call error_entry() and switch to the task stack if from userspace.
+	 *
+	 * When in XENPV, it is already in the task stack, and it can't fault
+	 * for native_iret() nor native_load_gs_index() since XENPV uses its
+	 * own pvops for IRET and load_gs_index().  And it doesn't need to
+	 * switch the CR3.  So it can skip invoking error_entry().
+	 */
+	ALTERNATIVE "call error_entry; movq %rax, %rsp", \
+		    "call xen_error_entry", X86_FEATURE_XENPV
+
+	ENCODE_FRAME_POINTER
 	UNWIND_HINT_REGS
 
 	movq	%rsp, %rdi			/* pt_regs pointer into 1st argument*/
@@ -568,6 +590,7 @@ __irqentry_text_end:
 
 SYM_CODE_START_LOCAL(common_interrupt_return)
 SYM_INNER_LABEL(swapgs_restore_regs_and_return_to_usermode, SYM_L_GLOBAL)
+	IBRS_EXIT
 #ifdef CONFIG_DEBUG_ENTRY
 	/* Assert that pt_regs indicates user mode. */
 	testb	$3, CS(%rsp)
@@ -675,6 +698,7 @@ native_irq_return_ldt:
 	pushq	%rdi				/* Stash user RDI */
 	swapgs					/* to kernel GS */
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rdi	/* to kernel CR3 */
+	UNTRAIN_RET
 
 	movq	PER_CPU_VAR(espfix_waddr), %rdi
 	movq	%rax, (0*8)(%rdi)		/* user RAX */
@@ -846,6 +870,9 @@ SYM_CODE_END(xen_failsafe_callback)
  *              1 -> no SWAPGS on exit
  *
  *     Y        GSBASE value at entry, must be restored in paranoid_exit
+ *
+ * R14 - old CR3
+ * R15 - old SPEC_CTRL
  */
 SYM_CODE_START_LOCAL(paranoid_entry)
 	UNWIND_HINT_FUNC
@@ -890,7 +917,7 @@ SYM_CODE_START_LOCAL(paranoid_entry)
 	 * is needed here.
 	 */
 	SAVE_AND_SET_GSBASE scratch_reg=%rax save_reg=%rbx
-	RET
+	jmp .Lparanoid_gsbase_done
 
 .Lparanoid_entry_checkgs:
 	/* EBX = 1 -> kernel GSBASE active, no restore required */
@@ -909,8 +936,16 @@ SYM_CODE_START_LOCAL(paranoid_entry)
 	xorl	%ebx, %ebx
 	swapgs
 .Lparanoid_kernel_gsbase:
-
 	FENCE_SWAPGS_KERNEL_ENTRY
+.Lparanoid_gsbase_done:
+
+	/*
+	 * Once we have CR3 and %GS setup save and set SPEC_CTRL. Just like
+	 * CR3 above, keep the old value in a callee saved register.
+	 */
+	IBRS_ENTER save_reg=%r15
+	UNTRAIN_RET
+
 	RET
 SYM_CODE_END(paranoid_entry)
 
@@ -932,9 +967,19 @@ SYM_CODE_END(paranoid_entry)
  *              1 -> no SWAPGS on exit
  *
  *     Y        User space GSBASE, must be restored unconditionally
+ *
+ * R14 - old CR3
+ * R15 - old SPEC_CTRL
  */
 SYM_CODE_START_LOCAL(paranoid_exit)
 	UNWIND_HINT_REGS
+
+	/*
+	 * Must restore IBRS state before both CR3 and %GS since we need access
+	 * to the per-CPU x86_spec_ctrl_shadow variable.
+	 */
+	IBRS_EXIT save_reg=%r15
+
 	/*
 	 * The order of operations is important. RESTORE_CR3 requires
 	 * kernel GSBASE.
@@ -963,13 +1008,15 @@ SYM_CODE_START_LOCAL(paranoid_exit)
 SYM_CODE_END(paranoid_exit)
 
 /*
- * Save all registers in pt_regs, and switch GS if needed.
+ * Switch GS and CR3 if needed.
  */
 SYM_CODE_START_LOCAL(error_entry)
 	UNWIND_HINT_FUNC
 	cld
+
 	PUSH_AND_CLEAR_REGS save_ret=1
 	ENCODE_FRAME_POINTER 8
+
 	testb	$3, CS+8(%rsp)
 	jz	.Lerror_kernelspace
 
@@ -981,15 +1028,14 @@ SYM_CODE_START_LOCAL(error_entry)
 	FENCE_SWAPGS_USER_ENTRY
 	/* We have user CR3.  Change to kernel CR3. */
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
+	IBRS_ENTER
+	UNTRAIN_RET
 
+	leaq	8(%rsp), %rdi			/* arg0 = pt_regs pointer */
 .Lerror_entry_from_usermode_after_swapgs:
+
 	/* Put us onto the real thread stack. */
-	popq	%r12				/* save return addr in %12 */
-	movq	%rsp, %rdi			/* arg0 = pt_regs pointer */
 	call	sync_regs
-	movq	%rax, %rsp			/* switch stack */
-	ENCODE_FRAME_POINTER
-	pushq	%r12
 	RET
 
 	/*
@@ -1021,6 +1067,8 @@ SYM_CODE_START_LOCAL(error_entry)
 	 */
 .Lerror_entry_done_lfence:
 	FENCE_SWAPGS_KERNEL_ENTRY
+	leaq	8(%rsp), %rax			/* return pt_regs pointer */
+	ANNOTATE_UNRET_END
 	RET
 
 .Lbstep_iret:
@@ -1036,14 +1084,16 @@ SYM_CODE_START_LOCAL(error_entry)
 	SWAPGS
 	FENCE_SWAPGS_USER_ENTRY
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
+	IBRS_ENTER
+	UNTRAIN_RET
 
 	/*
 	 * Pretend that the exception came from user mode: set up pt_regs
 	 * as if we faulted immediately after IRET.
 	 */
-	mov	%rsp, %rdi
+	leaq	8(%rsp), %rdi			/* arg0 = pt_regs pointer */
 	call	fixup_bad_iret
-	mov	%rax, %rsp
+	mov	%rax, %rdi
 	jmp	.Lerror_entry_from_usermode_after_swapgs
 SYM_CODE_END(error_entry)
 
@@ -1140,6 +1190,9 @@ SYM_CODE_START(asm_exc_nmi)
 	PUSH_AND_CLEAR_REGS rdx=(%rdx)
 	ENCODE_FRAME_POINTER
 
+	IBRS_ENTER
+	UNTRAIN_RET
+
 	/*
 	 * At this point we no longer need to worry about stack damage
 	 * due to nesting -- we're on the normal thread stack and we're
@@ -1362,6 +1415,9 @@ end_repeat_nmi:
 	movq	$-1, %rsi
 	call	exc_nmi
 
+	/* Always restore stashed SPEC_CTRL value (see paranoid_entry) */
+	IBRS_EXIT save_reg=%r15
+
 	/* Always restore stashed CR3 value (see paranoid_entry) */
 	RESTORE_CR3 scratch_reg=%r15 save_reg=%r14
 
diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index 0051cf5c792d..4d637a965efb 100644
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
@@ -14,9 +13,12 @@
 #include <asm/irqflags.h>
 #include <asm/asm.h>
 #include <asm/smap.h>
+#include <asm/nospec-branch.h>
 #include <linux/linkage.h>
 #include <linux/err.h>
 
+#include "calling.h"
+
 	.section .entry.text, "ax"
 
 /*
@@ -47,7 +49,7 @@
  * 0(%ebp) arg6
  */
 SYM_CODE_START(entry_SYSENTER_compat)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_ENTRY
 	/* Interrupts are off on entry. */
 	SWAPGS
 
@@ -112,6 +114,9 @@ SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
 
 	cld
 
+	IBRS_ENTER
+	UNTRAIN_RET
+
 	/*
 	 * SYSENTER doesn't filter flags, so we need to clear NT and AC
 	 * ourselves.  To save a few cycles, we can check whether
@@ -197,7 +202,7 @@ SYM_CODE_END(entry_SYSENTER_compat)
  * 0(%esp) arg6
  */
 SYM_CODE_START(entry_SYSCALL_compat)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_ENTRY
 	/* Interrupts are off on entry. */
 	swapgs
 
@@ -252,6 +257,9 @@ SYM_INNER_LABEL(entry_SYSCALL_compat_after_hwframe, SYM_L_GLOBAL)
 
 	UNWIND_HINT_REGS
 
+	IBRS_ENTER
+	UNTRAIN_RET
+
 	movq	%rsp, %rdi
 	call	do_fast_syscall_32
 	/* XEN PV guests always use IRET path */
@@ -266,6 +274,8 @@ sysret32_from_system_call:
 	 */
 	STACKLEAK_ERASE
 
+	IBRS_EXIT
+
 	movq	RBX(%rsp), %rbx		/* pt_regs->rbx */
 	movq	RBP(%rsp), %rbp		/* pt_regs->rbp */
 	movq	EFLAGS(%rsp), %r11	/* pt_regs->flags (in r11) */
@@ -339,7 +349,7 @@ SYM_CODE_END(entry_SYSCALL_compat)
  * ebp  arg6
  */
 SYM_CODE_START(entry_INT80_compat)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_ENTRY
 	/*
 	 * Interrupts are off on entry.
 	 */
@@ -409,6 +419,9 @@ SYM_CODE_START(entry_INT80_compat)
 
 	cld
 
+	IBRS_ENTER
+	UNTRAIN_RET
+
 	movq	%rsp, %rdi
 	call	do_int80_syscall_32
 	jmp	swapgs_restore_regs_and_return_to_usermode
diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index a2dddcc189f6..c8891d3b38d3 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -92,6 +92,7 @@ endif
 endif
 
 $(vobjs): KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_LTO) $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS),$(KBUILD_CFLAGS)) $(CFL)
+$(vobjs): KBUILD_AFLAGS += -DBUILD_VDSO
 
 #
 # vDSO code runs in userspace and -pg doesn't help with profiling anyway.
diff --git a/arch/x86/entry/vsyscall/vsyscall_emu_64.S b/arch/x86/entry/vsyscall/vsyscall_emu_64.S
index 15e35159ebb6..ef2dd1827243 100644
--- a/arch/x86/entry/vsyscall/vsyscall_emu_64.S
+++ b/arch/x86/entry/vsyscall/vsyscall_emu_64.S
@@ -19,17 +19,20 @@ __vsyscall_page:
 
 	mov $__NR_gettimeofday, %rax
 	syscall
-	RET
+	ret
+	int3
 
 	.balign 1024, 0xcc
 	mov $__NR_time, %rax
 	syscall
-	RET
+	ret
+	int3
 
 	.balign 1024, 0xcc
 	mov $__NR_getcpu, %rax
 	syscall
-	RET
+	ret
+	int3
 
 	.balign 4096, 0xcc
 
diff --git a/arch/x86/include/asm/GEN-for-each-reg.h b/arch/x86/include/asm/GEN-for-each-reg.h
index 1b07fb102c4e..07949102a08d 100644
--- a/arch/x86/include/asm/GEN-for-each-reg.h
+++ b/arch/x86/include/asm/GEN-for-each-reg.h
@@ -1,11 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * These are in machine order; things rely on that.
+ */
 #ifdef CONFIG_64BIT
 GEN(rax)
-GEN(rbx)
 GEN(rcx)
 GEN(rdx)
+GEN(rbx)
+GEN(rsp)
+GEN(rbp)
 GEN(rsi)
 GEN(rdi)
-GEN(rbp)
 GEN(r8)
 GEN(r9)
 GEN(r10)
@@ -16,10 +21,11 @@ GEN(r14)
 GEN(r15)
 #else
 GEN(eax)
-GEN(ebx)
 GEN(ecx)
 GEN(edx)
+GEN(ebx)
+GEN(esp)
+GEN(ebp)
 GEN(esi)
 GEN(edi)
-GEN(ebp)
 #endif
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index a3c2315aca12..a364971967c4 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -75,6 +75,8 @@ extern int alternatives_patched;
 
 extern void alternative_instructions(void);
 extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
+extern void apply_retpolines(s32 *start, s32 *end);
+extern void apply_returns(s32 *start, s32 *end);
 
 struct module;
 
diff --git a/arch/x86/include/asm/asm-prototypes.h b/arch/x86/include/asm/asm-prototypes.h
index 4cb726c71ed8..8f80de627c60 100644
--- a/arch/x86/include/asm/asm-prototypes.h
+++ b/arch/x86/include/asm/asm-prototypes.h
@@ -17,21 +17,3 @@
 extern void cmpxchg8b_emu(void);
 #endif
 
-#ifdef CONFIG_RETPOLINE
-
-#undef GEN
-#define GEN(reg) \
-	extern asmlinkage void __x86_indirect_thunk_ ## reg (void);
-#include <asm/GEN-for-each-reg.h>
-
-#undef GEN
-#define GEN(reg) \
-	extern asmlinkage void __x86_indirect_alt_call_ ## reg (void);
-#include <asm/GEN-for-each-reg.h>
-
-#undef GEN
-#define GEN(reg) \
-	extern asmlinkage void __x86_indirect_alt_jmp_ ## reg (void);
-#include <asm/GEN-for-each-reg.h>
-
-#endif /* CONFIG_RETPOLINE */
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index b258efa8bf43..3781a7f489ef 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -203,8 +203,8 @@
 #define X86_FEATURE_PROC_FEEDBACK	( 7*32+ 9) /* AMD ProcFeedbackInterface */
 /* FREE!                                ( 7*32+10) */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
-#define X86_FEATURE_RETPOLINE		( 7*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
-#define X86_FEATURE_RETPOLINE_LFENCE	( 7*32+13) /* "" Use LFENCE for Spectre variant 2 */
+#define X86_FEATURE_KERNEL_IBRS		( 7*32+12) /* "" Set/clear IBRS on kernel entry/exit */
+#define X86_FEATURE_RSB_VMEXIT		( 7*32+13) /* "" Fill RSB on VM-Exit */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_CDP_L2		( 7*32+15) /* Code and Data Prioritization L2 */
 #define X86_FEATURE_MSR_SPEC_CTRL	( 7*32+16) /* "" MSR SPEC_CTRL is implemented */
@@ -294,6 +294,12 @@
 #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
 #define X86_FEATURE_SGX1		(11*32+ 8) /* "" Basic SGX */
 #define X86_FEATURE_SGX2		(11*32+ 9) /* "" SGX Enclave Dynamic Memory Management (EDMM) */
+#define X86_FEATURE_ENTRY_IBPB		(11*32+10) /* "" Issue an IBPB on kernel entry */
+#define X86_FEATURE_RRSBA_CTRL		(11*32+11) /* "" RET prediction control */
+#define X86_FEATURE_RETPOLINE		(11*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
+#define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
+#define X86_FEATURE_RETHUNK		(11*32+14) /* "" Use REturn THUNK */
+#define X86_FEATURE_UNRET		(11*32+15) /* "" AMD BTB untrain return */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
@@ -313,6 +319,7 @@
 #define X86_FEATURE_AMD_SSBD		(13*32+24) /* "" Speculative Store Bypass Disable */
 #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* Virtualized Speculative Store Bypass Disable */
 #define X86_FEATURE_AMD_SSB_NO		(13*32+26) /* "" Speculative Store Bypass is fixed in hardware. */
+#define X86_FEATURE_BTC_NO		(13*32+29) /* "" Not vulnerable to Branch Type Confusion */
 
 /* Thermal and Power Management Leaf, CPUID level 0x00000006 (EAX), word 14 */
 #define X86_FEATURE_DTHERM		(14*32+ 0) /* Digital Thermal Sensor */
@@ -437,5 +444,6 @@
 #define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
+#define X86_BUG_RETBLEED		X86_BUG(26) /* CPU is affected by RETBleed */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 8f28fafa98b3..834a3b6d81e1 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -56,6 +56,25 @@
 # define DISABLE_PTI		(1 << (X86_FEATURE_PTI & 31))
 #endif
 
+#ifdef CONFIG_RETPOLINE
+# define DISABLE_RETPOLINE	0
+#else
+# define DISABLE_RETPOLINE	((1 << (X86_FEATURE_RETPOLINE & 31)) | \
+				 (1 << (X86_FEATURE_RETPOLINE_LFENCE & 31)))
+#endif
+
+#ifdef CONFIG_RETHUNK
+# define DISABLE_RETHUNK	0
+#else
+# define DISABLE_RETHUNK	(1 << (X86_FEATURE_RETHUNK & 31))
+#endif
+
+#ifdef CONFIG_CPU_UNRET_ENTRY
+# define DISABLE_UNRET		0
+#else
+# define DISABLE_UNRET		(1 << (X86_FEATURE_UNRET & 31))
+#endif
+
 /* Force disable because it's broken beyond repair */
 #define DISABLE_ENQCMD		(1 << (X86_FEATURE_ENQCMD & 31))
 
@@ -79,7 +98,7 @@
 #define DISABLED_MASK8	0
 #define DISABLED_MASK9	(DISABLE_SMAP|DISABLE_SGX)
 #define DISABLED_MASK10	0
-#define DISABLED_MASK11	0
+#define DISABLED_MASK11	(DISABLE_RETPOLINE|DISABLE_RETHUNK|DISABLE_UNRET)
 #define DISABLED_MASK12	0
 #define DISABLED_MASK13	0
 #define DISABLED_MASK14	0
diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index 030907922bd0..5000cf59bdf5 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -18,19 +18,27 @@
 #define __ALIGN_STR	__stringify(__ALIGN)
 #endif
 
+#if defined(CONFIG_RETHUNK) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
+#define RET	jmp __x86_return_thunk
+#else /* CONFIG_RETPOLINE */
 #ifdef CONFIG_SLS
 #define RET	ret; int3
 #else
 #define RET	ret
 #endif
+#endif /* CONFIG_RETPOLINE */
 
 #else /* __ASSEMBLY__ */
 
+#if defined(CONFIG_RETHUNK) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
+#define ASM_RET	"jmp __x86_return_thunk\n\t"
+#else /* CONFIG_RETPOLINE */
 #ifdef CONFIG_SLS
 #define ASM_RET	"ret; int3\n\t"
 #else
 #define ASM_RET	"ret\n\t"
 #endif
+#endif /* CONFIG_RETPOLINE */
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 7dc5a3306f37..ec2967e7249f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -51,6 +51,8 @@
 #define SPEC_CTRL_STIBP			BIT(SPEC_CTRL_STIBP_SHIFT)	/* STIBP mask */
 #define SPEC_CTRL_SSBD_SHIFT		2	   /* Speculative Store Bypass Disable bit */
 #define SPEC_CTRL_SSBD			BIT(SPEC_CTRL_SSBD_SHIFT)	/* Speculative Store Bypass Disable */
+#define SPEC_CTRL_RRSBA_DIS_S_SHIFT	6	   /* Disable RRSBA behavior */
+#define SPEC_CTRL_RRSBA_DIS_S		BIT(SPEC_CTRL_RRSBA_DIS_S_SHIFT)
 
 #define MSR_IA32_PRED_CMD		0x00000049 /* Prediction Command */
 #define PRED_CMD_IBPB			BIT(0)	   /* Indirect Branch Prediction Barrier */
@@ -91,6 +93,7 @@
 #define MSR_IA32_ARCH_CAPABILITIES	0x0000010a
 #define ARCH_CAP_RDCL_NO		BIT(0)	/* Not susceptible to Meltdown */
 #define ARCH_CAP_IBRS_ALL		BIT(1)	/* Enhanced IBRS support */
+#define ARCH_CAP_RSBA			BIT(2)	/* RET may use alternative branch predictors */
 #define ARCH_CAP_SKIP_VMENTRY_L1DFLUSH	BIT(3)	/* Skip L1D flush on vmentry */
 #define ARCH_CAP_SSB_NO			BIT(4)	/*
 						 * Not susceptible to Speculative Store Bypass
@@ -138,6 +141,13 @@
 						 * bit available to control VERW
 						 * behavior.
 						 */
+#define ARCH_CAP_RRSBA			BIT(19)	/*
+						 * Indicates RET may use predictors
+						 * other than the RSB. With eIBRS
+						 * enabled predictions in kernel mode
+						 * are restricted to targets in
+						 * kernel.
+						 */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
@@ -514,6 +524,9 @@
 /* Fam 17h MSRs */
 #define MSR_F17H_IRPERF			0xc00000e9
 
+#define MSR_ZEN2_SPECTRAL_CHICKEN	0xc00110e3
+#define MSR_ZEN2_SPECTRAL_CHICKEN_BIT	BIT_ULL(1)
+
 /* Fam 16h MSRs */
 #define MSR_F16H_L2I_PERF_CTL		0xc0010230
 #define MSR_F16H_L2I_PERF_CTR		0xc0010231
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 9783c6b08886..0a87b2bc4ef9 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -5,11 +5,15 @@
 
 #include <linux/static_key.h>
 #include <linux/objtool.h>
+#include <linux/linkage.h>
 
 #include <asm/alternative.h>
 #include <asm/cpufeatures.h>
 #include <asm/msr-index.h>
 #include <asm/unwind_hints.h>
+#include <asm/percpu.h>
+
+#define RETPOLINE_THUNK_SIZE	32
 
 /*
  * Fill the CPU return stack buffer.
@@ -72,6 +76,23 @@
 	.popsection
 .endm
 
+/*
+ * (ab)use RETPOLINE_SAFE on RET to annotate away 'bare' RET instructions
+ * vs RETBleed validation.
+ */
+#define ANNOTATE_UNRET_SAFE ANNOTATE_RETPOLINE_SAFE
+
+/*
+ * Abuse ANNOTATE_RETPOLINE_SAFE on a NOP to indicate UNRET_END, should
+ * eventually turn into it's own annotation.
+ */
+.macro ANNOTATE_UNRET_END
+#ifdef CONFIG_DEBUG_ENTRY
+	ANNOTATE_RETPOLINE_SAFE
+	nop
+#endif
+.endm
+
 /*
  * JMP_NOSPEC and CALL_NOSPEC macros can be used instead of a simple
  * indirect jmp/call which may be susceptible to the Spectre variant 2
@@ -102,10 +123,34 @@
   * monstrosity above, manually.
   */
 .macro FILL_RETURN_BUFFER reg:req nr:req ftr:req
-#ifdef CONFIG_RETPOLINE
 	ALTERNATIVE "jmp .Lskip_rsb_\@", "", \ftr
 	__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP)
 .Lskip_rsb_\@:
+.endm
+
+#ifdef CONFIG_CPU_UNRET_ENTRY
+#define CALL_ZEN_UNTRAIN_RET	"call zen_untrain_ret"
+#else
+#define CALL_ZEN_UNTRAIN_RET	""
+#endif
+
+/*
+ * Mitigate RETBleed for AMD/Hygon Zen uarch. Requires KERNEL CR3 because the
+ * return thunk isn't mapped into the userspace tables (then again, AMD
+ * typically has NO_MELTDOWN).
+ *
+ * While zen_untrain_ret() doesn't clobber anything but requires stack,
+ * entry_ibpb() will clobber AX, CX, DX.
+ *
+ * As such, this must be placed after every *SWITCH_TO_KERNEL_CR3 at a point
+ * where we have a stack but before any RET instruction.
+ */
+.macro UNTRAIN_RET
+#if defined(CONFIG_CPU_UNRET_ENTRY) || defined(CONFIG_CPU_IBPB_ENTRY)
+	ANNOTATE_UNRET_END
+	ALTERNATIVE_2 "",						\
+	              CALL_ZEN_UNTRAIN_RET, X86_FEATURE_UNRET,		\
+		      "call entry_ibpb", X86_FEATURE_ENTRY_IBPB
 #endif
 .endm
 
@@ -117,7 +162,21 @@
 	_ASM_PTR " 999b\n\t"					\
 	".popsection\n\t"
 
+extern void __x86_return_thunk(void);
+extern void zen_untrain_ret(void);
+extern void entry_ibpb(void);
+
 #ifdef CONFIG_RETPOLINE
+
+typedef u8 retpoline_thunk_t[RETPOLINE_THUNK_SIZE];
+
+#define GEN(reg) \
+	extern retpoline_thunk_t __x86_indirect_thunk_ ## reg;
+#include <asm/GEN-for-each-reg.h>
+#undef GEN
+
+extern retpoline_thunk_t __x86_indirect_thunk_array[];
+
 #ifdef CONFIG_X86_64
 
 /*
@@ -180,6 +239,7 @@ enum spectre_v2_mitigation {
 	SPECTRE_V2_EIBRS,
 	SPECTRE_V2_EIBRS_RETPOLINE,
 	SPECTRE_V2_EIBRS_LFENCE,
+	SPECTRE_V2_IBRS,
 };
 
 /* The indirect branch speculation control variants */
@@ -222,6 +282,9 @@ static inline void indirect_branch_prediction_barrier(void)
 
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
+DECLARE_PER_CPU(u64, x86_spec_ctrl_current);
+extern void write_spec_ctrl_current(u64 val, bool force);
+extern u64 spec_ctrl_current(void);
 
 /*
  * With retpoline, we must use IBRS to restrict branch prediction
@@ -231,18 +294,16 @@ extern u64 x86_spec_ctrl_base;
  */
 #define firmware_restrict_branch_speculation_start()			\
 do {									\
-	u64 val = x86_spec_ctrl_base | SPEC_CTRL_IBRS;			\
-									\
 	preempt_disable();						\
-	alternative_msr_write(MSR_IA32_SPEC_CTRL, val,			\
+	alternative_msr_write(MSR_IA32_SPEC_CTRL,			\
+			      spec_ctrl_current() | SPEC_CTRL_IBRS,	\
 			      X86_FEATURE_USE_IBRS_FW);			\
 } while (0)
 
 #define firmware_restrict_branch_speculation_end()			\
 do {									\
-	u64 val = x86_spec_ctrl_base;					\
-									\
-	alternative_msr_write(MSR_IA32_SPEC_CTRL, val,			\
+	alternative_msr_write(MSR_IA32_SPEC_CTRL,			\
+			      spec_ctrl_current(),			\
 			      X86_FEATURE_USE_IBRS_FW);			\
 	preempt_enable();						\
 } while (0)
@@ -307,63 +368,4 @@ static inline void mds_idle_clear_cpu_buffers(void)
 
 #endif /* __ASSEMBLY__ */
 
-/*
- * Below is used in the eBPF JIT compiler and emits the byte sequence
- * for the following assembly:
- *
- * With retpolines configured:
- *
- *    callq do_rop
- *  spec_trap:
- *    pause
- *    lfence
- *    jmp spec_trap
- *  do_rop:
- *    mov %rcx,(%rsp) for x86_64
- *    mov %edx,(%esp) for x86_32
- *    retq
- *
- * Without retpolines configured:
- *
- *    jmp *%rcx for x86_64
- *    jmp *%edx for x86_32
- */
-#ifdef CONFIG_RETPOLINE
-# ifdef CONFIG_X86_64
-#  define RETPOLINE_RCX_BPF_JIT_SIZE	17
-#  define RETPOLINE_RCX_BPF_JIT()				\
-do {								\
-	EMIT1_off32(0xE8, 7);	 /* callq do_rop */		\
-	/* spec_trap: */					\
-	EMIT2(0xF3, 0x90);       /* pause */			\
-	EMIT3(0x0F, 0xAE, 0xE8); /* lfence */			\
-	EMIT2(0xEB, 0xF9);       /* jmp spec_trap */		\
-	/* do_rop: */						\
-	EMIT4(0x48, 0x89, 0x0C, 0x24); /* mov %rcx,(%rsp) */	\
-	EMIT1(0xC3);             /* retq */			\
-} while (0)
-# else /* !CONFIG_X86_64 */
-#  define RETPOLINE_EDX_BPF_JIT()				\
-do {								\
-	EMIT1_off32(0xE8, 7);	 /* call do_rop */		\
-	/* spec_trap: */					\
-	EMIT2(0xF3, 0x90);       /* pause */			\
-	EMIT3(0x0F, 0xAE, 0xE8); /* lfence */			\
-	EMIT2(0xEB, 0xF9);       /* jmp spec_trap */		\
-	/* do_rop: */						\
-	EMIT3(0x89, 0x14, 0x24); /* mov %edx,(%esp) */		\
-	EMIT1(0xC3);             /* ret */			\
-} while (0)
-# endif
-#else /* !CONFIG_RETPOLINE */
-# ifdef CONFIG_X86_64
-#  define RETPOLINE_RCX_BPF_JIT_SIZE	2
-#  define RETPOLINE_RCX_BPF_JIT()				\
-	EMIT2(0xFF, 0xE1);       /* jmp *%rcx */
-# else /* !CONFIG_X86_64 */
-#  define RETPOLINE_EDX_BPF_JIT()				\
-	EMIT2(0xFF, 0xE2)        /* jmp *%edx */
-# endif
-#endif
-
 #endif /* _ASM_X86_NOSPEC_BRANCH_H_ */
diff --git a/arch/x86/include/asm/static_call.h b/arch/x86/include/asm/static_call.h
index 343234569392..491aadfac611 100644
--- a/arch/x86/include/asm/static_call.h
+++ b/arch/x86/include/asm/static_call.h
@@ -21,6 +21,16 @@
  * relative displacement across sections.
  */
 
+/*
+ * The trampoline is 8 bytes and of the general form:
+ *
+ *   jmp.d32 \func
+ *   ud1 %esp, %ecx
+ *
+ * That trailing #UD provides both a speculation stop and serves as a unique
+ * 3 byte signature identifying static call trampolines. Also see tramp_ud[]
+ * and __static_call_fixup().
+ */
 #define __ARCH_DEFINE_STATIC_CALL_TRAMP(name, insns)			\
 	asm(".pushsection .static_call.text, \"ax\"		\n"	\
 	    ".align 4						\n"	\
@@ -34,8 +44,13 @@
 #define ARCH_DEFINE_STATIC_CALL_TRAMP(name, func)			\
 	__ARCH_DEFINE_STATIC_CALL_TRAMP(name, ".byte 0xe9; .long " #func " - (. + 4)")
 
+#ifdef CONFIG_RETHUNK
+#define ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)			\
+	__ARCH_DEFINE_STATIC_CALL_TRAMP(name, "jmp __x86_return_thunk")
+#else
 #define ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)			\
 	__ARCH_DEFINE_STATIC_CALL_TRAMP(name, "ret; int3; nop; nop; nop")
+#endif
 
 
 #define ARCH_ADD_TRAMP_KEY(name)					\
@@ -44,4 +59,6 @@
 	    ".long " STATIC_CALL_KEY_STR(name) " - .		\n"	\
 	    ".popsection					\n")
 
+extern bool __static_call_fixup(void *tramp, u8 op, void *dest);
+
 #endif /* _ASM_STATIC_CALL_H */
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 6221be7cafc3..1cdd7e8bcba7 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -13,7 +13,7 @@
 #ifdef CONFIG_X86_64
 asmlinkage __visible notrace struct pt_regs *sync_regs(struct pt_regs *eregs);
 asmlinkage __visible notrace
-struct bad_iret_stack *fixup_bad_iret(struct bad_iret_stack *s);
+struct pt_regs *fixup_bad_iret(struct pt_regs *bad_regs);
 void __init trap_init(void);
 asmlinkage __visible noinstr struct pt_regs *vc_switch_off_ist(struct pt_regs *eregs);
 #endif
diff --git a/arch/x86/include/asm/unwind_hints.h b/arch/x86/include/asm/unwind_hints.h
index 8e574c0afef8..56664b31b6da 100644
--- a/arch/x86/include/asm/unwind_hints.h
+++ b/arch/x86/include/asm/unwind_hints.h
@@ -8,7 +8,11 @@
 #ifdef __ASSEMBLY__
 
 .macro UNWIND_HINT_EMPTY
-	UNWIND_HINT sp_reg=ORC_REG_UNDEFINED type=UNWIND_HINT_TYPE_CALL end=1
+	UNWIND_HINT type=UNWIND_HINT_TYPE_CALL end=1
+.endm
+
+.macro UNWIND_HINT_ENTRY
+	UNWIND_HINT type=UNWIND_HINT_TYPE_ENTRY end=1
 .endm
 
 .macro UNWIND_HINT_REGS base=%rsp offset=0 indirect=0 extra=1 partial=0
@@ -52,6 +56,14 @@
 	UNWIND_HINT sp_reg=ORC_REG_SP sp_offset=8 type=UNWIND_HINT_TYPE_FUNC
 .endm
 
+.macro UNWIND_HINT_SAVE
+	UNWIND_HINT type=UNWIND_HINT_TYPE_SAVE
+.endm
+
+.macro UNWIND_HINT_RESTORE
+	UNWIND_HINT type=UNWIND_HINT_TYPE_RESTORE
+.endm
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_UNWIND_HINTS_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index ae0f718b8ebb..8ed9ccf53b62 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -29,6 +29,7 @@
 #include <asm/io.h>
 #include <asm/fixmap.h>
 #include <asm/paravirt.h>
+#include <asm/asm-prototypes.h>
 
 int __read_mostly alternatives_patched;
 
@@ -113,6 +114,8 @@ static void __init_or_module add_nops(void *insns, unsigned int len)
 	}
 }
 
+extern s32 __retpoline_sites[], __retpoline_sites_end[];
+extern s32 __return_sites[], __return_sites_end[];
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern s32 __smp_locks[], __smp_locks_end[];
 void text_poke_early(void *addr, const void *opcode, size_t len);
@@ -221,7 +224,7 @@ static __always_inline int optimize_nops_range(u8 *instr, u8 instrlen, int off)
  * "noinline" to cause control flow change and thus invalidate I$ and
  * cause refetch after modification.
  */
-static void __init_or_module noinline optimize_nops(struct alt_instr *a, u8 *instr)
+static void __init_or_module noinline optimize_nops(u8 *instr, size_t len)
 {
 	struct insn insn;
 	int i = 0;
@@ -239,11 +242,11 @@ static void __init_or_module noinline optimize_nops(struct alt_instr *a, u8 *ins
 		 * optimized.
 		 */
 		if (insn.length == 1 && insn.opcode.bytes[0] == 0x90)
-			i += optimize_nops_range(instr, a->instrlen, i);
+			i += optimize_nops_range(instr, len, i);
 		else
 			i += insn.length;
 
-		if (i >= a->instrlen)
+		if (i >= len)
 			return;
 	}
 }
@@ -331,10 +334,252 @@ void __init_or_module noinline apply_alternatives(struct alt_instr *start,
 		text_poke_early(instr, insn_buff, insn_buff_sz);
 
 next:
-		optimize_nops(a, instr);
+		optimize_nops(instr, a->instrlen);
 	}
 }
 
+#if defined(CONFIG_RETPOLINE) && defined(CONFIG_STACK_VALIDATION)
+
+/*
+ * CALL/JMP *%\reg
+ */
+static int emit_indirect(int op, int reg, u8 *bytes)
+{
+	int i = 0;
+	u8 modrm;
+
+	switch (op) {
+	case CALL_INSN_OPCODE:
+		modrm = 0x10; /* Reg = 2; CALL r/m */
+		break;
+
+	case JMP32_INSN_OPCODE:
+		modrm = 0x20; /* Reg = 4; JMP r/m */
+		break;
+
+	default:
+		WARN_ON_ONCE(1);
+		return -1;
+	}
+
+	if (reg >= 8) {
+		bytes[i++] = 0x41; /* REX.B prefix */
+		reg -= 8;
+	}
+
+	modrm |= 0xc0; /* Mod = 3 */
+	modrm += reg;
+
+	bytes[i++] = 0xff; /* opcode */
+	bytes[i++] = modrm;
+
+	return i;
+}
+
+/*
+ * Rewrite the compiler generated retpoline thunk calls.
+ *
+ * For spectre_v2=off (!X86_FEATURE_RETPOLINE), rewrite them into immediate
+ * indirect instructions, avoiding the extra indirection.
+ *
+ * For example, convert:
+ *
+ *   CALL __x86_indirect_thunk_\reg
+ *
+ * into:
+ *
+ *   CALL *%\reg
+ *
+ * It also tries to inline spectre_v2=retpoline,amd when size permits.
+ */
+static int patch_retpoline(void *addr, struct insn *insn, u8 *bytes)
+{
+	retpoline_thunk_t *target;
+	int reg, ret, i = 0;
+	u8 op, cc;
+
+	target = addr + insn->length + insn->immediate.value;
+	reg = target - __x86_indirect_thunk_array;
+
+	if (WARN_ON_ONCE(reg & ~0xf))
+		return -1;
+
+	/* If anyone ever does: CALL/JMP *%rsp, we're in deep trouble. */
+	BUG_ON(reg == 4);
+
+	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE) &&
+	    !cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE))
+		return -1;
+
+	op = insn->opcode.bytes[0];
+
+	/*
+	 * Convert:
+	 *
+	 *   Jcc.d32 __x86_indirect_thunk_\reg
+	 *
+	 * into:
+	 *
+	 *   Jncc.d8 1f
+	 *   [ LFENCE ]
+	 *   JMP *%\reg
+	 *   [ NOP ]
+	 * 1:
+	 */
+	/* Jcc.d32 second opcode byte is in the range: 0x80-0x8f */
+	if (op == 0x0f && (insn->opcode.bytes[1] & 0xf0) == 0x80) {
+		cc = insn->opcode.bytes[1] & 0xf;
+		cc ^= 1; /* invert condition */
+
+		bytes[i++] = 0x70 + cc;        /* Jcc.d8 */
+		bytes[i++] = insn->length - 2; /* sizeof(Jcc.d8) == 2 */
+
+		/* Continue as if: JMP.d32 __x86_indirect_thunk_\reg */
+		op = JMP32_INSN_OPCODE;
+	}
+
+	/*
+	 * For RETPOLINE_AMD: prepend the indirect CALL/JMP with an LFENCE.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE)) {
+		bytes[i++] = 0x0f;
+		bytes[i++] = 0xae;
+		bytes[i++] = 0xe8; /* LFENCE */
+	}
+
+	ret = emit_indirect(op, reg, bytes + i);
+	if (ret < 0)
+		return ret;
+	i += ret;
+
+	for (; i < insn->length;)
+		bytes[i++] = BYTES_NOP1;
+
+	return i;
+}
+
+/*
+ * Generated by 'objtool --retpoline'.
+ */
+void __init_or_module noinline apply_retpolines(s32 *start, s32 *end)
+{
+	s32 *s;
+
+	for (s = start; s < end; s++) {
+		void *addr = (void *)s + *s;
+		struct insn insn;
+		int len, ret;
+		u8 bytes[16];
+		u8 op1, op2;
+
+		ret = insn_decode_kernel(&insn, addr);
+		if (WARN_ON_ONCE(ret < 0))
+			continue;
+
+		op1 = insn.opcode.bytes[0];
+		op2 = insn.opcode.bytes[1];
+
+		switch (op1) {
+		case CALL_INSN_OPCODE:
+		case JMP32_INSN_OPCODE:
+			break;
+
+		case 0x0f: /* escape */
+			if (op2 >= 0x80 && op2 <= 0x8f)
+				break;
+			fallthrough;
+		default:
+			WARN_ON_ONCE(1);
+			continue;
+		}
+
+		DPRINTK("retpoline at: %pS (%px) len: %d to: %pS",
+			addr, addr, insn.length,
+			addr + insn.length + insn.immediate.value);
+
+		len = patch_retpoline(addr, &insn, bytes);
+		if (len == insn.length) {
+			optimize_nops(bytes, len);
+			DUMP_BYTES(((u8*)addr),  len, "%px: orig: ", addr);
+			DUMP_BYTES(((u8*)bytes), len, "%px: repl: ", addr);
+			text_poke_early(addr, bytes, len);
+		}
+	}
+}
+
+#ifdef CONFIG_RETHUNK
+/*
+ * Rewrite the compiler generated return thunk tail-calls.
+ *
+ * For example, convert:
+ *
+ *   JMP __x86_return_thunk
+ *
+ * into:
+ *
+ *   RET
+ */
+static int patch_return(void *addr, struct insn *insn, u8 *bytes)
+{
+	int i = 0;
+
+	if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
+		return -1;
+
+	bytes[i++] = RET_INSN_OPCODE;
+
+	for (; i < insn->length;)
+		bytes[i++] = INT3_INSN_OPCODE;
+
+	return i;
+}
+
+void __init_or_module noinline apply_returns(s32 *start, s32 *end)
+{
+	s32 *s;
+
+	for (s = start; s < end; s++) {
+		void *dest = NULL, *addr = (void *)s + *s;
+		struct insn insn;
+		int len, ret;
+		u8 bytes[16];
+		u8 op;
+
+		ret = insn_decode_kernel(&insn, addr);
+		if (WARN_ON_ONCE(ret < 0))
+			continue;
+
+		op = insn.opcode.bytes[0];
+		if (op == JMP32_INSN_OPCODE)
+			dest = addr + insn.length + insn.immediate.value;
+
+		if (__static_call_fixup(addr, op, dest) ||
+		    WARN_ON_ONCE(dest != &__x86_return_thunk))
+			continue;
+
+		DPRINTK("return thunk at: %pS (%px) len: %d to: %pS",
+			addr, addr, insn.length,
+			addr + insn.length + insn.immediate.value);
+
+		len = patch_return(addr, &insn, bytes);
+		if (len == insn.length) {
+			DUMP_BYTES(((u8*)addr),  len, "%px: orig: ", addr);
+			DUMP_BYTES(((u8*)bytes), len, "%px: repl: ", addr);
+			text_poke_early(addr, bytes, len);
+		}
+	}
+}
+#else
+void __init_or_module noinline apply_returns(s32 *start, s32 *end) { }
+#endif /* CONFIG_RETHUNK */
+
+#else /* !RETPOLINES || !CONFIG_STACK_VALIDATION */
+
+void __init_or_module noinline apply_retpolines(s32 *start, s32 *end) { }
+void __init_or_module noinline apply_returns(s32 *start, s32 *end) { }
+
+#endif /* CONFIG_RETPOLINE && CONFIG_STACK_VALIDATION */
+
 #ifdef CONFIG_SMP
 static void alternatives_smp_lock(const s32 *start, const s32 *end,
 				  u8 *text, u8 *text_end)
@@ -642,6 +887,13 @@ void __init alternative_instructions(void)
 	 */
 	apply_paravirt(__parainstructions, __parainstructions_end);
 
+	/*
+	 * Rewrite the retpolines, must be done before alternatives since
+	 * those can rewrite the retpoline thunks.
+	 */
+	apply_retpolines(__retpoline_sites, __retpoline_sites_end);
+	apply_returns(__return_sites, __return_sites_end);
+
 	/*
 	 * Then patch alternatives, such that those paravirt calls that are in
 	 * alternatives can be overwritten by their immediate fragments.
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 4edb6f0f628c..8b1bf1c14fc3 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -886,6 +886,28 @@ static void init_amd_bd(struct cpuinfo_x86 *c)
 	clear_rdrand_cpuid_bit(c);
 }
 
+void init_spectral_chicken(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_CPU_UNRET_ENTRY
+	u64 value;
+
+	/*
+	 * On Zen2 we offer this chicken (bit) on the altar of Speculation.
+	 *
+	 * This suppresses speculation from the middle of a basic block, i.e. it
+	 * suppresses non-branch predictions.
+	 *
+	 * We use STIBP as a heuristic to filter out Zen2 from the rest of F17H
+	 */
+	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) && cpu_has(c, X86_FEATURE_AMD_STIBP)) {
+		if (!rdmsrl_safe(MSR_ZEN2_SPECTRAL_CHICKEN, &value)) {
+			value |= MSR_ZEN2_SPECTRAL_CHICKEN_BIT;
+			wrmsrl_safe(MSR_ZEN2_SPECTRAL_CHICKEN, value);
+		}
+	}
+#endif
+}
+
 static void init_amd_zn(struct cpuinfo_x86 *c)
 {
 	set_cpu_cap(c, X86_FEATURE_ZEN);
@@ -894,12 +916,21 @@ static void init_amd_zn(struct cpuinfo_x86 *c)
 	node_reclaim_distance = 32;
 #endif
 
-	/*
-	 * Fix erratum 1076: CPB feature bit not being set in CPUID.
-	 * Always set it, except when running under a hypervisor.
-	 */
-	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) && !cpu_has(c, X86_FEATURE_CPB))
-		set_cpu_cap(c, X86_FEATURE_CPB);
+	/* Fix up CPUID bits, but only if not virtualised. */
+	if (!cpu_has(c, X86_FEATURE_HYPERVISOR)) {
+
+		/* Erratum 1076: CPB feature bit not being set in CPUID. */
+		if (!cpu_has(c, X86_FEATURE_CPB))
+			set_cpu_cap(c, X86_FEATURE_CPB);
+
+		/*
+		 * Zen3 (Fam19 model < 0x10) parts are not susceptible to
+		 * Branch Type Confusion, but predate the allocation of the
+		 * BTC_NO bit.
+		 */
+		if (c->x86 == 0x19 && !cpu_has(c, X86_FEATURE_BTC_NO))
+			set_cpu_cap(c, X86_FEATURE_BTC_NO);
+	}
 }
 
 static void init_amd(struct cpuinfo_x86 *c)
@@ -931,7 +962,8 @@ static void init_amd(struct cpuinfo_x86 *c)
 	case 0x12: init_amd_ln(c); break;
 	case 0x15: init_amd_bd(c); break;
 	case 0x16: init_amd_jg(c); break;
-	case 0x17: fallthrough;
+	case 0x17: init_spectral_chicken(c);
+		   fallthrough;
 	case 0x19: init_amd_zn(c); break;
 	}
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 2c512ff2ee10..650333fce795 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -38,6 +38,8 @@
 
 static void __init spectre_v1_select_mitigation(void);
 static void __init spectre_v2_select_mitigation(void);
+static void __init retbleed_select_mitigation(void);
+static void __init spectre_v2_user_select_mitigation(void);
 static void __init ssb_select_mitigation(void);
 static void __init l1tf_select_mitigation(void);
 static void __init mds_select_mitigation(void);
@@ -48,16 +50,40 @@ static void __init mmio_select_mitigation(void);
 static void __init srbds_select_mitigation(void);
 static void __init l1d_flush_select_mitigation(void);
 
-/* The base value of the SPEC_CTRL MSR that always has to be preserved. */
+/* The base value of the SPEC_CTRL MSR without task-specific bits set */
 u64 x86_spec_ctrl_base;
 EXPORT_SYMBOL_GPL(x86_spec_ctrl_base);
+
+/* The current value of the SPEC_CTRL MSR with task-specific bits set */
+DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
+EXPORT_SYMBOL_GPL(x86_spec_ctrl_current);
+
 static DEFINE_MUTEX(spec_ctrl_mutex);
 
 /*
- * The vendor and possibly platform specific bits which can be modified in
- * x86_spec_ctrl_base.
+ * Keep track of the SPEC_CTRL MSR value for the current task, which may differ
+ * from x86_spec_ctrl_base due to STIBP/SSB in __speculation_ctrl_update().
  */
-static u64 __ro_after_init x86_spec_ctrl_mask = SPEC_CTRL_IBRS;
+void write_spec_ctrl_current(u64 val, bool force)
+{
+	if (this_cpu_read(x86_spec_ctrl_current) == val)
+		return;
+
+	this_cpu_write(x86_spec_ctrl_current, val);
+
+	/*
+	 * When KERNEL_IBRS this MSR is written on return-to-user, unless
+	 * forced the update can be delayed until that time.
+	 */
+	if (force || !cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS))
+		wrmsrl(MSR_IA32_SPEC_CTRL, val);
+}
+
+u64 spec_ctrl_current(void)
+{
+	return this_cpu_read(x86_spec_ctrl_current);
+}
+EXPORT_SYMBOL_GPL(spec_ctrl_current);
 
 /*
  * AMD specific MSR info for Speculative Store Bypass control.
@@ -114,13 +140,21 @@ void __init check_bugs(void)
 	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
 		rdmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
 
-	/* Allow STIBP in MSR_SPEC_CTRL if supported */
-	if (boot_cpu_has(X86_FEATURE_STIBP))
-		x86_spec_ctrl_mask |= SPEC_CTRL_STIBP;
-
 	/* Select the proper CPU mitigations before patching alternatives: */
 	spectre_v1_select_mitigation();
 	spectre_v2_select_mitigation();
+	/*
+	 * retbleed_select_mitigation() relies on the state set by
+	 * spectre_v2_select_mitigation(); specifically it wants to know about
+	 * spectre_v2=ibrs.
+	 */
+	retbleed_select_mitigation();
+	/*
+	 * spectre_v2_user_select_mitigation() relies on the state set by
+	 * retbleed_select_mitigation(); specifically the STIBP selection is
+	 * forced for UNRET.
+	 */
+	spectre_v2_user_select_mitigation();
 	ssb_select_mitigation();
 	l1tf_select_mitigation();
 	md_clear_select_mitigation();
@@ -161,31 +195,17 @@ void __init check_bugs(void)
 #endif
 }
 
+/*
+ * NOTE: For VMX, this function is not called in the vmexit path.
+ * It uses vmx_spec_ctrl_restore_host() instead.
+ */
 void
 x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
 {
-	u64 msrval, guestval, hostval = x86_spec_ctrl_base;
+	u64 msrval, guestval = guest_spec_ctrl, hostval = spec_ctrl_current();
 	struct thread_info *ti = current_thread_info();
 
-	/* Is MSR_SPEC_CTRL implemented ? */
 	if (static_cpu_has(X86_FEATURE_MSR_SPEC_CTRL)) {
-		/*
-		 * Restrict guest_spec_ctrl to supported values. Clear the
-		 * modifiable bits in the host base value and or the
-		 * modifiable bits from the guest value.
-		 */
-		guestval = hostval & ~x86_spec_ctrl_mask;
-		guestval |= guest_spec_ctrl & x86_spec_ctrl_mask;
-
-		/* SSBD controlled in MSR_SPEC_CTRL */
-		if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
-		    static_cpu_has(X86_FEATURE_AMD_SSBD))
-			hostval |= ssbd_tif_to_spec_ctrl(ti->flags);
-
-		/* Conditional STIBP enabled? */
-		if (static_branch_unlikely(&switch_to_cond_stibp))
-			hostval |= stibp_tif_to_spec_ctrl(ti->flags);
-
 		if (hostval != guestval) {
 			msrval = setguest ? guestval : hostval;
 			wrmsrl(MSR_IA32_SPEC_CTRL, msrval);
@@ -745,12 +765,180 @@ static int __init nospectre_v1_cmdline(char *str)
 }
 early_param("nospectre_v1", nospectre_v1_cmdline);
 
-#undef pr_fmt
-#define pr_fmt(fmt)     "Spectre V2 : " fmt
-
 static enum spectre_v2_mitigation spectre_v2_enabled __ro_after_init =
 	SPECTRE_V2_NONE;
 
+#undef pr_fmt
+#define pr_fmt(fmt)     "RETBleed: " fmt
+
+enum retbleed_mitigation {
+	RETBLEED_MITIGATION_NONE,
+	RETBLEED_MITIGATION_UNRET,
+	RETBLEED_MITIGATION_IBPB,
+	RETBLEED_MITIGATION_IBRS,
+	RETBLEED_MITIGATION_EIBRS,
+};
+
+enum retbleed_mitigation_cmd {
+	RETBLEED_CMD_OFF,
+	RETBLEED_CMD_AUTO,
+	RETBLEED_CMD_UNRET,
+	RETBLEED_CMD_IBPB,
+};
+
+const char * const retbleed_strings[] = {
+	[RETBLEED_MITIGATION_NONE]	= "Vulnerable",
+	[RETBLEED_MITIGATION_UNRET]	= "Mitigation: untrained return thunk",
+	[RETBLEED_MITIGATION_IBPB]	= "Mitigation: IBPB",
+	[RETBLEED_MITIGATION_IBRS]	= "Mitigation: IBRS",
+	[RETBLEED_MITIGATION_EIBRS]	= "Mitigation: Enhanced IBRS",
+};
+
+static enum retbleed_mitigation retbleed_mitigation __ro_after_init =
+	RETBLEED_MITIGATION_NONE;
+static enum retbleed_mitigation_cmd retbleed_cmd __ro_after_init =
+	RETBLEED_CMD_AUTO;
+
+static int __ro_after_init retbleed_nosmt = false;
+
+static int __init retbleed_parse_cmdline(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	while (str) {
+		char *next = strchr(str, ',');
+		if (next) {
+			*next = 0;
+			next++;
+		}
+
+		if (!strcmp(str, "off")) {
+			retbleed_cmd = RETBLEED_CMD_OFF;
+		} else if (!strcmp(str, "auto")) {
+			retbleed_cmd = RETBLEED_CMD_AUTO;
+		} else if (!strcmp(str, "unret")) {
+			retbleed_cmd = RETBLEED_CMD_UNRET;
+		} else if (!strcmp(str, "ibpb")) {
+			retbleed_cmd = RETBLEED_CMD_IBPB;
+		} else if (!strcmp(str, "nosmt")) {
+			retbleed_nosmt = true;
+		} else {
+			pr_err("Ignoring unknown retbleed option (%s).", str);
+		}
+
+		str = next;
+	}
+
+	return 0;
+}
+early_param("retbleed", retbleed_parse_cmdline);
+
+#define RETBLEED_UNTRAIN_MSG "WARNING: BTB untrained return thunk mitigation is only effective on AMD/Hygon!\n"
+#define RETBLEED_INTEL_MSG "WARNING: Spectre v2 mitigation leaves CPU vulnerable to RETBleed attacks, data leaks possible!\n"
+
+static void __init retbleed_select_mitigation(void)
+{
+	bool mitigate_smt = false;
+
+	if (!boot_cpu_has_bug(X86_BUG_RETBLEED) || cpu_mitigations_off())
+		return;
+
+	switch (retbleed_cmd) {
+	case RETBLEED_CMD_OFF:
+		return;
+
+	case RETBLEED_CMD_UNRET:
+		if (IS_ENABLED(CONFIG_CPU_UNRET_ENTRY)) {
+			retbleed_mitigation = RETBLEED_MITIGATION_UNRET;
+		} else {
+			pr_err("WARNING: kernel not compiled with CPU_UNRET_ENTRY.\n");
+			goto do_cmd_auto;
+		}
+		break;
+
+	case RETBLEED_CMD_IBPB:
+		if (!boot_cpu_has(X86_FEATURE_IBPB)) {
+			pr_err("WARNING: CPU does not support IBPB.\n");
+			goto do_cmd_auto;
+		} else if (IS_ENABLED(CONFIG_CPU_IBPB_ENTRY)) {
+			retbleed_mitigation = RETBLEED_MITIGATION_IBPB;
+		} else {
+			pr_err("WARNING: kernel not compiled with CPU_IBPB_ENTRY.\n");
+			goto do_cmd_auto;
+		}
+		break;
+
+do_cmd_auto:
+	case RETBLEED_CMD_AUTO:
+	default:
+		if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
+		    boot_cpu_data.x86_vendor == X86_VENDOR_HYGON) {
+			if (IS_ENABLED(CONFIG_CPU_UNRET_ENTRY))
+				retbleed_mitigation = RETBLEED_MITIGATION_UNRET;
+			else if (IS_ENABLED(CONFIG_CPU_IBPB_ENTRY) && boot_cpu_has(X86_FEATURE_IBPB))
+				retbleed_mitigation = RETBLEED_MITIGATION_IBPB;
+		}
+
+		/*
+		 * The Intel mitigation (IBRS or eIBRS) was already selected in
+		 * spectre_v2_select_mitigation().  'retbleed_mitigation' will
+		 * be set accordingly below.
+		 */
+
+		break;
+	}
+
+	switch (retbleed_mitigation) {
+	case RETBLEED_MITIGATION_UNRET:
+		setup_force_cpu_cap(X86_FEATURE_RETHUNK);
+		setup_force_cpu_cap(X86_FEATURE_UNRET);
+
+		if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
+		    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
+			pr_err(RETBLEED_UNTRAIN_MSG);
+
+		mitigate_smt = true;
+		break;
+
+	case RETBLEED_MITIGATION_IBPB:
+		setup_force_cpu_cap(X86_FEATURE_ENTRY_IBPB);
+		mitigate_smt = true;
+		break;
+
+	default:
+		break;
+	}
+
+	if (mitigate_smt && !boot_cpu_has(X86_FEATURE_STIBP) &&
+	    (retbleed_nosmt || cpu_mitigations_auto_nosmt()))
+		cpu_smt_disable(false);
+
+	/*
+	 * Let IBRS trump all on Intel without affecting the effects of the
+	 * retbleed= cmdline option.
+	 */
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) {
+		switch (spectre_v2_enabled) {
+		case SPECTRE_V2_IBRS:
+			retbleed_mitigation = RETBLEED_MITIGATION_IBRS;
+			break;
+		case SPECTRE_V2_EIBRS:
+		case SPECTRE_V2_EIBRS_RETPOLINE:
+		case SPECTRE_V2_EIBRS_LFENCE:
+			retbleed_mitigation = RETBLEED_MITIGATION_EIBRS;
+			break;
+		default:
+			pr_err(RETBLEED_INTEL_MSG);
+		}
+	}
+
+	pr_info("%s\n", retbleed_strings[retbleed_mitigation]);
+}
+
+#undef pr_fmt
+#define pr_fmt(fmt)     "Spectre V2 : " fmt
+
 static enum spectre_v2_user_mitigation spectre_v2_user_stibp __ro_after_init =
 	SPECTRE_V2_USER_NONE;
 static enum spectre_v2_user_mitigation spectre_v2_user_ibpb __ro_after_init =
@@ -821,6 +1009,7 @@ enum spectre_v2_mitigation_cmd {
 	SPECTRE_V2_CMD_EIBRS,
 	SPECTRE_V2_CMD_EIBRS_RETPOLINE,
 	SPECTRE_V2_CMD_EIBRS_LFENCE,
+	SPECTRE_V2_CMD_IBRS,
 };
 
 enum spectre_v2_user_cmd {
@@ -861,13 +1050,15 @@ static void __init spec_v2_user_print_cond(const char *reason, bool secure)
 		pr_info("spectre_v2_user=%s forced on command line.\n", reason);
 }
 
+static __ro_after_init enum spectre_v2_mitigation_cmd spectre_v2_cmd;
+
 static enum spectre_v2_user_cmd __init
-spectre_v2_parse_user_cmdline(enum spectre_v2_mitigation_cmd v2_cmd)
+spectre_v2_parse_user_cmdline(void)
 {
 	char arg[20];
 	int ret, i;
 
-	switch (v2_cmd) {
+	switch (spectre_v2_cmd) {
 	case SPECTRE_V2_CMD_NONE:
 		return SPECTRE_V2_USER_CMD_NONE;
 	case SPECTRE_V2_CMD_FORCE:
@@ -893,15 +1084,16 @@ spectre_v2_parse_user_cmdline(enum spectre_v2_mitigation_cmd v2_cmd)
 	return SPECTRE_V2_USER_CMD_AUTO;
 }
 
-static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
+static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
 {
-	return (mode == SPECTRE_V2_EIBRS ||
-		mode == SPECTRE_V2_EIBRS_RETPOLINE ||
-		mode == SPECTRE_V2_EIBRS_LFENCE);
+	return mode == SPECTRE_V2_IBRS ||
+	       mode == SPECTRE_V2_EIBRS ||
+	       mode == SPECTRE_V2_EIBRS_RETPOLINE ||
+	       mode == SPECTRE_V2_EIBRS_LFENCE;
 }
 
 static void __init
-spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
+spectre_v2_user_select_mitigation(void)
 {
 	enum spectre_v2_user_mitigation mode = SPECTRE_V2_USER_NONE;
 	bool smt_possible = IS_ENABLED(CONFIG_SMP);
@@ -914,7 +1106,7 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 	    cpu_smt_control == CPU_SMT_NOT_SUPPORTED)
 		smt_possible = false;
 
-	cmd = spectre_v2_parse_user_cmdline(v2_cmd);
+	cmd = spectre_v2_parse_user_cmdline();
 	switch (cmd) {
 	case SPECTRE_V2_USER_CMD_NONE:
 		goto set_mode;
@@ -962,12 +1154,12 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 	}
 
 	/*
-	 * If no STIBP, enhanced IBRS is enabled or SMT impossible, STIBP is not
-	 * required.
+	 * If no STIBP, IBRS or enhanced IBRS is enabled, or SMT impossible,
+	 * STIBP is not required.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_STIBP) ||
 	    !smt_possible ||
-	    spectre_v2_in_eibrs_mode(spectre_v2_enabled))
+	    spectre_v2_in_ibrs_mode(spectre_v2_enabled))
 		return;
 
 	/*
@@ -979,6 +1171,13 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 	    boot_cpu_has(X86_FEATURE_AMD_STIBP_ALWAYS_ON))
 		mode = SPECTRE_V2_USER_STRICT_PREFERRED;
 
+	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET) {
+		if (mode != SPECTRE_V2_USER_STRICT &&
+		    mode != SPECTRE_V2_USER_STRICT_PREFERRED)
+			pr_info("Selecting STIBP always-on mode to complement retbleed mitigation\n");
+		mode = SPECTRE_V2_USER_STRICT_PREFERRED;
+	}
+
 	spectre_v2_user_stibp = mode;
 
 set_mode:
@@ -992,6 +1191,7 @@ static const char * const spectre_v2_strings[] = {
 	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced IBRS",
 	[SPECTRE_V2_EIBRS_LFENCE]		= "Mitigation: Enhanced IBRS + LFENCE",
 	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced IBRS + Retpolines",
+	[SPECTRE_V2_IBRS]			= "Mitigation: IBRS",
 };
 
 static const struct {
@@ -1009,6 +1209,7 @@ static const struct {
 	{ "eibrs,lfence",	SPECTRE_V2_CMD_EIBRS_LFENCE,	  false },
 	{ "eibrs,retpoline",	SPECTRE_V2_CMD_EIBRS_RETPOLINE,	  false },
 	{ "auto",		SPECTRE_V2_CMD_AUTO,		  false },
+	{ "ibrs",		SPECTRE_V2_CMD_IBRS,              false },
 };
 
 static void __init spec_v2_print_cond(const char *reason, bool secure)
@@ -1071,6 +1272,30 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
 		return SPECTRE_V2_CMD_AUTO;
 	}
 
+	if (cmd == SPECTRE_V2_CMD_IBRS && !IS_ENABLED(CONFIG_CPU_IBRS_ENTRY)) {
+		pr_err("%s selected but not compiled in. Switching to AUTO select\n",
+		       mitigation_options[i].option);
+		return SPECTRE_V2_CMD_AUTO;
+	}
+
+	if (cmd == SPECTRE_V2_CMD_IBRS && boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
+		pr_err("%s selected but not Intel CPU. Switching to AUTO select\n",
+		       mitigation_options[i].option);
+		return SPECTRE_V2_CMD_AUTO;
+	}
+
+	if (cmd == SPECTRE_V2_CMD_IBRS && !boot_cpu_has(X86_FEATURE_IBRS)) {
+		pr_err("%s selected but CPU doesn't have IBRS. Switching to AUTO select\n",
+		       mitigation_options[i].option);
+		return SPECTRE_V2_CMD_AUTO;
+	}
+
+	if (cmd == SPECTRE_V2_CMD_IBRS && boot_cpu_has(X86_FEATURE_XENPV)) {
+		pr_err("%s selected but running as XenPV guest. Switching to AUTO select\n",
+		       mitigation_options[i].option);
+		return SPECTRE_V2_CMD_AUTO;
+	}
+
 	spec_v2_print_cond(mitigation_options[i].option,
 			   mitigation_options[i].secure);
 	return cmd;
@@ -1086,6 +1311,22 @@ static enum spectre_v2_mitigation __init spectre_v2_select_retpoline(void)
 	return SPECTRE_V2_RETPOLINE;
 }
 
+/* Disable in-kernel use of non-RSB RET predictors */
+static void __init spec_ctrl_disable_kernel_rrsba(void)
+{
+	u64 ia32_cap;
+
+	if (!boot_cpu_has(X86_FEATURE_RRSBA_CTRL))
+		return;
+
+	ia32_cap = x86_read_arch_cap_msr();
+
+	if (ia32_cap & ARCH_CAP_RRSBA) {
+		x86_spec_ctrl_base |= SPEC_CTRL_RRSBA_DIS_S;
+		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+	}
+}
+
 static void __init spectre_v2_select_mitigation(void)
 {
 	enum spectre_v2_mitigation_cmd cmd = spectre_v2_parse_cmdline();
@@ -1110,6 +1351,15 @@ static void __init spectre_v2_select_mitigation(void)
 			break;
 		}
 
+		if (IS_ENABLED(CONFIG_CPU_IBRS_ENTRY) &&
+		    boot_cpu_has_bug(X86_BUG_RETBLEED) &&
+		    retbleed_cmd != RETBLEED_CMD_OFF &&
+		    boot_cpu_has(X86_FEATURE_IBRS) &&
+		    boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) {
+			mode = SPECTRE_V2_IBRS;
+			break;
+		}
+
 		mode = spectre_v2_select_retpoline();
 		break;
 
@@ -1126,6 +1376,10 @@ static void __init spectre_v2_select_mitigation(void)
 		mode = spectre_v2_select_retpoline();
 		break;
 
+	case SPECTRE_V2_CMD_IBRS:
+		mode = SPECTRE_V2_IBRS;
+		break;
+
 	case SPECTRE_V2_CMD_EIBRS:
 		mode = SPECTRE_V2_EIBRS;
 		break;
@@ -1142,10 +1396,9 @@ static void __init spectre_v2_select_mitigation(void)
 	if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
 		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
 
-	if (spectre_v2_in_eibrs_mode(mode)) {
-		/* Force it so VMEXIT will restore correctly */
+	if (spectre_v2_in_ibrs_mode(mode)) {
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-		wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+		write_spec_ctrl_current(x86_spec_ctrl_base, true);
 	}
 
 	switch (mode) {
@@ -1153,6 +1406,10 @@ static void __init spectre_v2_select_mitigation(void)
 	case SPECTRE_V2_EIBRS:
 		break;
 
+	case SPECTRE_V2_IBRS:
+		setup_force_cpu_cap(X86_FEATURE_KERNEL_IBRS);
+		break;
+
 	case SPECTRE_V2_LFENCE:
 	case SPECTRE_V2_EIBRS_LFENCE:
 		setup_force_cpu_cap(X86_FEATURE_RETPOLINE_LFENCE);
@@ -1164,43 +1421,107 @@ static void __init spectre_v2_select_mitigation(void)
 		break;
 	}
 
+	/*
+	 * Disable alternate RSB predictions in kernel when indirect CALLs and
+	 * JMPs gets protection against BHI and Intramode-BTI, but RET
+	 * prediction from a non-RSB predictor is still a risk.
+	 */
+	if (mode == SPECTRE_V2_EIBRS_LFENCE ||
+	    mode == SPECTRE_V2_EIBRS_RETPOLINE ||
+	    mode == SPECTRE_V2_RETPOLINE)
+		spec_ctrl_disable_kernel_rrsba();
+
 	spectre_v2_enabled = mode;
 	pr_info("%s\n", spectre_v2_strings[mode]);
 
 	/*
-	 * If spectre v2 protection has been enabled, unconditionally fill
-	 * RSB during a context switch; this protects against two independent
-	 * issues:
+	 * If Spectre v2 protection has been enabled, fill the RSB during a
+	 * context switch.  In general there are two types of RSB attacks
+	 * across context switches, for which the CALLs/RETs may be unbalanced.
 	 *
-	 *	- RSB underflow (and switch to BTB) on Skylake+
-	 *	- SpectreRSB variant of spectre v2 on X86_BUG_SPECTRE_V2 CPUs
+	 * 1) RSB underflow
+	 *
+	 *    Some Intel parts have "bottomless RSB".  When the RSB is empty,
+	 *    speculated return targets may come from the branch predictor,
+	 *    which could have a user-poisoned BTB or BHB entry.
+	 *
+	 *    AMD has it even worse: *all* returns are speculated from the BTB,
+	 *    regardless of the state of the RSB.
+	 *
+	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack
+	 *    scenario is mitigated by the IBRS branch prediction isolation
+	 *    properties, so the RSB buffer filling wouldn't be necessary to
+	 *    protect against this type of attack.
+	 *
+	 *    The "user -> user" attack scenario is mitigated by RSB filling.
+	 *
+	 * 2) Poisoned RSB entry
+	 *
+	 *    If the 'next' in-kernel return stack is shorter than 'prev',
+	 *    'next' could be tricked into speculating with a user-poisoned RSB
+	 *    entry.
+	 *
+	 *    The "user -> kernel" attack scenario is mitigated by SMEP and
+	 *    eIBRS.
+	 *
+	 *    The "user -> user" scenario, also known as SpectreBHB, requires
+	 *    RSB clearing.
+	 *
+	 * So to mitigate all cases, unconditionally fill RSB on context
+	 * switches.
+	 *
+	 * FIXME: Is this pointless for retbleed-affected AMD?
 	 */
 	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
 
 	/*
-	 * Retpoline means the kernel is safe because it has no indirect
-	 * branches. Enhanced IBRS protects firmware too, so, enable restricted
-	 * speculation around firmware calls only when Enhanced IBRS isn't
-	 * supported.
+	 * Similar to context switches, there are two types of RSB attacks
+	 * after vmexit:
+	 *
+	 * 1) RSB underflow
+	 *
+	 * 2) Poisoned RSB entry
+	 *
+	 * When retpoline is enabled, both are mitigated by filling/clearing
+	 * the RSB.
+	 *
+	 * When IBRS is enabled, while #1 would be mitigated by the IBRS branch
+	 * prediction isolation protections, RSB still needs to be cleared
+	 * because of #2.  Note that SMEP provides no protection here, unlike
+	 * user-space-poisoned RSB entries.
+	 *
+	 * eIBRS, on the other hand, has RSB-poisoning protections, so it
+	 * doesn't need RSB clearing after vmexit.
+	 */
+	if (boot_cpu_has(X86_FEATURE_RETPOLINE) ||
+	    boot_cpu_has(X86_FEATURE_KERNEL_IBRS))
+		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
+
+	/*
+	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS
+	 * and Enhanced IBRS protect firmware too, so enable IBRS around
+	 * firmware calls only when IBRS / Enhanced IBRS aren't otherwise
+	 * enabled.
 	 *
 	 * Use "mode" to check Enhanced IBRS instead of boot_cpu_has(), because
 	 * the user might select retpoline on the kernel command line and if
 	 * the CPU supports Enhanced IBRS, kernel might un-intentionally not
 	 * enable IBRS around firmware calls.
 	 */
-	if (boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_eibrs_mode(mode)) {
+	if (boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_ibrs_mode(mode)) {
 		setup_force_cpu_cap(X86_FEATURE_USE_IBRS_FW);
 		pr_info("Enabling Restricted Speculation for firmware calls\n");
 	}
 
 	/* Set up IBPB and STIBP depending on the general spectre V2 command */
-	spectre_v2_user_select_mitigation(cmd);
+	spectre_v2_cmd = cmd;
 }
 
 static void update_stibp_msr(void * __unused)
 {
-	wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+	u64 val = spec_ctrl_current() | (x86_spec_ctrl_base & SPEC_CTRL_STIBP);
+	write_spec_ctrl_current(val, true);
 }
 
 /* Update x86_spec_ctrl_base in case SMT state changed. */
@@ -1416,16 +1737,6 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
 		break;
 	}
 
-	/*
-	 * If SSBD is controlled by the SPEC_CTRL MSR, then set the proper
-	 * bit in the mask to allow guests to use the mitigation even in the
-	 * case where the host does not enable it.
-	 */
-	if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
-	    static_cpu_has(X86_FEATURE_AMD_SSBD)) {
-		x86_spec_ctrl_mask |= SPEC_CTRL_SSBD;
-	}
-
 	/*
 	 * We have three CPU feature flags that are in play here:
 	 *  - X86_BUG_SPEC_STORE_BYPASS - CPU is susceptible.
@@ -1443,7 +1754,7 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
 			x86_amd_ssb_disable();
 		} else {
 			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
-			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+			write_spec_ctrl_current(x86_spec_ctrl_base, true);
 		}
 	}
 
@@ -1694,7 +2005,7 @@ int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which)
 void x86_spec_ctrl_setup_ap(void)
 {
 	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
-		wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+		write_spec_ctrl_current(x86_spec_ctrl_base, true);
 
 	if (ssb_mode == SPEC_STORE_BYPASS_DISABLE)
 		x86_amd_ssb_disable();
@@ -1931,7 +2242,7 @@ static ssize_t mmio_stale_data_show_state(char *buf)
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))
+	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
 		return "";
 
 	switch (spectre_v2_user_stibp) {
@@ -1987,6 +2298,24 @@ static ssize_t srbds_show_state(char *buf)
 	return sprintf(buf, "%s\n", srbds_strings[srbds_mitigation]);
 }
 
+static ssize_t retbleed_show_state(char *buf)
+{
+	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET) {
+	    if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
+		boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
+		    return sprintf(buf, "Vulnerable: untrained return thunk on non-Zen uarch\n");
+
+	    return sprintf(buf, "%s; SMT %s\n",
+			   retbleed_strings[retbleed_mitigation],
+			   !sched_smt_active() ? "disabled" :
+			   spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
+			   spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED ?
+			   "enabled with STIBP protection" : "vulnerable");
+	}
+
+	return sprintf(buf, "%s\n", retbleed_strings[retbleed_mitigation]);
+}
+
 static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr,
 			       char *buf, unsigned int bug)
 {
@@ -2032,6 +2361,9 @@ static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr
 	case X86_BUG_MMIO_STALE_DATA:
 		return mmio_stale_data_show_state(buf);
 
+	case X86_BUG_RETBLEED:
+		return retbleed_show_state(buf);
+
 	default:
 		break;
 	}
@@ -2088,4 +2420,9 @@ ssize_t cpu_show_mmio_stale_data(struct device *dev, struct device_attribute *at
 {
 	return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
 }
+
+ssize_t cpu_show_retbleed(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_RETBLEED);
+}
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index bd390c56e551..80cc41f79783 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1095,48 +1095,60 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	{}
 };
 
+#define VULNBL(vendor, family, model, blacklist)	\
+	X86_MATCH_VENDOR_FAM_MODEL(vendor, family, model, blacklist)
+
 #define VULNBL_INTEL_STEPPINGS(model, steppings, issues)		   \
 	X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE(INTEL, 6,		   \
 					    INTEL_FAM6_##model, steppings, \
 					    X86_FEATURE_ANY, issues)
 
+#define VULNBL_AMD(family, blacklist)		\
+	VULNBL(AMD, family, X86_MODEL_ANY, blacklist)
+
+#define VULNBL_HYGON(family, blacklist)		\
+	VULNBL(HYGON, family, X86_MODEL_ANY, blacklist)
+
 #define SRBDS		BIT(0)
 /* CPU is affected by X86_BUG_MMIO_STALE_DATA */
 #define MMIO		BIT(1)
 /* CPU is affected by Shared Buffers Data Sampling (SBDS), a variant of X86_BUG_MMIO_STALE_DATA */
 #define MMIO_SBDS	BIT(2)
+/* CPU is affected by RETbleed, speculating where you would not expect it */
+#define RETBLEED	BIT(3)
 
 static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(IVYBRIDGE,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(HASWELL,		X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(HASWELL_L,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(HASWELL_G,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(HASWELL_X,	BIT(2) | BIT(4),		MMIO),
-	VULNBL_INTEL_STEPPINGS(BROADWELL_D,	X86_STEPPINGS(0x3, 0x5),	MMIO),
+	VULNBL_INTEL_STEPPINGS(HASWELL_X,	X86_STEPPING_ANY,		MMIO),
+	VULNBL_INTEL_STEPPINGS(BROADWELL_D,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_G,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_X,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(BROADWELL,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_L,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_L,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_X,	BIT(3) | BIT(4) | BIT(6) |
-						BIT(7) | BIT(0xB),              MMIO),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE,		X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE,		X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_L,	X86_STEPPINGS(0x9, 0xC),	SRBDS | MMIO),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_L,	X86_STEPPINGS(0x0, 0x8),	SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE,	X86_STEPPINGS(0x9, 0xD),	SRBDS | MMIO),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE,	X86_STEPPINGS(0x0, 0x8),	SRBDS),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_L,	X86_STEPPINGS(0x5, 0x5),	MMIO | MMIO_SBDS),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_D,	X86_STEPPINGS(0x1, 0x1),	MMIO),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPINGS(0x4, 0x6),	MMIO),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE,	BIT(2) | BIT(3) | BIT(5),	MMIO | MMIO_SBDS),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x0, 0x0),	MMIO),
-	VULNBL_INTEL_STEPPINGS(LAKEFIELD,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
-	VULNBL_INTEL_STEPPINGS(ROCKETLAKE,	X86_STEPPINGS(0x1, 0x1),	MMIO),
-	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_L,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_X,	X86_STEPPING_ANY,		MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE,		X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_L,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(CANNONLAKE_L,	X86_STEPPING_ANY,		RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_L,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_D,	X86_STEPPING_ANY,		MMIO),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPING_ANY,		MMIO),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(LAKEFIELD,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ROCKETLAKE,	X86_STEPPING_ANY,		MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS),
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_D,	X86_STEPPING_ANY,		MMIO),
-	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | MMIO_SBDS),
+	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_L,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS),
+
+	VULNBL_AMD(0x15, RETBLEED),
+	VULNBL_AMD(0x16, RETBLEED),
+	VULNBL_AMD(0x17, RETBLEED),
+	VULNBL_HYGON(0x18, RETBLEED),
 	{}
 };
 
@@ -1238,6 +1250,11 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 	    !arch_cap_mmio_immune(ia32_cap))
 		setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
 
+	if (!cpu_has(c, X86_FEATURE_BTC_NO)) {
+		if (cpu_matches(cpu_vuln_blacklist, RETBLEED) || (ia32_cap & ARCH_CAP_RSBA))
+			setup_force_cpu_bug(X86_BUG_RETBLEED);
+	}
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 2a8e584fc991..7c9b5893c30a 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -61,6 +61,8 @@ static inline void tsx_init(void) { }
 static inline void tsx_ap_init(void) { }
 #endif /* CONFIG_CPU_SUP_INTEL */
 
+extern void init_spectral_chicken(struct cpuinfo_x86 *c);
+
 extern void get_cpu_cap(struct cpuinfo_x86 *c);
 extern void get_cpu_address_sizes(struct cpuinfo_x86 *c);
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/cpu/hygon.c b/arch/x86/kernel/cpu/hygon.c
index 3fcdda4c1e11..21fd425088fe 100644
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -302,6 +302,12 @@ static void init_hygon(struct cpuinfo_x86 *c)
 	/* get apicid instead of initial apic id from cpuid */
 	c->apicid = hard_smp_processor_id();
 
+	/*
+	 * XXX someone from Hygon needs to confirm this DTRT
+	 *
+	init_spectral_chicken(c);
+	 */
+
 	set_cpu_cap(c, X86_FEATURE_ZEN);
 	set_cpu_cap(c, X86_FEATURE_CPB);
 
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 21d1f062895a..06bfef1c4175 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -26,6 +26,7 @@ struct cpuid_bit {
 static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_APERFMPERF,       CPUID_ECX,  0, 0x00000006, 0 },
 	{ X86_FEATURE_EPB,		CPUID_ECX,  3, 0x00000006, 0 },
+	{ X86_FEATURE_RRSBA_CTRL,	CPUID_EDX,  2, 0x00000007, 2 },
 	{ X86_FEATURE_CQM_LLC,		CPUID_EDX,  1, 0x0000000f, 0 },
 	{ X86_FEATURE_CQM_OCCUP_LLC,	CPUID_EDX,  0, 0x0000000f, 1 },
 	{ X86_FEATURE_CQM_MBM_TOTAL,	CPUID_EDX,  1, 0x0000000f, 1 },
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 847776cc1aa4..74c2f88a43d0 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -308,7 +308,7 @@ union ftrace_op_code_union {
 	} __attribute__((packed));
 };
 
-#define RET_SIZE		1 + IS_ENABLED(CONFIG_SLS)
+#define RET_SIZE		(IS_ENABLED(CONFIG_RETPOLINE) ? 5 : 1 + IS_ENABLED(CONFIG_SLS))
 
 static unsigned long
 create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
@@ -367,7 +367,10 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 
 	/* The trampoline ends with ret(q) */
 	retq = (unsigned long)ftrace_stub;
-	ret = copy_from_kernel_nofault(ip, (void *)retq, RET_SIZE);
+	if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
+		memcpy(ip, text_gen_insn(JMP32_INSN_OPCODE, ip, &__x86_return_thunk), JMP32_INSN_SIZE);
+	else
+		ret = copy_from_kernel_nofault(ip, (void *)retq, RET_SIZE);
 	if (WARN_ON(ret < 0))
 		goto fail;
 
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index eb8656bac99b..9b7acc9c7874 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -23,6 +23,7 @@
 #include <asm/cpufeatures.h>
 #include <asm/percpu.h>
 #include <asm/nops.h>
+#include <asm/nospec-branch.h>
 #include <asm/bootparam.h>
 #include <asm/export.h>
 #include <asm/pgtable_32.h>
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index d8b3ebd2bb85..81f1ae278718 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -312,6 +312,8 @@ SYM_CODE_END(start_cpu0)
 SYM_CODE_START_NOALIGN(vc_boot_ghcb)
 	UNWIND_HINT_IRET_REGS offset=8
 
+	ANNOTATE_UNRET_END
+
 	/* Build pt_regs */
 	PUSH_AND_CLEAR_REGS
 
@@ -369,6 +371,7 @@ SYM_CODE_START(early_idt_handler_array)
 SYM_CODE_END(early_idt_handler_array)
 
 SYM_CODE_START_LOCAL(early_idt_handler_common)
+	ANNOTATE_UNRET_END
 	/*
 	 * The stack is the hardware frame, an error code or zero, and the
 	 * vector number.
@@ -415,6 +418,8 @@ SYM_CODE_END(early_idt_handler_common)
 SYM_CODE_START_NOALIGN(vc_no_ghcb)
 	UNWIND_HINT_IRET_REGS offset=8
 
+	ANNOTATE_UNRET_END
+
 	/* Build pt_regs */
 	PUSH_AND_CLEAR_REGS
 
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 32e546e41629..06b53ea940bf 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -252,7 +252,8 @@ int module_finalize(const Elf_Ehdr *hdr,
 		    struct module *me)
 {
 	const Elf_Shdr *s, *text = NULL, *alt = NULL, *locks = NULL,
-		*para = NULL, *orc = NULL, *orc_ip = NULL;
+		*para = NULL, *orc = NULL, *orc_ip = NULL,
+		*retpolines = NULL, *returns = NULL;
 	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
 
 	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
@@ -268,6 +269,10 @@ int module_finalize(const Elf_Ehdr *hdr,
 			orc = s;
 		if (!strcmp(".orc_unwind_ip", secstrings + s->sh_name))
 			orc_ip = s;
+		if (!strcmp(".retpoline_sites", secstrings + s->sh_name))
+			retpolines = s;
+		if (!strcmp(".return_sites", secstrings + s->sh_name))
+			returns = s;
 	}
 
 	/*
@@ -278,6 +283,14 @@ int module_finalize(const Elf_Ehdr *hdr,
 		void *pseg = (void *)para->sh_addr;
 		apply_paravirt(pseg, pseg + para->sh_size);
 	}
+	if (retpolines) {
+		void *rseg = (void *)retpolines->sh_addr;
+		apply_retpolines(rseg, rseg + retpolines->sh_size);
+	}
+	if (returns) {
+		void *rseg = (void *)returns->sh_addr;
+		apply_returns(rseg, rseg + returns->sh_size);
+	}
 	if (alt) {
 		/* patch .altinstructions */
 		void *aseg = (void *)alt->sh_addr;
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index f2f733bcb2b9..8d9d72fc27a2 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -584,7 +584,7 @@ static __always_inline void __speculation_ctrl_update(unsigned long tifp,
 	}
 
 	if (updmsr)
-		wrmsrl(MSR_IA32_SPEC_CTRL, msr);
+		write_spec_ctrl_current(msr, false);
 }
 
 static unsigned long speculation_ctrl_update_tif(struct task_struct *tsk)
diff --git a/arch/x86/kernel/relocate_kernel_32.S b/arch/x86/kernel/relocate_kernel_32.S
index fcc8a7699103..c7c4b1917336 100644
--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -7,10 +7,12 @@
 #include <linux/linkage.h>
 #include <asm/page_types.h>
 #include <asm/kexec.h>
+#include <asm/nospec-branch.h>
 #include <asm/processor-flags.h>
 
 /*
- * Must be relocatable PIC code callable as a C function
+ * Must be relocatable PIC code callable as a C function, in particular
+ * there must be a plain RET and not jump to return thunk.
  */
 
 #define PTR(x) (x << 2)
@@ -91,7 +93,9 @@ SYM_CODE_START_NOALIGN(relocate_kernel)
 	movl    %edi, %eax
 	addl    $(identity_mapped - relocate_kernel), %eax
 	pushl   %eax
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(relocate_kernel)
 
 SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
@@ -159,12 +163,15 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	xorl    %edx, %edx
 	xorl    %esi, %esi
 	xorl    %ebp, %ebp
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 1:
 	popl	%edx
 	movl	CP_PA_SWAP_PAGE(%edi), %esp
 	addl	$PAGE_SIZE, %esp
 2:
+	ANNOTATE_RETPOLINE_SAFE
 	call	*%edx
 
 	/* get the re-entry point of the peer system */
@@ -190,7 +197,9 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	movl	%edi, %eax
 	addl	$(virtual_mapped - relocate_kernel), %eax
 	pushl	%eax
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(identity_mapped)
 
 SYM_CODE_START_LOCAL_NOALIGN(virtual_mapped)
@@ -208,7 +217,9 @@ SYM_CODE_START_LOCAL_NOALIGN(virtual_mapped)
 	popl	%edi
 	popl	%esi
 	popl	%ebx
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(virtual_mapped)
 
 	/* Do the copies */
@@ -271,7 +282,9 @@ SYM_CODE_START_LOCAL_NOALIGN(swap_pages)
 	popl	%edi
 	popl	%ebx
 	popl	%ebp
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(swap_pages)
 
 	.globl kexec_control_code_size
diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index 5019091af059..8a9cea950e39 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -13,7 +13,8 @@
 #include <asm/unwind_hints.h>
 
 /*
- * Must be relocatable PIC code callable as a C function
+ * Must be relocatable PIC code callable as a C function, in particular
+ * there must be a plain RET and not jump to return thunk.
  */
 
 #define PTR(x) (x << 3)
@@ -104,7 +105,9 @@ SYM_CODE_START_NOALIGN(relocate_kernel)
 	/* jump to identity mapped page */
 	addq	$(identity_mapped - relocate_kernel), %r8
 	pushq	%r8
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(relocate_kernel)
 
 SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
@@ -191,7 +194,9 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	xorl	%r14d, %r14d
 	xorl	%r15d, %r15d
 
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 
 1:
 	popq	%rdx
@@ -210,7 +215,9 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	call	swap_pages
 	movq	$virtual_mapped, %rax
 	pushq	%rax
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(identity_mapped)
 
 SYM_CODE_START_LOCAL_NOALIGN(virtual_mapped)
@@ -231,7 +238,9 @@ SYM_CODE_START_LOCAL_NOALIGN(virtual_mapped)
 	popq	%r12
 	popq	%rbp
 	popq	%rbx
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(virtual_mapped)
 
 	/* Do the copies */
@@ -288,7 +297,9 @@ SYM_CODE_START_LOCAL_NOALIGN(swap_pages)
 	lea	PAGE_SIZE(%rax), %rsi
 	jmp	0b
 3:
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(swap_pages)
 
 	.globl kexec_control_code_size
diff --git a/arch/x86/kernel/static_call.c b/arch/x86/kernel/static_call.c
index 3ec2cb881eef..2fc4f96702e6 100644
--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -11,6 +11,13 @@ enum insn_type {
 	RET = 3,  /* tramp / site cond-tail-call */
 };
 
+/*
+ * ud1 %esp, %ecx - a 3 byte #UD that is unique to trampolines, chosen such
+ * that there is no false-positive trampoline identification while also being a
+ * speculation stop.
+ */
+static const u8 tramp_ud[] = { 0x0f, 0xb9, 0xcc };
+
 /*
  * cs cs cs xorl %eax, %eax - a single 5 byte instruction that clears %[er]ax
  */
@@ -18,7 +25,8 @@ static const u8 xor5rax[] = { 0x2e, 0x2e, 0x2e, 0x31, 0xc0 };
 
 static const u8 retinsn[] = { RET_INSN_OPCODE, 0xcc, 0xcc, 0xcc, 0xcc };
 
-static void __ref __static_call_transform(void *insn, enum insn_type type, void *func)
+static void __ref __static_call_transform(void *insn, enum insn_type type,
+					  void *func, bool modinit)
 {
 	const void *emulate = NULL;
 	int size = CALL_INSN_SIZE;
@@ -43,14 +51,17 @@ static void __ref __static_call_transform(void *insn, enum insn_type type, void
 		break;
 
 	case RET:
-		code = &retinsn;
+		if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
+			code = text_gen_insn(JMP32_INSN_OPCODE, insn, &__x86_return_thunk);
+		else
+			code = &retinsn;
 		break;
 	}
 
 	if (memcmp(insn, code, size) == 0)
 		return;
 
-	if (unlikely(system_state == SYSTEM_BOOTING))
+	if (system_state == SYSTEM_BOOTING || modinit)
 		return text_poke_early(insn, code, size);
 
 	text_poke_bp(insn, code, size, emulate);
@@ -98,14 +109,42 @@ void arch_static_call_transform(void *site, void *tramp, void *func, bool tail)
 
 	if (tramp) {
 		__static_call_validate(tramp, true);
-		__static_call_transform(tramp, __sc_insn(!func, true), func);
+		__static_call_transform(tramp, __sc_insn(!func, true), func, false);
 	}
 
 	if (IS_ENABLED(CONFIG_HAVE_STATIC_CALL_INLINE) && site) {
 		__static_call_validate(site, tail);
-		__static_call_transform(site, __sc_insn(!func, tail), func);
+		__static_call_transform(site, __sc_insn(!func, tail), func, false);
 	}
 
 	mutex_unlock(&text_mutex);
 }
 EXPORT_SYMBOL_GPL(arch_static_call_transform);
+
+#ifdef CONFIG_RETHUNK
+/*
+ * This is called by apply_returns() to fix up static call trampolines,
+ * specifically ARCH_DEFINE_STATIC_CALL_NULL_TRAMP which is recorded as
+ * having a return trampoline.
+ *
+ * The problem is that static_call() is available before determining
+ * X86_FEATURE_RETHUNK and, by implication, running alternatives.
+ *
+ * This means that __static_call_transform() above can have overwritten the
+ * return trampoline and we now need to fix things up to be consistent.
+ */
+bool __static_call_fixup(void *tramp, u8 op, void *dest)
+{
+	if (memcmp(tramp+5, tramp_ud, 3)) {
+		/* Not a trampoline site, not our problem. */
+		return false;
+	}
+
+	mutex_lock(&text_mutex);
+	if (op == RET_INSN_OPCODE || dest == &__x86_return_thunk)
+		__static_call_transform(tramp, RET, NULL, true);
+	mutex_unlock(&text_mutex);
+
+	return true;
+}
+#endif
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 928e1ac820e6..ca47080e3774 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -762,14 +762,10 @@ asmlinkage __visible noinstr struct pt_regs *vc_switch_off_ist(struct pt_regs *r
 }
 #endif
 
-struct bad_iret_stack {
-	void *error_entry_ret;
-	struct pt_regs regs;
-};
-
-asmlinkage __visible noinstr
-struct bad_iret_stack *fixup_bad_iret(struct bad_iret_stack *s)
+asmlinkage __visible noinstr struct pt_regs *fixup_bad_iret(struct pt_regs *bad_regs)
 {
+	struct pt_regs tmp, *new_stack;
+
 	/*
 	 * This is called from entry_64.S early in handling a fault
 	 * caused by a bad iret to user mode.  To handle the fault
@@ -778,19 +774,18 @@ struct bad_iret_stack *fixup_bad_iret(struct bad_iret_stack *s)
 	 * just below the IRET frame) and we want to pretend that the
 	 * exception came from the IRET target.
 	 */
-	struct bad_iret_stack tmp, *new_stack =
-		(struct bad_iret_stack *)__this_cpu_read(cpu_tss_rw.x86_tss.sp0) - 1;
+	new_stack = (struct pt_regs *)__this_cpu_read(cpu_tss_rw.x86_tss.sp0) - 1;
 
 	/* Copy the IRET target to the temporary storage. */
-	__memcpy(&tmp.regs.ip, (void *)s->regs.sp, 5*8);
+	__memcpy(&tmp.ip, (void *)bad_regs->sp, 5*8);
 
 	/* Copy the remainder of the stack from the current stack. */
-	__memcpy(&tmp, s, offsetof(struct bad_iret_stack, regs.ip));
+	__memcpy(&tmp, bad_regs, offsetof(struct pt_regs, ip));
 
 	/* Update the entry stack */
 	__memcpy(new_stack, &tmp, sizeof(tmp));
 
-	BUG_ON(!user_mode(&new_stack->regs));
+	BUG_ON(!user_mode(new_stack));
 	return new_stack;
 }
 #endif
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index efd9e9ea17f2..c1efcd194ad7 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -142,7 +142,7 @@ SECTIONS
 
 #ifdef CONFIG_RETPOLINE
 		__indirect_thunk_start = .;
-		*(.text.__x86.indirect_thunk)
+		*(.text.__x86.*)
 		__indirect_thunk_end = .;
 #endif
 	} :text =0xcccc
@@ -272,6 +272,27 @@ SECTIONS
 		__parainstructions_end = .;
 	}
 
+#ifdef CONFIG_RETPOLINE
+	/*
+	 * List of instructions that call/jmp/jcc to retpoline thunks
+	 * __x86_indirect_thunk_*(). These instructions can be patched along
+	 * with alternatives, after which the section can be freed.
+	 */
+	. = ALIGN(8);
+	.retpoline_sites : AT(ADDR(.retpoline_sites) - LOAD_OFFSET) {
+		__retpoline_sites = .;
+		*(.retpoline_sites)
+		__retpoline_sites_end = .;
+	}
+
+	. = ALIGN(8);
+	.return_sites : AT(ADDR(.return_sites) - LOAD_OFFSET) {
+		__return_sites = .;
+		*(.return_sites)
+		__return_sites_end = .;
+	}
+#endif
+
 	/*
 	 * struct alt_inst entries. From the header (alternative.h):
 	 * "Alternative instructions for different CPU types or capabilities"
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 82eff14bd064..318a78379ca6 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -187,9 +187,6 @@
 #define X8(x...) X4(x), X4(x)
 #define X16(x...) X8(x), X8(x)
 
-#define NR_FASTOP (ilog2(sizeof(ulong)) + 1)
-#define FASTOP_SIZE 8
-
 struct opcode {
 	u64 flags : 56;
 	u64 intercept : 8;
@@ -303,9 +300,15 @@ static void invalidate_registers(struct x86_emulate_ctxt *ctxt)
  * Moreover, they are all exactly FASTOP_SIZE bytes long, so functions for
  * different operand sizes can be reached by calculation, rather than a jump
  * table (which would be bigger than the code).
+ *
+ * The 16 byte alignment, considering 5 bytes for the RET thunk, 3 for ENDBR
+ * and 1 for the straight line speculation INT3, leaves 7 bytes for the
+ * body of the function.  Currently none is larger than 4.
  */
 static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
 
+#define FASTOP_SIZE	16
+
 #define __FOP_FUNC(name) \
 	".align " __stringify(FASTOP_SIZE) " \n\t" \
 	".type " name ", @function \n\t" \
@@ -321,13 +324,15 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
 #define FOP_RET(name) \
 	__FOP_RET(#name)
 
-#define FOP_START(op) \
+#define __FOP_START(op, align) \
 	extern void em_##op(struct fastop *fake); \
 	asm(".pushsection .text, \"ax\" \n\t" \
 	    ".global em_" #op " \n\t" \
-	    ".align " __stringify(FASTOP_SIZE) " \n\t" \
+	    ".align " __stringify(align) " \n\t" \
 	    "em_" #op ":\n\t"
 
+#define FOP_START(op) __FOP_START(op, FASTOP_SIZE)
+
 #define FOP_END \
 	    ".popsection")
 
@@ -431,29 +436,25 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
 /*
  * Depending on .config the SETcc functions look like:
  *
- * SETcc %al   [3 bytes]
- * RET         [1 byte]
- * INT3        [1 byte; CONFIG_SLS]
- *
- * Which gives possible sizes 4 or 5.  When rounded up to the
- * next power-of-two alignment they become 4 or 8.
+ * SETcc %al			[3 bytes]
+ * RET | JMP __x86_return_thunk	[1,5 bytes; CONFIG_RETHUNK]
+ * INT3				[1 byte; CONFIG_SLS]
  */
-#define SETCC_LENGTH	(4 + IS_ENABLED(CONFIG_SLS))
-#define SETCC_ALIGN	(4 << IS_ENABLED(CONFIG_SLS))
-static_assert(SETCC_LENGTH <= SETCC_ALIGN);
+#define SETCC_ALIGN	16
 
 #define FOP_SETCC(op) \
 	".align " __stringify(SETCC_ALIGN) " \n\t" \
 	".type " #op ", @function \n\t" \
 	#op ": \n\t" \
 	#op " %al \n\t" \
-	__FOP_RET(#op)
+	__FOP_RET(#op) \
+	".skip " __stringify(SETCC_ALIGN) " - (.-" #op "), 0xcc \n\t"
 
 asm(".pushsection .fixup, \"ax\"\n"
     "kvm_fastop_exception: xor %esi, %esi; " ASM_RET
     ".popsection");
 
-FOP_START(setcc)
+__FOP_START(setcc, SETCC_ALIGN)
 FOP_SETCC(seto)
 FOP_SETCC(setno)
 FOP_SETCC(setc)
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index dfaeb47fcf2a..723f8534986c 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -110,6 +110,15 @@ SYM_FUNC_START(__svm_vcpu_run)
 	mov %r15, VCPU_R15(%_ASM_AX)
 #endif
 
+	/*
+	 * Mitigate RETBleed for AMD/Hygon Zen uarch. RET should be
+	 * untrained as soon as we exit the VM and are back to the
+	 * kernel. This should be done before re-enabling interrupts
+	 * because interrupt handlers won't sanitize 'ret' if the return is
+	 * from the kernel.
+	 */
+	UNTRAIN_RET
+
 	/*
 	 * Clear all general purpose registers except RSP and RAX to prevent
 	 * speculative use of the guest's values, even those that are reloaded
@@ -190,6 +199,15 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
 #endif
 
+	/*
+	 * Mitigate RETBleed for AMD/Hygon Zen uarch. RET should be
+	 * untrained as soon as we exit the VM and are back to the
+	 * kernel. This should be done before re-enabling interrupts
+	 * because interrupt handlers won't sanitize RET if the return is
+	 * from the kernel.
+	 */
+	UNTRAIN_RET
+
 	pop %_ASM_BX
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f7bdb62d6cec..5f91aa62bdca 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3077,7 +3077,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 	}
 
 	vm_fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
-				 vmx->loaded_vmcs->launched);
+				 __vmx_vcpu_run_flags(vmx));
 
 	if (vmx->msr_autoload.host.nr)
 		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
new file mode 100644
index 000000000000..edc3f16cc189
--- /dev/null
+++ b/arch/x86/kvm/vmx/run_flags.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_VMX_RUN_FLAGS_H
+#define __KVM_X86_VMX_RUN_FLAGS_H
+
+#define VMX_RUN_VMRESUME	(1 << 0)
+#define VMX_RUN_SAVE_SPEC_CTRL	(1 << 1)
+
+#endif /* __KVM_X86_VMX_RUN_FLAGS_H */
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 435c187927c4..857fa0fc49fa 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -5,6 +5,7 @@
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/nospec-branch.h>
 #include <asm/segment.h>
+#include "run_flags.h"
 
 #define WORD_SIZE (BITS_PER_LONG / 8)
 
@@ -30,73 +31,12 @@
 
 .section .noinstr.text, "ax"
 
-/**
- * vmx_vmenter - VM-Enter the current loaded VMCS
- *
- * %RFLAGS.ZF:	!VMCS.LAUNCHED, i.e. controls VMLAUNCH vs. VMRESUME
- *
- * Returns:
- *	%RFLAGS.CF is set on VM-Fail Invalid
- *	%RFLAGS.ZF is set on VM-Fail Valid
- *	%RFLAGS.{CF,ZF} are cleared on VM-Success, i.e. VM-Exit
- *
- * Note that VMRESUME/VMLAUNCH fall-through and return directly if
- * they VM-Fail, whereas a successful VM-Enter + VM-Exit will jump
- * to vmx_vmexit.
- */
-SYM_FUNC_START_LOCAL(vmx_vmenter)
-	/* EFLAGS.ZF is set if VMCS.LAUNCHED == 0 */
-	je 2f
-
-1:	vmresume
-	RET
-
-2:	vmlaunch
-	RET
-
-3:	cmpb $0, kvm_rebooting
-	je 4f
-	RET
-4:	ud2
-
-	_ASM_EXTABLE(1b, 3b)
-	_ASM_EXTABLE(2b, 3b)
-
-SYM_FUNC_END(vmx_vmenter)
-
-/**
- * vmx_vmexit - Handle a VMX VM-Exit
- *
- * Returns:
- *	%RFLAGS.{CF,ZF} are cleared on VM-Success, i.e. VM-Exit
- *
- * This is vmx_vmenter's partner in crime.  On a VM-Exit, control will jump
- * here after hardware loads the host's state, i.e. this is the destination
- * referred to by VMCS.HOST_RIP.
- */
-SYM_FUNC_START(vmx_vmexit)
-#ifdef CONFIG_RETPOLINE
-	ALTERNATIVE "jmp .Lvmexit_skip_rsb", "", X86_FEATURE_RETPOLINE
-	/* Preserve guest's RAX, it's used to stuff the RSB. */
-	push %_ASM_AX
-
-	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
-	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
-
-	/* Clear RFLAGS.CF and RFLAGS.ZF to preserve VM-Exit, i.e. !VM-Fail. */
-	or $1, %_ASM_AX
-
-	pop %_ASM_AX
-.Lvmexit_skip_rsb:
-#endif
-	RET
-SYM_FUNC_END(vmx_vmexit)
-
 /**
  * __vmx_vcpu_run - Run a vCPU via a transition to VMX guest mode
- * @vmx:	struct vcpu_vmx * (forwarded to vmx_update_host_rsp)
+ * @vmx:	struct vcpu_vmx *
  * @regs:	unsigned long * (to guest registers)
- * @launched:	%true if the VMCS has been launched
+ * @flags:	VMX_RUN_VMRESUME:	use VMRESUME instead of VMLAUNCH
+ *		VMX_RUN_SAVE_SPEC_CTRL: save guest SPEC_CTRL into vmx->spec_ctrl
  *
  * Returns:
  *	0 on VM-Exit, 1 on VM-Fail
@@ -115,24 +55,29 @@ SYM_FUNC_START(__vmx_vcpu_run)
 #endif
 	push %_ASM_BX
 
+	/* Save @vmx for SPEC_CTRL handling */
+	push %_ASM_ARG1
+
+	/* Save @flags for SPEC_CTRL handling */
+	push %_ASM_ARG3
+
 	/*
 	 * Save @regs, _ASM_ARG2 may be modified by vmx_update_host_rsp() and
 	 * @regs is needed after VM-Exit to save the guest's register values.
 	 */
 	push %_ASM_ARG2
 
-	/* Copy @launched to BL, _ASM_ARG3 is volatile. */
+	/* Copy @flags to BL, _ASM_ARG3 is volatile. */
 	mov %_ASM_ARG3B, %bl
 
-	/* Adjust RSP to account for the CALL to vmx_vmenter(). */
-	lea -WORD_SIZE(%_ASM_SP), %_ASM_ARG2
+	lea (%_ASM_SP), %_ASM_ARG2
 	call vmx_update_host_rsp
 
 	/* Load @regs to RAX. */
 	mov (%_ASM_SP), %_ASM_AX
 
 	/* Check if vmlaunch or vmresume is needed */
-	testb %bl, %bl
+	testb $VMX_RUN_VMRESUME, %bl
 
 	/* Load guest registers.  Don't clobber flags. */
 	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
@@ -154,11 +99,36 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	/* Load guest RAX.  This kills the @regs pointer! */
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
-	/* Enter guest mode */
-	call vmx_vmenter
+	/* Check EFLAGS.ZF from 'testb' above */
+	jz .Lvmlaunch
 
-	/* Jump on VM-Fail. */
-	jbe 2f
+	/*
+	 * After a successful VMRESUME/VMLAUNCH, control flow "magically"
+	 * resumes below at 'vmx_vmexit' due to the VMCS HOST_RIP setting.
+	 * So this isn't a typical function and objtool needs to be told to
+	 * save the unwind state here and restore it below.
+	 */
+	UNWIND_HINT_SAVE
+
+/*
+ * If VMRESUME/VMLAUNCH and corresponding vmexit succeed, execution resumes at
+ * the 'vmx_vmexit' label below.
+ */
+.Lvmresume:
+	vmresume
+	jmp .Lvmfail
+
+.Lvmlaunch:
+	vmlaunch
+	jmp .Lvmfail
+
+	_ASM_EXTABLE(.Lvmresume, .Lfixup)
+	_ASM_EXTABLE(.Lvmlaunch, .Lfixup)
+
+SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
+
+	/* Restore unwind state from before the VMRESUME/VMLAUNCH. */
+	UNWIND_HINT_RESTORE
 
 	/* Temporarily save guest's RAX. */
 	push %_ASM_AX
@@ -185,21 +155,23 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	mov %r15, VCPU_R15(%_ASM_AX)
 #endif
 
-	/* Clear RAX to indicate VM-Exit (as opposed to VM-Fail). */
-	xor %eax, %eax
+	/* Clear return value to indicate VM-Exit (as opposed to VM-Fail). */
+	xor %ebx, %ebx
 
+.Lclear_regs:
 	/*
-	 * Clear all general purpose registers except RSP and RAX to prevent
+	 * Clear all general purpose registers except RSP and RBX to prevent
 	 * speculative use of the guest's values, even those that are reloaded
 	 * via the stack.  In theory, an L1 cache miss when restoring registers
 	 * could lead to speculative execution with the guest's values.
 	 * Zeroing XORs are dirt cheap, i.e. the extra paranoia is essentially
 	 * free.  RSP and RAX are exempt as RSP is restored by hardware during
-	 * VM-Exit and RAX is explicitly loaded with 0 or 1 to return VM-Fail.
+	 * VM-Exit and RBX is explicitly loaded with 0 or 1 to hold the return
+	 * value.
 	 */
-1:	xor %ecx, %ecx
+	xor %eax, %eax
+	xor %ecx, %ecx
 	xor %edx, %edx
-	xor %ebx, %ebx
 	xor %ebp, %ebp
 	xor %esi, %esi
 	xor %edi, %edi
@@ -216,8 +188,30 @@ SYM_FUNC_START(__vmx_vcpu_run)
 
 	/* "POP" @regs. */
 	add $WORD_SIZE, %_ASM_SP
-	pop %_ASM_BX
 
+	/*
+	 * IMPORTANT: RSB filling and SPEC_CTRL handling must be done before
+	 * the first unbalanced RET after vmexit!
+	 *
+	 * For retpoline or IBRS, RSB filling is needed to prevent poisoned RSB
+	 * entries and (in some cases) RSB underflow.
+	 *
+	 * eIBRS has its own protection against poisoned RSB, so it doesn't
+	 * need the RSB filling sequence.  But it does need to be enabled
+	 * before the first unbalanced RET.
+         */
+
+	FILL_RETURN_BUFFER %_ASM_CX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT
+
+	pop %_ASM_ARG2	/* @flags */
+	pop %_ASM_ARG1	/* @vmx */
+
+	call vmx_spec_ctrl_restore_host
+
+	/* Put return value in AX */
+	mov %_ASM_BX, %_ASM_AX
+
+	pop %_ASM_BX
 #ifdef CONFIG_X86_64
 	pop %r12
 	pop %r13
@@ -230,9 +224,15 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	pop %_ASM_BP
 	RET
 
-	/* VM-Fail.  Out-of-line to avoid a taken Jcc after VM-Exit. */
-2:	mov $1, %eax
-	jmp 1b
+.Lfixup:
+	cmpb $0, kvm_rebooting
+	jne .Lvmfail
+	ud2
+.Lvmfail:
+	/* VM-Fail: set return value to 1 */
+	mov $1, %_ASM_BX
+	jmp .Lclear_regs
+
 SYM_FUNC_END(__vmx_vcpu_run)
 
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1533ab7b579e..a236104fc743 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -380,9 +380,9 @@ static __always_inline void vmx_disable_fb_clear(struct vcpu_vmx *vmx)
 	if (!vmx->disable_fb_clear)
 		return;
 
-	rdmsrl(MSR_IA32_MCU_OPT_CTRL, msr);
+	msr = __rdmsr(MSR_IA32_MCU_OPT_CTRL);
 	msr |= FB_CLEAR_DIS;
-	wrmsrl(MSR_IA32_MCU_OPT_CTRL, msr);
+	native_wrmsrl(MSR_IA32_MCU_OPT_CTRL, msr);
 	/* Cache the MSR value to avoid reading it later */
 	vmx->msr_ia32_mcu_opt_ctrl = msr;
 }
@@ -393,7 +393,7 @@ static __always_inline void vmx_enable_fb_clear(struct vcpu_vmx *vmx)
 		return;
 
 	vmx->msr_ia32_mcu_opt_ctrl &= ~FB_CLEAR_DIS;
-	wrmsrl(MSR_IA32_MCU_OPT_CTRL, vmx->msr_ia32_mcu_opt_ctrl);
+	native_wrmsrl(MSR_IA32_MCU_OPT_CTRL, vmx->msr_ia32_mcu_opt_ctrl);
 }
 
 static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
@@ -835,6 +835,24 @@ static bool msr_write_intercepted(struct vcpu_vmx *vmx, u32 msr)
 					 MSR_IA32_SPEC_CTRL);
 }
 
+unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
+{
+	unsigned int flags = 0;
+
+	if (vmx->loaded_vmcs->launched)
+		flags |= VMX_RUN_VMRESUME;
+
+	/*
+	 * If writes to the SPEC_CTRL MSR aren't intercepted, the guest is free
+	 * to change it directly without causing a vmexit.  In that case read
+	 * it after vmexit and store it in vmx->spec_ctrl.
+	 */
+	if (unlikely(!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL)))
+		flags |= VMX_RUN_SAVE_SPEC_CTRL;
+
+	return flags;
+}
+
 static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 		unsigned long entry, unsigned long exit)
 {
@@ -6654,6 +6672,31 @@ void noinstr vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 	}
 }
 
+void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
+					unsigned int flags)
+{
+	u64 hostval = this_cpu_read(x86_spec_ctrl_current);
+
+	if (!cpu_feature_enabled(X86_FEATURE_MSR_SPEC_CTRL))
+		return;
+
+	if (flags & VMX_RUN_SAVE_SPEC_CTRL)
+		vmx->spec_ctrl = __rdmsr(MSR_IA32_SPEC_CTRL);
+
+	/*
+	 * If the guest/host SPEC_CTRL values differ, restore the host value.
+	 *
+	 * For legacy IBRS, the IBRS bit always needs to be written after
+	 * transitioning from a less privileged predictor mode, regardless of
+	 * whether the guest/host values differ.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) ||
+	    vmx->spec_ctrl != hostval)
+		native_wrmsrl(MSR_IA32_SPEC_CTRL, hostval);
+
+	barrier_nospec();
+}
+
 static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
 	switch (to_vmx(vcpu)->exit_reason.basic) {
@@ -6667,7 +6710,8 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 }
 
 static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
-					struct vcpu_vmx *vmx)
+					struct vcpu_vmx *vmx,
+					unsigned long flags)
 {
 	kvm_guest_enter_irqoff();
 
@@ -6686,7 +6730,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 		native_write_cr2(vcpu->arch.cr2);
 
 	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
-				   vmx->loaded_vmcs->launched);
+				   flags);
 
 	vcpu->arch.cr2 = native_read_cr2();
 
@@ -6786,27 +6830,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
 
 	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
-	vmx_vcpu_enter_exit(vcpu, vmx);
-
-	/*
-	 * We do not use IBRS in the kernel. If this vCPU has used the
-	 * SPEC_CTRL MSR it may have left it on; save the value and
-	 * turn it off. This is much more efficient than blindly adding
-	 * it to the atomic save/restore list. Especially as the former
-	 * (Saving guest MSRs on vmexit) doesn't even exist in KVM.
-	 *
-	 * For non-nested case:
-	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 *
-	 * For nested case:
-	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 */
-	if (unlikely(!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL)))
-		vmx->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
-
-	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
+	vmx_vcpu_enter_exit(vcpu, vmx, __vmx_vcpu_run_flags(vmx));
 
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs)) {
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 12fe7b31cbf6..a8b8150252bb 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -13,6 +13,7 @@
 #include "vmcs.h"
 #include "vmx_ops.h"
 #include "cpuid.h"
+#include "run_flags.h"
 
 #define MSR_TYPE_R	1
 #define MSR_TYPE_W	2
@@ -382,7 +383,10 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
-bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
+void vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx, unsigned int flags);
+unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx);
+bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs,
+		    unsigned int flags);
 int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 732c3f2f8ded..4525d0b25a43 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12179,9 +12179,9 @@ void kvm_arch_end_assignment(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_end_assignment);
 
-bool kvm_arch_has_assigned_device(struct kvm *kvm)
+bool noinstr kvm_arch_has_assigned_device(struct kvm *kvm)
 {
-	return atomic_read(&kvm->arch.assigned_device_count);
+	return arch_atomic_read(&kvm->arch.assigned_device_count);
 }
 EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);
 
diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index 50ea390df712..4b8ee3a2fcc3 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -40,7 +40,7 @@ SYM_FUNC_START(__memmove)
 	/* FSRM implies ERMS => no length checks, do the copy directly */
 .Lmemmove_begin_forward:
 	ALTERNATIVE "cmp $0x20, %rdx; jb 1f", "", X86_FEATURE_FSRM
-	ALTERNATIVE "", __stringify(movq %rdx, %rcx; rep movsb; RET), X86_FEATURE_ERMS
+	ALTERNATIVE "", "jmp .Lmemmove_erms", X86_FEATURE_ERMS
 
 	/*
 	 * movsq instruction have many startup latency
@@ -206,6 +206,11 @@ SYM_FUNC_START(__memmove)
 	movb %r11b, (%rdi)
 13:
 	RET
+
+.Lmemmove_erms:
+	movq %rdx, %rcx
+	rep movsb
+	RET
 SYM_FUNC_END(__memmove)
 SYM_FUNC_END_ALIAS(memmove)
 EXPORT_SYMBOL(__memmove)
diff --git a/arch/x86/lib/retpoline.S b/arch/x86/lib/retpoline.S
index 9556ff5f4773..1221bb099afb 100644
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -28,45 +28,13 @@
 
 .macro THUNK reg
 
-	.align 32
-
-SYM_FUNC_START(__x86_indirect_thunk_\reg)
-
-	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), \
-		      __stringify(RETPOLINE \reg), X86_FEATURE_RETPOLINE, \
-		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg; int3), X86_FEATURE_RETPOLINE_LFENCE
-
-SYM_FUNC_END(__x86_indirect_thunk_\reg)
-
-.endm
-
-/*
- * This generates .altinstr_replacement symbols for use by objtool. They,
- * however, must not actually live in .altinstr_replacement since that will be
- * discarded after init, but module alternatives will also reference these
- * symbols.
- *
- * Their names matches the "__x86_indirect_" prefix to mark them as retpolines.
- */
-.macro ALT_THUNK reg
-
-	.align 1
-
-SYM_FUNC_START_NOALIGN(__x86_indirect_alt_call_\reg)
-	ANNOTATE_RETPOLINE_SAFE
-1:	call	*%\reg
-2:	.skip	5-(2b-1b), 0x90
-SYM_FUNC_END(__x86_indirect_alt_call_\reg)
-
-STACK_FRAME_NON_STANDARD(__x86_indirect_alt_call_\reg)
-
-SYM_FUNC_START_NOALIGN(__x86_indirect_alt_jmp_\reg)
-	ANNOTATE_RETPOLINE_SAFE
-1:	jmp	*%\reg
-2:	.skip	5-(2b-1b), 0x90
-SYM_FUNC_END(__x86_indirect_alt_jmp_\reg)
+	.align RETPOLINE_THUNK_SIZE
+SYM_INNER_LABEL(__x86_indirect_thunk_\reg, SYM_L_GLOBAL)
+	UNWIND_HINT_EMPTY
 
-STACK_FRAME_NON_STANDARD(__x86_indirect_alt_jmp_\reg)
+	ALTERNATIVE_2 __stringify(RETPOLINE \reg), \
+		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg; int3), X86_FEATURE_RETPOLINE_LFENCE, \
+		      __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), ALT_NOT(X86_FEATURE_RETPOLINE)
 
 .endm
 
@@ -85,22 +53,89 @@ STACK_FRAME_NON_STANDARD(__x86_indirect_alt_jmp_\reg)
 #define __EXPORT_THUNK(sym)	_ASM_NOKPROBE(sym); EXPORT_SYMBOL(sym)
 #define EXPORT_THUNK(reg)	__EXPORT_THUNK(__x86_indirect_thunk_ ## reg)
 
-#undef GEN
+	.align RETPOLINE_THUNK_SIZE
+SYM_CODE_START(__x86_indirect_thunk_array)
+
 #define GEN(reg) THUNK reg
 #include <asm/GEN-for-each-reg.h>
-
 #undef GEN
+
+	.align RETPOLINE_THUNK_SIZE
+SYM_CODE_END(__x86_indirect_thunk_array)
+
 #define GEN(reg) EXPORT_THUNK(reg)
 #include <asm/GEN-for-each-reg.h>
-
 #undef GEN
-#define GEN(reg) ALT_THUNK reg
-#include <asm/GEN-for-each-reg.h>
 
-#undef GEN
-#define GEN(reg) __EXPORT_THUNK(__x86_indirect_alt_call_ ## reg)
-#include <asm/GEN-for-each-reg.h>
+/*
+ * This function name is magical and is used by -mfunction-return=thunk-extern
+ * for the compiler to generate JMPs to it.
+ */
+#ifdef CONFIG_RETHUNK
 
-#undef GEN
-#define GEN(reg) __EXPORT_THUNK(__x86_indirect_alt_jmp_ ## reg)
-#include <asm/GEN-for-each-reg.h>
+	.section .text.__x86.return_thunk
+
+/*
+ * Safety details here pertain to the AMD Zen{1,2} microarchitecture:
+ * 1) The RET at __x86_return_thunk must be on a 64 byte boundary, for
+ *    alignment within the BTB.
+ * 2) The instruction at zen_untrain_ret must contain, and not
+ *    end with, the 0xc3 byte of the RET.
+ * 3) STIBP must be enabled, or SMT disabled, to prevent the sibling thread
+ *    from re-poisioning the BTB prediction.
+ */
+	.align 64
+	.skip 63, 0xcc
+SYM_FUNC_START_NOALIGN(zen_untrain_ret);
+
+	/*
+	 * As executed from zen_untrain_ret, this is:
+	 *
+	 *   TEST $0xcc, %bl
+	 *   LFENCE
+	 *   JMP __x86_return_thunk
+	 *
+	 * Executing the TEST instruction has a side effect of evicting any BTB
+	 * prediction (potentially attacker controlled) attached to the RET, as
+	 * __x86_return_thunk + 1 isn't an instruction boundary at the moment.
+	 */
+	.byte	0xf6
+
+	/*
+	 * As executed from __x86_return_thunk, this is a plain RET.
+	 *
+	 * As part of the TEST above, RET is the ModRM byte, and INT3 the imm8.
+	 *
+	 * We subsequently jump backwards and architecturally execute the RET.
+	 * This creates a correct BTB prediction (type=ret), but in the
+	 * meantime we suffer Straight Line Speculation (because the type was
+	 * no branch) which is halted by the INT3.
+	 *
+	 * With SMT enabled and STIBP active, a sibling thread cannot poison
+	 * RET's prediction to a type of its choice, but can evict the
+	 * prediction due to competitive sharing. If the prediction is
+	 * evicted, __x86_return_thunk will suffer Straight Line Speculation
+	 * which will be contained safely by the INT3.
+	 */
+SYM_INNER_LABEL(__x86_return_thunk, SYM_L_GLOBAL)
+	ret
+	int3
+SYM_CODE_END(__x86_return_thunk)
+
+	/*
+	 * Ensure the TEST decoding / BTB invalidation is complete.
+	 */
+	lfence
+
+	/*
+	 * Jump back and execute the RET in the middle of the TEST instruction.
+	 * INT3 is for SLS protection.
+	 */
+	jmp __x86_return_thunk
+	int3
+SYM_FUNC_END(zen_untrain_ret)
+__EXPORT_THUNK(zen_untrain_ret)
+
+EXPORT_SYMBOL(__x86_return_thunk)
+
+#endif /* CONFIG_RETHUNK */
diff --git a/arch/x86/mm/mem_encrypt_boot.S b/arch/x86/mm/mem_encrypt_boot.S
index 3d1dba05fce4..9de3d900bc92 100644
--- a/arch/x86/mm/mem_encrypt_boot.S
+++ b/arch/x86/mm/mem_encrypt_boot.S
@@ -65,7 +65,10 @@ SYM_FUNC_START(sme_encrypt_execute)
 	movq	%rbp, %rsp		/* Restore original stack pointer */
 	pop	%rbp
 
-	RET
+	/* Offset to __x86_return_thunk would be wrong here */
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_FUNC_END(sme_encrypt_execute)
 
 SYM_FUNC_START(__enc_copy)
@@ -151,6 +154,9 @@ SYM_FUNC_START(__enc_copy)
 	pop	%r12
 	pop	%r15
 
-	RET
+	/* Offset to __x86_return_thunk would be wrong here */
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 .L__enc_copy_end:
 SYM_FUNC_END(__enc_copy)
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 8dca2bcbb0ea..131f7ceb54dc 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -15,7 +15,6 @@
 #include <asm/set_memory.h>
 #include <asm/nospec-branch.h>
 #include <asm/text-patching.h>
-#include <asm/asm-prototypes.h>
 
 static u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
 {
@@ -225,6 +224,14 @@ static void jit_fill_hole(void *area, unsigned int size)
 
 struct jit_context {
 	int cleanup_addr; /* Epilogue code offset */
+
+	/*
+	 * Program specific offsets of labels in the code; these rely on the
+	 * JIT doing at least 2 passes, recording the position on the first
+	 * pass, only to generate the correct offset on the second pass.
+	 */
+	int tail_call_direct_label;
+	int tail_call_indirect_label;
 };
 
 /* Maximum number of bytes emitted while JITing one eBPF insn */
@@ -380,20 +387,38 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 	return __bpf_arch_text_poke(ip, t, old_addr, new_addr, true);
 }
 
-static int get_pop_bytes(bool *callee_regs_used)
+#define EMIT_LFENCE()	EMIT3(0x0F, 0xAE, 0xE8)
+
+static void emit_indirect_jump(u8 **pprog, int reg, u8 *ip)
 {
-	int bytes = 0;
+	u8 *prog = *pprog;
 
-	if (callee_regs_used[3])
-		bytes += 2;
-	if (callee_regs_used[2])
-		bytes += 2;
-	if (callee_regs_used[1])
-		bytes += 2;
-	if (callee_regs_used[0])
-		bytes += 1;
+#ifdef CONFIG_RETPOLINE
+	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE)) {
+		EMIT_LFENCE();
+		EMIT2(0xFF, 0xE0 + reg);
+	} else if (cpu_feature_enabled(X86_FEATURE_RETPOLINE)) {
+		emit_jump(&prog, &__x86_indirect_thunk_array[reg], ip);
+	} else
+#endif
+	EMIT2(0xFF, 0xE0 + reg);
 
-	return bytes;
+	*pprog = prog;
+}
+
+static void emit_return(u8 **pprog, u8 *ip)
+{
+	u8 *prog = *pprog;
+
+	if (cpu_feature_enabled(X86_FEATURE_RETHUNK)) {
+		emit_jump(&prog, &__x86_return_thunk, ip);
+	} else {
+		EMIT1(0xC3);		/* ret */
+		if (IS_ENABLED(CONFIG_SLS))
+			EMIT1(0xCC);	/* int3 */
+	}
+
+	*pprog = prog;
 }
 
 /*
@@ -411,29 +436,12 @@ static int get_pop_bytes(bool *callee_regs_used)
  * out:
  */
 static void emit_bpf_tail_call_indirect(u8 **pprog, bool *callee_regs_used,
-					u32 stack_depth)
+					u32 stack_depth, u8 *ip,
+					struct jit_context *ctx)
 {
 	int tcc_off = -4 - round_up(stack_depth, 8);
-	u8 *prog = *pprog;
-	int pop_bytes = 0;
-	int off1 = 42;
-	int off2 = 31;
-	int off3 = 9;
-
-	/* count the additional bytes used for popping callee regs from stack
-	 * that need to be taken into account for each of the offsets that
-	 * are used for bailing out of the tail call
-	 */
-	pop_bytes = get_pop_bytes(callee_regs_used);
-	off1 += pop_bytes;
-	off2 += pop_bytes;
-	off3 += pop_bytes;
-
-	if (stack_depth) {
-		off1 += 7;
-		off2 += 7;
-		off3 += 7;
-	}
+	u8 *prog = *pprog, *start = *pprog;
+	int offset;
 
 	/*
 	 * rdi - pointer to ctx
@@ -448,8 +456,9 @@ static void emit_bpf_tail_call_indirect(u8 **pprog, bool *callee_regs_used,
 	EMIT2(0x89, 0xD2);                        /* mov edx, edx */
 	EMIT3(0x39, 0x56,                         /* cmp dword ptr [rsi + 16], edx */
 	      offsetof(struct bpf_array, map.max_entries));
-#define OFFSET1 (off1 + RETPOLINE_RCX_BPF_JIT_SIZE) /* Number of bytes to jump */
-	EMIT2(X86_JBE, OFFSET1);                  /* jbe out */
+
+	offset = ctx->tail_call_indirect_label - (prog + 2 - start);
+	EMIT2(X86_JBE, offset);                   /* jbe out */
 
 	/*
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
@@ -457,8 +466,9 @@ static void emit_bpf_tail_call_indirect(u8 **pprog, bool *callee_regs_used,
 	 */
 	EMIT2_off32(0x8B, 0x85, tcc_off);         /* mov eax, dword ptr [rbp - tcc_off] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
-#define OFFSET2 (off2 + RETPOLINE_RCX_BPF_JIT_SIZE)
-	EMIT2(X86_JA, OFFSET2);                   /* ja out */
+
+	offset = ctx->tail_call_indirect_label - (prog + 2 - start);
+	EMIT2(X86_JA, offset);                    /* ja out */
 	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
 	EMIT2_off32(0x89, 0x85, tcc_off);         /* mov dword ptr [rbp - tcc_off], eax */
 
@@ -471,12 +481,11 @@ static void emit_bpf_tail_call_indirect(u8 **pprog, bool *callee_regs_used,
 	 *	goto out;
 	 */
 	EMIT3(0x48, 0x85, 0xC9);                  /* test rcx,rcx */
-#define OFFSET3 (off3 + RETPOLINE_RCX_BPF_JIT_SIZE)
-	EMIT2(X86_JE, OFFSET3);                   /* je out */
 
-	*pprog = prog;
-	pop_callee_regs(pprog, callee_regs_used);
-	prog = *pprog;
+	offset = ctx->tail_call_indirect_label - (prog + 2 - start);
+	EMIT2(X86_JE, offset);                    /* je out */
+
+	pop_callee_regs(&prog, callee_regs_used);
 
 	EMIT1(0x58);                              /* pop rax */
 	if (stack_depth)
@@ -493,41 +502,21 @@ static void emit_bpf_tail_call_indirect(u8 **pprog, bool *callee_regs_used,
 	 * rdi == ctx (1st arg)
 	 * rcx == prog->bpf_func + X86_TAIL_CALL_OFFSET
 	 */
-	RETPOLINE_RCX_BPF_JIT();
+	emit_indirect_jump(&prog, 1 /* rcx */, ip + (prog - start));
 
 	/* out: */
+	ctx->tail_call_indirect_label = prog - start;
 	*pprog = prog;
 }
 
 static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
-				      u8 **pprog, int addr, u8 *image,
-				      bool *callee_regs_used, u32 stack_depth)
+				      u8 **pprog, u8 *ip,
+				      bool *callee_regs_used, u32 stack_depth,
+				      struct jit_context *ctx)
 {
 	int tcc_off = -4 - round_up(stack_depth, 8);
-	u8 *prog = *pprog;
-	int pop_bytes = 0;
-	int off1 = 20;
-	int poke_off;
-
-	/* count the additional bytes used for popping callee regs to stack
-	 * that need to be taken into account for jump offset that is used for
-	 * bailing out from of the tail call when limit is reached
-	 */
-	pop_bytes = get_pop_bytes(callee_regs_used);
-	off1 += pop_bytes;
-
-	/*
-	 * total bytes for:
-	 * - nop5/ jmpq $off
-	 * - pop callee regs
-	 * - sub rsp, $val if depth > 0
-	 * - pop rax
-	 */
-	poke_off = X86_PATCH_SIZE + pop_bytes + 1;
-	if (stack_depth) {
-		poke_off += 7;
-		off1 += 7;
-	}
+	u8 *prog = *pprog, *start = *pprog;
+	int offset;
 
 	/*
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
@@ -535,28 +524,30 @@ static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
 	 */
 	EMIT2_off32(0x8B, 0x85, tcc_off);             /* mov eax, dword ptr [rbp - tcc_off] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);         /* cmp eax, MAX_TAIL_CALL_CNT */
-	EMIT2(X86_JA, off1);                          /* ja out */
+
+	offset = ctx->tail_call_direct_label - (prog + 2 - start);
+	EMIT2(X86_JA, offset);                        /* ja out */
 	EMIT3(0x83, 0xC0, 0x01);                      /* add eax, 1 */
 	EMIT2_off32(0x89, 0x85, tcc_off);             /* mov dword ptr [rbp - tcc_off], eax */
 
-	poke->tailcall_bypass = image + (addr - poke_off - X86_PATCH_SIZE);
+	poke->tailcall_bypass = ip + (prog - start);
 	poke->adj_off = X86_TAIL_CALL_OFFSET;
-	poke->tailcall_target = image + (addr - X86_PATCH_SIZE);
+	poke->tailcall_target = ip + ctx->tail_call_direct_label - X86_PATCH_SIZE;
 	poke->bypass_addr = (u8 *)poke->tailcall_target + X86_PATCH_SIZE;
 
 	emit_jump(&prog, (u8 *)poke->tailcall_target + X86_PATCH_SIZE,
 		  poke->tailcall_bypass);
 
-	*pprog = prog;
-	pop_callee_regs(pprog, callee_regs_used);
-	prog = *pprog;
+	pop_callee_regs(&prog, callee_regs_used);
 	EMIT1(0x58);                                  /* pop rax */
 	if (stack_depth)
 		EMIT3_off32(0x48, 0x81, 0xC4, round_up(stack_depth, 8));
 
 	memcpy(prog, x86_nops[5], X86_PATCH_SIZE);
 	prog += X86_PATCH_SIZE;
+
 	/* out: */
+	ctx->tail_call_direct_label = prog - start;
 
 	*pprog = prog;
 }
@@ -1228,8 +1219,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			/* speculation barrier */
 		case BPF_ST | BPF_NOSPEC:
 			if (boot_cpu_has(X86_FEATURE_XMM2))
-				/* Emit 'lfence' */
-				EMIT3(0x0F, 0xAE, 0xE8);
+				EMIT_LFENCE();
 			break;
 
 			/* ST: *(u8*)(dst_reg + off) = imm */
@@ -1454,13 +1444,16 @@ st:			if (is_imm8(insn->off))
 		case BPF_JMP | BPF_TAIL_CALL:
 			if (imm32)
 				emit_bpf_tail_call_direct(&bpf_prog->aux->poke_tab[imm32 - 1],
-							  &prog, addrs[i], image,
+							  &prog, image + addrs[i - 1],
 							  callee_regs_used,
-							  bpf_prog->aux->stack_depth);
+							  bpf_prog->aux->stack_depth,
+							  ctx);
 			else
 				emit_bpf_tail_call_indirect(&prog,
 							    callee_regs_used,
-							    bpf_prog->aux->stack_depth);
+							    bpf_prog->aux->stack_depth,
+							    image + addrs[i - 1],
+							    ctx);
 			break;
 
 			/* cond jump */
@@ -1703,7 +1696,7 @@ st:			if (is_imm8(insn->off))
 			ctx->cleanup_addr = proglen;
 			pop_callee_regs(&prog, callee_regs_used);
 			EMIT1(0xC9);         /* leave */
-			EMIT1(0xC3);         /* ret */
+			emit_return(&prog, image + addrs[i - 1] + (prog - temp));
 			break;
 
 		default:
@@ -2149,7 +2142,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	if (flags & BPF_TRAMP_F_SKIP_FRAME)
 		/* skip our return address and return to parent */
 		EMIT4(0x48, 0x83, 0xC4, 8); /* add rsp, 8 */
-	EMIT1(0xC3); /* ret */
+	emit_return(&prog, prog);
 	/* Make sure the trampoline generation logic doesn't overflow */
 	if (WARN_ON_ONCE(prog > (u8 *)image_end - BPF_INSN_SAFETY)) {
 		ret = -EFAULT;
@@ -2162,24 +2155,6 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	return ret;
 }
 
-static int emit_fallback_jump(u8 **pprog)
-{
-	u8 *prog = *pprog;
-	int err = 0;
-
-#ifdef CONFIG_RETPOLINE
-	/* Note that this assumes the the compiler uses external
-	 * thunks for indirect calls. Both clang and GCC use the same
-	 * naming convention for external thunks.
-	 */
-	err = emit_jump(&prog, __x86_indirect_thunk_rdx, prog);
-#else
-	EMIT2(0xFF, 0xE2);	/* jmp rdx */
-#endif
-	*pprog = prog;
-	return err;
-}
-
 static int emit_bpf_dispatcher(u8 **pprog, int a, int b, s64 *progs)
 {
 	u8 *jg_reloc, *prog = *pprog;
@@ -2201,9 +2176,7 @@ static int emit_bpf_dispatcher(u8 **pprog, int a, int b, s64 *progs)
 		if (err)
 			return err;
 
-		err = emit_fallback_jump(&prog);	/* jmp thunk/indirect */
-		if (err)
-			return err;
+		emit_indirect_jump(&prog, 2 /* rdx */, prog);
 
 		*pprog = prog;
 		return 0;
diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index 3bfda5f502cb..da9b7cfa4632 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -15,6 +15,7 @@
 #include <asm/cacheflush.h>
 #include <asm/set_memory.h>
 #include <asm/nospec-branch.h>
+#include <asm/asm-prototypes.h>
 #include <linux/bpf.h>
 
 /*
@@ -1267,6 +1268,21 @@ static void emit_epilogue(u8 **pprog, u32 stack_depth)
 	*pprog = prog;
 }
 
+static int emit_jmp_edx(u8 **pprog, u8 *ip)
+{
+	u8 *prog = *pprog;
+	int cnt = 0;
+
+#ifdef CONFIG_RETPOLINE
+	EMIT1_off32(0xE9, (u8 *)__x86_indirect_thunk_edx - (ip + 5));
+#else
+	EMIT2(0xFF, 0xE2);
+#endif
+	*pprog = prog;
+
+	return cnt;
+}
+
 /*
  * Generate the following code:
  * ... bpf_tail_call(void *ctx, struct bpf_array *array, u64 index) ...
@@ -1280,7 +1296,7 @@ static void emit_epilogue(u8 **pprog, u32 stack_depth)
  *   goto *(prog->bpf_func + prologue_size);
  * out:
  */
-static void emit_bpf_tail_call(u8 **pprog)
+static void emit_bpf_tail_call(u8 **pprog, u8 *ip)
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
@@ -1362,7 +1378,7 @@ static void emit_bpf_tail_call(u8 **pprog)
 	 * eax == ctx (1st arg)
 	 * edx == prog->bpf_func + prologue_size
 	 */
-	RETPOLINE_EDX_BPF_JIT();
+	cnt += emit_jmp_edx(&prog, ip + cnt);
 
 	if (jmp_label1 == -1)
 		jmp_label1 = cnt;
@@ -2122,7 +2138,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			break;
 		}
 		case BPF_JMP | BPF_TAIL_CALL:
-			emit_bpf_tail_call(&prog);
+			emit_bpf_tail_call(&prog, image + addrs[i - 1]);
 			break;
 
 		/* cond jump */
diff --git a/arch/x86/platform/efi/efi_thunk_64.S b/arch/x86/platform/efi/efi_thunk_64.S
index f2a8eec69f8f..a7ffe30e8614 100644
--- a/arch/x86/platform/efi/efi_thunk_64.S
+++ b/arch/x86/platform/efi/efi_thunk_64.S
@@ -22,6 +22,7 @@
 #include <linux/linkage.h>
 #include <asm/page_types.h>
 #include <asm/segment.h>
+#include <asm/nospec-branch.h>
 
 	.text
 	.code64
@@ -63,7 +64,9 @@ SYM_CODE_START(__efi64_thunk)
 1:	movq	24(%rsp), %rsp
 	pop	%rbx
 	pop	%rbp
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 
 	.code32
 2:	pushl	$__KERNEL_CS
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 8bfc10330107..1f80dd3a2dd4 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -922,7 +922,7 @@ void xen_enable_sysenter(void)
 	if (!boot_cpu_has(sysenter_feature))
 		return;
 
-	ret = register_callback(CALLBACKTYPE_sysenter, xen_sysenter_target);
+	ret = register_callback(CALLBACKTYPE_sysenter, xen_entry_SYSENTER_compat);
 	if(ret != 0)
 		setup_clear_cpu_cap(sysenter_feature);
 }
@@ -931,7 +931,7 @@ void xen_enable_syscall(void)
 {
 	int ret;
 
-	ret = register_callback(CALLBACKTYPE_syscall, xen_syscall_target);
+	ret = register_callback(CALLBACKTYPE_syscall, xen_entry_SYSCALL_64);
 	if (ret != 0) {
 		printk(KERN_ERR "Failed to set syscall callback: %d\n", ret);
 		/* Pretty fatal; 64-bit userspace has no other
@@ -940,7 +940,7 @@ void xen_enable_syscall(void)
 
 	if (boot_cpu_has(X86_FEATURE_SYSCALL32)) {
 		ret = register_callback(CALLBACKTYPE_syscall32,
-					xen_syscall32_target);
+					xen_entry_SYSCALL_compat);
 		if (ret != 0)
 			setup_clear_cpu_cap(X86_FEATURE_SYSCALL32);
 	}
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index 962d30ea01a2..1b757a1ee1bb 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -120,7 +120,7 @@ SYM_FUNC_END(xen_read_cr2_direct);
 
 .macro xen_pv_trap name
 SYM_CODE_START(xen_\name)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_ENTRY
 	pop %rcx
 	pop %r11
 	jmp  \name
@@ -227,8 +227,8 @@ SYM_CODE_END(xenpv_restore_regs_and_return_to_usermode)
  */
 
 /* Normal 64-bit system call target */
-SYM_CODE_START(xen_syscall_target)
-	UNWIND_HINT_EMPTY
+SYM_CODE_START(xen_entry_SYSCALL_64)
+	UNWIND_HINT_ENTRY
 	popq %rcx
 	popq %r11
 
@@ -241,13 +241,13 @@ SYM_CODE_START(xen_syscall_target)
 	movq $__USER_CS, 1*8(%rsp)
 
 	jmp entry_SYSCALL_64_after_hwframe
-SYM_CODE_END(xen_syscall_target)
+SYM_CODE_END(xen_entry_SYSCALL_64)
 
 #ifdef CONFIG_IA32_EMULATION
 
 /* 32-bit compat syscall target */
-SYM_CODE_START(xen_syscall32_target)
-	UNWIND_HINT_EMPTY
+SYM_CODE_START(xen_entry_SYSCALL_compat)
+	UNWIND_HINT_ENTRY
 	popq %rcx
 	popq %r11
 
@@ -260,11 +260,11 @@ SYM_CODE_START(xen_syscall32_target)
 	movq $__USER32_CS, 1*8(%rsp)
 
 	jmp entry_SYSCALL_compat_after_hwframe
-SYM_CODE_END(xen_syscall32_target)
+SYM_CODE_END(xen_entry_SYSCALL_compat)
 
 /* 32-bit compat sysenter target */
-SYM_CODE_START(xen_sysenter_target)
-	UNWIND_HINT_EMPTY
+SYM_CODE_START(xen_entry_SYSENTER_compat)
+	UNWIND_HINT_ENTRY
 	/*
 	 * NB: Xen is polite and clears TF from EFLAGS for us.  This means
 	 * that we don't need to guard against single step exceptions here.
@@ -281,18 +281,18 @@ SYM_CODE_START(xen_sysenter_target)
 	movq $__USER32_CS, 1*8(%rsp)
 
 	jmp entry_SYSENTER_compat_after_hwframe
-SYM_CODE_END(xen_sysenter_target)
+SYM_CODE_END(xen_entry_SYSENTER_compat)
 
 #else /* !CONFIG_IA32_EMULATION */
 
-SYM_CODE_START(xen_syscall32_target)
-SYM_CODE_START(xen_sysenter_target)
-	UNWIND_HINT_EMPTY
+SYM_CODE_START(xen_entry_SYSCALL_compat)
+SYM_CODE_START(xen_entry_SYSENTER_compat)
+	UNWIND_HINT_ENTRY
 	lea 16(%rsp), %rsp	/* strip %rcx, %r11 */
 	mov $-ENOSYS, %rax
 	pushq $0
 	jmp hypercall_iret
-SYM_CODE_END(xen_sysenter_target)
-SYM_CODE_END(xen_syscall32_target)
+SYM_CODE_END(xen_entry_SYSENTER_compat)
+SYM_CODE_END(xen_entry_SYSCALL_compat)
 
 #endif	/* CONFIG_IA32_EMULATION */
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 565062932ef1..2a3ef5fcba34 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -69,8 +69,9 @@ SYM_CODE_END(asm_cpu_bringup_and_idle)
 SYM_CODE_START(hypercall_page)
 	.rept (PAGE_SIZE / 32)
 		UNWIND_HINT_FUNC
-		.skip 31, 0x90
-		RET
+		ANNOTATE_UNRET_SAFE
+		ret
+		.skip 31, 0xcc
 	.endr
 
 #define HYPERCALL(n) \
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 8bc8b72a205d..16aed4b12129 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -10,10 +10,10 @@
 /* These are code, but not functions.  Defined in entry.S */
 extern const char xen_failsafe_callback[];
 
-void xen_sysenter_target(void);
+void xen_entry_SYSENTER_compat(void);
 #ifdef CONFIG_X86_64
-void xen_syscall_target(void);
-void xen_syscall32_target(void);
+void xen_entry_SYSCALL_64(void);
+void xen_entry_SYSCALL_compat(void);
 #endif
 
 extern void *xen_initial_gdt;
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index fddd08e482fc..55405ebf23ab 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -570,6 +570,12 @@ ssize_t __weak cpu_show_mmio_stale_data(struct device *dev,
 	return sysfs_emit(buf, "Not affected\n");
 }
 
+ssize_t __weak cpu_show_retbleed(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "Not affected\n");
+}
+
 static DEVICE_ATTR(meltdown, 0444, cpu_show_meltdown, NULL);
 static DEVICE_ATTR(spectre_v1, 0444, cpu_show_spectre_v1, NULL);
 static DEVICE_ATTR(spectre_v2, 0444, cpu_show_spectre_v2, NULL);
@@ -580,6 +586,7 @@ static DEVICE_ATTR(tsx_async_abort, 0444, cpu_show_tsx_async_abort, NULL);
 static DEVICE_ATTR(itlb_multihit, 0444, cpu_show_itlb_multihit, NULL);
 static DEVICE_ATTR(srbds, 0444, cpu_show_srbds, NULL);
 static DEVICE_ATTR(mmio_stale_data, 0444, cpu_show_mmio_stale_data, NULL);
+static DEVICE_ATTR(retbleed, 0444, cpu_show_retbleed, NULL);
 
 static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_meltdown.attr,
@@ -592,6 +599,7 @@ static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_itlb_multihit.attr,
 	&dev_attr_srbds.attr,
 	&dev_attr_mmio_stale_data.attr,
+	&dev_attr_retbleed.attr,
 	NULL
 };
 
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index e6c543b5ee1d..376e631e80d6 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -47,11 +47,13 @@
 #include <linux/tick.h>
 #include <trace/events/power.h>
 #include <linux/sched.h>
+#include <linux/sched/smt.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/moduleparam.h>
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
+#include <asm/nospec-branch.h>
 #include <asm/mwait.h>
 #include <asm/msr.h>
 
@@ -93,6 +95,12 @@ static unsigned int mwait_substates __initdata;
  */
 #define CPUIDLE_FLAG_ALWAYS_ENABLE	BIT(15)
 
+/*
+ * Disable IBRS across idle (when KERNEL_IBRS), is exclusive vs IRQ_ENABLE
+ * above.
+ */
+#define CPUIDLE_FLAG_IBRS		BIT(16)
+
 /*
  * MWAIT takes an 8-bit "hint" in EAX "suggesting"
  * the C-state (top nibble) and sub-state (bottom nibble)
@@ -132,6 +140,24 @@ static __cpuidle int intel_idle(struct cpuidle_device *dev,
 	return index;
 }
 
+static __cpuidle int intel_idle_ibrs(struct cpuidle_device *dev,
+				     struct cpuidle_driver *drv, int index)
+{
+	bool smt_active = sched_smt_active();
+	u64 spec_ctrl = spec_ctrl_current();
+	int ret;
+
+	if (smt_active)
+		wrmsrl(MSR_IA32_SPEC_CTRL, 0);
+
+	ret = intel_idle(dev, drv, index);
+
+	if (smt_active)
+		wrmsrl(MSR_IA32_SPEC_CTRL, spec_ctrl);
+
+	return ret;
+}
+
 /**
  * intel_idle_s2idle - Ask the processor to enter the given idle state.
  * @dev: cpuidle device of the target CPU.
@@ -653,7 +679,7 @@ static struct cpuidle_state skl_cstates[] __initdata = {
 	{
 		.name = "C6",
 		.desc = "MWAIT 0x20",
-		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 85,
 		.target_residency = 200,
 		.enter = &intel_idle,
@@ -661,7 +687,7 @@ static struct cpuidle_state skl_cstates[] __initdata = {
 	{
 		.name = "C7s",
 		.desc = "MWAIT 0x33",
-		.flags = MWAIT2flg(0x33) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x33) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 124,
 		.target_residency = 800,
 		.enter = &intel_idle,
@@ -669,7 +695,7 @@ static struct cpuidle_state skl_cstates[] __initdata = {
 	{
 		.name = "C8",
 		.desc = "MWAIT 0x40",
-		.flags = MWAIT2flg(0x40) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x40) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 200,
 		.target_residency = 800,
 		.enter = &intel_idle,
@@ -677,7 +703,7 @@ static struct cpuidle_state skl_cstates[] __initdata = {
 	{
 		.name = "C9",
 		.desc = "MWAIT 0x50",
-		.flags = MWAIT2flg(0x50) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x50) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 480,
 		.target_residency = 5000,
 		.enter = &intel_idle,
@@ -685,7 +711,7 @@ static struct cpuidle_state skl_cstates[] __initdata = {
 	{
 		.name = "C10",
 		.desc = "MWAIT 0x60",
-		.flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 890,
 		.target_residency = 5000,
 		.enter = &intel_idle,
@@ -714,7 +740,7 @@ static struct cpuidle_state skx_cstates[] __initdata = {
 	{
 		.name = "C6",
 		.desc = "MWAIT 0x20",
-		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 133,
 		.target_residency = 600,
 		.enter = &intel_idle,
@@ -1574,6 +1600,11 @@ static void __init intel_idle_init_cstates_icpu(struct cpuidle_driver *drv)
 		/* Structure copy. */
 		drv->states[drv->state_count] = cpuidle_state_table[cstate];
 
+		if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) &&
+		    cpuidle_state_table[cstate].flags & CPUIDLE_FLAG_IBRS) {
+			drv->states[drv->state_count].enter = intel_idle_ibrs;
+		}
+
 		if ((disabled_states_mask & BIT(drv->state_count)) ||
 		    ((icpu->use_acpi || force_use_acpi) &&
 		     intel_idle_off_by_default(mwait_hint) &&
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index eb3394f5b109..6102a21a01d9 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -68,6 +68,8 @@ extern ssize_t cpu_show_srbds(struct device *dev, struct device_attribute *attr,
 extern ssize_t cpu_show_mmio_stale_data(struct device *dev,
 					struct device_attribute *attr,
 					char *buf);
+extern ssize_t cpu_show_retbleed(struct device *dev,
+				 struct device_attribute *attr, char *buf);
 
 extern __printf(4, 5)
 struct device *cpu_device_create(struct device *parent, void *drvdata,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 926f60499c34..fb70dd4ff3b6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1233,7 +1233,7 @@ static inline void kvm_arch_end_assignment(struct kvm *kvm)
 {
 }
 
-static inline bool kvm_arch_has_assigned_device(struct kvm *kvm)
+static __always_inline bool kvm_arch_has_assigned_device(struct kvm *kvm)
 {
 	return false;
 }
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 7e72d975cb76..a2042c418686 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -32,11 +32,16 @@ struct unwind_hint {
  *
  * UNWIND_HINT_FUNC: Generate the unwind metadata of a callable function.
  * Useful for code which doesn't have an ELF function annotation.
+ *
+ * UNWIND_HINT_ENTRY: machine entry without stack, SYSCALL/SYSENTER etc.
  */
 #define UNWIND_HINT_TYPE_CALL		0
 #define UNWIND_HINT_TYPE_REGS		1
 #define UNWIND_HINT_TYPE_REGS_PARTIAL	2
 #define UNWIND_HINT_TYPE_FUNC		3
+#define UNWIND_HINT_TYPE_ENTRY		4
+#define UNWIND_HINT_TYPE_SAVE		5
+#define UNWIND_HINT_TYPE_RESTORE	6
 
 #ifdef CONFIG_STACK_VALIDATION
 
@@ -99,7 +104,7 @@ struct unwind_hint {
  * the debuginfo as necessary.  It will also warn if it sees any
  * inconsistencies.
  */
-.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 end=0
 .Lunwind_hint_ip_\@:
 	.pushsection .discard.unwind_hints
 		/* struct unwind_hint */
@@ -129,7 +134,7 @@ struct unwind_hint {
 #define STACK_FRAME_NON_STANDARD(func)
 #else
 #define ANNOTATE_INTRA_FUNCTION_CALL
-.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 end=0
 .endm
 .macro STACK_FRAME_NON_STANDARD func:req
 .endm
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 2b988b6ccacb..17aa8ef2d52a 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -231,6 +231,7 @@ objtool_args =								\
 	$(if $(CONFIG_FRAME_POINTER),, --no-fp)				\
 	$(if $(CONFIG_GCOV_KERNEL)$(CONFIG_LTO_CLANG), --no-unreachable)\
 	$(if $(CONFIG_RETPOLINE), --retpoline)				\
+	$(if $(CONFIG_RETHUNK), --rethunk)				\
 	$(if $(CONFIG_X86_SMAP), --uaccess)				\
 	$(if $(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL), --mcount)		\
 	$(if $(CONFIG_SLS), --sls)
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 59a3df87907e..3819a461465d 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -120,6 +120,9 @@ objtool_link()
 
 	if [ -n "${CONFIG_VMLINUX_VALIDATION}" ]; then
 		objtoolopt="${objtoolopt} --noinstr"
+		if is_enabled CONFIG_CPU_UNRET_ENTRY; then
+			objtoolopt="${objtoolopt} --unret"
+		fi
 	fi
 
 	if [ -n "${objtoolopt}" ]; then
diff --git a/security/Kconfig b/security/Kconfig
index fe6c0395fa02..5d412b3ddc49 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -54,17 +54,6 @@ config SECURITY_NETWORK
 	  implement socket and networking access controls.
 	  If you are unsure how to answer this question, answer N.
 
-config PAGE_TABLE_ISOLATION
-	bool "Remove the kernel mapping in user mode"
-	default y
-	depends on (X86_64 || X86_PAE) && !UML
-	help
-	  This feature reduces the number of hardware side channels by
-	  ensuring that the majority of kernel addresses are not mapped
-	  into userspace.
-
-	  See Documentation/x86/pti.rst for more details.
-
 config SECURITY_INFINIBAND
 	bool "Infiniband Security Hooks"
 	depends on SECURITY && INFINIBAND
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index 96eefc05387a..3781a7f489ef 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -203,8 +203,8 @@
 #define X86_FEATURE_PROC_FEEDBACK	( 7*32+ 9) /* AMD ProcFeedbackInterface */
 /* FREE!                                ( 7*32+10) */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
-#define X86_FEATURE_RETPOLINE		( 7*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
-#define X86_FEATURE_RETPOLINE_LFENCE	( 7*32+13) /* "" Use LFENCEs for Spectre variant 2 */
+#define X86_FEATURE_KERNEL_IBRS		( 7*32+12) /* "" Set/clear IBRS on kernel entry/exit */
+#define X86_FEATURE_RSB_VMEXIT		( 7*32+13) /* "" Fill RSB on VM-Exit */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_CDP_L2		( 7*32+15) /* Code and Data Prioritization L2 */
 #define X86_FEATURE_MSR_SPEC_CTRL	( 7*32+16) /* "" MSR SPEC_CTRL is implemented */
@@ -294,6 +294,12 @@
 #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
 #define X86_FEATURE_SGX1		(11*32+ 8) /* "" Basic SGX */
 #define X86_FEATURE_SGX2		(11*32+ 9) /* "" SGX Enclave Dynamic Memory Management (EDMM) */
+#define X86_FEATURE_ENTRY_IBPB		(11*32+10) /* "" Issue an IBPB on kernel entry */
+#define X86_FEATURE_RRSBA_CTRL		(11*32+11) /* "" RET prediction control */
+#define X86_FEATURE_RETPOLINE		(11*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
+#define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
+#define X86_FEATURE_RETHUNK		(11*32+14) /* "" Use REturn THUNK */
+#define X86_FEATURE_UNRET		(11*32+15) /* "" AMD BTB untrain return */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
@@ -313,6 +319,7 @@
 #define X86_FEATURE_AMD_SSBD		(13*32+24) /* "" Speculative Store Bypass Disable */
 #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* Virtualized Speculative Store Bypass Disable */
 #define X86_FEATURE_AMD_SSB_NO		(13*32+26) /* "" Speculative Store Bypass is fixed in hardware. */
+#define X86_FEATURE_BTC_NO		(13*32+29) /* "" Not vulnerable to Branch Type Confusion */
 
 /* Thermal and Power Management Leaf, CPUID level 0x00000006 (EAX), word 14 */
 #define X86_FEATURE_DTHERM		(14*32+ 0) /* Digital Thermal Sensor */
@@ -437,5 +444,6 @@
 #define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
+#define X86_BUG_RETBLEED		X86_BUG(26) /* CPU is affected by RETBleed */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/tools/arch/x86/include/asm/disabled-features.h b/tools/arch/x86/include/asm/disabled-features.h
index 8f28fafa98b3..834a3b6d81e1 100644
--- a/tools/arch/x86/include/asm/disabled-features.h
+++ b/tools/arch/x86/include/asm/disabled-features.h
@@ -56,6 +56,25 @@
 # define DISABLE_PTI		(1 << (X86_FEATURE_PTI & 31))
 #endif
 
+#ifdef CONFIG_RETPOLINE
+# define DISABLE_RETPOLINE	0
+#else
+# define DISABLE_RETPOLINE	((1 << (X86_FEATURE_RETPOLINE & 31)) | \
+				 (1 << (X86_FEATURE_RETPOLINE_LFENCE & 31)))
+#endif
+
+#ifdef CONFIG_RETHUNK
+# define DISABLE_RETHUNK	0
+#else
+# define DISABLE_RETHUNK	(1 << (X86_FEATURE_RETHUNK & 31))
+#endif
+
+#ifdef CONFIG_CPU_UNRET_ENTRY
+# define DISABLE_UNRET		0
+#else
+# define DISABLE_UNRET		(1 << (X86_FEATURE_UNRET & 31))
+#endif
+
 /* Force disable because it's broken beyond repair */
 #define DISABLE_ENQCMD		(1 << (X86_FEATURE_ENQCMD & 31))
 
@@ -79,7 +98,7 @@
 #define DISABLED_MASK8	0
 #define DISABLED_MASK9	(DISABLE_SMAP|DISABLE_SGX)
 #define DISABLED_MASK10	0
-#define DISABLED_MASK11	0
+#define DISABLED_MASK11	(DISABLE_RETPOLINE|DISABLE_RETHUNK|DISABLE_UNRET)
 #define DISABLED_MASK12	0
 #define DISABLED_MASK13	0
 #define DISABLED_MASK14	0
diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index 7dc5a3306f37..ec2967e7249f 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -51,6 +51,8 @@
 #define SPEC_CTRL_STIBP			BIT(SPEC_CTRL_STIBP_SHIFT)	/* STIBP mask */
 #define SPEC_CTRL_SSBD_SHIFT		2	   /* Speculative Store Bypass Disable bit */
 #define SPEC_CTRL_SSBD			BIT(SPEC_CTRL_SSBD_SHIFT)	/* Speculative Store Bypass Disable */
+#define SPEC_CTRL_RRSBA_DIS_S_SHIFT	6	   /* Disable RRSBA behavior */
+#define SPEC_CTRL_RRSBA_DIS_S		BIT(SPEC_CTRL_RRSBA_DIS_S_SHIFT)
 
 #define MSR_IA32_PRED_CMD		0x00000049 /* Prediction Command */
 #define PRED_CMD_IBPB			BIT(0)	   /* Indirect Branch Prediction Barrier */
@@ -91,6 +93,7 @@
 #define MSR_IA32_ARCH_CAPABILITIES	0x0000010a
 #define ARCH_CAP_RDCL_NO		BIT(0)	/* Not susceptible to Meltdown */
 #define ARCH_CAP_IBRS_ALL		BIT(1)	/* Enhanced IBRS support */
+#define ARCH_CAP_RSBA			BIT(2)	/* RET may use alternative branch predictors */
 #define ARCH_CAP_SKIP_VMENTRY_L1DFLUSH	BIT(3)	/* Skip L1D flush on vmentry */
 #define ARCH_CAP_SSB_NO			BIT(4)	/*
 						 * Not susceptible to Speculative Store Bypass
@@ -138,6 +141,13 @@
 						 * bit available to control VERW
 						 * behavior.
 						 */
+#define ARCH_CAP_RRSBA			BIT(19)	/*
+						 * Indicates RET may use predictors
+						 * other than the RSB. With eIBRS
+						 * enabled predictions in kernel mode
+						 * are restricted to targets in
+						 * kernel.
+						 */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
@@ -514,6 +524,9 @@
 /* Fam 17h MSRs */
 #define MSR_F17H_IRPERF			0xc00000e9
 
+#define MSR_ZEN2_SPECTRAL_CHICKEN	0xc00110e3
+#define MSR_ZEN2_SPECTRAL_CHICKEN_BIT	BIT_ULL(1)
+
 /* Fam 16h MSRs */
 #define MSR_F16H_L2I_PERF_CTL		0xc0010230
 #define MSR_F16H_L2I_PERF_CTR		0xc0010231
diff --git a/tools/include/linux/objtool.h b/tools/include/linux/objtool.h
index 7e72d975cb76..a2042c418686 100644
--- a/tools/include/linux/objtool.h
+++ b/tools/include/linux/objtool.h
@@ -32,11 +32,16 @@ struct unwind_hint {
  *
  * UNWIND_HINT_FUNC: Generate the unwind metadata of a callable function.
  * Useful for code which doesn't have an ELF function annotation.
+ *
+ * UNWIND_HINT_ENTRY: machine entry without stack, SYSCALL/SYSENTER etc.
  */
 #define UNWIND_HINT_TYPE_CALL		0
 #define UNWIND_HINT_TYPE_REGS		1
 #define UNWIND_HINT_TYPE_REGS_PARTIAL	2
 #define UNWIND_HINT_TYPE_FUNC		3
+#define UNWIND_HINT_TYPE_ENTRY		4
+#define UNWIND_HINT_TYPE_SAVE		5
+#define UNWIND_HINT_TYPE_RESTORE	6
 
 #ifdef CONFIG_STACK_VALIDATION
 
@@ -99,7 +104,7 @@ struct unwind_hint {
  * the debuginfo as necessary.  It will also warn if it sees any
  * inconsistencies.
  */
-.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 end=0
 .Lunwind_hint_ip_\@:
 	.pushsection .discard.unwind_hints
 		/* struct unwind_hint */
@@ -129,7 +134,7 @@ struct unwind_hint {
 #define STACK_FRAME_NON_STANDARD(func)
 #else
 #define ANNOTATE_INTRA_FUNCTION_CALL
-.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 end=0
 .endm
 .macro STACK_FRAME_NON_STANDARD func:req
 .endm
diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 63ffbc36dacc..f62db0e006e9 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -684,154 +684,32 @@ const char *arch_ret_insn(int len)
 	return ret[len-1];
 }
 
-/* asm/alternative.h ? */
-
-#define ALTINSTR_FLAG_INV	(1 << 15)
-#define ALT_NOT(feat)		((feat) | ALTINSTR_FLAG_INV)
-
-struct alt_instr {
-	s32 instr_offset;	/* original instruction */
-	s32 repl_offset;	/* offset to replacement instruction */
-	u16 cpuid;		/* cpuid bit set for replacement */
-	u8  instrlen;		/* length of original instruction */
-	u8  replacementlen;	/* length of new instruction */
-} __packed;
-
-static int elf_add_alternative(struct elf *elf,
-			       struct instruction *orig, struct symbol *sym,
-			       int cpuid, u8 orig_len, u8 repl_len)
+int arch_decode_hint_reg(u8 sp_reg, int *base)
 {
-	const int size = sizeof(struct alt_instr);
-	struct alt_instr *alt;
-	struct section *sec;
-	Elf_Scn *s;
-
-	sec = find_section_by_name(elf, ".altinstructions");
-	if (!sec) {
-		sec = elf_create_section(elf, ".altinstructions",
-					 SHF_ALLOC, 0, 0);
-
-		if (!sec) {
-			WARN_ELF("elf_create_section");
-			return -1;
-		}
-	}
-
-	s = elf_getscn(elf->elf, sec->idx);
-	if (!s) {
-		WARN_ELF("elf_getscn");
-		return -1;
-	}
-
-	sec->data = elf_newdata(s);
-	if (!sec->data) {
-		WARN_ELF("elf_newdata");
-		return -1;
-	}
-
-	sec->data->d_size = size;
-	sec->data->d_align = 1;
-
-	alt = sec->data->d_buf = malloc(size);
-	if (!sec->data->d_buf) {
-		perror("malloc");
-		return -1;
-	}
-	memset(sec->data->d_buf, 0, size);
-
-	if (elf_add_reloc_to_insn(elf, sec, sec->sh.sh_size,
-				  R_X86_64_PC32, orig->sec, orig->offset)) {
-		WARN("elf_create_reloc: alt_instr::instr_offset");
-		return -1;
-	}
-
-	if (elf_add_reloc(elf, sec, sec->sh.sh_size + 4,
-			  R_X86_64_PC32, sym, 0)) {
-		WARN("elf_create_reloc: alt_instr::repl_offset");
-		return -1;
-	}
-
-	alt->cpuid = bswap_if_needed(cpuid);
-	alt->instrlen = orig_len;
-	alt->replacementlen = repl_len;
-
-	sec->sh.sh_size += size;
-	sec->changed = true;
-
-	return 0;
-}
-
-#define X86_FEATURE_RETPOLINE                ( 7*32+12)
-
-int arch_rewrite_retpolines(struct objtool_file *file)
-{
-	struct instruction *insn;
-	struct reloc *reloc;
-	struct symbol *sym;
-	char name[32] = "";
-
-	list_for_each_entry(insn, &file->retpoline_call_list, call_node) {
-
-		if (insn->type != INSN_JUMP_DYNAMIC &&
-		    insn->type != INSN_CALL_DYNAMIC)
-			continue;
-
-		if (!strcmp(insn->sec->name, ".text.__x86.indirect_thunk"))
-			continue;
-
-		reloc = insn->reloc;
-
-		sprintf(name, "__x86_indirect_alt_%s_%s",
-			insn->type == INSN_JUMP_DYNAMIC ? "jmp" : "call",
-			reloc->sym->name + 21);
-
-		sym = find_symbol_by_name(file->elf, name);
-		if (!sym) {
-			sym = elf_create_undef_symbol(file->elf, name);
-			if (!sym) {
-				WARN("elf_create_undef_symbol");
-				return -1;
-			}
-		}
-
-		if (elf_add_alternative(file->elf, insn, sym,
-					ALT_NOT(X86_FEATURE_RETPOLINE), 5, 5)) {
-			WARN("elf_add_alternative");
-			return -1;
-		}
-	}
-
-	return 0;
-}
-
-int arch_decode_hint_reg(struct instruction *insn, u8 sp_reg)
-{
-	struct cfi_reg *cfa = &insn->cfi.cfa;
-
 	switch (sp_reg) {
 	case ORC_REG_UNDEFINED:
-		cfa->base = CFI_UNDEFINED;
+		*base = CFI_UNDEFINED;
 		break;
 	case ORC_REG_SP:
-		cfa->base = CFI_SP;
+		*base = CFI_SP;
 		break;
 	case ORC_REG_BP:
-		cfa->base = CFI_BP;
+		*base = CFI_BP;
 		break;
 	case ORC_REG_SP_INDIRECT:
-		cfa->base = CFI_SP_INDIRECT;
+		*base = CFI_SP_INDIRECT;
 		break;
 	case ORC_REG_R10:
-		cfa->base = CFI_R10;
+		*base = CFI_R10;
 		break;
 	case ORC_REG_R13:
-		cfa->base = CFI_R13;
+		*base = CFI_R13;
 		break;
 	case ORC_REG_DI:
-		cfa->base = CFI_DI;
+		*base = CFI_DI;
 		break;
 	case ORC_REG_DX:
-		cfa->base = CFI_DX;
+		*base = CFI_DX;
 		break;
 	default:
 		return -1;
@@ -844,3 +722,8 @@ bool arch_is_retpoline(struct symbol *sym)
 {
 	return !strncmp(sym->name, "__x86_indirect_", 15);
 }
+
+bool arch_is_rethunk(struct symbol *sym)
+{
+	return !strcmp(sym->name, "__x86_return_thunk");
+}
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 38070f26105b..35081fe37320 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -20,7 +20,7 @@
 #include <objtool/objtool.h>
 
 bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats,
-     validate_dup, vmlinux, mcount, noinstr, backup, sls;
+     validate_dup, vmlinux, mcount, noinstr, backup, sls, unret, rethunk;
 
 static const char * const check_usage[] = {
 	"objtool check [<options>] file.o",
@@ -36,6 +36,8 @@ const struct option check_options[] = {
 	OPT_BOOLEAN('f', "no-fp", &no_fp, "Skip frame pointer validation"),
 	OPT_BOOLEAN('u', "no-unreachable", &no_unreachable, "Skip 'unreachable instruction' warnings"),
 	OPT_BOOLEAN('r', "retpoline", &retpoline, "Validate retpoline assumptions"),
+	OPT_BOOLEAN(0,   "rethunk", &rethunk, "validate and annotate rethunk usage"),
+	OPT_BOOLEAN(0,   "unret", &unret, "validate entry unret placement"),
 	OPT_BOOLEAN('m', "module", &module, "Indicates the object will be part of a kernel module"),
 	OPT_BOOLEAN('b', "backtrace", &backtrace, "unwind on error"),
 	OPT_BOOLEAN('a', "uaccess", &uaccess, "enable uaccess checking"),
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 8b3435af989a..72e5d23f1ad8 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -6,6 +6,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <inttypes.h>
+#include <sys/mman.h>
 
 #include <arch/elf.h>
 #include <objtool/builtin.h>
@@ -27,7 +28,11 @@ struct alternative {
 	bool skip_orig;
 };
 
-struct cfi_init_state initial_func_cfi;
+static unsigned long nr_cfi, nr_cfi_reused, nr_cfi_cache;
+
+static struct cfi_init_state initial_func_cfi;
+static struct cfi_state init_cfi;
+static struct cfi_state func_cfi;
 
 struct instruction *find_insn(struct objtool_file *file,
 			      struct section *sec, unsigned long offset)
@@ -267,6 +272,78 @@ static void init_insn_state(struct insn_state *state, struct section *sec)
 		state->noinstr = sec->noinstr;
 }
 
+static struct cfi_state *cfi_alloc(void)
+{
+	struct cfi_state *cfi = calloc(sizeof(struct cfi_state), 1);
+	if (!cfi) {
+		WARN("calloc failed");
+		exit(1);
+	}
+	nr_cfi++;
+	return cfi;
+}
+
+static int cfi_bits;
+static struct hlist_head *cfi_hash;
+
+static inline bool cficmp(struct cfi_state *cfi1, struct cfi_state *cfi2)
+{
+	return memcmp((void *)cfi1 + sizeof(cfi1->hash),
+		      (void *)cfi2 + sizeof(cfi2->hash),
+		      sizeof(struct cfi_state) - sizeof(struct hlist_node));
+}
+
+static inline u32 cfi_key(struct cfi_state *cfi)
+{
+	return jhash((void *)cfi + sizeof(cfi->hash),
+		     sizeof(*cfi) - sizeof(cfi->hash), 0);
+}
+
+static struct cfi_state *cfi_hash_find_or_add(struct cfi_state *cfi)
+{
+	struct hlist_head *head = &cfi_hash[hash_min(cfi_key(cfi), cfi_bits)];
+	struct cfi_state *obj;
+
+	hlist_for_each_entry(obj, head, hash) {
+		if (!cficmp(cfi, obj)) {
+			nr_cfi_cache++;
+			return obj;
+		}
+	}
+
+	obj = cfi_alloc();
+	*obj = *cfi;
+	hlist_add_head(&obj->hash, head);
+
+	return obj;
+}
+
+static void cfi_hash_add(struct cfi_state *cfi)
+{
+	struct hlist_head *head = &cfi_hash[hash_min(cfi_key(cfi), cfi_bits)];
+
+	hlist_add_head(&cfi->hash, head);
+}
+
+static void *cfi_hash_alloc(unsigned long size)
+{
+	cfi_bits = max(10, ilog2(size));
+	cfi_hash = mmap(NULL, sizeof(struct hlist_head) << cfi_bits,
+			PROT_READ|PROT_WRITE,
+			MAP_PRIVATE|MAP_ANON, -1, 0);
+	if (cfi_hash == (void *)-1L) {
+		WARN("mmap fail cfi_hash");
+		cfi_hash = NULL;
+	}  else if (stats) {
+		printf("cfi_bits: %d\n", cfi_bits);
+	}
+
+	return cfi_hash;
+}
+
+static unsigned long nr_insns;
+static unsigned long nr_insns_visited;
+
 /*
  * Call the arch-specific instruction decoder for all the instructions and add
  * them to the global instruction list.
@@ -277,7 +354,6 @@ static int decode_instructions(struct objtool_file *file)
 	struct symbol *func;
 	unsigned long offset;
 	struct instruction *insn;
-	unsigned long nr_insns = 0;
 	int ret;
 
 	for_each_sec(file, sec) {
@@ -291,7 +367,8 @@ static int decode_instructions(struct objtool_file *file)
 			sec->text = true;
 
 		if (!strcmp(sec->name, ".noinstr.text") ||
-		    !strcmp(sec->name, ".entry.text"))
+		    !strcmp(sec->name, ".entry.text") ||
+		    !strncmp(sec->name, ".text.__x86.", 12))
 			sec->noinstr = true;
 
 		for (offset = 0; offset < sec->sh.sh_size; offset += insn->len) {
@@ -303,7 +380,6 @@ static int decode_instructions(struct objtool_file *file)
 			memset(insn, 0, sizeof(*insn));
 			INIT_LIST_HEAD(&insn->alts);
 			INIT_LIST_HEAD(&insn->stack_ops);
-			init_cfi_state(&insn->cfi);
 
 			insn->sec = sec;
 			insn->offset = offset;
@@ -533,6 +609,98 @@ static int create_static_call_sections(struct objtool_file *file)
 	return 0;
 }
 
+static int create_retpoline_sites_sections(struct objtool_file *file)
+{
+	struct instruction *insn;
+	struct section *sec;
+	int idx;
+
+	sec = find_section_by_name(file->elf, ".retpoline_sites");
+	if (sec) {
+		WARN("file already has .retpoline_sites, skipping");
+		return 0;
+	}
+
+	idx = 0;
+	list_for_each_entry(insn, &file->retpoline_call_list, call_node)
+		idx++;
+
+	if (!idx)
+		return 0;
+
+	sec = elf_create_section(file->elf, ".retpoline_sites", 0,
+				 sizeof(int), idx);
+	if (!sec) {
+		WARN("elf_create_section: .retpoline_sites");
+		return -1;
+	}
+
+	idx = 0;
+	list_for_each_entry(insn, &file->retpoline_call_list, call_node) {
+
+		int *site = (int *)sec->data->d_buf + idx;
+		*site = 0;
+
+		if (elf_add_reloc_to_insn(file->elf, sec,
+					  idx * sizeof(int),
+					  R_X86_64_PC32,
+					  insn->sec, insn->offset)) {
+			WARN("elf_add_reloc_to_insn: .retpoline_sites");
+			return -1;
+		}
+
+		idx++;
+	}
+
+	return 0;
+}
+
+static int create_return_sites_sections(struct objtool_file *file)
+{
+	struct instruction *insn;
+	struct section *sec;
+	int idx;
+
+	sec = find_section_by_name(file->elf, ".return_sites");
+	if (sec) {
+		WARN("file already has .return_sites, skipping");
+		return 0;
+	}
+
+	idx = 0;
+	list_for_each_entry(insn, &file->return_thunk_list, call_node)
+		idx++;
+
+	if (!idx)
+		return 0;
+
+	sec = elf_create_section(file->elf, ".return_sites", 0,
+				 sizeof(int), idx);
+	if (!sec) {
+		WARN("elf_create_section: .return_sites");
+		return -1;
+	}
+
+	idx = 0;
+	list_for_each_entry(insn, &file->return_thunk_list, call_node) {
+
+		int *site = (int *)sec->data->d_buf + idx;
+		*site = 0;
+
+		if (elf_add_reloc_to_insn(file->elf, sec,
+					  idx * sizeof(int),
+					  R_X86_64_PC32,
+					  insn->sec, insn->offset)) {
+			WARN("elf_add_reloc_to_insn: .return_sites");
+			return -1;
+		}
+
+		idx++;
+	}
+
+	return 0;
+}
+
 static int create_mcount_loc_sections(struct objtool_file *file)
 {
 	struct section *sec;
@@ -551,7 +719,7 @@ static int create_mcount_loc_sections(struct objtool_file *file)
 		return 0;
 
 	idx = 0;
-	list_for_each_entry(insn, &file->mcount_loc_list, mcount_loc_node)
+	list_for_each_entry(insn, &file->mcount_loc_list, call_node)
 		idx++;
 
 	sec = elf_create_section(file->elf, "__mcount_loc", 0, sizeof(unsigned long), idx);
@@ -559,7 +727,7 @@ static int create_mcount_loc_sections(struct objtool_file *file)
 		return -1;
 
 	idx = 0;
-	list_for_each_entry(insn, &file->mcount_loc_list, mcount_loc_node) {
+	list_for_each_entry(insn, &file->mcount_loc_list, call_node) {
 
 		loc = (unsigned long *)sec->data->d_buf + idx;
 		memset(loc, 0, sizeof(unsigned long));
@@ -811,6 +979,11 @@ __weak bool arch_is_retpoline(struct symbol *sym)
 	return false;
 }
 
+__weak bool arch_is_rethunk(struct symbol *sym)
+{
+	return false;
+}
+
 #define NEGATIVE_RELOC	((void *)-1L)
 
 static struct reloc *insn_reloc(struct objtool_file *file, struct instruction *insn)
@@ -840,18 +1013,32 @@ static void remove_insn_ops(struct instruction *insn)
 	}
 }
 
-static void add_call_dest(struct objtool_file *file, struct instruction *insn,
-			  struct symbol *dest, bool sibling)
+static void annotate_call_site(struct objtool_file *file,
+			       struct instruction *insn, bool sibling)
 {
 	struct reloc *reloc = insn_reloc(file, insn);
+	struct symbol *sym = insn->call_dest;
 
-	insn->call_dest = dest;
-	if (!dest)
+	if (!sym)
+		sym = reloc->sym;
+
+	/*
+	 * Alternative replacement code is just template code which is
+	 * sometimes copied to the original instruction. For now, don't
+	 * annotate it. (In the future we might consider annotating the
+	 * original instruction if/when it ever makes sense to do so.)
+	 */
+	if (!strcmp(insn->sec->name, ".altinstr_replacement"))
 		return;
 
-	if (insn->call_dest->static_call_tramp) {
-		list_add_tail(&insn->call_node,
-			      &file->static_call_list);
+	if (sym->static_call_tramp) {
+		list_add_tail(&insn->call_node, &file->static_call_list);
+		return;
+	}
+
+	if (sym->retpoline_thunk) {
+		list_add_tail(&insn->call_node, &file->retpoline_call_list);
+		return;
 	}
 
 	/*
@@ -859,8 +1046,7 @@ static void add_call_dest(struct objtool_file *file, struct instruction *insn,
 	 * so they need a little help, NOP out any KCOV calls from noinstr
 	 * text.
 	 */
-	if (insn->sec->noinstr &&
-	    !strncmp(insn->call_dest->name, "__sanitizer_cov_", 16)) {
+	if (insn->sec->noinstr && sym->kcov) {
 		if (reloc) {
 			reloc->type = R_NONE;
 			elf_write_reloc(file->elf, reloc);
@@ -882,9 +1068,11 @@ static void add_call_dest(struct objtool_file *file, struct instruction *insn,
 			 */
 			insn->retpoline_safe = true;
 		}
+
+		return;
 	}
 
-	if (mcount && !strcmp(insn->call_dest->name, "__fentry__")) {
+	if (mcount && sym->fentry) {
 		if (sibling)
 			WARN_FUNC("Tail call to __fentry__ !?!?", insn->sec, insn->offset);
 
@@ -899,9 +1087,17 @@ static void add_call_dest(struct objtool_file *file, struct instruction *insn,
 
 		insn->type = INSN_NOP;
 
-		list_add_tail(&insn->mcount_loc_node,
-			      &file->mcount_loc_list);
+		list_add_tail(&insn->call_node, &file->mcount_loc_list);
+		return;
 	}
+}
+
+static void add_call_dest(struct objtool_file *file, struct instruction *insn,
+			  struct symbol *dest, bool sibling)
+{
+	insn->call_dest = dest;
+	if (!dest)
+		return;
 
 	/*
 	 * Whatever stack impact regular CALLs have, should be undone
@@ -911,6 +1107,56 @@ static void add_call_dest(struct objtool_file *file, struct instruction *insn,
 	 * are converted to JUMP, see read_intra_function_calls().
 	 */
 	remove_insn_ops(insn);
+
+	annotate_call_site(file, insn, sibling);
+}
+
+static void add_retpoline_call(struct objtool_file *file, struct instruction *insn)
+{
+	/*
+	 * Retpoline calls/jumps are really dynamic calls/jumps in disguise,
+	 * so convert them accordingly.
+	 */
+	switch (insn->type) {
+	case INSN_CALL:
+		insn->type = INSN_CALL_DYNAMIC;
+		break;
+	case INSN_JUMP_UNCONDITIONAL:
+		insn->type = INSN_JUMP_DYNAMIC;
+		break;
+	case INSN_JUMP_CONDITIONAL:
+		insn->type = INSN_JUMP_DYNAMIC_CONDITIONAL;
+		break;
+	default:
+		return;
+	}
+
+	insn->retpoline_safe = true;
+
+	/*
+	 * Whatever stack impact regular CALLs have, should be undone
+	 * by the RETURN of the called function.
+	 *
+	 * Annotated intra-function calls retain the stack_ops but
+	 * are converted to JUMP, see read_intra_function_calls().
+	 */
+	remove_insn_ops(insn);
+
+	annotate_call_site(file, insn, false);
+}
+
+static void add_return_call(struct objtool_file *file, struct instruction *insn, bool add)
+{
+	/*
+	 * Return thunk tail calls are really just returns in disguise,
+	 * so convert them accordingly.
+	 */
+	insn->type = INSN_RETURN;
+	insn->retpoline_safe = true;
+
+	/* Skip the non-text sections, specially .discard ones */
+	if (add && insn->sec->text)
+		list_add_tail(&insn->call_node, &file->return_thunk_list);
 }
 
 /*
@@ -934,20 +1180,11 @@ static int add_jump_destinations(struct objtool_file *file)
 		} else if (reloc->sym->type == STT_SECTION) {
 			dest_sec = reloc->sym->sec;
 			dest_off = arch_dest_reloc_offset(reloc->addend);
-		} else if (arch_is_retpoline(reloc->sym)) {
-			/*
-			 * Retpoline jumps are really dynamic jumps in
-			 * disguise, so convert them accordingly.
-			 */
-			if (insn->type == INSN_JUMP_UNCONDITIONAL)
-				insn->type = INSN_JUMP_DYNAMIC;
-			else
-				insn->type = INSN_JUMP_DYNAMIC_CONDITIONAL;
-
-			list_add_tail(&insn->call_node,
-				      &file->retpoline_call_list);
-
-			insn->retpoline_safe = true;
+		} else if (reloc->sym->retpoline_thunk) {
+			add_retpoline_call(file, insn);
+			continue;
+		} else if (reloc->sym->return_thunk) {
+			add_return_call(file, insn, true);
 			continue;
 		} else if (insn->func) {
 			/* internal or external sibling call (with reloc) */
@@ -964,6 +1201,7 @@ static int add_jump_destinations(struct objtool_file *file)
 
 		insn->jump_dest = find_insn(file, dest_sec, dest_off);
 		if (!insn->jump_dest) {
+			struct symbol *sym = find_symbol_by_offset(dest_sec, dest_off);
 
 			/*
 			 * This is a special case where an alt instruction
@@ -973,6 +1211,19 @@ static int add_jump_destinations(struct objtool_file *file)
 			if (!strcmp(insn->sec->name, ".altinstr_replacement"))
 				continue;
 
+			/*
+			 * This is a special case for zen_untrain_ret().
+			 * It jumps to __x86_return_thunk(), but objtool
+			 * can't find the thunk's starting RET
+			 * instruction, because the RET is also in the
+			 * middle of another instruction.  Objtool only
+			 * knows about the outer instruction.
+			 */
+			if (sym && sym->return_thunk) {
+				add_return_call(file, insn, false);
+				continue;
+			}
+
 			WARN_FUNC("can't find jump dest instruction at %s+0x%lx",
 				  insn->sec, insn->offset, dest_sec->name,
 				  dest_off);
@@ -1075,19 +1326,8 @@ static int add_call_destinations(struct objtool_file *file)
 
 			add_call_dest(file, insn, dest, false);
 
-		} else if (arch_is_retpoline(reloc->sym)) {
-			/*
-			 * Retpoline calls are really dynamic calls in
-			 * disguise, so convert them accordingly.
-			 */
-			insn->type = INSN_CALL_DYNAMIC;
-			insn->retpoline_safe = true;
-
-			list_add_tail(&insn->call_node,
-				      &file->retpoline_call_list);
-
-			remove_insn_ops(insn);
-			continue;
+		} else if (reloc->sym->retpoline_thunk) {
+			add_retpoline_call(file, insn);
 
 		} else
 			add_call_dest(file, insn, reloc->sym, false);
@@ -1158,7 +1398,6 @@ static int handle_group_alt(struct objtool_file *file,
 		memset(nop, 0, sizeof(*nop));
 		INIT_LIST_HEAD(&nop->alts);
 		INIT_LIST_HEAD(&nop->stack_ops);
-		init_cfi_state(&nop->cfi);
 
 		nop->sec = special_alt->new_sec;
 		nop->offset = special_alt->new_off + special_alt->new_len;
@@ -1567,10 +1806,11 @@ static void set_func_state(struct cfi_state *state)
 
 static int read_unwind_hints(struct objtool_file *file)
 {
+	struct cfi_state cfi = init_cfi;
 	struct section *sec, *relocsec;
-	struct reloc *reloc;
 	struct unwind_hint *hint;
 	struct instruction *insn;
+	struct reloc *reloc;
 	int i;
 
 	sec = find_section_by_name(file->elf, ".discard.unwind_hints");
@@ -1607,20 +1847,49 @@ static int read_unwind_hints(struct objtool_file *file)
 
 		insn->hint = true;
 
+		if (hint->type == UNWIND_HINT_TYPE_SAVE) {
+			insn->hint = false;
+			insn->save = true;
+			continue;
+		}
+
+		if (hint->type == UNWIND_HINT_TYPE_RESTORE) {
+			insn->restore = true;
+			continue;
+		}
+
+		if (hint->type == UNWIND_HINT_TYPE_REGS_PARTIAL) {
+			struct symbol *sym = find_symbol_by_offset(insn->sec, insn->offset);
+
+			if (sym && sym->bind == STB_GLOBAL) {
+				insn->entry = 1;
+			}
+		}
+
+		if (hint->type == UNWIND_HINT_TYPE_ENTRY) {
+			hint->type = UNWIND_HINT_TYPE_CALL;
+			insn->entry = 1;
+		}
+
 		if (hint->type == UNWIND_HINT_TYPE_FUNC) {
-			set_func_state(&insn->cfi);
+			insn->cfi = &func_cfi;
 			continue;
 		}
 
-		if (arch_decode_hint_reg(insn, hint->sp_reg)) {
+		if (insn->cfi)
+			cfi = *(insn->cfi);
+
+		if (arch_decode_hint_reg(hint->sp_reg, &cfi.cfa.base)) {
 			WARN_FUNC("unsupported unwind_hint sp base reg %d",
 				  insn->sec, insn->offset, hint->sp_reg);
 			return -1;
 		}
 
-		insn->cfi.cfa.offset = bswap_if_needed(hint->sp_offset);
-		insn->cfi.type = hint->type;
-		insn->cfi.end = hint->end;
+		cfi.cfa.offset = bswap_if_needed(hint->sp_offset);
+		cfi.type = hint->type;
+		cfi.end = hint->end;
+
+		insn->cfi = cfi_hash_find_or_add(&cfi);
 	}
 
 	return 0;
@@ -1649,8 +1918,10 @@ static int read_retpoline_hints(struct objtool_file *file)
 		}
 
 		if (insn->type != INSN_JUMP_DYNAMIC &&
-		    insn->type != INSN_CALL_DYNAMIC) {
-			WARN_FUNC("retpoline_safe hint not an indirect jump/call",
+		    insn->type != INSN_CALL_DYNAMIC &&
+		    insn->type != INSN_RETURN &&
+		    insn->type != INSN_NOP) {
+			WARN_FUNC("retpoline_safe hint not an indirect jump/call/ret/nop",
 				  insn->sec, insn->offset);
 			return -1;
 		}
@@ -1759,17 +2030,31 @@ static int read_intra_function_calls(struct objtool_file *file)
 	return 0;
 }
 
-static int read_static_call_tramps(struct objtool_file *file)
+static int classify_symbols(struct objtool_file *file)
 {
 	struct section *sec;
 	struct symbol *func;
 
 	for_each_sec(file, sec) {
 		list_for_each_entry(func, &sec->symbol_list, list) {
-			if (func->bind == STB_GLOBAL &&
-			    !strncmp(func->name, STATIC_CALL_TRAMP_PREFIX_STR,
+			if (func->bind != STB_GLOBAL)
+				continue;
+
+			if (!strncmp(func->name, STATIC_CALL_TRAMP_PREFIX_STR,
 				     strlen(STATIC_CALL_TRAMP_PREFIX_STR)))
 				func->static_call_tramp = true;
+
+			if (arch_is_retpoline(func))
+				func->retpoline_thunk = true;
+
+			if (arch_is_rethunk(func))
+				func->return_thunk = true;
+
+			if (!strcmp(func->name, "__fentry__"))
+				func->fentry = true;
+
+			if (!strncmp(func->name, "__sanitizer_cov_", 16))
+				func->kcov = true;
 		}
 	}
 
@@ -1802,11 +2087,6 @@ static void mark_rodata(struct objtool_file *file)
 	file->rodata = found;
 }
 
-__weak int arch_rewrite_retpolines(struct objtool_file *file)
-{
-	return 0;
-}
-
 static int decode_sections(struct objtool_file *file)
 {
 	int ret;
@@ -1831,7 +2111,7 @@ static int decode_sections(struct objtool_file *file)
 	/*
 	 * Must be before add_{jump_call}_destination.
 	 */
-	ret = read_static_call_tramps(file);
+	ret = classify_symbols(file);
 	if (ret)
 		return ret;
 
@@ -1875,23 +2155,14 @@ static int decode_sections(struct objtool_file *file)
 	if (ret)
 		return ret;
 
-	/*
-	 * Must be after add_special_section_alts(), since this will emit
-	 * alternatives. Must be after add_{jump,call}_destination(), since
-	 * those create the call insn lists.
-	 */
-	ret = arch_rewrite_retpolines(file);
-	if (ret)
-		return ret;
-
 	return 0;
 }
 
 static bool is_fentry_call(struct instruction *insn)
 {
-	if (insn->type == INSN_CALL && insn->call_dest &&
-	    insn->call_dest->type == STT_NOTYPE &&
-	    !strcmp(insn->call_dest->name, "__fentry__"))
+	if (insn->type == INSN_CALL &&
+	    insn->call_dest &&
+	    insn->call_dest->fentry)
 		return true;
 
 	return false;
@@ -2474,13 +2745,18 @@ static int propagate_alt_cfi(struct objtool_file *file, struct instruction *insn
 	if (!insn->alt_group)
 		return 0;
 
+	if (!insn->cfi) {
+		WARN("CFI missing");
+		return -1;
+	}
+
 	alt_cfi = insn->alt_group->cfi;
 	group_off = insn->offset - insn->alt_group->first_insn->offset;
 
 	if (!alt_cfi[group_off]) {
-		alt_cfi[group_off] = &insn->cfi;
+		alt_cfi[group_off] = insn->cfi;
 	} else {
-		if (memcmp(alt_cfi[group_off], &insn->cfi, sizeof(struct cfi_state))) {
+		if (cficmp(alt_cfi[group_off], insn->cfi)) {
 			WARN_FUNC("stack layout conflict in alternatives",
 				  insn->sec, insn->offset);
 			return -1;
@@ -2531,9 +2807,14 @@ static int handle_insn_ops(struct instruction *insn,
 
 static bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2)
 {
-	struct cfi_state *cfi1 = &insn->cfi;
+	struct cfi_state *cfi1 = insn->cfi;
 	int i;
 
+	if (!cfi1) {
+		WARN("CFI missing");
+		return false;
+	}
+
 	if (memcmp(&cfi1->cfa, &cfi2->cfa, sizeof(cfi1->cfa))) {
 
 		WARN_FUNC("stack state mismatch: cfa1=%d%+d cfa2=%d%+d",
@@ -2718,7 +2999,7 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 			   struct instruction *insn, struct insn_state state)
 {
 	struct alternative *alt;
-	struct instruction *next_insn;
+	struct instruction *next_insn, *prev_insn = NULL;
 	struct section *sec;
 	u8 visited;
 	int ret;
@@ -2740,22 +3021,61 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 			return 1;
 		}
 
-		visited = 1 << state.uaccess;
-		if (insn->visited) {
+		visited = VISITED_BRANCH << state.uaccess;
+		if (insn->visited & VISITED_BRANCH_MASK) {
 			if (!insn->hint && !insn_cfi_match(insn, &state.cfi))
 				return 1;
 
 			if (insn->visited & visited)
 				return 0;
+		} else {
+			nr_insns_visited++;
 		}
 
 		if (state.noinstr)
 			state.instr += insn->instr;
 
-		if (insn->hint)
-			state.cfi = insn->cfi;
-		else
-			insn->cfi = state.cfi;
+		if (insn->hint) {
+			if (insn->restore) {
+				struct instruction *save_insn, *i;
+
+				i = insn;
+				save_insn = NULL;
+
+				sym_for_each_insn_continue_reverse(file, func, i) {
+					if (i->save) {
+						save_insn = i;
+						break;
+					}
+				}
+
+				if (!save_insn) {
+					WARN_FUNC("no corresponding CFI save for CFI restore",
+						  sec, insn->offset);
+					return 1;
+				}
+
+				if (!save_insn->visited) {
+					WARN_FUNC("objtool isn't smart enough to handle this CFI save/restore combo",
+						  sec, insn->offset);
+					return 1;
+				}
+
+				insn->cfi = save_insn->cfi;
+				nr_cfi_reused++;
+			}
+
+			state.cfi = *insn->cfi;
+		} else {
+			/* XXX track if we actually changed state.cfi */
+
+			if (prev_insn && !cficmp(prev_insn->cfi, &state.cfi)) {
+				insn->cfi = prev_insn->cfi;
+				nr_cfi_reused++;
+			} else {
+				insn->cfi = cfi_hash_find_or_add(&state.cfi);
+			}
+		}
 
 		insn->visited |= visited;
 
@@ -2787,9 +3107,8 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 		switch (insn->type) {
 
 		case INSN_RETURN:
-			if (next_insn && next_insn->type == INSN_TRAP) {
-				next_insn->ignore = true;
-			} else if (sls && !insn->retpoline_safe) {
+			if (sls && !insn->retpoline_safe &&
+			    next_insn && next_insn->type != INSN_TRAP) {
 				WARN_FUNC("missing int3 after ret",
 					  insn->sec, insn->offset);
 			}
@@ -2836,9 +3155,8 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 			break;
 
 		case INSN_JUMP_DYNAMIC:
-			if (next_insn && next_insn->type == INSN_TRAP) {
-				next_insn->ignore = true;
-			} else if (sls && !insn->retpoline_safe) {
+			if (sls && !insn->retpoline_safe &&
+			    next_insn && next_insn->type != INSN_TRAP) {
 				WARN_FUNC("missing int3 after indirect jump",
 					  insn->sec, insn->offset);
 			}
@@ -2919,6 +3237,7 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 			return 1;
 		}
 
+		prev_insn = insn;
 		insn = next_insn;
 	}
 
@@ -2958,6 +3277,145 @@ static int validate_unwind_hints(struct objtool_file *file, struct section *sec)
 	return warnings;
 }
 
+/*
+ * Validate rethunk entry constraint: must untrain RET before the first RET.
+ *
+ * Follow every branch (intra-function) and ensure ANNOTATE_UNRET_END comes
+ * before an actual RET instruction.
+ */
+static int validate_entry(struct objtool_file *file, struct instruction *insn)
+{
+	struct instruction *next, *dest;
+	int ret, warnings = 0;
+
+	for (;;) {
+		next = next_insn_to_validate(file, insn);
+
+		if (insn->visited & VISITED_ENTRY)
+			return 0;
+
+		insn->visited |= VISITED_ENTRY;
+
+		if (!insn->ignore_alts && !list_empty(&insn->alts)) {
+			struct alternative *alt;
+			bool skip_orig = false;
+
+			list_for_each_entry(alt, &insn->alts, list) {
+				if (alt->skip_orig)
+					skip_orig = true;
+
+				ret = validate_entry(file, alt->insn);
+				if (ret) {
+				        if (backtrace)
+						BT_FUNC("(alt)", insn);
+					return ret;
+				}
+			}
+
+			if (skip_orig)
+				return 0;
+		}
+
+		switch (insn->type) {
+
+		case INSN_CALL_DYNAMIC:
+		case INSN_JUMP_DYNAMIC:
+		case INSN_JUMP_DYNAMIC_CONDITIONAL:
+			WARN_FUNC("early indirect call", insn->sec, insn->offset);
+			return 1;
+
+		case INSN_JUMP_UNCONDITIONAL:
+		case INSN_JUMP_CONDITIONAL:
+			if (!is_sibling_call(insn)) {
+				if (!insn->jump_dest) {
+					WARN_FUNC("unresolved jump target after linking?!?",
+						  insn->sec, insn->offset);
+					return -1;
+				}
+				ret = validate_entry(file, insn->jump_dest);
+				if (ret) {
+					if (backtrace) {
+						BT_FUNC("(branch%s)", insn,
+							insn->type == INSN_JUMP_CONDITIONAL ? "-cond" : "");
+					}
+					return ret;
+				}
+
+				if (insn->type == INSN_JUMP_UNCONDITIONAL)
+					return 0;
+
+				break;
+			}
+
+			/* fallthrough */
+		case INSN_CALL:
+			dest = find_insn(file, insn->call_dest->sec,
+					 insn->call_dest->offset);
+			if (!dest) {
+				WARN("Unresolved function after linking!?: %s",
+				     insn->call_dest->name);
+				return -1;
+			}
+
+			ret = validate_entry(file, dest);
+			if (ret) {
+				if (backtrace)
+					BT_FUNC("(call)", insn);
+				return ret;
+			}
+			/*
+			 * If a call returns without error, it must have seen UNTRAIN_RET.
+			 * Therefore any non-error return is a success.
+			 */
+			return 0;
+
+		case INSN_RETURN:
+			WARN_FUNC("RET before UNTRAIN", insn->sec, insn->offset);
+			return 1;
+
+		case INSN_NOP:
+			if (insn->retpoline_safe)
+				return 0;
+			break;
+
+		default:
+			break;
+		}
+
+		if (!next) {
+			WARN_FUNC("teh end!", insn->sec, insn->offset);
+			return -1;
+		}
+		insn = next;
+	}
+
+	return warnings;
+}
+
+/*
+ * Validate that all branches starting at 'insn->entry' encounter UNRET_END
+ * before RET.
+ */
+static int validate_unret(struct objtool_file *file)
+{
+	struct instruction *insn;
+	int ret, warnings = 0;
+
+	for_each_insn(file, insn) {
+		if (!insn->entry)
+			continue;
+
+		ret = validate_entry(file, insn);
+		if (ret < 0) {
+			WARN_FUNC("Failed UNRET validation", insn->sec, insn->offset);
+			return ret;
+		}
+		warnings += ret;
+	}
+
+	return warnings;
+}
+
 static int validate_retpoline(struct objtool_file *file)
 {
 	struct instruction *insn;
@@ -2965,7 +3423,8 @@ static int validate_retpoline(struct objtool_file *file)
 
 	for_each_insn(file, insn) {
 		if (insn->type != INSN_JUMP_DYNAMIC &&
-		    insn->type != INSN_CALL_DYNAMIC)
+		    insn->type != INSN_CALL_DYNAMIC &&
+		    insn->type != INSN_RETURN)
 			continue;
 
 		if (insn->retpoline_safe)
@@ -2980,9 +3439,17 @@ static int validate_retpoline(struct objtool_file *file)
 		if (!strcmp(insn->sec->name, ".init.text") && !module)
 			continue;
 
-		WARN_FUNC("indirect %s found in RETPOLINE build",
-			  insn->sec, insn->offset,
-			  insn->type == INSN_JUMP_DYNAMIC ? "jump" : "call");
+		if (insn->type == INSN_RETURN) {
+			if (rethunk) {
+				WARN_FUNC("'naked' return found in RETHUNK build",
+					  insn->sec, insn->offset);
+			} else
+				continue;
+		} else {
+			WARN_FUNC("indirect %s found in RETPOLINE build",
+				  insn->sec, insn->offset,
+				  insn->type == INSN_JUMP_DYNAMIC ? "jump" : "call");
+		}
 
 		warnings++;
 	}
@@ -3008,7 +3475,7 @@ static bool ignore_unreachable_insn(struct objtool_file *file, struct instructio
 	int i;
 	struct instruction *prev_insn;
 
-	if (insn->ignore || insn->type == INSN_NOP)
+	if (insn->ignore || insn->type == INSN_NOP || insn->type == INSN_TRAP)
 		return true;
 
 	/*
@@ -3174,10 +3641,20 @@ int check(struct objtool_file *file)
 	int ret, warnings = 0;
 
 	arch_initial_func_cfi_state(&initial_func_cfi);
+	init_cfi_state(&init_cfi);
+	init_cfi_state(&func_cfi);
+	set_func_state(&func_cfi);
+
+	if (!cfi_hash_alloc(1UL << (file->elf->symbol_bits - 3)))
+		goto out;
+
+	cfi_hash_add(&init_cfi);
+	cfi_hash_add(&func_cfi);
 
 	ret = decode_sections(file);
 	if (ret < 0)
 		goto out;
+
 	warnings += ret;
 
 	if (list_empty(&file->insn_list))
@@ -3209,6 +3686,17 @@ int check(struct objtool_file *file)
 		goto out;
 	warnings += ret;
 
+	if (unret) {
+		/*
+		 * Must be after validate_branch() and friends, it plays
+		 * further games with insn->visited.
+		 */
+		ret = validate_unret(file);
+		if (ret < 0)
+			return ret;
+		warnings += ret;
+	}
+
 	if (!warnings) {
 		ret = validate_reachable_instructions(file);
 		if (ret < 0)
@@ -3221,6 +3709,20 @@ int check(struct objtool_file *file)
 		goto out;
 	warnings += ret;
 
+	if (retpoline) {
+		ret = create_retpoline_sites_sections(file);
+		if (ret < 0)
+			goto out;
+		warnings += ret;
+	}
+
+	if (rethunk) {
+		ret = create_return_sites_sections(file);
+		if (ret < 0)
+			goto out;
+		warnings += ret;
+	}
+
 	if (mcount) {
 		ret = create_mcount_loc_sections(file);
 		if (ret < 0)
@@ -3228,6 +3730,13 @@ int check(struct objtool_file *file)
 		warnings += ret;
 	}
 
+	if (stats) {
+		printf("nr_insns_visited: %ld\n", nr_insns_visited);
+		printf("nr_cfi: %ld\n", nr_cfi);
+		printf("nr_cfi_reused: %ld\n", nr_cfi_reused);
+		printf("nr_cfi_cache: %ld\n", nr_cfi_cache);
+	}
+
 out:
 	/*
 	 *  For now, don't fail the kernel build on fatal warnings.  These
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 2554f48c4ede..bc3005ef5af8 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -944,90 +944,6 @@ static int elf_add_string(struct elf *elf, struct section *strtab, char *str)
 	return len;
 }
 
-struct symbol *elf_create_undef_symbol(struct elf *elf, const char *name)
-{
-	struct section *symtab, *symtab_shndx;
-	struct symbol *sym;
-	Elf_Data *data;
-	Elf_Scn *s;
-
-	sym = malloc(sizeof(*sym));
-	if (!sym) {
-		perror("malloc");
-		return NULL;
-	}
-	memset(sym, 0, sizeof(*sym));
-
-	sym->name = strdup(name);
-
-	sym->sym.st_name = elf_add_string(elf, NULL, sym->name);
-	if (sym->sym.st_name == -1)
-		return NULL;
-
-	sym->sym.st_info = GELF_ST_INFO(STB_GLOBAL, STT_NOTYPE);
-	// st_other 0
-	// st_shndx 0
-	// st_value 0
-	// st_size 0
-
-	symtab = find_section_by_name(elf, ".symtab");
-	if (!symtab) {
-		WARN("can't find .symtab");
-		return NULL;
-	}
-
-	s = elf_getscn(elf->elf, symtab->idx);
-	if (!s) {
-		WARN_ELF("elf_getscn");
-		return NULL;
-	}
-
-	data = elf_newdata(s);
-	if (!data) {
-		WARN_ELF("elf_newdata");
-		return NULL;
-	}
-
-	data->d_buf = &sym->sym;
-	data->d_size = sizeof(sym->sym);
-	data->d_align = 1;
-	data->d_type = ELF_T_SYM;
-
-	sym->idx = symtab->sh.sh_size / sizeof(sym->sym);
-
-	symtab->sh.sh_size += data->d_size;
-	symtab->changed = true;
-
-	symtab_shndx = find_section_by_name(elf, ".symtab_shndx");
-	if (symtab_shndx) {
-		s = elf_getscn(elf->elf, symtab_shndx->idx);
-		if (!s) {
-			WARN_ELF("elf_getscn");
-			return NULL;
-		}
-
-		data = elf_newdata(s);
-		if (!data) {
-			WARN_ELF("elf_newdata");
-			return NULL;
-		}
-
-		data->d_buf = &sym->sym.st_size; /* conveniently 0 */
-		data->d_size = sizeof(Elf32_Word);
-		data->d_align = 4;
-		data->d_type = ELF_T_WORD;
-
-		symtab_shndx->sh.sh_size += 4;
-		symtab_shndx->changed = true;
-	}
-
-	sym->sec = find_section_by_index(elf, 0);
-
-	elf_add_symbol(elf, sym);
-
-	return sym;
-}
-
 struct section *elf_create_section(struct elf *elf, const char *name,
 				   unsigned int sh_flags, size_t entsize, int nr)
 {
diff --git a/tools/objtool/include/objtool/arch.h b/tools/objtool/include/objtool/arch.h
index 9ca08d95e78e..8d57e3d1f763 100644
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -85,9 +85,10 @@ unsigned long arch_dest_reloc_offset(int addend);
 const char *arch_nop_insn(int len);
 const char *arch_ret_insn(int len);
 
-int arch_decode_hint_reg(struct instruction *insn, u8 sp_reg);
+int arch_decode_hint_reg(u8 sp_reg, int *base);
 
 bool arch_is_retpoline(struct symbol *sym);
+bool arch_is_rethunk(struct symbol *sym);
 
 int arch_rewrite_retpolines(struct objtool_file *file);
 
diff --git a/tools/objtool/include/objtool/builtin.h b/tools/objtool/include/objtool/builtin.h
index 89ba869ed08f..66ad30ec5818 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -9,7 +9,7 @@
 
 extern const struct option check_options[];
 extern bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats,
-            validate_dup, vmlinux, mcount, noinstr, backup, sls;
+            validate_dup, vmlinux, mcount, noinstr, backup, sls, unret, rethunk;
 
 extern int cmd_parse_options(int argc, const char **argv, const char * const usage[]);
 
diff --git a/tools/objtool/include/objtool/cfi.h b/tools/objtool/include/objtool/cfi.h
index fd5cb0bed9bf..f11d1ac1dadf 100644
--- a/tools/objtool/include/objtool/cfi.h
+++ b/tools/objtool/include/objtool/cfi.h
@@ -7,6 +7,7 @@
 #define _OBJTOOL_CFI_H
 
 #include <arch/cfi_regs.h>
+#include <linux/list.h>
 
 #define CFI_UNDEFINED		-1
 #define CFI_CFA			-2
@@ -24,6 +25,7 @@ struct cfi_init_state {
 };
 
 struct cfi_state {
+	struct hlist_node hash; /* must be first, cficmp() */
 	struct cfi_reg regs[CFI_NUM_REGS];
 	struct cfi_reg vals[CFI_NUM_REGS];
 	struct cfi_reg cfa;
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index 56d50bc50c10..4ba041db304f 100644
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -40,7 +40,6 @@ struct instruction {
 	struct list_head list;
 	struct hlist_node hash;
 	struct list_head call_node;
-	struct list_head mcount_loc_node;
 	struct section *sec;
 	unsigned long offset;
 	unsigned int len;
@@ -48,7 +47,9 @@ struct instruction {
 	unsigned long immediate;
 	bool dead_end, ignore, ignore_alts;
 	bool hint;
+	bool save, restore;
 	bool retpoline_safe;
+	bool entry;
 	s8 instr;
 	u8 visited;
 	struct alt_group *alt_group;
@@ -60,9 +61,14 @@ struct instruction {
 	struct list_head alts;
 	struct symbol *func;
 	struct list_head stack_ops;
-	struct cfi_state cfi;
+	struct cfi_state *cfi;
 };
 
+#define VISITED_BRANCH		0x01
+#define VISITED_BRANCH_UACCESS	0x02
+#define VISITED_BRANCH_MASK	0x03
+#define VISITED_ENTRY		0x04
+
 static inline bool is_static_jump(struct instruction *insn)
 {
 	return insn->type == INSN_JUMP_CONDITIONAL ||
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 444365285618..6cdfa401b000 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -54,8 +54,12 @@ struct symbol {
 	unsigned long offset;
 	unsigned int len;
 	struct symbol *pfunc, *cfunc, *alias;
-	bool uaccess_safe;
-	bool static_call_tramp;
+	u8 uaccess_safe      : 1;
+	u8 static_call_tramp : 1;
+	u8 retpoline_thunk   : 1;
+	u8 return_thunk      : 1;
+	u8 fentry            : 1;
+	u8 kcov              : 1;
 };
 
 struct reloc {
@@ -140,7 +144,6 @@ int elf_write_insn(struct elf *elf, struct section *sec,
 		   unsigned long offset, unsigned int len,
 		   const char *insn);
 int elf_write_reloc(struct elf *elf, struct reloc *reloc);
-struct symbol *elf_create_undef_symbol(struct elf *elf, const char *name);
 int elf_write(struct elf *elf);
 void elf_close(struct elf *elf);
 
diff --git a/tools/objtool/include/objtool/objtool.h b/tools/objtool/include/objtool/objtool.h
index 24fa83634de4..97b25a217c3a 100644
--- a/tools/objtool/include/objtool/objtool.h
+++ b/tools/objtool/include/objtool/objtool.h
@@ -19,6 +19,7 @@ struct objtool_file {
 	struct list_head insn_list;
 	DECLARE_HASHTABLE(insn_hash, 20);
 	struct list_head retpoline_call_list;
+	struct list_head return_thunk_list;
 	struct list_head static_call_list;
 	struct list_head mcount_loc_list;
 	bool ignore_unreachables, c_file, hints, rodata;
diff --git a/tools/objtool/objtool.c b/tools/objtool/objtool.c
index e21db8bce493..24650d533d85 100644
--- a/tools/objtool/objtool.c
+++ b/tools/objtool/objtool.c
@@ -126,6 +126,7 @@ struct objtool_file *objtool_open_read(const char *_objname)
 	INIT_LIST_HEAD(&file.insn_list);
 	hash_init(file.insn_hash);
 	INIT_LIST_HEAD(&file.retpoline_call_list);
+	INIT_LIST_HEAD(&file.return_thunk_list);
 	INIT_LIST_HEAD(&file.static_call_list);
 	INIT_LIST_HEAD(&file.mcount_loc_list);
 	file.c_file = !vmlinux && find_section_by_name(file.elf, ".comment");
diff --git a/tools/objtool/orc_gen.c b/tools/objtool/orc_gen.c
index b5865e2450cb..dd3c64af9db2 100644
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -13,13 +13,19 @@
 #include <objtool/warn.h>
 #include <objtool/endianness.h>
 
-static int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi)
+static int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi,
+			  struct instruction *insn)
 {
-	struct instruction *insn = container_of(cfi, struct instruction, cfi);
 	struct cfi_reg *bp = &cfi->regs[CFI_BP];
 
 	memset(orc, 0, sizeof(*orc));
 
+	if (!cfi) {
+		orc->end = 0;
+		orc->sp_reg = ORC_REG_UNDEFINED;
+		return 0;
+	}
+
 	orc->end = cfi->end;
 
 	if (cfi->cfa.base == CFI_UNDEFINED) {
@@ -162,7 +168,7 @@ int orc_create(struct objtool_file *file)
 			int i;
 
 			if (!alt_group) {
-				if (init_orc_entry(&orc, &insn->cfi))
+				if (init_orc_entry(&orc, insn->cfi, insn))
 					return -1;
 				if (!memcmp(&prev_orc, &orc, sizeof(orc)))
 					continue;
@@ -186,7 +192,8 @@ int orc_create(struct objtool_file *file)
 				struct cfi_state *cfi = alt_group->cfi[i];
 				if (!cfi)
 					continue;
-				if (init_orc_entry(&orc, cfi))
+				/* errors are reported on the original insn */
+				if (init_orc_entry(&orc, cfi, insn))
 					return -1;
 				if (!memcmp(&prev_orc, &orc, sizeof(orc)))
 					continue;
diff --git a/tools/objtool/special.c b/tools/objtool/special.c
index 06c3eacab3d5..e2223dd91c37 100644
--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -109,14 +109,6 @@ static int get_alt_entry(struct elf *elf, struct special_entry *entry,
 			return -1;
 		}
 
-		/*
-		 * Skip retpoline .altinstr_replacement... we already rewrite the
-		 * instructions for retpolines anyway, see arch_is_retpoline()
-		 * usage in add_{call,jump}_destinations().
-		 */
-		if (arch_is_retpoline(new_reloc->sym))
-			return 1;
-
 		reloc_to_sec_off(new_reloc, &alt->new_sec, &alt->new_off);
 
 		/* _ASM_EXTABLE_EX hack */
