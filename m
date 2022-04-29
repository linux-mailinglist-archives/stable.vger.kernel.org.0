Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B29513F51
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 02:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353468AbiD2ACn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 20:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353486AbiD2ACl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 20:02:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5241EB3DCF
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j11-20020a05690212cb00b006454988d225so5977203ybu.10
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1Pgc2AK0Uo5o+vR+WcEr5z9IlxvSgdU3PW14Zp+wI/I=;
        b=ZN/PLrg+8gYsLxR1qk/ufZVw4sdBPpMXyBHqUJSaCKHS0BDGOETh74COqFrsqG4Mgn
         aJYSSKRObLrRT26LfKs9lLoH5U3D3NTK/Y6zcBgs0W0ye5x5nIZyWmMB7ceXepJ3sMSq
         4ry6ism76sYxRH6r99wyFEBz5AnRe5d14LjlzqdNBiR+5jsKoR6GqgfN+mar8UiIMk6Y
         CLyq+ESYipDgMcd93l3axvMX0Beyeoy9FlCEGdmR/3dHZVH5gLga8eEM56YMn65CiVen
         ieszvZs6DlHAacZBFfleikMHgplR4x4zlsuooxpXTuEuRvEPlPUAbkwJpCtlHTgn/r49
         VmoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1Pgc2AK0Uo5o+vR+WcEr5z9IlxvSgdU3PW14Zp+wI/I=;
        b=yLfuA+hNF1eT+k4w+++/3WtZjYmiBnqOWGEfQBNwbE6efsoLybN2j5wFUbpJKn0DJy
         y5t2oXCWa5wtImVOV1hD47VbhZRXX53W1Yt2kUzCUdogdawK5kZnZC2zJGYLxwZyEDbw
         7Tnm8oHAFRg4mPphi2ayJtfUAbU//1693e7VMZijbUQNkouZj5k06pTl2IrxTo3B4OxO
         0OntvFAlBo7T8SPoLYRXbnOxoWHTxuQaB59rcBbLJNYBFjcm4hIo1/3PR820T0G/CXcX
         dcyz+bbwMmC0ekBSo2vva8E9SF9H64zjvmU32bzD73LskIyrAEQDhISyEI1ydExBKjvc
         OEhg==
X-Gm-Message-State: AOAM533mZJm/VKwqfU+QL0wT0/OOUQagb+mM+W2QFKU/XHEuL8T35gWV
        nyEk1q97PKn5OLhLGK14yLFWgGm0LbM=
X-Google-Smtp-Source: ABdhPJwUHyI+1fnFzVyZx+0wy8UarLimekrsrvmSxeibyiSLXHkeGJLx56L6O8VDA32aVvS/Fi7k7HOBmcE=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:25cd:1665:36bc:f38e])
 (user=haoluo job=sendgmr) by 2002:a5b:690:0:b0:645:d493:36c9 with SMTP id
 j16-20020a5b0690000000b00645d49336c9mr30544612ybq.641.1651190362563; Thu, 28
 Apr 2022 16:59:22 -0700 (PDT)
Date:   Thu, 28 Apr 2022 16:57:45 -0700
In-Reply-To: <20220428235751.103203-1-haoluo@google.com>
Message-Id: <20220428235751.103203-5-haoluo@google.com>
Mime-Version: 1.0
References: <20220428235751.103203-1-haoluo@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH stable linux-5.15.y 04/10] bpf: Replace PTR_TO_XXX_OR_NULL
 with PTR_TO_XXX | PTR_MAYBE_NULL
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

commit c25b2ae136039ffa820c26138ed4a5e5f3ab3841 upstream.

We have introduced a new type to make bpf_reg composable, by
allocating bits in the type to represent flags.

One of the flags is PTR_MAYBE_NULL which indicates a pointer
may be NULL. This patch switches the qualified reg_types to
use this flag. The reg_types changed in this patch include:

1. PTR_TO_MAP_VALUE_OR_NULL
2. PTR_TO_SOCKET_OR_NULL
3. PTR_TO_SOCK_COMMON_OR_NULL
4. PTR_TO_TCP_SOCK_OR_NULL
5. PTR_TO_BTF_ID_OR_NULL
6. PTR_TO_MEM_OR_NULL
7. PTR_TO_RDONLY_BUF_OR_NULL
8. PTR_TO_RDWR_BUF_OR_NULL

