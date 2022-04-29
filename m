Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AAD514758
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357861AbiD2Ktq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358123AbiD2Ksp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:48:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44F5CA0F8;
        Fri, 29 Apr 2022 03:43:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DB0460C8E;
        Fri, 29 Apr 2022 10:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DADC385AD;
        Fri, 29 Apr 2022 10:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651229034;
        bh=0WNEd8stFqmhkeHmsOuxdI4qhlt1ptMG4LxZUvXajJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V50rODOy1J6VdZ20INfRi5z2v/A3EQtBYRnKx6PADa/dYUzVzC1H/HNdinmJjw4KQ
         pseRdYJ7k4mxnh7GKw4FzIGpxLUZZXPztHz/0gW/GpwasqxBgYar7M4ssA3gTI/gdm
         GW6s6hFLUhW8+kzrG4qP5UvBatrhhPuEPUEQJnkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 09/33] bpf: Add MEM_RDONLY for helper args that are pointers to rdonly mem.
Date:   Fri, 29 Apr 2022 12:41:56 +0200
Message-Id: <20220429104052.613931896@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h      |    4 ++
 kernel/bpf/btf.c         |    2 -
 kernel/bpf/cgroup.c      |    2 -
 kernel/bpf/helpers.c     |    8 ++---
 kernel/bpf/ringbuf.c     |    2 -
 kernel/bpf/syscall.c     |    2 -
 kernel/bpf/verifier.c    |   20 ++++++++++++--
 kernel/trace/bpf_trace.c |   22 ++++++++--------
 net/core/filter.c        |   64 +++++++++++++++++++++++------------------------
 9 files changed, 71 insertions(+), 55 deletions(-)

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
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6231,7 +6231,7 @@ const struct bpf_func_proto bpf_btf_find
 	.func		= bpf_btf_find_by_name_kind,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE,
 	.arg3_type	= ARG_ANYTHING,
 	.arg4_type	= ARG_ANYTHING,
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1753,7 +1753,7 @@ static const struct bpf_func_proto bpf_s
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 };
 
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -530,7 +530,7 @@ const struct bpf_func_proto bpf_strtol_p
 	.func		= bpf_strtol,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE,
 	.arg3_type	= ARG_ANYTHING,
 	.arg4_type	= ARG_PTR_TO_LONG,
@@ -558,7 +558,7 @@ const struct bpf_func_proto bpf_strtoul_
 	.func		= bpf_strtoul,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE,
 	.arg3_type	= ARG_ANYTHING,
 	.arg4_type	= ARG_PTR_TO_LONG,
@@ -630,7 +630,7 @@ const struct bpf_func_proto bpf_event_ou
 	.arg1_type      = ARG_PTR_TO_CTX,
 	.arg2_type      = ARG_CONST_MAP_PTR,
 	.arg3_type      = ARG_ANYTHING,
-	.arg4_type      = ARG_PTR_TO_MEM,
+	.arg4_type      = ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type      = ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -1013,7 +1013,7 @@ const struct bpf_func_proto bpf_snprintf
 	.arg1_type	= ARG_PTR_TO_MEM_OR_NULL,
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg3_type	= ARG_PTR_TO_CONST_STR,
-	.arg4_type	= ARG_PTR_TO_MEM_OR_NULL,
+	.arg4_type	= ARG_PTR_TO_MEM | PTR_MAYBE_NULL | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -444,7 +444,7 @@ const struct bpf_func_proto bpf_ringbuf_
 	.func		= bpf_ringbuf_output,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_CONST_MAP_PTR,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg4_type	= ARG_ANYTHING,
 };
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4753,7 +4753,7 @@ static const struct bpf_func_proto bpf_s
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_ANYTHING,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 };
 
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4890,7 +4890,6 @@ static const struct bpf_reg_types mem_ty
 		PTR_TO_MAP_VALUE,
 		PTR_TO_MEM,
 		PTR_TO_BUF,
-		PTR_TO_BUF | MEM_RDONLY,
 	},
 };
 
