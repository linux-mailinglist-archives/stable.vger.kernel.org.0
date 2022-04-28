Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF47D513F4B
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 02:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353494AbiD2ACv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 20:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353497AbiD2ACu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 20:02:50 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73236B3DF6
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a18-20020a25bad2000000b0063360821ea7so6011508ybk.15
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=y7ROG8K7b9SbY1ukufVwtqFXGsg8o23NDMWbhHQt+a8=;
        b=W6KxjWSfNyqQukCRWFvFO1qfOknYa/yTW0zC924dlhsTYc5gnS71EkGADtU2x7wXNb
         8zqhmqG6iSOlO080S4tZBygcy4Im/UAhu9UEzIdRwkwkfX6oPc9FDjXjGJlibC+83VPk
         uHVqy/8zL2zdRYld9yZ1TqOXUr6jp7YzttWEP9AGi2BDK0f8f+E24zS3hlFLACwtAdNd
         ZHfhIDlOWbBIyWoBTMJquVNo8ObVLuZO50sLWZ//9jzBHfB1Gm2xLYv8WUUppJWcvO+Z
         hQj06xQv/ruJrpLWYhEc3hiWbrDkeMvQ4mlhOiSKQbu6rqZ6e6U9XrMWYfE47M4udkNe
         W9gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=y7ROG8K7b9SbY1ukufVwtqFXGsg8o23NDMWbhHQt+a8=;
        b=k/nwea61M+K84c18JkMF3SeF4nToG08M7mQ8FigervbONjni/AsStp6uBWemW/o1kd
         uF3Mu94ahC1ZHKW0S2FdAKpoYDk1kpKOLncOwa8giKjBre11ieRbSjMM4rahzlwmWKm+
         WfVnuViH0SvISNFdgmjpEVR7nfX7kZniqFOFJMARif1581fx80sUO3R8aqE/z8TQZ+5y
         FW5nuDGDr+Dlae9IPSUuLen++HbjcvlaS6pXGn1PQoN5bd1T2ylQZWainmDWvfRbWzrF
         cIPr5GROrOjgxk0Ok7PCQvMukPg7ERfuJ6wxtpbT3v37ixFmC2y/p/dmn8WK09pMx0eI
         /xBg==
X-Gm-Message-State: AOAM531QwamfSGfxTtQ5G51/xFTFmA2JuIG2Enf71r1GNnaOz3Mlxtts
        C4yb+pO+fJh+mWxTcvAyf5gy6Jsyw2M=
X-Google-Smtp-Source: ABdhPJzO49nOs04NkEm7uikekE7KkjEt9KOQBc88bfNWViLUVW3iq5f502nRNLFQAAkV/l8z3cnaYJoMQSw=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:25cd:1665:36bc:f38e])
 (user=haoluo job=sendgmr) by 2002:a25:844b:0:b0:648:5385:313b with SMTP id
 r11-20020a25844b000000b006485385313bmr23669690ybm.430.1651190372658; Thu, 28
 Apr 2022 16:59:32 -0700 (PDT)
Date:   Thu, 28 Apr 2022 16:57:49 -0700
In-Reply-To: <20220428235751.103203-1-haoluo@google.com>
Message-Id: <20220428235751.103203-9-haoluo@google.com>
Mime-Version: 1.0
References: <20220428235751.103203-1-haoluo@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH stable linux-5.15.y 08/10] bpf: Add MEM_RDONLY for helper args
 that are pointers to rdonly mem.
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

commit 216e3cd2f28dbbf1fe86848e0e29e6693b9f0a20 upstream.

Some helper functions may modify its arguments, for example,
bpf_d_path, bpf_get_stack etc. Previously, their argument types
were marked as ARG_PTR_TO_MEM, which is compatible with read-only
mem types, such as PTR_TO_RDONLY_BUF. Therefore it's legitimate,
but technically incorrect, to modify a read-only memory by passing
it into one of such helper functions.

