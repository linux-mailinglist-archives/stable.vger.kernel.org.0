Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4467E572308
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiGLSnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbiGLSm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:42:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D3FD6CD6;
        Tue, 12 Jul 2022 11:41:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 710BA6186E;
        Tue, 12 Jul 2022 18:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D133C3411E;
        Tue, 12 Jul 2022 18:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651300;
        bh=E7rbmcrV7XwUzajBPQnJcFe7GQ/LEzE1EoPxgXcQPSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ykA2mUkwDS9+G1O+v4oWyWh4RC1DOzNjNHcf6FUS2Jm1wRhYyKSwzHVcRIveMBW1d
         NaBAhjqzcTrFspUqGLOK7Sb4FaeCRJxEtIKwdwYx70UynlYKN4heaIbGhrvk3Lk/4l
         DmFJgRHioweN2+Ni+HO7dqVeXbCeTO+0/UszGAsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 034/130] objtool/x86: Rewrite retpoline thunk calls
Date:   Tue, 12 Jul 2022 20:38:00 +0200
Message-Id: <20220712183247.970930676@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 9bc0bb50727c8ac69fbb33fb937431cf3518ff37 upstream.

When the compiler emits: "CALL __x86_indirect_thunk_\reg" for an
indirect call, have objtool rewrite it to:

	ALTERNATIVE "call __x86_indirect_thunk_\reg",
		    "call *%reg", ALT_NOT(X86_FEATURE_RETPOLINE)

Additionally, in order to not emit endless identical
.altinst_replacement chunks, use a global symbol for them, see
__x86_indirect_alt_*.

This also avoids objtool from having to do code generation.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Link: https://lkml.kernel.org/r/20210326151300.320177914@infradead.org
[bwh: Backported to 5.10: include "arch_elf.h" instead of "arch/elf.h"]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/asm-prototypes.h |   12 ++-
 arch/x86/lib/retpoline.S              |   41 +++++++++++
 tools/objtool/arch/x86/decode.c       |  117 ++++++++++++++++++++++++++++++++++
 3 files changed, 167 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/asm-prototypes.h
+++ b/arch/x86/include/asm/asm-prototypes.h
@@ -19,11 +19,19 @@ extern void cmpxchg8b_emu(void);
 
 #ifdef CONFIG_RETPOLINE
 
-#define DECL_INDIRECT_THUNK(reg) \
+#undef GEN
+#define GEN(reg) \
 	extern asmlinkage void __x86_indirect_thunk_ ## reg (void);
+#include <asm/GEN-for-each-reg.h>
+
+#undef GEN
+#define GEN(reg) \
+	extern asmlinkage void __x86_indirect_alt_call_ ## reg (void);
+#include <asm/GEN-for-each-reg.h>
 
 #undef GEN
-#define GEN(reg) DECL_INDIRECT_THUNK(reg)
+#define GEN(reg) \
+	extern asmlinkage void __x86_indirect_alt_jmp_ ## reg (void);
 #include <asm/GEN-for-each-reg.h>
 
 #endif /* CONFIG_RETPOLINE */
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -10,6 +10,8 @@
 #include <asm/unwind_hints.h>
 #include <asm/frame.h>
 
+	.section .text.__x86.indirect_thunk
+
 .macro RETPOLINE reg
 	ANNOTATE_INTRA_FUNCTION_CALL
 	call    .Ldo_rop_\@
@@ -25,9 +27,9 @@
 .endm
 
 .macro THUNK reg
-	.section .text.__x86.indirect_thunk
 
 	.align 32
+
 SYM_FUNC_START(__x86_indirect_thunk_\reg)
 
 	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), \
