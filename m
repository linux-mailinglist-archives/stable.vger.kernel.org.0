Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89C84C7688
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236723AbiB1SFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240764AbiB1SEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:04:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45602BB04;
        Mon, 28 Feb 2022 09:47:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B95FB810DB;
        Mon, 28 Feb 2022 17:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E918C340E7;
        Mon, 28 Feb 2022 17:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070442;
        bh=F9gJERXBsZJBDheWrV6kP9fWLD21CujIcydQ8FHt2JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZNoTszv2P3XXCVV1P3npjjjWP3l84Tr5c/e2SB93wDo8/EXeiD43x4Fkn8W+yhzT
         6mFguFOF3wXzZldPkM+HJ9E9o2WCGdrqLww2Lgu17Z3YefkpnnDCq0luoBIfmILvwx
         kON3LyqgU4GvDzIPWd6g+ePA1M3orWi0qkjAXTJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 111/164] bpf: Fix crash due to out of bounds access into reg2btf_ids.
Date:   Mon, 28 Feb 2022 18:24:33 +0100
Message-Id: <20220228172410.347859308@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 45ce4b4f9009102cd9f581196d480a59208690c1 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 1621f9d45fbda..c9da250fee38c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5676,7 +5676,8 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			}
 			if (check_ctx_reg(env, reg, regno))
 				return -EINVAL;
-		} else if (is_kfunc && (reg->type == PTR_TO_BTF_ID || reg2btf_ids[reg->type])) {
+		} else if (is_kfunc && (reg->type == PTR_TO_BTF_ID ||
+			   (reg2btf_ids[base_type(reg->type)] && !type_flag(reg->type)))) {
 			const struct btf_type *reg_ref_t;
 			const struct btf *reg_btf;
 			const char *reg_ref_tname;
@@ -5694,7 +5695,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				reg_ref_id = reg->btf_id;
 			} else {
 				reg_btf = btf_vmlinux;
-				reg_ref_id = *reg2btf_ids[reg->type];
+				reg_ref_id = *reg2btf_ids[base_type(reg->type)];
 			}
 
 			reg_ref_t = btf_type_skip_modifiers(reg_btf, reg_ref_id,
-- 
2.34.1



