Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259604BE0A7
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244288AbiBUJij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:38:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352057AbiBUJiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:38:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23361A3B6;
        Mon, 21 Feb 2022 01:16:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 08801CE0E76;
        Mon, 21 Feb 2022 09:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B440C340EB;
        Mon, 21 Feb 2022 09:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435007;
        bh=8VU1XlfUYGyslFEo6JXHCftwiWygtPw5POtD+4tXuZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLry55QwhEl/S8rx2kvP2pMrvQqlt56ePghzRKx0BsiuaeLe88Shv+Dam58mkEaCU
         y5tsqhZZJSomYDZBCOFCw/9HMGd1hwiNGkMiW78UkXFcy+MqOppxUy3H0+uBsjcSRX
         y7XRVyx18+08BWSJpn0hV5JY70x5zfByGuBRu0hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.16 004/227] bpf: Replace RET_XXX_OR_NULL with RET_XXX | PTR_MAYBE_NULL
Date:   Mon, 21 Feb 2022 09:47:03 +0100
Message-Id: <20220221084934.979899415@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Hao Luo <haoluo@google.com>

commit 3c4807322660d4290ac9062c034aed6b87243861 upstream.

We have introduced a new type to make bpf_ret composable, by
reserving high bits to represent flags.

One of the flag is PTR_MAYBE_NULL, which indicates a pointer
may be NULL. When applying this flag to ret_types, it means
the returned value could be a NULL pointer. This patch
switches the qualified arg_types to use this flag.
The ret_types changed in this patch include:

1. RET_PTR_TO_MAP_VALUE_OR_NULL
2. RET_PTR_TO_SOCKET_OR_NULL
3. RET_PTR_TO_TCP_SOCK_OR_NULL
4. RET_PTR_TO_SOCK_COMMON_OR_NULL
5. RET_PTR_TO_ALLOC_MEM_OR_NULL
6. RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL
7. RET_PTR_TO_BTF_ID_OR_NULL

