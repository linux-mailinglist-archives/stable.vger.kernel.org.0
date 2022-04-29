Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D2F514786
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357952AbiD2KsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357932AbiD2Krd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:47:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B68C9B49;
        Fri, 29 Apr 2022 03:43:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AFB6B8344E;
        Fri, 29 Apr 2022 10:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93397C385A7;
        Fri, 29 Apr 2022 10:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228985;
        bh=PH2fEo2gX2WYr22TAaYwcnFxMKwrIJ2TF9uLgs2SCVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElcljPtxIN9sMuK7AOvpVX45MfxTr6/o+Ys2gRF9O+wd7QOVbfBCgr2URI8rzvVQm
         pNNZEQLvwUBSKd3Fill3Svs+5bSR8a4Udn0/Xl8bHpo5vGl30c8giwobsbNIOpNq9x
         AlQ67eHigy/UNq0qijR9yx2jfgXJl4Fd4zNslkY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 03/33] bpf: Replace ARG_XXX_OR_NULL with ARG_XXX | PTR_MAYBE_NULL
Date:   Fri, 29 Apr 2022 12:41:50 +0200
Message-Id: <20220429104052.444732851@linuxfoundation.org>
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
Cc: stable@vger.kernel.org # 5.15.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h   |   15 +++++++++------
 kernel/bpf/verifier.c |   39 ++++++++++++++-------------------------
 2 files changed, 23 insertions(+), 31 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -327,13 +327,11 @@ enum bpf_arg_type {
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
@@ -343,26 +341,31 @@ enum bpf_arg_type {
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
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -478,14 +478,9 @@ static bool arg_type_may_be_refcounted(e
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
@@ -4796,9 +4791,8 @@ static int process_timer_func(struct bpf
 
 static bool arg_type_is_mem_ptr(enum bpf_arg_type type)
 {
-	return type == ARG_PTR_TO_MEM ||
-	       type == ARG_PTR_TO_MEM_OR_NULL ||
-	       type == ARG_PTR_TO_UNINIT_MEM;
+	return base_type(type) == ARG_PTR_TO_MEM ||
+	       base_type(type) == ARG_PTR_TO_UNINIT_MEM;
 }
 
 static bool arg_type_is_mem_size(enum bpf_arg_type type)
@@ -4932,31 +4926,26 @@ static const struct bpf_reg_types *compa
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
@@ -4970,7 +4959,7 @@ static int check_reg_type(struct bpf_ver
 	const struct bpf_reg_types *compatible;
 	int i, j;
 
-	compatible = compatible_reg_types[arg_type];
+	compatible = compatible_reg_types[base_type(arg_type)];
 	if (!compatible) {
 		verbose(env, "verifier internal error: unsupported arg type %d\n", arg_type);
 		return -EFAULT;
@@ -5051,15 +5040,14 @@ static int check_func_arg(struct bpf_ver
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
@@ -5128,10 +5116,11 @@ skip_type_check:
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


