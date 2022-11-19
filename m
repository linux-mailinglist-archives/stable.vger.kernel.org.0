Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F3A63103C
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 19:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbiKSSVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Nov 2022 13:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbiKSSVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Nov 2022 13:21:22 -0500
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4680D13D43;
        Sat, 19 Nov 2022 10:21:19 -0800 (PST)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4NF2650XQDz9sZd;
        Sat, 19 Nov 2022 19:21:17 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9dP50iU9p0hz; Sat, 19 Nov 2022 19:21:16 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4NF26460kRz9sZY;
        Sat, 19 Nov 2022 19:21:16 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id AE2AD8B76C;
        Sat, 19 Nov 2022 19:21:16 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id ZSS9eVuynq4e; Sat, 19 Nov 2022 19:21:16 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.4.152])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5A5D48B763;
        Sat, 19 Nov 2022 19:21:16 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 2AJHJgAl2482924
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sat, 19 Nov 2022 18:19:42 +0100
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 2AJHJe3a2482922;
        Sat, 19 Nov 2022 18:19:40 +0100
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] powerpc/bpf/32: Fix Oops on tail call tests
Date:   Sat, 19 Nov 2022 18:19:35 +0100
Message-Id: <8a0b9f7e4fe208a8b518c0c4310472f99d9fdb55.1668876211.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1668878372; l=6038; s=20211009; h=from:subject:message-id; bh=yCeqy7mTPVbgcrSwBiCurTBvvyery5JpUQSfv916m3k=; b=5WQZbI9f+2gy/zQTO6eMU+RJE/pGup2cXIDkBb5INfBfxelfMRDe5qL5ixybklkhLpOa4D4VBlmw cbraNIixAUs5Nx580UioNSwkJxCM+JbWlo3vN5aHiJ5hWSbqRr1E
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

