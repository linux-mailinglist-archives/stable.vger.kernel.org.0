Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881FC36AE49
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbhDZHnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:43:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233389AbhDZHls (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:41:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04EAB61363;
        Mon, 26 Apr 2021 07:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422742;
        bh=yqYtQgLY8OhOASUyen2z8VE+ivmR9a8RmF8A0zjtACw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0qNLocaPiFljQa/o19NrpFxERaDH5rEgGvMebCC9T5QOeMPfQ7qtrT9DbFQm1sxXa
         DlRxNbUcJKagkaaVL0+KzTlLDuWvOlpE7E0hE7IuQaE/N5AfLjiQNFltmmDaEcp0PZ
         s/v0Ir+dVV0rwxm5tJuqOJUBVACeM0JAD+LE0+y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrei Matei <andreimatei1@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 10/36] bpf: Allow variable-offset stack access
Date:   Mon, 26 Apr 2021 09:29:52 +0200
Message-Id: <20210426072819.147955757@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
References: <20210426072818.777662399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Matei <andreimatei1@gmail.com>

[ Upstream commit 01f810ace9ed37255f27608a0864abebccf0aab3 ]

Before this patch, variable offset access to the stack was dissalowed
for regular instructions, but was allowed for "indirect" accesses (i.e.
helpers). This patch removes the restriction, allowing reading and
writing to the stack through stack pointers with variable offsets. This
makes stack-allocated buffers more usable in programs, and brings stack
pointers closer to other types of pointers.

The motivation is being able to use stack-allocated buffers for data
manipulation. When the stack size limit is sufficient, allocating
buffers on the stack is simpler than per-cpu arrays, or other
alternatives.

In unpriviledged programs, variable-offset reads and writes are
disallowed (they were already disallowed for the indirect access case)
because the speculative execution checking code doesn't support them.
Additionally, when writing through a variable-offset stack pointer, if
any pointers are in the accessible range, there's possilibities of later
leaking pointers because the write cannot be tracked precisely.

Writes with variable offset mark the whole range as initialized, even
though we don't know which stack slots are actually written. This is in
order to not reject future reads to these slots. Note that this doesn't
affect writes done through helpers; like before, helpers need the whole
stack range to be initialized to begin with.
All the stack slots are in range are considered scalars after the write;
variable-offset register spills are not tracked.

For reads, all the stack slots in the variable range needs to be
initialized (but see above about what writes do), otherwise the read is
rejected. All register spilled in stack slots that might be read are
marked as having been read, however reads through such pointers don't do
register filling; the target register will always be either a scalar or
a constant zero.

Signed-off-by: Andrei Matei <andreimatei1@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210207011027.676572-2-andreimatei1@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h          |   5 +
 include/linux/bpf_verifier.h |   3 +-
 kernel/bpf/verifier.c        | 657 +++++++++++++++++++++++++++--------
 3 files changed, 518 insertions(+), 147 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index b416bba3a62b..8ad819132dde 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1259,6 +1259,11 @@ static inline bool bpf_allow_ptr_leaks(void)
 	return perfmon_capable();
 }
 
