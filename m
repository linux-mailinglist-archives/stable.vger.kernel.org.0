Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75E14B9413
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 23:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237766AbiBPWwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 17:52:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237728AbiBPWwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 17:52:33 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E688A65798
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 14:52:19 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id t8-20020a259ac8000000b00619a3b5977fso7295368ybo.5
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 14:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=V4H6YGOL4+6a8Mf+V69pg/yW52K/GHTqmuFi6m3KYso=;
        b=RxeLRUf9vcwhURZH4NfF+bBXGn7ZrE87wTFgXMckeKsAJm5ES4d2COnaop4h1FRjUi
         wNYumKFIfL33oocWZKuGl0BJB9kypyV1vwLieevjvkBOfCg5gVuGW4uSE1o4sAOqbqxq
         bbzbK0CF+3+omXlL8R7EOIgVfmj80WQH0Hwsx8GmCYPZNXv1wD4MaMvzZt8vv38RJJbp
         0sTMDc+z2Xd2geACoO/sZWEYD+AWpYf5yn0xf+iKaeOLt1pGnjjplEoR/srRv9m7dOqb
         qvExjPty8P2d23GY+AhzGWuHZrgu7invT9TOr5+HSe9cPlzbAwrZ1Qx8IiQ/PY19Hruu
         q+Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=V4H6YGOL4+6a8Mf+V69pg/yW52K/GHTqmuFi6m3KYso=;
        b=FlaVe5bpQwdFUz+LRVm5gtq2AxbbUIbdAw21j6KD1xrNVMN3zXzYMCwYoB03RsHWPZ
         yazDVmt3lSkJueEWNeDc/JUnKgRP7gxzCgcrzxZ7zLetkHxFLqRf3niaLaeUGk+Hz6K+
         SXtg3bKJTjapW4BthcTDiEk4tpLZkgx0D9oUJlempPo2AG0+q3SJ3WA/qy6o7VlO1T4S
         dpViliMMQ0AOEO80Tz71CtezFo9VplrrQOsoGQcj+h0/gjjtRnAPGq08qs2UN2na1Mq8
         5iNVrHBd7JjlVBq1CdTv1u3gpvzNTd7G6XrwW8B1mpMtWvdviWZ81u2tfKoAW7ZEh2Qk
         EQiw==
X-Gm-Message-State: AOAM5338jtsZGTC9rKG8YicJO+uehNUVAUqJWZihRvH9ZV8/SgAiXHQM
        1u7GbQGaW2oPYqIYqYtQScS9ZJV3+1Y=
X-Google-Smtp-Source: ABdhPJxQtxZyAohqUIel4Kg1Ki2u6lixEVtV6dZHoMbBsu5W66LdY69PLtGzctfvSi+HdzvcFhSZuLa3ENU=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:6674:61c7:b01a:7f98])
 (user=haoluo job=sendgmr) by 2002:a25:c693:0:b0:61d:d5ec:aad4 with SMTP id
 k141-20020a25c693000000b0061dd5ecaad4mr112113ybf.682.1645051939148; Wed, 16
 Feb 2022 14:52:19 -0800 (PST)
Date:   Wed, 16 Feb 2022 14:52:02 -0800
In-Reply-To: <20220216225209.2196865-1-haoluo@google.com>
Message-Id: <20220216225209.2196865-3-haoluo@google.com>
Mime-Version: 1.0
References: <20220216225209.2196865-1-haoluo@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH stable linux-5.16.y 2/9] bpf: Replace ARG_XXX_OR_NULL with
 ARG_XXX | PTR_MAYBE_NULL
From:   Hao Luo <haoluo@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, laura@labbott.name,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 48946bd6a5d695c50b34546864b79c1f910a33c1 upstream.

We have introduced a new type to make bpf_arg composable, by
reserving high bits of bpf_arg to represent flags of a type.

One of the flags is PTR_MAYBE_NULL which indicates a pointer
may be NULL. When applying this flag to an arg_type, it means
the arg can take NULL pointer. This patch switches the
qualified arg_types to use this flag. The arg_types changed
in this patch include:

1. ARG_PTR_TO_MAP_VALUE_OR_NULL
2. ARG_PTR_TO_MEM_OR_NULL
3. ARG_PTR_TO_CTX_OR_NULL
4. ARG_PTR_TO_SOCKET_OR_NULL
5. ARG_PTR_TO_ALLOC_MEM_OR_NULL
6. ARG_PTR_TO_STACK_OR_NULL