test_bpf tail call tests end up as:

  test_bpf: #0 Tail call leaf jited:1 85 PASS
  test_bpf: #1 Tail call 2 jited:1 111 PASS
  test_bpf: #2 Tail call 3 jited:1 145 PASS
  test_bpf: #3 Tail call 4 jited:1 170 PASS
  test_bpf: #4 Tail call load/store leaf jited:1 190 PASS
  test_bpf: #5 Tail call load/store jited:1
  BUG: Unable to handle kernel data access on write at 0xf1b4e000
  Faulting instruction address: 0xbe86b710
  Oops: Kernel access of bad area, sig: 11 [#1]
  BE PAGE_SIZE=4K MMU=Hash PowerMac
  Modules linked in: test_bpf(+)
  CPU: 0 PID: 97 Comm: insmod Not tainted 6.1.0-rc4+ #195
  Hardware name: PowerMac3,1 750CL 0x87210 PowerMac
  NIP:  be86b710 LR: be857e88 CTR: be86b704
  REGS: f1b4df20 TRAP: 0300   Not tainted  (6.1.0-rc4+)
  MSR:  00009032 <EE,ME,IR,DR,RI>  CR: 28008242  XER: 00000000
  DAR: f1b4e000 DSISR: 42000000
  GPR00: 00000001 f1b4dfe0 c11d2280 00000000 00000000 00000000 00000002 00000000
  GPR08: f1b4e000 be86b704 f1b4e000 00000000 00000000 100d816a f2440000 fe73baa8
  GPR16: f2458000 00000000 c1941ae4 f1fe2248 00000045 c0de0000 f2458030 00000000
  GPR24: 000003e8 0000000f f2458000 f1b4dc90 3e584b46 00000000 f24466a0 c1941a00
  NIP [be86b710] 0xbe86b710
  LR [be857e88] __run_one+0xec/0x264 [test_bpf]
  Call Trace:
  [f1b4dfe0] [00000002] 0x2 (unreliable)
  Instruction dump:
  XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
  XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
  ---[ end trace 0000000000000000 ]---

This is a tentative to write above the stack. The problem is encoutered
with tests added by commit 38608ee7b690 ("bpf, tests: Add load store
test case for tail call")

This happens because tail call is done to a BPF prog with a different
stack_depth. At the time being, the stack is kept as is when the caller
tail calls its callee. But at exit, the callee restores the stack based
on its own properties. Therefore here, at each run, r1 is erroneously
increased by 32 - 16 = 16 bytes.

This was done that way in order to pass the tail call count from caller
to callee through the stack. As powerpc32 doesn't have a red zone in
the stack, it was necessary the maintain the stack as is for the tail
call. But it was not anticipated that the BPF frame size could be
different.

Let's take a new approach. Use register r0 to carry the tail call count
during the tail call, and save it into the stack at function entry if
required. That's a deviation from the ppc32 ABI, but after all the way
tail calls are implemented is already not in accordance with the ABI.

With the fix, tail call tests are now successfull:

  test_bpf: #0 Tail call leaf jited:1 53 PASS
  test_bpf: #1 Tail call 2 jited:1 115 PASS
  test_bpf: #2 Tail call 3 jited:1 154 PASS
  test_bpf: #3 Tail call 4 jited:1 165 PASS
  test_bpf: #4 Tail call load/store leaf jited:1 101 PASS
  test_bpf: #5 Tail call load/store jited:1 141 PASS
  test_bpf: #6 Tail call error path, max count reached jited:1 994 PASS
  test_bpf: #7 Tail call count preserved across function calls jited:1 140975 PASS
  test_bpf: #8 Tail call error path, NULL target jited:1 110 PASS
  test_bpf: #9 Tail call error path, index out of range jited:1 69 PASS
  test_bpf: test_tail_calls: Summary: 10 PASSED, 0 FAILED, [10/10 JIT'ed]

Fixes: 51c66ad849a7 ("powerpc/bpf: Implement extended BPF on PPC32")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/net/bpf_jit_comp32.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index 43f1c76d48ce..97e75b8181ca 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -115,21 +115,19 @@ void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx)
 
 	/* First arg comes in as a 32 bits pointer. */
 	EMIT(PPC_RAW_MR(bpf_to_ppc(BPF_REG_1), _R3));
-	EMIT(PPC_RAW_LI(bpf_to_ppc(BPF_REG_1) - 1, 0));
+	EMIT(PPC_RAW_LI(_R0, 0));
+
+#define BPF_TAILCALL_PROLOGUE_SIZE	8
+
 	EMIT(PPC_RAW_STWU(_R1, _R1, -BPF_PPC_STACKFRAME(ctx)));
 
 	/*
-	 * Initialize tail_call_cnt in stack frame if we do tail calls.
-	 * Otherwise, put in NOPs so that it can be skipped when we are
-	 * invoked through a tail call.
+	 * Save tail_call_cnt in stack frame if we do tail calls.
 	 */
 	if (ctx->seen & SEEN_TAILCALL)
-		EMIT(PPC_RAW_STW(bpf_to_ppc(BPF_REG_1) - 1, _R1,
-				 bpf_jit_stack_offsetof(ctx, BPF_PPC_TC)));
-	else
-		EMIT(PPC_RAW_NOP());
+		EMIT(PPC_RAW_STW(_R0, _R1, bpf_jit_stack_offsetof(ctx, BPF_PPC_TC)));
 
-#define BPF_TAILCALL_PROLOGUE_SIZE	16
+	EMIT(PPC_RAW_LI(bpf_to_ppc(BPF_REG_1) - 1, 0));
 
 	/*
 	 * We need a stack frame, but we don't necessarily need to
@@ -244,7 +242,6 @@ static int bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 o
 	EMIT(PPC_RAW_RLWINM(_R3, b2p_index, 2, 0, 29));
 	EMIT(PPC_RAW_ADD(_R3, _R3, b2p_bpf_array));
 	EMIT(PPC_RAW_LWZ(_R3, _R3, offsetof(struct bpf_array, ptrs)));
-	EMIT(PPC_RAW_STW(_R0, _R1, bpf_jit_stack_offsetof(ctx, BPF_PPC_TC)));
 
 	/*
 	 * if (prog == NULL)
@@ -257,20 +254,20 @@ static int bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 o
 	EMIT(PPC_RAW_LWZ(_R3, _R3, offsetof(struct bpf_prog, bpf_func)));
 
 	if (ctx->seen & SEEN_FUNC)
-		EMIT(PPC_RAW_LWZ(_R0, _R1, BPF_PPC_STACKFRAME(ctx) + PPC_LR_STKOFF));
+		EMIT(PPC_RAW_LWZ(_R5, _R1, BPF_PPC_STACKFRAME(ctx) + PPC_LR_STKOFF));
 
 	EMIT(PPC_RAW_ADDIC(_R3, _R3, BPF_TAILCALL_PROLOGUE_SIZE));
 
 	if (ctx->seen & SEEN_FUNC)
-		EMIT(PPC_RAW_MTLR(_R0));
+		EMIT(PPC_RAW_MTLR(_R5));
 
 	EMIT(PPC_RAW_MTCTR(_R3));
 
-	EMIT(PPC_RAW_MR(_R3, bpf_to_ppc(BPF_REG_1)));
-
 	/* tear restore NVRs, ... */
 	bpf_jit_emit_common_epilogue(image, ctx);
 
+	EMIT(PPC_RAW_ADDI(_R1, _R1, BPF_PPC_STACKFRAME(ctx)));
+
 	EMIT(PPC_RAW_BCTR());
 
 	/* out: */
-- 
2.38.1

