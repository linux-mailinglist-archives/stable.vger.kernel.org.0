Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5D2395C75
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbhEaNdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:33:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232268AbhEaNbU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:31:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31A1461429;
        Mon, 31 May 2021 13:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467405;
        bh=xb23o8DUX8b75uGqoq5GEqkbgFB7zS0mmrZsTAk7r0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ywUOByNxbspBEkuUbe/oA/VZBEBAdsBDoBAti6vPTI/luOpkXqLVl6pUaJid5iZiy
         S9/d+qVfhCJbuaRTaGVD+jERPQOxUzZehKq4k1xO/cg02wJnrnZ8X5MSCI/vNL2/FC
         3SOBDYL/MeMtL0DBibW1mo1SPylW/qT20Qvv4afQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Piotr Krysiuk <piotras@gmail.com>,
        Benedict Schlueter <benedict.schlueter@rub.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Frank van der Linden <fllinden@amazon.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 053/116] bpf: Tighten speculative pointer arithmetic mask
Date:   Mon, 31 May 2021 15:13:49 +0200
Message-Id: <20210531130641.968248687@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 7fedb63a8307dda0ec3b8969a3b233a1dd7ea8e0 upstream.

This work tightens the offset mask we use for unprivileged pointer arithmetic
in order to mitigate a corner case reported by Piotr and Benedict where in
the speculative domain it is possible to advance, for example, the map value
pointer by up to value_size-1 out-of-bounds in order to leak kernel memory
via side-channel to user space.

Before this change, the computed ptr_limit for retrieve_ptr_limit() helper
represents largest valid distance when moving pointer to the right or left
which is then fed as aux->alu_limit to generate masking instructions against
the offset register. After the change, the derived aux->alu_limit represents
the largest potential value of the offset register which we mask against which
is just a narrower subset of the former limit.

For minimal complexity, we call sanitize_ptr_alu() from 2 observation points
in adjust_ptr_min_max_vals(), that is, before and after the simulated alu
operation. In the first step, we retieve the alu_state and alu_limit before
the operation as well as we branch-off a verifier path and push it to the
verification stack as we did before which checks the dst_reg under truncation,
in other words, when the speculative domain would attempt to move the pointer
out-of-bounds.

In the second step, we retrieve the new alu_limit and calculate the absolute
distance between both. Moreover, we commit the alu_state and final alu_limit
via update_alu_sanitation_state() to the env's instruction aux data, and bail
out from there if there is a mismatch due to coming from different verification
paths with different states.