This patch does not eliminate the use of these arg_types, instead
it makes them an alias to the 'ARG_XXX | PTR_MAYBE_NULL'.

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211217003152.48334-3-haoluo@google.com
Cc: stable@vger.kernel.org # 5.16.x
---
 include/linux/bpf.h   | 15 +++++++++------
 kernel/bpf/verifier.c | 39 ++++++++++++++-------------------------
 2 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index afebe332898f..f13711ac0979 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -331,13 +331,11 @@ enum bpf_arg_type {
 	ARG_PTR_TO_MAP_KEY,	/* pointer to stack used as map key */
 	ARG_PTR_TO_MAP_VALUE,	/* pointer to stack used as map value */
 	ARG_PTR_TO_UNINIT_MAP_VALUE,	/* pointer to valid memory used to store a map value */
-	ARG_PTR_TO_MAP_VALUE_OR_NULL,	/* pointer to stack used as map value or NULL */
 
 	/* the following constraints used to prototype bpf_memcmp() and other
 	 * functions that access data on eBPF program stack
 	 */
 	ARG_PTR_TO_MEM,		/* pointer to valid memory (stack, packet, map value) */
-	ARG_PTR_TO_MEM_OR_NULL, /* pointer to valid memory or NULL */
 	ARG_PTR_TO_UNINIT_MEM,	/* pointer to memory does not need to be initialized,
 				 * helper function must fill all bytes or clear
 				 * them in error case.
@@ -347,26 +345,31 @@ enum bpf_arg_type {
 	ARG_CONST_SIZE_OR_ZERO,	/* number of bytes accessed from memory or 0 */
 
 	ARG_PTR_TO_CTX,		/* pointer to context */
-	ARG_PTR_TO_CTX_OR_NULL,	/* pointer to context or NULL */
 	ARG_ANYTHING,		/* any (initialized) argument is ok */
 	ARG_PTR_TO_SPIN_LOCK,	/* pointer to bpf_spin_lock */
 	ARG_PTR_TO_SOCK_COMMON,	/* pointer to sock_common */
 	ARG_PTR_TO_INT,		/* pointer to int */
 	ARG_PTR_TO_LONG,	/* pointer to long */
 	ARG_PTR_TO_SOCKET,	/* pointer to bpf_sock (fullsock) */
-	ARG_PTR_TO_SOCKET_OR_NULL,	/* pointer to bpf_sock (fullsock) or NULL */
 	ARG_PTR_TO_BTF_ID,	/* pointer to in-kernel struct */
 	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
-	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memory or NULL */
 	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
 	ARG_PTR_TO_BTF_ID_SOCK_COMMON,	/* pointer to in-kernel sock_common or bpf-mirrored bpf_sock */
 	ARG_PTR_TO_PERCPU_BTF_ID,	/* pointer to in-kernel percpu type */
 	ARG_PTR_TO_FUNC,	/* pointer to a bpf program function */
-	ARG_PTR_TO_STACK_OR_NULL,	/* pointer to stack or NULL */
+	ARG_PTR_TO_STACK,	/* pointer to stack */
 	ARG_PTR_TO_CONST_STR,	/* pointer to a null terminated read-only string */
 	ARG_PTR_TO_TIMER,	/* pointer to bpf_timer */
 	__BPF_ARG_TYPE_MAX,
 
+	/* Extended arg_types. */
+	ARG_PTR_TO_MAP_VALUE_OR_NULL	= PTR_MAYBE_NULL | ARG_PTR_TO_MAP_VALUE,
+	ARG_PTR_TO_MEM_OR_NULL		= PTR_MAYBE_NULL | ARG_PTR_TO_MEM,
+	ARG_PTR_TO_CTX_OR_NULL		= PTR_MAYBE_NULL | ARG_PTR_TO_CTX,
+	ARG_PTR_TO_SOCKET_OR_NULL	= PTR_MAYBE_NULL | ARG_PTR_TO_SOCKET,
+	ARG_PTR_TO_ALLOC_MEM_OR_NULL	= PTR_MAYBE_NULL | ARG_PTR_TO_ALLOC_MEM,
+	ARG_PTR_TO_STACK_OR_NULL	= PTR_MAYBE_NULL | ARG_PTR_TO_STACK,
+
 	/* This must be the last entry. Its purpose is to ensure the enum is
 	 * wide enough to hold the higher bits reserved for bpf_type_flag.
 	 */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6b987407752a..3ee21e21d52c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -472,14 +472,9 @@ static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
 	return type == ARG_PTR_TO_SOCK_COMMON;
 }
 
