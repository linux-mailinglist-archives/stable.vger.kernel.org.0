Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333DF627FD4
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237697AbiKNNCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237791AbiKNNBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:01:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0917F29809
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:01:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B4A261175
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99367C433D6;
        Mon, 14 Nov 2022 13:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430912;
        bh=63E/KvD/3sfkbden9cVMAq/fDmSHUzELbKwlOPdQvcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Ol3ZED6PZUp+KeAs3F5PGJuNzoEdurwH9v9QQwVKs66nyUP1MgGmq68poWdzb10I
         ozcRWKrojfNoKc0oM6tVhnrwTAvTLm4DcvQe3LgVa7Yk2+qiYMoe2qvu/Swb6aUjQ8
         J3JXeXYvBdEczS9+gZMnZU7vaTc3eXa8I/jUNKkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 032/190] bpf: Add helper macro bpf_for_each_reg_in_vstate
Date:   Mon, 14 Nov 2022 13:44:16 +0100
Message-Id: <20221114124500.164440629@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit b239da34203f49c40b5d656220c39647c3ff0b3c ]

For a lot of use cases in future patches, we will want to modify the
state of registers part of some same 'group' (e.g. same ref_obj_id). It
won't just be limited to releasing reference state, but setting a type
flag dynamically based on certain actions, etc.

Hence, we need a way to easily pass a callback to the function that
iterates over all registers in current bpf_verifier_state in all frames
upto (and including) the curframe.

While in C++ we would be able to easily use a lambda to pass state and
the callback together, sadly we aren't using C++ in the kernel. The next
best thing to avoid defining a function for each case seems like
statement expressions in GNU C. The kernel already uses them heavily,
hence they can passed to the macro in the style of a lambda. The
statement expression will then be substituted in the for loop bodies.

Variables __state and __reg are set to current bpf_func_state and reg
for each invocation of the expression inside the passed in verifier
state.

