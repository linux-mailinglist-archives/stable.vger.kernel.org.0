Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D21513F4E
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 02:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353485AbiD2ACo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 20:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353488AbiD2ACm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 20:02:42 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E423B3DF2
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z15-20020a25bb0f000000b00613388c7d99so6042652ybg.8
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nm+T8A3rSmIEMijAcxHl0Z675bTOaomC/R4t4xGVzsY=;
        b=hxt5Oodza/4OEHaFEORcb4j8O0f9eteqjnD22OZRy6Tv+EImnbtpiWOp20kXmA4Emj
         Pdu/NJFSNWLjA2p8TKv7A7mEoBk8ccwpmRyXjN4fGtJ0y+G9//kv7hZUdgQ6aWaGRyEz
         8z9ipcSbWDLg6oEBjoN3VlohllO5fbuzGm9VNBrOHXS+Es2qNNHdAWy4gPx99HFrSPjf
         0+mPuxE5eDX+ExO+qkJ6udZlgDHXwQRrdJ4ilSqC3mbHGrccwyekYUNFeAjfzVS3Itti
         kz6Uc3W85FicTAkxkxSu13Y8zNDJ0hfm7GrugXWEel4kIuG8seGuXB3vRiVXsxyG7OkO
         pe8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nm+T8A3rSmIEMijAcxHl0Z675bTOaomC/R4t4xGVzsY=;
        b=HrG98vR/2v99onLz7urVErBT7WkR7rUFiWcKE0UjJx6uXECn1JCz04+JSoNFZET3tL
         HrxZemUpVQ9q1l+9INZygvDYjLgrAqdMgv0w9Sy8q00WvsC4Swasg8DmZF8mdiYVNH5C
         RWC3XokQiyuCqDRDa9n6DJQkLUvf2MRdAK8e5GzXHRqEQXMOAp6nQOsgJSnKyGpzRanh
         EMGgwgWQjvpt1lrp7uEbaqj6LhyNSCvJMJR9G4FPF3JTjxVpvWiexeY8qsva1Gcd3Q7U
         eA/ZkAhfPjdmt0otfRSyB0TUi4zmJ9oWAYqGOnB5yul/X9y4+wFF6qZIz1UTnqylIU4Y
         RO3w==
X-Gm-Message-State: AOAM530QNuTuiM6SobtjgXpnLwZTtkkL9ctEgTwc954trfLCSxsYOSv0
        l/bOEoti5dENdaNJdbt/63Km9hmGMIY=
X-Google-Smtp-Source: ABdhPJyAWnTGLMl6cDB9i0F4FFGp2/C/QeuTAQ+p4LeiNroNguyksZ12Ontp4K4yir3PS99hsj16aeTWrvo=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:25cd:1665:36bc:f38e])
 (user=haoluo job=sendgmr) by 2002:a81:5bc5:0:b0:2d6:5659:73c2 with SMTP id
 p188-20020a815bc5000000b002d6565973c2mr36253370ywb.121.1651190365174; Thu, 28
 Apr 2022 16:59:25 -0700 (PDT)
Date:   Thu, 28 Apr 2022 16:57:46 -0700
In-Reply-To: <20220428235751.103203-1-haoluo@google.com>
Message-Id: <20220428235751.103203-6-haoluo@google.com>
Mime-Version: 1.0
References: <20220428235751.103203-1-haoluo@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH stable linux-5.15.y 05/10] bpf: Introduce MEM_RDONLY flag
From:   Hao Luo <haoluo@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, laura@labbott.name,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 20b2aff4bc15bda809f994761d5719827d66c0b4 upstream.

This patch introduce a flag MEM_RDONLY to tag a reg value
pointing to read-only memory. It makes the following changes:

1. PTR_TO_RDWR_BUF -> PTR_TO_BUF
2. PTR_TO_RDONLY_BUF -> PTR_TO_BUF | MEM_RDONLY

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211217003152.48334-6-haoluo@google.com
Cc: stable@vger.kernel.org # 5.15.x
---
 include/linux/bpf.h       |  8 ++--
 kernel/bpf/btf.c          |  3 +-
 kernel/bpf/map_iter.c     |  4 +-
 kernel/bpf/verifier.c     | 84 +++++++++++++++++++++++----------------
 net/core/bpf_sk_storage.c |  2 +-
 net/core/sock_map.c       |  2 +-
 6 files changed, 60 insertions(+), 43 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7249f5e2480e..83c28c683b6d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -307,7 +307,10 @@ enum bpf_type_flag {
 	/* PTR may be NULL. */
 	PTR_MAYBE_NULL		= BIT(0 + BPF_BASE_TYPE_BITS),
 
-	__BPF_TYPE_LAST_FLAG	= PTR_MAYBE_NULL,
+	/* MEM is read-only. */
+	MEM_RDONLY		= BIT(1 + BPF_BASE_TYPE_BITS),
+
+	__BPF_TYPE_LAST_FLAG	= MEM_RDONLY,
 };
 
 /* Max number of base types. */
