Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F590408DB3
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241651AbhIMN2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:28:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241665AbhIMN0e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:26:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8BE561252;
        Mon, 13 Sep 2021 13:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539377;
        bh=x5Km+A5KqIqeOqbaMfrUfjOAgJcZYRPrrx4zwAZDiFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lgu3daG5o/Xz/vYm82vewUrmwqH+1zulT5Ss7EhZ4eL+NjYQbVBnhQxwbn6zO6FuA
         LsEmdzkIvJZA3vQwQ5YMA99yqrQujyg6GmFMzft2OM5J6ve6tXM1yfYPg4MSpHu41V
         uznBoOfZtV7RvuhMZRY/xnjh7orjUZzIx4Xl72uo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 130/144] bpf: Fix pointer arithmetic mask tightening under state pruning
Date:   Mon, 13 Sep 2021 15:15:11 +0200
Message-Id: <20210913131052.273895278@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
[OP: adjusted context in include/linux/bpf_verifier.h for 5.4]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf_verifier.h |    1 +
 kernel/bpf/verifier.c        |   27 +++++++++++++++++----------
 2 files changed, 18 insertions(+), 10 deletions(-)

--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -371,6 +371,7 @@ struct bpf_verifier_env {
 	struct bpf_map *used_maps[MAX_USED_MAPS]; /* array of map's used by eBPF program */
 	u32 used_map_cnt;		/* number of used maps */
 	u32 id_gen;			/* used to generate unique reg IDs */
+	bool explore_alu_limits;
 	bool allow_ptr_leaks;
 	bool seen_direct_write;
 	struct bpf_insn_aux_data *insn_aux_data; /* array of per-insn state */
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4449,6 +4449,12 @@ static int sanitize_ptr_alu(struct bpf_v
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
@@ -7102,8 +7108,8 @@ next:
 }
 
 /* Returns true if (rold safe implies rcur safe) */
-static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
-		    struct bpf_id_pair *idmap)
+static bool regsafe(struct bpf_verifier_env *env, struct bpf_reg_state *rold,
+		    struct bpf_reg_state *rcur, struct bpf_id_pair *idmap)
 {
 	bool equal;
 
@@ -7129,6 +7135,8 @@ static bool regsafe(struct bpf_reg_state
 		return false;
 	switch (rold->type) {
 	case SCALAR_VALUE:
+		if (env->explore_alu_limits)
+			return false;
 		if (rcur->type == SCALAR_VALUE) {
 			if (!rold->precise && !rcur->precise)
 				return true;
@@ -7218,9 +7226,8 @@ static bool regsafe(struct bpf_reg_state
 	return false;
 }
 
-static bool stacksafe(struct bpf_func_state *old,
-		      struct bpf_func_state *cur,
-		      struct bpf_id_pair *idmap)
+static bool stacksafe(struct bpf_verifier_env *env, struct bpf_func_state *old,
+		      struct bpf_func_state *cur, struct bpf_id_pair *idmap)
 {
 	int i, spi;
 
@@ -7265,9 +7272,8 @@ static bool stacksafe(struct bpf_func_st
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
@@ -7324,10 +7330,11 @@ static bool func_states_equal(struct bpf
 
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


