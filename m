Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE21661517D
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 19:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiKASXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 14:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiKASXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 14:23:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3AF2608;
        Tue,  1 Nov 2022 11:23:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58AE3616E4;
        Tue,  1 Nov 2022 18:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EE9C433D6;
        Tue,  1 Nov 2022 18:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667327010;
        bh=H5xfb0ZGyAvbIEL065giINLKfhI442iViph5xhDmfHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqV9oPF+21Bpd+zhfJQ9RnsAaZ3UGzPi7yHx5wFRkHTY4aZryMCrUEjtUAV5TbEMx
         yfr6lr/jBLhXOK5KTZN1kvYjSTt2VOExiH8ndsarQXApEBhvlyM55m0w63992YkQvp
         n6TEIKO5anXytuz6wMHuMGwVgbj5hsuxfsIb55V4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.297
Date:   Tue,  1 Nov 2022 19:24:14 +0100
Message-Id: <16673270545232@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <166732705422181@kroah.com>
References: <166732705422181@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/hw-vuln/spectre.rst b/Documentation/admin-guide/hw-vuln/spectre.rst
index 6bd97cd50d62..7e061ed449aa 100644
--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -422,6 +422,14 @@ The possible values in this file are:
   'RSB filling'   Protection of RSB on context switch enabled
   =============   ===========================================
 
+  - EIBRS Post-barrier Return Stack Buffer (PBRSB) protection status:
+
+  ===========================  =======================================================
+  'PBRSB-eIBRS: SW sequence'   CPU is affected and protection of RSB on VMEXIT enabled
+  'PBRSB-eIBRS: Vulnerable'    CPU is vulnerable
+  'PBRSB-eIBRS: Not affected'  CPU is not affected by PBRSB
+  ===========================  =======================================================
+
 Full mitigation might require a microcode update from the CPU
 vendor. When the necessary microcode is not available, the kernel will
 report vulnerability.
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 681d429c6426..629d7956ddf1 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3965,6 +3965,18 @@
 
 	retain_initrd	[RAM] Keep initrd memory after extraction
 
+	retbleed=	[X86] Control mitigation of RETBleed (Arbitrary
+			Speculative Code Execution with Return Instructions)
+			vulnerability.
+
+			off         - unconditionally disable
+			auto        - automatically select a migitation
+
+			Selecting 'auto' will choose a mitigation method at run
+			time according to the CPU.
+
+			Not specifying this option is equivalent to retbleed=auto.
+
 	rfkill.default_state=
 		0	"airplane mode".  All wifi, bluetooth, wimax, gps, fm,
 			etc. communication is blocked by default.
@@ -4204,6 +4216,7 @@
 			eibrs		  - enhanced IBRS
 			eibrs,retpoline   - enhanced IBRS + Retpolines
 			eibrs,lfence      - enhanced IBRS + LFENCE
+			ibrs		  - use IBRS to protect kernel
 
 			Not specifying this option is equivalent to
 			spectre_v2=auto.
diff --git a/Makefile b/Makefile
index b7978fb873d6..a66c65fcb96f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 296
+SUBLEVEL = 297
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 1dbc62a96b85..ef759951fd0f 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -6,6 +6,8 @@
 #include <asm/percpu.h>
 #include <asm/asm-offsets.h>
 #include <asm/processor-flags.h>
+#include <asm/msr.h>
+#include <asm/nospec-branch.h>
 
 /*
 
@@ -146,27 +148,19 @@ For 32-bit we have the following conventions - kernel is built with
 
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
@@ -336,6 +330,62 @@ For 32-bit we have the following conventions - kernel is built with
 
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
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index c19974a49378..dbcea4281c30 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -245,7 +245,6 @@ ENTRY(__switch_to_asm)
 	movl	%ebx, PER_CPU_VAR(stack_canary)+stack_canary_offset
 #endif
 
-#ifdef CONFIG_RETPOLINE
 	/*
 	 * When switching from a shallower to a deeper call stack
 	 * the RSB may either underflow or use entries populated
@@ -254,7 +253,6 @@ ENTRY(__switch_to_asm)
 	 * speculative execution to prevent attack.
 	 */
 	FILL_RETURN_BUFFER %ebx, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_CTXSW
-#endif
 
 	/* restore callee-saved registers */
 	popfl
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index ac389ffb1822..637a23d404e9 100644
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
@@ -301,8 +305,8 @@ GLOBAL(entry_SYSCALL_64_after_hwframe)
 	 * perf profiles. Nothing jumps here.
 	 */
 syscall_return_via_sysret:
-	/* rcx and r11 are already restored (see code above) */
-	POP_REGS pop_rdi=0 skip_r11rcx=1
+	IBRS_EXIT
+	POP_REGS pop_rdi=0
 
 	/*
 	 * Now all regs are restored except RSP and RDI.
@@ -353,7 +357,6 @@ ENTRY(__switch_to_asm)
 	movq	%rbx, PER_CPU_VAR(irq_stack_union)+stack_canary_offset
 #endif
 
-#ifdef CONFIG_RETPOLINE
 	/*
 	 * When switching from a shallower to a deeper call stack
 	 * the RSB may either underflow or use entries populated
@@ -362,7 +365,6 @@ ENTRY(__switch_to_asm)
 	 * speculative execution to prevent attack.
 	 */
 	FILL_RETURN_BUFFER %r12, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_CTXSW
-#endif
 
 	/* restore callee-saved registers */
 	popfq
@@ -591,6 +593,7 @@ GLOBAL(retint_user)
 	TRACE_IRQS_IRETQ
 
 GLOBAL(swapgs_restore_regs_and_return_to_usermode)
+	IBRS_EXIT
 #ifdef CONFIG_DEBUG_ENTRY
 	/* Assert that pt_regs indicates user mode. */
 	testb	$3, CS(%rsp)
@@ -1134,6 +1137,9 @@ idtentry machine_check		do_mce			has_error_code=0	paranoid=1
  * Save all registers in pt_regs, and switch gs if needed.
  * Use slow, but surefire "are we in kernel?" check.
  * Return: ebx=0: need swapgs on exit, ebx=1: otherwise
+ *
+ * R14 - old CR3
+ * R15 - old SPEC_CTRL
  */
 ENTRY(paranoid_entry)
 	UNWIND_HINT_FUNC
@@ -1157,6 +1163,12 @@ ENTRY(paranoid_entry)
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
 
@@ -1171,9 +1183,19 @@ END(paranoid_entry)
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
@@ -1208,8 +1230,10 @@ ENTRY(error_entry)
 	FENCE_SWAPGS_USER_ENTRY
 	/* We have user CR3.  Change to kernel CR3. */
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
+	IBRS_ENTER
 
 .Lerror_entry_from_usermode_after_swapgs:
