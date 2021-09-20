Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66AC411FDF
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349303AbhITRqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348956AbhITRmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:42:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEFDF61B6F;
        Mon, 20 Sep 2021 17:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157735;
        bh=6ugk766FFRvrgwQqRyGsUyklvua9phq5zxoJ5/9HbiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujslHlYrr9KWMCcfyUTsjZz9P66tedmRdmPFIRXDJAp3sTJbi51sTV4AR6DbaToww
         71V5pq3+31RkM844Xyq3XcTd4EaLLHpeVocl5Uk5RKa1AmGRdSQg+N3TNwx6X1jUaO
         l0MIoKQJz0IF4yqQjMMxmoavm48Wr4CR/BcOL4u0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Edward Cree <ecree@solarflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 127/293] bpf/verifier: per-register parent pointers
Date:   Mon, 20 Sep 2021 18:41:29 +0200
Message-Id: <20210920163937.609395197@linuxfoundation.org>
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

From: Edward Cree <ecree@solarflare.com>

commit 679c782de14bd48c19dd74cd1af20a2bc05dd936 upstream.

By giving each register its own liveness chain, we elide the skip_callee()
 logic.  Instead, each register's parent is the state it inherits from;
 both check_func_call() and prepare_func_exit() automatically connect
 reg states to the correct chain since when they copy the reg state across
 (r1-r5 into the callee as args, and r0 out as the return value) they also
 copy the parent pointer.

