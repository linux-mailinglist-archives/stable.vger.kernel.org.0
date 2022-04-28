Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2285D513F52
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 02:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353503AbiD2AC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 20:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353504AbiD2ACz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 20:02:55 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48379B3DF6
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a17-20020a258051000000b00648703d0c56so5964901ybn.22
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=M25q6OwIcD94di3lP1WbYTf9phlWxFQdOt2FIKZZ4S0=;
        b=eoddl0Uo913QFGuY/NyJkPs/PN9AQKxSS+thxWf00rPcgY0To75Pj1rvdh+DHwM/Ic
         uYZhLqiW0imzItbEVN8kaUNCRvGLZL5nz4Te4CXItEI14lpEWt4IbgLl4S7I7MWKVboZ
         NdfPlMsESCY4W94hmIa/no5cLRouCvl/JIh881ZLPIKzzq9RfENkSGUf5wAFeWeURe+z
         9csDntCDjrr+iBlLAn4MBdAQcCGL9o/+IK6woYvr6DAIVPL7a14UgEZS/SQhCyWDbf/A
         HSfgfmBqQ87mGQqwadLO9UczOSyTriLtLTMMUjRLkgF2/RbH55t/tBm4/y6jvCYYRQWC
         kM9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=M25q6OwIcD94di3lP1WbYTf9phlWxFQdOt2FIKZZ4S0=;
        b=ORCmLiCLuq5bhM3zr5pEcfLHXdCPVfOUT80gwN3vFe9tk1MAWp/j4zDMHVezUKl5+o
         JBOJ3wSKJUv7xjm+KyuC3wXuIruUIhmSIT8NlQiAI77+3IpszZLyooAvg5z7ZAroLqHP
         8gDvEAjEFI0qDtz44a7Pee16nkzq9bb/rLHKimuMTbF7jdEHfuaAFs3qrtT4V6fftnzr
         4y8mL8TQVcaXAhce/mpCde4Dejlr07N56zhk65/IsfdffGaQ8Rp6P3S6a8MP8d0y+zby
         6uJWOu/iYT6lKnq5InN3P19L0v2UhcQtZBFC+5k6uN2dGBIlv5E0IV7RSbhm+9aFvquR
         jc0g==
X-Gm-Message-State: AOAM533kvHEYpXG3SclRyyxS46SxmsdJmVCnjsLO6zg1F+BTuzcwVfRF
        ytx3qMlA+EgLhdNm/a1H8fWyt4Lcl/w=
X-Google-Smtp-Source: ABdhPJwPcPBvfh/xU9F2YV50sRqZlzLDkFbgJVyZblKn3OPl11qYccAxXmalcA+yX+BSRzLKohyXSj2MJPk=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:25cd:1665:36bc:f38e])
 (user=haoluo job=sendgmr) by 2002:a25:2a52:0:b0:648:f7b4:7cb8 with SMTP id
 q79-20020a252a52000000b00648f7b47cb8mr5248177ybq.431.1651190377533; Thu, 28
 Apr 2022 16:59:37 -0700 (PDT)
Date:   Thu, 28 Apr 2022 16:57:51 -0700
In-Reply-To: <20220428235751.103203-1-haoluo@google.com>
Message-Id: <20220428235751.103203-11-haoluo@google.com>
Mime-Version: 1.0
References: <20220428235751.103203-1-haoluo@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH stable linux-5.15.y 10/10] bpf: Fix crash due to out of bounds
 access into reg2btf_ids.
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
---
 kernel/bpf/btf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index ba471f38bb4d..40df35088cdb 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5510,9 +5510,9 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
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
-- 
2.36.0.464.gb9c8b46e94-goog