+
 	/* Put us onto the real thread stack. */
 	popq	%r12				/* save return addr in %12 */
 	movq	%rsp, %rdi			/* arg0 = pt_regs pointer */
@@ -1272,6 +1296,7 @@ ENTRY(error_entry)
 	SWAPGS
 	FENCE_SWAPGS_USER_ENTRY
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
+	IBRS_ENTER
 
 	/*
 	 * Pretend that the exception came from user mode: set up pt_regs
@@ -1377,6 +1402,8 @@ ENTRY(nmi)
 	PUSH_AND_CLEAR_REGS rdx=(%rdx)
 	ENCODE_FRAME_POINTER
 
+	IBRS_ENTER
+
 	/*
 	 * At this point we no longer need to worry about stack damage
 	 * due to nesting -- we're on the normal thread stack and we're
@@ -1600,6 +1627,9 @@ end_repeat_nmi:
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
diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index 884466592943..e54babe529c7 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -1,13 +1,172 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _CPU_DEVICE_ID
-#define _CPU_DEVICE_ID 1
+#ifndef _ASM_X86_CPU_DEVICE_ID
+#define _ASM_X86_CPU_DEVICE_ID
 
 /*
  * Declare drivers belonging to specific x86 CPUs
  * Similar in spirit to pci_device_id and related PCI functions
+ *
+ * The wildcard initializers are in mod_devicetable.h because
+ * file2alias needs them. Sigh.
  */
-
 #include <linux/mod_devicetable.h>
+/* Get the INTEL_FAM* model defines */
+#include <asm/intel-family.h>
+/* And the X86_VENDOR_* ones */
+#include <asm/processor.h>
+
+/* Centaur FAM6 models */
+#define X86_CENTAUR_FAM6_C7_A		0xa
+#define X86_CENTAUR_FAM6_C7_D		0xd
+#define X86_CENTAUR_FAM6_NANO		0xf
+
+/**
+ * X86_MATCH_VENDOR_FAM_MODEL_FEATURE - Base macro for CPU matching
+ * @_vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@_vendor
+ * @_family:	The family number or X86_FAMILY_ANY
+ * @_model:	The model number, model constant or X86_MODEL_ANY
+ * @_feature:	A X86_FEATURE bit or X86_FEATURE_ANY
+ * @_data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * Use only if you need all selectors. Otherwise use one of the shorter
+ * macros of the X86_MATCH_* family. If there is no matching shorthand
+ * macro, consider to add one. If you really need to wrap one of the macros
+ * into another macro at the usage site for good reasons, then please
+ * start this local macro with X86_MATCH to allow easy grepping.
+ */
+#define X86_MATCH_VENDOR_FAM_MODEL_FEATURE(_vendor, _family, _model,	\
+					   _feature, _data) {		\
+	.vendor		= X86_VENDOR_##_vendor,				\
+	.family		= _family,					\
+	.model		= _model,					\
+	.feature	= _feature,					\
+	.driver_data	= (unsigned long) _data				\
+}
+
+/**
+ * X86_MATCH_VENDOR_FAM_FEATURE - Macro for matching vendor, family and CPU feature
+ * @vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@vendor
+ * @family:	The family number or X86_FAMILY_ANY
+ * @feature:	A X86_FEATURE bit
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * All other missing arguments of X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are
+ * set to wildcards.
+ */
+#define X86_MATCH_VENDOR_FAM_FEATURE(vendor, family, feature, data)	\
+	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(vendor, family,		\
+					   X86_MODEL_ANY, feature, data)
+
+/**
+ * X86_MATCH_VENDOR_FEATURE - Macro for matching vendor and CPU feature
+ * @vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@vendor
+ * @feature:	A X86_FEATURE bit
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * All other missing arguments of X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are
+ * set to wildcards.
+ */
+#define X86_MATCH_VENDOR_FEATURE(vendor, feature, data)			\
+	X86_MATCH_VENDOR_FAM_FEATURE(vendor, X86_FAMILY_ANY, feature, data)
+
+/**
+ * X86_MATCH_FEATURE - Macro for matching a CPU feature
+ * @feature:	A X86_FEATURE bit
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * All other missing arguments of X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are
+ * set to wildcards.
+ */
+#define X86_MATCH_FEATURE(feature, data)				\
+	X86_MATCH_VENDOR_FEATURE(ANY, feature, data)
+
+/* Transitional to keep the existing code working */
+#define X86_FEATURE_MATCH(feature)	X86_MATCH_FEATURE(feature, NULL)
+
+/**
+ * X86_MATCH_VENDOR_FAM_MODEL - Match vendor, family and model
+ * @vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@vendor
+ * @family:	The family number or X86_FAMILY_ANY
+ * @model:	The model number, model constant or X86_MODEL_ANY
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * All other missing arguments of X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are
+ * set to wildcards.
+ */
+#define X86_MATCH_VENDOR_FAM_MODEL(vendor, family, model, data)		\
+	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(vendor, family, model,	\
+					   X86_FEATURE_ANY, data)
+
+/**
+ * X86_MATCH_VENDOR_FAM - Match vendor and family
+ * @vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@vendor
+ * @family:	The family number or X86_FAMILY_ANY
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * All other missing arguments to X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are
+ * set of wildcards.
+ */
+#define X86_MATCH_VENDOR_FAM(vendor, family, data)			\
+	X86_MATCH_VENDOR_FAM_MODEL(vendor, family, X86_MODEL_ANY, data)
+
+/**
+ * X86_MATCH_INTEL_FAM6_MODEL - Match vendor INTEL, family 6 and model
+ * @model:	The model name without the INTEL_FAM6_ prefix or ANY
+ *		The model name is expanded to INTEL_FAM6_@model internally
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * The vendor is set to INTEL, the family to 6 and all other missing
+ * arguments of X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are set to wildcards.
+ *
+ * See X86_MATCH_VENDOR_FAM_MODEL_FEATURE() for further information.
+ */
+#define X86_MATCH_INTEL_FAM6_MODEL(model, data)				\
+	X86_MATCH_VENDOR_FAM_MODEL(INTEL, 6, INTEL_FAM6_##model, data)
+
+/*
+ * Match specific microcode revisions.
+ *
+ * vendor/family/model/stepping must be all set.
+ *
+ * Only checks against the boot CPU.  When mixed-stepping configs are
+ * valid for a CPU model, add a quirk for every valid stepping and
+ * do the fine-tuning in the quirk handler.
+ */
+
+struct x86_cpu_desc {
+	u8	x86_family;
+	u8	x86_vendor;
+	u8	x86_model;
+	u8	x86_stepping;
+	u32	x86_microcode_rev;
+};
+
+#define INTEL_CPU_DESC(model, stepping, revision) {		\
+	.x86_family		= 6,				\
+	.x86_vendor		= X86_VENDOR_INTEL,		\
+	.x86_model		= (model),			\
+	.x86_stepping		= (stepping),			\
+	.x86_microcode_rev	= (revision),			\
+}
 
 #define X86_STEPPINGS(mins, maxs)    GENMASK(maxs, mins)
 