This patch doesn't eliminate the use of these names, instead
it makes them aliases to 'RET_PTR_TO_XXX | PTR_MAYBE_NULL'.

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211217003152.48334-4-haoluo@google.com
Cc: stable@vger.kernel.org # 5.16.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h   |   19 +++++++++++-------
 kernel/bpf/helpers.c  |    2 -
 kernel/bpf/verifier.c |   52 +++++++++++++++++++++++++-------------------------
 3 files changed, 39 insertions(+), 34 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -382,17 +382,22 @@ enum bpf_return_type {
 	RET_INTEGER,			/* function returns integer */
 	RET_VOID,			/* function doesn't return anything */
 	RET_PTR_TO_MAP_VALUE,		/* returns a pointer to map elem value */
-	RET_PTR_TO_MAP_VALUE_OR_NULL,	/* returns a pointer to map elem value or NULL */
-	RET_PTR_TO_SOCKET_OR_NULL,	/* returns a pointer to a socket or NULL */
-	RET_PTR_TO_TCP_SOCK_OR_NULL,	/* returns a pointer to a tcp_sock or NULL */
-	RET_PTR_TO_SOCK_COMMON_OR_NULL,	/* returns a pointer to a sock_common or NULL */
-	RET_PTR_TO_ALLOC_MEM_OR_NULL,	/* returns a pointer to dynamically allocated memory or NULL */
-	RET_PTR_TO_BTF_ID_OR_NULL,	/* returns a pointer to a btf_id or NULL */
-	RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL, /* returns a pointer to a valid memory or a btf_id or NULL */
+	RET_PTR_TO_SOCKET,		/* returns a pointer to a socket */
+	RET_PTR_TO_TCP_SOCK,		/* returns a pointer to a tcp_sock */
+	RET_PTR_TO_SOCK_COMMON,		/* returns a pointer to a sock_common */
+	RET_PTR_TO_ALLOC_MEM,		/* returns a pointer to dynamically allocated memory */
 	RET_PTR_TO_MEM_OR_BTF_ID,	/* returns a pointer to a valid memory or a btf_id */
 	RET_PTR_TO_BTF_ID,		/* returns a pointer to a btf_id */
 	__BPF_RET_TYPE_MAX,
 
+	/* Extended ret_types. */
+	RET_PTR_TO_MAP_VALUE_OR_NULL	= PTR_MAYBE_NULL | RET_PTR_TO_MAP_VALUE,
+	RET_PTR_TO_SOCKET_OR_NULL	= PTR_MAYBE_NULL | RET_PTR_TO_SOCKET,
+	RET_PTR_TO_TCP_SOCK_OR_NULL	= PTR_MAYBE_NULL | RET_PTR_TO_TCP_SOCK,
+	RET_PTR_TO_SOCK_COMMON_OR_NULL	= PTR_MAYBE_NULL | RET_PTR_TO_SOCK_COMMON,
+	RET_PTR_TO_ALLOC_MEM_OR_NULL	= PTR_MAYBE_NULL | RET_PTR_TO_ALLOC_MEM,
+	RET_PTR_TO_BTF_ID_OR_NULL	= PTR_MAYBE_NULL | RET_PTR_TO_BTF_ID,
+
 	/* This must be the last entry. Its purpose is to ensure the enum is
 	 * wide enough to hold the higher bits reserved for bpf_type_flag.
 	 */
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -667,7 +667,7 @@ BPF_CALL_2(bpf_per_cpu_ptr, const void *
 const struct bpf_func_proto bpf_per_cpu_ptr_proto = {
 	.func		= bpf_per_cpu_ptr,
 	.gpl_only	= false,
-	.ret_type	= RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL,
+	.ret_type	= RET_PTR_TO_MEM_OR_BTF_ID | PTR_MAYBE_NULL,
 	.arg1_type	= ARG_PTR_TO_PERCPU_BTF_ID,
 	.arg2_type	= ARG_ANYTHING,
 };
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6375,6 +6375,7 @@ static int check_helper_call(struct bpf_
 			     int *insn_idx_p)
 {
 	const struct bpf_func_proto *fn = NULL;
+	enum bpf_return_type ret_type;
 	struct bpf_reg_state *regs;
 	struct bpf_call_arg_meta meta;
 	int insn_idx = *insn_idx_p;
@@ -6508,13 +6509,13 @@ static int check_helper_call(struct bpf_
 	regs[BPF_REG_0].subreg_def = DEF_NOT_SUBREG;
 
 	/* update return register (already marked as written above) */
-	if (fn->ret_type == RET_INTEGER) {
+	ret_type = fn->ret_type;
+	if (ret_type == RET_INTEGER) {
 		/* sets type to SCALAR_VALUE */
 		mark_reg_unknown(env, regs, BPF_REG_0);
-	} else if (fn->ret_type == RET_VOID) {
+	} else if (ret_type == RET_VOID) {
 		regs[BPF_REG_0].type = NOT_INIT;
-	} else if (fn->ret_type == RET_PTR_TO_MAP_VALUE_OR_NULL ||
-		   fn->ret_type == RET_PTR_TO_MAP_VALUE) {
+	} else if (base_type(ret_type) == RET_PTR_TO_MAP_VALUE) {
 		/* There is no offset yet applied, variable or fixed */
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		/* remember map_ptr, so that check_map_access()
@@ -6528,28 +6529,27 @@ static int check_helper_call(struct bpf_
 		}
 		regs[BPF_REG_0].map_ptr = meta.map_ptr;
 		regs[BPF_REG_0].map_uid = meta.map_uid;
-		if (fn->ret_type == RET_PTR_TO_MAP_VALUE) {
+		if (type_may_be_null(ret_type)) {
+			regs[BPF_REG_0].type = PTR_TO_MAP_VALUE_OR_NULL;
+		} else {
 			regs[BPF_REG_0].type = PTR_TO_MAP_VALUE;
 			if (map_value_has_spin_lock(meta.map_ptr))
 				regs[BPF_REG_0].id = ++env->id_gen;
-		} else {
-			regs[BPF_REG_0].type = PTR_TO_MAP_VALUE_OR_NULL;
 		}
-	} else if (fn->ret_type == RET_PTR_TO_SOCKET_OR_NULL) {
+	} else if (base_type(ret_type) == RET_PTR_TO_SOCKET) {
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type = PTR_TO_SOCKET_OR_NULL;
-	} else if (fn->ret_type == RET_PTR_TO_SOCK_COMMON_OR_NULL) {
+	} else if (base_type(ret_type) == RET_PTR_TO_SOCK_COMMON) {
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type = PTR_TO_SOCK_COMMON_OR_NULL;
-	} else if (fn->ret_type == RET_PTR_TO_TCP_SOCK_OR_NULL) {
+	} else if (base_type(ret_type) == RET_PTR_TO_TCP_SOCK) {
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type = PTR_TO_TCP_SOCK_OR_NULL;
-	} else if (fn->ret_type == RET_PTR_TO_ALLOC_MEM_OR_NULL) {
+	} else if (base_type(ret_type) == RET_PTR_TO_ALLOC_MEM) {
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
 		regs[BPF_REG_0].mem_size = meta.mem_size;
-	} else if (fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL ||
-		   fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID) {
+	} else if (base_type(ret_type) == RET_PTR_TO_MEM_OR_BTF_ID) {
 		const struct btf_type *t;
 
 		mark_reg_known_zero(env, regs, BPF_REG_0);
@@ -6568,28 +6568,28 @@ static int check_helper_call(struct bpf_
 				return -EINVAL;
 			}
 			regs[BPF_REG_0].type =
-				fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID ?
-				PTR_TO_MEM : PTR_TO_MEM_OR_NULL;
+				(ret_type & PTR_MAYBE_NULL) ?
+				PTR_TO_MEM_OR_NULL : PTR_TO_MEM;
 			regs[BPF_REG_0].mem_size = tsize;
 		} else {
 			regs[BPF_REG_0].type =
-				fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID ?
-				PTR_TO_BTF_ID : PTR_TO_BTF_ID_OR_NULL;
+				(ret_type & PTR_MAYBE_NULL) ?
+				PTR_TO_BTF_ID_OR_NULL : PTR_TO_BTF_ID;
 			regs[BPF_REG_0].btf = meta.ret_btf;
 			regs[BPF_REG_0].btf_id = meta.ret_btf_id;
 		}
-	} else if (fn->ret_type == RET_PTR_TO_BTF_ID_OR_NULL ||
-		   fn->ret_type == RET_PTR_TO_BTF_ID) {
+	} else if (base_type(ret_type) == RET_PTR_TO_BTF_ID) {
 		int ret_btf_id;
 
 		mark_reg_known_zero(env, regs, BPF_REG_0);
-		regs[BPF_REG_0].type = fn->ret_type == RET_PTR_TO_BTF_ID ?
-						     PTR_TO_BTF_ID :
-						     PTR_TO_BTF_ID_OR_NULL;
+		regs[BPF_REG_0].type = (ret_type & PTR_MAYBE_NULL) ?
+						     PTR_TO_BTF_ID_OR_NULL :
+						     PTR_TO_BTF_ID;
 		ret_btf_id = *fn->ret_btf_id;
 		if (ret_btf_id == 0) {
-			verbose(env, "invalid return type %d of func %s#%d\n",
-				fn->ret_type, func_id_name(func_id), func_id);
+			verbose(env, "invalid return type %u of func %s#%d\n",
+				base_type(ret_type), func_id_name(func_id),
+				func_id);
 			return -EINVAL;
 		}
 		/* current BPF helper definitions are only coming from
@@ -6598,8 +6598,8 @@ static int check_helper_call(struct bpf_
 		regs[BPF_REG_0].btf = btf_vmlinux;
 		regs[BPF_REG_0].btf_id = ret_btf_id;
 	} else {
-		verbose(env, "unknown return type %d of func %s#%d\n",
-			fn->ret_type, func_id_name(func_id), func_id);
+		verbose(env, "unknown return type %u of func %s#%d\n",
+			base_type(ret_type), func_id_name(func_id), func_id);
 		return -EINVAL;
 	}
 


