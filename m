Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316CC3967E7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 20:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhEaS2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 14:28:06 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:12136 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbhEaS1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 14:27:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622485563; x=1654021563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MzqcICHfYp+BmFkGXG3Fb9jklj0rxf3wKxKksvBVNzs=;
  b=EVRfTfmgv6Ot9DYV1mlU0l/rHESTvGIK7JqzwvuytzwopnR8zmg5CkZt
   MmE9pu2iR30frUFABgAky9d6ZX4ye7TztTyQ7V0sxuM00RhAnMo0bIwHM
   GB2ftsCLLR7n8m21TlpDuXvMnVPF8QazFT19juvdVF8FvuTu/3db+r0OJ
   I=;
X-IronPort-AV: E=Sophos;i="5.83,238,1616457600"; 
   d="scan'208";a="115653033"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 31 May 2021 18:26:00 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id F2426A1D52;
        Mon, 31 May 2021 18:25:59 +0000 (UTC)
Received: from EX13D04UEB001.ant.amazon.com (10.43.60.125) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.96) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:58 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D04UEB001.ant.amazon.com (10.43.60.125) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:58 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.18 via Frontend Transport; Mon, 31 May 2021 18:25:58
 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 91BA0149B; Mon, 31 May 2021 18:25:57 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <daniel@iogearbox.net>
Subject: [PATCH v2 4.14 14/17] bpf: Fix leakage of uninitialized bpf stack under speculation
Date:   Mon, 31 May 2021 18:25:53 +0000
Message-ID: <20210531182556.25277-15-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210531182556.25277-1-fllinden@amazon.com>
References: <20210531182556.25277-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
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
[fllinden@amazon.com: fixed minor 4.14 conflict because of renamed function]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
---
 include/linux/bpf_verifier.h |  5 +++--
 kernel/bpf/verifier.c        | 27 +++++++++++++++++----------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index d8b3240cfe6e..8509484cada4 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -114,10 +114,11 @@ struct bpf_verifier_state_list {
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
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5c440398e0a1..84779fe35ebc 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2120,6 +2120,7 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 {
 	struct bpf_insn_aux_data *aux = commit_window ? cur_aux(env) : tmp_aux;
 	struct bpf_verifier_state *vstate = env->cur_state;
+	bool off_is_imm = tnum_is_const(off_reg->var_off);
 	bool off_is_neg = off_reg->smin_value < 0;
 	bool ptr_is_dst_reg = ptr_reg == dst_reg;
 	u8 opcode = BPF_OP(insn->code);
@@ -2150,6 +2151,7 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 		alu_limit = abs(tmp_aux->alu_limit - alu_limit);
 	} else {
 		alu_state  = off_is_neg ? BPF_ALU_NEG_VALUE : 0;
+		alu_state |= off_is_imm ? BPF_ALU_IMMEDIATE : 0;
 		alu_state |= ptr_is_dst_reg ?
 			     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
 	}
@@ -4850,7 +4852,7 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 			const u8 code_sub = BPF_ALU64 | BPF_SUB | BPF_X;
 			struct bpf_insn insn_buf[16];
 			struct bpf_insn *patch = &insn_buf[0];
-			bool issrc, isneg;
+			bool issrc, isneg, isimm;
 			u32 off_reg;
 
 			aux = &env->insn_aux_data[i + delta];
@@ -4861,16 +4863,21 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
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
@@ -4878,7 +4885,7 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 				insn->code = insn->code == code_add ?
 					     code_sub : code_add;
 			*patch++ = *insn;
-			if (issrc && isneg)
+			if (issrc && isneg && !isimm)
 				*patch++ = BPF_ALU64_IMM(BPF_MUL, off_reg, -1);
 			cnt = patch - insn_buf;
 
-- 
2.23.4

