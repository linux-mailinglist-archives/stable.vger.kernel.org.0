Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B211B5AEEB6
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 17:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240001AbiIFP1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 11:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239483AbiIFP0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 11:26:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7309C00D8;
        Tue,  6 Sep 2022 07:37:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1920D61522;
        Tue,  6 Sep 2022 13:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB860C433D6;
        Tue,  6 Sep 2022 13:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471756;
        bh=vBMgthTadQNphz5a8+B52KcmN0NBY+ceUp57cMixy58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7W8EjTuMtizxJOa9DfiGC0I2GI/V3gRjiYhAQ4vMsGMAoDHiTTrKre0BIm5084Bz
         2uUrjwlKLDKQfjKh0PiU6saPn9n6a6Q4NP2pmLasHwjANv12P81kYcsAC4z16UzGSG
         mObTMDDiakI3K4apUROthiaWw/6Fr4G6ZAkHKnak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
        Hao Luo <haoluo@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 027/155] bpf: Tidy up verifier check_func_arg()
Date:   Tue,  6 Sep 2022 15:29:35 +0200
Message-Id: <20220906132830.573659332@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit 8ab4cdcf03d0b060fbf73f76460f199bbd759ff7 ]

This patch does two things:

1. For matching against the arg type, the match should be against the
base type of the arg type, since the arg type can have different
bpf_type_flags set on it.

2. Uses switch casing to improve readability + efficiency.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Acked-by: Hao Luo <haoluo@google.com>
Link: https://lore.kernel.org/r/20220712210603.123791-1-joannelkoong@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 66 +++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 28 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f0dd73bf69ddf..20df58c351abf 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5533,17 +5533,6 @@ static bool arg_type_is_mem_size(enum bpf_arg_type type)
 	       type == ARG_CONST_SIZE_OR_ZERO;
 }
 
-static bool arg_type_is_alloc_size(enum bpf_arg_type type)
-{
-	return type == ARG_CONST_ALLOC_SIZE_OR_ZERO;
-}
-
-static bool arg_type_is_int_ptr(enum bpf_arg_type type)
-{
-	return type == ARG_PTR_TO_INT ||
-	       type == ARG_PTR_TO_LONG;
-}
-
 static bool arg_type_is_release(enum bpf_arg_type type)
 {
 	return type & OBJ_RELEASE;
@@ -5929,7 +5918,8 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		meta->ref_obj_id = reg->ref_obj_id;
 	}
 
