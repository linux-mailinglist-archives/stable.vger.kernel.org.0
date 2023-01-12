Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB0F6674E3
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbjALOPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbjALOOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:14:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41881551C7
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:06:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3570FB81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75094C433EF;
        Thu, 12 Jan 2023 14:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532414;
        bh=P3VqbGCBm4P/kbJZQbaLI3UD2Z/ekxPtxHEkgdz8wRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TentpMVrTORL6pxiGhY0ievvA4c6oHr6Q1lC0v3/CaUy5rFuxwzF9SJkIQU2Nj6aU
         szs1Xn8w4y3S23VsIwar+dFeG0g/uWTN8gJvPQxE/PzNcbnvBEua6d3hLah8lkNdjr
         R7Ye0Qr9DnLNFdjb3FcaROL11ixuH4Nhh8NNhn0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/783] bpf: Check the other end of slot_type for STACK_SPILL
Date:   Thu, 12 Jan 2023 14:47:33 +0100
Message-Id: <20230112135530.671166669@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Martin KaFai Lau <kafai@fb.com>

[ Upstream commit 27113c59b6d0a587b29ae72d4ff3f832f58b0651 ]

Every 8 bytes of the stack is tracked by a bpf_stack_state.
Within each bpf_stack_state, there is a 'u8 slot_type[8]' to track
the type of each byte.  Verifier tests slot_type[0] == STACK_SPILL
to decide if the spilled reg state is saved.  Verifier currently only
saves the reg state if the whole 8 bytes are spilled to the stack,
so checking the slot_type[7] is the same as checking slot_type[0].

The later patch will allow verifier to save the bounded scalar
reg also for <8 bytes spill.  There is a llvm patch [1] to ensure
the <8 bytes spill will be 8-byte aligned,  so checking
slot_type[7] instead of slot_type[0] is required.

While at it, this patch refactors the slot_type[0] == STACK_SPILL
test into a new function is_spilled_reg() and change the
slot_type[0] check to slot_type[7] check in there also.

[1] https://reviews.llvm.org/D109073

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210922004934.624194-1-kafai@fb.com
Stable-dep-of: 529409ea92d5 ("bpf: propagate precision across all frames, not just the last one")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 30e0fa1bd83c..034eb3030ce9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -562,6 +562,14 @@ const char *kernel_type_name(u32 id)
 				  btf_type_by_id(btf_vmlinux, id)->name_off);
 }
 
+/* The reg state of a pointer or a bounded scalar was saved when
+ * it was spilled to the stack.
+ */
+static bool is_spilled_reg(const struct bpf_stack_state *stack)
+{
+	return stack->slot_type[BPF_REG_SIZE - 1] == STACK_SPILL;
+}
+
 static void print_verifier_state(struct bpf_verifier_env *env,
 				 const struct bpf_func_state *state)
 {
@@ -666,7 +674,7 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 			continue;
 		verbose(env, " fp%d", (-i - 1) * BPF_REG_SIZE);
 		print_liveness(env, state->stack[i].spilled_ptr.live);
-		if (state->stack[i].slot_type[0] == STACK_SPILL) {
+		if (is_spilled_reg(&state->stack[i])) {
 			reg = &state->stack[i].spilled_ptr;
 			t = reg->type;
 			verbose(env, "=%s", reg_type_str[t]);
@@ -2009,7 +2017,7 @@ static void mark_all_scalars_precise(struct bpf_verifier_env *env,
 				reg->precise = true;
 			}
 			for (j = 0; j < func->allocated_stack / BPF_REG_SIZE; j++) {
-				if (func->stack[j].slot_type[0] != STACK_SPILL)
+				if (!is_spilled_reg(&func->stack[j]))
 					continue;
 				reg = &func->stack[j].spilled_ptr;
 				if (reg->type != SCALAR_VALUE)
@@ -2051,7 +2059,7 @@ static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
 	}
 
 	while (spi >= 0) {
-		if (func->stack[spi].slot_type[0] != STACK_SPILL) {
+		if (!is_spilled_reg(&func->stack[spi])) {
 			stack_mask = 0;
 			break;
 		}
@@ -2150,7 +2158,7 @@ static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
 				return 0;
 			}
 
-			if (func->stack[i].slot_type[0] != STACK_SPILL) {
+			if (!is_spilled_reg(&func->stack[i])) {
 				stack_mask &= ~(1ull << i);
 				continue;
 			}
@@ -2348,7 +2356,7 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 		/* regular write of data into stack destroys any spilled ptr */
 		state->stack[spi].spilled_ptr.type = NOT_INIT;
 		/* Mark slots as STACK_MISC if they belonged to spilled ptr. */
-		if (state->stack[spi].slot_type[0] == STACK_SPILL)
+		if (is_spilled_reg(&state->stack[spi]))
 			for (i = 0; i < BPF_REG_SIZE; i++)
 				state->stack[spi].slot_type[i] = STACK_MISC;
 
@@ -2562,7 +2570,7 @@ static int check_stack_read_fixed_off(struct bpf_verifier_env *env,
 	stype = reg_state->stack[spi].slot_type;
 	reg = &reg_state->stack[spi].spilled_ptr;
 
-	if (stype[0] == STACK_SPILL) {
+	if (is_spilled_reg(&reg_state->stack[spi])) {
 		if (size != BPF_REG_SIZE) {
 			if (reg->type != SCALAR_VALUE) {
 				verbose_linfo(env, env->insn_idx, "; ");
@@ -4081,11 +4089,11 @@ static int check_stack_range_initialized(
 			goto mark;
 		}
 
-		if (state->stack[spi].slot_type[0] == STACK_SPILL &&
+		if (is_spilled_reg(&state->stack[spi]) &&
 		    state->stack[spi].spilled_ptr.type == PTR_TO_BTF_ID)
 			goto mark;
 
-		if (state->stack[spi].slot_type[0] == STACK_SPILL &&
+		if (is_spilled_reg(&state->stack[spi]) &&
 		    (state->stack[spi].spilled_ptr.type == SCALAR_VALUE ||
 		     env->allow_ptr_leaks)) {
 			if (clobber) {
@@ -9282,9 +9290,9 @@ static bool stacksafe(struct bpf_verifier_env *env, struct bpf_func_state *old,
 			 * return false to continue verification of this path
 			 */
 			return false;
-		if (i % BPF_REG_SIZE)
+		if (i % BPF_REG_SIZE != BPF_REG_SIZE - 1)
 			continue;
-		if (old->stack[spi].slot_type[0] != STACK_SPILL)
+		if (!is_spilled_reg(&old->stack[spi]))
 			continue;
 		if (!regsafe(env, &old->stack[spi].spilled_ptr,
 			     &cur->stack[spi].spilled_ptr, idmap))
@@ -9491,7 +9499,7 @@ static int propagate_precision(struct bpf_verifier_env *env,
 	}
 
 	for (i = 0; i < state->allocated_stack / BPF_REG_SIZE; i++) {
-		if (state->stack[i].slot_type[0] != STACK_SPILL)
+		if (!is_spilled_reg(&state->stack[i]))
 			continue;
 		state_reg = &state->stack[i].spilled_ptr;
 		if (state_reg->type != SCALAR_VALUE ||
-- 
2.35.1