@@ -37,5 +196,6 @@
 }
 
 extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match);
+extern bool x86_cpu_has_min_microcode_rev(const struct x86_cpu_desc *table);
 
-#endif
+#endif /* _ASM_X86_CPU_DEVICE_ID */
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index d56634d6b10c..840d8981567e 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -202,8 +202,8 @@
 #define X86_FEATURE_PROC_FEEDBACK	( 7*32+ 9) /* AMD ProcFeedbackInterface */
 #define X86_FEATURE_SME			( 7*32+10) /* AMD Secure Memory Encryption */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
-#define X86_FEATURE_RETPOLINE		( 7*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
-#define X86_FEATURE_RETPOLINE_LFENCE	( 7*32+13) /* "" Use LFENCE for Spectre variant 2 */
+#define X86_FEATURE_KERNEL_IBRS		( 7*32+12) /* "" Set/clear IBRS on kernel entry/exit */
+#define X86_FEATURE_RSB_VMEXIT		( 7*32+13) /* "" Fill RSB on VM-Exit */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_CDP_L2		( 7*32+15) /* Code and Data Prioritization L2 */
 #define X86_FEATURE_MSR_SPEC_CTRL	( 7*32+16) /* "" MSR SPEC_CTRL is implemented */
@@ -283,6 +283,15 @@
 #define X86_FEATURE_CQM_MBM_LOCAL	(11*32+ 3) /* LLC Local MBM monitoring */
 #define X86_FEATURE_FENCE_SWAPGS_USER	(11*32+ 4) /* "" LFENCE in user entry SWAPGS path */
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
+/* FREE!				(11*32+ 6) */
+/* FREE!				(11*32+ 7) */
+/* FREE!				(11*32+ 8) */
+/* FREE!				(11*32+ 9) */
+/* FREE!				(11*32+10) */
+#define X86_FEATURE_RRSBA_CTRL		(11*32+11) /* "" RET prediction control */
+#define X86_FEATURE_RETPOLINE		(11*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
+#define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
+#define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
@@ -295,6 +304,7 @@
 #define X86_FEATURE_AMD_SSBD		(13*32+24) /* "" Speculative Store Bypass Disable */
 #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* Virtualized Speculative Store Bypass Disable */
 #define X86_FEATURE_AMD_SSB_NO		(13*32+26) /* "" Speculative Store Bypass is fixed in hardware. */
+#define X86_FEATURE_BTC_NO		(13*32+29) /* "" Not vulnerable to Branch Type Confusion */
 
 /* Thermal and Power Management Leaf, CPUID level 0x00000006 (EAX), word 14 */
 #define X86_FEATURE_DTHERM		(14*32+ 0) /* Digital Thermal Sensor */
@@ -395,5 +405,7 @@
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
 #define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
+#define X86_BUG_RETBLEED		X86_BUG(27) /* CPU is affected by RETBleed */
+#define X86_BUG_EIBRS_PBRSB		X86_BUG(28) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 05d2d7169ab8..7811d42e78ef 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -16,6 +16,9 @@
  * that group keep the CPUID for the variants sorted by model number.
  */
 
+/* Wildcard match for FAM6 so X86_MATCH_INTEL_FAM6_MODEL(ANY) works */
+#define INTEL_FAM6_ANY			X86_MODEL_ANY
+
 #define INTEL_FAM6_CORE_YONAH		0x0E
 
 #define INTEL_FAM6_CORE2_MEROM		0x0F
@@ -103,4 +106,7 @@
 #define INTEL_FAM6_XEON_PHI_KNL		0x57 /* Knights Landing */
 #define INTEL_FAM6_XEON_PHI_KNM		0x85 /* Knights Mill */
 
+/* Family 5 */
+#define INTEL_FAM5_QUARK_X1000		0x09 /* Quark X1000 SoC */
+
 #endif /* _ASM_X86_INTEL_FAMILY_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index c090d8e8fbb3..92c6054f0a00 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -47,6 +47,8 @@
 #define SPEC_CTRL_STIBP			BIT(SPEC_CTRL_STIBP_SHIFT)	/* STIBP mask */
 #define SPEC_CTRL_SSBD_SHIFT		2	   /* Speculative Store Bypass Disable bit */
 #define SPEC_CTRL_SSBD			BIT(SPEC_CTRL_SSBD_SHIFT)	/* Speculative Store Bypass Disable */
+#define SPEC_CTRL_RRSBA_DIS_S_SHIFT	6	   /* Disable RRSBA behavior */
+#define SPEC_CTRL_RRSBA_DIS_S		BIT(SPEC_CTRL_RRSBA_DIS_S_SHIFT)
 
 #define MSR_IA32_PRED_CMD		0x00000049 /* Prediction Command */
 #define PRED_CMD_IBPB			BIT(0)	   /* Indirect Branch Prediction Barrier */
@@ -73,6 +75,7 @@
 #define MSR_IA32_ARCH_CAPABILITIES	0x0000010a
 #define ARCH_CAP_RDCL_NO		BIT(0)	/* Not susceptible to Meltdown */
 #define ARCH_CAP_IBRS_ALL		BIT(1)	/* Enhanced IBRS support */
+#define ARCH_CAP_RSBA			BIT(2)	/* RET may use alternative branch predictors */
 #define ARCH_CAP_SKIP_VMENTRY_L1DFLUSH	BIT(3)	/* Skip L1D flush on vmentry */
 #define ARCH_CAP_SSB_NO			BIT(4)	/*
 						 * Not susceptible to Speculative Store Bypass
@@ -120,6 +123,17 @@
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
+#define ARCH_CAP_PBRSB_NO		BIT(24)	/*
+						 * Not susceptible to Post-Barrier
+						 * Return Stack Buffer Predictions.
+						 */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 8a618fbf569f..118441f53399 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -4,11 +4,14 @@
 #define _ASM_X86_NOSPEC_BRANCH_H_
 
 #include <linux/static_key.h>
+#include <linux/frame.h>
 
 #include <asm/alternative.h>
 #include <asm/alternative-asm.h>
 #include <asm/cpufeatures.h>
 #include <asm/msr-index.h>