@@ -488,8 +491,7 @@ enum bpf_reg_type {
 	 * an explicit null check is required for this struct.
 	 */
 	PTR_TO_MEM,		 /* reg points to valid memory region */
-	PTR_TO_RDONLY_BUF,	 /* reg points to a readonly buffer */
-	PTR_TO_RDWR_BUF,	 /* reg points to a read/write buffer */
+	PTR_TO_BUF,		 /* reg points to a read/write buffer */
 	PTR_TO_PERCPU_BTF_ID,	 /* reg points to a percpu kernel variable */
 	PTR_TO_FUNC,		 /* reg points to a bpf program function */
 	__BPF_REG_TYPE_MAX,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 1872b3e05d6c..9247dfcde054 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4804,8 +4804,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 
 		type = base_type(ctx_arg_info->reg_type);
 		flag = type_flag(ctx_arg_info->reg_type);
-		if (ctx_arg_info->offset == off &&
-		    (type == PTR_TO_RDWR_BUF || type == PTR_TO_RDONLY_BUF) &&
+		if (ctx_arg_info->offset == off && type == PTR_TO_BUF &&
 		    (flag & PTR_MAYBE_NULL)) {
 			info->reg_type = ctx_arg_info->reg_type;
 			return true;
diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
index 631f0e44b7a9..b0fa190b0979 100644
--- a/kernel/bpf/map_iter.c
+++ b/kernel/bpf/map_iter.c
@@ -174,9 +174,9 @@ static const struct bpf_iter_reg bpf_map_elem_reg_info = {
 	.ctx_arg_info_size	= 2,
 	.ctx_arg_info		= {
 		{ offsetof(struct bpf_iter__bpf_map_elem, key),
-		  PTR_TO_RDONLY_BUF | PTR_MAYBE_NULL },
+		  PTR_TO_BUF | PTR_MAYBE_NULL | MEM_RDONLY },
 		{ offsetof(struct bpf_iter__bpf_map_elem, value),
-		  PTR_TO_RDWR_BUF | PTR_MAYBE_NULL },
+		  PTR_TO_BUF | PTR_MAYBE_NULL },
 	},
 };
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 24e9955a93e5..0de4a9458bf7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -458,6 +458,11 @@ static bool reg_type_may_be_refcounted_or_null(enum bpf_reg_type type)
 		base_type(type) == PTR_TO_MEM;
 }
 