@@ -4960,6 +4959,21 @@ static int check_reg_type(struct bpf_ver
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
@@ -4969,14 +4983,14 @@ static int check_reg_type(struct bpf_ver
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
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -345,7 +345,7 @@ static const struct bpf_func_proto bpf_p
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_ANYTHING,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 };
 
@@ -394,7 +394,7 @@ static const struct bpf_func_proto bpf_t
 	.func		= bpf_trace_printk,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE,
 };
 
@@ -446,9 +446,9 @@ static const struct bpf_func_proto bpf_s
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
 
@@ -463,7 +463,7 @@ static const struct bpf_func_proto bpf_s
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID,
 	.arg1_btf_id	= &btf_seq_file_ids[0],
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -487,7 +487,7 @@ static const struct bpf_func_proto bpf_s
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID,
 	.arg1_btf_id	= &btf_seq_file_ids[0],
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg4_type	= ARG_ANYTHING,
 };
@@ -648,7 +648,7 @@ static const struct bpf_func_proto bpf_p
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_CONST_MAP_PTR,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -958,7 +958,7 @@ const struct bpf_func_proto bpf_snprintf
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_MEM,
 	.arg2_type	= ARG_CONST_SIZE,
-	.arg3_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg4_type	= ARG_CONST_SIZE,
 	.arg5_type	= ARG_ANYTHING,
 };
@@ -1207,7 +1207,7 @@ static const struct bpf_func_proto bpf_p
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_CONST_MAP_PTR,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -1429,7 +1429,7 @@ static const struct bpf_func_proto bpf_p
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_CONST_MAP_PTR,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -1483,7 +1483,7 @@ static const struct bpf_func_proto bpf_g
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg4_type	= ARG_ANYTHING,
 };
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1713,7 +1713,7 @@ static const struct bpf_func_proto bpf_s
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
-	.arg3_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg4_type	= ARG_CONST_SIZE,
 	.arg5_type	= ARG_ANYTHING,
 };
@@ -2018,9 +2018,9 @@ static const struct bpf_func_proto bpf_c
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
@@ -2541,7 +2541,7 @@ static const struct bpf_func_proto bpf_r
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_ANYTHING,
-	.arg2_type      = ARG_PTR_TO_MEM_OR_NULL,
+	.arg2_type      = ARG_PTR_TO_MEM | PTR_MAYBE_NULL | MEM_RDONLY,
 	.arg3_type      = ARG_CONST_SIZE_OR_ZERO,
 	.arg4_type	= ARG_ANYTHING,
 };
@@ -4177,7 +4177,7 @@ static const struct bpf_func_proto bpf_s
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_CONST_MAP_PTR,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -4191,7 +4191,7 @@ const struct bpf_func_proto bpf_skb_outp
 	.arg1_btf_id	= &bpf_skb_output_btf_ids[0],
 	.arg2_type	= ARG_CONST_MAP_PTR,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -4374,7 +4374,7 @@ static const struct bpf_func_proto bpf_s
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 };
@@ -4400,7 +4400,7 @@ static const struct bpf_func_proto bpf_s
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 };
 
@@ -4570,7 +4570,7 @@ static const struct bpf_func_proto bpf_x
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_CONST_MAP_PTR,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -4584,7 +4584,7 @@ const struct bpf_func_proto bpf_xdp_outp
 	.arg1_btf_id	= &bpf_xdp_output_btf_ids[0],
 	.arg2_type	= ARG_CONST_MAP_PTR,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -5072,7 +5072,7 @@ const struct bpf_func_proto bpf_sk_setso
 	.arg1_type	= ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 	.arg2_type	= ARG_ANYTHING,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE,
 };
 
@@ -5106,7 +5106,7 @@ static const struct bpf_func_proto bpf_s
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE,
 };
 
@@ -5140,7 +5140,7 @@ static const struct bpf_func_proto bpf_s
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg5_type	= ARG_CONST_SIZE,
 };
 
@@ -5315,7 +5315,7 @@ static const struct bpf_func_proto bpf_b
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 };
 
@@ -5903,7 +5903,7 @@ static const struct bpf_func_proto bpf_l
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
-	.arg3_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg4_type	= ARG_CONST_SIZE
 };
 