+#include <asm/unwind_hints.h>
+#include <asm/percpu.h>
 
 /*
  * Fill the CPU return stack buffer.
@@ -50,9 +53,18 @@
 	lfence;					\
 	jmp	775b;				\
 774:						\
+	add	$(BITS_PER_LONG/8) * 2, sp;	\
 	dec	reg;				\
 	jnz	771b;				\
-	add	$(BITS_PER_LONG/8) * nr, sp;
+	/* barrier for jnz misprediction */	\
+	lfence;
+
+#define ISSUE_UNBALANCED_RET_GUARD(sp)		\
+	call 992f;				\
+	int3;					\
+992:						\
+	add $(BITS_PER_LONG/8), sp;		\
+	lfence;
 
 #ifdef __ASSEMBLY__
 
@@ -141,13 +153,9 @@
   * monstrosity above, manually.
   */
 .macro FILL_RETURN_BUFFER reg:req nr:req ftr:req
-#ifdef CONFIG_RETPOLINE
-	ANNOTATE_NOSPEC_ALTERNATIVE
-	ALTERNATIVE "jmp .Lskip_rsb_\@",				\
-		__stringify(__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP))	\
-		\ftr
+	ALTERNATIVE "jmp .Lskip_rsb_\@", "", \ftr
+	__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP)
 .Lskip_rsb_\@:
-#endif
 .endm
 
 #else /* __ASSEMBLY__ */
@@ -228,6 +236,7 @@ enum spectre_v2_mitigation {
 	SPECTRE_V2_EIBRS,
 	SPECTRE_V2_EIBRS_RETPOLINE,
 	SPECTRE_V2_EIBRS_LFENCE,
+	SPECTRE_V2_IBRS,
 };
 
 /* The indirect branch speculation control variants */
@@ -256,19 +265,19 @@ extern char __indirect_thunk_end[];
  * retpoline and IBRS mitigations for Spectre v2 need this; only on future
  * CPUs with IBRS_ALL *might* it be avoided.
  */
-static inline void vmexit_fill_RSB(void)
+static __always_inline void vmexit_fill_RSB(void)
 {
-#ifdef CONFIG_RETPOLINE
 	unsigned long loops;
 
 	asm volatile (ANNOTATE_NOSPEC_ALTERNATIVE
-		      ALTERNATIVE("jmp 910f",
-				  __stringify(__FILL_RETURN_BUFFER(%0, RSB_CLEAR_LOOPS, %1)),
-				  X86_FEATURE_RETPOLINE)
+		      ALTERNATIVE_2("jmp 910f", "", X86_FEATURE_RSB_VMEXIT,
+				    "jmp 911f", X86_FEATURE_RSB_VMEXIT_LITE)
+		      __stringify(__FILL_RETURN_BUFFER(%0, RSB_CLEAR_LOOPS, %1))
+		      "911:"
+		      __stringify(ISSUE_UNBALANCED_RET_GUARD(%1))
 		      "910:"
 		      : "=r" (loops), ASM_CALL_CONSTRAINT
 		      : : "memory" );
-#endif
 }
 
 static __always_inline
@@ -291,6 +300,9 @@ static inline void indirect_branch_prediction_barrier(void)
 
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
+DECLARE_PER_CPU(u64, x86_spec_ctrl_current);
+extern void write_spec_ctrl_current(u64 val, bool force);
+extern u64 spec_ctrl_current(void);
 
 /*
  * With retpoline, we must use IBRS to restrict branch prediction
@@ -300,18 +312,16 @@ extern u64 x86_spec_ctrl_base;
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
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 3914f9218a6b..0ccd74d37aad 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -857,12 +857,21 @@ static void init_amd_zn(struct cpuinfo_x86 *c)
 {
 	set_cpu_cap(c, X86_FEATURE_ZEN);
 
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
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 68056ee5dff9..05dcdb419abd 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -37,6 +37,8 @@
 
 static void __init spectre_v1_select_mitigation(void);
 static void __init spectre_v2_select_mitigation(void);
+static void __init retbleed_select_mitigation(void);
+static void __init spectre_v2_user_select_mitigation(void);
 static void __init ssb_select_mitigation(void);
 static void __init l1tf_select_mitigation(void);
 static void __init mds_select_mitigation(void);
@@ -46,16 +48,40 @@ static void __init taa_select_mitigation(void);
 static void __init mmio_select_mitigation(void);
 static void __init srbds_select_mitigation(void);
 
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
@@ -105,13 +131,21 @@ void __init check_bugs(void)
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
@@ -151,31 +185,17 @@ void __init check_bugs(void)
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
@@ -705,12 +725,101 @@ static int __init nospectre_v1_cmdline(char *str)
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
+	RETBLEED_MITIGATION_IBRS,
+	RETBLEED_MITIGATION_EIBRS,
+};
+
+enum retbleed_mitigation_cmd {
+	RETBLEED_CMD_OFF,
+	RETBLEED_CMD_AUTO
+};
+
+const char * const retbleed_strings[] = {
+	[RETBLEED_MITIGATION_NONE]	= "Vulnerable",
+	[RETBLEED_MITIGATION_IBRS]	= "Mitigation: IBRS",
+	[RETBLEED_MITIGATION_EIBRS]	= "Mitigation: Enhanced IBRS",
+};
+
+static enum retbleed_mitigation retbleed_mitigation __ro_after_init =
+	RETBLEED_MITIGATION_NONE;
+static enum retbleed_mitigation_cmd retbleed_cmd __ro_after_init =
+	RETBLEED_CMD_AUTO;
+
+static int __init retbleed_parse_cmdline(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (!strcmp(str, "off"))
+		retbleed_cmd = RETBLEED_CMD_OFF;
+	else if (!strcmp(str, "auto"))
+		retbleed_cmd = RETBLEED_CMD_AUTO;
+	else
+		pr_err("Unknown retbleed option (%s). Defaulting to 'auto'\n", str);
+
+	return 0;
+}
+early_param("retbleed", retbleed_parse_cmdline);
+
+#define RETBLEED_INTEL_MSG "WARNING: Spectre v2 mitigation leaves CPU vulnerable to RETBleed attacks, data leaks possible!\n"
+
+static void __init retbleed_select_mitigation(void)
+{
+	if (!boot_cpu_has_bug(X86_BUG_RETBLEED) || cpu_mitigations_off())
+		return;
+
+	switch (retbleed_cmd) {
+	case RETBLEED_CMD_OFF:
+		return;
+
+	case RETBLEED_CMD_AUTO:
+	default:
+		/*
+		 * The Intel mitigation (IBRS) was already selected in
+		 * spectre_v2_select_mitigation().
+		 */
+
+		break;
+	}
+
+	switch (retbleed_mitigation) {
+	default:
+		break;
+	}
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
@@ -740,6 +849,7 @@ static inline const char *spectre_v2_module_string(void) { return ""; }
 #define SPECTRE_V2_LFENCE_MSG "WARNING: LFENCE mitigation is not recommended for this CPU, data leaks possible!\n"
 #define SPECTRE_V2_EIBRS_EBPF_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!\n"
 #define SPECTRE_V2_EIBRS_LFENCE_EBPF_SMT_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS+LFENCE mitigation and SMT, data leaks possible via Spectre v2 BHB attacks!\n"
