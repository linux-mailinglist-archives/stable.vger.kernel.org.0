Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5AE1604013
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbiJSJm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234759AbiJSJlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:41:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894FAF41BE;
        Wed, 19 Oct 2022 02:17:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BCFF61841;
        Wed, 19 Oct 2022 08:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE503C433C1;
        Wed, 19 Oct 2022 08:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169424;
        bh=EGcsfzoNPFKFZSw/DSUmI+rLPToiQsF/UsMGg+e9mb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRCQisENAx/Ipp+M60IQyMPgO5wVgIQsFlHsG2I63H7ABYPVjNEuvanhOR05IN983
         0bTTgNSnraUTmFQV7YrdTJIA96BK93sMSrz+NFau7AfuBVKaID3/rLeXXTrwnRjSnk
         UOVN0vZk2nEhyidO7BaCDTVJJZjIWIazAR4LgnXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 237/862] bpf: Fix reference state management for synchronous callbacks
Date:   Wed, 19 Oct 2022 10:25:24 +0200
Message-Id: <20221019083300.514252157@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 9d9d00ac29d0ef7ce426964de46fa6b380357d0a ]

Currently, verifier verifies callback functions (sync and async) as if
they will be executed once, (i.e. it explores execution state as if the
function was being called once). The next insn to explore is set to
start of subprog and the exit from nested frame is handled using
curframe > 0 and prepare_func_exit. In case of async callback it uses a
customized variant of push_stack simulating a kind of branch to set up
custom state and execution context for the async callback.

While this approach is simple and works when callback really will be
executed only once, it is unsafe for all of our current helpers which
are for_each style, i.e. they execute the callback multiple times.

A callback releasing acquired references of the caller may do so
multiple times, but currently verifier sees it as one call inside the
frame, which then returns to caller. Hence, it thinks it released some
reference that the cb e.g. got access through callback_ctx (register
filled inside cb from spilled typed register on stack).

Similarly, it may see that an acquire call is unpaired inside the
callback, so the caller will copy the reference state of callback and
then will have to release the register with new ref_obj_ids. But again,
the callback may execute multiple times, but the verifier will only
account for acquired references for a single symbolic execution of the
callback, which will cause leaks.

Note that for async callback case, things are different. While currently
we have bpf_timer_set_callback which only executes it once, even for
multiple executions it would be safe, as reference state is NULL and
check_reference_leak would force program to release state before
BPF_EXIT. The state is also unaffected by analysis for the caller frame.
Hence async callback is safe.

Since we want the reference state to be accessible, e.g. for pointers
loaded from stack through callback_ctx's PTR_TO_STACK, we still have to
copy caller's reference_state to callback's bpf_func_state, but we
enforce that whatever references it adds to that reference_state has
been released before it hits BPF_EXIT. This requires introducing a new
callback_ref member in the reference state to distinguish between caller
vs callee references. Hence, check_reference_leak now errors out if it
sees we are in callback_fn and we have not released callback_ref refs.
Since there can be multiple nested callbacks, like frame 0 -> cb1 -> cb2
etc. we need to also distinguish between whether this particular ref
belongs to this callback frame or parent, and only error for our own, so
we store state->frameno (which is always non-zero for callbacks).

