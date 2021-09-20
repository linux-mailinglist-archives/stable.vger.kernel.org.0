Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44284411FB9
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345434AbhITRpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:45:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353010AbhITRnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:43:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DD7561B55;
        Mon, 20 Sep 2021 17:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157752;
        bh=jHNtbOO8T56oiWBgCTi+lNaxGg8nT/GF/zgExs4+zsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erEa1D7pdmf+cZWMfyLt/i6Y5UkQg8PV9Nh7NznoR5ybsrJyypqoerN5ecthxGOIY
         NS6lX6mvvvsWLByDoVQ4NXrn9pmQKuaieGBQsiDK3z2SHkrL1f6apfEJUdGiAx5SYJ
         3cVZbqaGxZtq5D3npli8LPJb7Q5gDodbIi8P5bd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 134/293] bpf: track spill/fill of constants
Date:   Mon, 20 Sep 2021 18:41:36 +0200
Message-Id: <20210920163937.866323905@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

commit f7cf25b2026dc8441e0fa3a202c2aa8a56211e30 upstream.

Compilers often spill induction variables into the stack,
hence it is necessary for the verifier to track scalar values
of the registers through stack slots.

Also few bpf programs were incorrectly rejected in the past,
since the verifier was not able to track such constants while
they were used to compute offsets into packet headers.

Tracking constants through the stack significantly decreases
the chances of state pruning, since two different constants
are considered to be different by state equivalency.
End result that cilium tests suffer serious degradation in the number
of states processed and corresponding verification time increase.

                     before  after
bpf_lb-DLB_L3.o      1838    6441
bpf_lb-DLB_L4.o      3218    5908
bpf_lb-DUNKNOWN.o    1064    1064
bpf_lxc-DDROP_ALL.o  26935   93790
bpf_lxc-DUNKNOWN.o   34439   123886
bpf_netdev.o         9721    31413
bpf_overlay.o        6184    18561
bpf_lxc_jit.o        39389   359445

After further debugging turned out that cillium progs are
getting hurt by clang due to the same constant tracking issue.
Newer clang generates better code by spilling less to the stack.
Instead it keeps more constants in the registers which
hurts state pruning since the verifier already tracks constants
in the registers:
                  old clang  new clang
                         (no spill/fill tracking introduced by this patch)
bpf_lb-DLB_L3.o      1838    1923
bpf_lb-DLB_L4.o      3218    3077
bpf_lb-DUNKNOWN.o    1064    1062
bpf_lxc-DDROP_ALL.o  26935   166729
bpf_lxc-DUNKNOWN.o   34439   174607
bpf_netdev.o         9721    8407
bpf_overlay.o        6184    5420
bpf_lcx_jit.o        39389   39389

The final table is depressing:
                  old clang  old clang    new clang  new clang
                           const spill/fill        const spill/fill
bpf_lb-DLB_L3.o      1838    6441          1923      8128
bpf_lb-DLB_L4.o      3218    5908          3077      6707
bpf_lb-DUNKNOWN.o    1064    1064          1062      1062
bpf_lxc-DDROP_ALL.o  26935   93790         166729    380712
bpf_lxc-DUNKNOWN.o   34439   123886        174607    440652
bpf_netdev.o         9721    31413         8407      31904
bpf_overlay.o        6184    18561         5420      23569
bpf_lxc_jit.o        39389   359445        39389     359445