[haoluo: backport notes
 There was a reg_type_may_be_null() in adjust_ptr_min_max_vals() in
 5.15.x, but didn't exist in the upstream commit. This backport
 converted that reg_type_may_be_null() to type_may_be_null() as well.]

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/r/20211217003152.48334-5-haoluo@google.com
Cc: stable@vger.kernel.org # 5.15.x
---
 include/linux/bpf.h          |  18 +--
 include/linux/bpf_verifier.h |   4 +
 kernel/bpf/btf.c             |   7 +-
 kernel/bpf/map_iter.c        |   4 +-
 kernel/bpf/verifier.c        | 297 +++++++++++++++--------------------
 net/core/bpf_sk_storage.c    |   2 +-
 net/core/sock_map.c          |   2 +-
 7 files changed, 148 insertions(+), 186 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 31c79271735e..7249f5e2480e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -461,18 +461,15 @@ enum bpf_reg_type {
 	PTR_TO_CTX,		 /* reg points to bpf_context */
 	CONST_PTR_TO_MAP,	 /* reg points to struct bpf_map */
 	PTR_TO_MAP_VALUE,	 /* reg points to map element value */
-	PTR_TO_MAP_VALUE_OR_NULL,/* points to map elem value or NULL */
+	PTR_TO_MAP_KEY,		 /* reg points to a map element key */
 	PTR_TO_STACK,		 /* reg == frame_pointer + offset */
 	PTR_TO_PACKET_META,	 /* skb->data - meta_len */
 	PTR_TO_PACKET,		 /* reg points to skb->data */
 	PTR_TO_PACKET_END,	 /* skb->data + headlen */
 	PTR_TO_FLOW_KEYS,	 /* reg points to bpf_flow_keys */
 	PTR_TO_SOCKET,		 /* reg points to struct bpf_sock */
-	PTR_TO_SOCKET_OR_NULL,	 /* reg points to struct bpf_sock or NULL */
 	PTR_TO_SOCK_COMMON,	 /* reg points to sock_common */
-	PTR_TO_SOCK_COMMON_OR_NULL, /* reg points to sock_common or NULL */
 	PTR_TO_TCP_SOCK,	 /* reg points to struct tcp_sock */
-	PTR_TO_TCP_SOCK_OR_NULL, /* reg points to struct tcp_sock or NULL */
 	PTR_TO_TP_BUFFER,	 /* reg points to a writable raw tp's buffer */
 	PTR_TO_XDP_SOCK,	 /* reg points to struct xdp_sock */
 	/* PTR_TO_BTF_ID points to a kernel struct that does not need
@@ -490,18 +487,21 @@ enum bpf_reg_type {
 	 * been checked for null. Used primarily to inform the verifier
 	 * an explicit null check is required for this struct.
 	 */
-	PTR_TO_BTF_ID_OR_NULL,
 	PTR_TO_MEM,		 /* reg points to valid memory region */
-	PTR_TO_MEM_OR_NULL,	 /* reg points to valid memory region or NULL */
 	PTR_TO_RDONLY_BUF,	 /* reg points to a readonly buffer */
-	PTR_TO_RDONLY_BUF_OR_NULL, /* reg points to a readonly buffer or NULL */
 	PTR_TO_RDWR_BUF,	 /* reg points to a read/write buffer */
-	PTR_TO_RDWR_BUF_OR_NULL, /* reg points to a read/write buffer or NULL */
 	PTR_TO_PERCPU_BTF_ID,	 /* reg points to a percpu kernel variable */
 	PTR_TO_FUNC,		 /* reg points to a bpf program function */
-	PTR_TO_MAP_KEY,		 /* reg points to a map element key */
 	__BPF_REG_TYPE_MAX,
 
+	/* Extended reg_types. */
+	PTR_TO_MAP_VALUE_OR_NULL	= PTR_MAYBE_NULL | PTR_TO_MAP_VALUE,
+	PTR_TO_SOCKET_OR_NULL		= PTR_MAYBE_NULL | PTR_TO_SOCKET,
+	PTR_TO_SOCK_COMMON_OR_NULL	= PTR_MAYBE_NULL | PTR_TO_SOCK_COMMON,
+	PTR_TO_TCP_SOCK_OR_NULL		= PTR_MAYBE_NULL | PTR_TO_TCP_SOCK,
+	PTR_TO_BTF_ID_OR_NULL		= PTR_MAYBE_NULL | PTR_TO_BTF_ID,
+	PTR_TO_MEM_OR_NULL		= PTR_MAYBE_NULL | PTR_TO_MEM,
+
 	/* This must be the last entry. Its purpose is to ensure the enum is
 	 * wide enough to hold the higher bits reserved for bpf_type_flag.
 	 */
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 2e612f3fd385..bb1cc3fbc4ba 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -18,6 +18,8 @@
  * that converting umax_value to int cannot overflow.
  */
 #define BPF_MAX_VAR_SIZ	(1 << 29)
+/* size of type_str_buf in bpf_verifier. */
+#define TYPE_STR_BUF_LEN 64
 
 /* Liveness marks, used for registers and spilled-regs (in stack slots).
  * Read marks propagate upwards until they find a write mark; they record that
@@ -474,6 +476,8 @@ struct bpf_verifier_env {
 	/* longest register parentage chain walked for liveness marking */
 	u32 longest_mark_read_walk;
 	bpfptr_t fd_array;
+	/* buffer used in reg_type_str() to generate reg_type string */
+	char type_str_buf[TYPE_STR_BUF_LEN];
 };
 
 __printf(2, 0) void bpf_verifier_vlog(struct bpf_verifier_log *log,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 09406b0e215e..1872b3e05d6c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4800,10 +4800,13 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	/* check for PTR_TO_RDONLY_BUF_OR_NULL or PTR_TO_RDWR_BUF_OR_NULL */
 	for (i = 0; i < prog->aux->ctx_arg_info_size; i++) {
 		const struct bpf_ctx_arg_aux *ctx_arg_info = &prog->aux->ctx_arg_info[i];
+		u32 type, flag;
 
+		type = base_type(ctx_arg_info->reg_type);
+		flag = type_flag(ctx_arg_info->reg_type);
 		if (ctx_arg_info->offset == off &&
-		    (ctx_arg_info->reg_type == PTR_TO_RDONLY_BUF_OR_NULL ||
-		     ctx_arg_info->reg_type == PTR_TO_RDWR_BUF_OR_NULL)) {
+		    (type == PTR_TO_RDWR_BUF || type == PTR_TO_RDONLY_BUF) &&
+		    (flag & PTR_MAYBE_NULL)) {
 			info->reg_type = ctx_arg_info->reg_type;
 			return true;
 		}
diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
index 6a9542af4212..631f0e44b7a9 100644
--- a/kernel/bpf/map_iter.c
+++ b/kernel/bpf/map_iter.c
@@ -174,9 +174,9 @@ static const struct bpf_iter_reg bpf_map_elem_reg_info = {
 	.ctx_arg_info_size	= 2,
 	.ctx_arg_info		= {
 		{ offsetof(struct bpf_iter__bpf_map_elem, key),
-		  PTR_TO_RDONLY_BUF_OR_NULL },
+		  PTR_TO_RDONLY_BUF | PTR_MAYBE_NULL },
 		{ offsetof(struct bpf_iter__bpf_map_elem, value),
-		  PTR_TO_RDWR_BUF_OR_NULL },
+		  PTR_TO_RDWR_BUF | PTR_MAYBE_NULL },
 	},
 };
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 647a7c4b8da9..24e9955a93e5 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -445,18 +445,6 @@ static bool reg_type_not_null(enum bpf_reg_type type)
 		type == PTR_TO_SOCK_COMMON;
 }
 
