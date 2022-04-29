Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7176251475C
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356176AbiD2KtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358071AbiD2KsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:48:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEFFC865F;
        Fri, 29 Apr 2022 03:43:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A4C5B83405;
        Fri, 29 Apr 2022 10:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2AFDC385A4;
        Fri, 29 Apr 2022 10:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651229017;
        bh=reDSbp8xMqyh27R/JkwS8GqI9GdQdQrFP43vsRS78Yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mBRm8wSAsAVdBLefL/2BtbLHrx52Fi8hh9HNNr3zo/Tp/rUqJLjYVH+J3sNgOSCG3
         GrejcNluRrlMujuBds+0NeQPtPRByvi3/y96HcfNk+KIjHFW+NcFBayiGP8LhPnAOj
         Ta1HnWzCShwJrGhdQeMdap9ZFEwIkBCFAfX8t3hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 04/33] bpf: Replace RET_XXX_OR_NULL with RET_XXX | PTR_MAYBE_NULL
Date:   Fri, 29 Apr 2022 12:41:51 +0200
Message-Id: <20220429104052.472800855@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429104052.345760505@linuxfoundation.org>
References: <20220429104052.345760505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Cc: stable@vger.kernel.org # 5.15.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h   |   19 +++++++++++-------
 kernel/bpf/helpers.c  |    2 -
 kernel/bpf/verifier.c |   52 +++++++++++++++++++++++++-------------------------
 3 files changed, 39 insertions(+), 34 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -378,17 +378,22 @@ enum bpf_return_type {
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
@@ -6195,6 +6195,7 @@ static int check_helper_call(struct bpf_
 			     int *insn_idx_p)
 {
 	const struct bpf_func_proto *fn = NULL;
+	enum bpf_return_type ret_type;
 	struct bpf_reg_state *regs;
 	struct bpf_call_arg_meta meta;
 	int insn_idx = *insn_idx_p;
@@ -6328,13 +6329,13 @@ static int check_helper_call(struct bpf_
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
@@ -6348,28 +6349,27 @@ static int check_helper_call(struct bpf_
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
@@ -6388,28 +6388,28 @@ static int check_helper_call(struct bpf_
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
@@ -6418,8 +6418,8 @@ static int check_helper_call(struct bpf_
 		regs[BPF_REG_0].btf = btf_vmlinux;
 		regs[BPF_REG_0].btf_id = ret_btf_id;
 	} else {
-		verbose(env, "unknown return type %d of func %s#%d\n",
-			fn->ret_type, func_id_name(func_id), func_id);
+		verbose(env, "unknown return type %u of func %s#%d\n",
+			base_type(ret_type), func_id_name(func_id), func_id);
 		return -EINVAL;
 	}
 


