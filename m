Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C607529BD7F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811090AbgJ0QhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801933AbgJ0PpG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:45:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC29A22265;
        Tue, 27 Oct 2020 15:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813506;
        bh=5F1eCWD7BbEawmelMZIl45LE4geAtpzk5ScacLdqWH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmK/K28OJreTJELfyCQwwBJgFVyZ2jvhWaP41SQFg1E8nhf24ms9BCCBuML0BjGfU
         QQv14HqBwwjXUQWvXwtctKA+3NOcsDbiG2jBcZFw3R0Zl/O0WbE0quenYSobMtjpwM
         SNFhlON3K1HVOZWWEi0oURdKfYblHLicDIhZRTZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 573/757] bpf: Enforce id generation for all may-be-null register type
Date:   Tue, 27 Oct 2020 14:53:43 +0100
Message-Id: <20201027135517.386099894@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>

[ Upstream commit 93c230e3f5bd6e1d2b2759d582fdfe9c2731473b ]

The commit af7ec1383361 ("bpf: Add bpf_skc_to_tcp6_sock() helper")
introduces RET_PTR_TO_BTF_ID_OR_NULL and
the commit eaa6bcb71ef6 ("bpf: Introduce bpf_per_cpu_ptr()")
introduces RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL.
Note that for RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL, the reg0->type
could become PTR_TO_MEM_OR_NULL which is not covered by
BPF_PROBE_MEM.

The BPF_REG_0 will then hold a _OR_NULL pointer type. This _OR_NULL
pointer type requires the bpf program to explicitly do a NULL check first.
After NULL check, the verifier will mark all registers having
the same reg->id as safe to use.  However, the reg->id
is not set for those new _OR_NULL return types.  One of the ways
that may be wrong is, checking NULL for one btf_id typed pointer will
end up validating all other btf_id typed pointers because
all of them have id == 0.  The later tests will exercise
this path.

To fix it and also avoid similar issue in the future, this patch
moves the id generation logic out of each individual RET type
test in check_helper_call().  Instead, it does one
reg_type_may_be_null() test and then do the id generation
if needed.

This patch also adds a WARN_ON_ONCE in mark_ptr_or_null_reg()
to catch future breakage.

The _OR_NULL pointer usage in the bpf_iter_reg.ctx_arg_info is
fine because it just happens that the existing id generation after
check_ctx_access() has covered it.  It is also using the
reg_type_may_be_null() to decide if id generation is needed or not.

Fixes: af7ec1383361 ("bpf: Add bpf_skc_to_tcp6_sock() helper")
Fixes: eaa6bcb71ef6 ("bpf: Introduce bpf_per_cpu_ptr()")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20201019194212.1050855-1-kafai@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5b9d2cf06fc6b..c38ebc9af9468 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4885,24 +4885,19 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 				regs[BPF_REG_0].id = ++env->id_gen;
 		} else {
 			regs[BPF_REG_0].type = PTR_TO_MAP_VALUE_OR_NULL;
-			regs[BPF_REG_0].id = ++env->id_gen;
 		}
 	} else if (fn->ret_type == RET_PTR_TO_SOCKET_OR_NULL) {
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type = PTR_TO_SOCKET_OR_NULL;
-		regs[BPF_REG_0].id = ++env->id_gen;
 	} else if (fn->ret_type == RET_PTR_TO_SOCK_COMMON_OR_NULL) {
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type = PTR_TO_SOCK_COMMON_OR_NULL;
-		regs[BPF_REG_0].id = ++env->id_gen;
 	} else if (fn->ret_type == RET_PTR_TO_TCP_SOCK_OR_NULL) {
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type = PTR_TO_TCP_SOCK_OR_NULL;
-		regs[BPF_REG_0].id = ++env->id_gen;
 	} else if (fn->ret_type == RET_PTR_TO_ALLOC_MEM_OR_NULL) {
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
-		regs[BPF_REG_0].id = ++env->id_gen;
 		regs[BPF_REG_0].mem_size = meta.mem_size;
 	} else if (fn->ret_type == RET_PTR_TO_BTF_ID_OR_NULL) {
 		int ret_btf_id;
@@ -4922,6 +4917,9 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 		return -EINVAL;
 	}
 
+	if (reg_type_may_be_null(regs[BPF_REG_0].type))
+		regs[BPF_REG_0].id = ++env->id_gen;
+
 	if (is_ptr_cast_function(func_id)) {
 		/* For release_reference() */
 		regs[BPF_REG_0].ref_obj_id = meta.ref_obj_id;
@@ -6847,7 +6845,8 @@ static void mark_ptr_or_null_reg(struct bpf_func_state *state,
 				 struct bpf_reg_state *reg, u32 id,
 				 bool is_null)
 {
-	if (reg_type_may_be_null(reg->type) && reg->id == id) {
+	if (reg_type_may_be_null(reg->type) && reg->id == id &&
+	    !WARN_ON_ONCE(!reg->id)) {
 		/* Old offset (both fixed and variable parts) should
 		 * have been known-zero, because we don't allow pointer
 		 * arithmetic on pointers that might be NULL.
-- 
2.25.1