Reported-by: Piotr Krysiuk <piotras@gmail.com>
Reported-by: Benedict Schlueter <benedict.schlueter@rub.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Tested-by: Benedict Schlueter <benedict.schlueter@rub.de>
[fllinden@amazon.com: backported to 5.4]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[OP: backport to 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   70 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 26 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2744,7 +2744,7 @@ static int retrieve_ptr_limit(const stru
 	bool off_is_neg = off_reg->smin_value < 0;
 	bool mask_to_left = (opcode == BPF_ADD &&  off_is_neg) ||
 			    (opcode == BPF_SUB && !off_is_neg);
-	u32 off, max = 0, ptr_limit = 0;
+	u32 max = 0, ptr_limit = 0;
 
 	if (!tnum_is_const(off_reg->var_off) &&
 	    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
@@ -2753,23 +2753,18 @@ static int retrieve_ptr_limit(const stru
 	switch (ptr_reg->type) {
 	case PTR_TO_STACK:
 		/* Offset 0 is out-of-bounds, but acceptable start for the
-		 * left direction, see BPF_REG_FP.
+		 * left direction, see BPF_REG_FP. Also, unknown scalar
+		 * offset where we would need to deal with min/max bounds is
+		 * currently prohibited for unprivileged.
 		 */
 		max = MAX_BPF_STACK + mask_to_left;
-		off = ptr_reg->off + ptr_reg->var_off.value;
-		if (mask_to_left)
-			ptr_limit = MAX_BPF_STACK + off;
-		else
-			ptr_limit = -off - 1;
+		ptr_limit = -(ptr_reg->var_off.value + ptr_reg->off);
 		break;
 	case PTR_TO_MAP_VALUE:
 		max = ptr_reg->map_ptr->value_size;
-		if (mask_to_left) {
-			ptr_limit = ptr_reg->umax_value + ptr_reg->off;
-		} else {
-			off = ptr_reg->smin_value + ptr_reg->off;
-			ptr_limit = ptr_reg->map_ptr->value_size - off - 1;
-		}
+		ptr_limit = (mask_to_left ?
+			     ptr_reg->smin_value :
+			     ptr_reg->umax_value) + ptr_reg->off;
 		break;
 	default:
 		return REASON_TYPE;
@@ -2824,10 +2819,12 @@ static int sanitize_ptr_alu(struct bpf_v
 			    struct bpf_insn *insn,
 			    const struct bpf_reg_state *ptr_reg,
 			    const struct bpf_reg_state *off_reg,
-			    struct bpf_reg_state *dst_reg)
+			    struct bpf_reg_state *dst_reg,
+			    struct bpf_insn_aux_data *tmp_aux,
+			    const bool commit_window)
 {
+	struct bpf_insn_aux_data *aux = commit_window ? cur_aux(env) : tmp_aux;
 	struct bpf_verifier_state *vstate = env->cur_state;
-	struct bpf_insn_aux_data *aux = cur_aux(env);
 	bool off_is_neg = off_reg->smin_value < 0;
 	bool ptr_is_dst_reg = ptr_reg == dst_reg;
 	u8 opcode = BPF_OP(insn->code);
@@ -2846,18 +2843,33 @@ static int sanitize_ptr_alu(struct bpf_v
 	if (vstate->speculative)
 		goto do_sim;
 
-	alu_state  = off_is_neg ? BPF_ALU_NEG_VALUE : 0;
-	alu_state |= ptr_is_dst_reg ?
-		     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
-
 	err = retrieve_ptr_limit(ptr_reg, off_reg, &alu_limit, opcode);
 	if (err < 0)
 		return err;
 
+	if (commit_window) {
+		/* In commit phase we narrow the masking window based on
+		 * the observed pointer move after the simulated operation.
+		 */
+		alu_state = tmp_aux->alu_state;
+		alu_limit = abs(tmp_aux->alu_limit - alu_limit);
+	} else {
+		alu_state  = off_is_neg ? BPF_ALU_NEG_VALUE : 0;
+		alu_state |= ptr_is_dst_reg ?
+			     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
+	}
+
 	err = update_alu_sanitation_state(aux, alu_state, alu_limit);
 	if (err < 0)
 		return err;
 do_sim:
+	/* If we're in commit phase, we're done here given we already
+	 * pushed the truncated dst_reg into the speculative verification
+	 * stack.
+	 */
+	if (commit_window)
+		return 0;
+
 	/* Simulate and find potential out-of-bounds access under
 	 * speculative execution from truncation as a result of
 	 * masking when off was not within expected range. If off
@@ -2969,6 +2981,7 @@ static int adjust_ptr_min_max_vals(struc
 	    smin_ptr = ptr_reg->smin_value, smax_ptr = ptr_reg->smax_value;
 	u64 umin_val = off_reg->umin_value, umax_val = off_reg->umax_value,
 	    umin_ptr = ptr_reg->umin_value, umax_ptr = ptr_reg->umax_value;
+	struct bpf_insn_aux_data tmp_aux = {};
 	u8 opcode = BPF_OP(insn->code);
 	u32 dst = insn->dst_reg;
 	int ret;
@@ -3018,12 +3031,15 @@ static int adjust_ptr_min_max_vals(struc
 	    !check_reg_sane_offset(env, ptr_reg, ptr_reg->type))
 		return -EINVAL;
 
-	switch (opcode) {
-	case BPF_ADD:
-		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
+	if (sanitize_needed(opcode)) {
+		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg,
+				       &tmp_aux, false);
 		if (ret < 0)
 			return sanitize_err(env, insn, ret, off_reg, dst_reg);
+	}
 
+	switch (opcode) {
+	case BPF_ADD:
 		/* We can take a fixed offset as long as it doesn't overflow
 		 * the s32 'off' field
 		 */
@@ -3074,10 +3090,6 @@ static int adjust_ptr_min_max_vals(struc
 		}
 		break;
 	case BPF_SUB:
-		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
-		if (ret < 0)
-			return sanitize_err(env, insn, ret, off_reg, dst_reg);
-
 		if (dst_reg == off_reg) {
 			/* scalar -= pointer.  Creates an unknown scalar */
 			verbose(env, "R%d tried to subtract pointer from scalar\n",
@@ -3160,6 +3172,12 @@ static int adjust_ptr_min_max_vals(struc
 
 	if (sanitize_check_bounds(env, insn, dst_reg) < 0)
 		return -EACCES;
+	if (sanitize_needed(opcode)) {
+		ret = sanitize_ptr_alu(env, insn, dst_reg, off_reg, dst_reg,
+				       &tmp_aux, true);
+		if (ret < 0)
+			return sanitize_err(env, insn, ret, off_reg, dst_reg);
+	}
 
 	return 0;
 }