-static bool arg_type_may_be_null(enum bpf_arg_type type)
+static bool type_may_be_null(u32 type)
 {
-	return type == ARG_PTR_TO_MAP_VALUE_OR_NULL ||
-	       type == ARG_PTR_TO_MEM_OR_NULL ||
-	       type == ARG_PTR_TO_CTX_OR_NULL ||
-	       type == ARG_PTR_TO_SOCKET_OR_NULL ||
-	       type == ARG_PTR_TO_ALLOC_MEM_OR_NULL ||
-	       type == ARG_PTR_TO_STACK_OR_NULL;
+	return type & PTR_MAYBE_NULL;
 }
 
 /* Determine whether the function releases some resources allocated by another
@@ -4963,9 +4958,8 @@ static int process_timer_func(struct bpf_verifier_env *env, int regno,
 
 static bool arg_type_is_mem_ptr(enum bpf_arg_type type)
 {
-	return type == ARG_PTR_TO_MEM ||
-	       type == ARG_PTR_TO_MEM_OR_NULL ||
-	       type == ARG_PTR_TO_UNINIT_MEM;
+	return base_type(type) == ARG_PTR_TO_MEM ||
+	       base_type(type) == ARG_PTR_TO_UNINIT_MEM;
 }
 
 static bool arg_type_is_mem_size(enum bpf_arg_type type)
@@ -5102,31 +5096,26 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_PTR_TO_MAP_KEY]		= &map_key_value_types,
 	[ARG_PTR_TO_MAP_VALUE]		= &map_key_value_types,
 	[ARG_PTR_TO_UNINIT_MAP_VALUE]	= &map_key_value_types,
-	[ARG_PTR_TO_MAP_VALUE_OR_NULL]	= &map_key_value_types,
 	[ARG_CONST_SIZE]		= &scalar_types,
 	[ARG_CONST_SIZE_OR_ZERO]	= &scalar_types,
 	[ARG_CONST_ALLOC_SIZE_OR_ZERO]	= &scalar_types,
 	[ARG_CONST_MAP_PTR]		= &const_map_ptr_types,
 	[ARG_PTR_TO_CTX]		= &context_types,
-	[ARG_PTR_TO_CTX_OR_NULL]	= &context_types,
 	[ARG_PTR_TO_SOCK_COMMON]	= &sock_types,
 #ifdef CONFIG_NET
 	[ARG_PTR_TO_BTF_ID_SOCK_COMMON]	= &btf_id_sock_common_types,
 #endif
 	[ARG_PTR_TO_SOCKET]		= &fullsock_types,
-	[ARG_PTR_TO_SOCKET_OR_NULL]	= &fullsock_types,
 	[ARG_PTR_TO_BTF_ID]		= &btf_ptr_types,
 	[ARG_PTR_TO_SPIN_LOCK]		= &spin_lock_types,
 	[ARG_PTR_TO_MEM]		= &mem_types,
-	[ARG_PTR_TO_MEM_OR_NULL]	= &mem_types,
 	[ARG_PTR_TO_UNINIT_MEM]		= &mem_types,
 	[ARG_PTR_TO_ALLOC_MEM]		= &alloc_mem_types,
-	[ARG_PTR_TO_ALLOC_MEM_OR_NULL]	= &alloc_mem_types,
 	[ARG_PTR_TO_INT]		= &int_ptr_types,
 	[ARG_PTR_TO_LONG]		= &int_ptr_types,
 	[ARG_PTR_TO_PERCPU_BTF_ID]	= &percpu_btf_ptr_types,
 	[ARG_PTR_TO_FUNC]		= &func_ptr_types,
-	[ARG_PTR_TO_STACK_OR_NULL]	= &stack_ptr_types,
+	[ARG_PTR_TO_STACK]		= &stack_ptr_types,
 	[ARG_PTR_TO_CONST_STR]		= &const_str_ptr_types,
 	[ARG_PTR_TO_TIMER]		= &timer_types,
 };
@@ -5140,7 +5129,7 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
 	const struct bpf_reg_types *compatible;
 	int i, j;
 
-	compatible = compatible_reg_types[arg_type];
+	compatible = compatible_reg_types[base_type(arg_type)];
 	if (!compatible) {
 		verbose(env, "verifier internal error: unsupported arg type %d\n", arg_type);
 		return -EFAULT;
@@ -5221,15 +5210,14 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		return -EACCES;
 	}
 
-	if (arg_type == ARG_PTR_TO_MAP_VALUE ||
-	    arg_type == ARG_PTR_TO_UNINIT_MAP_VALUE ||
-	    arg_type == ARG_PTR_TO_MAP_VALUE_OR_NULL) {
+	if (base_type(arg_type) == ARG_PTR_TO_MAP_VALUE ||
+	    base_type(arg_type) == ARG_PTR_TO_UNINIT_MAP_VALUE) {
 		err = resolve_map_arg_type(env, meta, &arg_type);
 		if (err)
 			return err;
 	}
 
-	if (register_is_null(reg) && arg_type_may_be_null(arg_type))
+	if (register_is_null(reg) && type_may_be_null(arg_type))
 		/* A NULL register has a SCALAR_VALUE type, so skip
 		 * type checking.
 		 */
@@ -5298,10 +5286,11 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		err = check_helper_mem_access(env, regno,
 					      meta->map_ptr->key_size, false,
 					      NULL);
-	} else if (arg_type == ARG_PTR_TO_MAP_VALUE ||
-		   (arg_type == ARG_PTR_TO_MAP_VALUE_OR_NULL &&
-		    !register_is_null(reg)) ||
-		   arg_type == ARG_PTR_TO_UNINIT_MAP_VALUE) {
+	} else if (base_type(arg_type) == ARG_PTR_TO_MAP_VALUE ||
+		   base_type(arg_type) == ARG_PTR_TO_UNINIT_MAP_VALUE) {
+		if (type_may_be_null(arg_type) && register_is_null(reg))
+			return 0;
+
 		/* bpf_map_xxx(..., map_ptr, ..., value) call:
 		 * check [value, value + map->value_size) validity
 		 */
-- 
2.35.1.265.g69c8d7142f-goog