+#define SPECTRE_V2_IBRS_PERF_MSG "WARNING: IBRS mitigation selected on Enhanced IBRS CPU, this may cause unnecessary performance loss\n"
 
 #ifdef CONFIG_BPF_SYSCALL
 void unpriv_ebpf_notify(int new_state)
@@ -781,6 +891,7 @@ enum spectre_v2_mitigation_cmd {
 	SPECTRE_V2_CMD_EIBRS,
 	SPECTRE_V2_CMD_EIBRS_RETPOLINE,
 	SPECTRE_V2_CMD_EIBRS_LFENCE,
+	SPECTRE_V2_CMD_IBRS,
 };
 
 enum spectre_v2_user_cmd {
@@ -821,13 +932,15 @@ static void __init spec_v2_user_print_cond(const char *reason, bool secure)
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
@@ -853,15 +966,16 @@ spectre_v2_parse_user_cmdline(enum spectre_v2_mitigation_cmd v2_cmd)
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
@@ -874,7 +988,7 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 	    cpu_smt_control == CPU_SMT_NOT_SUPPORTED)
 		smt_possible = false;
 
-	cmd = spectre_v2_parse_user_cmdline(v2_cmd);
+	cmd = spectre_v2_parse_user_cmdline();
 	switch (cmd) {
 	case SPECTRE_V2_USER_CMD_NONE:
 		goto set_mode;
@@ -922,12 +1036,12 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
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
@@ -952,6 +1066,7 @@ static const char * const spectre_v2_strings[] = {
 	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced IBRS",
 	[SPECTRE_V2_EIBRS_LFENCE]		= "Mitigation: Enhanced IBRS + LFENCE",
 	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced IBRS + Retpolines",
+	[SPECTRE_V2_IBRS]			= "Mitigation: IBRS",
 };
 
 static const struct {
@@ -969,6 +1084,7 @@ static const struct {
 	{ "eibrs,lfence",	SPECTRE_V2_CMD_EIBRS_LFENCE,	  false },
 	{ "eibrs,retpoline",	SPECTRE_V2_CMD_EIBRS_RETPOLINE,	  false },
 	{ "auto",		SPECTRE_V2_CMD_AUTO,		  false },
+	{ "ibrs",		SPECTRE_V2_CMD_IBRS,              false },
 };
 
 static void __init spec_v2_print_cond(const char *reason, bool secure)
@@ -1031,6 +1147,24 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
 		return SPECTRE_V2_CMD_AUTO;
 	}
 
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
@@ -1046,6 +1180,70 @@ static enum spectre_v2_mitigation __init spectre_v2_select_retpoline(void)
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
+static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_mitigation mode)
+{
+	/*
+	 * Similar to context switches, there are two types of RSB attacks
+	 * after VM exit:
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
+	 * eIBRS should protect against RSB poisoning, but if the EIBRS_PBRSB
+	 * bug is present then a LITE version of RSB protection is required,
+	 * just a single call needs to retire before a RET is executed.
+	 */
+	switch (mode) {
+	case SPECTRE_V2_NONE:
+		return;
+
+	case SPECTRE_V2_EIBRS_LFENCE:
+	case SPECTRE_V2_EIBRS:
+		if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB) &&
+		    (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)) {
+			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
+			pr_info("Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT\n");
+		}
+		return;
+
+	case SPECTRE_V2_EIBRS_RETPOLINE:
+	case SPECTRE_V2_RETPOLINE:
+	case SPECTRE_V2_LFENCE:
+	case SPECTRE_V2_IBRS:
+		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
+		pr_info("Spectre v2 / SpectreRSB : Filling RSB on VMEXIT\n");
+		return;
+	}
+
+	pr_warn_once("Unknown Spectre v2 mode, disabling RSB mitigation at VM exit");
+	dump_stack();
+}
+
 static void __init spectre_v2_select_mitigation(void)
 {
 	enum spectre_v2_mitigation_cmd cmd = spectre_v2_parse_cmdline();
@@ -1070,6 +1268,14 @@ static void __init spectre_v2_select_mitigation(void)
 			break;
 		}
 
+		if (boot_cpu_has_bug(X86_BUG_RETBLEED) &&
+		    retbleed_cmd != RETBLEED_CMD_OFF &&
+		    boot_cpu_has(X86_FEATURE_IBRS) &&
+		    boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) {
+			mode = SPECTRE_V2_IBRS;
+			break;
+		}
+
 		mode = spectre_v2_select_retpoline();
 		break;
 
@@ -1086,6 +1292,10 @@ static void __init spectre_v2_select_mitigation(void)
 		mode = spectre_v2_select_retpoline();
 		break;
 
+	case SPECTRE_V2_CMD_IBRS:
+		mode = SPECTRE_V2_IBRS;
+		break;
+
 	case SPECTRE_V2_CMD_EIBRS:
 		mode = SPECTRE_V2_EIBRS;
 		break;
@@ -1102,10 +1312,9 @@ static void __init spectre_v2_select_mitigation(void)
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
@@ -1113,6 +1322,12 @@ static void __init spectre_v2_select_mitigation(void)
 	case SPECTRE_V2_EIBRS:
 		break;
 
+	case SPECTRE_V2_IBRS:
+		setup_force_cpu_cap(X86_FEATURE_KERNEL_IBRS);
+		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED))
+			pr_warn(SPECTRE_V2_IBRS_PERF_MSG);
+		break;
+
 	case SPECTRE_V2_LFENCE:
 	case SPECTRE_V2_EIBRS_LFENCE:
 		setup_force_cpu_cap(X86_FEATURE_RETPOLINE_LFENCE);
@@ -1124,43 +1339,86 @@ static void __init spectre_v2_select_mitigation(void)
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
+	 *
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
 	 *
-	 *	- RSB underflow (and switch to BTB) on Skylake+
-	 *	- SpectreRSB variant of spectre v2 on X86_BUG_SPECTRE_V2 CPUs
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
 
