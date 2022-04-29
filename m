Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50AD35146FF
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357909AbiD2Kql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245509AbiD2KqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:46:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63437C749C;
        Fri, 29 Apr 2022 03:42:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01CD862325;
        Fri, 29 Apr 2022 10:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82ADC385A4;
        Fri, 29 Apr 2022 10:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228955;
        bh=OEBy9BIJsvJj8QlMo6Gd+ZfXJ26Uwm0qSRRilNBekfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpEHM6Ekg66RxowrLo8kxZJXWHyl4OeowUp/AFoRkbDf7dpxuw5atiJ/bYtFvMGzy
         Uzlxhpp1wahM4Lv7kYshlJX6hk8yCJYs1iZm1nxb7+lGxAQAvBOz2oxAiFI2/ISavX
         FvthfY02940hAhtz6iMkSGEGVpLlk/vkwoN6lOOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Hao Luo <haoluo@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 11/33] bpf: Fix crash due to out of bounds access into reg2btf_ids.
Date:   Fri, 29 Apr 2022 12:41:58 +0200
Message-Id: <20220429104052.672989921@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

commit 45ce4b4f9009102cd9f581196d480a59208690c1 upstream

When commit e6ac2450d6de ("bpf: Support bpf program calling kernel function") added
kfunc support, it defined reg2btf_ids as a cheap way to translate the verifier
reg type to the appropriate btf_vmlinux BTF ID, however
commit c25b2ae13603 ("bpf: Replace PTR_TO_XXX_OR_NULL with PTR_TO_XXX | PTR_MAYBE_NULL")
moved the __BPF_REG_TYPE_MAX from the last member of bpf_reg_type enum to after
the base register types, and defined other variants using type flag
composition. However, now, the direct usage of reg->type to index into
reg2btf_ids may no longer fall into __BPF_REG_TYPE_MAX range, and hence lead to
out of bounds access and kernel crash on dereference of bad pointer.

[backport note: commit 3363bd0cfbb80 ("bpf: Extend kfunc with PTR_TO_CTX, PTR_TO_MEM
 argument support") was introduced after 5.15 and contains an out of bound
 reg2btf_ids access. Since that commit hasn't been backported, this patch
 doesn't include fix to that access. If we backport that commit in future,
 we need to fix its faulting access as well.]

Fixes: c25b2ae13603 ("bpf: Replace PTR_TO_XXX_OR_NULL with PTR_TO_XXX | PTR_MAYBE_NULL")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220216201943.624869-1-memxor@gmail.com
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/btf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5510,9 +5510,9 @@ static int btf_check_func_arg_match(stru
 			if (reg->type == PTR_TO_BTF_ID) {
 				reg_btf = reg->btf;
 				reg_ref_id = reg->btf_id;
-			} else if (reg2btf_ids[reg->type]) {
+			} else if (reg2btf_ids[base_type(reg->type)]) {
 				reg_btf = btf_vmlinux;
-				reg_ref_id = *reg2btf_ids[reg->type];
+				reg_ref_id = *reg2btf_ids[base_type(reg->type)];
 			} else {
 				bpf_log(log, "kernel function %s args#%d expected pointer to %s %s but R%d is not a pointer to btf_id\n",
 					func_name, i,


