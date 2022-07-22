Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC82E57DE4D
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbiGVJXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236093AbiGVJXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:23:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E663C1982;
        Fri, 22 Jul 2022 02:14:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33DEB61FE3;
        Fri, 22 Jul 2022 09:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BFAC341C7;
        Fri, 22 Jul 2022 09:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481291;
        bh=gyTumT4hw6VHWnWrwAMvjjqvSQdP1RDAw8ZDnCvu/Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqOrMHcwWLJyxU2R8B1AamLU1lEsjsGYrLEgRHaBR2iRmXe6MXjxH7tKZGIMKpktE
         2eR28ieoqc7q7OTUkS1nCG4eIuOhfnVP6g7fdr4LXkj7N1TEjw8f1HiUNur56zML7i
         /w9UOFulli9rqdUpn7YRCs+8c1JIbgN7HbNV1wPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 41/89] x86: Add magic AMD return-thunk
Date:   Fri, 22 Jul 2022 11:11:15 +0200
Message-Id: <20220722091135.665533613@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
References: <20220722091133.320803732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit a149180fbcf336e97ce4eb2cdc13672727feb94d upstream.

Note: needs to be in a section distinct from Retpolines such that the
Retpoline RET substitution cannot possibly use immediate jumps.

ORC unwinding for zen_untrain_ret() and __x86_return_thunk() is a
little tricky but works due to the fact that zen_untrain_ret() doesn't
have any stack ops and as such will emit a single ORC entry at the
start (+0x3f).

Meanwhile, unwinding an IP, including the __x86_return_thunk() one
(+0x40) will search for the largest ORC entry smaller or equal to the
IP, these will find the one ORC entry (+0x3f) and all works.

  [ Alexandre: SVM part. ]
  [ bp: Build fix, massages. ]

Suggested-by: Andrew Cooper <Andrew.Cooper3@citrix.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: conflicts at arch/x86/entry/entry_64_compat.S]
[cascardo: there is no ANNOTATE_NOENDBR]
[cascardo: objtool commit 34c861e806478ac2ea4032721defbf1d6967df08 missing]
[cascardo: conflict fixup]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S                |    6 ++
 arch/x86/entry/entry_64_compat.S         |    4 +
 arch/x86/include/asm/cpufeatures.h       |    1 
 arch/x86/include/asm/disabled-features.h |    3 -
 arch/x86/include/asm/nospec-branch.h     |   17 ++++++++
 arch/x86/kernel/vmlinux.lds.S            |    2 
 arch/x86/kvm/svm/vmenter.S               |   18 ++++++++
 arch/x86/lib/retpoline.S                 |   63 +++++++++++++++++++++++++++++--
 tools/objtool/check.c                    |   20 ++++++++-
 9 files changed, 126 insertions(+), 8 deletions(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -94,6 +94,7 @@ SYM_CODE_START(entry_SYSCALL_64)
 	movq	PER_CPU_VAR(cpu_current_top_of_stack), %rsp
 
 SYM_INNER_LABEL(entry_SYSCALL_64_safe_stack, SYM_L_GLOBAL)
+	UNTRAIN_RET
 
 	/* Construct struct pt_regs on stack */
 	pushq	$__USER_DS				/* pt_regs->ss */
@@ -688,6 +689,7 @@ native_irq_return_ldt:
 	pushq	%rdi				/* Stash user RDI */
 	swapgs					/* to kernel GS */
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rdi	/* to kernel CR3 */
+	UNTRAIN_RET
 
 	movq	PER_CPU_VAR(espfix_waddr), %rdi
 	movq	%rax, (0*8)(%rdi)		/* user RAX */
@@ -882,6 +884,7 @@ SYM_CODE_START_LOCAL(paranoid_entry)
 	 * be retrieved from a kernel internal table.
 	 */
 	SAVE_AND_SWITCH_TO_KERNEL_CR3 scratch_reg=%rax save_reg=%r14
+	UNTRAIN_RET
 
 	/*
 	 * Handling GSBASE depends on the availability of FSGSBASE.
@@ -992,6 +995,7 @@ SYM_CODE_START_LOCAL(error_entry)
 	FENCE_SWAPGS_USER_ENTRY
 	/* We have user CR3.  Change to kernel CR3. */
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
+	UNTRAIN_RET
 
 	leaq	8(%rsp), %rdi			/* arg0 = pt_regs pointer */
 .Lerror_entry_from_usermode_after_swapgs:
@@ -1044,6 +1048,7 @@ SYM_CODE_START_LOCAL(error_entry)
 	SWAPGS
 	FENCE_SWAPGS_USER_ENTRY
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
+	UNTRAIN_RET
 
 	/*
 	 * Pretend that the exception came from user mode: set up pt_regs
@@ -1138,6 +1143,7 @@ SYM_CODE_START(asm_exc_nmi)
 	movq	%rsp, %rdx
 	movq	PER_CPU_VAR(cpu_current_top_of_stack), %rsp
 	UNWIND_HINT_IRET_REGS base=%rdx offset=8
+	UNTRAIN_RET
 	pushq	5*8(%rdx)	/* pt_regs->ss */
 	pushq	4*8(%rdx)	/* pt_regs->rsp */
 	pushq	3*8(%rdx)	/* pt_regs->flags */
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -14,6 +14,7 @@
 #include <asm/irqflags.h>
 #include <asm/asm.h>
 #include <asm/smap.h>
+#include <asm/nospec-branch.h>
 #include <linux/linkage.h>
 #include <linux/err.h>
 
@@ -71,6 +72,7 @@ SYM_CODE_START(entry_SYSENTER_compat)
 	pushq	$__USER32_CS		/* pt_regs->cs */
 	pushq	$0			/* pt_regs->ip = 0 (placeholder) */
 SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
+	UNTRAIN_RET
 
 	/*
 	 * User tracing code (ptrace or signal handlers) might assume that
@@ -211,6 +213,7 @@ SYM_CODE_START(entry_SYSCALL_compat)
 	movq	PER_CPU_VAR(cpu_current_top_of_stack), %rsp
 
 SYM_INNER_LABEL(entry_SYSCALL_compat_safe_stack, SYM_L_GLOBAL)
+	UNTRAIN_RET
 
 	/* Construct struct pt_regs on stack */
 	pushq	$__USER32_DS		/* pt_regs->ss */
@@ -377,6 +380,7 @@ SYM_CODE_START(entry_INT80_compat)
 	pushq	(%rdi)			/* pt_regs->di */
 .Lint80_keep_stack:
 
+	UNTRAIN_RET
 	pushq	%rsi			/* pt_regs->si */
 	xorl	%esi, %esi		/* nospec   si */
 	pushq	%rdx			/* pt_regs->dx */
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -299,6 +299,7 @@
 #define X86_FEATURE_RETPOLINE		(11*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
 #define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
 #define X86_FEATURE_RETHUNK		(11*32+14) /* "" Use REturn THUNK */
+#define X86_FEATURE_UNRET		(11*32+15) /* "" AMD BTB untrain return */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -61,7 +61,8 @@
 #else
 # define DISABLE_RETPOLINE	((1 << (X86_FEATURE_RETPOLINE & 31)) | \
 				 (1 << (X86_FEATURE_RETPOLINE_LFENCE & 31)) | \
-				 (1 << (X86_FEATURE_RETHUNK & 31)))
+				 (1 << (X86_FEATURE_RETHUNK & 31)) | \
+				 (1 << (X86_FEATURE_UNRET & 31)))
 #endif
 
 /* Force disable because it's broken beyond repair */
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -112,6 +112,22 @@
 #endif
 .endm
 
