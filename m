Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E3337058D
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 06:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhEAEb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 00:31:57 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:41177 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbhEAEbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 00:31:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619843465; x=1651379465;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VSElzeoIeDbyeLzpqpMDH6EKCg/dFvYF77JFMuCVIck=;
  b=lNtmwA7Je1c6bXi/+FFMFrDWodmAMiZD60nM7JM9EX+e5gq9K+EXQL7H
   L8u07qFJfkyqZTyufAXvkzmhEmSA/w9W7TFVU2wH6ztHtcK+UuxWzv92s
   qJLS+IZMT2BI59SpH7hih99Iapy2gXCFchz3CVkldcNqmrwG0GiR82R44
   c=;
X-IronPort-AV: E=Sophos;i="5.82,264,1613433600"; 
   d="scan'208";a="110970744"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 01 May 2021 04:31:05 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 94FA5A1CD7;
        Sat,  1 May 2021 04:31:02 +0000 (UTC)
Received: from EX13D01UWB002.ant.amazon.com (10.43.161.136) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13d01UWB002.ant.amazon.com (10.43.161.136) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:15 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Sat, 1 May 2021 04:30:15 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 43156DDB; Sat,  1 May 2021 04:30:14 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <samjonas@amazon.com>
Subject: [PATCH 4.14 12/15] bpf: do not allow root to mangle valid pointers
Date:   Sat, 1 May 2021 04:30:11 +0000
Message-ID: <20210501043014.33300-13-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210501043014.33300-1-fllinden@amazon.com>
References: <20210501043014.33300-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Upstream commit 82abbf8d2fc46d79611ab58daa7c608df14bb3ee

Do not allow root to convert valid pointers into unknown scalars.
In particular disallow:
 ptr &= reg
 ptr <<= reg
 ptr += ptr
and explicitly allow:
 ptr -= ptr
since pkt_end - pkt == length

1.
This minimizes amount of address leaks root can do.
In the future may need to further tighten the leaks with kptr_restrict.

2.
If program has such pointer math it's likely a user mistake and
when verifier complains about it right away instead of many instructions
later on invalid memory access it's easier for users to fix their progs.

3.
when register holding a pointer cannot change to scalar it allows JITs to
optimize better. Like 32-bit archs could use single register for pointers
instead of a pair required to hold 64-bit scalars.

4.
reduces architecture dependent behavior. Since code:
r1 = r10;
r1 &= 0xff;
if (r1 ...)
will behave differently arm64 vs x64 and offloaded vs native.

A significant chunk of ptr mangling was allowed by
commit f1174f77b50c ("bpf/verifier: rework value tracking")
yet some of it was allowed even earlier.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
[fllinden@amazon.com: backport to 4.14]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
---
 kernel/bpf/verifier.c                       | 100 +++++++-------------
 tools/testing/selftests/bpf/test_verifier.c |  56 +++++------
 2 files changed, 62 insertions(+), 94 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0ec8604747b2..8ef1c74eaa11 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2292,28 +2292,24 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 
 	if (BPF_CLASS(insn->code) != BPF_ALU64) {
 		/* 32-bit ALU ops on pointers produce (meaningless) scalars */
-		if (!env->allow_ptr_leaks)
-			verbose("R%d 32-bit pointer arithmetic prohibited\n",
-				dst);
+		verbose("R%d 32-bit pointer arithmetic prohibited\n",
+			dst);
 		return -EACCES;
 	}
 
 	if (ptr_reg->type == PTR_TO_MAP_VALUE_OR_NULL) {
-		if (!env->allow_ptr_leaks)
-			verbose("R%d pointer arithmetic on PTR_TO_MAP_VALUE_OR_NULL prohibited, null-check it first\n",
-				dst);
+		verbose("R%d pointer arithmetic on PTR_TO_MAP_VALUE_OR_NULL prohibited, null-check it first\n",
+			dst);
 		return -EACCES;
 	}
 	if (ptr_reg->type == CONST_PTR_TO_MAP) {
-		if (!env->allow_ptr_leaks)
-			verbose("R%d pointer arithmetic on CONST_PTR_TO_MAP prohibited\n",
-				dst);
+		verbose("R%d pointer arithmetic on CONST_PTR_TO_MAP prohibited\n",
+			dst);
 		return -EACCES;
 	}
 	if (ptr_reg->type == PTR_TO_PACKET_END) {
-		if (!env->allow_ptr_leaks)
-			verbose("R%d pointer arithmetic on PTR_TO_PACKET_END prohibited\n",
-				dst);
+		verbose("R%d pointer arithmetic on PTR_TO_PACKET_END prohibited\n",
+			dst);
 		return -EACCES;
 	}
 