Then, convert mark_ptr_or_null_regs, clear_all_pkt_pointers,
release_reference, find_good_pkt_pointers, find_equal_scalars to
use bpf_for_each_reg_in_vstate.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20220904204145.3089-16-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: f1db20814af5 ("bpf: Fix wrong reg type conversion in release_reference()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h |  21 ++++++
 kernel/bpf/verifier.c        | 135 ++++++++---------------------------
 2 files changed, 49 insertions(+), 107 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 1fdddbf3546b..184b957e28ad 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -348,6 +348,27 @@ struct bpf_verifier_state {
 	     iter < frame->allocated_stack / BPF_REG_SIZE;		\
 	     iter++, reg = bpf_get_spilled_reg(iter, frame))
 
+/* Invoke __expr over regsiters in __vst, setting __state and __reg */
+#define bpf_for_each_reg_in_vstate(__vst, __state, __reg, __expr)   \
+	({                                                               \
+		struct bpf_verifier_state *___vstate = __vst;            \
+		int ___i, ___j;                                          \
+		for (___i = 0; ___i <= ___vstate->curframe; ___i++) {    \
+			struct bpf_reg_state *___regs;                   \
+			__state = ___vstate->frame[___i];                \
+			___regs = __state->regs;                         \
+			for (___j = 0; ___j < MAX_BPF_REG; ___j++) {     \
+				__reg = &___regs[___j];                  \
+				(void)(__expr);                          \
+			}                                                \
+			bpf_for_each_spilled_reg(___j, __state, __reg) { \
+				if (!__reg)                              \
+					continue;                        \
+				(void)(__expr);                          \
+			}                                                \
+		}                                                        \
+	})
+
 /* linked list of verifier states used to prune search */
 struct bpf_verifier_state_list {
 	struct bpf_verifier_state state;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2d7ece2a87fa..7bfeb249214e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6500,31 +6500,15 @@ static int check_func_proto(const struct bpf_func_proto *fn, int func_id,
 /* Packet data might have moved, any old PTR_TO_PACKET[_META,_END]
  * are now invalid, so turn them into unknown SCALAR_VALUE.
  */
-static void __clear_all_pkt_pointers(struct bpf_verifier_env *env,
-				     struct bpf_func_state *state)
+static void clear_all_pkt_pointers(struct bpf_verifier_env *env)
 {
-	struct bpf_reg_state *regs = state->regs, *reg;
-	int i;
-
-	for (i = 0; i < MAX_BPF_REG; i++)
-		if (reg_is_pkt_pointer_any(&regs[i]))
-			mark_reg_unknown(env, regs, i);
+	struct bpf_func_state *state;
+	struct bpf_reg_state *reg;
 
-	bpf_for_each_spilled_reg(i, state, reg) {
-		if (!reg)
-			continue;
+	bpf_for_each_reg_in_vstate(env->cur_state, state, reg, ({
 		if (reg_is_pkt_pointer_any(reg))
 			__mark_reg_unknown(env, reg);
-	}
-}
-
-static void clear_all_pkt_pointers(struct bpf_verifier_env *env)
-{
-	struct bpf_verifier_state *vstate = env->cur_state;
-	int i;
-
-	for (i = 0; i <= vstate->curframe; i++)
-		__clear_all_pkt_pointers(env, vstate->frame[i]);
+	}));
 }
 
 enum {
@@ -6553,41 +6537,24 @@ static void mark_pkt_end(struct bpf_verifier_state *vstate, int regn, bool range
 		reg->range = AT_PKT_END;
 }
 
-static void release_reg_references(struct bpf_verifier_env *env,
-				   struct bpf_func_state *state,
-				   int ref_obj_id)
-{
-	struct bpf_reg_state *regs = state->regs, *reg;
-	int i;
-
-	for (i = 0; i < MAX_BPF_REG; i++)
-		if (regs[i].ref_obj_id == ref_obj_id)
-			mark_reg_unknown(env, regs, i);
-
-	bpf_for_each_spilled_reg(i, state, reg) {
-		if (!reg)
-			continue;
-		if (reg->ref_obj_id == ref_obj_id)
-			__mark_reg_unknown(env, reg);
-	}
-}
-
 /* The pointer with the specified id has released its reference to kernel
  * resources. Identify all copies of the same pointer and clear the reference.
  */
 static int release_reference(struct bpf_verifier_env *env,
 			     int ref_obj_id)
 {
-	struct bpf_verifier_state *vstate = env->cur_state;
+	struct bpf_func_state *state;
+	struct bpf_reg_state *reg;
 	int err;
-	int i;
 
 	err = release_reference_state(cur_func(env), ref_obj_id);
 	if (err)
 		return err;
 
-	for (i = 0; i <= vstate->curframe; i++)
-		release_reg_references(env, vstate->frame[i], ref_obj_id);
+	bpf_for_each_reg_in_vstate(env->cur_state, state, reg, ({
+		if (reg->ref_obj_id == ref_obj_id)
+			__mark_reg_unknown(env, reg);
+	}));
 
 	return 0;
 }
@@ -9283,34 +9250,14 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	return 0;
 }
 
-static void __find_good_pkt_pointers(struct bpf_func_state *state,
-				     struct bpf_reg_state *dst_reg,
-				     enum bpf_reg_type type, int new_range)
-{
-	struct bpf_reg_state *reg;
-	int i;
-
-	for (i = 0; i < MAX_BPF_REG; i++) {
-		reg = &state->regs[i];
-		if (reg->type == type && reg->id == dst_reg->id)
-			/* keep the maximum range already checked */
-			reg->range = max(reg->range, new_range);
-	}
-
-	bpf_for_each_spilled_reg(i, state, reg) {
-		if (!reg)
-			continue;
-		if (reg->type == type && reg->id == dst_reg->id)
-			reg->range = max(reg->range, new_range);
-	}
-}
-
 static void find_good_pkt_pointers(struct bpf_verifier_state *vstate,
 				   struct bpf_reg_state *dst_reg,
 				   enum bpf_reg_type type,
 				   bool range_right_open)
 {
-	int new_range, i;
+	struct bpf_func_state *state;
+	struct bpf_reg_state *reg;
+	int new_range;
 
 	if (dst_reg->off < 0 ||
 	    (dst_reg->off == 0 && range_right_open))
@@ -9375,9 +9322,11 @@ static void find_good_pkt_pointers(struct bpf_verifier_state *vstate,
 	 * the range won't allow anything.
 	 * dst_reg->off is known < MAX_PACKET_OFF, therefore it fits in a u16.
 	 */
-	for (i = 0; i <= vstate->curframe; i++)
-		__find_good_pkt_pointers(vstate->frame[i], dst_reg, type,
-					 new_range);
+	bpf_for_each_reg_in_vstate(vstate, state, reg, ({
+		if (reg->type == type && reg->id == dst_reg->id)
+			/* keep the maximum range already checked */
+			reg->range = max(reg->range, new_range);
+	}));
 }
 
 static int is_branch32_taken(struct bpf_reg_state *reg, u32 val, u8 opcode)
@@ -9866,7 +9815,7 @@ static void mark_ptr_or_null_reg(struct bpf_func_state *state,
 
 		if (!reg_may_point_to_spin_lock(reg)) {
 			/* For not-NULL ptr, reg->ref_obj_id will be reset
-			 * in release_reg_references().
+			 * in release_reference().
 			 *
 			 * reg->id is still used by spin_lock ptr. Other
 			 * than spin_lock ptr type, reg->id can be reset.
@@ -9876,22 +9825,6 @@ static void mark_ptr_or_null_reg(struct bpf_func_state *state,
 	}
 }
 
-static void __mark_ptr_or_null_regs(struct bpf_func_state *state, u32 id,
-				    bool is_null)
-{
-	struct bpf_reg_state *reg;
-	int i;
-
-	for (i = 0; i < MAX_BPF_REG; i++)
-		mark_ptr_or_null_reg(state, &state->regs[i], id, is_null);
-
-	bpf_for_each_spilled_reg(i, state, reg) {
-		if (!reg)
-			continue;
-		mark_ptr_or_null_reg(state, reg, id, is_null);
-	}
-}
-
 /* The logic is similar to find_good_pkt_pointers(), both could eventually
  * be folded together at some point.
  */
@@ -9899,10 +9832,9 @@ static void mark_ptr_or_null_regs(struct bpf_verifier_state *vstate, u32 regno,
 				  bool is_null)
 {
 	struct bpf_func_state *state = vstate->frame[vstate->curframe];
-	struct bpf_reg_state *regs = state->regs;
+	struct bpf_reg_state *regs = state->regs, *reg;
 	u32 ref_obj_id = regs[regno].ref_obj_id;
 	u32 id = regs[regno].id;
-	int i;
 
 	if (ref_obj_id && ref_obj_id == id && is_null)
 		/* regs[regno] is in the " == NULL" branch.
@@ -9911,8 +9843,9 @@ static void mark_ptr_or_null_regs(struct bpf_verifier_state *vstate, u32 regno,
 		 */
 		WARN_ON_ONCE(release_reference_state(state, id));
 
-	for (i = 0; i <= vstate->curframe; i++)
-		__mark_ptr_or_null_regs(vstate->frame[i], id, is_null);
+	bpf_for_each_reg_in_vstate(vstate, state, reg, ({
+		mark_ptr_or_null_reg(state, reg, id, is_null);
+	}));
 }
 
 static bool try_match_pkt_pointers(const struct bpf_insn *insn,
@@ -10025,23 +9958,11 @@ static void find_equal_scalars(struct bpf_verifier_state *vstate,
 {
 	struct bpf_func_state *state;
 	struct bpf_reg_state *reg;
-	int i, j;
 
-	for (i = 0; i <= vstate->curframe; i++) {
-		state = vstate->frame[i];
-		for (j = 0; j < MAX_BPF_REG; j++) {
-			reg = &state->regs[j];
-			if (reg->type == SCALAR_VALUE && reg->id == known_reg->id)
-				*reg = *known_reg;
-		}
-
-		bpf_for_each_spilled_reg(j, state, reg) {
-			if (!reg)
-				continue;
-			if (reg->type == SCALAR_VALUE && reg->id == known_reg->id)
-				*reg = *known_reg;
-		}
-	}
+	bpf_for_each_reg_in_vstate(vstate, state, reg, ({
+		if (reg->type == SCALAR_VALUE && reg->id == known_reg->id)
+			*reg = *known_reg;
+	}));
 }
 
 static int check_cond_jmp_op(struct bpf_verifier_env *env,
-- 
2.35.1



