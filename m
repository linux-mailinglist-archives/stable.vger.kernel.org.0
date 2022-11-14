Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAEB8627E6E
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237236AbiKNMrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237240AbiKNMrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:47:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889D22494A
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:47:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2389561180
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D83C433D6;
        Mon, 14 Nov 2022 12:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430060;
        bh=RUz7aPzVDfwLUwqzQKgvS4Haw7yr/j5S3102VAZxfGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rm0razf0eNAt8uAHm6zncI9k89/kn4M6G7SVWxXpekVpmBh9/AuXeNrFe7Bg/E/56
         2WyWFYf36zujwlOph78/dd0LXYiAmRZs3HdPIK2TwGZ8+bj/ODyKpSZVi1Ac3in/3T
         DYcXt5v+q5bMpN0Gq1zZJwg/k3W3DH92rCWu5IG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/95] bpf: Support for pointers beyond pkt_end.
Date:   Mon, 14 Nov 2022 13:45:03 +0100
Message-Id: <20221114124442.904055820@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 6d94e741a8ff818e5518da8257f5ca0aaed1f269 ]

This patch adds the verifier support to recognize inlined branch conditions.
The LLVM knows that the branch evaluates to the same value, but the verifier
couldn't track it. Hence causing valid programs to be rejected.
The potential LLVM workaround: https://reviews.llvm.org/D87428
can have undesired side effects, since LLVM doesn't know that
skb->data/data_end are being compared. LLVM has to introduce extra boolean
variable and use inline_asm trick to force easier for the verifier assembly.