This patch tags the bpf_args compatible with immutable memory with
MEM_RDONLY flag. The arguments that don't have this flag will be
only compatible with mutable memory types, preventing the helper
from modifying a read-only memory. The bpf_args that have
MEM_RDONLY are compatible with both mutable memory and immutable
memory.

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211217003152.48334-9-haoluo@google.com
Cc: stable@vger.kernel.org # 5.15.x
---
 include/linux/bpf.h      |  4 ++-
 kernel/bpf/btf.c         |  2 +-
 kernel/bpf/cgroup.c      |  2 +-
 kernel/bpf/helpers.c     |  8 ++---
 kernel/bpf/ringbuf.c     |  2 +-
 kernel/bpf/syscall.c     |  2 +-
 kernel/bpf/verifier.c    | 20 +++++++++++--
 kernel/trace/bpf_trace.c | 22 +++++++-------
 net/core/filter.c        | 64 ++++++++++++++++++++--------------------
 9 files changed, 71 insertions(+), 55 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1cb5aae0fcb6..c5c4b6f09e23 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -307,7 +307,9 @@ enum bpf_type_flag {
 	/* PTR may be NULL. */
 	PTR_MAYBE_NULL		= BIT(0 + BPF_BASE_TYPE_BITS),
 
-	/* MEM is read-only. */
+	/* MEM is read-only. When applied on bpf_arg, it indicates the arg is
+	 * compatible with both mutable and immutable memory.
+	 */
 	MEM_RDONLY		= BIT(1 + BPF_BASE_TYPE_BITS),
 
 	__BPF_TYPE_LAST_FLAG	= MEM_RDONLY,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index c2ecea3c16e0..ba471f38bb4d 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6231,7 +6231,7 @@ const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
 	.func		= bpf_btf_find_by_name_kind,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE,
 	.arg3_type	= ARG_ANYTHING,
 	.arg4_type	= ARG_ANYTHING,
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 7dbd68195a2b..fe053ffd8932 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1753,7 +1753,7 @@ static const struct bpf_func_proto bpf_sysctl_set_new_value_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 };
 
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 7db5511cc300..a711ffe23893 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -530,7 +530,7 @@ const struct bpf_func_proto bpf_strtol_proto = {
 	.func		= bpf_strtol,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE,
 	.arg3_type	= ARG_ANYTHING,
 	.arg4_type	= ARG_PTR_TO_LONG,
@@ -558,7 +558,7 @@ const struct bpf_func_proto bpf_strtoul_proto = {
 	.func		= bpf_strtoul,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE,
 	.arg3_type	= ARG_ANYTHING,
 	.arg4_type	= ARG_PTR_TO_LONG,
@@ -630,7 +630,7 @@ const struct bpf_func_proto bpf_event_output_data_proto =  {
 	.arg1_type      = ARG_PTR_TO_CTX,
 	.arg2_type      = ARG_CONST_MAP_PTR,
 	.arg3_type      = ARG_ANYTHING,
-	.arg4_type      = ARG_PTR_TO_MEM,
+	.arg4_type      = ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type      = ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -1013,7 +1013,7 @@ const struct bpf_func_proto bpf_snprintf_proto = {
 	.arg1_type	= ARG_PTR_TO_MEM_OR_NULL,
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg3_type	= ARG_PTR_TO_CONST_STR,
-	.arg4_type	= ARG_PTR_TO_MEM_OR_NULL,
+	.arg4_type	= ARG_PTR_TO_MEM | PTR_MAYBE_NULL | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index f1c51c45667d..710ba9de12ce 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -444,7 +444,7 @@ const struct bpf_func_proto bpf_ringbuf_output_proto = {
 	.func		= bpf_ringbuf_output,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_CONST_MAP_PTR,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg4_type	= ARG_ANYTHING,
 };
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 42490c39dfbf..48e02a725563 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4753,7 +4753,7 @@ static const struct bpf_func_proto bpf_sys_bpf_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_ANYTHING,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 };
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 42b64d844eae..d2b119b4fbe7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4890,7 +4890,6 @@ static const struct bpf_reg_types mem_types = {
 		PTR_TO_MAP_VALUE,
 		PTR_TO_MEM,
 		PTR_TO_BUF,
-		PTR_TO_BUF | MEM_RDONLY,
 	},
 };
 
@@ -4960,6 +4959,21 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
 		return -EFAULT;
 	}
 
+	/* ARG_PTR_TO_MEM + RDONLY is compatible with PTR_TO_MEM and PTR_TO_MEM + RDONLY,
+	 * but ARG_PTR_TO_MEM is compatible only with PTR_TO_MEM and NOT with PTR_TO_MEM + RDONLY
+	 *
+	 * Same for MAYBE_NULL:
+	 *
+	 * ARG_PTR_TO_MEM + MAYBE_NULL is compatible with PTR_TO_MEM and PTR_TO_MEM + MAYBE_NULL,
+	 * but ARG_PTR_TO_MEM is compatible only with PTR_TO_MEM but NOT with PTR_TO_MEM + MAYBE_NULL
+	 *
+	 * Therefore we fold these flags depending on the arg_type before comparison.
+	 */
+	if (arg_type & MEM_RDONLY)
+		type &= ~MEM_RDONLY;
+	if (arg_type & PTR_MAYBE_NULL)
+		type &= ~PTR_MAYBE_NULL;
+
 	for (i = 0; i < ARRAY_SIZE(compatible->types); i++) {
 		expected = compatible->types[i];
 		if (expected == NOT_INIT)
@@ -4969,14 +4983,14 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
 			goto found;
 	}
 
-	verbose(env, "R%d type=%s expected=", regno, reg_type_str(env, type));
+	verbose(env, "R%d type=%s expected=", regno, reg_type_str(env, reg->type));
 	for (j = 0; j + 1 < i; j++)
 		verbose(env, "%s, ", reg_type_str(env, compatible->types[j]));
 	verbose(env, "%s\n", reg_type_str(env, compatible->types[j]));
 	return -EACCES;
 
 found:
-	if (type == PTR_TO_BTF_ID) {
+	if (reg->type == PTR_TO_BTF_ID) {
 		if (!arg_btf_id) {
 			if (!compatible->btf_id) {
 				verbose(env, "verifier internal error: missing arg compatible BTF ID\n");
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 5a18b861fcf7..c289010b0964 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -345,7 +345,7 @@ static const struct bpf_func_proto bpf_probe_write_user_proto = {
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_ANYTHING,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 };
 
@@ -394,7 +394,7 @@ static const struct bpf_func_proto bpf_trace_printk_proto = {
 	.func		= bpf_trace_printk,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE,
 };
 
@@ -446,9 +446,9 @@ static const struct bpf_func_proto bpf_seq_printf_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID,
 	.arg1_btf_id	= &btf_seq_file_ids[0],
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
-	.arg4_type      = ARG_PTR_TO_MEM_OR_NULL,
+	.arg4_type      = ARG_PTR_TO_MEM | PTR_MAYBE_NULL | MEM_RDONLY,
 	.arg5_type      = ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -463,7 +463,7 @@ static const struct bpf_func_proto bpf_seq_write_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID,
 	.arg1_btf_id	= &btf_seq_file_ids[0],
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -487,7 +487,7 @@ static const struct bpf_func_proto bpf_seq_printf_btf_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID,
 	.arg1_btf_id	= &btf_seq_file_ids[0],
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg4_type	= ARG_ANYTHING,
 };
@@ -648,7 +648,7 @@ static const struct bpf_func_proto bpf_perf_event_output_proto = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_CONST_MAP_PTR,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -958,7 +958,7 @@ const struct bpf_func_proto bpf_snprintf_btf_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_MEM,
 	.arg2_type	= ARG_CONST_SIZE,
-	.arg3_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg4_type	= ARG_CONST_SIZE,
 	.arg5_type	= ARG_ANYTHING,
 };
@@ -1207,7 +1207,7 @@ static const struct bpf_func_proto bpf_perf_event_output_proto_tp = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_CONST_MAP_PTR,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -1429,7 +1429,7 @@ static const struct bpf_func_proto bpf_perf_event_output_proto_raw_tp = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_CONST_MAP_PTR,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -1483,7 +1483,7 @@ static const struct bpf_func_proto bpf_get_stack_proto_raw_tp = {
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg4_type	= ARG_ANYTHING,
 };
diff --git a/net/core/filter.c b/net/core/filter.c
index cdd7e92db303..821278b906b7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1713,7 +1713,7 @@ static const struct bpf_func_proto bpf_skb_store_bytes_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
-	.arg3_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg4_type	= ARG_CONST_SIZE,
 	.arg5_type	= ARG_ANYTHING,
 };
@@ -2018,9 +2018,9 @@ static const struct bpf_func_proto bpf_csum_diff_proto = {
 	.gpl_only	= false,
 	.pkt_access	= true,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_MEM_OR_NULL,
+	.arg1_type	= ARG_PTR_TO_MEM | PTR_MAYBE_NULL | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
-	.arg3_type	= ARG_PTR_TO_MEM_OR_NULL,
+	.arg3_type	= ARG_PTR_TO_MEM | PTR_MAYBE_NULL | MEM_RDONLY,
 	.arg4_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg5_type	= ARG_ANYTHING,
 };
@@ -2541,7 +2541,7 @@ static const struct bpf_func_proto bpf_redirect_neigh_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_ANYTHING,
-	.arg2_type      = ARG_PTR_TO_MEM_OR_NULL,
+	.arg2_type      = ARG_PTR_TO_MEM | PTR_MAYBE_NULL | MEM_RDONLY,
 	.arg3_type      = ARG_CONST_SIZE_OR_ZERO,
 	.arg4_type	= ARG_ANYTHING,
 };
@@ -4177,7 +4177,7 @@ static const struct bpf_func_proto bpf_skb_event_output_proto = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_CONST_MAP_PTR,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -4191,7 +4191,7 @@ const struct bpf_func_proto bpf_skb_output_proto = {
 	.arg1_btf_id	= &bpf_skb_output_btf_ids[0],
 	.arg2_type	= ARG_CONST_MAP_PTR,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -4374,7 +4374,7 @@ static const struct bpf_func_proto bpf_skb_set_tunnel_key_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 };
@@ -4400,7 +4400,7 @@ static const struct bpf_func_proto bpf_skb_set_tunnel_opt_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 };
 
