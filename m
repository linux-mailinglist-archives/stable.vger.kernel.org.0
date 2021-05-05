Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA84373A88
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbhEEMLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:11:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233093AbhEEMKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:10:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 517E2613D8;
        Wed,  5 May 2021 12:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216545;
        bh=XqLgv7r2dMQRYl1KkcoVkyeiy148TjiJxkdsvbhjVa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m0LCqn151Rn+pcuxIV7+Ynvg+GM9Gxi47KjN4JoERuHqMPdcayzIANa2XwxrjX8k5
         QBHk3iiVdtg/qDIQrYyJ68yNxLgDC6fa1oqw6bV3MlwpZb6l843zfKXACNwHKchjG8
         eBxvOTOBfPvPhDpJJzRrThTsgK8noSXwajKqbR68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Krysiuk <piotras@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.11 07/31] bpf: Fix leakage of uninitialized bpf stack under speculation
Date:   Wed,  5 May 2021 14:05:56 +0200
Message-Id: <20210505112326.908699621@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112326.672439569@linuxfoundation.org>
References: <20210505112326.672439569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 801c6058d14a82179a7ee17a4b532cac6fad067f upstream.

The current implemented mechanisms to mitigate data disclosure under
speculation mainly address stack and map value oob access from the
speculative domain. However, Piotr discovered that uninitialized BPF
stack is not protected yet, and thus old data from the kernel stack,
potentially including addresses of kernel structures, could still be
extracted from that 512 bytes large window. The BPF stack is special
compared to map values since it's not zero initialized for every
program invocation, whereas map values /are/ zero initialized upon
their initial allocation and thus cannot leak any prior data in either
domain. In the non-speculative domain, the verifier ensures that every
stack slot read must have a prior stack slot write by the BPF program
to avoid such data leaking issue.

However, this is not enough: for example, when the pointer arithmetic
operation moves the stack pointer from the last valid stack offset to
the first valid offset, the sanitation logic allows for any intermediate
offsets during speculative execution, which could then be used to
extract any restricted stack content via side-channel.