@@ -2388,9 +2384,8 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	case BPF_SUB:
 		if (dst_reg == off_reg) {
 			/* scalar -= pointer.  Creates an unknown scalar */
-			if (!env->allow_ptr_leaks)
-				verbose("R%d tried to subtract pointer from scalar\n",
-					dst);
+			verbose("R%d tried to subtract pointer from scalar\n",
+				dst);
 			return -EACCES;
 		}
 		/* We don't allow subtraction from FP, because (according to
@@ -2398,9 +2393,8 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		 * be able to deal with it.
 		 */
 		if (ptr_reg->type == PTR_TO_STACK) {
-			if (!env->allow_ptr_leaks)
-				verbose("R%d subtraction from stack pointer prohibited\n",
-					dst);
+			verbose("R%d subtraction from stack pointer prohibited\n",
+				dst);
 			return -EACCES;
 		}
 		if (known && (ptr_reg->off - smin_val ==
@@ -2450,19 +2444,14 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	case BPF_AND:
 	case BPF_OR:
 	case BPF_XOR:
-		/* bitwise ops on pointers are troublesome, prohibit for now.
-		 * (However, in principle we could allow some cases, e.g.
-		 * ptr &= ~3 which would reduce min_value by 3.)
-		 */
-		if (!env->allow_ptr_leaks)
-			verbose("R%d bitwise operator %s on pointer prohibited\n",
-				dst, bpf_alu_string[opcode >> 4]);
+		/* bitwise ops on pointers are troublesome. */
+		verbose("R%d bitwise operator %s on pointer prohibited\n",
+			dst, bpf_alu_string[opcode >> 4]);
 		return -EACCES;
 	default:
 		/* other operators (e.g. MUL,LSH) produce non-pointer results */
-		if (!env->allow_ptr_leaks)
-			verbose("R%d pointer arithmetic with %s operator prohibited\n",
-				dst, bpf_alu_string[opcode >> 4]);
+		verbose("R%d pointer arithmetic with %s operator prohibited\n",
+			dst, bpf_alu_string[opcode >> 4]);
 		return -EACCES;
 	}
 
@@ -2752,7 +2741,6 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 	struct bpf_reg_state *regs = cur_regs(env), *dst_reg, *src_reg;
 	struct bpf_reg_state *ptr_reg = NULL, off_reg = {0};
 	u8 opcode = BPF_OP(insn->code);
-	int rc;
 
 	dst_reg = &regs[insn->dst_reg];
 	src_reg = NULL;
@@ -2763,43 +2751,29 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 		if (src_reg->type != SCALAR_VALUE) {
 			if (dst_reg->type != SCALAR_VALUE) {
 				/* Combining two pointers by any ALU op yields
-				 * an arbitrary scalar.
+				 * an arbitrary scalar. Disallow all math except
+				 * pointer subtraction
 				 */
-				if (!env->allow_ptr_leaks) {
-					verbose("R%d pointer %s pointer prohibited\n",
-						insn->dst_reg,
-						bpf_alu_string[opcode >> 4]);
-					return -EACCES;
+				if (opcode == BPF_SUB){
+					mark_reg_unknown(regs, insn->dst_reg);
+					return 0;
 				}
-				mark_reg_unknown(regs, insn->dst_reg);
-				return 0;
+				verbose("R%d pointer %s pointer prohibited\n",
+					insn->dst_reg,
+					bpf_alu_string[opcode >> 4]);
+				return -EACCES;
 			} else {
 				/* scalar += pointer
 				 * This is legal, but we have to reverse our
 				 * src/dest handling in computing the range
 				 */
-				rc = adjust_ptr_min_max_vals(env, insn,
-							     src_reg, dst_reg);
-				if (rc == -EACCES && env->allow_ptr_leaks) {
-					/* scalar += unknown scalar */
-					__mark_reg_unknown(&off_reg);
-					return adjust_scalar_min_max_vals(
-							env, insn,
-							dst_reg, off_reg);
-				}
-				return rc;
+				return adjust_ptr_min_max_vals(env, insn,
+							       src_reg, dst_reg);
 			}
 		} else if (ptr_reg) {
 			/* pointer += scalar */
-			rc = adjust_ptr_min_max_vals(env, insn,
-						     dst_reg, src_reg);
-			if (rc == -EACCES && env->allow_ptr_leaks) {
-				/* unknown scalar += scalar */
-				__mark_reg_unknown(dst_reg);
-				return adjust_scalar_min_max_vals(
-						env, insn, dst_reg, *src_reg);
-			}
-			return rc;
+			return adjust_ptr_min_max_vals(env, insn,
+						       dst_reg, src_reg);
 		}
 	} else {
 		/* Pretend the src is a reg with a known value, since we only
@@ -2808,17 +2782,9 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 		off_reg.type = SCALAR_VALUE;
 		__mark_reg_known(&off_reg, insn->imm);
 		src_reg = &off_reg;
-		if (ptr_reg) { /* pointer += K */
-			rc = adjust_ptr_min_max_vals(env, insn,
-						     ptr_reg, src_reg);
-			if (rc == -EACCES && env->allow_ptr_leaks) {
-				/* unknown scalar += K */
-				__mark_reg_unknown(dst_reg);
-				return adjust_scalar_min_max_vals(
-						env, insn, dst_reg, off_reg);
-			}
-			return rc;
-		}
+		if (ptr_reg) /* pointer += K */
+			return adjust_ptr_min_max_vals(env, insn,
+						       ptr_reg, src_reg);
 	}
 
 	/* Got here implies adding two SCALAR_VALUEs */
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index bab9942b20b2..d4f611546fc0 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -462,9 +462,7 @@ static struct bpf_test tests[] = {
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R1 subtraction from stack pointer",
-		.result_unpriv = REJECT,
-		.errstr = "R1 invalid mem access",
+		.errstr = "R1 subtraction from stack pointer",
 		.result = REJECT,
 	},
 	{
@@ -1900,9 +1898,8 @@ static struct bpf_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
-		.result = ACCEPT,
-		.result_unpriv = REJECT,
-		.errstr_unpriv = "R1 pointer += pointer",
+		.result = REJECT,
+		.errstr = "R1 pointer += pointer",
 	},
 	{
 		"unpriv: neg pointer",
@@ -2694,7 +2691,8 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct __sk_buff, data)),
 			BPF_ALU64_REG(BPF_ADD, BPF_REG_3, BPF_REG_4),
