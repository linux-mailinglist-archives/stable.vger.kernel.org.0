Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797245AECB3
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240845AbiIFOAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240726AbiIFN6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:58:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7555682D26;
        Tue,  6 Sep 2022 06:42:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D218CB816A0;
        Tue,  6 Sep 2022 13:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25291C433D6;
        Tue,  6 Sep 2022 13:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471753;
        bh=B8SYJhSjHk6PuBErWMZ4CgVzP1fMKC6HH8rdKZoE6k4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DO7pBnWy80pWW4TQI/+Rhx2T3VQiQp/ta6fKeH+EzxE4bAskQVns/0BsgNhBywq0u
         mbeM0lU15ZuGCAgGtZ9gmRGuK70mPj+pfbrokDswcszLoqcYBuTjvUz6p+foFh3PRc
         7mmNdYr4mtnRMylCpLO58iKq68+mn8CKhTNwJwoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 026/155] bpf: Allow helpers to accept pointers with a fixed size
Date:   Tue,  6 Sep 2022 15:29:34 +0200
Message-Id: <20220906132830.532067705@linuxfoundation.org>
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

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit 508362ac66b0478affb4e52cb8da98478312d72d ]

Before this commit, the BPF verifier required ARG_PTR_TO_MEM arguments
to be followed by ARG_CONST_SIZE holding the size of the memory region.
The helpers had to check that size in runtime.

There are cases where the size expected by a helper is a compile-time
constant. Checking it in runtime is an unnecessary overhead and waste of
BPF registers.

This commit allows helpers to accept pointers to memory without the
corresponding ARG_CONST_SIZE, given that they define the memory region
size in struct bpf_func_proto and use ARG_PTR_TO_FIXED_SIZE_MEM type.

arg_size is unionized with arg_btf_id to reduce the kernel image size,
and it's valid because they are used by different argument types.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20220615134847.3753567-3-maximmi@nvidia.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h   | 13 +++++++++++++
 kernel/bpf/verifier.c | 43 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7424cf234ae03..ed352c00330cd 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -398,6 +398,9 @@ enum bpf_type_flag {
 	/* DYNPTR points to a ringbuf record. */
 	DYNPTR_TYPE_RINGBUF	= BIT(9 + BPF_BASE_TYPE_BITS),
 
+	/* Size is known at compile time. */
+	MEM_FIXED_SIZE		= BIT(10 + BPF_BASE_TYPE_BITS),
+
 	__BPF_TYPE_FLAG_MAX,
 	__BPF_TYPE_LAST_FLAG	= __BPF_TYPE_FLAG_MAX - 1,
 };
@@ -461,6 +464,8 @@ enum bpf_arg_type {
 	 * all bytes or clear them in error case.
 	 */
 	ARG_PTR_TO_UNINIT_MEM		= MEM_UNINIT | ARG_PTR_TO_MEM,
+	/* Pointer to valid memory of size known at compile time. */
+	ARG_PTR_TO_FIXED_SIZE_MEM	= MEM_FIXED_SIZE | ARG_PTR_TO_MEM,
 
 	/* This must be the last entry. Its purpose is to ensure the enum is
 	 * wide enough to hold the higher bits reserved for bpf_type_flag.
@@ -526,6 +531,14 @@ struct bpf_func_proto {
 			u32 *arg5_btf_id;
 		};
 		u32 *arg_btf_id[5];
+		struct {
+			size_t arg1_size;
+			size_t arg2_size;
+			size_t arg3_size;
+			size_t arg4_size;
+			size_t arg5_size;
+		};
+		size_t arg_size[5];
 	};
 	int *ret_btf_id; /* return value btf_id */
 	bool (*allowed)(const struct bpf_prog *prog);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0e45d405f151c..f0dd73bf69ddf 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5847,6 +5847,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
 	enum bpf_arg_type arg_type = fn->arg_type[arg];
 	enum bpf_reg_type type = reg->type;
+	u32 *arg_btf_id = NULL;
 	int err = 0;
 
 	if (arg_type == ARG_DONTCARE)
@@ -5883,7 +5884,11 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		 */
 		goto skip_type_check;
 
-	err = check_reg_type(env, regno, arg_type, fn->arg_btf_id[arg], meta);
+	/* arg_btf_id and arg_size are in a union. */
+	if (base_type(arg_type) == ARG_PTR_TO_BTF_ID)
+		arg_btf_id = fn->arg_btf_id[arg];
+
+	err = check_reg_type(env, regno, arg_type, arg_btf_id, meta);
 	if (err)
 		return err;
 
@@ -6010,6 +6015,11 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		 * next is_mem_size argument below.
 		 */
 		meta->raw_mode = arg_type & MEM_UNINIT;
+		if (arg_type & MEM_FIXED_SIZE) {
+			err = check_helper_mem_access(env, regno,
+						      fn->arg_size[arg], false,
+						      meta);
+		}
 	} else if (arg_type_is_mem_size(arg_type)) {
 		bool zero_size_allowed = (arg_type == ARG_CONST_SIZE_OR_ZERO);
 
@@ -6400,11 +6410,19 @@ static bool check_raw_mode_ok(const struct bpf_func_proto *fn)
 	return count <= 1;
 }
 
