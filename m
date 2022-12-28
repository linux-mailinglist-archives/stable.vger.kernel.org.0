Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CF6657C4C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbiL1PbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233824AbiL1PbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:31:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94BE6404
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:30:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 574EB61344
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A84C433EF;
        Wed, 28 Dec 2022 15:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241458;
        bh=BX2uNUkWPMCYw2peGS1ZQCi2+CspRTvDZ+2gvoy/nSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/zqej8oDnPAQsrRZnzcMZmktOM5y1qvpwP3RBT5cvopkwG+DWUgwdgxcgq5B7HAj
         LXAMnEATyMs/sLCs03OAVgJzQGPvsVN2Bm6dhUe+QHu11wV51pI8D+zDK1saXDFhRo
         cWepABXhW0OA1BcYRdWbIqwXUBNquguSiiqxhbLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0286/1073] bpf: propagate precision across all frames, not just the last one
Date:   Wed, 28 Dec 2022 15:31:14 +0100
Message-Id: <20221228144335.786307958@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 529409ea92d590659be487ba0839710329bd8074 ]

When equivalent completed state is found and it has additional precision
restrictions, BPF verifier propagates precision to
currently-being-verified state chain (i.e., including parent states) so
that if some of the states in the chain are not yet completed, necessary
precision restrictions are enforced.

Unfortunately, right now this happens only for the last frame (deepest
active subprogram's frame), not all the frames. This can lead to
incorrect matching of states due to missing precision marker. Currently
this doesn't seem possible as BPF verifier forces everything to precise
when validated BPF program has any subprograms. But with the next patch
lifting this restriction, this becomes problematic.

In fact, without this fix, we'll start getting failure in one of the
existing test_verifier test cases:

  #906/p precise: cross frame pruning FAIL
  Unexpected success to load!
  verification time 48 usec
  stack depth 0+0
  processed 26 insns (limit 1000000) max_states_per_insn 3 total_states 17 peak_states 17 mark_read 8

This patch adds precision propagation across all frames.

Fixes: a3ce685dd01a ("bpf: fix precision tracking")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20221104163649.121784-3-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 71 ++++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 32 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 05414615c008..7a1ca0e58043 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2751,7 +2751,7 @@ static void mark_all_scalars_precise(struct bpf_verifier_env *env,
 		}
 }
 
-static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
+static int __mark_chain_precision(struct bpf_verifier_env *env, int frame, int regno,
 				  int spi)
 {
 	struct bpf_verifier_state *st = env->cur_state;
@@ -2768,7 +2768,7 @@ static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
 	if (!env->bpf_capable)
 		return 0;
 
-	func = st->frame[st->curframe];
+	func = st->frame[frame];
 	if (regno >= 0) {
 		reg = &func->regs[regno];
 		if (reg->type != SCALAR_VALUE) {
@@ -2849,7 +2849,7 @@ static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
 			break;
 
 		new_marks = false;
-		func = st->frame[st->curframe];
+		func = st->frame[frame];
 		bitmap_from_u64(mask, reg_mask);
 		for_each_set_bit(i, mask, 32) {
 			reg = &func->regs[i];
@@ -2915,12 +2915,17 @@ static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
 
 static int mark_chain_precision(struct bpf_verifier_env *env, int regno)
 {
-	return __mark_chain_precision(env, regno, -1);
+	return __mark_chain_precision(env, env->cur_state->curframe, regno, -1);
 }
 
-static int mark_chain_precision_stack(struct bpf_verifier_env *env, int spi)
+static int mark_chain_precision_frame(struct bpf_verifier_env *env, int frame, int regno)
 {
-	return __mark_chain_precision(env, -1, spi);
+	return __mark_chain_precision(env, frame, regno, -1);
+}
+
+static int mark_chain_precision_stack_frame(struct bpf_verifier_env *env, int frame, int spi)
+{
+	return __mark_chain_precision(env, frame, -1, spi);
 }
 
 static bool is_spillable_regtype(enum bpf_reg_type type)
@@ -11702,34 +11707,36 @@ static int propagate_precision(struct bpf_verifier_env *env,
 {
 	struct bpf_reg_state *state_reg;
 	struct bpf_func_state *state;
-	int i, err = 0;
+	int i, err = 0, fr;
 
-	state = old->frame[old->curframe];
-	state_reg = state->regs;
-	for (i = 0; i < BPF_REG_FP; i++, state_reg++) {
-		if (state_reg->type != SCALAR_VALUE ||
-		    !state_reg->precise)
-			continue;
-		if (env->log.level & BPF_LOG_LEVEL2)
-			verbose(env, "propagating r%d\n", i);
-		err = mark_chain_precision(env, i);
-		if (err < 0)
-			return err;
-	}
+	for (fr = old->curframe; fr >= 0; fr--) {
+		state = old->frame[fr];
+		state_reg = state->regs;
+		for (i = 0; i < BPF_REG_FP; i++, state_reg++) {
+			if (state_reg->type != SCALAR_VALUE ||
+			    !state_reg->precise)
+				continue;
+			if (env->log.level & BPF_LOG_LEVEL2)
+				verbose(env, "frame %d: propagating r%d\n", i, fr);
+			err = mark_chain_precision_frame(env, fr, i);
+			if (err < 0)
+				return err;
+		}
 
-	for (i = 0; i < state->allocated_stack / BPF_REG_SIZE; i++) {
-		if (!is_spilled_reg(&state->stack[i]))
-			continue;
-		state_reg = &state->stack[i].spilled_ptr;
-		if (state_reg->type != SCALAR_VALUE ||
-		    !state_reg->precise)
-			continue;
-		if (env->log.level & BPF_LOG_LEVEL2)
-			verbose(env, "propagating fp%d\n",
-				(-i - 1) * BPF_REG_SIZE);
-		err = mark_chain_precision_stack(env, i);
-		if (err < 0)
-			return err;
+		for (i = 0; i < state->allocated_stack / BPF_REG_SIZE; i++) {
+			if (!is_spilled_reg(&state->stack[i]))
+				continue;
+			state_reg = &state->stack[i].spilled_ptr;
+			if (state_reg->type != SCALAR_VALUE ||
+			    !state_reg->precise)
+				continue;
+			if (env->log.level & BPF_LOG_LEVEL2)
+				verbose(env, "frame %d: propagating fp%d\n",
+					(-i - 1) * BPF_REG_SIZE, fr);
+			err = mark_chain_precision_stack_frame(env, fr, i);
+			if (err < 0)
+				return err;
+		}
 	}
 	return 0;
 }
-- 
2.35.1



