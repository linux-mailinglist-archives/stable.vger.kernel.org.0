Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A0A4B941A
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 23:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237745AbiBPWwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 17:52:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237795AbiBPWwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 17:52:45 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DEE45AE7
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 14:52:31 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id k2-20020a25b282000000b00623dea9687dso7249618ybj.4
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 14:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XO0qqz2v41M/C7UsPPEPlhfdrd2LhB0g/uyeESS3ryg=;
        b=Tg9wdtLYofH/c3muQAQXvTuHXGkBG+RjG9aL1XxnwrTmsApWdGt5LMlzsJwRY6hQkA
         eP8EU2E5j64bkJYQglc4Z1nqjYVolk65RLYzSwy6AI5VfqvTroYCHNaRZG5mk995wsCv
         n42XXJpiNI+dIbFAqmcmTouO9crTnnaTIkw7kmuk9pkvlrvyqEigFaGtqUr/64E3eilJ
         hFCt0s1LcKsW2ehHAdZmpAQ6TXEMp1DvNm3xdn9bQJN8llg/q0dFR9fg2x6KREOLUbE0
         LZgoXUUCulCYp+CT7KsRu9hT4Vi2TwxA803AtdF1w5CK6yqskOJnIzmnDUWD8cgycKlV
         XpTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XO0qqz2v41M/C7UsPPEPlhfdrd2LhB0g/uyeESS3ryg=;
        b=HGvBPZzv3Hoi3DKaotYTUrYw4uLdc475DS6aE7zVEuEObeTObgQSKgVg9n1p6vD2g6
         nJnQ/qH+X6+jztYQtRZ+oKepRa5YbihFZRVEZ5jgyeE1GBpugy6aBFUcaH9qbdNDPWEJ
         Hnb7yOczTbafF6x7vu9ltqbPrE8LgpK0MeKDFEc5bi5ZuLy09LVGtpS0A30lwmpbmUxN
         qdvhwcGITt+qCEOrDRJjAjNhE2J47rzHObmDpihdTElnLzM8q51JaqrkcYBqTzZcjfA6
         +JpssS6QDKUEKajpSyww6uh6mdCBDlVejTv+ZDOni6+zmwnNCs+2loU0l0YEiBD6vCa7
         DHZQ==
X-Gm-Message-State: AOAM531vc2SoGyNVvUJDc5TCXXWnf14n/jCOmMpo5Qy0XYhLps+LPjsc
        wMa0adG8VvxRZI9paP+1X6KF1X1Xwfg=
X-Google-Smtp-Source: ABdhPJzcQ6xBSdLfoo0ezKWIUJgZ3Puu036HiSATnwM4HO2mDxuoiHe7I41iTsYHI7XS227rnJQtEDgFUtw=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:6674:61c7:b01a:7f98])
 (user=haoluo job=sendgmr) by 2002:a81:5591:0:b0:2ca:287c:6c8a with SMTP id
 j139-20020a815591000000b002ca287c6c8amr114864ywb.303.1645051951135; Wed, 16
 Feb 2022 14:52:31 -0800 (PST)
Date:   Wed, 16 Feb 2022 14:52:07 -0800
In-Reply-To: <20220216225209.2196865-1-haoluo@google.com>
Message-Id: <20220216225209.2196865-8-haoluo@google.com>
Mime-Version: 1.0
References: <20220216225209.2196865-1-haoluo@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH stable linux-5.16.y 7/9] bpf: Make per_cpu_ptr return rdonly PTR_TO_MEM.
From:   Hao Luo <haoluo@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, laura@labbott.name,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 34d3a78c681e8e7844b43d1a2f4671a04249c821 upstream.

Tag the return type of {per, this}_cpu_ptr with RDONLY_MEM. The
returned value of this pair of helpers is kernel object, which
can not be updated by bpf programs. Previously these two helpers
return PTR_OT_MEM for kernel objects of scalar type, which allows
one to directly modify the memory. Now with RDONLY_MEM tagging,
the verifier will reject programs that write into RDONLY_MEM.