-static bool reg_type_may_be_null(enum bpf_reg_type type)
-{
-	return type == PTR_TO_MAP_VALUE_OR_NULL ||
-	       type == PTR_TO_SOCKET_OR_NULL ||
-	       type == PTR_TO_SOCK_COMMON_OR_NULL ||
-	       type == PTR_TO_TCP_SOCK_OR_NULL ||
-	       type == PTR_TO_BTF_ID_OR_NULL ||
-	       type == PTR_TO_MEM_OR_NULL ||
-	       type == PTR_TO_RDONLY_BUF_OR_NULL ||
-	       type == PTR_TO_RDWR_BUF_OR_NULL;
-}
-
 static bool reg_may_point_to_spin_lock(const struct bpf_reg_state *reg)
 {
 	return reg->type == PTR_TO_MAP_VALUE &&
@@ -465,12 +453,9 @@ static bool reg_may_point_to_spin_lock(const struct bpf_reg_state *reg)
 
 static bool reg_type_may_be_refcounted_or_null(enum bpf_reg_type type)
 {
-	return type == PTR_TO_SOCKET ||
-		type == PTR_TO_SOCKET_OR_NULL ||
-		type == PTR_TO_TCP_SOCK ||
-		type == PTR_TO_TCP_SOCK_OR_NULL ||
-		type == PTR_TO_MEM ||
-		type == PTR_TO_MEM_OR_NULL;
+	return base_type(type) == PTR_TO_SOCKET ||
+		base_type(type) == PTR_TO_TCP_SOCK ||
+		base_type(type) == PTR_TO_MEM;
 }
 
 static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
@@ -540,39 +525,52 @@ static bool is_cmpxchg_insn(const struct bpf_insn *insn)
 	       insn->imm == BPF_CMPXCHG;
 }
 