@@ -39,6 +41,32 @@ SYM_FUNC_END(__x86_indirect_thunk_\reg)
 .endm
 
 /*
+ * This generates .altinstr_replacement symbols for use by objtool. They,
+ * however, must not actually live in .altinstr_replacement since that will be
+ * discarded after init, but module alternatives will also reference these
+ * symbols.
+ *
+ * Their names matches the "__x86_indirect_" prefix to mark them as retpolines.
+ */
+.macro ALT_THUNK reg
+
+	.align 1
+
+SYM_FUNC_START_NOALIGN(__x86_indirect_alt_call_\reg)
+	ANNOTATE_RETPOLINE_SAFE
+1:	call	*%\reg
+2:	.skip	5-(2b-1b), 0x90
+SYM_FUNC_END(__x86_indirect_alt_call_\reg)
+
+SYM_FUNC_START_NOALIGN(__x86_indirect_alt_jmp_\reg)
+	ANNOTATE_RETPOLINE_SAFE
+1:	jmp	*%\reg
+2:	.skip	5-(2b-1b), 0x90
+SYM_FUNC_END(__x86_indirect_alt_jmp_\reg)
+
+.endm
+
+/*
  * Despite being an assembler file we can't just use .irp here
  * because __KSYM_DEPS__ only uses the C preprocessor and would
  * only see one instance of "__x86_indirect_thunk_\reg" rather
@@ -61,3 +89,14 @@ SYM_FUNC_END(__x86_indirect_thunk_\reg)
 #define GEN(reg) EXPORT_THUNK(reg)
 #include <asm/GEN-for-each-reg.h>
 
+#undef GEN
+#define GEN(reg) ALT_THUNK reg
+#include <asm/GEN-for-each-reg.h>
+
+#undef GEN
+#define GEN(reg) __EXPORT_THUNK(__x86_indirect_alt_call_ ## reg)
+#include <asm/GEN-for-each-reg.h>
+
+#undef GEN
+#define GEN(reg) __EXPORT_THUNK(__x86_indirect_alt_jmp_ ## reg)
+#include <asm/GEN-for-each-reg.h>
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -16,6 +16,7 @@
 #include "../../arch.h"
 #include "../../warn.h"
 #include <asm/orc_types.h>
+#include "arch_elf.h"
 
 static unsigned char op_to_cfi_reg[][2] = {
 	{CFI_AX, CFI_R8},
@@ -585,6 +586,122 @@ const char *arch_nop_insn(int len)
 	return nops[len-1];
 }
 
+/* asm/alternative.h ? */
+
+#define ALTINSTR_FLAG_INV	(1 << 15)
+#define ALT_NOT(feat)		((feat) | ALTINSTR_FLAG_INV)
+
+struct alt_instr {
+	s32 instr_offset;	/* original instruction */
+	s32 repl_offset;	/* offset to replacement instruction */
+	u16 cpuid;		/* cpuid bit set for replacement */
+	u8  instrlen;		/* length of original instruction */
+	u8  replacementlen;	/* length of new instruction */
+} __packed;
+
+static int elf_add_alternative(struct elf *elf,
+			       struct instruction *orig, struct symbol *sym,
+			       int cpuid, u8 orig_len, u8 repl_len)
+{
+	const int size = sizeof(struct alt_instr);
+	struct alt_instr *alt;
+	struct section *sec;
+	Elf_Scn *s;
+
+	sec = find_section_by_name(elf, ".altinstructions");
+	if (!sec) {
+		sec = elf_create_section(elf, ".altinstructions",
+					 SHF_WRITE, size, 0);
+
+		if (!sec) {
+			WARN_ELF("elf_create_section");
+			return -1;
+		}
+	}
+
+	s = elf_getscn(elf->elf, sec->idx);
+	if (!s) {
+		WARN_ELF("elf_getscn");
+		return -1;
+	}
+
+	sec->data = elf_newdata(s);
+	if (!sec->data) {
+		WARN_ELF("elf_newdata");
+		return -1;
+	}
+
+	sec->data->d_size = size;
+	sec->data->d_align = 1;
+
+	alt = sec->data->d_buf = malloc(size);
+	if (!sec->data->d_buf) {
+		perror("malloc");
+		return -1;
+	}
+	memset(sec->data->d_buf, 0, size);
+
+	if (elf_add_reloc_to_insn(elf, sec, sec->sh.sh_size,
+				  R_X86_64_PC32, orig->sec, orig->offset)) {
+		WARN("elf_create_reloc: alt_instr::instr_offset");
+		return -1;
+	}
+
+	if (elf_add_reloc(elf, sec, sec->sh.sh_size + 4,
+			  R_X86_64_PC32, sym, 0)) {
+		WARN("elf_create_reloc: alt_instr::repl_offset");
+		return -1;
+	}
+
+	alt->cpuid = cpuid;
+	alt->instrlen = orig_len;
+	alt->replacementlen = repl_len;
+
+	sec->sh.sh_size += size;
+	sec->changed = true;
+
+	return 0;
+}
+
+#define X86_FEATURE_RETPOLINE                ( 7*32+12)
+
+int arch_rewrite_retpolines(struct objtool_file *file)
+{
+	struct instruction *insn;
+	struct reloc *reloc;
+	struct symbol *sym;
+	char name[32] = "";
+
+	list_for_each_entry(insn, &file->retpoline_call_list, call_node) {
+
+		if (!strcmp(insn->sec->name, ".text.__x86.indirect_thunk"))
+			continue;
+
+		reloc = insn->reloc;
+
+		sprintf(name, "__x86_indirect_alt_%s_%s",
+			insn->type == INSN_JUMP_DYNAMIC ? "jmp" : "call",
+			reloc->sym->name + 21);
+
+		sym = find_symbol_by_name(file->elf, name);
+		if (!sym) {
+			sym = elf_create_undef_symbol(file->elf, name);
+			if (!sym) {
+				WARN("elf_create_undef_symbol");
+				return -1;
+			}
+		}
+
+		if (elf_add_alternative(file->elf, insn, sym,
+					ALT_NOT(X86_FEATURE_RETPOLINE), 5, 5)) {
+			WARN("elf_add_alternative");
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
 int arch_decode_hint_reg(struct instruction *insn, u8 sp_reg)
 {
 	struct cfi_reg *cfa = &insn->cfi.cfa;