@@ -5913,7 +5913,7 @@ static const struct bpf_func_proto bpf_l
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
-	.arg3_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg4_type	= ARG_CONST_SIZE
 };
 
@@ -5956,7 +5956,7 @@ static const struct bpf_func_proto bpf_l
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
-	.arg3_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg4_type	= ARG_CONST_SIZE
 };
 
@@ -6044,7 +6044,7 @@ static const struct bpf_func_proto bpf_l
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
-	.arg3_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg4_type	= ARG_CONST_SIZE
 };
 
@@ -6269,7 +6269,7 @@ static const struct bpf_func_proto bpf_s
 	.pkt_access	= true,
 	.ret_type	= RET_PTR_TO_SOCK_COMMON_OR_NULL,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 	.arg5_type	= ARG_ANYTHING,
@@ -6288,7 +6288,7 @@ static const struct bpf_func_proto bpf_s
 	.pkt_access	= true,
 	.ret_type	= RET_PTR_TO_SOCKET_OR_NULL,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 	.arg5_type	= ARG_ANYTHING,
@@ -6307,7 +6307,7 @@ static const struct bpf_func_proto bpf_s
 	.pkt_access	= true,
 	.ret_type	= RET_PTR_TO_SOCKET_OR_NULL,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 	.arg5_type	= ARG_ANYTHING,
@@ -6344,7 +6344,7 @@ static const struct bpf_func_proto bpf_x
 	.pkt_access     = true,
 	.ret_type       = RET_PTR_TO_SOCKET_OR_NULL,
 	.arg1_type      = ARG_PTR_TO_CTX,
-	.arg2_type      = ARG_PTR_TO_MEM,
+	.arg2_type      = ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type      = ARG_CONST_SIZE,
 	.arg4_type      = ARG_ANYTHING,
 	.arg5_type      = ARG_ANYTHING,
@@ -6367,7 +6367,7 @@ static const struct bpf_func_proto bpf_x
 	.pkt_access     = true,
 	.ret_type       = RET_PTR_TO_SOCK_COMMON_OR_NULL,
 	.arg1_type      = ARG_PTR_TO_CTX,
-	.arg2_type      = ARG_PTR_TO_MEM,
+	.arg2_type      = ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type      = ARG_CONST_SIZE,
 	.arg4_type      = ARG_ANYTHING,
 	.arg5_type      = ARG_ANYTHING,
@@ -6390,7 +6390,7 @@ static const struct bpf_func_proto bpf_x
 	.pkt_access     = true,
 	.ret_type       = RET_PTR_TO_SOCKET_OR_NULL,
 	.arg1_type      = ARG_PTR_TO_CTX,
-	.arg2_type      = ARG_PTR_TO_MEM,
+	.arg2_type      = ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type      = ARG_CONST_SIZE,
 	.arg4_type      = ARG_ANYTHING,
 	.arg5_type      = ARG_ANYTHING,
@@ -6409,7 +6409,7 @@ static const struct bpf_func_proto bpf_s
 	.gpl_only	= false,
 	.ret_type	= RET_PTR_TO_SOCK_COMMON_OR_NULL,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 	.arg5_type	= ARG_ANYTHING,
@@ -6428,7 +6428,7 @@ static const struct bpf_func_proto bpf_s
 	.gpl_only	= false,
 	.ret_type	= RET_PTR_TO_SOCKET_OR_NULL,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 	.arg5_type	= ARG_ANYTHING,
@@ -6447,7 +6447,7 @@ static const struct bpf_func_proto bpf_s
 	.gpl_only	= false,
 	.ret_type	= RET_PTR_TO_SOCKET_OR_NULL,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 	.arg5_type	= ARG_ANYTHING,
@@ -6769,9 +6769,9 @@ static const struct bpf_func_proto bpf_t
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
 
@@ -6838,9 +6838,9 @@ static const struct bpf_func_proto bpf_t
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
 
@@ -7069,7 +7069,7 @@ static const struct bpf_func_proto bpf_s
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 };


