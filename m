Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9D43DD927
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbhHBN5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:57:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235536AbhHBNzx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:55:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E13FC6112E;
        Mon,  2 Aug 2021 13:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912461;
        bh=aGHkqmSGxXrbhtwRUFt4vEQlw1xCA2kFYBUK5GRyUn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFqslmpn9DOzypyLcYzOizwbhu+vEENwuuriwK/vg+67ORAf+gcd25Heex+4u1v4D
         iXoQ3r5rCRFnR0Ui7GonUTLJp8HL+dYIB1x1E/DWyFv0N6O+NcnLu0yevaIrU/PimU
         6LFhBvldF1Dz9rf/6fj2EWOC6iU81ePw0DnAZeMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 62/67] bpf: Fix pointer arithmetic mask tightening under state pruning
Date:   Mon,  2 Aug 2021 15:45:25 +0200
Message-Id: <20210802134341.172647088@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit e042aa532c84d18ff13291d00620502ce7a38dda upstream.

In 7fedb63a8307 ("bpf: Tighten speculative pointer arithmetic mask") we
narrowed the offset mask for unprivileged pointer arithmetic in order to
mitigate a corner case where in the speculative domain it is possible to
advance, for example, the map value pointer by up to value_size-1 out-of-
bounds in order to leak kernel memory via side-channel to user space.

The verifier's state pruning for scalars leaves one corner case open
where in the first verification path R_x holds an unknown scalar with an
aux->alu_limit of e.g. 7, and in a second verification path that same
register R_x, here denoted as R_x', holds an unknown scalar which has
tighter bounds and would thus satisfy range_within(R_x, R_x') as well as
tnum_in(R_x, R_x') for state pruning, yielding an aux->alu_limit of 3:
Given the second path fits the register constraints for pruning, the final
generated mask from aux->alu_limit will remain at 7. While technically
not wrong for the non-speculative domain, it would however be possible
to craft similar cases where the mask would be too wide as in 7fedb63a8307.

One way to fix it is to detect the presence of unknown scalar map pointer
arithmetic and force a deeper search on unknown scalars to ensure that
we do not run into a masking mismatch.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf_verifier.h |    1 +
 kernel/bpf/verifier.c        |   27 +++++++++++++++++----------
 2 files changed, 18 insertions(+), 10 deletions(-)

--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -397,6 +397,7 @@ struct bpf_verifier_env {
 	struct bpf_map *used_maps[MAX_USED_MAPS]; /* array of map's used by eBPF program */
 	u32 used_map_cnt;		/* number of used maps */
 	u32 id_gen;			/* used to generate unique reg IDs */
+	bool explore_alu_limits;
 	bool allow_ptr_leaks;
 	bool allow_uninit_stack;
 	bool allow_ptr_to_map_access;
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5792,6 +5792,12 @@ static int sanitize_ptr_alu(struct bpf_v
 		alu_state |= off_is_imm ? BPF_ALU_IMMEDIATE : 0;
 		alu_state |= ptr_is_dst_reg ?
 			     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
+
+		/* Limit pruning on unknown scalars to enable deep search for
+		 * potential masking differences from other program paths.
+		 */
+		if (!off_is_imm)
+			env->explore_alu_limits = true;
 	}
 
 	err = update_alu_sanitation_state(aux, alu_state, alu_limit);
@@ -9088,8 +9094,8 @@ next:
 }
 
 /* Returns true if (rold safe implies rcur safe) */
-static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
-		    struct bpf_id_pair *idmap)
+static bool regsafe(struct bpf_verifier_env *env, struct bpf_reg_state *rold,
+		    struct bpf_reg_state *rcur, struct bpf_id_pair *idmap)
 {
 	bool equal;
 
@@ -9115,6 +9121,8 @@ static bool regsafe(struct bpf_reg_state
 		return false;
 	switch (rold->type) {
 	case SCALAR_VALUE:
+		if (env->explore_alu_limits)
+			return false;
 		if (rcur->type == SCALAR_VALUE) {
 			if (!rold->precise && !rcur->precise)
 				return true;
@@ -9204,9 +9212,8 @@ static bool regsafe(struct bpf_reg_state
 	return false;
 }
 
-static bool stacksafe(struct bpf_func_state *old,
-		      struct bpf_func_state *cur,
-		      struct bpf_id_pair *idmap)
+static bool stacksafe(struct bpf_verifier_env *env, struct bpf_func_state *old,
+		      struct bpf_func_state *cur, struct bpf_id_pair *idmap)
 {
 	int i, spi;
 
@@ -9251,9 +9258,8 @@ static bool stacksafe(struct bpf_func_st
 			continue;
 		if (old->stack[spi].slot_type[0] != STACK_SPILL)
 			continue;
-		if (!regsafe(&old->stack[spi].spilled_ptr,
-			     &cur->stack[spi].spilled_ptr,
-			     idmap))
+		if (!regsafe(env, &old->stack[spi].spilled_ptr,
+			     &cur->stack[spi].spilled_ptr, idmap))
 			/* when explored and current stack slot are both storing
 			 * spilled registers, check that stored pointers types
 			 * are the same as well.
@@ -9310,10 +9316,11 @@ static bool func_states_equal(struct bpf
 
 	memset(env->idmap_scratch, 0, sizeof(env->idmap_scratch));
 	for (i = 0; i < MAX_BPF_REG; i++)
-		if (!regsafe(&old->regs[i], &cur->regs[i], env->idmap_scratch))
+		if (!regsafe(env, &old->regs[i], &cur->regs[i],
+			     env->idmap_scratch))
 			return false;
 
-	if (!stacksafe(old, cur, env->idmap_scratch))
+	if (!stacksafe(env, old, cur, env->idmap_scratch))
 		return false;
 
 	if (!refsafe(old, cur))


