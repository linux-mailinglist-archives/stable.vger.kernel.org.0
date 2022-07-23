Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEFE357EE4B
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238871AbiGWKJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238960AbiGWKJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:09:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6963F329;
        Sat, 23 Jul 2022 03:02:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D41FF61263;
        Sat, 23 Jul 2022 10:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC755C341C0;
        Sat, 23 Jul 2022 10:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570536;
        bh=PR4qSsLfCebVv1MQRnxZGaYukimLYC4djFlgxVu5qwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExkolcrzIGz7JZfOwLsRe4FrnuWxd38XyZKuRPS3LfQYcoRBCZbUKZ3Pa/UhTaJCq
         RrfxTLspYrZjtmupCpiQjFerHyAipw4EPztQmRtSqlzj2oPRZukznW9LyQgeVs+vbR
         XxJVZXLI/rsGlh5RVL1C/DbdnE5PgDSsQgwfPutE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 110/148] objtool: Add entry UNRET validation
Date:   Sat, 23 Jul 2022 11:55:22 +0200
Message-Id: <20220723095255.234133949@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
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

commit a09a6e2399ba0595c3042b3164f3ca68a3cff33e upstream.

Since entry asm is tricky, add a validation pass that ensures the
retbleed mitigation has been done before the first actual RET
instruction.

Entry points are those that either have UNWIND_HINT_ENTRY, which acts
as UNWIND_HINT_EMPTY but marks the instruction as an entry point, or
those that have UWIND_HINT_IRET_REGS at +0.

This is basically a variant of validate_branch() that is
intra-function and it will simply follow all branches from marked
entry points and ensures that all paths lead to ANNOTATE_UNRET_END.

If a path hits RET or an indirection the path is a fail and will be
reported.

