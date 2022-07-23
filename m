Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F268157EDFA
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238425AbiGWKFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238615AbiGWKEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:04:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F3511823;
        Sat, 23 Jul 2022 03:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F0D96116A;
        Sat, 23 Jul 2022 10:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51605C341C0;
        Sat, 23 Jul 2022 10:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570401;
        bh=GdgQnVw35ejBBdRQk4JC4U3Dhgfkk09O80TBVdJvkNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L12zXGNX9ITbahJibsY4+rUe42WvsjzqYPdBJAizi+CmGRGtpJeGHMMDHCFfb+QfK
         QR011PxMpmlhhaXOHimKvIJeP2Si5KKiSnNmHWkb2TaI5WfMJtH2UxzC5bZdvngzwh
         XLsKNLgU4Mn1tsscOrfEgBYhE635BqDLgE0QP7qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 084/148] x86: Undo return-thunk damage
Date:   Sat, 23 Jul 2022 11:54:56 +0200
Message-Id: <20220723095247.887292450@linuxfoundation.org>
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

commit 15e67227c49a57837108acfe1c80570e1bd9f962 upstream.

Introduce X86_FEATURE_RETHUNK for those afflicted with needing this.

  [ bp: Do only INT3 padding - simpler. ]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: CONFIG_STACK_VALIDATION vs CONFIG_OBJTOOL]
[cascardo: no IBT support]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/alternative.h       |    1 
 arch/x86/include/asm/cpufeatures.h       |    1 
 arch/x86/include/asm/disabled-features.h |    3 +
 arch/x86/kernel/alternative.c            |   60 +++++++++++++++++++++++++++++++
 arch/x86/kernel/module.c                 |    8 +++-
 arch/x86/kernel/vmlinux.lds.S            |    7 +++
 6 files changed, 78 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -76,6 +76,7 @@ extern int alternatives_patched;
 extern void alternative_instructions(void);
 extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
 extern void apply_retpolines(s32 *start, s32 *end);
+extern void apply_returns(s32 *start, s32 *end);
 
 struct module;
 
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -296,6 +296,7 @@
 /* FREE!				(11*32+11) */
 #define X86_FEATURE_RETPOLINE		(11*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
 #define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
+#define X86_FEATURE_RETHUNK		(11*32+14) /* "" Use REturn THUNK */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -60,7 +60,8 @@
 # define DISABLE_RETPOLINE	0
 #else
 # define DISABLE_RETPOLINE	((1 << (X86_FEATURE_RETPOLINE & 31)) | \
-				 (1 << (X86_FEATURE_RETPOLINE_LFENCE & 31)))
+				 (1 << (X86_FEATURE_RETPOLINE_LFENCE & 31)) | \
+				 (1 << (X86_FEATURE_RETHUNK & 31)))
 #endif
 
 /* Force disable because it's broken beyond repair */
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -270,6 +270,7 @@ static void __init_or_module add_nops(vo
 }
 
 extern s32 __retpoline_sites[], __retpoline_sites_end[];
+extern s32 __return_sites[], __return_sites_end[];
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern s32 __smp_locks[], __smp_locks_end[];
 void text_poke_early(void *addr, const void *opcode, size_t len);
@@ -661,9 +662,67 @@ void __init_or_module noinline apply_ret
 	}
 }
 
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
+		void *addr = (void *)s + *s;
+		struct insn insn;
+		int len, ret;
+		u8 bytes[16];
+		u8 op1;
+
+		ret = insn_decode_kernel(&insn, addr);
+		if (WARN_ON_ONCE(ret < 0))
+			continue;
+
+		op1 = insn.opcode.bytes[0];
+		if (WARN_ON_ONCE(op1 != JMP32_INSN_OPCODE))
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
 #else /* !RETPOLINES || !CONFIG_STACK_VALIDATION */
 
 void __init_or_module noinline apply_retpolines(s32 *start, s32 *end) { }
+void __init_or_module noinline apply_returns(s32 *start, s32 *end) { }
 
 #endif /* CONFIG_RETPOLINE && CONFIG_STACK_VALIDATION */
 
@@ -956,6 +1015,7 @@ void __init alternative_instructions(voi
 	 * those can rewrite the retpoline thunks.
 	 */
 	apply_retpolines(__retpoline_sites, __retpoline_sites_end);
+	apply_returns(__return_sites, __return_sites_end);
 
 	apply_alternatives(__alt_instructions, __alt_instructions_end);
 
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -252,7 +252,7 @@ int module_finalize(const Elf_Ehdr *hdr,
 {
 	const Elf_Shdr *s, *text = NULL, *alt = NULL, *locks = NULL,
 		*para = NULL, *orc = NULL, *orc_ip = NULL,
-		*retpolines = NULL;
+		*retpolines = NULL, *returns = NULL;
 	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
 
 	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
@@ -270,12 +270,18 @@ int module_finalize(const Elf_Ehdr *hdr,
 			orc_ip = s;
 		if (!strcmp(".retpoline_sites", secstrings + s->sh_name))
 			retpolines = s;
+		if (!strcmp(".return_sites", secstrings + s->sh_name))
+			returns = s;
 	}
 
 	if (retpolines) {
 		void *rseg = (void *)retpolines->sh_addr;
 		apply_retpolines(rseg, rseg + retpolines->sh_size);
 	}
+	if (returns) {
+		void *rseg = (void *)returns->sh_addr;
+		apply_returns(rseg, rseg + returns->sh_size);
+	}
 	if (alt) {
 		/* patch .altinstructions */
 		void *aseg = (void *)alt->sh_addr;
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -284,6 +284,13 @@ SECTIONS
 		*(.retpoline_sites)
 		__retpoline_sites_end = .;
 	}
+
+	. = ALIGN(8);
+	.return_sites : AT(ADDR(.return_sites) - LOAD_OFFSET) {
+		__return_sites = .;
+		*(.return_sites)
+		__return_sites_end = .;
+	}
 #endif
 
 	/*