+static bool type_is_rdonly_mem(u32 type)
+{
+	return type & MEM_RDONLY;
+}
+
 static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
 {
 	return type == ARG_PTR_TO_SOCK_COMMON;
@@ -533,7 +538,7 @@ static bool is_cmpxchg_insn(const struct bpf_insn *insn)
 static const char *reg_type_str(struct bpf_verifier_env *env,
 				enum bpf_reg_type type)
 {
-	char postfix[16] = {0};
+	char postfix[16] = {0}, prefix[16] = {0};
 	static const char * const str[] = {
 		[NOT_INIT]		= "?",
 		[SCALAR_VALUE]		= "inv",
@@ -553,8 +558,7 @@ static const char *reg_type_str(struct bpf_verifier_env *env,
 		[PTR_TO_BTF_ID]		= "ptr_",
 		[PTR_TO_PERCPU_BTF_ID]	= "percpu_ptr_",
 		[PTR_TO_MEM]		= "mem",
-		[PTR_TO_RDONLY_BUF]	= "rdonly_buf",
-		[PTR_TO_RDWR_BUF]	= "rdwr_buf",
+		[PTR_TO_BUF]		= "buf",
 		[PTR_TO_FUNC]		= "func",
 		[PTR_TO_MAP_KEY]	= "map_key",
 	};
@@ -567,8 +571,11 @@ static const char *reg_type_str(struct bpf_verifier_env *env,
 			strncpy(postfix, "_or_null", 16);
 	}
 
-	snprintf(env->type_str_buf, TYPE_STR_BUF_LEN, "%s%s",
-		 str[base_type(type)], postfix);
+	if (type & MEM_RDONLY)
+		strncpy(prefix, "rdonly_", 16);
+
+	snprintf(env->type_str_buf, TYPE_STR_BUF_LEN, "%s%s%s",
+		 prefix, str[base_type(type)], postfix);
 	return env->type_str_buf;
 }
 
@@ -2546,8 +2553,7 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_XDP_SOCK:
 	case PTR_TO_BTF_ID:
-	case PTR_TO_RDONLY_BUF:
-	case PTR_TO_RDWR_BUF:
+	case PTR_TO_BUF:
 	case PTR_TO_PERCPU_BTF_ID:
 	case PTR_TO_MEM:
 	case PTR_TO_FUNC:
@@ -4275,22 +4281,28 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 	} else if (reg->type == CONST_PTR_TO_MAP) {
 		err = check_ptr_to_map_access(env, regs, regno, off, size, t,
 					      value_regno);
-	} else if (reg->type == PTR_TO_RDONLY_BUF) {
-		if (t == BPF_WRITE) {
-			verbose(env, "R%d cannot write into %s\n",
-				regno, reg_type_str(env, reg->type));
-			return -EACCES;
+	} else if (base_type(reg->type) == PTR_TO_BUF) {
+		bool rdonly_mem = type_is_rdonly_mem(reg->type);
+		const char *buf_info;
+		u32 *max_access;
+
+		if (rdonly_mem) {
+			if (t == BPF_WRITE) {
+				verbose(env, "R%d cannot write into %s\n",
+					regno, reg_type_str(env, reg->type));
+				return -EACCES;
+			}
+			buf_info = "rdonly";
+			max_access = &env->prog->aux->max_rdonly_access;
+		} else {
+			buf_info = "rdwr";
+			max_access = &env->prog->aux->max_rdwr_access;
 		}
+
 		err = check_buffer_access(env, reg, regno, off, size, false,
-					  "rdonly",
-					  &env->prog->aux->max_rdonly_access);
-		if (!err && value_regno >= 0)
-			mark_reg_unknown(env, regs, value_regno);
-	} else if (reg->type == PTR_TO_RDWR_BUF) {
-		err = check_buffer_access(env, reg, regno, off, size, false,
-					  "rdwr",
-					  &env->prog->aux->max_rdwr_access);
-		if (!err && t == BPF_READ && value_regno >= 0)
+					  buf_info, max_access);
+
+		if (!err && value_regno >= 0 && (rdonly_mem || t == BPF_READ))
 			mark_reg_unknown(env, regs, value_regno);
 	} else {
 		verbose(env, "R%d invalid mem access '%s'\n", regno,
@@ -4551,8 +4563,10 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
 				   struct bpf_call_arg_meta *meta)
 {
 	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
+	const char *buf_info;
+	u32 *max_access;
 
-	switch (reg->type) {
+	switch (base_type(reg->type)) {
 	case PTR_TO_PACKET:
 	case PTR_TO_PACKET_META:
 		return check_packet_access(env, regno, reg->off, access_size,
@@ -4571,18 +4585,20 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
 		return check_mem_region_access(env, regno, reg->off,
 					       access_size, reg->mem_size,
 					       zero_size_allowed);
-	case PTR_TO_RDONLY_BUF:
-		if (meta && meta->raw_mode)
-			return -EACCES;
-		return check_buffer_access(env, reg, regno, reg->off,
-					   access_size, zero_size_allowed,
-					   "rdonly",
-					   &env->prog->aux->max_rdonly_access);
-	case PTR_TO_RDWR_BUF:
+	case PTR_TO_BUF:
+		if (type_is_rdonly_mem(reg->type)) {
+			if (meta && meta->raw_mode)
+				return -EACCES;
+
+			buf_info = "rdonly";
+			max_access = &env->prog->aux->max_rdonly_access;
+		} else {
+			buf_info = "rdwr";
+			max_access = &env->prog->aux->max_rdwr_access;
+		}
 		return check_buffer_access(env, reg, regno, reg->off,
 					   access_size, zero_size_allowed,
-					   "rdwr",
-					   &env->prog->aux->max_rdwr_access);
+					   buf_info, max_access);
 	case PTR_TO_STACK:
 		return check_stack_range_initialized(
 				env,
@@ -4858,8 +4874,8 @@ static const struct bpf_reg_types mem_types = {
 		PTR_TO_MAP_KEY,
 		PTR_TO_MAP_VALUE,
 		PTR_TO_MEM,
-		PTR_TO_RDONLY_BUF,
-		PTR_TO_RDWR_BUF,
+		PTR_TO_BUF,
+		PTR_TO_BUF | MEM_RDONLY,
 	},
 };
 
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 4cb5ef8eddbc..ea61dfe19c86 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -929,7 +929,7 @@ static struct bpf_iter_reg bpf_sk_storage_map_reg_info = {
 		{ offsetof(struct bpf_iter__bpf_sk_storage_map, sk),
 		  PTR_TO_BTF_ID_OR_NULL },
 		{ offsetof(struct bpf_iter__bpf_sk_storage_map, value),
-		  PTR_TO_RDWR_BUF | PTR_MAYBE_NULL },
+		  PTR_TO_BUF | PTR_MAYBE_NULL },
 	},
 	.seq_info		= &iter_seq_info,
 };
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 5a8f3b52d08c..6351b6af7aca 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1575,7 +1575,7 @@ static struct bpf_iter_reg sock_map_iter_reg = {
 	.ctx_arg_info_size	= 2,
 	.ctx_arg_info		= {
 		{ offsetof(struct bpf_iter__sockmap, key),
-		  PTR_TO_RDONLY_BUF | PTR_MAYBE_NULL },
+		  PTR_TO_BUF | PTR_MAYBE_NULL | MEM_RDONLY },
 		{ offsetof(struct bpf_iter__sockmap, sk),
 		  PTR_TO_BTF_ID_OR_NULL },
 	},
-- 
2.36.0.464.gb9c8b46e94-goog