@@ -4570,7 +4570,7 @@ static const struct bpf_func_proto bpf_xdp_event_output_proto = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_CONST_MAP_PTR,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -4584,7 +4584,7 @@ const struct bpf_func_proto bpf_xdp_output_proto = {
 	.arg1_btf_id	= &bpf_xdp_output_btf_ids[0],
 	.arg2_type	= ARG_CONST_MAP_PTR,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -5072,7 +5072,7 @@ const struct bpf_func_proto bpf_sk_setsockopt_proto = {
 	.arg1_type	= ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 	.arg2_type	= ARG_ANYTHING,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE,
 };
 
@@ -5106,7 +5106,7 @@ static const struct bpf_func_proto bpf_sock_addr_setsockopt_proto = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE,
 };
 
@@ -5140,7 +5140,7 @@ static const struct bpf_func_proto bpf_sock_ops_setsockopt_proto = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE,
 };
 
@@ -5315,7 +5315,7 @@ static const struct bpf_func_proto bpf_bind_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 };
 
@@ -5903,7 +5903,7 @@ static const struct bpf_func_proto bpf_lwt_in_push_encap_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
-	.arg3_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg4_type	= ARG_CONST_SIZE
 };
 
@@ -5913,7 +5913,7 @@ static const struct bpf_func_proto bpf_lwt_xmit_push_encap_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
-	.arg3_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg4_type	= ARG_CONST_SIZE
 };
 