+	spectre_v2_determine_rsb_fill_type_at_vmexit(mode);
+
 	/*
-	 * Retpoline means the kernel is safe because it has no indirect
-	 * branches. Enhanced IBRS protects firmware too, so, enable restricted
-	 * speculation around firmware calls only when Enhanced IBRS isn't
-	 * supported.
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
@@ -1376,16 +1634,6 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
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
@@ -1403,7 +1651,7 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
 			x86_amd_ssb_disable();
 		} else {
 			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
-			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+			write_spec_ctrl_current(x86_spec_ctrl_base, true);
 		}
 	}
 
@@ -1608,7 +1856,7 @@ int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which)
 void x86_spec_ctrl_setup_ap(void)
 {
 	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
-		wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+		write_spec_ctrl_current(x86_spec_ctrl_base, true);
 
 	if (ssb_mode == SPEC_STORE_BYPASS_DISABLE)
 		x86_amd_ssb_disable();
@@ -1843,7 +2091,7 @@ static ssize_t mmio_stale_data_show_state(char *buf)
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))
+	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
 		return "";
 
 	switch (spectre_v2_user_stibp) {
@@ -1873,6 +2121,19 @@ static char *ibpb_state(void)
 	return "";
 }
 
+static char *pbrsb_eibrs_state(void)
+{
+	if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
+		if (boot_cpu_has(X86_FEATURE_RSB_VMEXIT_LITE) ||
+		    boot_cpu_has(X86_FEATURE_RSB_VMEXIT))
+			return ", PBRSB-eIBRS: SW sequence";
+		else
+			return ", PBRSB-eIBRS: Vulnerable";
+	} else {
+		return ", PBRSB-eIBRS: Not affected";
+	}
+}
+
 static ssize_t spectre_v2_show_state(char *buf)
 {
 	if (spectre_v2_enabled == SPECTRE_V2_LFENCE)
@@ -1885,12 +2146,13 @@ static ssize_t spectre_v2_show_state(char *buf)
 	    spectre_v2_enabled == SPECTRE_V2_EIBRS_LFENCE)
 		return sprintf(buf, "Vulnerable: eIBRS+LFENCE with unprivileged eBPF and SMT\n");
 
-	return sprintf(buf, "%s%s%s%s%s%s\n",
+	return sprintf(buf, "%s%s%s%s%s%s%s\n",
 		       spectre_v2_strings[spectre_v2_enabled],
 		       ibpb_state(),
 		       boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? ", IBRS_FW" : "",
 		       stibp_state(),
 		       boot_cpu_has(X86_FEATURE_RSB_CTXSW) ? ", RSB filling" : "",
+		       pbrsb_eibrs_state(),
 		       spectre_v2_module_string());
 }
 
@@ -1899,6 +2161,11 @@ static ssize_t srbds_show_state(char *buf)
 	return sprintf(buf, "%s\n", srbds_strings[srbds_mitigation]);
 }
 
+static ssize_t retbleed_show_state(char *buf)
+{
+	return sprintf(buf, "%s\n", retbleed_strings[retbleed_mitigation]);
+}
+
 static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr,
 			       char *buf, unsigned int bug)
 {
@@ -1942,6 +2209,9 @@ static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr
 	case X86_BUG_MMIO_UNKNOWN:
 		return mmio_stale_data_show_state(buf);
 
+	case X86_BUG_RETBLEED:
+		return retbleed_show_state(buf);
+
 	default:
 		break;
 	}
@@ -2001,4 +2271,9 @@ ssize_t cpu_show_mmio_stale_data(struct device *dev, struct device_attribute *at
 	else
 		return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
 }
+
+ssize_t cpu_show_retbleed(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_RETBLEED);
+}
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e72a21c20772..2ad6d3b02a38 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -906,6 +906,7 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 #define NO_SWAPGS		BIT(6)
 #define NO_ITLB_MULTIHIT	BIT(7)
 #define NO_MMIO			BIT(8)
+#define NO_EIBRS_PBRSB		BIT(9)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -947,7 +948,7 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 
 	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB),
 
 	/*
 	 * Technically, swapgs isn't serializing on AMD (despite it previously
@@ -957,7 +958,9 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	 * good enough for our purposes.
 	 */
 
-	VULNWL_INTEL(ATOM_TREMONT_X,		NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_TREMONT,		NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_L,		NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_X,		NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
 
 	/* AMD Family 0xf - 0x12 */
 	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
@@ -970,48 +973,55 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
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
 #define SRBDS		BIT(0)
 /* CPU is affected by X86_BUG_MMIO_STALE_DATA */
 #define MMIO		BIT(1)
 /* CPU is affected by Shared Buffers Data Sampling (SBDS), a variant of X86_BUG_MMIO_STALE_DATA */
 #define MMIO_SBDS	BIT(2)
+/* CPU is affected by RETbleed, speculating where you would not expect it */
+#define RETBLEED	BIT(3)
 
 static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(IVYBRIDGE,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(HASWELL_CORE,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(HASWELL_ULT,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(HASWELL_GT3E,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(HASWELL_X,	BIT(2) | BIT(4),		MMIO),
-	VULNBL_INTEL_STEPPINGS(BROADWELL_XEON_D,X86_STEPPINGS(0x3, 0x5),	MMIO),
+	VULNBL_INTEL_STEPPINGS(HASWELL_X,	X86_STEPPING_ANY,		MMIO),
+	VULNBL_INTEL_STEPPINGS(BROADWELL_XEON_D,X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_GT3E,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_X,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_CORE,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_MOBILE,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_MOBILE,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_X,	BIT(3) | BIT(4) | BIT(6) |
-						BIT(7) | BIT(0xB),              MMIO),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPINGS(0x9, 0xC),	SRBDS | MMIO),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPINGS(0x0, 0x8),	SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPINGS(0x9, 0xD),	SRBDS | MMIO),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPINGS(0x0, 0x8),	SRBDS),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_MOBILE,	X86_STEPPINGS(0x5, 0x5),	MMIO | MMIO_SBDS),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_XEON_D,	X86_STEPPINGS(0x1, 0x1),	MMIO),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPINGS(0x4, 0x6),	MMIO),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE,	BIT(2) | BIT(3) | BIT(5),	MMIO | MMIO_SBDS),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x0, 0x0),	MMIO),
-	VULNBL_INTEL_STEPPINGS(LAKEFIELD,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
-	VULNBL_INTEL_STEPPINGS(ROCKETLAKE,	X86_STEPPINGS(0x1, 0x1),	MMIO),
-	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_MOBILE,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_X,	X86_STEPPING_ANY,		MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(CANNONLAKE_MOBILE,X86_STEPPING_ANY,		RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_MOBILE,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_XEON_D,	X86_STEPPING_ANY,		MMIO),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPING_ANY,		MMIO),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(LAKEFIELD,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ROCKETLAKE,	X86_STEPPING_ANY,		MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS),
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_X,	X86_STEPPING_ANY,		MMIO),
-	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | MMIO_SBDS),
+	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_L,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS),
+
+	VULNBL_AMD(0x15, RETBLEED),
+	VULNBL_AMD(0x16, RETBLEED),
+	VULNBL_AMD(0x17, RETBLEED),
 	{}
 };
 
@@ -1117,6 +1127,16 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 			setup_force_cpu_bug(X86_BUG_MMIO_UNKNOWN);
 	}
 