Tracking constants in the registers hurts state pruning already.
Adding tracking of constants through stack hurts pruning even more.
The later patch address this general constant tracking issue
with coarse/precise logic.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
[OP: - drop verbose_linfo() calls, as the function is not implemented in 4.19
     - adjust mark_reg_read() calls to match the prototype in 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   88 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 64 insertions(+), 24 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -963,6 +963,23 @@ static bool register_is_null(struct bpf_
 	return reg->type == SCALAR_VALUE && tnum_equals_const(reg->var_off, 0);
 }
 
+static bool register_is_const(struct bpf_reg_state *reg)
+{
+	return reg->type == SCALAR_VALUE && tnum_is_const(reg->var_off);
+}
+
+static void save_register_state(struct bpf_func_state *state,
+				int spi, struct bpf_reg_state *reg)
+{
+	int i;
+
+	state->stack[spi].spilled_ptr = *reg;
+	state->stack[spi].spilled_ptr.live |= REG_LIVE_WRITTEN;
+
+	for (i = 0; i < BPF_REG_SIZE; i++)
+		state->stack[spi].slot_type[i] = STACK_SPILL;
+}
+
 /* check_stack_read/write functions track spill/fill of registers,
  * stack boundary and alignment are checked in check_mem_access()
  */
@@ -972,7 +989,7 @@ static int check_stack_write(struct bpf_
 {
 	struct bpf_func_state *cur; /* state of the current function */
 	int i, slot = -off - 1, spi = slot / BPF_REG_SIZE, err;
-	enum bpf_reg_type type;
+	struct bpf_reg_state *reg = NULL;
 
 	err = realloc_func_state(state, round_up(slot + 1, BPF_REG_SIZE),
 				 true);
@@ -989,27 +1006,36 @@ static int check_stack_write(struct bpf_
 	}
 
 	cur = env->cur_state->frame[env->cur_state->curframe];
-	if (value_regno >= 0 &&
-	    is_spillable_regtype((type = cur->regs[value_regno].type))) {
+	if (value_regno >= 0)
+		reg = &cur->regs[value_regno];
 
+	if (reg && size == BPF_REG_SIZE && register_is_const(reg) &&
+	    !register_is_null(reg) && env->allow_ptr_leaks) {
+		save_register_state(state, spi, reg);
+	} else if (reg && is_spillable_regtype(reg->type)) {
 		/* register containing pointer is being spilled into stack */
 		if (size != BPF_REG_SIZE) {
 			verbose(env, "invalid size of register spill\n");
 			return -EACCES;
 		}
 
-		if (state != cur && type == PTR_TO_STACK) {
+		if (state != cur && reg->type == PTR_TO_STACK) {
 			verbose(env, "cannot spill pointers to stack into stack frame of the caller\n");
 			return -EINVAL;
 		}
 
-		/* save register state */
-		state->stack[spi].spilled_ptr = cur->regs[value_regno];
-		state->stack[spi].spilled_ptr.live |= REG_LIVE_WRITTEN;
-
-		for (i = 0; i < BPF_REG_SIZE; i++) {
-			if (state->stack[spi].slot_type[i] == STACK_MISC &&
-			    !env->allow_ptr_leaks) {
+		if (!env->allow_ptr_leaks) {
+			bool sanitize = false;
+
+			if (state->stack[spi].slot_type[0] == STACK_SPILL &&
+			    register_is_const(&state->stack[spi].spilled_ptr))
+				sanitize = true;
+			for (i = 0; i < BPF_REG_SIZE; i++)
+				if (state->stack[spi].slot_type[i] == STACK_MISC) {
+					sanitize = true;
+					break;
+				}
+			if (sanitize) {
 				int *poff = &env->insn_aux_data[insn_idx].sanitize_stack_off;
 				int soff = (-spi - 1) * BPF_REG_SIZE;
 
@@ -1032,8 +1058,8 @@ static int check_stack_write(struct bpf_
 				}
 				*poff = soff;
 			}
-			state->stack[spi].slot_type[i] = STACK_SPILL;
 		}
+		save_register_state(state, spi, reg);
 	} else {
 		u8 type = STACK_MISC;
 
@@ -1056,8 +1082,7 @@ static int check_stack_write(struct bpf_
 			state->stack[spi].spilled_ptr.live |= REG_LIVE_WRITTEN;
 
 		/* when we zero initialize stack slots mark them as such */
-		if (value_regno >= 0 &&
-		    register_is_null(&cur->regs[value_regno]))
+		if (reg && register_is_null(reg))
 			type = STACK_ZERO;
 
 		/* Mark slots affected by this stack write. */
@@ -1075,6 +1100,7 @@ static int check_stack_read(struct bpf_v
 	struct bpf_verifier_state *vstate = env->cur_state;
 	struct bpf_func_state *state = vstate->frame[vstate->curframe];
 	int i, slot = -off - 1, spi = slot / BPF_REG_SIZE;
+	struct bpf_reg_state *reg;
 	u8 *stype;
 
 	if (reg_state->allocated_stack <= slot) {
@@ -1083,11 +1109,20 @@ static int check_stack_read(struct bpf_v
 		return -EACCES;
 	}
 	stype = reg_state->stack[spi].slot_type;
+	reg = &reg_state->stack[spi].spilled_ptr;
 
 	if (stype[0] == STACK_SPILL) {
 		if (size != BPF_REG_SIZE) {
-			verbose(env, "invalid size of register spill\n");
-			return -EACCES;
+			if (reg->type != SCALAR_VALUE) {
+				verbose(env, "invalid size of register fill\n");
+				return -EACCES;
+			}
+			if (value_regno >= 0) {
+				mark_reg_unknown(env, state->regs, value_regno);
+				state->regs[value_regno].live |= REG_LIVE_WRITTEN;
+			}
+			mark_reg_read(env, reg, reg->parent);
+			return 0;
 		}
 		for (i = 1; i < BPF_REG_SIZE; i++) {
 			if (stype[(slot - i) % BPF_REG_SIZE] != STACK_SPILL) {
@@ -1098,16 +1133,14 @@ static int check_stack_read(struct bpf_v
 
 		if (value_regno >= 0) {
 			/* restore register state from stack */
-			state->regs[value_regno] = reg_state->stack[spi].spilled_ptr;
+			state->regs[value_regno] = *reg;
 			/* mark reg as written since spilled pointer state likely
 			 * has its liveness marks cleared by is_state_visited()
 			 * which resets stack/reg liveness for state transitions
 			 */
 			state->regs[value_regno].live |= REG_LIVE_WRITTEN;
 		}
-		mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
-			      reg_state->stack[spi].spilled_ptr.parent);
-		return 0;
+		mark_reg_read(env, reg, reg->parent);
 	} else {
 		int zeros = 0;
 
@@ -1122,8 +1155,7 @@ static int check_stack_read(struct bpf_v
 				off, i, size);
 			return -EACCES;
 		}
-		mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
-			      reg_state->stack[spi].spilled_ptr.parent);
+		mark_reg_read(env, reg, reg->parent);
 		if (value_regno >= 0) {
 			if (zeros == size) {
 				/* any size read into register is zero extended,
@@ -1136,8 +1168,8 @@ static int check_stack_read(struct bpf_v
 			}
 			state->regs[value_regno].live |= REG_LIVE_WRITTEN;
 		}
-		return 0;
 	}
+	return 0;
 }
 
 static int check_stack_access(struct bpf_verifier_env *env,
@@ -1790,7 +1822,7 @@ static int check_stack_boundary(struct b
 {
 	struct bpf_reg_state *reg = cur_regs(env) + regno;
 	struct bpf_func_state *state = func(env, reg);
-	int err, min_off, max_off, i, slot, spi;
+	int err, min_off, max_off, i, j, slot, spi;
 
 	if (reg->type != PTR_TO_STACK) {
 		/* Allow zero-byte read from NULL, regardless of pointer type */
@@ -1878,6 +1910,14 @@ static int check_stack_boundary(struct b
 			*stype = STACK_MISC;
 			goto mark;
 		}
+		if (state->stack[spi].slot_type[0] == STACK_SPILL &&
+		    state->stack[spi].spilled_ptr.type == SCALAR_VALUE) {
+			__mark_reg_unknown(&state->stack[spi].spilled_ptr);
+			for (j = 0; j < BPF_REG_SIZE; j++)
+				state->stack[spi].slot_type[j] = STACK_MISC;
+			goto mark;
+		}
+
 err:
 		if (tnum_is_const(reg->var_off)) {
 			verbose(env, "invalid indirect read from stack off %d+%d size %d\n",