@@ -5956,7 +5956,7 @@ static const struct bpf_func_proto bpf_lwt_seg6_store_bytes_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
-	.arg3_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg4_type	= ARG_CONST_SIZE
 };
 
@@ -6044,7 +6044,7 @@ static const struct bpf_func_proto bpf_lwt_seg6_action_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
-	.arg3_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg4_type	= ARG_CONST_SIZE
 };
 
@@ -6269,7 +6269,7 @@ static const struct bpf_func_proto bpf_skc_lookup_tcp_proto = {
 	.pkt_access	= true,
 	.ret_type	= RET_PTR_TO_SOCK_COMMON_OR_NULL,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 	.arg5_type	= ARG_ANYTHING,
@@ -6288,7 +6288,7 @@ static const struct bpf_func_proto bpf_sk_lookup_tcp_proto = {
 	.pkt_access	= true,
 	.ret_type	= RET_PTR_TO_SOCKET_OR_NULL,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 	.arg5_type	= ARG_ANYTHING,
@@ -6307,7 +6307,7 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
 	.pkt_access	= true,
 	.ret_type	= RET_PTR_TO_SOCKET_OR_NULL,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 	.arg5_type	= ARG_ANYTHING,
@@ -6344,7 +6344,7 @@ static const struct bpf_func_proto bpf_xdp_sk_lookup_udp_proto = {
 	.pkt_access     = true,
 	.ret_type       = RET_PTR_TO_SOCKET_OR_NULL,
 	.arg1_type      = ARG_PTR_TO_CTX,
-	.arg2_type      = ARG_PTR_TO_MEM,
+	.arg2_type      = ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type      = ARG_CONST_SIZE,
 	.arg4_type      = ARG_ANYTHING,
 	.arg5_type      = ARG_ANYTHING,
@@ -6367,7 +6367,7 @@ static const struct bpf_func_proto bpf_xdp_skc_lookup_tcp_proto = {
 	.pkt_access     = true,
 	.ret_type       = RET_PTR_TO_SOCK_COMMON_OR_NULL,
 	.arg1_type      = ARG_PTR_TO_CTX,
-	.arg2_type      = ARG_PTR_TO_MEM,
+	.arg2_type      = ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type      = ARG_CONST_SIZE,
 	.arg4_type      = ARG_ANYTHING,
 	.arg5_type      = ARG_ANYTHING,
@@ -6390,7 +6390,7 @@ static const struct bpf_func_proto bpf_xdp_sk_lookup_tcp_proto = {
 	.pkt_access     = true,
 	.ret_type       = RET_PTR_TO_SOCKET_OR_NULL,
 	.arg1_type      = ARG_PTR_TO_CTX,
-	.arg2_type      = ARG_PTR_TO_MEM,
+	.arg2_type      = ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type      = ARG_CONST_SIZE,
 	.arg4_type      = ARG_ANYTHING,
 	.arg5_type      = ARG_ANYTHING,
@@ -6409,7 +6409,7 @@ static const struct bpf_func_proto bpf_sock_addr_skc_lookup_tcp_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_PTR_TO_SOCK_COMMON_OR_NULL,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 	.arg5_type	= ARG_ANYTHING,
@@ -6428,7 +6428,7 @@ static const struct bpf_func_proto bpf_sock_addr_sk_lookup_tcp_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_PTR_TO_SOCKET_OR_NULL,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 	.arg5_type	= ARG_ANYTHING,
@@ -6447,7 +6447,7 @@ static const struct bpf_func_proto bpf_sock_addr_sk_lookup_udp_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_PTR_TO_SOCKET_OR_NULL,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 	.arg5_type	= ARG_ANYTHING,
@@ -6769,9 +6769,9 @@ static const struct bpf_func_proto bpf_tcp_check_syncookie_proto = {
 	.pkt_access	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID_SOCK_COMMON,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE,
 };
 
@@ -6838,9 +6838,9 @@ static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
 	.pkt_access	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID_SOCK_COMMON,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE,
 };
 
@@ -7069,7 +7069,7 @@ static const struct bpf_func_proto bpf_sock_ops_store_hdr_opt_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 };
-- 
2.36.0.464.gb9c8b46e94-goog