+/*
+ * Mitigate RETBleed for AMD/Hygon Zen uarch. Requires KERNEL CR3 because the
+ * return thunk isn't mapped into the userspace tables (then again, AMD
+ * typically has NO_MELTDOWN).
+ *
+ * Doesn't clobber any registers but does require a stable stack.
+ *
+ * As such, this must be placed after every *SWITCH_TO_KERNEL_CR3 at a point
+ * where we have a stack but before any RET instruction.
+ */
+.macro UNTRAIN_RET
+#ifdef CONFIG_RETPOLINE
+	ALTERNATIVE "", "call zen_untrain_ret", X86_FEATURE_UNRET
+#endif
+.endm
+
 #else /* __ASSEMBLY__ */
 
 #define ANNOTATE_RETPOLINE_SAFE					\
@@ -121,6 +137,7 @@
 	".popsection\n\t"
 
 extern void __x86_return_thunk(void);
+extern void zen_untrain_ret(void);
 
 #ifdef CONFIG_RETPOLINE
 
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
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -111,6 +111,15 @@ SYM_FUNC_START(__svm_vcpu_run)
 #endif
 
 	/*
+	 * Mitigate RETBleed for AMD/Hygon Zen uarch. RET should be
+	 * untrained as soon as we exit the VM and are back to the
+	 * kernel. This should be done before re-enabling interrupts
+	 * because interrupt handlers won't sanitize 'ret' if the return is
+	 * from the kernel.
+	 */
+	UNTRAIN_RET
+
+	/*
 	 * Clear all general purpose registers except RSP and RAX to prevent
 	 * speculative use of the guest's values, even those that are reloaded
 	 * via the stack.  In theory, an L1 cache miss when restoring registers
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
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -71,10 +71,67 @@ SYM_CODE_END(__x86_indirect_thunk_array)
  * This function name is magical and is used by -mfunction-return=thunk-extern
  * for the compiler to generate JMPs to it.
  */
-SYM_CODE_START(__x86_return_thunk)
-	UNWIND_HINT_EMPTY
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
 	ret
 	int3
 SYM_CODE_END(__x86_return_thunk)
 
-__EXPORT_THUNK(__x86_return_thunk)
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
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1145,7 +1145,7 @@ static void add_retpoline_call(struct ob
 	annotate_call_site(file, insn, false);
 }
 
-static void add_return_call(struct objtool_file *file, struct instruction *insn)
+static void add_return_call(struct objtool_file *file, struct instruction *insn, bool add)
 {
 	/*
 	 * Return thunk tail calls are really just returns in disguise,
@@ -1155,7 +1155,7 @@ static void add_return_call(struct objto
 	insn->retpoline_safe = true;
 
 	/* Skip the non-text sections, specially .discard ones */
-	if (insn->sec->text)
+	if (add && insn->sec->text)
 		list_add_tail(&insn->call_node, &file->return_thunk_list);
 }
 
@@ -1184,7 +1184,7 @@ static int add_jump_destinations(struct
 			add_retpoline_call(file, insn);
 			continue;
 		} else if (reloc->sym->return_thunk) {
-			add_return_call(file, insn);
+			add_return_call(file, insn, true);
 			continue;
 		} else if (insn->func) {
 			/* internal or external sibling call (with reloc) */
@@ -1201,6 +1201,7 @@ static int add_jump_destinations(struct
 
 		insn->jump_dest = find_insn(file, dest_sec, dest_off);
 		if (!insn->jump_dest) {
+			struct symbol *sym = find_symbol_by_offset(dest_sec, dest_off);
 
 			/*
 			 * This is a special case where an alt instruction
@@ -1210,6 +1211,19 @@ static int add_jump_destinations(struct
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