-static bool check_args_pair_invalid(enum bpf_arg_type arg_curr,
-				    enum bpf_arg_type arg_next)
+static bool check_args_pair_invalid(const struct bpf_func_proto *fn, int arg)
 {
-	return (base_type(arg_curr) == ARG_PTR_TO_MEM) !=
-		arg_type_is_mem_size(arg_next);
+	bool is_fixed = fn->arg_type[arg] & MEM_FIXED_SIZE;
+	bool has_size = fn->arg_size[arg] != 0;
+	bool is_next_size = false;
+
+	if (arg + 1 < ARRAY_SIZE(fn->arg_type))
+		is_next_size = arg_type_is_mem_size(fn->arg_type[arg + 1]);
+
+	if (base_type(fn->arg_type[arg]) != ARG_PTR_TO_MEM)
+		return is_next_size;
+
+	return has_size == is_next_size || is_next_size == is_fixed;
 }
 
 static bool check_arg_pair_ok(const struct bpf_func_proto *fn)
@@ -6415,11 +6433,11 @@ static bool check_arg_pair_ok(const struct bpf_func_proto *fn)
 	 * helper function specification.
 	 */
 	if (arg_type_is_mem_size(fn->arg1_type) ||
-	    base_type(fn->arg5_type) == ARG_PTR_TO_MEM ||
-	    check_args_pair_invalid(fn->arg1_type, fn->arg2_type) ||
-	    check_args_pair_invalid(fn->arg2_type, fn->arg3_type) ||
-	    check_args_pair_invalid(fn->arg3_type, fn->arg4_type) ||
-	    check_args_pair_invalid(fn->arg4_type, fn->arg5_type))
+	    check_args_pair_invalid(fn, 0) ||
+	    check_args_pair_invalid(fn, 1) ||
+	    check_args_pair_invalid(fn, 2) ||
+	    check_args_pair_invalid(fn, 3) ||
+	    check_args_pair_invalid(fn, 4))
 		return false;
 
 	return true;
@@ -6460,7 +6478,10 @@ static bool check_btf_id_ok(const struct bpf_func_proto *fn)
 		if (base_type(fn->arg_type[i]) == ARG_PTR_TO_BTF_ID && !fn->arg_btf_id[i])
 			return false;
 
-		if (base_type(fn->arg_type[i]) != ARG_PTR_TO_BTF_ID && fn->arg_btf_id[i])
+		if (base_type(fn->arg_type[i]) != ARG_PTR_TO_BTF_ID && fn->arg_btf_id[i] &&
+		    /* arg_btf_id and arg_size are in a union. */
+		    (base_type(fn->arg_type[i]) != ARG_PTR_TO_MEM ||
+		     !(fn->arg_type[i] & MEM_FIXED_SIZE)))
 			return false;
 	}
 
-- 
2.35.1



