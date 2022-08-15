Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994F1593FB9
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344871AbiHOVLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348214AbiHOVIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:08:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BDB52FD0;
        Mon, 15 Aug 2022 12:18:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20C67B8110A;
        Mon, 15 Aug 2022 19:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50021C433D6;
        Mon, 15 Aug 2022 19:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591114;
        bh=AiL8C4bcc+DV1FzeQRqw5uNlFaO1A51bBlHx9EuX62o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygE+KI2PtKf5a6j1bOhVgQVql+ktUTox0/XTN/ISKNKwPBHUgY4XlKOESkjL8hpOG
         yOGnPZHtYZiYxl8BvoCtchVhzS3/2Ym1VkaK0RW5d1Mfp3/GVegFFUtEQ6A6Ttej8u
         WGxf2NpQpoDN24iAI7MCAeZU8EuTxWM+PvKmeHtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0477/1095] bpf: Tag argument to be released in bpf_func_proto
Date:   Mon, 15 Aug 2022 19:57:56 +0200
Message-Id: <20220815180449.318005835@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 8f14852e89113d738c99c375b4c8b8b7e1073df1 ]

Add a new type flag for bpf_arg_type that when set tells verifier that
for a release function, that argument's register will be the one for
which meta.ref_obj_id will be set, and which will then be released
using release_reference. To capture the regno, introduce a new field
release_regno in bpf_call_arg_meta.

This would be required in the next patch, where we may either pass NULL
or a refcounted pointer as an argument to the release function
bpf_kptr_xchg. Just releasing only when meta.ref_obj_id is set is not
enough, as there is a case where the type of argument needed matches,
but the ref_obj_id is set to 0. Hence, we must enforce that whenever
meta.ref_obj_id is zero, the register that is to be released can only
be NULL for a release function.

