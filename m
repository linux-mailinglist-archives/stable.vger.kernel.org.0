Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F507603EC5
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbiJSJUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiJSJTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:19:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6373D3DF10;
        Wed, 19 Oct 2022 02:09:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCFF3617E9;
        Wed, 19 Oct 2022 08:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E940FC433C1;
        Wed, 19 Oct 2022 08:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169413;
        bh=fCYDvPwsLwgEnvhcuZ0ycwDqjRtCNzRwDsH/BtX8qkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbPmEbmI6lasvaZgHCLMB8Qp+xwRaZoBQ8KIeADADdG+vnIiGiSwqXDFX+p41kGVe
         bWMWLGWaqmoVPde3wk3LB5BnQjeUtYIiJdCrD3KbjvH3o+My30DD3tu+Nxe/tjx7Wv
         fLiH+E63nj7fS2EV3Dlltcr316HRrYpVRc8DxaSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
        David Vernet <void@manifault.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 233/862] bpf: Fix ref_obj_id for dynptr data slices in verifier
Date:   Wed, 19 Oct 2022 10:25:20 +0200
Message-Id: <20221019083300.331989794@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit 883743422ced8c961ab05dc63ec81b75a4e56052 ]

When a data slice is obtained from a dynptr (through the bpf_dynptr_data API),
the ref obj id of the dynptr must be found and then associated with the data
slice.

The ref obj id of the dynptr must be found *before* the caller saved regs are
reset. Without this fix, the ref obj id tracking is not correct for
dynptrs that are at an offset from the frame pointer.

Please also note that the data slice's ref obj id must be assigned after the
ret types are parsed, since RET_PTR_TO_ALLOC_MEM-type return regs get
zero-marked.

Fixes: 34d4ef5775f7 ("bpf: Add dynptr data slices")
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Acked-by: David Vernet <void@manifault.com>
Link: https://lore.kernel.org/r/20220809214055.4050604-1-joannelkoong@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1141a35216a7..c127585ad429 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -504,7 +504,7 @@ static bool is_ptr_cast_function(enum bpf_func_id func_id)
 		func_id == BPF_FUNC_skc_to_tcp_request_sock;
 }
 
-static bool is_dynptr_acquire_function(enum bpf_func_id func_id)
+static bool is_dynptr_ref_function(enum bpf_func_id func_id)
 {
 	return func_id == BPF_FUNC_dynptr_data;
 }
@@ -518,7 +518,7 @@ static bool helper_multiple_ref_obj_use(enum bpf_func_id func_id,
 		ref_obj_uses++;
 	if (is_acquire_function(func_id, map))
 		ref_obj_uses++;
-	if (is_dynptr_acquire_function(func_id))
+	if (is_dynptr_ref_function(func_id))
 		ref_obj_uses++;
 
 	return ref_obj_uses > 1;
@@ -7322,6 +7322,23 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 			}
 		}
 		break;
+	case BPF_FUNC_dynptr_data:
+		for (i = 0; i < MAX_BPF_FUNC_REG_ARGS; i++) {
+			if (arg_type_is_dynptr(fn->arg_type[i])) {
+				if (meta.ref_obj_id) {
+					verbose(env, "verifier internal error: meta.ref_obj_id already set\n");
+					return -EFAULT;
+				}
+				/* Find the id of the dynptr we're tracking the reference of */
+				meta.ref_obj_id = stack_slot_get_id(env, &regs[BPF_REG_1 + i]);
+				break;
+			}
+		}
+		if (i == MAX_BPF_FUNC_REG_ARGS) {
+			verbose(env, "verifier internal error: no dynptr in bpf_dynptr_data()\n");
+			return -EFAULT;
+		}
+		break;
 	}
 
 	if (err)
@@ -7444,7 +7461,7 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		return -EFAULT;
 	}
 
-	if (is_ptr_cast_function(func_id)) {
+	if (is_ptr_cast_function(func_id) || is_dynptr_ref_function(func_id)) {
 		/* For release_reference() */
 		regs[BPF_REG_0].ref_obj_id = meta.ref_obj_id;
 	} else if (is_acquire_function(func_id, meta.map_ptr)) {
@@ -7456,21 +7473,6 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		regs[BPF_REG_0].id = id;
 		/* For release_reference() */
 		regs[BPF_REG_0].ref_obj_id = id;
-	} else if (is_dynptr_acquire_function(func_id)) {
-		int dynptr_id = 0, i;
-
-		/* Find the id of the dynptr we're tracking the reference of */
-		for (i = 0; i < MAX_BPF_FUNC_REG_ARGS; i++) {
-			if (arg_type_is_dynptr(fn->arg_type[i])) {
-				if (dynptr_id) {
-					verbose(env, "verifier internal error: multiple dynptr args in func\n");
-					return -EFAULT;
-				}
-				dynptr_id = stack_slot_get_id(env, &regs[BPF_REG_1 + i]);
-			}
-		}
-		/* For release_reference() */
-		regs[BPF_REG_0].ref_obj_id = dynptr_id;
 	}
 
 	do_refine_retval_range(regs, fn->ret_type, func_id, &meta);
-- 
2.35.1



