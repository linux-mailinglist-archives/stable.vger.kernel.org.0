Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09984A4357
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358316AbiAaLVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47934 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377200AbiAaLRt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:17:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB5386114C;
        Mon, 31 Jan 2022 11:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54151C340E8;
        Mon, 31 Jan 2022 11:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627868;
        bh=+73rGfCBgLJesVwuPl33Zlp4csAarRXlaZuKTqeiMYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RnidJSWRhO5WRE/AvGaK8zgOd+3bfOTFlSq0jxiMGFckYydsR2CHY6TNCW42tkOFA
         oc/A8fK4WVl/h0ZrDD+Yvw0Q4qRM5GG55mjProDzAGcUHPHdFBnPfVAgCM0LP8hjUs
         YkB/SDGXVcBjwA2sXXI8nrXxj1IyuGIutBVJyA1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.16 023/200] powerpc/bpf: Update ldimm64 instructions during extra pass
Date:   Mon, 31 Jan 2022 11:54:46 +0100
Message-Id: <20220131105234.344489321@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit f9320c49993ca3c0ec0f9a7026b313735306bb8b upstream.

These instructions are updated after the initial JIT, so redo codegen
during the extra pass. Rename bpf_jit_fixup_subprog_calls() to clarify
that this is more than just subprog calls.

Fixes: 69c087ba6225b5 ("bpf: Add bpf_for_each_map_elem() helper")
Cc: stable@vger.kernel.org # v5.15
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/7cc162af77ba918eb3ecd26ec9e7824bc44b1fae.1641468127.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/net/bpf_jit_comp.c   |   29 +++++++++++++++++++++++------
 arch/powerpc/net/bpf_jit_comp32.c |    6 ++++++
 arch/powerpc/net/bpf_jit_comp64.c |    7 ++++++-
 3 files changed, 35 insertions(+), 7 deletions(-)

--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -23,15 +23,15 @@ static void bpf_jit_fill_ill_insns(void
 	memset32(area, BREAKPOINT_INSTRUCTION, size / 4);
 }
 
-/* Fix the branch target addresses for subprog calls */
-static int bpf_jit_fixup_subprog_calls(struct bpf_prog *fp, u32 *image,
-				       struct codegen_context *ctx, u32 *addrs)
+/* Fix updated addresses (for subprog calls, ldimm64, et al) during extra pass */
+static int bpf_jit_fixup_addresses(struct bpf_prog *fp, u32 *image,
+				   struct codegen_context *ctx, u32 *addrs)
 {
 	const struct bpf_insn *insn = fp->insnsi;
 	bool func_addr_fixed;
 	u64 func_addr;
 	u32 tmp_idx;
-	int i, ret;
+	int i, j, ret;
 
 	for (i = 0; i < fp->len; i++) {
 		/*
@@ -66,6 +66,23 @@ static int bpf_jit_fixup_subprog_calls(s
 			 * of the JITed sequence remains unchanged.
 			 */
 			ctx->idx = tmp_idx;
+		} else if (insn[i].code == (BPF_LD | BPF_IMM | BPF_DW)) {
+			tmp_idx = ctx->idx;
+			ctx->idx = addrs[i] / 4;
+#ifdef CONFIG_PPC32
+			PPC_LI32(ctx->b2p[insn[i].dst_reg] - 1, (u32)insn[i + 1].imm);
+			PPC_LI32(ctx->b2p[insn[i].dst_reg], (u32)insn[i].imm);
+			for (j = ctx->idx - addrs[i] / 4; j < 4; j++)
+				EMIT(PPC_RAW_NOP());
+#else
+			func_addr = ((u64)(u32)insn[i].imm) | (((u64)(u32)insn[i + 1].imm) << 32);
+			PPC_LI64(b2p[insn[i].dst_reg], func_addr);
+			/* overwrite rest with nops */
+			for (j = ctx->idx - addrs[i] / 4; j < 5; j++)
+				EMIT(PPC_RAW_NOP());
+#endif
+			ctx->idx = tmp_idx;
+			i++;
 		}
 	}
 
@@ -193,13 +210,13 @@ skip_init_ctx:
 		/*
 		 * Do not touch the prologue and epilogue as they will remain
 		 * unchanged. Only fix the branch target address for subprog
-		 * calls in the body.
+		 * calls in the body, and ldimm64 instructions.
 		 *
 		 * This does not change the offsets and lengths of the subprog
 		 * call instruction sequences and hence, the size of the JITed
 		 * image as well.
 		 */
-		bpf_jit_fixup_subprog_calls(fp, code_base, &cgctx, addrs);
+		bpf_jit_fixup_addresses(fp, code_base, &cgctx, addrs);
 
 		/* There is no need to perform the usual passes. */
 		goto skip_codegen_passes;
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -292,6 +292,8 @@ int bpf_jit_build_body(struct bpf_prog *
 		bool func_addr_fixed;
 		u64 func_addr;
 		u32 true_cond;
+		u32 tmp_idx;
+		int j;
 
 		/*
 		 * addrs[] maps a BPF bytecode address into a real offset from
@@ -839,8 +841,12 @@ int bpf_jit_build_body(struct bpf_prog *
 		 * 16 byte instruction that uses two 'struct bpf_insn'
 		 */
 		case BPF_LD | BPF_IMM | BPF_DW: /* dst = (u64) imm */
+			tmp_idx = ctx->idx;
 			PPC_LI32(dst_reg_h, (u32)insn[i + 1].imm);
 			PPC_LI32(dst_reg, (u32)insn[i].imm);
+			/* padding to allow full 4 instructions for later patching */
+			for (j = ctx->idx - tmp_idx; j < 4; j++)
+				EMIT(PPC_RAW_NOP());
 			/* Adjust for two bpf instructions */
 			addrs[++i] = ctx->idx * 4;
 			break;
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -318,6 +318,7 @@ int bpf_jit_build_body(struct bpf_prog *
 		u64 imm64;
 		u32 true_cond;
 		u32 tmp_idx;
+		int j;
 
 		/*
 		 * addrs[] maps a BPF bytecode address into a real offset from
@@ -806,9 +807,13 @@ emit_clear:
 		case BPF_LD | BPF_IMM | BPF_DW: /* dst = (u64) imm */
 			imm64 = ((u64)(u32) insn[i].imm) |
 				    (((u64)(u32) insn[i+1].imm) << 32);
+			tmp_idx = ctx->idx;
+			PPC_LI64(dst_reg, imm64);
+			/* padding to allow full 5 instructions for later patching */
+			for (j = ctx->idx - tmp_idx; j < 5; j++)
+				EMIT(PPC_RAW_NOP());
 			/* Adjust for two bpf instructions */
 			addrs[++i] = ctx->idx * 4;
-			PPC_LI64(dst_reg, imm64);
 			break;
 
 		/*


