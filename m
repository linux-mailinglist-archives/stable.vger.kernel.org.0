Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5266263742A
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 09:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiKXIiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 03:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiKXIhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 03:37:48 -0500
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD86427CED;
        Thu, 24 Nov 2022 00:37:44 -0800 (PST)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4NHrwQ1pCtz9shv;
        Thu, 24 Nov 2022 09:37:42 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id G6KG9rd6xw5r; Thu, 24 Nov 2022 09:37:42 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4NHrwQ0lSGz9shP;
        Thu, 24 Nov 2022 09:37:42 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 04F408B78B;
        Thu, 24 Nov 2022 09:37:42 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id k1nd9GEy5u-2; Thu, 24 Nov 2022 09:37:41 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [172.25.230.108])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id CA7908B763;
        Thu, 24 Nov 2022 09:37:41 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 2AO8bYAc3220875
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 09:37:35 +0100
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 2AO8bY4R3220874;
        Thu, 24 Nov 2022 09:37:34 +0100
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
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] powerpc/bpf/32: Fix Oops on tail call tests
Date:   Thu, 24 Nov 2022 09:37:27 +0100
Message-Id: <757acccb7fbfc78efa42dcf3c974b46678198905.1669278887.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1669279046; l=7402; s=20211009; h=from:subject:message-id; bh=YzdHtYIsX7vEzA4IEMpmiDsUpCiw/v9VxIjI3qTsVSs=; b=z34aTIrI9igWgams38omKQDk/w/FKhIvfN5lguWSpyehPRHuGJH2rpP+jN9fOZlSNQq5axP2i8z+ iNTCxbCxA/GLxX5AjyM1MtPiiItOLWevgRVPBTUPJGiUtaBk2qzH
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

Let's take a new approach. Use register r4 to carry the tail call count
during the tail call, and save it into the stack at function entry if
required. This means the input parameter must be in r3, which is more
correct as it is a 32 bits parameter, then tail call better match with
normal BPF function entry, the down side being that we move that input
parameter back and forth between r3 and r4. That can be optimised later.

Doing that also has the advantage of maximising the common parts between
tail calls and a normal function exit.

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

Suggested-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Fixes: 51c66ad849a7 ("powerpc/bpf: Implement extended BPF on PPC32")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
v2: Using r4 for tcc as suggested by Naveen.
---
 arch/powerpc/net/bpf_jit_comp32.c | 52 +++++++++++++------------------
 1 file changed, 21 insertions(+), 31 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index 43f1c76d48ce..a379b0ce19ff 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -113,23 +113,19 @@ void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx)
 {
 	int i;
 
-	/* First arg comes in as a 32 bits pointer. */
-	EMIT(PPC_RAW_MR(bpf_to_ppc(BPF_REG_1), _R3));
-	EMIT(PPC_RAW_LI(bpf_to_ppc(BPF_REG_1) - 1, 0));
+	/* Initialize tail_call_cnt, to be skipped if we do tail calls. */
+	EMIT(PPC_RAW_LI(_R4, 0));
+
+#define BPF_TAILCALL_PROLOGUE_SIZE	4
+
 	EMIT(PPC_RAW_STWU(_R1, _R1, -BPF_PPC_STACKFRAME(ctx)));
 
-	/*
-	 * Initialize tail_call_cnt in stack frame if we do tail calls.
-	 * Otherwise, put in NOPs so that it can be skipped when we are
-	 * invoked through a tail call.
-	 */
 	if (ctx->seen & SEEN_TAILCALL)
-		EMIT(PPC_RAW_STW(bpf_to_ppc(BPF_REG_1) - 1, _R1,
-				 bpf_jit_stack_offsetof(ctx, BPF_PPC_TC)));
-	else
-		EMIT(PPC_RAW_NOP());
+		EMIT(PPC_RAW_STW(_R4, _R1, bpf_jit_stack_offsetof(ctx, BPF_PPC_TC)));
 
-#define BPF_TAILCALL_PROLOGUE_SIZE	16
+	/* First arg comes in as a 32 bits pointer. */
+	EMIT(PPC_RAW_MR(bpf_to_ppc(BPF_REG_1), _R3));
+	EMIT(PPC_RAW_LI(bpf_to_ppc(BPF_REG_1) - 1, 0));
 
 	/*
 	 * We need a stack frame, but we don't necessarily need to
@@ -170,24 +166,24 @@ static void bpf_jit_emit_common_epilogue(u32 *image, struct codegen_context *ctx
 	for (i = BPF_PPC_NVR_MIN; i <= 31; i++)
 		if (bpf_is_seen_register(ctx, i))
 			EMIT(PPC_RAW_LWZ(i, _R1, bpf_jit_stack_offsetof(ctx, i)));
-}
-
-void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx)
-{
-	EMIT(PPC_RAW_MR(_R3, bpf_to_ppc(BPF_REG_0)));
-
-	bpf_jit_emit_common_epilogue(image, ctx);
-
-	/* Tear down our stack frame */
 
 	if (ctx->seen & SEEN_FUNC)
 		EMIT(PPC_RAW_LWZ(_R0, _R1, BPF_PPC_STACKFRAME(ctx) + PPC_LR_STKOFF));
 
+	/* Tear down our stack frame */
 	EMIT(PPC_RAW_ADDI(_R1, _R1, BPF_PPC_STACKFRAME(ctx)));
 
 	if (ctx->seen & SEEN_FUNC)
 		EMIT(PPC_RAW_MTLR(_R0));
 
+}
+
+void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx)
+{
+	EMIT(PPC_RAW_MR(_R3, bpf_to_ppc(BPF_REG_0)));
+
+	bpf_jit_emit_common_epilogue(image, ctx);
+
 	EMIT(PPC_RAW_BLR());
 }
 
@@ -244,7 +240,6 @@ static int bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 o
 	EMIT(PPC_RAW_RLWINM(_R3, b2p_index, 2, 0, 29));
 	EMIT(PPC_RAW_ADD(_R3, _R3, b2p_bpf_array));
 	EMIT(PPC_RAW_LWZ(_R3, _R3, offsetof(struct bpf_array, ptrs)));
-	EMIT(PPC_RAW_STW(_R0, _R1, bpf_jit_stack_offsetof(ctx, BPF_PPC_TC)));
 
 	/*
 	 * if (prog == NULL)
@@ -255,19 +250,14 @@ static int bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 o
 
 	/* goto *(prog->bpf_func + prologue_size); */
 	EMIT(PPC_RAW_LWZ(_R3, _R3, offsetof(struct bpf_prog, bpf_func)));
-
-	if (ctx->seen & SEEN_FUNC)
-		EMIT(PPC_RAW_LWZ(_R0, _R1, BPF_PPC_STACKFRAME(ctx) + PPC_LR_STKOFF));
-
 	EMIT(PPC_RAW_ADDIC(_R3, _R3, BPF_TAILCALL_PROLOGUE_SIZE));
-
-	if (ctx->seen & SEEN_FUNC)
-		EMIT(PPC_RAW_MTLR(_R0));
-
 	EMIT(PPC_RAW_MTCTR(_R3));
 
 	EMIT(PPC_RAW_MR(_R3, bpf_to_ppc(BPF_REG_1)));
 
+	/* Put tail_call_cnt in r4 */
+	EMIT(PPC_RAW_MR(_R4, _R0));
+
 	/* tear restore NVRs, ... */
 	bpf_jit_emit_common_epilogue(image, ctx);
 
-- 
2.38.1

