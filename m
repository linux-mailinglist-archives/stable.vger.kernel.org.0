Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12FB04C48D7
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 16:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242070AbiBYP2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242069AbiBYP2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:28:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EC820DB30
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:28:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BE76B8324F
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE980C340E7;
        Fri, 25 Feb 2022 15:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645802891;
        bh=MxmK5+6UPBquD/tkWlUMzTfGpSprOw1BvB27lbVdxzQ=;
        h=Subject:To:Cc:From:Date:From;
        b=SqP+WSKBKCLg/PItdVgKphLw8pDMBDADZXrBpfCkqLVqGuD5pCWtsfCqjz/E8urnx
         lvE376z9NN8EBsDCeRTKXYHHY65D7sJ2q4EgfBWQiJ4fCb3bNRlmoXYjq2oyM3Kz43
         Dgi2xORmKj93Ocb+l2XsEd+H18UYONHdCDHIOpTE=
Subject: FAILED: patch "[PATCH] bpf: Fix crash due to out of bounds access into reg2btf_ids." failed to apply to 5.16-stable tree
To:     memxor@gmail.com, ast@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 16:27:58 +0100
Message-ID: <16458028789591@kroah.com>
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


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 45ce4b4f9009102cd9f581196d480a59208690c1 Mon Sep 17 00:00:00 2001
From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date: Thu, 17 Feb 2022 01:49:43 +0530
Subject: [PATCH] bpf: Fix crash due to out of bounds access into reg2btf_ids.

When commit e6ac2450d6de ("bpf: Support bpf program calling kernel function") added
kfunc support, it defined reg2btf_ids as a cheap way to translate the verifier
reg type to the appropriate btf_vmlinux BTF ID, however
commit c25b2ae13603 ("bpf: Replace PTR_TO_XXX_OR_NULL with PTR_TO_XXX | PTR_MAYBE_NULL")
moved the __BPF_REG_TYPE_MAX from the last member of bpf_reg_type enum to after
the base register types, and defined other variants using type flag
composition. However, now, the direct usage of reg->type to index into
reg2btf_ids may no longer fall into __BPF_REG_TYPE_MAX range, and hence lead to
out of bounds access and kernel crash on dereference of bad pointer.

Fixes: c25b2ae13603 ("bpf: Replace PTR_TO_XXX_OR_NULL with PTR_TO_XXX | PTR_MAYBE_NULL")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220216201943.624869-1-memxor@gmail.com

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index e16dafeb2450..3e23b3fa79ff 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5688,7 +5688,8 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			}
 			if (check_ptr_off_reg(env, reg, regno))
 				return -EINVAL;
-		} else if (is_kfunc && (reg->type == PTR_TO_BTF_ID || reg2btf_ids[reg->type])) {
+		} else if (is_kfunc && (reg->type == PTR_TO_BTF_ID ||
+			   (reg2btf_ids[base_type(reg->type)] && !type_flag(reg->type)))) {
 			const struct btf_type *reg_ref_t;
 			const struct btf *reg_btf;
 			const char *reg_ref_tname;
@@ -5706,7 +5707,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				reg_ref_id = reg->btf_id;
 			} else {
 				reg_btf = btf_vmlinux;
-				reg_ref_id = *reg2btf_ids[reg->type];
+				reg_ref_id = *reg2btf_ids[base_type(reg->type)];
 			}
 
 			reg_ref_t = btf_type_skip_modifiers(reg_btf, reg_ref_id,