Since we now indicate whether an argument is to be released in
bpf_func_proto itself, is_release_function helper has lost its utitlity,
hence refactor code to work without it, and just rely on
meta.release_regno to know when to release state for a ref_obj_id.
Still, the restriction of one release argument and only one ref_obj_id
passed to BPF helper or kfunc remains. This may be lifted in the future.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220424214901.2743946-3-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h                           |  5 +-
 include/linux/bpf_verifier.h                  |  3 +-
 kernel/bpf/btf.c                              | 11 ++-
 kernel/bpf/ringbuf.c                          |  4 +-
 kernel/bpf/verifier.c                         | 76 +++++++++++--------
 net/core/filter.c                             |  2 +-
 .../selftests/bpf/verifier/ref_tracking.c     |  2 +-
 tools/testing/selftests/bpf/verifier/sock.c   |  6 +-
 8 files changed, 60 insertions(+), 49 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 00d55c10d876..2feae4a24d99 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -366,7 +366,10 @@ enum bpf_type_flag {
 	 */
 	MEM_PERCPU		= BIT(4 + BPF_BASE_TYPE_BITS),
 
-	__BPF_TYPE_LAST_FLAG	= MEM_PERCPU,
+	/* Indicates that the argument will be released. */
+	OBJ_RELEASE		= BIT(5 + BPF_BASE_TYPE_BITS),
+
+	__BPF_TYPE_LAST_FLAG	= OBJ_RELEASE,
 };
 
 /* Max number of base types. */
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 3a9d2d7cc6b7..1f1e7f2ea967 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -523,8 +523,7 @@ int check_ptr_off_reg(struct bpf_verifier_env *env,
 		      const struct bpf_reg_state *reg, int regno);
 int check_func_arg_reg_off(struct bpf_verifier_env *env,
 			   const struct bpf_reg_state *reg, int regno,
-			   enum bpf_arg_type arg_type,
-			   bool is_release_func);
+			   enum bpf_arg_type arg_type);
 int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
 			     u32 regno);
 int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index cbb48eb8c009..752de8112206 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5994,6 +5994,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 	 * verifier sees.
 	 */
 	for (i = 0; i < nargs; i++) {
+		enum bpf_arg_type arg_type = ARG_DONTCARE;
 		u32 regno = i + 1;
 		struct bpf_reg_state *reg = &regs[regno];
 
@@ -6014,7 +6015,9 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		ref_t = btf_type_skip_modifiers(btf, t->type, &ref_id);
 		ref_tname = btf_name_by_offset(btf, ref_t->name_off);
 
-		ret = check_func_arg_reg_off(env, reg, regno, ARG_DONTCARE, rel);
+		if (rel && reg->ref_obj_id)
+			arg_type |= OBJ_RELEASE;
+		ret = check_func_arg_reg_off(env, reg, regno, arg_type);
 		if (ret < 0)
 			return ret;
 
@@ -6045,11 +6048,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			if (reg->type == PTR_TO_BTF_ID) {
 				reg_btf = reg->btf;
 				reg_ref_id = reg->btf_id;
-				/* Ensure only one argument is referenced
-				 * PTR_TO_BTF_ID, check_func_arg_reg_off relies
-				 * on only one referenced register being allowed
-				 * for kfuncs.
-				 */
+				/* Ensure only one argument is referenced PTR_TO_BTF_ID */
 				if (reg->ref_obj_id) {
 					if (ref_obj_id) {
 						bpf_log(log, "verifier internal error: more than one arg with ref_obj_id R%d %u %u\n",
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 710ba9de12ce..5173fd37590f 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -404,7 +404,7 @@ BPF_CALL_2(bpf_ringbuf_submit, void *, sample, u64, flags)
 const struct bpf_func_proto bpf_ringbuf_submit_proto = {
 	.func		= bpf_ringbuf_submit,
 	.ret_type	= RET_VOID,
-	.arg1_type	= ARG_PTR_TO_ALLOC_MEM,
+	.arg1_type	= ARG_PTR_TO_ALLOC_MEM | OBJ_RELEASE,
 	.arg2_type	= ARG_ANYTHING,
 };
 
@@ -417,7 +417,7 @@ BPF_CALL_2(bpf_ringbuf_discard, void *, sample, u64, flags)
 const struct bpf_func_proto bpf_ringbuf_discard_proto = {
 	.func		= bpf_ringbuf_discard,
 	.ret_type	= RET_VOID,
-	.arg1_type	= ARG_PTR_TO_ALLOC_MEM,
+	.arg1_type	= ARG_PTR_TO_ALLOC_MEM | OBJ_RELEASE,
 	.arg2_type	= ARG_ANYTHING,
 };
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b8d1060153c8..4f19a86c2682 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -245,6 +245,7 @@ struct bpf_call_arg_meta {
 	struct bpf_map *map_ptr;
 	bool raw_mode;
 	bool pkt_access;
+	u8 release_regno;
 	int regno;
 	int access_size;
 	int mem_size;
@@ -471,17 +472,6 @@ static bool type_may_be_null(u32 type)
 	return type & PTR_MAYBE_NULL;
 }
 
-/* Determine whether the function releases some resources allocated by another
- * function call. The first reference type argument will be assumed to be
- * released by release_reference().
- */
-static bool is_release_function(enum bpf_func_id func_id)
-{
-	return func_id == BPF_FUNC_sk_release ||
-	       func_id == BPF_FUNC_ringbuf_submit ||
-	       func_id == BPF_FUNC_ringbuf_discard;
-}
-
 static bool may_be_acquire_function(enum bpf_func_id func_id)
 {
 	return func_id == BPF_FUNC_sk_lookup_tcp ||
@@ -5325,6 +5315,11 @@ static bool arg_type_is_int_ptr(enum bpf_arg_type type)
 	       type == ARG_PTR_TO_LONG;
 }
 
+static bool arg_type_is_release(enum bpf_arg_type type)
+{
+	return type & OBJ_RELEASE;
+}
+
 static int int_ptr_type_to_size(enum bpf_arg_type type)
 {
 	if (type == ARG_PTR_TO_INT)
@@ -5535,11 +5530,10 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
 
 int check_func_arg_reg_off(struct bpf_verifier_env *env,
 			   const struct bpf_reg_state *reg, int regno,
-			   enum bpf_arg_type arg_type,
-			   bool is_release_func)
+			   enum bpf_arg_type arg_type)
 {
-	bool fixed_off_ok = false, release_reg;
 	enum bpf_reg_type type = reg->type;
+	bool fixed_off_ok = false;
 
 	switch ((u32)type) {
 	case SCALAR_VALUE:
@@ -5557,7 +5551,7 @@ int check_func_arg_reg_off(struct bpf_verifier_env *env,
 		/* Some of the argument types nevertheless require a
 		 * zero register offset.
 		 */
-		if (arg_type != ARG_PTR_TO_ALLOC_MEM)
+		if (base_type(arg_type) != ARG_PTR_TO_ALLOC_MEM)
 			return 0;
 		break;
 	/* All the rest must be rejected, except PTR_TO_BTF_ID which allows
@@ -5565,19 +5559,17 @@ int check_func_arg_reg_off(struct bpf_verifier_env *env,
 	 */
 	case PTR_TO_BTF_ID:
 		/* When referenced PTR_TO_BTF_ID is passed to release function,
-		 * it's fixed offset must be 0. We rely on the property that
-		 * only one referenced register can be passed to BPF helpers and
-		 * kfuncs. In the other cases, fixed offset can be non-zero.
+		 * it's fixed offset must be 0.	In the other cases, fixed offset
+		 * can be non-zero.
 		 */
-		release_reg = is_release_func && reg->ref_obj_id;
-		if (release_reg && reg->off) {
+		if (arg_type_is_release(arg_type) && reg->off) {
 			verbose(env, "R%d must have zero offset when passed to release func\n",
 				regno);
 			return -EINVAL;
 		}
-		/* For release_reg == true, fixed_off_ok must be false, but we
-		 * already checked and rejected reg->off != 0 above, so set to
-		 * true to allow fixed offset for all other cases.
+		/* For arg is release pointer, fixed_off_ok must be false, but
+		 * we already checked and rejected reg->off != 0 above, so set
+		 * to true to allow fixed offset for all other cases.
 		 */
 		fixed_off_ok = true;
 		break;
@@ -5636,14 +5628,24 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 	if (err)
 		return err;
 
-	err = check_func_arg_reg_off(env, reg, regno, arg_type, is_release_function(meta->func_id));
+	err = check_func_arg_reg_off(env, reg, regno, arg_type);
 	if (err)
 		return err;
 
 skip_type_check:
-	/* check_func_arg_reg_off relies on only one referenced register being
-	 * allowed for BPF helpers.
-	 */
+	if (arg_type_is_release(arg_type)) {
+		if (!reg->ref_obj_id && !register_is_null(reg)) {
+			verbose(env, "R%d must be referenced when passed to release function\n",
+				regno);
+			return -EINVAL;
+		}
+		if (meta->release_regno) {
+			verbose(env, "verifier internal error: more than one release argument\n");
+			return -EFAULT;
+		}
+		meta->release_regno = regno;
+	}
+
 	if (reg->ref_obj_id) {
 		if (meta->ref_obj_id) {
 			verbose(env, "verifier internal error: more than one arg with ref_obj_id R%d %u %u\n",
@@ -6151,7 +6153,8 @@ static bool check_btf_id_ok(const struct bpf_func_proto *fn)
 	return true;
 }
 
-static int check_func_proto(const struct bpf_func_proto *fn, int func_id)
+static int check_func_proto(const struct bpf_func_proto *fn, int func_id,
+			    struct bpf_call_arg_meta *meta)
 {
 	return check_raw_mode_ok(fn) &&
 	       check_arg_pair_ok(fn) &&
@@ -6833,7 +6836,7 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 	memset(&meta, 0, sizeof(meta));
 	meta.pkt_access = fn->pkt_access;
 
-	err = check_func_proto(fn, func_id);
+	err = check_func_proto(fn, func_id, &meta);
 	if (err) {
 		verbose(env, "kernel subsystem misconfigured func %s#%d\n",
 			func_id_name(func_id), func_id);
@@ -6866,8 +6869,17 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 			return err;
 	}
 
-	if (is_release_function(func_id)) {
-		err = release_reference(env, meta.ref_obj_id);
+	regs = cur_regs(env);
+
+	if (meta.release_regno) {
+		err = -EINVAL;
+		if (meta.ref_obj_id)
+			err = release_reference(env, meta.ref_obj_id);
+		/* meta.ref_obj_id can only be 0 if register that is meant to be
+		 * released is NULL, which must be > R0.
+		 */
+		else if (register_is_null(&regs[meta.release_regno]))
+			err = 0;
 		if (err) {
 			verbose(env, "func %s#%d reference has not been acquired before\n",
 				func_id_name(func_id), func_id);
@@ -6875,8 +6887,6 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		}
 	}
 
-	regs = cur_regs(env);
-
 	switch (func_id) {
 	case BPF_FUNC_tail_call:
 		err = check_reference_leak(env);
diff --git a/net/core/filter.c b/net/core/filter.c
index d0b0c163d3f3..5db4fae23925 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6642,7 +6642,7 @@ static const struct bpf_func_proto bpf_sk_release_proto = {
 	.func		= bpf_sk_release,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_BTF_ID_SOCK_COMMON,
+	.arg1_type	= ARG_PTR_TO_BTF_ID_SOCK_COMMON | OBJ_RELEASE,
 };
 
 BPF_CALL_5(bpf_xdp_sk_lookup_udp, struct xdp_buff *, ctx,
diff --git a/tools/testing/selftests/bpf/verifier/ref_tracking.c b/tools/testing/selftests/bpf/verifier/ref_tracking.c
index fbd682520e47..57a83d763ec1 100644
--- a/tools/testing/selftests/bpf/verifier/ref_tracking.c
+++ b/tools/testing/selftests/bpf/verifier/ref_tracking.c
@@ -796,7 +796,7 @@
 	},
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.result = REJECT,
-	.errstr = "reference has not been acquired before",
+	.errstr = "R1 must be referenced when passed to release function",
 },
 {
 	/* !bpf_sk_fullsock(sk) is checked but !bpf_tcp_sock(sk) is not checked */
diff --git a/tools/testing/selftests/bpf/verifier/sock.c b/tools/testing/selftests/bpf/verifier/sock.c
index 86b24cad27a7..d11d0b28be41 100644
--- a/tools/testing/selftests/bpf/verifier/sock.c
+++ b/tools/testing/selftests/bpf/verifier/sock.c
@@ -417,7 +417,7 @@
 	},
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.result = REJECT,
-	.errstr = "reference has not been acquired before",
+	.errstr = "R1 must be referenced when passed to release function",
 },
 {
 	"bpf_sk_release(bpf_sk_fullsock(skb->sk))",
@@ -436,7 +436,7 @@
 	},
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.result = REJECT,
-	.errstr = "reference has not been acquired before",
+	.errstr = "R1 must be referenced when passed to release function",
 },
 {
 	"bpf_sk_release(bpf_tcp_sock(skb->sk))",
@@ -455,7 +455,7 @@
 	},
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.result = REJECT,
-	.errstr = "reference has not been acquired before",
+	.errstr = "R1 must be referenced when passed to release function",
 },
 {
 	"sk_storage_get(map, skb->sk, NULL, 0): value == NULL",
-- 
2.35.1