-/* string representation of 'enum bpf_reg_type' */
-static const char * const reg_type_str[] = {
-	[NOT_INIT]		= "?",
-	[SCALAR_VALUE]		= "inv",
-	[PTR_TO_CTX]		= "ctx",
-	[CONST_PTR_TO_MAP]	= "map_ptr",
-	[PTR_TO_MAP_VALUE]	= "map_value",
-	[PTR_TO_MAP_VALUE_OR_NULL] = "map_value_or_null",
-	[PTR_TO_STACK]		= "fp",
-	[PTR_TO_PACKET]		= "pkt",
-	[PTR_TO_PACKET_META]	= "pkt_meta",
-	[PTR_TO_PACKET_END]	= "pkt_end",
-	[PTR_TO_FLOW_KEYS]	= "flow_keys",
-	[PTR_TO_SOCKET]		= "sock",
-	[PTR_TO_SOCKET_OR_NULL] = "sock_or_null",
-	[PTR_TO_SOCK_COMMON]	= "sock_common",
-	[PTR_TO_SOCK_COMMON_OR_NULL] = "sock_common_or_null",
-	[PTR_TO_TCP_SOCK]	= "tcp_sock",
-	[PTR_TO_TCP_SOCK_OR_NULL] = "tcp_sock_or_null",
-	[PTR_TO_TP_BUFFER]	= "tp_buffer",
-	[PTR_TO_XDP_SOCK]	= "xdp_sock",
-	[PTR_TO_BTF_ID]		= "ptr_",
-	[PTR_TO_BTF_ID_OR_NULL]	= "ptr_or_null_",
-	[PTR_TO_PERCPU_BTF_ID]	= "percpu_ptr_",
-	[PTR_TO_MEM]		= "mem",
-	[PTR_TO_MEM_OR_NULL]	= "mem_or_null",
-	[PTR_TO_RDONLY_BUF]	= "rdonly_buf",
-	[PTR_TO_RDONLY_BUF_OR_NULL] = "rdonly_buf_or_null",
-	[PTR_TO_RDWR_BUF]	= "rdwr_buf",
-	[PTR_TO_RDWR_BUF_OR_NULL] = "rdwr_buf_or_null",
-	[PTR_TO_FUNC]		= "func",
-	[PTR_TO_MAP_KEY]	= "map_key",
-};
+/* string representation of 'enum bpf_reg_type'
+ *
+ * Note that reg_type_str() can not appear more than once in a single verbose()
+ * statement.
+ */
+static const char *reg_type_str(struct bpf_verifier_env *env,
+				enum bpf_reg_type type)
+{
+	char postfix[16] = {0};
+	static const char * const str[] = {
+		[NOT_INIT]		= "?",
+		[SCALAR_VALUE]		= "inv",
+		[PTR_TO_CTX]		= "ctx",
+		[CONST_PTR_TO_MAP]	= "map_ptr",
+		[PTR_TO_MAP_VALUE]	= "map_value",
+		[PTR_TO_STACK]		= "fp",
+		[PTR_TO_PACKET]		= "pkt",
+		[PTR_TO_PACKET_META]	= "pkt_meta",
+		[PTR_TO_PACKET_END]	= "pkt_end",
+		[PTR_TO_FLOW_KEYS]	= "flow_keys",
+		[PTR_TO_SOCKET]		= "sock",
+		[PTR_TO_SOCK_COMMON]	= "sock_common",
+		[PTR_TO_TCP_SOCK]	= "tcp_sock",
+		[PTR_TO_TP_BUFFER]	= "tp_buffer",
+		[PTR_TO_XDP_SOCK]	= "xdp_sock",
+		[PTR_TO_BTF_ID]		= "ptr_",
+		[PTR_TO_PERCPU_BTF_ID]	= "percpu_ptr_",
+		[PTR_TO_MEM]		= "mem",
+		[PTR_TO_RDONLY_BUF]	= "rdonly_buf",
+		[PTR_TO_RDWR_BUF]	= "rdwr_buf",
+		[PTR_TO_FUNC]		= "func",
+		[PTR_TO_MAP_KEY]	= "map_key",
+	};
+
+	if (type & PTR_MAYBE_NULL) {
+		if (base_type(type) == PTR_TO_BTF_ID ||
+		    base_type(type) == PTR_TO_PERCPU_BTF_ID)
+			strncpy(postfix, "or_null_", 16);
+		else
+			strncpy(postfix, "_or_null", 16);
+	}
+
+	snprintf(env->type_str_buf, TYPE_STR_BUF_LEN, "%s%s",
+		 str[base_type(type)], postfix);
+	return env->type_str_buf;
+}
 
 static char slot_type_char[] = {
 	[STACK_INVALID]	= '?',
@@ -623,7 +621,7 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 			continue;
 		verbose(env, " R%d", i);
 		print_liveness(env, reg->live);
-		verbose(env, "=%s", reg_type_str[t]);
+		verbose(env, "=%s", reg_type_str(env, t));
 		if (t == SCALAR_VALUE && reg->precise)
 			verbose(env, "P");
 		if ((t == SCALAR_VALUE || t == PTR_TO_STACK) &&
@@ -631,9 +629,8 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 			/* reg->off should be 0 for SCALAR_VALUE */
 			verbose(env, "%lld", reg->var_off.value + reg->off);
 		} else {
-			if (t == PTR_TO_BTF_ID ||
-			    t == PTR_TO_BTF_ID_OR_NULL ||
-			    t == PTR_TO_PERCPU_BTF_ID)
+			if (base_type(t) == PTR_TO_BTF_ID ||
+			    base_type(t) == PTR_TO_PERCPU_BTF_ID)
 				verbose(env, "%s", kernel_type_name(reg->btf, reg->btf_id));
 			verbose(env, "(id=%d", reg->id);
 			if (reg_type_may_be_refcounted_or_null(t))
@@ -642,10 +639,9 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 				verbose(env, ",off=%d", reg->off);
 			if (type_is_pkt_pointer(t))
 				verbose(env, ",r=%d", reg->range);
-			else if (t == CONST_PTR_TO_MAP ||
-				 t == PTR_TO_MAP_KEY ||
-				 t == PTR_TO_MAP_VALUE ||
-				 t == PTR_TO_MAP_VALUE_OR_NULL)
+			else if (base_type(t) == CONST_PTR_TO_MAP ||
+				 base_type(t) == PTR_TO_MAP_KEY ||
+				 base_type(t) == PTR_TO_MAP_VALUE)
 				verbose(env, ",ks=%d,vs=%d",
 					reg->map_ptr->key_size,
 					reg->map_ptr->value_size);
@@ -715,7 +711,7 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 		if (state->stack[i].slot_type[0] == STACK_SPILL) {
 			reg = &state->stack[i].spilled_ptr;
 			t = reg->type;
-			verbose(env, "=%s", reg_type_str[t]);
+			verbose(env, "=%s", reg_type_str(env, t));
 			if (t == SCALAR_VALUE && reg->precise)
 				verbose(env, "P");
 			if (t == SCALAR_VALUE && tnum_is_const(reg->var_off))
@@ -1128,8 +1124,7 @@ static void mark_reg_known_zero(struct bpf_verifier_env *env,
 
 static void mark_ptr_not_null_reg(struct bpf_reg_state *reg)
 {
-	switch (reg->type) {
-	case PTR_TO_MAP_VALUE_OR_NULL: {
+	if (base_type(reg->type) == PTR_TO_MAP_VALUE) {
 		const struct bpf_map *map = reg->map_ptr;
 
 		if (map->inner_map_meta) {
@@ -1148,32 +1143,10 @@ static void mark_ptr_not_null_reg(struct bpf_reg_state *reg)
 		} else {
 			reg->type = PTR_TO_MAP_VALUE;
 		}
-		break;
-	}
-	case PTR_TO_SOCKET_OR_NULL:
-		reg->type = PTR_TO_SOCKET;
-		break;
-	case PTR_TO_SOCK_COMMON_OR_NULL:
-		reg->type = PTR_TO_SOCK_COMMON;
-		break;
-	case PTR_TO_TCP_SOCK_OR_NULL:
-		reg->type = PTR_TO_TCP_SOCK;
-		break;
-	case PTR_TO_BTF_ID_OR_NULL:
-		reg->type = PTR_TO_BTF_ID;
-		break;
-	case PTR_TO_MEM_OR_NULL:
-		reg->type = PTR_TO_MEM;
-		break;
-	case PTR_TO_RDONLY_BUF_OR_NULL:
-		reg->type = PTR_TO_RDONLY_BUF;
-		break;
-	case PTR_TO_RDWR_BUF_OR_NULL:
-		reg->type = PTR_TO_RDWR_BUF;
-		break;
-	default:
-		WARN_ONCE(1, "unknown nullable register type");
+		return;
 	}
+
+	reg->type &= ~PTR_MAYBE_NULL;
 }
 
 static bool reg_is_pkt_pointer(const struct bpf_reg_state *reg)
@@ -1901,7 +1874,7 @@ static int mark_reg_read(struct bpf_verifier_env *env,
 			break;
 		if (parent->live & REG_LIVE_DONE) {
 			verbose(env, "verifier BUG type %s var_off %lld off %d\n",
-				reg_type_str[parent->type],
+				reg_type_str(env, parent->type),
 				parent->var_off.value, parent->off);
 			return -EFAULT;
 		}
@@ -2559,9 +2532,8 @@ static int mark_chain_precision_stack(struct bpf_verifier_env *env, int spi)
 
 static bool is_spillable_regtype(enum bpf_reg_type type)
 {
-	switch (type) {
+	switch (base_type(type)) {
 	case PTR_TO_MAP_VALUE:
-	case PTR_TO_MAP_VALUE_OR_NULL:
 	case PTR_TO_STACK:
 	case PTR_TO_CTX:
 	case PTR_TO_PACKET:
@@ -2570,21 +2542,14 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_FLOW_KEYS:
 	case CONST_PTR_TO_MAP:
 	case PTR_TO_SOCKET:
-	case PTR_TO_SOCKET_OR_NULL:
 	case PTR_TO_SOCK_COMMON:
-	case PTR_TO_SOCK_COMMON_OR_NULL:
 	case PTR_TO_TCP_SOCK:
-	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
 	case PTR_TO_BTF_ID:
-	case PTR_TO_BTF_ID_OR_NULL:
 	case PTR_TO_RDONLY_BUF:
-	case PTR_TO_RDONLY_BUF_OR_NULL:
 	case PTR_TO_RDWR_BUF:
-	case PTR_TO_RDWR_BUF_OR_NULL:
 	case PTR_TO_PERCPU_BTF_ID:
 	case PTR_TO_MEM:
-	case PTR_TO_MEM_OR_NULL:
 	case PTR_TO_FUNC:
 	case PTR_TO_MAP_KEY:
 		return true;
@@ -3400,7 +3365,7 @@ static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off,
 		 */
 		*reg_type = info.reg_type;
 
-		if (*reg_type == PTR_TO_BTF_ID || *reg_type == PTR_TO_BTF_ID_OR_NULL) {
+		if (base_type(*reg_type) == PTR_TO_BTF_ID) {
 			*btf = info.btf;
 			*btf_id = info.btf_id;
 		} else {
@@ -3468,7 +3433,7 @@ static int check_sock_access(struct bpf_verifier_env *env, int insn_idx,
 	}
 
 	verbose(env, "R%d invalid %s access off=%d size=%d\n",
-		regno, reg_type_str[reg->type], off, size);
+		regno, reg_type_str(env, reg->type), off, size);
 
 	return -EACCES;
 }
@@ -4233,7 +4198,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 			} else {
 				mark_reg_known_zero(env, regs,
 						    value_regno);
-				if (reg_type_may_be_null(reg_type))
+				if (type_may_be_null(reg_type))
 					regs[value_regno].id = ++env->id_gen;
 				/* A load of ctx field could have different
 				 * actual load size with the one encoded in the
@@ -4241,8 +4206,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 				 * a sub-register.
 				 */
 				regs[value_regno].subreg_def = DEF_NOT_SUBREG;
-				if (reg_type == PTR_TO_BTF_ID ||
-				    reg_type == PTR_TO_BTF_ID_OR_NULL) {
+				if (base_type(reg_type) == PTR_TO_BTF_ID) {
 					regs[value_regno].btf = btf;
 					regs[value_regno].btf_id = btf_id;
 				}
@@ -4295,7 +4259,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 	} else if (type_is_sk_pointer(reg->type)) {
 		if (t == BPF_WRITE) {
 			verbose(env, "R%d cannot write into %s\n",
-				regno, reg_type_str[reg->type]);
+				regno, reg_type_str(env, reg->type));
 			return -EACCES;
 		}
 		err = check_sock_access(env, insn_idx, regno, off, size, t);
@@ -4314,7 +4278,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 	} else if (reg->type == PTR_TO_RDONLY_BUF) {
 		if (t == BPF_WRITE) {
 			verbose(env, "R%d cannot write into %s\n",
-				regno, reg_type_str[reg->type]);
+				regno, reg_type_str(env, reg->type));
 			return -EACCES;
 		}
 		err = check_buffer_access(env, reg, regno, off, size, false,
@@ -4330,7 +4294,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 			mark_reg_unknown(env, regs, value_regno);
 	} else {
 		verbose(env, "R%d invalid mem access '%s'\n", regno,
-			reg_type_str[reg->type]);
+			reg_type_str(env, reg->type));
 		return -EACCES;
 	}
 
@@ -4404,7 +4368,7 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
 	    is_sk_reg(env, insn->dst_reg)) {
 		verbose(env, "BPF_ATOMIC stores into R%d %s is not allowed\n",
 			insn->dst_reg,
-			reg_type_str[reg_state(env, insn->dst_reg)->type]);
+			reg_type_str(env, reg_state(env, insn->dst_reg)->type));
 		return -EACCES;
 	}
 
@@ -4630,9 +4594,9 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
 		    register_is_null(reg))
 			return 0;
 
-		verbose(env, "R%d type=%s expected=%s\n", regno,
-			reg_type_str[reg->type],
-			reg_type_str[PTR_TO_STACK]);
+		verbose(env, "R%d type=%s ", regno,
+			reg_type_str(env, reg->type));
+		verbose(env, "expected=%s\n", reg_type_str(env, PTR_TO_STACK));
 		return -EACCES;
 	}
 }
@@ -4643,7 +4607,7 @@ int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
 	if (register_is_null(reg))
 		return 0;
 
-	if (reg_type_may_be_null(reg->type)) {
+	if (type_may_be_null(reg->type)) {
 		/* Assuming that the register contains a value check if the memory
 		 * access is safe. Temporarily save and restore the register's state as
 		 * the conversion shouldn't be visible to a caller.
@@ -4974,10 +4938,10 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
 			goto found;
 	}
 
-	verbose(env, "R%d type=%s expected=", regno, reg_type_str[type]);
+	verbose(env, "R%d type=%s expected=", regno, reg_type_str(env, type));
 	for (j = 0; j + 1 < i; j++)
-		verbose(env, "%s, ", reg_type_str[compatible->types[j]]);
-	verbose(env, "%s\n", reg_type_str[compatible->types[j]]);
+		verbose(env, "%s, ", reg_type_str(env, compatible->types[j]));
+	verbose(env, "%s\n", reg_type_str(env, compatible->types[j]));
 	return -EACCES;
 
 found:
@@ -6196,6 +6160,7 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 {
 	const struct bpf_func_proto *fn = NULL;
 	enum bpf_return_type ret_type;
+	enum bpf_type_flag ret_flag;
 	struct bpf_reg_state *regs;
 	struct bpf_call_arg_meta meta;
 	int insn_idx = *insn_idx_p;
@@ -6330,6 +6295,7 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 
 	/* update return register (already marked as written above) */
 	ret_type = fn->ret_type;
+	ret_flag = type_flag(fn->ret_type);
 	if (ret_type == RET_INTEGER) {
 		/* sets type to SCALAR_VALUE */
 		mark_reg_unknown(env, regs, BPF_REG_0);
@@ -6349,25 +6315,23 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		}
 		regs[BPF_REG_0].map_ptr = meta.map_ptr;
 		regs[BPF_REG_0].map_uid = meta.map_uid;
-		if (type_may_be_null(ret_type)) {
-			regs[BPF_REG_0].type = PTR_TO_MAP_VALUE_OR_NULL;
-		} else {
-			regs[BPF_REG_0].type = PTR_TO_MAP_VALUE;
-			if (map_value_has_spin_lock(meta.map_ptr))
-				regs[BPF_REG_0].id = ++env->id_gen;
+		regs[BPF_REG_0].type = PTR_TO_MAP_VALUE | ret_flag;
+		if (!type_may_be_null(ret_type) &&
+		    map_value_has_spin_lock(meta.map_ptr)) {
+			regs[BPF_REG_0].id = ++env->id_gen;
 		}
 	} else if (base_type(ret_type) == RET_PTR_TO_SOCKET) {
 		mark_reg_known_zero(env, regs, BPF_REG_0);
-		regs[BPF_REG_0].type = PTR_TO_SOCKET_OR_NULL;
+		regs[BPF_REG_0].type = PTR_TO_SOCKET | ret_flag;
 	} else if (base_type(ret_type) == RET_PTR_TO_SOCK_COMMON) {
 		mark_reg_known_zero(env, regs, BPF_REG_0);
-		regs[BPF_REG_0].type = PTR_TO_SOCK_COMMON_OR_NULL;
+		regs[BPF_REG_0].type = PTR_TO_SOCK_COMMON | ret_flag;
 	} else if (base_type(ret_type) == RET_PTR_TO_TCP_SOCK) {
 		mark_reg_known_zero(env, regs, BPF_REG_0);
-		regs[BPF_REG_0].type = PTR_TO_TCP_SOCK_OR_NULL;
+		regs[BPF_REG_0].type = PTR_TO_TCP_SOCK | ret_flag;
 	} else if (base_type(ret_type) == RET_PTR_TO_ALLOC_MEM) {
 		mark_reg_known_zero(env, regs, BPF_REG_0);
-		regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
+		regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
 		regs[BPF_REG_0].mem_size = meta.mem_size;
 	} else if (base_type(ret_type) == RET_PTR_TO_MEM_OR_BTF_ID) {
 		const struct btf_type *t;
@@ -6387,14 +6351,10 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 					tname, PTR_ERR(ret));
 				return -EINVAL;
 			}
-			regs[BPF_REG_0].type =
-				(ret_type & PTR_MAYBE_NULL) ?
-				PTR_TO_MEM_OR_NULL : PTR_TO_MEM;
+			regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
 			regs[BPF_REG_0].mem_size = tsize;
 		} else {
-			regs[BPF_REG_0].type =
-				(ret_type & PTR_MAYBE_NULL) ?
-				PTR_TO_BTF_ID_OR_NULL : PTR_TO_BTF_ID;
+			regs[BPF_REG_0].type = PTR_TO_BTF_ID | ret_flag;
 			regs[BPF_REG_0].btf = meta.ret_btf;
 			regs[BPF_REG_0].btf_id = meta.ret_btf_id;
 		}
@@ -6402,9 +6362,7 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		int ret_btf_id;
 
 		mark_reg_known_zero(env, regs, BPF_REG_0);
-		regs[BPF_REG_0].type = (ret_type & PTR_MAYBE_NULL) ?
-						     PTR_TO_BTF_ID_OR_NULL :
-						     PTR_TO_BTF_ID;
+		regs[BPF_REG_0].type = PTR_TO_BTF_ID | ret_flag;
 		ret_btf_id = *fn->ret_btf_id;
 		if (ret_btf_id == 0) {
 			verbose(env, "invalid return type %u of func %s#%d\n",
@@ -6423,7 +6381,7 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		return -EINVAL;
 	}
 
-	if (reg_type_may_be_null(regs[BPF_REG_0].type))
+	if (type_may_be_null(regs[BPF_REG_0].type))
 		regs[BPF_REG_0].id = ++env->id_gen;
 
 	if (is_ptr_cast_function(func_id)) {
@@ -6622,25 +6580,25 @@ static bool check_reg_sane_offset(struct bpf_verifier_env *env,
 
 	if (known && (val >= BPF_MAX_VAR_OFF || val <= -BPF_MAX_VAR_OFF)) {
 		verbose(env, "math between %s pointer and %lld is not allowed\n",
-			reg_type_str[type], val);
+			reg_type_str(env, type), val);
 		return false;
 	}
 
 	if (reg->off >= BPF_MAX_VAR_OFF || reg->off <= -BPF_MAX_VAR_OFF) {
 		verbose(env, "%s pointer offset %d is not allowed\n",
-			reg_type_str[type], reg->off);
+			reg_type_str(env, type), reg->off);
 		return false;
 	}
 
 	if (smin == S64_MIN) {
 		verbose(env, "math between %s pointer and register with unbounded min value is not allowed\n",
-			reg_type_str[type]);
+			reg_type_str(env, type));
 		return false;
 	}
 
 	if (smin >= BPF_MAX_VAR_OFF || smin <= -BPF_MAX_VAR_OFF) {
 		verbose(env, "value %lld makes %s pointer be out of bounds\n",
-			smin, reg_type_str[type]);
+			smin, reg_type_str(env, type));
 		return false;
 	}
 
@@ -7017,11 +6975,13 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		return -EACCES;
 	}
 
