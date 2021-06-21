Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B323AEEA8
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhFUQar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:30:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230393AbhFUQ1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:27:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9442613B4;
        Mon, 21 Jun 2021 16:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292582;
        bh=Abov54/AoW6Cr7AeSRZmWaeX/aaHoEaPW88roiMUlto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gnH44aldBeExRSXeT71a5cvUb6exlfNSurNKaTBMBEAQYo+CvPJIjgiVSdAgjSe1o
         aiodxTvjL/5KD3sVkJUyaQ7mDq14YpY/6nQXbZJyB2mlpuQVOduvs5hw6dzgqgYZ5Q
         jCEME8KBxAHlasELwFlzU9g7xTwyPL5laf/hoSBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Morrison <mad@cs.tau.ac.il>,
        Ofek Kirzner <ofekkir@gmail.com>,
        Benedict Schlueter <benedict.schlueter@rub.de>,
        Piotr Krysiuk <piotras@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/146] bpf: Fix leakage under speculation on mispredicted branches
Date:   Mon, 21 Jun 2021 18:14:44 +0200
Message-Id: <20210621154913.906586441@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 9183671af6dbf60a1219371d4ed73e23f43b49db ]

The verifier only enumerates valid control-flow paths and skips paths that
are unreachable in the non-speculative domain. And so it can miss issues
under speculative execution on mispredicted branches.

For example, a type confusion has been demonstrated with the following
crafted program:

  // r0 = pointer to a map array entry
  // r6 = pointer to readable stack slot
  // r9 = scalar controlled by attacker
  1: r0 = *(u64 *)(r0) // cache miss
  2: if r0 != 0x0 goto line 4
  3: r6 = r9
  4: if r0 != 0x1 goto line 6
  5: r9 = *(u8 *)(r6)
  6: // leak r9

Since line 3 runs iff r0 == 0 and line 5 runs iff r0 == 1, the verifier
concludes that the pointer dereference on line 5 is safe. But: if the
attacker trains both the branches to fall-through, such that the following
is speculatively executed ...

  r6 = r9
  r9 = *(u8 *)(r6)
  // leak r9

... then the program will dereference an attacker-controlled value and could
leak its content under speculative execution via side-channel. This requires
to mistrain the branch predictor, which can be rather tricky, because the
branches are mutually exclusive. However such training can be done at
congruent addresses in user space using different branches that are not
mutually exclusive. That is, by training branches in user space ...

  A:  if r0 != 0x0 goto line C
  B:  ...
  C:  if r0 != 0x0 goto line D
  D:  ...

... such that addresses A and C collide to the same CPU branch prediction
entries in the PHT (pattern history table) as those of the BPF program's
lines 2 and 4, respectively. A non-privileged attacker could simply brute
force such collisions in the PHT until observing the attack succeeding.

Alternative methods to mistrain the branch predictor are also possible that
avoid brute forcing the collisions in the PHT. A reliable attack has been
demonstrated, for example, using the following crafted program:

  // r0 = pointer to a [control] map array entry
  // r7 = *(u64 *)(r0 + 0), training/attack phase
  // r8 = *(u64 *)(r0 + 8), oob address
  // [...]
  // r0 = pointer to a [data] map array entry
  1: if r7 == 0x3 goto line 3
  2: r8 = r0
  // crafted sequence of conditional jumps to separate the conditional
  // branch in line 193 from the current execution flow
  3: if r0 != 0x0 goto line 5
  4: if r0 == 0x0 goto exit
  5: if r0 != 0x0 goto line 7
  6: if r0 == 0x0 goto exit
  [...]
  187: if r0 != 0x0 goto line 189
  188: if r0 == 0x0 goto exit
  // load any slowly-loaded value (due to cache miss in phase 3) ...
  189: r3 = *(u64 *)(r0 + 0x1200)
  // ... and turn it into known zero for verifier, while preserving slowly-
  // loaded dependency when executing:
  190: r3 &= 1
  191: r3 &= 2
  // speculatively bypassed phase dependency
  192: r7 += r3
  193: if r7 == 0x3 goto exit
  194: r4 = *(u8 *)(r8 + 0)
  // leak r4

As can be seen, in training phase (phase != 0x3), the condition in line 1
turns into false and therefore r8 with the oob address is overridden with
the valid map value address, which in line 194 we can read out without
issues. However, in attack phase, line 2 is skipped, and due to the cache
miss in line 189 where the map value is (zeroed and later) added to the
phase register, the condition in line 193 takes the fall-through path due
to prior branch predictor training, where under speculation, it'll load the
byte at oob address r8 (unknown scalar type at that point) which could then
be leaked via side-channel.