-			BPF_MOV64_REG(BPF_REG_2, BPF_REG_1),
+			BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+				    offsetof(struct __sk_buff, len)),
 			BPF_ALU64_IMM(BPF_LSH, BPF_REG_2, 49),
 			BPF_ALU64_IMM(BPF_RSH, BPF_REG_2, 49),
 			BPF_ALU64_REG(BPF_ADD, BPF_REG_3, BPF_REG_2),
@@ -3001,7 +2999,7 @@ static struct bpf_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
-		.errstr = "invalid access to packet",
+		.errstr = "R3 pointer arithmetic on PTR_TO_PACKET_END",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	},
@@ -3988,9 +3986,7 @@ static struct bpf_test tests[] = {
 			BPF_EXIT_INSN(),
 		},
 		.fixup_map2 = { 3, 11 },
-		.errstr_unpriv = "R0 pointer += pointer",
-		.errstr = "R0 invalid mem access 'inv'",
-		.result_unpriv = REJECT,
+		.errstr = "R0 pointer += pointer",
 		.result = REJECT,
 		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
@@ -4031,7 +4027,7 @@ static struct bpf_test tests[] = {
 			BPF_EXIT_INSN(),
 		},
 		.fixup_map1 = { 4 },
-		.errstr = "R4 invalid mem access",
+		.errstr = "R4 pointer arithmetic on PTR_TO_MAP_VALUE_OR_NULL",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS
 	},