In short, callbacks can read parent reference_state, but cannot mutate
it, to be able to use pointers acquired by the caller. They must only
undo their changes (by releasing their own acquired_refs before
BPF_EXIT) on top of caller reference_state before returning (at which
point the caller and callback state will match anyway, so no need to
copy it back to caller).

Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20220823013125.24938-1-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h | 11 ++++++++++
 kernel/bpf/verifier.c        | 42 ++++++++++++++++++++++++++++--------
 2 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 2e3bad8640dc..1fdddbf3546b 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -212,6 +212,17 @@ struct bpf_reference_state {
 	 * is used purely to inform the user of a reference leak.
 	 */
 	int insn_idx;
+	/* There can be a case like:
+	 * main (frame 0)
+	 *  cb (frame 1)
+	 *   func (frame 3)
+	 *    cb (frame 4)
+	 * Hence for frame 4, if callback_ref just stored boolean, it would be
+	 * impossible to distinguish nested callback refs. Hence store the
+	 * frameno and compare that to callback_ref in check_reference_leak when
+	 * exiting a callback function.
+	 */
+	int callback_ref;
 };
 
 /* state of the program:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c127585ad429..8b5ea7f6b536 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1092,6 +1092,7 @@ static int acquire_reference_state(struct bpf_verifier_env *env, int insn_idx)
 	id = ++env->id_gen;
 	state->refs[new_ofs].id = id;
 	state->refs[new_ofs].insn_idx = insn_idx;
+	state->refs[new_ofs].callback_ref = state->in_callback_fn ? state->frameno : 0;
 
 	return id;
 }
@@ -1104,6 +1105,9 @@ static int release_reference_state(struct bpf_func_state *state, int ptr_id)
 	last_idx = state->acquired_refs - 1;
 	for (i = 0; i < state->acquired_refs; i++) {
 		if (state->refs[i].id == ptr_id) {
+			/* Cannot release caller references in callbacks */
+			if (state->in_callback_fn && state->refs[i].callback_ref != state->frameno)
+				return -EINVAL;
 			if (last_idx && i != last_idx)
 				memcpy(&state->refs[i], &state->refs[last_idx],
 				       sizeof(*state->refs));
@@ -6919,10 +6923,17 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 		caller->regs[BPF_REG_0] = *r0;
 	}
 
-	/* Transfer references to the caller */
-	err = copy_reference_state(caller, callee);
-	if (err)
-		return err;
+	/* callback_fn frame should have released its own additions to parent's
+	 * reference state at this point, or check_reference_leak would
+	 * complain, hence it must be the same as the caller. There is no need
+	 * to copy it back.
+	 */
+	if (!callee->in_callback_fn) {
+		/* Transfer references to the caller */
+		err = copy_reference_state(caller, callee);
+		if (err)
+			return err;
+	}
 
 	*insn_idx = callee->callsite + 1;
 	if (env->log.level & BPF_LOG_LEVEL) {
@@ -7044,13 +7055,20 @@ record_func_key(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 static int check_reference_leak(struct bpf_verifier_env *env)
 {
 	struct bpf_func_state *state = cur_func(env);
+	bool refs_lingering = false;
 	int i;
 
+	if (state->frameno && !state->in_callback_fn)
+		return 0;
+
 	for (i = 0; i < state->acquired_refs; i++) {
+		if (state->in_callback_fn && state->refs[i].callback_ref != state->frameno)
+			continue;
 		verbose(env, "Unreleased reference id=%d alloc_insn=%d\n",
 			state->refs[i].id, state->refs[i].insn_idx);
+		refs_lingering = true;
 	}
-	return state->acquired_refs ? -EINVAL : 0;
+	return refs_lingering ? -EINVAL : 0;
 }
 
 static int check_bpf_snprintf_call(struct bpf_verifier_env *env,
@@ -12319,6 +12337,16 @@ static int do_check(struct bpf_verifier_env *env)
 					return -EINVAL;
 				}
 
+				/* We must do check_reference_leak here before
+				 * prepare_func_exit to handle the case when
+				 * state->curframe > 0, it may be a callback
+				 * function, for which reference_state must
+				 * match caller reference state when it exits.
+				 */
+				err = check_reference_leak(env);
+				if (err)
+					return err;
+
 				if (state->curframe) {
 					/* exit from nested function */
 					err = prepare_func_exit(env, &env->insn_idx);
@@ -12328,10 +12356,6 @@ static int do_check(struct bpf_verifier_env *env)
 					continue;
 				}
 
-				err = check_reference_leak(env);
-				if (err)
-					return err;
-
 				err = check_return_code(env);
 				if (err)
 					return err;
-- 
2.35.1



