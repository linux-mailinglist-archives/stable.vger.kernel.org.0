Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D8C572373
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234453AbiGLSru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234201AbiGLSrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:47:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE972DD215;
        Tue, 12 Jul 2022 11:43:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA18A61ACE;
        Tue, 12 Jul 2022 18:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DD0C3411E;
        Tue, 12 Jul 2022 18:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651386;
        bh=nJKapeQMlrIeJZpFilw2PfRWT6K3ylI1DSqHQel0aj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cx5/SE7tjdNu5Aa42uWcdyzaDKx6WQqCq42q8rio5X2CF+vEthH/77NnCw+tbAIIY
         85O1F7mw0vcn0k9tbVQ3vOP8BQnchOAhbqswIshaLkjjHLGDsmCQR033pO5hrw+Mg9
         wNR1fdUG7uqXdY2BOuXC0z23/hbWYS05oQSCA3Ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 060/130] bpf,x86: Respect X86_FEATURE_RETPOLINE*
Date:   Tue, 12 Jul 2022 20:38:26 +0200
Message-Id: <20220712183249.225968839@linuxfoundation.org>
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

commit 87c87ecd00c54ecd677798cb49ef27329e0fab41 upstream.

Current BPF codegen doesn't respect X86_FEATURE_RETPOLINE* flags and
unconditionally emits a thunk call, this is sub-optimal and doesn't
match the regular, compiler generated, code.

Update the i386 JIT to emit code equal to what the compiler emits for
the regular kernel text (IOW. a plain THUNK call).

Update the x86_64 JIT to emit code similar to the result of compiler
and kernel rewrites as according to X86_FEATURE_RETPOLINE* flags.
Inlining RETPOLINE_AMD (lfence; jmp *%reg) and !RETPOLINE (jmp *%reg),
while doing a THUNK call for RETPOLINE.

This removes the hard-coded retpoline thunks and shrinks the generated
code. Leaving a single retpoline thunk definition in the kernel.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/r/20211026120310.614772675@infradead.org
[cascardo: RETPOLINE_AMD was renamed to RETPOLINE_LFENCE]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[bwh: Backported to 5.10: add the necessary cnt variable to
 emit_indirect_jump()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |   59 -----------------------------------
 arch/x86/net/bpf_jit_comp.c          |   49 +++++++++++++----------------
 arch/x86/net/bpf_jit_comp32.c        |   22 +++++++++++--
 3 files changed, 42 insertions(+), 88 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -318,63 +318,4 @@ static inline void mds_idle_clear_cpu_bu
 
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
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -379,6 +379,26 @@ int bpf_arch_text_poke(void *ip, enum bp
 	return __bpf_arch_text_poke(ip, t, old_addr, new_addr, true);
 }
 
+#define EMIT_LFENCE()	EMIT3(0x0F, 0xAE, 0xE8)
+
+static void emit_indirect_jump(u8 **pprog, int reg, u8 *ip)
+{
+	u8 *prog = *pprog;
+	int cnt = 0;
+
+#ifdef CONFIG_RETPOLINE
+	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE)) {
+		EMIT_LFENCE();
+		EMIT2(0xFF, 0xE0 + reg);
+	} else if (cpu_feature_enabled(X86_FEATURE_RETPOLINE)) {
+		emit_jump(&prog, &__x86_indirect_thunk_array[reg], ip);
+	} else
+#endif
+	EMIT2(0xFF, 0xE0 + reg);
+
+	*pprog = prog;
+}
+
 /*
  * Generate the following code:
  *
@@ -460,7 +480,7 @@ static void emit_bpf_tail_call_indirect(
 	 * rdi == ctx (1st arg)
 	 * rcx == prog->bpf_func + X86_TAIL_CALL_OFFSET
 	 */
-	RETPOLINE_RCX_BPF_JIT();
+	emit_indirect_jump(&prog, 1 /* rcx */, ip + (prog - start));
 
 	/* out: */
 	ctx->tail_call_indirect_label = prog - start;
@@ -1099,8 +1119,7 @@ static int do_jit(struct bpf_prog *bpf_p
 			/* speculation barrier */
 		case BPF_ST | BPF_NOSPEC:
 			if (boot_cpu_has(X86_FEATURE_XMM2))
-				/* Emit 'lfence' */
-				EMIT3(0x0F, 0xAE, 0xE8);
+				EMIT_LFENCE();
 			break;
 
 			/* ST: *(u8*)(dst_reg + off) = imm */
@@ -1878,26 +1897,6 @@ cleanup:
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
-	int cnt = 0;
-
-	EMIT2(0xFF, 0xE2);	/* jmp rdx */
-#endif
-	*pprog = prog;
-	return err;
-}
-
 static int emit_bpf_dispatcher(u8 **pprog, int a, int b, s64 *progs)
 {
 	u8 *jg_reloc, *prog = *pprog;
@@ -1919,9 +1918,7 @@ static int emit_bpf_dispatcher(u8 **ppro
 		if (err)
 			return err;
 
-		err = emit_fallback_jump(&prog);	/* jmp thunk/indirect */
-		if (err)
-			return err;
+		emit_indirect_jump(&prog, 2 /* rdx */, prog);
 
 		*pprog = prog;
 		return 0;
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -15,6 +15,7 @@
 #include <asm/cacheflush.h>
 #include <asm/set_memory.h>
 #include <asm/nospec-branch.h>
+#include <asm/asm-prototypes.h>
 #include <linux/bpf.h>
 
 /*
@@ -1267,6 +1268,21 @@ static void emit_epilogue(u8 **pprog, u3
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
@@ -1280,7 +1296,7 @@ static void emit_epilogue(u8 **pprog, u3
  *   goto *(prog->bpf_func + prologue_size);
  * out:
  */
-static void emit_bpf_tail_call(u8 **pprog)
+static void emit_bpf_tail_call(u8 **pprog, u8 *ip)
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
@@ -1362,7 +1378,7 @@ static void emit_bpf_tail_call(u8 **ppro
 	 * eax == ctx (1st arg)
 	 * edx == prog->bpf_func + prologue_size
 	 */
-	RETPOLINE_EDX_BPF_JIT();
+	cnt += emit_jmp_edx(&prog, ip + cnt);
 
 	if (jmp_label1 == -1)
 		jmp_label1 = cnt;
@@ -1929,7 +1945,7 @@ static int do_jit(struct bpf_prog *bpf_p
 			break;
 		}
 		case BPF_JMP | BPF_TAIL_CALL:
-			emit_bpf_tail_call(&prog);
+			emit_bpf_tail_call(&prog, image + addrs[i - 1]);
 			break;
 
 		/* cond jump */


