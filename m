Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D43513F4F
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 02:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353508AbiD2ACr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 20:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353486AbiD2ACo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 20:02:44 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763B0A146B
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:28 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2f7c011e3e9so60978867b3.23
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=U6P8YG40YYE5sCtfgW9ipxvV/Qx7mnfFtQYWKimccYg=;
        b=B2p+TZ6ZG9GxyjusT87pOwB5Rv+YTa6ahu8gBBEyoMEZd/aZ6qICPfIWpp4VvUTq54
         DWtm5YeZeDDGdT6YNj6L3w/2zp6Fl3GUKR+rtgpwIWXOuLHJT4Iqw/RE5lsBmZPCqHzy
         lvf0rGKcsVQfxCE9W6UMEF2UGm2UPbY4SccnHKtCjBOaKjhj+jpHglnKOyQycHPV078z
         4gFN7SJjf1Ao1j2Y9MVdm1LrjIc6B6ff8rM5o25A2ZQfijWyConTpGMEDkdmRxvMUwkm
         Qe5A5MiVpqT0dj/++2NMB05n2k5SBvhdOg+BvxRzcH7J2wUFT/iOjHKOWfbg0/lLcsAd
         WKbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=U6P8YG40YYE5sCtfgW9ipxvV/Qx7mnfFtQYWKimccYg=;
        b=HwLElEnhZgNASkOSOgbFZqjuXf0vaXF0XGftHXLS5n0iVOGSIXmpxJdiyA+3CMoiUU
         yNvGdTyCbKJNLHe8H9tDZ5w9FKIJwP8Ef6UpRIAdL7RXRq9gg5DODYTa0TwrHj8cVkBq
         g/RS7BVEWoLVGTe9TgvJva7s1HGkyreuXpqZ6IxyxaK/tHlicjC1yN5uR1wfKfz0Z8+H
         ITAKDAH9hA03l4/ZV1/gAyW2vnrgxn/M8vS4uA2pDjJAZ510OjfEB8UX78Qr/Fs28wMw
         p62+lyCYCPA7HtYHFbIBjdMfFnGpkTx/KT07jYt0Fwe/LcrmJjwuXva/tH7T4Rj+lJj+
         ILGw==
X-Gm-Message-State: AOAM530s7si9M0G3+JVYzU0mynmN3WnF9kkypUUJEZRd+qqlUpchC2cu
        ie5DMxQ0tO4eP/Zrj41iI7k5X6zCYEM=
X-Google-Smtp-Source: ABdhPJxcweIOo/lFlAHsZMHQTHGHfbLbCQoCGGpzqg+ptA3Au6treuiJCyHLWK8kClMjccctW9tDMdmqi5Q=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:25cd:1665:36bc:f38e])
 (user=haoluo job=sendgmr) by 2002:a25:595:0:b0:648:dd02:7e51 with SMTP id
 143-20020a250595000000b00648dd027e51mr9456645ybf.486.1651190367740; Thu, 28
 Apr 2022 16:59:27 -0700 (PDT)
Date:   Thu, 28 Apr 2022 16:57:47 -0700
In-Reply-To: <20220428235751.103203-1-haoluo@google.com>
Message-Id: <20220428235751.103203-7-haoluo@google.com>
Mime-Version: 1.0
References: <20220428235751.103203-1-haoluo@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH stable linux-5.15.y 06/10] bpf: Convert PTR_TO_MEM_OR_NULL to
 composable types.
From:   Hao Luo <haoluo@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, laura@labbott.name,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit cf9f2f8d62eca810afbd1ee6cc0800202b000e57 upstream.

Remove PTR_TO_MEM_OR_NULL and replace it with PTR_TO_MEM combined with
flag PTR_MAYBE_NULL.

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211217003152.48334-7-haoluo@google.com
Cc: stable@vger.kernel.org # 5.15.x
---
 include/linux/bpf.h   | 1 -
 kernel/bpf/btf.c      | 2 +-
 kernel/bpf/verifier.c | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 83c28c683b6d..1cb5aae0fcb6 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -502,7 +502,6 @@ enum bpf_reg_type {
 	PTR_TO_SOCK_COMMON_OR_NULL	= PTR_MAYBE_NULL | PTR_TO_SOCK_COMMON,
 	PTR_TO_TCP_SOCK_OR_NULL		= PTR_MAYBE_NULL | PTR_TO_TCP_SOCK,
 	PTR_TO_BTF_ID_OR_NULL		= PTR_MAYBE_NULL | PTR_TO_BTF_ID,
-	PTR_TO_MEM_OR_NULL		= PTR_MAYBE_NULL | PTR_TO_MEM,
 
 	/* This must be the last entry. Its purpose is to ensure the enum is
 	 * wide enough to hold the higher bits reserved for bpf_type_flag.
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 9247dfcde054..c2ecea3c16e0 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5719,7 +5719,7 @@ int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 				return -EINVAL;
 			}
 
-			reg->type = PTR_TO_MEM_OR_NULL;
+			reg->type = PTR_TO_MEM | PTR_MAYBE_NULL;
 			reg->id = ++env->id_gen;
 
 			continue;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0de4a9458bf7..0aff2e4976d6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13135,7 +13135,7 @@ static int do_check_common(struct bpf_verifier_env *env, int subprog)
 				mark_reg_known_zero(env, regs, i);
 			else if (regs[i].type == SCALAR_VALUE)
 				mark_reg_unknown(env, regs, i);
-			else if (regs[i].type == PTR_TO_MEM_OR_NULL) {
+			else if (base_type(regs[i].type) == PTR_TO_MEM) {
 				const u32 mem_size = regs[i].mem_size;
 
 				mark_reg_known_zero(env, regs, i);
-- 
2.36.0.464.gb9c8b46e94-goog