+	if (!cpu_has(c, X86_FEATURE_BTC_NO)) {
+		if (cpu_matches(cpu_vuln_blacklist, RETBLEED) || (ia32_cap & ARCH_CAP_RSBA))
+			setup_force_cpu_bug(X86_BUG_RETBLEED);
+	}
+
+	if (cpu_has(c, X86_FEATURE_IBRS_ENHANCED) &&
+	    !cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
+	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
+		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index 751e59057466..ad6776081e60 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -16,12 +16,17 @@
  * respective wildcard entries.
  *
  * A typical table entry would be to match a specific CPU
- * { X86_VENDOR_INTEL, 6, 0x12 }
- * or to match a specific CPU feature
- * { X86_FEATURE_MATCH(X86_FEATURE_FOOBAR) }
+ *
+ * X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6, INTEL_FAM6_BROADWELL,
+ *				      X86_FEATURE_ANY, NULL);
  *
  * Fields can be wildcarded with %X86_VENDOR_ANY, %X86_FAMILY_ANY,
- * %X86_MODEL_ANY, %X86_FEATURE_ANY or 0 (except for vendor)
+ * %X86_MODEL_ANY, %X86_FEATURE_ANY (except for vendor)
+ *
+ * asm/cpu_device_id.h contains a set of useful macros which are shortcuts
+ * for various common selections. The above can be shortened to:
+ *
+ * X86_MATCH_INTEL_FAM6_MODEL(BROADWELL, NULL);
  *
  * Arrays used to match for this should also be declared using
  * MODULE_DEVICE_TABLE(x86cpu, ...)
@@ -53,3 +58,34 @@ const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match)
 	return NULL;
 }
 EXPORT_SYMBOL(x86_match_cpu);
+
+static const struct x86_cpu_desc *
+x86_match_cpu_with_stepping(const struct x86_cpu_desc *match)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	const struct x86_cpu_desc *m;
+
+	for (m = match; m->x86_family | m->x86_model; m++) {
+		if (c->x86_vendor != m->x86_vendor)
+			continue;
+		if (c->x86 != m->x86_family)
+			continue;
+		if (c->x86_model != m->x86_model)
+			continue;
+		if (c->x86_stepping != m->x86_stepping)
+			continue;
+		return m;
+	}
+	return NULL;
+}
+
+bool x86_cpu_has_min_microcode_rev(const struct x86_cpu_desc *table)
+{
+	const struct x86_cpu_desc *res = x86_match_cpu_with_stepping(table);
+
+	if (!res || res->x86_microcode_rev > boot_cpu_data.microcode)
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(x86_cpu_has_min_microcode_rev);
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 0b9c7150cb23..efdb1decf034 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -21,6 +21,7 @@ struct cpuid_bit {
 static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_APERFMPERF,       CPUID_ECX,  0, 0x00000006, 0 },
 	{ X86_FEATURE_EPB,		CPUID_ECX,  3, 0x00000006, 0 },
+	{ X86_FEATURE_RRSBA_CTRL,	CPUID_EDX,  2, 0x00000007, 2 },
 	{ X86_FEATURE_CQM_LLC,		CPUID_EDX,  1, 0x0000000f, 0 },
 	{ X86_FEATURE_CQM_OCCUP_LLC,	CPUID_EDX,  0, 0x0000000f, 1 },
 	{ X86_FEATURE_CQM_MBM_TOTAL,	CPUID_EDX,  1, 0x0000000f, 1 },
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index a07b09f68e7e..baa9254149e7 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -435,7 +435,7 @@ static __always_inline void __speculation_ctrl_update(unsigned long tifp,
 	}
 
 	if (updmsr)
-		wrmsrl(MSR_IA32_SPEC_CTRL, msr);
+		write_spec_ctrl_current(msr, false);
 }
 
 static unsigned long speculation_ctrl_update_tif(struct task_struct *tsk)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 69056af43a98..7d8670896203 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -47,6 +47,7 @@
 #include <asm/irq_remapping.h>
 #include <asm/microcode.h>
 #include <asm/spec-ctrl.h>
+#include <asm/cpu_device_id.h>
 
 #include <asm/virtext.h>
 #include "trace.h"
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 27d99928a10e..aea4c497da3f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -40,6 +40,7 @@
 #include "x86.h"
 
 #include <asm/cpu.h>
+#include <asm/cpu_device_id.h>
 #include <asm/io.h>
 #include <asm/desc.h>
 #include <asm/vmx.h>
@@ -9769,10 +9770,36 @@ static void vmx_arm_hv_timer(struct kvm_vcpu *vcpu)
 	vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, delta_tsc);
 }
 