-	if (arg_type == ARG_CONST_MAP_PTR) {
+	switch (base_type(arg_type)) {
+	case ARG_CONST_MAP_PTR:
 		/* bpf_map_xxx(map_ptr) call: remember that map_ptr */
 		if (meta->map_ptr) {
 			/* Use map_uid (which is unique id of inner map) to reject:
@@ -5954,7 +5944,8 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		}
 		meta->map_ptr = reg->map_ptr;
 		meta->map_uid = reg->map_uid;
-	} else if (arg_type == ARG_PTR_TO_MAP_KEY) {
+		break;
+	case ARG_PTR_TO_MAP_KEY:
 		/* bpf_map_xxx(..., map_ptr, ..., key) call:
 		 * check that [key, key + map->key_size) are within
 		 * stack limits and initialized
@@ -5971,7 +5962,8 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		err = check_helper_mem_access(env, regno,
 					      meta->map_ptr->key_size, false,
 					      NULL);
-	} else if (base_type(arg_type) == ARG_PTR_TO_MAP_VALUE) {
+		break;
+	case ARG_PTR_TO_MAP_VALUE:
 		if (type_may_be_null(arg_type) && register_is_null(reg))
 			return 0;
 
@@ -5987,14 +5979,16 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		err = check_helper_mem_access(env, regno,
 					      meta->map_ptr->value_size, false,
 					      meta);
-	} else if (arg_type == ARG_PTR_TO_PERCPU_BTF_ID) {
+		break;
+	case ARG_PTR_TO_PERCPU_BTF_ID:
 		if (!reg->btf_id) {
 			verbose(env, "Helper has invalid btf_id in R%d\n", regno);
 			return -EACCES;
 		}
 		meta->ret_btf = reg->btf;
 		meta->ret_btf_id = reg->btf_id;
-	} else if (arg_type == ARG_PTR_TO_SPIN_LOCK) {
+		break;
+	case ARG_PTR_TO_SPIN_LOCK:
 		if (meta->func_id == BPF_FUNC_spin_lock) {
 			if (process_spin_lock(env, regno, true))
 				return -EACCES;
@@ -6005,12 +5999,15 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			verbose(env, "verifier internal error\n");
 			return -EFAULT;
 		}
-	} else if (arg_type == ARG_PTR_TO_TIMER) {
+		break;
+	case ARG_PTR_TO_TIMER:
 		if (process_timer_func(env, regno, meta))
 			return -EACCES;
-	} else if (arg_type == ARG_PTR_TO_FUNC) {
+		break;
+	case ARG_PTR_TO_FUNC:
 		meta->subprogno = reg->subprogno;
-	} else if (base_type(arg_type) == ARG_PTR_TO_MEM) {
+		break;
+	case ARG_PTR_TO_MEM:
 		/* The access to this pointer is only checked when we hit the
 		 * next is_mem_size argument below.
 		 */
@@ -6020,11 +6017,14 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 						      fn->arg_size[arg], false,
 						      meta);
 		}
-	} else if (arg_type_is_mem_size(arg_type)) {
-		bool zero_size_allowed = (arg_type == ARG_CONST_SIZE_OR_ZERO);
-
-		err = check_mem_size_reg(env, reg, regno, zero_size_allowed, meta);
-	} else if (arg_type_is_dynptr(arg_type)) {
+		break;
+	case ARG_CONST_SIZE:
+		err = check_mem_size_reg(env, reg, regno, false, meta);
+		break;
+	case ARG_CONST_SIZE_OR_ZERO:
+		err = check_mem_size_reg(env, reg, regno, true, meta);
+		break;
+	case ARG_PTR_TO_DYNPTR:
 		if (arg_type & MEM_UNINIT) {
 			if (!is_dynptr_reg_valid_uninit(env, reg)) {
 				verbose(env, "Dynptr has to be an uninitialized dynptr\n");
@@ -6058,21 +6058,28 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 				err_extra, arg + 1);
 			return -EINVAL;
 		}
-	} else if (arg_type_is_alloc_size(arg_type)) {
+		break;
+	case ARG_CONST_ALLOC_SIZE_OR_ZERO:
 		if (!tnum_is_const(reg->var_off)) {
 			verbose(env, "R%d is not a known constant'\n",
 				regno);
 			return -EACCES;
 		}
 		meta->mem_size = reg->var_off.value;
-	} else if (arg_type_is_int_ptr(arg_type)) {
+		break;
+	case ARG_PTR_TO_INT:
+	case ARG_PTR_TO_LONG:
+	{
 		int size = int_ptr_type_to_size(arg_type);
 
 		err = check_helper_mem_access(env, regno, size, false, meta);
 		if (err)
 			return err;
 		err = check_ptr_alignment(env, reg, 0, size, true);
-	} else if (arg_type == ARG_PTR_TO_CONST_STR) {
+		break;
+	}
+	case ARG_PTR_TO_CONST_STR:
+	{
 		struct bpf_map *map = reg->map_ptr;
 		int map_off;
 		u64 map_addr;
@@ -6111,9 +6118,12 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			verbose(env, "string is not zero-terminated\n");
 			return -EINVAL;
 		}
-	} else if (arg_type == ARG_PTR_TO_KPTR) {
+		break;
+	}
+	case ARG_PTR_TO_KPTR:
 		if (process_kptr_func(env, regno, meta))
 			return -EACCES;
+		break;
 	}
 
 	return err;
-- 
2.35.1