+static inline bool bpf_allow_uninit_stack(void)
+{
+	return perfmon_capable();
+}
+
 static inline bool bpf_allow_ptr_to_map_access(void)
 {
 	return perfmon_capable();
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index e83ef6f6bf43..85bac3191e12 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -187,7 +187,7 @@ struct bpf_func_state {
 	 * 0 = main function, 1 = first callee.
 	 */
 	u32 frameno;
-	/* subprog number == index within subprog_stack_depth
+	/* subprog number == index within subprog_info
 	 * zero == main subprog
 	 */
 	u32 subprogno;
@@ -390,6 +390,7 @@ struct bpf_verifier_env {
 	u32 used_map_cnt;		/* number of used maps */
 	u32 id_gen;			/* used to generate unique reg IDs */
 	bool allow_ptr_leaks;
+	bool allow_uninit_stack;
 	bool allow_ptr_to_map_access;
 	bool bpf_capable;
 	bool bypass_spec_v1;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2e09e691a6be..94923c2bdd81 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2268,12 +2268,14 @@ static void save_register_state(struct bpf_func_state *state,
 		state->stack[spi].slot_type[i] = STACK_SPILL;
 }
 
-/* check_stack_read/write functions track spill/fill of registers,
+/* check_stack_{read,write}_fixed_off functions track spill/fill of registers,
  * stack boundary and alignment are checked in check_mem_access()
  */
-static int check_stack_write(struct bpf_verifier_env *env,
-			     struct bpf_func_state *state, /* func where register points to */
-			     int off, int size, int value_regno, int insn_idx)
+static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
+				       /* stack frame we're writing to */
+				       struct bpf_func_state *state,
+				       int off, int size, int value_regno,
+				       int insn_idx)
 {
 	struct bpf_func_state *cur; /* state of the current function */
 	int i, slot = -off - 1, spi = slot / BPF_REG_SIZE, err;
@@ -2399,9 +2401,175 @@ static int check_stack_write(struct bpf_verifier_env *env,
 	return 0;
 }
 
-static int check_stack_read(struct bpf_verifier_env *env,
-			    struct bpf_func_state *reg_state /* func where register points to */,
-			    int off, int size, int value_regno)
+/* Write the stack: 'stack[ptr_regno + off] = value_regno'. 'ptr_regno' is
+ * known to contain a variable offset.
+ * This function checks whether the write is permitted and conservatively
+ * tracks the effects of the write, considering that each stack slot in the
+ * dynamic range is potentially written to.
+ *
+ * 'off' includes 'regno->off'.
+ * 'value_regno' can be -1, meaning that an unknown value is being written to
+ * the stack.
+ *
+ * Spilled pointers in range are not marked as written because we don't know
+ * what's going to be actually written. This means that read propagation for
+ * future reads cannot be terminated by this write.
+ *
+ * For privileged programs, uninitialized stack slots are considered
+ * initialized by this write (even though we don't know exactly what offsets
+ * are going to be written to). The idea is that we don't want the verifier to
+ * reject future reads that access slots written to through variable offsets.
+ */
+static int check_stack_write_var_off(struct bpf_verifier_env *env,
+				     /* func where register points to */
+				     struct bpf_func_state *state,
+				     int ptr_regno, int off, int size,
+				     int value_regno, int insn_idx)
+{
+	struct bpf_func_state *cur; /* state of the current function */
+	int min_off, max_off;
+	int i, err;
+	struct bpf_reg_state *ptr_reg = NULL, *value_reg = NULL;
+	bool writing_zero = false;
+	/* set if the fact that we're writing a zero is used to let any
+	 * stack slots remain STACK_ZERO
+	 */
+	bool zero_used = false;
+
+	cur = env->cur_state->frame[env->cur_state->curframe];
+	ptr_reg = &cur->regs[ptr_regno];
+	min_off = ptr_reg->smin_value + off;
+	max_off = ptr_reg->smax_value + off + size;
+	if (value_regno >= 0)
+		value_reg = &cur->regs[value_regno];
+	if (value_reg && register_is_null(value_reg))
+		writing_zero = true;
+
+	err = realloc_func_state(state, round_up(-min_off, BPF_REG_SIZE),
+				 state->acquired_refs, true);
+	if (err)
+		return err;
+
+
+	/* Variable offset writes destroy any spilled pointers in range. */
+	for (i = min_off; i < max_off; i++) {
+		u8 new_type, *stype;
+		int slot, spi;
+
+		slot = -i - 1;
+		spi = slot / BPF_REG_SIZE;
+		stype = &state->stack[spi].slot_type[slot % BPF_REG_SIZE];
+
+		if (!env->allow_ptr_leaks
+				&& *stype != NOT_INIT
+				&& *stype != SCALAR_VALUE) {
+			/* Reject the write if there's are spilled pointers in
+			 * range. If we didn't reject here, the ptr status
+			 * would be erased below (even though not all slots are
+			 * actually overwritten), possibly opening the door to
+			 * leaks.
+			 */
+			verbose(env, "spilled ptr in range of var-offset stack write; insn %d, ptr off: %d",
+				insn_idx, i);
+			return -EINVAL;
+		}
+
+		/* Erase all spilled pointers. */
+		state->stack[spi].spilled_ptr.type = NOT_INIT;
+
+		/* Update the slot type. */
+		new_type = STACK_MISC;
+		if (writing_zero && *stype == STACK_ZERO) {
+			new_type = STACK_ZERO;
+			zero_used = true;
+		}
+		/* If the slot is STACK_INVALID, we check whether it's OK to
+		 * pretend that it will be initialized by this write. The slot
+		 * might not actually be written to, and so if we mark it as
+		 * initialized future reads might leak uninitialized memory.
+		 * For privileged programs, we will accept such reads to slots
+		 * that may or may not be written because, if we're reject
+		 * them, the error would be too confusing.
+		 */
+		if (*stype == STACK_INVALID && !env->allow_uninit_stack) {
+			verbose(env, "uninit stack in range of var-offset write prohibited for !root; insn %d, off: %d",
+					insn_idx, i);
+			return -EINVAL;
+		}
+		*stype = new_type;
+	}
+	if (zero_used) {
+		/* backtracking doesn't work for STACK_ZERO yet. */
+		err = mark_chain_precision(env, value_regno);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+/* When register 'dst_regno' is assigned some values from stack[min_off,
+ * max_off), we set the register's type according to the types of the
+ * respective stack slots. If all the stack values are known to be zeros, then
+ * so is the destination reg. Otherwise, the register is considered to be
+ * SCALAR. This function does not deal with register filling; the caller must
+ * ensure that all spilled registers in the stack range have been marked as
+ * read.
+ */
+static void mark_reg_stack_read(struct bpf_verifier_env *env,
+				/* func where src register points to */
+				struct bpf_func_state *ptr_state,
+				int min_off, int max_off, int dst_regno)
+{
+	struct bpf_verifier_state *vstate = env->cur_state;
+	struct bpf_func_state *state = vstate->frame[vstate->curframe];
+	int i, slot, spi;
+	u8 *stype;
+	int zeros = 0;
+
+	for (i = min_off; i < max_off; i++) {
+		slot = -i - 1;
+		spi = slot / BPF_REG_SIZE;
+		stype = ptr_state->stack[spi].slot_type;
+		if (stype[slot % BPF_REG_SIZE] != STACK_ZERO)
+			break;
+		zeros++;
+	}
+	if (zeros == max_off - min_off) {
+		/* any access_size read into register is zero extended,
+		 * so the whole register == const_zero
+		 */
+		__mark_reg_const_zero(&state->regs[dst_regno]);
+		/* backtracking doesn't support STACK_ZERO yet,
+		 * so mark it precise here, so that later
+		 * backtracking can stop here.
+		 * Backtracking may not need this if this register
+		 * doesn't participate in pointer adjustment.
+		 * Forward propagation of precise flag is not
+		 * necessary either. This mark is only to stop
+		 * backtracking. Any register that contributed
+		 * to const 0 was marked precise before spill.
+		 */
+		state->regs[dst_regno].precise = true;
+	} else {
+		/* have read misc data from the stack */
+		mark_reg_unknown(env, state->regs, dst_regno);
+	}
+	state->regs[dst_regno].live |= REG_LIVE_WRITTEN;
+}
+
+/* Read the stack at 'off' and put the results into the register indicated by
+ * 'dst_regno'. It handles reg filling if the addressed stack slot is a
+ * spilled reg.
+ *
+ * 'dst_regno' can be -1, meaning that the read value is not going to a
+ * register.
+ *
+ * The access is assumed to be within the current stack bounds.
+ */
+static int check_stack_read_fixed_off(struct bpf_verifier_env *env,
+				      /* func where src register points to */
+				      struct bpf_func_state *reg_state,
+				      int off, int size, int dst_regno)
 {
 	struct bpf_verifier_state *vstate = env->cur_state;
 	struct bpf_func_state *state = vstate->frame[vstate->curframe];
@@ -2409,11 +2577,6 @@ static int check_stack_read(struct bpf_verifier_env *env,
 	struct bpf_reg_state *reg;
 	u8 *stype;
 
-	if (reg_state->allocated_stack <= slot) {
-		verbose(env, "invalid read from stack off %d+0 size %d\n",
-			off, size);
-		return -EACCES;
-	}
 	stype = reg_state->stack[spi].slot_type;
 	reg = &reg_state->stack[spi].spilled_ptr;
 
@@ -2424,9 +2587,9 @@ static int check_stack_read(struct bpf_verifier_env *env,
 				verbose(env, "invalid size of register fill\n");
 				return -EACCES;
 			}
-			if (value_regno >= 0) {
-				mark_reg_unknown(env, state->regs, value_regno);
-				state->regs[value_regno].live |= REG_LIVE_WRITTEN;
+			if (dst_regno >= 0) {
+				mark_reg_unknown(env, state->regs, dst_regno);
+				state->regs[dst_regno].live |= REG_LIVE_WRITTEN;
 			}
 			mark_reg_read(env, reg, reg->parent, REG_LIVE_READ64);
 			return 0;
@@ -2438,16 +2601,16 @@ static int check_stack_read(struct bpf_verifier_env *env,
 			}
 		}
 
-		if (value_regno >= 0) {
+		if (dst_regno >= 0) {
 			/* restore register state from stack */
-			state->regs[value_regno] = *reg;
+			state->regs[dst_regno] = *reg;
 			/* mark reg as written since spilled pointer state likely
 			 * has its liveness marks cleared by is_state_visited()
 			 * which resets stack/reg liveness for state transitions
 			 */
-			state->regs[value_regno].live |= REG_LIVE_WRITTEN;
+			state->regs[dst_regno].live |= REG_LIVE_WRITTEN;
 		} else if (__is_pointer_value(env->allow_ptr_leaks, reg)) {
-			/* If value_regno==-1, the caller is asking us whether
+			/* If dst_regno==-1, the caller is asking us whether
 			 * it is acceptable to use this value as a SCALAR_VALUE
 			 * (e.g. for XADD).
 			 * We must not allow unprivileged callers to do that
@@ -2459,70 +2622,167 @@ static int check_stack_read(struct bpf_verifier_env *env,
 		}
 		mark_reg_read(env, reg, reg->parent, REG_LIVE_READ64);
 	} else {
-		int zeros = 0;
+		u8 type;
 
 		for (i = 0; i < size; i++) {
-			if (stype[(slot - i) % BPF_REG_SIZE] == STACK_MISC)
+			type = stype[(slot - i) % BPF_REG_SIZE];
+			if (type == STACK_MISC)
 				continue;
-			if (stype[(slot - i) % BPF_REG_SIZE] == STACK_ZERO) {
-				zeros++;
+			if (type == STACK_ZERO)
 				continue;
-			}
 			verbose(env, "invalid read from stack off %d+%d size %d\n",
 				off, i, size);
 			return -EACCES;
 		}
 		mark_reg_read(env, reg, reg->parent, REG_LIVE_READ64);
-		if (value_regno >= 0) {
-			if (zeros == size) {
-				/* any size read into register is zero extended,
-				 * so the whole register == const_zero
-				 */
-				__mark_reg_const_zero(&state->regs[value_regno]);
-				/* backtracking doesn't support STACK_ZERO yet,
-				 * so mark it precise here, so that later
-				 * backtracking can stop here.
-				 * Backtracking may not need this if this register
-				 * doesn't participate in pointer adjustment.
-				 * Forward propagation of precise flag is not
-				 * necessary either. This mark is only to stop
-				 * backtracking. Any register that contributed
-				 * to const 0 was marked precise before spill.
-				 */
-				state->regs[value_regno].precise = true;
-			} else {
-				/* have read misc data from the stack */
-				mark_reg_unknown(env, state->regs, value_regno);
-			}
-			state->regs[value_regno].live |= REG_LIVE_WRITTEN;
-		}
+		if (dst_regno >= 0)
+			mark_reg_stack_read(env, reg_state, off, off + size, dst_regno);
 	}
 	return 0;
 }
 
-static int check_stack_access(struct bpf_verifier_env *env,
-			      const struct bpf_reg_state *reg,
-			      int off, int size)
+enum stack_access_src {
+	ACCESS_DIRECT = 1,  /* the access is performed by an instruction */
+	ACCESS_HELPER = 2,  /* the access is performed by a helper */
+};
+
+static int check_stack_range_initialized(struct bpf_verifier_env *env,
+					 int regno, int off, int access_size,
+					 bool zero_size_allowed,
+					 enum stack_access_src type,
+					 struct bpf_call_arg_meta *meta);
+
+static struct bpf_reg_state *reg_state(struct bpf_verifier_env *env, int regno)
+{
+	return cur_regs(env) + regno;
+}
+
+/* Read the stack at 'ptr_regno + off' and put the result into the register
+ * 'dst_regno'.
+ * 'off' includes the pointer register's fixed offset(i.e. 'ptr_regno.off'),
+ * but not its variable offset.
+ * 'size' is assumed to be <= reg size and the access is assumed to be aligned.
+ *
+ * As opposed to check_stack_read_fixed_off, this function doesn't deal with
+ * filling registers (i.e. reads of spilled register cannot be detected when
+ * the offset is not fixed). We conservatively mark 'dst_regno' as containing
+ * SCALAR_VALUE. That's why we assert that the 'ptr_regno' has a variable
+ * offset; for a fixed offset check_stack_read_fixed_off should be used
+ * instead.
+ */
+static int check_stack_read_var_off(struct bpf_verifier_env *env,
+				    int ptr_regno, int off, int size, int dst_regno)
 {
-	/* Stack accesses must be at a fixed offset, so that we
-	 * can determine what type of data were returned. See
-	 * check_stack_read().
+	/* The state of the source register. */
+	struct bpf_reg_state *reg = reg_state(env, ptr_regno);
+	struct bpf_func_state *ptr_state = func(env, reg);
+	int err;
+	int min_off, max_off;
+
+	/* Note that we pass a NULL meta, so raw access will not be permitted.
 	 */
-	if (!tnum_is_const(reg->var_off)) {
+	err = check_stack_range_initialized(env, ptr_regno, off, size,
+					    false, ACCESS_DIRECT, NULL);
+	if (err)
+		return err;
+
+	min_off = reg->smin_value + off;
+	max_off = reg->smax_value + off;
+	mark_reg_stack_read(env, ptr_state, min_off, max_off + size, dst_regno);
+	return 0;
+}
+
+/* check_stack_read dispatches to check_stack_read_fixed_off or
+ * check_stack_read_var_off.
+ *
+ * The caller must ensure that the offset falls within the allocated stack
+ * bounds.
+ *
+ * 'dst_regno' is a register which will receive the value from the stack. It
+ * can be -1, meaning that the read value is not going to a register.
+ */
+static int check_stack_read(struct bpf_verifier_env *env,
+			    int ptr_regno, int off, int size,
+			    int dst_regno)
+{
+	struct bpf_reg_state *reg = reg_state(env, ptr_regno);
+	struct bpf_func_state *state = func(env, reg);
+	int err;
+	/* Some accesses are only permitted with a static offset. */
+	bool var_off = !tnum_is_const(reg->var_off);
+
+	/* The offset is required to be static when reads don't go to a
+	 * register, in order to not leak pointers (see
+	 * check_stack_read_fixed_off).
+	 */
+	if (dst_regno < 0 && var_off) {
 		char tn_buf[48];
 
 		tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
-		verbose(env, "variable stack access var_off=%s off=%d size=%d\n",
+		verbose(env, "variable offset stack pointer cannot be passed into helper function; var_off=%s off=%d size=%d\n",
 			tn_buf, off, size);
 		return -EACCES;
 	}
+	/* Variable offset is prohibited for unprivileged mode for simplicity
+	 * since it requires corresponding support in Spectre masking for stack
+	 * ALU. See also retrieve_ptr_limit().
+	 */
+	if (!env->bypass_spec_v1 && var_off) {
+		char tn_buf[48];
 
-	if (off >= 0 || off < -MAX_BPF_STACK) {
-		verbose(env, "invalid stack off=%d size=%d\n", off, size);
+		tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
+		verbose(env, "R%d variable offset stack access prohibited for !root, var_off=%s\n",
+				ptr_regno, tn_buf);
 		return -EACCES;
 	}
 
-	return 0;
+	if (!var_off) {
+		off += reg->var_off.value;
+		err = check_stack_read_fixed_off(env, state, off, size,
+						 dst_regno);
+	} else {
+		/* Variable offset stack reads need more conservative handling
+		 * than fixed offset ones. Note that dst_regno >= 0 on this
+		 * branch.
+		 */
+		err = check_stack_read_var_off(env, ptr_regno, off, size,
+					       dst_regno);
+	}
+	return err;
+}
+
+
+/* check_stack_write dispatches to check_stack_write_fixed_off or
+ * check_stack_write_var_off.
+ *
+ * 'ptr_regno' is the register used as a pointer into the stack.
+ * 'off' includes 'ptr_regno->off', but not its variable offset (if any).
+ * 'value_regno' is the register whose value we're writing to the stack. It can
+ * be -1, meaning that we're not writing from a register.
+ *
+ * The caller must ensure that the offset falls within the maximum stack size.
+ */
+static int check_stack_write(struct bpf_verifier_env *env,
+			     int ptr_regno, int off, int size,
+			     int value_regno, int insn_idx)
+{
+	struct bpf_reg_state *reg = reg_state(env, ptr_regno);
+	struct bpf_func_state *state = func(env, reg);
+	int err;
+
+	if (tnum_is_const(reg->var_off)) {
+		off += reg->var_off.value;
+		err = check_stack_write_fixed_off(env, state, off, size,
+						  value_regno, insn_idx);
+	} else {
+		/* Variable offset stack reads need more conservative handling
+		 * than fixed offset ones.
+		 */
+		err = check_stack_write_var_off(env, state,
+						ptr_regno, off, size,
+						value_regno, insn_idx);
+	}
+	return err;
 }
 
 static int check_map_access_type(struct bpf_verifier_env *env, u32 regno,
@@ -2851,11 +3111,6 @@ static int check_sock_access(struct bpf_verifier_env *env, int insn_idx,
 	return -EACCES;
 }
 
-static struct bpf_reg_state *reg_state(struct bpf_verifier_env *env, int regno)
-{
-	return cur_regs(env) + regno;
-}
-
 static bool is_pointer_value(struct bpf_verifier_env *env, int regno)
 {
 	return __is_pointer_value(env->allow_ptr_leaks, reg_state(env, regno));
@@ -2974,8 +3229,8 @@ static int check_ptr_alignment(struct bpf_verifier_env *env,
 		break;
 	case PTR_TO_STACK:
 		pointer_desc = "stack ";
-		/* The stack spill tracking logic in check_stack_write()
-		 * and check_stack_read() relies on stack accesses being
+		/* The stack spill tracking logic in check_stack_write_fixed_off()
+		 * and check_stack_read_fixed_off() relies on stack accesses being
 		 * aligned.
 		 */
 		strict = true;
@@ -3393,6 +3648,91 @@ static int check_ptr_to_map_access(struct bpf_verifier_env *env,
 	return 0;
 }
 
+/* Check that the stack access at the given offset is within bounds. The
+ * maximum valid offset is -1.
+ *
+ * The minimum valid offset is -MAX_BPF_STACK for writes, and
+ * -state->allocated_stack for reads.
+ */
+static int check_stack_slot_within_bounds(int off,
+					  struct bpf_func_state *state,
+					  enum bpf_access_type t)
+{
+	int min_valid_off;
+
+	if (t == BPF_WRITE)
+		min_valid_off = -MAX_BPF_STACK;
+	else
+		min_valid_off = -state->allocated_stack;
+
+	if (off < min_valid_off || off > -1)
+		return -EACCES;
+	return 0;
+}
+
+/* Check that the stack access at 'regno + off' falls within the maximum stack
+ * bounds.
+ *
+ * 'off' includes `regno->offset`, but not its dynamic part (if any).
+ */
+static int check_stack_access_within_bounds(
+		struct bpf_verifier_env *env,
+		int regno, int off, int access_size,
+		enum stack_access_src src, enum bpf_access_type type)
+{
+	struct bpf_reg_state *regs = cur_regs(env);
+	struct bpf_reg_state *reg = regs + regno;
+	struct bpf_func_state *state = func(env, reg);
+	int min_off, max_off;
+	int err;
+	char *err_extra;
+
+	if (src == ACCESS_HELPER)
+		/* We don't know if helpers are reading or writing (or both). */
+		err_extra = " indirect access to";
+	else if (type == BPF_READ)
+		err_extra = " read from";
+	else
+		err_extra = " write to";
+
+	if (tnum_is_const(reg->var_off)) {
+		min_off = reg->var_off.value + off;
+		if (access_size > 0)
+			max_off = min_off + access_size - 1;
+		else
+			max_off = min_off;
+	} else {
+		if (reg->smax_value >= BPF_MAX_VAR_OFF ||
+		    reg->smin_value <= -BPF_MAX_VAR_OFF) {
+			verbose(env, "invalid unbounded variable-offset%s stack R%d\n",
+				err_extra, regno);
+			return -EACCES;
+		}
+		min_off = reg->smin_value + off;
+		if (access_size > 0)
+			max_off = reg->smax_value + off + access_size - 1;
+		else
+			max_off = min_off;
+	}
+
+	err = check_stack_slot_within_bounds(min_off, state, type);
+	if (!err)
+		err = check_stack_slot_within_bounds(max_off, state, type);
+
+	if (err) {
+		if (tnum_is_const(reg->var_off)) {
+			verbose(env, "invalid%s stack R%d off=%d size=%d\n",
+				err_extra, regno, off, access_size);
+		} else {
+			char tn_buf[48];
+
+			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
+			verbose(env, "invalid variable-offset%s stack R%d var_off=%s size=%d\n",
+				err_extra, regno, tn_buf, access_size);
+		}
+	}
+	return err;
+}
 
 /* check whether memory at (regno + off) is accessible for t = (read | write)
  * if t==write, value_regno is a register which value is stored into memory
@@ -3505,8 +3845,8 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 		}
 
 	} else if (reg->type == PTR_TO_STACK) {
-		off += reg->var_off.value;
-		err = check_stack_access(env, reg, off, size);
+		/* Basic bounds checks. */
+		err = check_stack_access_within_bounds(env, regno, off, size, ACCESS_DIRECT, t);
 		if (err)
 			return err;
 
@@ -3515,12 +3855,12 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 		if (err)
 			return err;
 
-		if (t == BPF_WRITE)
-			err = check_stack_write(env, state, off, size,
-						value_regno, insn_idx);
-		else
-			err = check_stack_read(env, state, off, size,
+		if (t == BPF_READ)
+			err = check_stack_read(env, regno, off, size,
 					       value_regno);
+		else
+			err = check_stack_write(env, regno, off, size,
+						value_regno, insn_idx);
 	} else if (reg_is_pkt_pointer(reg)) {
 		if (t == BPF_WRITE && !may_access_direct_pkt_data(env, NULL, t)) {
 			verbose(env, "cannot write into packet\n");
@@ -3642,49 +3982,53 @@ static int check_xadd(struct bpf_verifier_env *env, int insn_idx, struct bpf_ins
 				BPF_SIZE(insn->code), BPF_WRITE, -1, true);
 }
 
-static int __check_stack_boundary(struct bpf_verifier_env *env, u32 regno,
-				  int off, int access_size,
-				  bool zero_size_allowed)
+/* When register 'regno' is used to read the stack (either directly or through
+ * a helper function) make sure that it's within stack boundary and, depending
+ * on the access type, that all elements of the stack are initialized.
+ *
+ * 'off' includes 'regno->off', but not its dynamic part (if any).
+ *
+ * All registers that have been spilled on the stack in the slots within the
+ * read offsets are marked as read.
+ */
+static int check_stack_range_initialized(
+		struct bpf_verifier_env *env, int regno, int off,
+		int access_size, bool zero_size_allowed,
+		enum stack_access_src type, struct bpf_call_arg_meta *meta)
 {
 	struct bpf_reg_state *reg = reg_state(env, regno);
+	struct bpf_func_state *state = func(env, reg);
+	int err, min_off, max_off, i, j, slot, spi;
+	char *err_extra = type == ACCESS_HELPER ? " indirect" : "";
+	enum bpf_access_type bounds_check_type;
+	/* Some accesses can write anything into the stack, others are
+	 * read-only.
+	 */
+	bool clobber = false;
 
-	if (off >= 0 || off < -MAX_BPF_STACK || off + access_size > 0 ||
-	    access_size < 0 || (access_size == 0 && !zero_size_allowed)) {
-		if (tnum_is_const(reg->var_off)) {
-			verbose(env, "invalid stack type R%d off=%d access_size=%d\n",
-				regno, off, access_size);
-		} else {
-			char tn_buf[48];
-
-			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
-			verbose(env, "invalid stack type R%d var_off=%s access_size=%d\n",
-				regno, tn_buf, access_size);
-		}
+	if (access_size == 0 && !zero_size_allowed) {
+		verbose(env, "invalid zero-sized read\n");
 		return -EACCES;
 	}
-	return 0;
-}
 
-/* when register 'regno' is passed into function that will read 'access_size'
- * bytes from that pointer, make sure that it's within stack boundary
- * and all elements of stack are initialized.
- * Unlike most pointer bounds-checking functions, this one doesn't take an
- * 'off' argument, so it has to add in reg->off itself.
- */
-static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
-				int access_size, bool zero_size_allowed,
-				struct bpf_call_arg_meta *meta)
-{
-	struct bpf_reg_state *reg = reg_state(env, regno);
-	struct bpf_func_state *state = func(env, reg);
-	int err, min_off, max_off, i, j, slot, spi;
+	if (type == ACCESS_HELPER) {
+		/* The bounds checks for writes are more permissive than for
+		 * reads. However, if raw_mode is not set, we'll do extra
+		 * checks below.
+		 */
+		bounds_check_type = BPF_WRITE;
+		clobber = true;
+	} else {
+		bounds_check_type = BPF_READ;
+	}
+	err = check_stack_access_within_bounds(env, regno, off, access_size,
+					       type, bounds_check_type);
+	if (err)
+		return err;
+
 
 	if (tnum_is_const(reg->var_off)) {
-		min_off = max_off = reg->var_off.value + reg->off;
-		err = __check_stack_boundary(env, regno, min_off, access_size,
-					     zero_size_allowed);
-		if (err)
-			return err;
+		min_off = max_off = reg->var_off.value + off;
 	} else {
 		/* Variable offset is prohibited for unprivileged mode for
 		 * simplicity since it requires corresponding support in
@@ -3695,8 +4039,8 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 			char tn_buf[48];
 
 			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
-			verbose(env, "R%d indirect variable offset stack access prohibited for !root, var_off=%s\n",
-				regno, tn_buf);
+			verbose(env, "R%d%s variable offset stack access prohibited for !root, var_off=%s\n",
+				regno, err_extra, tn_buf);
 			return -EACCES;
 		}
 		/* Only initialized buffer on stack is allowed to be accessed
@@ -3708,28 +4052,8 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 		if (meta && meta->raw_mode)
 			meta = NULL;
 
-		if (reg->smax_value >= BPF_MAX_VAR_OFF ||
-		    reg->smax_value <= -BPF_MAX_VAR_OFF) {
-			verbose(env, "R%d unbounded indirect variable offset stack access\n",
-				regno);
-			return -EACCES;
-		}
-		min_off = reg->smin_value + reg->off;
-		max_off = reg->smax_value + reg->off;
-		err = __check_stack_boundary(env, regno, min_off, access_size,
-					     zero_size_allowed);
-		if (err) {
-			verbose(env, "R%d min value is outside of stack bound\n",
-				regno);
-			return err;
-		}
-		err = __check_stack_boundary(env, regno, max_off, access_size,
-					     zero_size_allowed);
-		if (err) {
-			verbose(env, "R%d max value is outside of stack bound\n",
-				regno);
-			return err;
-		}
+		min_off = reg->smin_value + off;
+		max_off = reg->smax_value + off;
 	}
 
 	if (meta && meta->raw_mode) {
@@ -3749,8 +4073,10 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 		if (*stype == STACK_MISC)
 			goto mark;
 		if (*stype == STACK_ZERO) {
-			/* helper can write anything into the stack */
-			*stype = STACK_MISC;
+			if (clobber) {
+				/* helper can write anything into the stack */
+				*stype = STACK_MISC;
+			}
 			goto mark;
 		}
 
@@ -3761,22 +4087,24 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 		if (state->stack[spi].slot_type[0] == STACK_SPILL &&
 		    (state->stack[spi].spilled_ptr.type == SCALAR_VALUE ||
 		     env->allow_ptr_leaks)) {
-			__mark_reg_unknown(env, &state->stack[spi].spilled_ptr);
-			for (j = 0; j < BPF_REG_SIZE; j++)
-				state->stack[spi].slot_type[j] = STACK_MISC;
+			if (clobber) {
+				__mark_reg_unknown(env, &state->stack[spi].spilled_ptr);
+				for (j = 0; j < BPF_REG_SIZE; j++)
+					state->stack[spi].slot_type[j] = STACK_MISC;
+			}
 			goto mark;
 		}
 
 err:
 		if (tnum_is_const(reg->var_off)) {
-			verbose(env, "invalid indirect read from stack off %d+%d size %d\n",
-				min_off, i - min_off, access_size);
+			verbose(env, "invalid%s read from stack R%d off %d+%d size %d\n",
+				err_extra, regno, min_off, i - min_off, access_size);
 		} else {
 			char tn_buf[48];
 
 			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
-			verbose(env, "invalid indirect read from stack var_off %s+%d size %d\n",
-				tn_buf, i - min_off, access_size);
+			verbose(env, "invalid%s read from stack R%d var_off %s+%d size %d\n",
+				err_extra, regno, tn_buf, i - min_off, access_size);
 		}
 		return -EACCES;
 mark:
@@ -3825,8 +4153,10 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
 					   "rdwr",
 					   &env->prog->aux->max_rdwr_access);
 	case PTR_TO_STACK:
-		return check_stack_boundary(env, regno, access_size,
-					    zero_size_allowed, meta);
+		return check_stack_range_initialized(
+				env,
+				regno, reg->off, access_size,
+				zero_size_allowed, ACCESS_HELPER, meta);
 	default: /* scalar_value or invalid ptr */
 		/* Allow zero-byte read from NULL, regardless of pointer type */
 		if (zero_size_allowed && access_size == 0 &&
@@ -5519,6 +5849,41 @@ static int sanitize_err(struct bpf_verifier_env *env,
 	return -EACCES;
 }
 
+/* check that stack access falls within stack limits and that 'reg' doesn't
+ * have a variable offset.
+ *
+ * Variable offset is prohibited for unprivileged mode for simplicity since it
+ * requires corresponding support in Spectre masking for stack ALU.  See also
+ * retrieve_ptr_limit().
+ *
+ *
+ * 'off' includes 'reg->off'.
+ */
+static int check_stack_access_for_ptr_arithmetic(
+				struct bpf_verifier_env *env,
+				int regno,
+				const struct bpf_reg_state *reg,
+				int off)
+{
+	if (!tnum_is_const(reg->var_off)) {
+		char tn_buf[48];
+
+		tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
+		verbose(env, "R%d variable stack access prohibited for !root, var_off=%s off=%d\n",
+			regno, tn_buf, off);
+		return -EACCES;
+	}
+
+	if (off >= 0 || off < -MAX_BPF_STACK) {
+		verbose(env, "R%d stack pointer arithmetic goes out of range, "
+			"prohibited for !root; off=%d\n", regno, off);
+		return -EACCES;
+	}
+
+	return 0;
+}
+
+
 /* Handles arithmetic on a pointer and a scalar: computes new min/max and var_off.
  * Caller should also handle BPF_MOV case separately.
  * If we return -EACCES, caller may want to try again treating pointer as a
@@ -5753,10 +6118,9 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 				"prohibited for !root\n", dst);
 			return -EACCES;
 		} else if (dst_reg->type == PTR_TO_STACK &&
-			   check_stack_access(env, dst_reg, dst_reg->off +
-					      dst_reg->var_off.value, 1)) {
-			verbose(env, "R%d stack pointer arithmetic goes out of range, "
-				"prohibited for !root\n", dst);
+			   check_stack_access_for_ptr_arithmetic(
+				   env, dst, dst_reg, dst_reg->off +
+				   dst_reg->var_off.value)) {
 			return -EACCES;
 		}
 	}
@@ -11952,6 +12316,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 		env->strict_alignment = false;
 
 	env->allow_ptr_leaks = bpf_allow_ptr_leaks();
+	env->allow_uninit_stack = bpf_allow_uninit_stack();
 	env->allow_ptr_to_map_access = bpf_allow_ptr_to_map_access();
 	env->bypass_spec_v1 = bpf_bypass_spec_v1();
 	env->bypass_spec_v4 = bpf_bypass_spec_v4();
-- 
2.30.2