Signed-off-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[OP: adjusted context for 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf_verifier.h |    8 -
 kernel/bpf/verifier.c        |  183 ++++++++++---------------------------------
 2 files changed, 47 insertions(+), 144 deletions(-)

--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -41,6 +41,7 @@ enum bpf_reg_liveness {
 };
 
 struct bpf_reg_state {
+	/* Ordering of fields matters.  See states_equal() */
 	enum bpf_reg_type type;
 	union {
 		/* valid when type == PTR_TO_PACKET */
@@ -62,7 +63,6 @@ struct bpf_reg_state {
 	 * came from, when one is tested for != NULL.
 	 */
 	u32 id;
-	/* Ordering of fields matters.  See states_equal() */
 	/* For scalar types (SCALAR_VALUE), this represents our knowledge of
 	 * the actual value.
 	 * For pointer types, this represents the variable part of the offset
@@ -79,15 +79,15 @@ struct bpf_reg_state {
 	s64 smax_value; /* maximum possible (s64)value */
 	u64 umin_value; /* minimum possible (u64)value */
 	u64 umax_value; /* maximum possible (u64)value */
+	/* parentage chain for liveness checking */
+	struct bpf_reg_state *parent;
 	/* Inside the callee two registers can be both PTR_TO_STACK like
 	 * R1=fp-8 and R2=fp-8, but one of them points to this function stack
 	 * while another to the caller's stack. To differentiate them 'frameno'
 	 * is used which is an index in bpf_verifier_state->frame[] array
 	 * pointing to bpf_func_state.
-	 * This field must be second to last, for states_equal() reasons.
 	 */
 	u32 frameno;
-	/* This field must be last, for states_equal() reasons. */
 	enum bpf_reg_liveness live;
 };
 
@@ -110,7 +110,6 @@ struct bpf_stack_state {
  */
 struct bpf_func_state {
 	struct bpf_reg_state regs[MAX_BPF_REG];
-	struct bpf_verifier_state *parent;
 	/* index of call instruction that called into this func */
 	int callsite;
 	/* stack frame number of this function state from pov of
@@ -132,7 +131,6 @@ struct bpf_func_state {
 struct bpf_verifier_state {
 	/* call stack tracking */
 	struct bpf_func_state *frame[MAX_CALL_FRAMES];
-	struct bpf_verifier_state *parent;
 	u32 curframe;
 	bool speculative;
 };
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -380,9 +380,9 @@ static int copy_stack_state(struct bpf_f
 /* do_check() starts with zero-sized stack in struct bpf_verifier_state to
  * make it consume minimal amount of memory. check_stack_write() access from
  * the program calls into realloc_func_state() to grow the stack size.
- * Note there is a non-zero 'parent' pointer inside bpf_verifier_state
- * which this function copies over. It points to previous bpf_verifier_state
- * which is never reallocated
+ * Note there is a non-zero parent pointer inside each reg of bpf_verifier_state
+ * which this function copies over. It points to corresponding reg in previous
+ * bpf_verifier_state which is never reallocated
  */
 static int realloc_func_state(struct bpf_func_state *state, int size,
 			      bool copy_old)
@@ -467,7 +467,6 @@ static int copy_verifier_state(struct bp
 	}
 	dst_state->speculative = src->speculative;
 	dst_state->curframe = src->curframe;
-	dst_state->parent = src->parent;
 	for (i = 0; i <= src->curframe; i++) {
 		dst = dst_state->frame[i];
 		if (!dst) {
@@ -739,6 +738,7 @@ static void init_reg_state(struct bpf_ve
 	for (i = 0; i < MAX_BPF_REG; i++) {
 		mark_reg_not_init(env, regs, i);
 		regs[i].live = REG_LIVE_NONE;
+		regs[i].parent = NULL;
 	}
 
 	/* frame pointer */
@@ -883,74 +883,21 @@ next:
 	return 0;
 }
 
-static
-struct bpf_verifier_state *skip_callee(struct bpf_verifier_env *env,
-				       const struct bpf_verifier_state *state,
-				       struct bpf_verifier_state *parent,
-				       u32 regno)
-{
-	struct bpf_verifier_state *tmp = NULL;
-
-	/* 'parent' could be a state of caller and
-	 * 'state' could be a state of callee. In such case
-	 * parent->curframe < state->curframe
-	 * and it's ok for r1 - r5 registers
-	 *
-	 * 'parent' could be a callee's state after it bpf_exit-ed.
-	 * In such case parent->curframe > state->curframe
-	 * and it's ok for r0 only
-	 */
-	if (parent->curframe == state->curframe ||
-	    (parent->curframe < state->curframe &&
-	     regno >= BPF_REG_1 && regno <= BPF_REG_5) ||
-	    (parent->curframe > state->curframe &&
-	       regno == BPF_REG_0))
-		return parent;
-
-	if (parent->curframe > state->curframe &&
-	    regno >= BPF_REG_6) {
-		/* for callee saved regs we have to skip the whole chain
-		 * of states that belong to callee and mark as LIVE_READ
-		 * the registers before the call
-		 */
-		tmp = parent;
-		while (tmp && tmp->curframe != state->curframe) {
-			tmp = tmp->parent;
-		}
-		if (!tmp)
-			goto bug;
-		parent = tmp;
-	} else {
-		goto bug;
-	}
-	return parent;
-bug:
-	verbose(env, "verifier bug regno %d tmp %p\n", regno, tmp);
-	verbose(env, "regno %d parent frame %d current frame %d\n",
-		regno, parent->curframe, state->curframe);
-	return NULL;
-}
-
+/* Parentage chain of this register (or stack slot) should take care of all
+ * issues like callee-saved registers, stack slot allocation time, etc.
+ */
 static int mark_reg_read(struct bpf_verifier_env *env,
-			 const struct bpf_verifier_state *state,
-			 struct bpf_verifier_state *parent,
-			 u32 regno)
+			 const struct bpf_reg_state *state,
+			 struct bpf_reg_state *parent)
 {
 	bool writes = parent == state->parent; /* Observe write marks */
 
-	if (regno == BPF_REG_FP)
-		/* We don't need to worry about FP liveness because it's read-only */
-		return 0;
-
 	while (parent) {
 		/* if read wasn't screened by an earlier write ... */
-		if (writes && state->frame[state->curframe]->regs[regno].live & REG_LIVE_WRITTEN)
+		if (writes && state->live & REG_LIVE_WRITTEN)
 			break;
-		parent = skip_callee(env, state, parent, regno);
-		if (!parent)
-			return -EFAULT;
 		/* ... then we depend on parent's value */
-		parent->frame[parent->curframe]->regs[regno].live |= REG_LIVE_READ;
+		parent->live |= REG_LIVE_READ;
 		state = parent;
 		parent = state->parent;
 		writes = true;
@@ -976,7 +923,10 @@ static int check_reg_arg(struct bpf_veri
 			verbose(env, "R%d !read_ok\n", regno);
 			return -EACCES;
 		}
-		return mark_reg_read(env, vstate, vstate->parent, regno);
+		/* We don't need to worry about FP liveness because it's read-only */
+		if (regno != BPF_REG_FP)
+			return mark_reg_read(env, &regs[regno],
+					     regs[regno].parent);
 	} else {
 		/* check whether register used as dest operand can be written to */
 		if (regno == BPF_REG_FP) {
@@ -1087,8 +1037,8 @@ static int check_stack_write(struct bpf_
 	} else {
 		u8 type = STACK_MISC;
 
-		/* regular write of data into stack */
-		state->stack[spi].spilled_ptr = (struct bpf_reg_state) {};
+		/* regular write of data into stack destroys any spilled ptr */
+		state->stack[spi].spilled_ptr.type = NOT_INIT;
 
 		/* only mark the slot as written if all 8 bytes were written
 		 * otherwise read propagation may incorrectly stop too soon
@@ -1113,61 +1063,6 @@ static int check_stack_write(struct bpf_
 	return 0;
 }
 
-/* registers of every function are unique and mark_reg_read() propagates
- * the liveness in the following cases:
- * - from callee into caller for R1 - R5 that were used as arguments
- * - from caller into callee for R0 that used as result of the call
- * - from caller to the same caller skipping states of the callee for R6 - R9,
- *   since R6 - R9 are callee saved by implicit function prologue and
- *   caller's R6 != callee's R6, so when we propagate liveness up to
- *   parent states we need to skip callee states for R6 - R9.
- *
- * stack slot marking is different, since stacks of caller and callee are
- * accessible in both (since caller can pass a pointer to caller's stack to
- * callee which can pass it to another function), hence mark_stack_slot_read()
- * has to propagate the stack liveness to all parent states at given frame number.
- * Consider code:
- * f1() {
- *   ptr = fp - 8;
- *   *ptr = ctx;
- *   call f2 {
- *      .. = *ptr;
- *   }
- *   .. = *ptr;
- * }
- * First *ptr is reading from f1's stack and mark_stack_slot_read() has
- * to mark liveness at the f1's frame and not f2's frame.
- * Second *ptr is also reading from f1's stack and mark_stack_slot_read() has
- * to propagate liveness to f2 states at f1's frame level and further into
- * f1 states at f1's frame level until write into that stack slot
- */
-static void mark_stack_slot_read(struct bpf_verifier_env *env,
-				 const struct bpf_verifier_state *state,
-				 struct bpf_verifier_state *parent,
-				 int slot, int frameno)
-{
-	bool writes = parent == state->parent; /* Observe write marks */
-
-	while (parent) {
-		if (parent->frame[frameno]->allocated_stack <= slot * BPF_REG_SIZE)
-			/* since LIVE_WRITTEN mark is only done for full 8-byte
-			 * write the read marks are conservative and parent
-			 * state may not even have the stack allocated. In such case
-			 * end the propagation, since the loop reached beginning
-			 * of the function
-			 */
-			break;
-		/* if read wasn't screened by an earlier write ... */
-		if (writes && state->frame[frameno]->stack[slot].spilled_ptr.live & REG_LIVE_WRITTEN)
-			break;
-		/* ... then we depend on parent's value */
-		parent->frame[frameno]->stack[slot].spilled_ptr.live |= REG_LIVE_READ;
-		state = parent;
-		parent = state->parent;
-		writes = true;
-	}
-}
-
 static int check_stack_read(struct bpf_verifier_env *env,
 			    struct bpf_func_state *reg_state /* func where register points to */,
 			    int off, int size, int value_regno)
@@ -1205,8 +1100,8 @@ static int check_stack_read(struct bpf_v
 			 */
 			state->regs[value_regno].live |= REG_LIVE_WRITTEN;
 		}
-		mark_stack_slot_read(env, vstate, vstate->parent, spi,
-				     reg_state->frameno);
+		mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
+			      reg_state->stack[spi].spilled_ptr.parent);
 		return 0;
 	} else {
 		int zeros = 0;
@@ -1222,8 +1117,8 @@ static int check_stack_read(struct bpf_v
 				off, i, size);
 			return -EACCES;
 		}
-		mark_stack_slot_read(env, vstate, vstate->parent, spi,
-				     reg_state->frameno);
+		mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
+			      reg_state->stack[spi].spilled_ptr.parent);
 		if (value_regno >= 0) {
 			if (zeros == size) {
 				/* any size read into register is zero extended,
@@ -1927,8 +1822,8 @@ mark:
 		/* reading any byte out of 8-byte 'spill_slot' will cause
 		 * the whole slot to be marked as 'read'
 		 */
-		mark_stack_slot_read(env, env->cur_state, env->cur_state->parent,
-				     spi, state->frameno);
+		mark_reg_read(env, &state->stack[spi].spilled_ptr,
+			      state->stack[spi].spilled_ptr.parent);
 	}
 	return update_stack_depth(env, state, off);
 }
@@ -2384,11 +2279,13 @@ static int check_func_call(struct bpf_ve
 			state->curframe + 1 /* frameno within this callchain */,
 			subprog /* subprog number within this prog */);
 
-	/* copy r1 - r5 args that callee can access */
+	/* copy r1 - r5 args that callee can access.  The copy includes parent
+	 * pointers, which connects us up to the liveness chain
+	 */
 	for (i = BPF_REG_1; i <= BPF_REG_5; i++)
 		callee->regs[i] = caller->regs[i];
 
-	/* after the call regsiters r0 - r5 were scratched */
+	/* after the call registers r0 - r5 were scratched */
 	for (i = 0; i < CALLER_SAVED_REGS; i++) {
 		mark_reg_not_init(env, caller->regs, caller_saved[i]);
 		check_reg_arg(env, caller_saved[i], DST_OP_NO_MARK);
@@ -4844,7 +4741,7 @@ static bool regsafe(struct bpf_reg_state
 		/* explored state didn't use this */
 		return true;
 
-	equal = memcmp(rold, rcur, offsetof(struct bpf_reg_state, frameno)) == 0;
+	equal = memcmp(rold, rcur, offsetof(struct bpf_reg_state, parent)) == 0;
 
 	if (rold->type == PTR_TO_STACK)
 		/* two stack pointers are equal only if they're pointing to
@@ -5083,7 +4980,7 @@ static bool states_equal(struct bpf_veri
  * equivalent state (jump target or such) we didn't arrive by the straight-line
  * code, so read marks in the state must propagate to the parent regardless
  * of the state's write marks. That's what 'parent == state->parent' comparison
- * in mark_reg_read() and mark_stack_slot_read() is for.
+ * in mark_reg_read() is for.
  */
 static int propagate_liveness(struct bpf_verifier_env *env,
 			      const struct bpf_verifier_state *vstate,
@@ -5104,7 +5001,8 @@ static int propagate_liveness(struct bpf
 		if (vparent->frame[vparent->curframe]->regs[i].live & REG_LIVE_READ)
 			continue;
 		if (vstate->frame[vstate->curframe]->regs[i].live & REG_LIVE_READ) {
-			err = mark_reg_read(env, vstate, vparent, i);
+			err = mark_reg_read(env, &vstate->frame[vstate->curframe]->regs[i],
+					    &vparent->frame[vstate->curframe]->regs[i]);
 			if (err)
 				return err;
 		}
@@ -5119,7 +5017,8 @@ static int propagate_liveness(struct bpf
 			if (parent->stack[i].spilled_ptr.live & REG_LIVE_READ)
 				continue;
 			if (state->stack[i].spilled_ptr.live & REG_LIVE_READ)
-				mark_stack_slot_read(env, vstate, vparent, i, frame);
+				mark_reg_read(env, &state->stack[i].spilled_ptr,
+					      &parent->stack[i].spilled_ptr);
 		}
 	}
 	return err;
@@ -5129,7 +5028,7 @@ static int is_state_visited(struct bpf_v
 {
 	struct bpf_verifier_state_list *new_sl;
 	struct bpf_verifier_state_list *sl;
-	struct bpf_verifier_state *cur = env->cur_state;
+	struct bpf_verifier_state *cur = env->cur_state, *new;
 	int i, j, err, states_cnt = 0;
 
 	sl = env->explored_states[insn_idx];
@@ -5175,16 +5074,18 @@ static int is_state_visited(struct bpf_v
 		return -ENOMEM;
 
 	/* add new state to the head of linked list */
-	err = copy_verifier_state(&new_sl->state, cur);
+	new = &new_sl->state;
+	err = copy_verifier_state(new, cur);
 	if (err) {
-		free_verifier_state(&new_sl->state, false);
+		free_verifier_state(new, false);
 		kfree(new_sl);
 		return err;
 	}
 	new_sl->next = env->explored_states[insn_idx];
 	env->explored_states[insn_idx] = new_sl;
 	/* connect new state to parentage chain */
-	cur->parent = &new_sl->state;
+	for (i = 0; i < BPF_REG_FP; i++)
+		cur_regs(env)[i].parent = &new->frame[new->curframe]->regs[i];
 	/* clear write marks in current state: the writes we did are not writes
 	 * our child did, so they don't screen off its reads from us.
 	 * (There are no read marks in current state, because reads always mark
@@ -5197,9 +5098,13 @@ static int is_state_visited(struct bpf_v
 	/* all stack frames are accessible from callee, clear them all */
 	for (j = 0; j <= cur->curframe; j++) {
 		struct bpf_func_state *frame = cur->frame[j];
+		struct bpf_func_state *newframe = new->frame[j];
 
-		for (i = 0; i < frame->allocated_stack / BPF_REG_SIZE; i++)
+		for (i = 0; i < frame->allocated_stack / BPF_REG_SIZE; i++) {
 			frame->stack[i].spilled_ptr.live = REG_LIVE_NONE;
+			frame->stack[i].spilled_ptr.parent =
+						&newframe->stack[i].spilled_ptr;
+		}
 	}
 	return 0;
 }