@@ -4052,7 +4048,7 @@ static struct bpf_test tests[] = {
 			BPF_EXIT_INSN(),
 		},
 		.fixup_map1 = { 4 },
-		.errstr = "R4 invalid mem access",
+		.errstr = "R4 pointer arithmetic on PTR_TO_MAP_VALUE_OR_NULL",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS
 	},
@@ -4073,7 +4069,7 @@ static struct bpf_test tests[] = {
 			BPF_EXIT_INSN(),
 		},
 		.fixup_map1 = { 4 },
-		.errstr = "R4 invalid mem access",
+		.errstr = "R4 pointer arithmetic on PTR_TO_MAP_VALUE_OR_NULL",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS
 	},
@@ -5304,10 +5300,8 @@ static struct bpf_test tests[] = {
 			BPF_EXIT_INSN(),
 		},
 		.fixup_map2 = { 3 },
-		.errstr_unpriv = "R0 bitwise operator &= on pointer",
-		.errstr = "invalid mem access 'inv'",
+		.errstr = "R0 bitwise operator &= on pointer",
 		.result = REJECT,
-		.result_unpriv = REJECT,
 	},
 	{
 		"map element value illegal alu op, 2",
@@ -5323,10 +5317,8 @@ static struct bpf_test tests[] = {
 			BPF_EXIT_INSN(),
 		},
 		.fixup_map2 = { 3 },
-		.errstr_unpriv = "R0 32-bit pointer arithmetic prohibited",
-		.errstr = "invalid mem access 'inv'",
+		.errstr = "R0 32-bit pointer arithmetic prohibited",
 		.result = REJECT,
-		.result_unpriv = REJECT,
 	},
 	{
 		"map element value illegal alu op, 3",
@@ -5342,10 +5334,8 @@ static struct bpf_test tests[] = {
 			BPF_EXIT_INSN(),
 		},
 		.fixup_map2 = { 3 },
-		.errstr_unpriv = "R0 pointer arithmetic with /= operator",
-		.errstr = "invalid mem access 'inv'",
+		.errstr = "R0 pointer arithmetic with /= operator",
 		.result = REJECT,
-		.result_unpriv = REJECT,
 	},
 	{
 		"map element value illegal alu op, 4",
@@ -5938,8 +5928,7 @@ static struct bpf_test tests[] = {
 			BPF_EXIT_INSN(),
 		},
 		.fixup_map_in_map = { 3 },
-		.errstr = "R1 type=inv expected=map_ptr",
-		.errstr_unpriv = "R1 pointer arithmetic on CONST_PTR_TO_MAP prohibited",
+		.errstr = "R1 pointer arithmetic on CONST_PTR_TO_MAP prohibited",
 		.result = REJECT,
 	},
 	{
@@ -7299,6 +7288,19 @@ static struct bpf_test tests[] = {
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	},
+	{
+		"pkt_end - pkt_start is allowed",
+		.insns = {
+			BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+				    offsetof(struct __sk_buff, data_end)),
+			BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+				    offsetof(struct __sk_buff, data)),
+			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_2),
+			BPF_EXIT_INSN(),
+		},
+		.result = ACCEPT,
+		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	},
 	{
 		"XDP pkt read, pkt_end mangling, bad access 1",
 		.insns = {
@@ -7314,7 +7316,7 @@ static struct bpf_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
-		.errstr = "R1 offset is outside of the packet",
+		.errstr = "R3 pointer arithmetic on PTR_TO_PACKET_END",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
 	},
@@ -7333,7 +7335,7 @@ static struct bpf_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
-		.errstr = "R1 offset is outside of the packet",
+		.errstr = "R3 pointer arithmetic on PTR_TO_PACKET_END",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_XDP,
 	},
-- 
2.23.3