Given for unprivileged stack pointer arithmetic the use of unknown
but bounded scalars is generally forbidden, we can simply turn the
register-based arithmetic operation into an immediate-based arithmetic
operation without the need for masking. This also gives the benefit
of reducing the needed instructions for the operation. Given after
the work in 7fedb63a8307 ("bpf: Tighten speculative pointer arithmetic
mask"), the aux->alu_limit already holds the final immediate value for
the offset register with the known scalar. Thus, a simple mov of the
immediate to AX register with using AX as the source for the original
instruction is sufficient and possible now in this case.

Reported-by: Piotr Krysiuk <piotras@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Piotr Krysiuk <piotras@gmail.com>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf_verifier.h |    5 +++--
 kernel/bpf/verifier.c        |   27 +++++++++++++++++----------
 2 files changed, 20 insertions(+), 12 deletions(-)

--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -299,10 +299,11 @@ struct bpf_verifier_state_list {
 };
 
 /* Possible states for alu_state member. */
-#define BPF_ALU_SANITIZE_SRC		1U
-#define BPF_ALU_SANITIZE_DST		2U
+#define BPF_ALU_SANITIZE_SRC		(1U << 0)
+#define BPF_ALU_SANITIZE_DST		(1U << 1)
 #define BPF_ALU_NEG_VALUE		(1U << 2)
 #define BPF_ALU_NON_POINTER		(1U << 3)
+#define BPF_ALU_IMMEDIATE		(1U << 4)
 #define BPF_ALU_SANITIZE		(BPF_ALU_SANITIZE_SRC | \
 					 BPF_ALU_SANITIZE_DST)
 
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5810,6 +5810,7 @@ static int sanitize_ptr_alu(struct bpf_v
 {
 	struct bpf_insn_aux_data *aux = commit_window ? cur_aux(env) : tmp_aux;
 	struct bpf_verifier_state *vstate = env->cur_state;
+	bool off_is_imm = tnum_is_const(off_reg->var_off);
 	bool off_is_neg = off_reg->smin_value < 0;
 	bool ptr_is_dst_reg = ptr_reg == dst_reg;
 	u8 opcode = BPF_OP(insn->code);
@@ -5840,6 +5841,7 @@ static int sanitize_ptr_alu(struct bpf_v
 		alu_limit = abs(tmp_aux->alu_limit - alu_limit);
 	} else {
 		alu_state  = off_is_neg ? BPF_ALU_NEG_VALUE : 0;
+		alu_state |= off_is_imm ? BPF_ALU_IMMEDIATE : 0;
 		alu_state |= ptr_is_dst_reg ?
 			     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
 	}
@@ -11523,7 +11525,7 @@ static int fixup_bpf_calls(struct bpf_ve
 			const u8 code_sub = BPF_ALU64 | BPF_SUB | BPF_X;
 			struct bpf_insn insn_buf[16];
 			struct bpf_insn *patch = &insn_buf[0];
-			bool issrc, isneg;
+			bool issrc, isneg, isimm;
 			u32 off_reg;
 
 			aux = &env->insn_aux_data[i + delta];
@@ -11534,16 +11536,21 @@ static int fixup_bpf_calls(struct bpf_ve
 			isneg = aux->alu_state & BPF_ALU_NEG_VALUE;
 			issrc = (aux->alu_state & BPF_ALU_SANITIZE) ==
 				BPF_ALU_SANITIZE_SRC;
+			isimm = aux->alu_state & BPF_ALU_IMMEDIATE;
 
 			off_reg = issrc ? insn->src_reg : insn->dst_reg;
-			if (isneg)
-				*patch++ = BPF_ALU64_IMM(BPF_MUL, off_reg, -1);
-			*patch++ = BPF_MOV32_IMM(BPF_REG_AX, aux->alu_limit);
-			*patch++ = BPF_ALU64_REG(BPF_SUB, BPF_REG_AX, off_reg);
-			*patch++ = BPF_ALU64_REG(BPF_OR, BPF_REG_AX, off_reg);
-			*patch++ = BPF_ALU64_IMM(BPF_NEG, BPF_REG_AX, 0);
-			*patch++ = BPF_ALU64_IMM(BPF_ARSH, BPF_REG_AX, 63);
-			*patch++ = BPF_ALU64_REG(BPF_AND, BPF_REG_AX, off_reg);
+			if (isimm) {
+				*patch++ = BPF_MOV32_IMM(BPF_REG_AX, aux->alu_limit);
+			} else {
+				if (isneg)
+					*patch++ = BPF_ALU64_IMM(BPF_MUL, off_reg, -1);
+				*patch++ = BPF_MOV32_IMM(BPF_REG_AX, aux->alu_limit);
+				*patch++ = BPF_ALU64_REG(BPF_SUB, BPF_REG_AX, off_reg);
+				*patch++ = BPF_ALU64_REG(BPF_OR, BPF_REG_AX, off_reg);
+				*patch++ = BPF_ALU64_IMM(BPF_NEG, BPF_REG_AX, 0);
+				*patch++ = BPF_ALU64_IMM(BPF_ARSH, BPF_REG_AX, 63);
+				*patch++ = BPF_ALU64_REG(BPF_AND, BPF_REG_AX, off_reg);
+			}
 			if (!issrc)
 				*patch++ = BPF_MOV64_REG(insn->dst_reg, insn->src_reg);
 			insn->src_reg = BPF_REG_AX;
@@ -11551,7 +11558,7 @@ static int fixup_bpf_calls(struct bpf_ve
 				insn->code = insn->code == code_add ?
 					     code_sub : code_add;
 			*patch++ = *insn;
-			if (issrc && isneg)
+			if (issrc && isneg && !isimm)
 				*patch++ = BPF_ALU64_IMM(BPF_MUL, off_reg, -1);
 			cnt = patch - insn_buf;
 