Instead teach the verifier to recognize that
r1 = skb->data;
r1 += 10;
r2 = skb->data_end;
if (r1 > r2) {
  here r1 points beyond packet_end and
  subsequent
  if (r1 > r2) // always evaluates to "true".
}

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20201111031213.25109-2-alexei.starovoitov@gmail.com
Stable-dep-of: f1db20814af5 ("bpf: Fix wrong reg type conversion in release_reference()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h |   2 +-
 kernel/bpf/verifier.c        | 129 +++++++++++++++++++++++++++++------
 2 files changed, 108 insertions(+), 23 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 391bc1480dfb..f49165f9229c 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -45,7 +45,7 @@ struct bpf_reg_state {
 	enum bpf_reg_type type;
 	union {
 		/* valid when type == PTR_TO_PACKET */
-		u16 range;
+		int range;
 
 		/* valid when type == CONST_PTR_TO_MAP | PTR_TO_MAP_VALUE |
 		 *   PTR_TO_MAP_VALUE_OR_NULL
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e4dcc23b52c0..510a54471f13 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2978,7 +2978,9 @@ static int check_packet_access(struct bpf_verifier_env *env, u32 regno, int off,
 			regno);
 		return -EACCES;
 	}
-	err = __check_mem_access(env, regno, off, size, reg->range,
+
+	err = reg->range < 0 ? -EINVAL :
+	      __check_mem_access(env, regno, off, size, reg->range,
 				 zero_size_allowed);
 	if (err) {
 		verbose(env, "R%d offset is outside of the packet\n", regno);
@@ -5018,6 +5020,32 @@ static void clear_all_pkt_pointers(struct bpf_verifier_env *env)
 		__clear_all_pkt_pointers(env, vstate->frame[i]);
 }
 
+enum {
+	AT_PKT_END = -1,
+	BEYOND_PKT_END = -2,
+};
+
+static void mark_pkt_end(struct bpf_verifier_state *vstate, int regn, bool range_open)
+{
+	struct bpf_func_state *state = vstate->frame[vstate->curframe];
+	struct bpf_reg_state *reg = &state->regs[regn];
+
+	if (reg->type != PTR_TO_PACKET)
+		/* PTR_TO_PACKET_META is not supported yet */
+		return;
+
+	/* The 'reg' is pkt > pkt_end or pkt >= pkt_end.
+	 * How far beyond pkt_end it goes is unknown.
+	 * if (!range_open) it's the case of pkt >= pkt_end
+	 * if (range_open) it's the case of pkt > pkt_end
+	 * hence this pointer is at least 1 byte bigger than pkt_end
+	 */
+	if (range_open)
+		reg->range = BEYOND_PKT_END;
+	else
+		reg->range = AT_PKT_END;
+}
+
 static void release_reg_references(struct bpf_verifier_env *env,
 				   struct bpf_func_state *state,
 				   int ref_obj_id)
@@ -7193,7 +7221,7 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 
 static void __find_good_pkt_pointers(struct bpf_func_state *state,
 				     struct bpf_reg_state *dst_reg,
-				     enum bpf_reg_type type, u16 new_range)
+				     enum bpf_reg_type type, int new_range)
 {
 	struct bpf_reg_state *reg;
 	int i;
@@ -7218,8 +7246,7 @@ static void find_good_pkt_pointers(struct bpf_verifier_state *vstate,
 				   enum bpf_reg_type type,
 				   bool range_right_open)
 {
-	u16 new_range;
-	int i;
+	int new_range, i;
 
 	if (dst_reg->off < 0 ||
 	    (dst_reg->off == 0 && range_right_open))
@@ -7470,6 +7497,67 @@ static int is_branch_taken(struct bpf_reg_state *reg, u64 val, u8 opcode,
 	return is_branch64_taken(reg, val, opcode);
 }
 
+static int flip_opcode(u32 opcode)
+{
+	/* How can we transform "a <op> b" into "b <op> a"? */
+	static const u8 opcode_flip[16] = {
+		/* these stay the same */
+		[BPF_JEQ  >> 4] = BPF_JEQ,
+		[BPF_JNE  >> 4] = BPF_JNE,
+		[BPF_JSET >> 4] = BPF_JSET,
+		/* these swap "lesser" and "greater" (L and G in the opcodes) */
+		[BPF_JGE  >> 4] = BPF_JLE,
+		[BPF_JGT  >> 4] = BPF_JLT,
+		[BPF_JLE  >> 4] = BPF_JGE,
+		[BPF_JLT  >> 4] = BPF_JGT,
+		[BPF_JSGE >> 4] = BPF_JSLE,
+		[BPF_JSGT >> 4] = BPF_JSLT,
+		[BPF_JSLE >> 4] = BPF_JSGE,
+		[BPF_JSLT >> 4] = BPF_JSGT
+	};
+	return opcode_flip[opcode >> 4];
+}
+
+static int is_pkt_ptr_branch_taken(struct bpf_reg_state *dst_reg,
+				   struct bpf_reg_state *src_reg,
+				   u8 opcode)
+{
+	struct bpf_reg_state *pkt;
+
+	if (src_reg->type == PTR_TO_PACKET_END) {
+		pkt = dst_reg;
+	} else if (dst_reg->type == PTR_TO_PACKET_END) {
+		pkt = src_reg;
+		opcode = flip_opcode(opcode);
+	} else {
+		return -1;
+	}
+
+	if (pkt->range >= 0)
+		return -1;
+
+	switch (opcode) {
+	case BPF_JLE:
+		/* pkt <= pkt_end */
+		fallthrough;
+	case BPF_JGT:
+		/* pkt > pkt_end */
+		if (pkt->range == BEYOND_PKT_END)
+			/* pkt has at last one extra byte beyond pkt_end */
+			return opcode == BPF_JGT;
+		break;
+	case BPF_JLT:
+		/* pkt < pkt_end */
+		fallthrough;
+	case BPF_JGE:
+		/* pkt >= pkt_end */
+		if (pkt->range == BEYOND_PKT_END || pkt->range == AT_PKT_END)
+			return opcode == BPF_JGE;
+		break;
+	}
+	return -1;
+}
+
 /* Adjusts the register min/max values in the case that the dst_reg is the
  * variable register that we are working on, and src_reg is a constant or we're
  * simply doing a BPF_K check.
@@ -7640,23 +7728,7 @@ static void reg_set_min_max_inv(struct bpf_reg_state *true_reg,
 				u64 val, u32 val32,
 				u8 opcode, bool is_jmp32)
 {
-	/* How can we transform "a <op> b" into "b <op> a"? */
-	static const u8 opcode_flip[16] = {
-		/* these stay the same */
-		[BPF_JEQ  >> 4] = BPF_JEQ,
-		[BPF_JNE  >> 4] = BPF_JNE,
-		[BPF_JSET >> 4] = BPF_JSET,
-		/* these swap "lesser" and "greater" (L and G in the opcodes) */
-		[BPF_JGE  >> 4] = BPF_JLE,
-		[BPF_JGT  >> 4] = BPF_JLT,
-		[BPF_JLE  >> 4] = BPF_JGE,
-		[BPF_JLT  >> 4] = BPF_JGT,
-		[BPF_JSGE >> 4] = BPF_JSLE,
-		[BPF_JSGT >> 4] = BPF_JSLT,
-		[BPF_JSLE >> 4] = BPF_JSGE,
-		[BPF_JSLT >> 4] = BPF_JSGT
-	};
-	opcode = opcode_flip[opcode >> 4];
+	opcode = flip_opcode(opcode);
 	/* This uses zero as "not present in table"; luckily the zero opcode,
 	 * BPF_JA, can't get here.
 	 */
@@ -7825,6 +7897,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_data' > pkt_end, pkt_meta' > pkt_data */
 			find_good_pkt_pointers(this_branch, dst_reg,
 					       dst_reg->type, false);
+			mark_pkt_end(other_branch, insn->dst_reg, true);
 		} else if ((dst_reg->type == PTR_TO_PACKET_END &&
 			    src_reg->type == PTR_TO_PACKET) ||
 			   (reg_is_init_pkt_pointer(dst_reg, PTR_TO_PACKET) &&
@@ -7832,6 +7905,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_end > pkt_data', pkt_data > pkt_meta' */
 			find_good_pkt_pointers(other_branch, src_reg,
 					       src_reg->type, true);
+			mark_pkt_end(this_branch, insn->src_reg, false);
 		} else {
 			return false;
 		}
@@ -7844,6 +7918,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_data' < pkt_end, pkt_meta' < pkt_data */
 			find_good_pkt_pointers(other_branch, dst_reg,
 					       dst_reg->type, true);
+			mark_pkt_end(this_branch, insn->dst_reg, false);
 		} else if ((dst_reg->type == PTR_TO_PACKET_END &&
 			    src_reg->type == PTR_TO_PACKET) ||
 			   (reg_is_init_pkt_pointer(dst_reg, PTR_TO_PACKET) &&
@@ -7851,6 +7926,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_end < pkt_data', pkt_data > pkt_meta' */
 			find_good_pkt_pointers(this_branch, src_reg,
 					       src_reg->type, false);
+			mark_pkt_end(other_branch, insn->src_reg, true);
 		} else {
 			return false;
 		}
@@ -7863,6 +7939,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_data' >= pkt_end, pkt_meta' >= pkt_data */
 			find_good_pkt_pointers(this_branch, dst_reg,
 					       dst_reg->type, true);
+			mark_pkt_end(other_branch, insn->dst_reg, false);
 		} else if ((dst_reg->type == PTR_TO_PACKET_END &&
 			    src_reg->type == PTR_TO_PACKET) ||
 			   (reg_is_init_pkt_pointer(dst_reg, PTR_TO_PACKET) &&
@@ -7870,6 +7947,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_end >= pkt_data', pkt_data >= pkt_meta' */
 			find_good_pkt_pointers(other_branch, src_reg,
 					       src_reg->type, false);
+			mark_pkt_end(this_branch, insn->src_reg, true);
 		} else {
 			return false;
 		}
@@ -7882,6 +7960,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_data' <= pkt_end, pkt_meta' <= pkt_data */
 			find_good_pkt_pointers(other_branch, dst_reg,
 					       dst_reg->type, false);
+			mark_pkt_end(this_branch, insn->dst_reg, true);
 		} else if ((dst_reg->type == PTR_TO_PACKET_END &&
 			    src_reg->type == PTR_TO_PACKET) ||
 			   (reg_is_init_pkt_pointer(dst_reg, PTR_TO_PACKET) &&
@@ -7889,6 +7968,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_end <= pkt_data', pkt_data <= pkt_meta' */
 			find_good_pkt_pointers(this_branch, src_reg,
 					       src_reg->type, true);
+			mark_pkt_end(other_branch, insn->src_reg, false);
 		} else {
 			return false;
 		}
@@ -7988,6 +8068,10 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 				       src_reg->var_off.value,
 				       opcode,
 				       is_jmp32);
+	} else if (reg_is_pkt_pointer_any(dst_reg) &&
+		   reg_is_pkt_pointer_any(src_reg) &&
+		   !is_jmp32) {
+		pred = is_pkt_ptr_branch_taken(dst_reg, src_reg, opcode);
 	}
 
 	if (pred >= 0) {
@@ -7996,7 +8080,8 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 		 */
 		if (!__is_pointer_value(false, dst_reg))
 			err = mark_chain_precision(env, insn->dst_reg);
-		if (BPF_SRC(insn->code) == BPF_X && !err)
+		if (BPF_SRC(insn->code) == BPF_X && !err &&
+		    !__is_pointer_value(false, src_reg))
 			err = mark_chain_precision(env, insn->src_reg);
 		if (err)
 			return err;
-- 
2.35.1