Fixes: 63d9b80dcf2c ("bpf: Introducte bpf_this_cpu_ptr()")
Fixes: eaa6bcb71ef6 ("bpf: Introduce bpf_per_cpu_ptr()")
Fixes: 4976b718c355 ("bpf: Introduce pseudo_btf_id")
Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211217003152.48334-8-haoluo@google.com
Cc: stable@vger.kernel.org # 5.16.x
---
 kernel/bpf/helpers.c  |  4 ++--
 kernel/bpf/verifier.c | 30 ++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index e9c9a59783f4..726a42b9dc22 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -667,7 +667,7 @@ BPF_CALL_2(bpf_per_cpu_ptr, const void *, ptr, u32, cpu)
 const struct bpf_func_proto bpf_per_cpu_ptr_proto = {
 	.func		= bpf_per_cpu_ptr,
 	.gpl_only	= false,
-	.ret_type	= RET_PTR_TO_MEM_OR_BTF_ID | PTR_MAYBE_NULL,
+	.ret_type	= RET_PTR_TO_MEM_OR_BTF_ID | PTR_MAYBE_NULL | MEM_RDONLY,
 	.arg1_type	= ARG_PTR_TO_PERCPU_BTF_ID,
 	.arg2_type	= ARG_ANYTHING,
 };
@@ -680,7 +680,7 @@ BPF_CALL_1(bpf_this_cpu_ptr, const void *, percpu_ptr)
 const struct bpf_func_proto bpf_this_cpu_ptr_proto = {
 	.func		= bpf_this_cpu_ptr,
 	.gpl_only	= false,
-	.ret_type	= RET_PTR_TO_MEM_OR_BTF_ID,
+	.ret_type	= RET_PTR_TO_MEM_OR_BTF_ID | MEM_RDONLY,
 	.arg1_type	= ARG_PTR_TO_PERCPU_BTF_ID,
 };
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 45094975cf05..408412031a5f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4333,15 +4333,30 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 				mark_reg_unknown(env, regs, value_regno);
 			}
 		}
-	} else if (reg->type == PTR_TO_MEM) {
+	} else if (base_type(reg->type) == PTR_TO_MEM) {
+		bool rdonly_mem = type_is_rdonly_mem(reg->type);
+
+		if (type_may_be_null(reg->type)) {
+			verbose(env, "R%d invalid mem access '%s'\n", regno,
+				reg_type_str(env, reg->type));
+			return -EACCES;
+		}
+
+		if (t == BPF_WRITE && rdonly_mem) {
+			verbose(env, "R%d cannot write into %s\n",
+				regno, reg_type_str(env, reg->type));
+			return -EACCES;
+		}
+
 		if (t == BPF_WRITE && value_regno >= 0 &&
 		    is_pointer_value(env, value_regno)) {
 			verbose(env, "R%d leaks addr into mem\n", value_regno);
 			return -EACCES;
 		}
+
 		err = check_mem_region_access(env, regno, off, size,
 					      reg->mem_size, false);
-		if (!err && t == BPF_READ && value_regno >= 0)
+		if (!err && value_regno >= 0 && (t == BPF_READ || rdonly_mem))
 			mark_reg_unknown(env, regs, value_regno);
 	} else if (reg->type == PTR_TO_CTX) {
 		enum bpf_reg_type reg_type = SCALAR_VALUE;
@@ -6550,6 +6565,13 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 			regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
 			regs[BPF_REG_0].mem_size = tsize;
 		} else {
+			/* MEM_RDONLY may be carried from ret_flag, but it
+			 * doesn't apply on PTR_TO_BTF_ID. Fold it, otherwise
+			 * it will confuse the check of PTR_TO_BTF_ID in
+			 * check_mem_access().
+			 */
+			ret_flag &= ~MEM_RDONLY;
+
 			regs[BPF_REG_0].type = PTR_TO_BTF_ID | ret_flag;
 			regs[BPF_REG_0].btf = meta.ret_btf;
 			regs[BPF_REG_0].btf_id = meta.ret_btf_id;
@@ -9362,7 +9384,7 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
 
 	if (insn->src_reg == BPF_PSEUDO_BTF_ID) {
 		dst_reg->type = aux->btf_var.reg_type;
-		switch (dst_reg->type) {
+		switch (base_type(dst_reg->type)) {
 		case PTR_TO_MEM:
 			dst_reg->mem_size = aux->btf_var.mem_size;
 			break;
@@ -11505,7 +11527,7 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 			err = -EINVAL;
 			goto err_put;
 		}
-		aux->btf_var.reg_type = PTR_TO_MEM;
+		aux->btf_var.reg_type = PTR_TO_MEM | MEM_RDONLY;
 		aux->btf_var.mem_size = tsize;
 	} else {
 		aux->btf_var.reg_type = PTR_TO_BTF_ID;
-- 
2.35.1.265.g69c8d7142f-goog

