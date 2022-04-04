Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159554F12B5
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 12:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355357AbiDDKLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 06:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356019AbiDDKLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 06:11:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA7725280
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 03:09:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BDBE614D4
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 10:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B93C2BBE4;
        Mon,  4 Apr 2022 10:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649066944;
        bh=q61+sBBkwSgpvToCRD+Ogc6l1oEeZA6VoVmhlBWHK8A=;
        h=Subject:To:Cc:From:Date:From;
        b=tv3EakPhwlpMG7iI8sFN6Cqmh2rTrbiKWMGzx1/WrHq58C1UyrKgcIOe44oI18gCx
         3E/pkfyQUuvnkwUaYQYgHKlpkcAAKFWWh6f1er8LE46OGIu0X4Sklp5FmZkzXVV8gm
         gaOMDc7uCF1cP/S69au9H96mEYFc+AYbfYJ2ntxs=
Subject: FAILED: patch "[PATCH] bpf: Fix PTR_TO_BTF_ID var_off check" failed to apply to 5.15-stable tree
To:     memxor@gmail.com, ast@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Apr 2022 12:08:58 +0200
Message-ID: <1649066938155193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 655efe5089f077485eec848272bd7e26b1a5a735 Mon Sep 17 00:00:00 2001
From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date: Sat, 5 Mar 2022 04:16:39 +0530
Subject: [PATCH] bpf: Fix PTR_TO_BTF_ID var_off check

When kfunc support was added, check_ctx_reg was called for PTR_TO_CTX
register, but no offset checks were made for PTR_TO_BTF_ID. Only
reg->off was taken into account by btf_struct_ids_match, which protected
against type mismatch due to non-zero reg->off, but when reg->off was
zero, a user could set the variable offset of the register and allow it
to be passed to kfunc, leading to bad pointer being passed into the
kernel.

Fix this by reusing the extracted helper check_func_arg_reg_off from
previous commit, and make one call before checking all supported
register types. Since the list is maintained, any future changes will be
taken into account by updating check_func_arg_reg_off. This function
prevents non-zero var_off to be set for PTR_TO_BTF_ID, but still allows
a fixed non-zero reg->off, which is needed for type matching to work
correctly when using pointer arithmetic.

ARG_DONTCARE is passed as arg_type, since kfunc doesn't support
accepting a ARG_PTR_TO_ALLOC_MEM without relying on size of parameter
type from BTF (in case of pointer), or using a mem, len pair. The
forcing of offset check for ARG_PTR_TO_ALLOC_MEM is done because ringbuf
helpers obtain the size from the header located at the beginning of the
memory region, hence any changes to the original pointer shouldn't be
allowed. In case of kfunc, size is always known, either at verification
time, or using the length parameter, hence this forcing is not required.

Since this check will happen once already for PTR_TO_CTX, remove the
check_ptr_off_reg call inside its block.

Fixes: e6ac2450d6de ("bpf: Support bpf program calling kernel function")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220304224645.3677453-3-memxor@gmail.com

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index b472cf0c8fdb..7f6a0ae5028b 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5726,7 +5726,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 	const char *func_name, *ref_tname;
 	const struct btf_type *t, *ref_t;
 	const struct btf_param *args;
-	int ref_regno = 0;
+	int ref_regno = 0, ret;
 	bool rel = false;
 
 	t = btf_type_by_id(btf, func_id);
@@ -5776,6 +5776,11 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 
 		ref_t = btf_type_skip_modifiers(btf, t->type, &ref_id);
 		ref_tname = btf_name_by_offset(btf, ref_t->name_off);
+
+		ret = check_func_arg_reg_off(env, reg, regno, ARG_DONTCARE);
+		if (ret < 0)
+			return ret;
+
 		if (btf_get_prog_ctx_type(log, btf, t,
 					  env->prog->type, i)) {
 			/* If function expects ctx type in BTF check that caller
@@ -5787,8 +5792,6 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 					i, btf_type_str(t));
 				return -EINVAL;
 			}
-			if (check_ptr_off_reg(env, reg, regno))
-				return -EINVAL;
 		} else if (is_kfunc && (reg->type == PTR_TO_BTF_ID ||
 			   (reg2btf_ids[base_type(reg->type)] && !type_flag(reg->type)))) {
 			const struct btf_type *reg_ref_t;