+u64 __always_inline vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx)
+{
+	u64 guestval, hostval = this_cpu_read(x86_spec_ctrl_current);
+
+	if (!cpu_feature_enabled(X86_FEATURE_MSR_SPEC_CTRL))
+		return 0;
+
+	guestval = __rdmsr(MSR_IA32_SPEC_CTRL);
+
+	/*
+	 * If the guest/host SPEC_CTRL values differ, restore the host value.
+	 *
+	 * For legacy IBRS, the IBRS bit always needs to be written after
+	 * transitioning from a less privileged predictor mode, regardless of
+	 * whether the guest/host values differ.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) ||
+	    guestval != hostval)
+		native_wrmsrl(MSR_IA32_SPEC_CTRL, hostval);
+
+	barrier_nospec();
+
+	return guestval;
+}
+
 static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long debugctlmsr, cr3, cr4;
+	u64 spec_ctrl;
 
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!cpu_has_virtual_nmis() &&
@@ -9966,6 +9993,23 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		, "eax", "ebx", "edi", "esi"
 #endif
 	      );
+	/*
+	 * IMPORTANT: RSB filling and SPEC_CTRL handling must be done before
+	 * the first unbalanced RET after vmexit!
+	 *
+	 * For retpoline or IBRS, RSB filling is needed to prevent poisoned RSB
+	 * entries and (in some cases) RSB underflow.
+	 *
+	 * eIBRS has its own protection against poisoned RSB, so it doesn't
+	 * need the RSB filling sequence.  But it does need to be enabled, and a
+	 * single call to retire, before the first unbalanced RET.
+	 *
+	 * So no RETs before vmx_spec_ctrl_restore_host() below.
+	 */
+	vmexit_fill_RSB();
+
+	/* Save this for below */
+	spec_ctrl = vmx_spec_ctrl_restore_host(vmx);
 
 	vmx_enable_fb_clear(vmx);
 
@@ -9985,12 +10029,7 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 * save it.
 	 */
 	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
-		vmx->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
-
-	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
-
-	/* Eliminate branch target predictions from guest mode */
-	vmexit_fill_RSB();
+		vmx->spec_ctrl = spec_ctrl;
 
 	/* MSR_IA32_DEBUGCTLMSR is zeroed on vmexit. Restore it if needed */
 	if (debugctlmsr)
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index ba4e7732e2c7..9ae153124380 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -564,6 +564,12 @@ ssize_t __weak cpu_show_mmio_stale_data(struct device *dev,
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
@@ -574,6 +580,7 @@ static DEVICE_ATTR(tsx_async_abort, 0444, cpu_show_tsx_async_abort, NULL);
 static DEVICE_ATTR(itlb_multihit, 0444, cpu_show_itlb_multihit, NULL);
 static DEVICE_ATTR(srbds, 0444, cpu_show_srbds, NULL);
 static DEVICE_ATTR(mmio_stale_data, 0444, cpu_show_mmio_stale_data, NULL);
+static DEVICE_ATTR(retbleed, 0444, cpu_show_retbleed, NULL);
 
 static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_meltdown.attr,
@@ -586,6 +593,7 @@ static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_itlb_multihit.attr,
 	&dev_attr_srbds.attr,
 	&dev_attr_mmio_stale_data.attr,
+	&dev_attr_retbleed.attr,
 	NULL
 };
 
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 8a199b4047c2..6b5304177575 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -47,6 +47,7 @@
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/cpufeature.h>
+#include <asm/cpu_device_id.h>
 
 MODULE_AUTHOR("Paul Diefenbaugh, Dominik Brodowski");
 MODULE_DESCRIPTION("ACPI Processor P-States Driver");
diff --git a/drivers/cpufreq/amd_freq_sensitivity.c b/drivers/cpufreq/amd_freq_sensitivity.c
index 042023bbbf62..b7692861b2f7 100644
--- a/drivers/cpufreq/amd_freq_sensitivity.c
+++ b/drivers/cpufreq/amd_freq_sensitivity.c
@@ -20,6 +20,7 @@
 
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
+#include <asm/cpu_device_id.h>
 
 #include "cpufreq_ondemand.h"
 
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 31f54a334b58..51cc492c2e35 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -58,11 +58,13 @@
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
 
@@ -97,6 +99,8 @@ static const struct idle_cpu *icpu;
 static struct cpuidle_device __percpu *intel_idle_cpuidle_devices;
 static int intel_idle(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv, int index);
+static int intel_idle_ibrs(struct cpuidle_device *dev,
+			   struct cpuidle_driver *drv, int index);
 static void intel_idle_s2idle(struct cpuidle_device *dev,
 			      struct cpuidle_driver *drv, int index);
 static struct cpuidle_state *cpuidle_state_table;
@@ -109,6 +113,12 @@ static struct cpuidle_state *cpuidle_state_table;
  */
 #define CPUIDLE_FLAG_TLB_FLUSHED	0x10000
 
+/*
+ * Disable IBRS across idle (when KERNEL_IBRS), is exclusive vs IRQ_ENABLE
+ * above.
+ */
+#define CPUIDLE_FLAG_IBRS		BIT(16)
+
 /*
  * MWAIT takes an 8-bit "hint" in EAX "suggesting"
  * the C-state (top nibble) and sub-state (bottom nibble)
@@ -617,7 +627,7 @@ static struct cpuidle_state skl_cstates[] = {
 	{
 		.name = "C6",
 		.desc = "MWAIT 0x20",
-		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 85,
 		.target_residency = 200,
 		.enter = &intel_idle,
@@ -625,7 +635,7 @@ static struct cpuidle_state skl_cstates[] = {
 	{
 		.name = "C7s",
 		.desc = "MWAIT 0x33",
-		.flags = MWAIT2flg(0x33) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x33) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 124,
 		.target_residency = 800,
 		.enter = &intel_idle,
@@ -633,7 +643,7 @@ static struct cpuidle_state skl_cstates[] = {
 	{
 		.name = "C8",
 		.desc = "MWAIT 0x40",
-		.flags = MWAIT2flg(0x40) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x40) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 200,
 		.target_residency = 800,
 		.enter = &intel_idle,
@@ -641,7 +651,7 @@ static struct cpuidle_state skl_cstates[] = {
 	{
 		.name = "C9",
 		.desc = "MWAIT 0x50",
-		.flags = MWAIT2flg(0x50) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x50) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 480,
 		.target_residency = 5000,
 		.enter = &intel_idle,
@@ -649,7 +659,7 @@ static struct cpuidle_state skl_cstates[] = {
 	{
 		.name = "C10",
 		.desc = "MWAIT 0x60",
-		.flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 890,
 		.target_residency = 5000,
 		.enter = &intel_idle,
@@ -678,7 +688,7 @@ static struct cpuidle_state skx_cstates[] = {
 	{
 		.name = "C6",
 		.desc = "MWAIT 0x20",
-		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 133,
 		.target_residency = 600,
 		.enter = &intel_idle,
@@ -935,6 +945,24 @@ static __cpuidle int intel_idle(struct cpuidle_device *dev,
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
  * intel_idle_s2idle - simplified "enter" callback routine for suspend-to-idle
  * @dev: cpuidle_device
@@ -1375,6 +1403,11 @@ static void __init intel_idle_cpuidle_driver_init(void)
 			mark_tsc_unstable("TSC halts in idle"
 					" states deeper than C2");
 
+		if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) &&
+		    cpuidle_state_table[cstate].flags & CPUIDLE_FLAG_IBRS) {
+			drv->states[drv->state_count].enter = intel_idle_ibrs;
+		}
+
 		drv->states[drv->state_count] =	/* structure copy */
 			cpuidle_state_table[cstate];
 
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index f958ecc82de9..8c4d21e71774 100644
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
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 6f8eb1238235..97794823eabd 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -604,9 +604,7 @@ struct x86_cpu_id {
 	__u16 steppings;
 };
 
-#define X86_FEATURE_MATCH(x) \
-	{ X86_VENDOR_ANY, X86_FAMILY_ANY, X86_MODEL_ANY, x }
-
+/* Wild cards for x86_cpu_id::vendor, family, model and feature */
 #define X86_VENDOR_ANY 0xffff
 #define X86_FAMILY_ANY 0
 #define X86_MODEL_ANY  0
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index bb5861adb5a0..8fd46c879348 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -270,6 +270,7 @@
 
 /* Intel-defined CPU QoS Sub-leaf, CPUID level 0x0000000F:0 (EDX), word 11 */
 #define X86_FEATURE_CQM_LLC		(11*32+ 1) /* LLC QoS if 1 */
+#define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM-Exit when EIBRS is enabled */
 
 /* Intel-defined CPU QoS Sub-leaf, CPUID level 0x0000000F:1 (EDX), word 12 */
 #define X86_FEATURE_CQM_OCCUP_LLC	(12*32+ 0) /* LLC occupancy monitoring */