There are 3 ANNOTATE_UNRET_END instances:

 - UNTRAIN_RET itself
 - exception from-kernel; this path doesn't need UNTRAIN_RET
 - all early exceptions; these also don't need UNTRAIN_RET

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: arch/x86/entry/entry_64.S no pt_regs return at .Lerror_entry_done_lfence]
[cascardo: tools/objtool/builtin-check.c no link option validation]
[cascardo: tools/objtool/check.c opts.ibt is ibt]
[cascardo: tools/objtool/include/objtool/builtin.h leave unret option as bool, no struct opts]
[cascardo: objtool is still called from scripts/link-vmlinux.sh]
[cascardo: no IBT support]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[bwh: Backported to 5.10:
 - In scripts/link-vmlinux.sh, use "test -n" instead of is_enabled
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S            |    3 
 arch/x86/entry/entry_64_compat.S     |    6 -
 arch/x86/include/asm/nospec-branch.h |   12 ++
 arch/x86/include/asm/unwind_hints.h  |    4 
 arch/x86/kernel/head_64.S            |    5 +
 arch/x86/xen/xen-asm.S               |   10 +-
 include/linux/objtool.h              |    3 
 scripts/link-vmlinux.sh              |    3 
 tools/include/linux/objtool.h        |    3 
 tools/objtool/builtin-check.c        |    3 
 tools/objtool/builtin.h              |    2 
 tools/objtool/check.c                |  172 ++++++++++++++++++++++++++++++++++-
 tools/objtool/check.h                |    6 +
 13 files changed, 217 insertions(+), 15 deletions(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -93,7 +93,7 @@ SYM_CODE_END(native_usergs_sysret64)
  */
 
 SYM_CODE_START(entry_SYSCALL_64)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_ENTRY
 
 	swapgs
 	/* tss.sp2 is scratch space. */
@@ -1094,6 +1094,7 @@ SYM_CODE_START_LOCAL(error_entry)
 	 */
 .Lerror_entry_done_lfence:
 	FENCE_SWAPGS_KERNEL_ENTRY
+	ANNOTATE_UNRET_END
 	RET
 
 .Lbstep_iret:
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -49,7 +49,7 @@
  * 0(%ebp) arg6
  */
 SYM_CODE_START(entry_SYSENTER_compat)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_ENTRY
 	/* Interrupts are off on entry. */
 	SWAPGS
 
@@ -202,7 +202,7 @@ SYM_CODE_END(entry_SYSENTER_compat)
  * 0(%esp) arg6
  */
 SYM_CODE_START(entry_SYSCALL_compat)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_ENTRY
 	/* Interrupts are off on entry. */
 	swapgs
 
@@ -349,7 +349,7 @@ SYM_CODE_END(entry_SYSCALL_compat)
  * ebp  arg6
  */
 SYM_CODE_START(entry_INT80_compat)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_ENTRY
 	/*
 	 * Interrupts are off on entry.
 	 */
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -82,6 +82,17 @@
 #define ANNOTATE_UNRET_SAFE ANNOTATE_RETPOLINE_SAFE
 
 /*
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
+/*
  * JMP_NOSPEC and CALL_NOSPEC macros can be used instead of a simple
  * indirect jmp/call which may be susceptible to the Spectre variant 2
  * attack.
@@ -131,6 +142,7 @@
  */
 .macro UNTRAIN_RET
 #ifdef CONFIG_RETPOLINE
+	ANNOTATE_UNRET_END
 	ALTERNATIVE_2 "",						\
 	              "call zen_untrain_ret", X86_FEATURE_UNRET,	\
 		      "call entry_ibpb", X86_FEATURE_ENTRY_IBPB
--- a/arch/x86/include/asm/unwind_hints.h
+++ b/arch/x86/include/asm/unwind_hints.h
@@ -11,6 +11,10 @@
 	UNWIND_HINT sp_reg=ORC_REG_UNDEFINED type=UNWIND_HINT_TYPE_CALL end=1
 .endm
 
+.macro UNWIND_HINT_ENTRY
+	UNWIND_HINT sp_reg=ORC_REG_UNDEFINED type=UNWIND_HINT_TYPE_ENTRY end=1
+.endm
+
 .macro UNWIND_HINT_REGS base=%rsp offset=0 indirect=0 extra=1 partial=0
 	.if \base == %rsp
 		.if \indirect
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -321,6 +321,8 @@ SYM_CODE_END(start_cpu0)
 SYM_CODE_START_NOALIGN(vc_boot_ghcb)
 	UNWIND_HINT_IRET_REGS offset=8
 
+	ANNOTATE_UNRET_END
+
 	/* Build pt_regs */
 	PUSH_AND_CLEAR_REGS
 
@@ -378,6 +380,7 @@ SYM_CODE_START(early_idt_handler_array)
 SYM_CODE_END(early_idt_handler_array)
 
 SYM_CODE_START_LOCAL(early_idt_handler_common)
+	ANNOTATE_UNRET_END
 	/*
 	 * The stack is the hardware frame, an error code or zero, and the
 	 * vector number.
@@ -424,6 +427,8 @@ SYM_CODE_END(early_idt_handler_common)
 SYM_CODE_START_NOALIGN(vc_no_ghcb)
 	UNWIND_HINT_IRET_REGS offset=8
 
+	ANNOTATE_UNRET_END
+
 	/* Build pt_regs */
 	PUSH_AND_CLEAR_REGS
 
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -148,7 +148,7 @@ SYM_FUNC_END(xen_read_cr2_direct);
 
 .macro xen_pv_trap name
 SYM_CODE_START(xen_\name)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_ENTRY
 	pop %rcx
 	pop %r11
 	jmp  \name
@@ -277,7 +277,7 @@ SYM_CODE_END(xenpv_restore_regs_and_retu
 
 /* Normal 64-bit system call target */
 SYM_CODE_START(xen_entry_SYSCALL_64)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_ENTRY
 	popq %rcx
 	popq %r11
 
@@ -296,7 +296,7 @@ SYM_CODE_END(xen_entry_SYSCALL_64)
 
 /* 32-bit compat syscall target */
 SYM_CODE_START(xen_entry_SYSCALL_compat)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_ENTRY
 	popq %rcx
 	popq %r11
 
@@ -313,7 +313,7 @@ SYM_CODE_END(xen_entry_SYSCALL_compat)
 
 /* 32-bit compat sysenter target */
 SYM_CODE_START(xen_entry_SYSENTER_compat)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_ENTRY
 	/*
 	 * NB: Xen is polite and clears TF from EFLAGS for us.  This means
 	 * that we don't need to guard against single step exceptions here.
@@ -336,7 +336,7 @@ SYM_CODE_END(xen_entry_SYSENTER_compat)
 
 SYM_CODE_START(xen_entry_SYSCALL_compat)
 SYM_CODE_START(xen_entry_SYSENTER_compat)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_ENTRY
 	lea 16(%rsp), %rsp	/* strip %rcx, %r11 */
 	mov $-ENOSYS, %rax
 	pushq $0
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -32,11 +32,14 @@ struct unwind_hint {
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
 
 #ifdef CONFIG_STACK_VALIDATION
 
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -65,6 +65,9 @@ objtool_link()
 
 	if [ -n "${CONFIG_VMLINUX_VALIDATION}" ]; then
 		objtoolopt="check"
+		if [ -n "${CONFIG_RETPOLINE}" ]; then
+			objtoolopt="${objtoolopt} --unret"
+		fi
 		if [ -z "${CONFIG_FRAME_POINTER}" ]; then
 			objtoolopt="${objtoolopt} --no-fp"
 		fi
--- a/tools/include/linux/objtool.h
+++ b/tools/include/linux/objtool.h
@@ -32,11 +32,14 @@ struct unwind_hint {
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
 
 #ifdef CONFIG_STACK_VALIDATION
 
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -19,7 +19,7 @@
 #include "objtool.h"
 
 bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats,
-     validate_dup, vmlinux, sls;
+     validate_dup, vmlinux, sls, unret;
 
 static const char * const check_usage[] = {
 	"objtool check [<options>] file.o",
@@ -30,6 +30,7 @@ const struct option check_options[] = {
 	OPT_BOOLEAN('f', "no-fp", &no_fp, "Skip frame pointer validation"),
 	OPT_BOOLEAN('u', "no-unreachable", &no_unreachable, "Skip 'unreachable instruction' warnings"),
 	OPT_BOOLEAN('r', "retpoline", &retpoline, "Validate retpoline assumptions"),
+	OPT_BOOLEAN(0,   "unret", &unret, "validate entry unret placement"),
 	OPT_BOOLEAN('m', "module", &module, "Indicates the object will be part of a kernel module"),
 	OPT_BOOLEAN('b', "backtrace", &backtrace, "unwind on error"),
 	OPT_BOOLEAN('a', "uaccess", &uaccess, "enable uaccess checking"),
--- a/tools/objtool/builtin.h
+++ b/tools/objtool/builtin.h
@@ -9,7 +9,7 @@
 
 extern const struct option check_options[];
 extern bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats,
-            validate_dup, vmlinux, sls;
+            validate_dup, vmlinux, sls, unret;
 
 extern int cmd_check(int argc, const char **argv);
 extern int cmd_orc(int argc, const char **argv);
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1752,6 +1752,19 @@ static int read_unwind_hints(struct objt
 
 		insn->hint = true;
 
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
 			insn->cfi = &func_cfi;
 			continue;
@@ -1800,8 +1813,9 @@ static int read_retpoline_hints(struct o
 
 		if (insn->type != INSN_JUMP_DYNAMIC &&
 		    insn->type != INSN_CALL_DYNAMIC &&
-		    insn->type != INSN_RETURN) {
-			WARN_FUNC("retpoline_safe hint not an indirect jump/call/ret",
+		    insn->type != INSN_RETURN &&
+		    insn->type != INSN_NOP) {
+			WARN_FUNC("retpoline_safe hint not an indirect jump/call/ret/nop",
 				  insn->sec, insn->offset);
 			return -1;
 		}
@@ -2818,8 +2832,8 @@ static int validate_branch(struct objtoo
 			return 1;
 		}
 
-		visited = 1 << state.uaccess;
-		if (insn->visited) {
+		visited = VISITED_BRANCH << state.uaccess;
+		if (insn->visited & VISITED_BRANCH_MASK) {
 			if (!insn->hint && !insn_cfi_match(insn, &state.cfi))
 				return 1;
 
@@ -3045,6 +3059,145 @@ static int validate_unwind_hints(struct
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
@@ -3312,6 +3465,17 @@ int check(struct objtool_file *file)
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
--- a/tools/objtool/check.h
+++ b/tools/objtool/check.h
@@ -48,6 +48,7 @@ struct instruction {
 	bool dead_end, ignore, ignore_alts;
 	bool hint;
 	bool retpoline_safe;
+	bool entry;
 	s8 instr;
 	u8 visited;
 	struct alt_group *alt_group;
@@ -62,6 +63,11 @@ struct instruction {
 	struct cfi_state *cfi;
 };
 
+#define VISITED_BRANCH		0x01
+#define VISITED_BRANCH_UACCESS	0x02
+#define VISITED_BRANCH_MASK	0x03
+#define VISITED_ENTRY		0x04
+
 static inline bool is_static_jump(struct instruction *insn)
 {
 	return insn->type == INSN_JUMP_CONDITIONAL ||