-	switch (ptr_reg->type) {
-	case PTR_TO_MAP_VALUE_OR_NULL:
+	if (ptr_reg->type & PTR_MAYBE_NULL) {
 		verbose(env, "R%d pointer arithmetic on %s prohibited, null-check it first\n",
-			dst, reg_type_str[ptr_reg->type]);
+			dst, reg_type_str(env, ptr_reg->type));
 		return -EACCES;
+	}
+
+	switch (base_type(ptr_reg->type)) {
 	case CONST_PTR_TO_MAP:
 		/* smin_val represents the known value */
 		if (known && smin_val == 0 && opcode == BPF_ADD)
@@ -7034,10 +6994,10 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	case PTR_TO_XDP_SOCK:
 reject:
 		verbose(env, "R%d pointer arithmetic on %s prohibited\n",
-			dst, reg_type_str[ptr_reg->type]);
+			dst, reg_type_str(env, ptr_reg->type));
 		return -EACCES;
 	default:
-		if (reg_type_may_be_null(ptr_reg->type))
+		if (type_may_be_null(ptr_reg->type))
 			goto reject;
 		break;
 	}
@@ -8759,7 +8719,7 @@ static void mark_ptr_or_null_reg(struct bpf_func_state *state,
 				 struct bpf_reg_state *reg, u32 id,
 				 bool is_null)
 {
-	if (reg_type_may_be_null(reg->type) && reg->id == id &&
+	if (type_may_be_null(reg->type) && reg->id == id &&
 	    !WARN_ON_ONCE(!reg->id)) {
 		if (WARN_ON_ONCE(reg->smin_value || reg->smax_value ||
 				 !tnum_equals_const(reg->var_off, 0) ||
@@ -9137,7 +9097,7 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 	 */
 	if (!is_jmp32 && BPF_SRC(insn->code) == BPF_K &&
 	    insn->imm == 0 && (opcode == BPF_JEQ || opcode == BPF_JNE) &&
-	    reg_type_may_be_null(dst_reg->type)) {
+	    type_may_be_null(dst_reg->type)) {
 		/* Mark all identical registers in each branch as either
 		 * safe or unknown depending R == 0 or R != 0 conditional.
 		 */
@@ -9393,7 +9353,7 @@ static int check_return_code(struct bpf_verifier_env *env)
 		/* enforce return zero from async callbacks like timer */
 		if (reg->type != SCALAR_VALUE) {
 			verbose(env, "In async callback the register R0 is not a known value (%s)\n",
-				reg_type_str[reg->type]);
+				reg_type_str(env, reg->type));
 			return -EINVAL;
 		}
 
@@ -9407,7 +9367,7 @@ static int check_return_code(struct bpf_verifier_env *env)
 	if (is_subprog) {
 		if (reg->type != SCALAR_VALUE) {
 			verbose(env, "At subprogram exit the register R0 is not a scalar value (%s)\n",
-				reg_type_str[reg->type]);
+				reg_type_str(env, reg->type));
 			return -EINVAL;
 		}
 		return 0;
@@ -9471,7 +9431,7 @@ static int check_return_code(struct bpf_verifier_env *env)
 
 	if (reg->type != SCALAR_VALUE) {
 		verbose(env, "At program exit the register R0 is not a known value (%s)\n",
-			reg_type_str[reg->type]);
+			reg_type_str(env, reg->type));
 		return -EINVAL;
 	}
 
@@ -10252,7 +10212,7 @@ static bool regsafe(struct bpf_verifier_env *env, struct bpf_reg_state *rold,
 		return true;
 	if (rcur->type == NOT_INIT)
 		return false;
-	switch (rold->type) {
+	switch (base_type(rold->type)) {
 	case SCALAR_VALUE:
 		if (env->explore_alu_limits)
 			return false;
@@ -10274,6 +10234,22 @@ static bool regsafe(struct bpf_verifier_env *env, struct bpf_reg_state *rold,
 		}
 	case PTR_TO_MAP_KEY:
 	case PTR_TO_MAP_VALUE:
+		/* a PTR_TO_MAP_VALUE could be safe to use as a
+		 * PTR_TO_MAP_VALUE_OR_NULL into the same map.
+		 * However, if the old PTR_TO_MAP_VALUE_OR_NULL then got NULL-
+		 * checked, doing so could have affected others with the same
+		 * id, and we can't check for that because we lost the id when
+		 * we converted to a PTR_TO_MAP_VALUE.
+		 */
+		if (type_may_be_null(rold->type)) {
+			if (!type_may_be_null(rcur->type))
+				return false;
+			if (memcmp(rold, rcur, offsetof(struct bpf_reg_state, id)))
+				return false;
+			/* Check our ids match any regs they're supposed to */
+			return check_ids(rold->id, rcur->id, idmap);
+		}
+
 		/* If the new min/max/var_off satisfy the old ones and
 		 * everything else matches, we are OK.
 		 * 'id' is not compared, since it's only used for maps with
@@ -10285,20 +10261,6 @@ static bool regsafe(struct bpf_verifier_env *env, struct bpf_reg_state *rold,
 		return memcmp(rold, rcur, offsetof(struct bpf_reg_state, id)) == 0 &&
 		       range_within(rold, rcur) &&
 		       tnum_in(rold->var_off, rcur->var_off);
-	case PTR_TO_MAP_VALUE_OR_NULL:
-		/* a PTR_TO_MAP_VALUE could be safe to use as a
-		 * PTR_TO_MAP_VALUE_OR_NULL into the same map.
-		 * However, if the old PTR_TO_MAP_VALUE_OR_NULL then got NULL-
-		 * checked, doing so could have affected others with the same
-		 * id, and we can't check for that because we lost the id when
-		 * we converted to a PTR_TO_MAP_VALUE.
-		 */
-		if (rcur->type != PTR_TO_MAP_VALUE_OR_NULL)
-			return false;
-		if (memcmp(rold, rcur, offsetof(struct bpf_reg_state, id)))
-			return false;
-		/* Check our ids match any regs they're supposed to */
-		return check_ids(rold->id, rcur->id, idmap);
 	case PTR_TO_PACKET_META:
 	case PTR_TO_PACKET:
 		if (rcur->type != rold->type)
@@ -10327,11 +10289,8 @@ static bool regsafe(struct bpf_verifier_env *env, struct bpf_reg_state *rold,
 	case PTR_TO_PACKET_END:
 	case PTR_TO_FLOW_KEYS:
 	case PTR_TO_SOCKET:
-	case PTR_TO_SOCKET_OR_NULL:
 	case PTR_TO_SOCK_COMMON:
-	case PTR_TO_SOCK_COMMON_OR_NULL:
 	case PTR_TO_TCP_SOCK:
-	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
 		/* Only valid matches are exact, which memcmp() above
 		 * would have accepted
@@ -10857,17 +10816,13 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 /* Return true if it's OK to have the same insn return a different type. */
 static bool reg_type_mismatch_ok(enum bpf_reg_type type)
 {
-	switch (type) {
+	switch (base_type(type)) {
 	case PTR_TO_CTX:
 	case PTR_TO_SOCKET:
-	case PTR_TO_SOCKET_OR_NULL:
 	case PTR_TO_SOCK_COMMON:
-	case PTR_TO_SOCK_COMMON_OR_NULL:
 	case PTR_TO_TCP_SOCK:
-	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
 	case PTR_TO_BTF_ID:
-	case PTR_TO_BTF_ID_OR_NULL:
 		return false;
 	default:
 		return true;
@@ -11091,7 +11046,7 @@ static int do_check(struct bpf_verifier_env *env)
 			if (is_ctx_reg(env, insn->dst_reg)) {
 				verbose(env, "BPF_ST stores into R%d %s is not allowed\n",
 					insn->dst_reg,
-					reg_type_str[reg_state(env, insn->dst_reg)->type]);
+					reg_type_str(env, reg_state(env, insn->dst_reg)->type));
 				return -EACCES;
 			}
 
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 68d2cbf8331a..4cb5ef8eddbc 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -929,7 +929,7 @@ static struct bpf_iter_reg bpf_sk_storage_map_reg_info = {
 		{ offsetof(struct bpf_iter__bpf_sk_storage_map, sk),
 		  PTR_TO_BTF_ID_OR_NULL },
 		{ offsetof(struct bpf_iter__bpf_sk_storage_map, value),
-		  PTR_TO_RDWR_BUF_OR_NULL },
+		  PTR_TO_RDWR_BUF | PTR_MAYBE_NULL },
 	},
 	.seq_info		= &iter_seq_info,
 };
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 8288b5382f08..5a8f3b52d08c 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1575,7 +1575,7 @@ static struct bpf_iter_reg sock_map_iter_reg = {
 	.ctx_arg_info_size	= 2,
 	.ctx_arg_info		= {
 		{ offsetof(struct bpf_iter__sockmap, key),
-		  PTR_TO_RDONLY_BUF_OR_NULL },
+		  PTR_TO_RDONLY_BUF | PTR_MAYBE_NULL },
 		{ offsetof(struct bpf_iter__sockmap, sk),
 		  PTR_TO_BTF_ID_OR_NULL },
 	},
-- 
2.36.0.464.gb9c8b46e94-goog

