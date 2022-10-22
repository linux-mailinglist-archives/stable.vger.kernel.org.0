Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2A86086DA
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbiJVHxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbiJVHwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:52:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0472C5010;
        Sat, 22 Oct 2022 00:46:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5654960B0C;
        Sat, 22 Oct 2022 07:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4D2C433C1;
        Sat, 22 Oct 2022 07:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424673;
        bh=Kqj41S+V63UtDdNsvtO1ZA3eW/sA9t6K52qQFyV2Jps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NaVKzwL0oaxpFu0b5uglzE+1a912Nxar8UdIFSzWEl0usgxHRvGW7OLf2EWSSktYZ
         nJjCddBe0+zmNnIpE5BfbpUI7vgau00AoMERVL1yELqPRzgGm8cQE91JZ3l2Isx8RQ
         j0aGnlDnqfeED0P1q8PNo15Otj9X2LzwbdR3Cc3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Marchevsky <davemarchevsky@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 204/717] bpf: Cleanup check_refcount_ok
Date:   Sat, 22 Oct 2022 09:21:23 +0200
Message-Id: <20221022072451.465748454@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Marchevsky <davemarchevsky@fb.com>

[ Upstream commit b2d8ef19c6e7ed71ba5092feb0710063a751834f ]

Discussion around a recently-submitted patch provided historical
context for check_refcount_ok [0]. Specifically, the function and its
helpers - may_be_acquire_function and arg_type_may_be_refcounted -
predate the OBJ_RELEASE type flag and the addition of many more helpers
with acquire/release semantics.

The purpose of check_refcount_ok is to ensure:
  1) Helper doesn't have multiple uses of return reg's ref_obj_id
  2) Helper with release semantics only has one arg needing to be
  released, since that's tracked using meta->ref_obj_id

With current verifier, it's safe to remove check_refcount_ok and its
helpers. Since addition of OBJ_RELEASE type flag, case 2) has been
handled by the arg_type_is_release check in check_func_arg. To ensure
case 1) won't result in verifier silently prioritizing one use of
ref_obj_id, this patch adds a helper_multiple_ref_obj_use check which
fails loudly if a helper passes > 1 test for use of ref_obj_id.

  [0]: lore.kernel.org/bpf/20220713234529.4154673-1-davemarchevsky@fb.com

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: Joanne Koong <joannelkoong@gmail.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20220808171559.3251090-1-davemarchevsky@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 883743422ced ("bpf: Fix ref_obj_id for dynptr data slices in verifier")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 74 +++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 45 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 339147061127..210793b5cd6c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -467,25 +467,11 @@ static bool type_is_rdonly_mem(u32 type)
 	return type & MEM_RDONLY;
 }
 
-static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
-{
-	return type == ARG_PTR_TO_SOCK_COMMON;
-}
-
 static bool type_may_be_null(u32 type)
 {
 	return type & PTR_MAYBE_NULL;
 }
 
-static bool may_be_acquire_function(enum bpf_func_id func_id)
-{
-	return func_id == BPF_FUNC_sk_lookup_tcp ||
-		func_id == BPF_FUNC_sk_lookup_udp ||
-		func_id == BPF_FUNC_skc_lookup_tcp ||
-		func_id == BPF_FUNC_map_lookup_elem ||
-	        func_id == BPF_FUNC_ringbuf_reserve;
-}
-
 static bool is_acquire_function(enum bpf_func_id func_id,
 				const struct bpf_map *map)
 {
@@ -518,6 +504,26 @@ static bool is_ptr_cast_function(enum bpf_func_id func_id)
 		func_id == BPF_FUNC_skc_to_tcp_request_sock;
 }
 
+static bool is_dynptr_acquire_function(enum bpf_func_id func_id)
+{
+	return func_id == BPF_FUNC_dynptr_data;
+}
+
+static bool helper_multiple_ref_obj_use(enum bpf_func_id func_id,
+					const struct bpf_map *map)
+{
+	int ref_obj_uses = 0;
+
+	if (is_ptr_cast_function(func_id))
+		ref_obj_uses++;
+	if (is_acquire_function(func_id, map))
+		ref_obj_uses++;
+	if (is_dynptr_acquire_function(func_id))
+		ref_obj_uses++;
+
+	return ref_obj_uses > 1;
+}
+
 static bool is_cmpxchg_insn(const struct bpf_insn *insn)
 {
 	return BPF_CLASS(insn->code) == BPF_STX &&
@@ -6456,33 +6462,6 @@ static bool check_arg_pair_ok(const struct bpf_func_proto *fn)
 	return true;
 }
 
-static bool check_refcount_ok(const struct bpf_func_proto *fn, int func_id)
-{
-	int count = 0;
-
-	if (arg_type_may_be_refcounted(fn->arg1_type))
-		count++;
-	if (arg_type_may_be_refcounted(fn->arg2_type))
-		count++;
-	if (arg_type_may_be_refcounted(fn->arg3_type))
-		count++;
-	if (arg_type_may_be_refcounted(fn->arg4_type))
-		count++;
-	if (arg_type_may_be_refcounted(fn->arg5_type))
-		count++;
-
-	/* A reference acquiring function cannot acquire
-	 * another refcounted ptr.
-	 */
-	if (may_be_acquire_function(func_id) && count)
-		return false;
-
-	/* We only support one arg being unreferenced at the moment,
-	 * which is sufficient for the helper functions we have right now.
-	 */
-	return count <= 1;
-}
-
 static bool check_btf_id_ok(const struct bpf_func_proto *fn)
 {
 	int i;
@@ -6506,8 +6485,7 @@ static int check_func_proto(const struct bpf_func_proto *fn, int func_id,
 {
 	return check_raw_mode_ok(fn) &&
 	       check_arg_pair_ok(fn) &&
-	       check_btf_id_ok(fn) &&
-	       check_refcount_ok(fn, func_id) ? 0 : -EINVAL;
+	       check_btf_id_ok(fn) ? 0 : -EINVAL;
 }
 
 /* Packet data might have moved, any old PTR_TO_PACKET[_META,_END]
@@ -7410,6 +7388,12 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 	if (type_may_be_null(regs[BPF_REG_0].type))
 		regs[BPF_REG_0].id = ++env->id_gen;
 
+	if (helper_multiple_ref_obj_use(func_id, meta.map_ptr)) {
+		verbose(env, "verifier internal error: func %s#%d sets ref_obj_id more than once\n",
+			func_id_name(func_id), func_id);
+		return -EFAULT;
+	}
+
 	if (is_ptr_cast_function(func_id)) {
 		/* For release_reference() */
 		regs[BPF_REG_0].ref_obj_id = meta.ref_obj_id;
@@ -7422,10 +7406,10 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		regs[BPF_REG_0].id = id;
 		/* For release_reference() */
 		regs[BPF_REG_0].ref_obj_id = id;
-	} else if (func_id == BPF_FUNC_dynptr_data) {
+	} else if (is_dynptr_acquire_function(func_id)) {
 		int dynptr_id = 0, i;
 
-		/* Find the id of the dynptr we're acquiring a reference to */
+		/* Find the id of the dynptr we're tracking the reference of */
 		for (i = 0; i < MAX_BPF_FUNC_REG_ARGS; i++) {
 			if (arg_type_is_dynptr(fn->arg_type[i])) {
 				if (dynptr_id) {
-- 
2.35.1