One way to mitigate these is to 'branch off' an unreachable path, meaning,
the current verification path keeps following the is_branch_taken() path
and we push the other branch to the verification stack. Given this is
unreachable from the non-speculative domain, this branch's vstate is
explicitly marked as speculative. This is needed for two reasons: i) if
this path is solely seen from speculative execution, then we later on still
want the dead code elimination to kick in in order to sanitize these
instructions with jmp-1s, and ii) to ensure that paths walked in the
non-speculative domain are not pruned from earlier walks of paths walked in
the speculative domain. Additionally, for robustness, we mark the registers
which have been part of the conditional as unknown in the speculative path
given there should be no assumptions made on their content.

The fix in here mitigates type confusion attacks described earlier due to
i) all code paths in the BPF program being explored and ii) existing
verifier logic already ensuring that given memory access instruction
references one specific data structure.

An alternative to this fix that has also been looked at in this scope was to
mark aux->alu_state at the jump instruction with a BPF_JMP_TAKEN state as
well as direction encoding (always-goto, always-fallthrough, unknown), such
that mixing of different always-* directions themselves as well as mixing of
always-* with unknown directions would cause a program rejection by the
verifier, e.g. programs with constructs like 'if ([...]) { x = 0; } else
{ x = 1; }' with subsequent 'if (x == 1) { [...] }'. For unprivileged, this
would result in only single direction always-* taken paths, and unknown taken
paths being allowed, such that the former could be patched from a conditional
jump to an unconditional jump (ja). Compared to this approach here, it would
have two downsides: i) valid programs that otherwise are not performing any
pointer arithmetic, etc, would potentially be rejected/broken, and ii) we are
required to turn off path pruning for unprivileged, where both can be avoided
in this work through pushing the invalid branch to the verification stack.

The issue was originally discovered by Adam and Ofek, and later independently
discovered and reported as a result of Benedict and Piotr's research work.

Fixes: b2157399cc98 ("bpf: prevent out-of-bounds speculation")
Reported-by: Adam Morrison <mad@cs.tau.ac.il>
Reported-by: Ofek Kirzner <ofekkir@gmail.com>
Reported-by: Benedict Schlueter <benedict.schlueter@rub.de>
Reported-by: Piotr Krysiuk <piotras@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Reviewed-by: Benedict Schlueter <benedict.schlueter@rub.de>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 44 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4f50d6f128be..da8fc57ff5b2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5740,6 +5740,27 @@ struct bpf_sanitize_info {
 	bool mask_to_left;
 };
 
+static struct bpf_verifier_state *
+sanitize_speculative_path(struct bpf_verifier_env *env,
+			  const struct bpf_insn *insn,
+			  u32 next_idx, u32 curr_idx)
+{
+	struct bpf_verifier_state *branch;
+	struct bpf_reg_state *regs;
+
+	branch = push_stack(env, next_idx, curr_idx, true);
+	if (branch && insn) {
+		regs = branch->frame[branch->curframe]->regs;
+		if (BPF_SRC(insn->code) == BPF_K) {
+			mark_reg_unknown(env, regs, insn->dst_reg);
+		} else if (BPF_SRC(insn->code) == BPF_X) {
+			mark_reg_unknown(env, regs, insn->dst_reg);
+			mark_reg_unknown(env, regs, insn->src_reg);
+		}
+	}
+	return branch;
+}
+
 static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 			    struct bpf_insn *insn,
 			    const struct bpf_reg_state *ptr_reg,
@@ -5823,7 +5844,8 @@ do_sim:
 		tmp = *dst_reg;
 		*dst_reg = *ptr_reg;
 	}
-	ret = push_stack(env, env->insn_idx + 1, env->insn_idx, true);
+	ret = sanitize_speculative_path(env, NULL, env->insn_idx + 1,
+					env->insn_idx);
 	if (!ptr_is_dst_reg && ret)
 		*dst_reg = tmp;
 	return !ret ? REASON_STACK : 0;
@@ -7974,14 +7996,28 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 		if (err)
 			return err;
 	}
+
 	if (pred == 1) {
-		/* only follow the goto, ignore fall-through */
+		/* Only follow the goto, ignore fall-through. If needed, push
+		 * the fall-through branch for simulation under speculative
+		 * execution.
+		 */
+		if (!env->bypass_spec_v1 &&
+		    !sanitize_speculative_path(env, insn, *insn_idx + 1,
+					       *insn_idx))
+			return -EFAULT;
 		*insn_idx += insn->off;
 		return 0;
 	} else if (pred == 0) {
-		/* only follow fall-through branch, since
-		 * that's where the program will go
+		/* Only follow the fall-through branch, since that's where the
+		 * program will go. If needed, push the goto branch for
+		 * simulation under speculative execution.
 		 */
+		if (!env->bypass_spec_v1 &&
+		    !sanitize_speculative_path(env, insn,
+					       *insn_idx + insn->off + 1,
+					       *insn_idx))
+			return -EFAULT;
 		return 0;
 	}
 
-- 
2.30.2



