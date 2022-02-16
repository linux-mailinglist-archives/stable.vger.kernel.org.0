Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6D74B9418
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 23:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237778AbiBPWwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 17:52:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237745AbiBPWwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 17:52:42 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8675265798
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 14:52:29 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b12-20020a056902030c00b0061d720e274aso7174736ybs.20
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 14:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=69lge+tFhS/MXS3I8fNDRPS5zuSMQcfSzLR+CxESgFY=;
        b=bbg35nLGWAQ3cZwBJUZVuWaVO4YFYKP6RoEykbs0f63FkPUTARTERQgeugHruST2OX
         tbLvTbSMD7t+DkEF7kf58zUpvDf30vIrMbZHD1c7X8zVCWJDqwLVEVUrMmkpRt26ByN8
         Gf2gZsOXAW/h6iFR1bEnU4KNA/217D8Azpy2CL+vYpa97qjqh9rsveyqVweE8rru0IVK
         FnIcn2i9TvBDJtIiGv5DRuz1BhNitSqwTUKwtveb9zdjCpS9JV5nl2hILlI0/IrtV82T
         W8JXd29qIe3Z4xhyHWmt//5VNJbzr/ZocfvS8W+X34Yv9xUQ4mO2hYJsWvWOxCgIZhsZ
         YupQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=69lge+tFhS/MXS3I8fNDRPS5zuSMQcfSzLR+CxESgFY=;
        b=QVPIpzpsEbxe/qlf8yMAEW1nDW+Nmgaev55neHm4alI27ekFPAcii0noF6x56R3Qqx
         ZODvQN6/kJW9klokqrpyUhuA0vLLyT3JHW9g5YmhgnGWZ0d22e+7TJ7w1hWP6fwDc277
         sKaycKvUZ4Ot+IKATTbAsMFHBpFdzW1xcbDTvraQthDmCD1gz1YlwLc8omgC7b//ILNc
         kTLSZzmtzx5jqGZjvWexRU0zbmwnH3rBi/KyNDZd3tmTpKgE9bdjQCGlGfdPC6wp287/
         AsHxWlfT/nn2Z3Vf5MuKFDrQqEatSpefdlRmQ28SRGrAHZG4i+W7LFNuP7qn6R7GN24W
         PMHQ==
X-Gm-Message-State: AOAM531+C3xb60b3UkzfnDEBH0JYtkcFGB/tf8+/cj49KrGDCfIoZ4zm
        e3b2Ix0UGw/JQeWxdoKpHPY8odtP2ew=
X-Google-Smtp-Source: ABdhPJyuRCElXDQZ9dyLudi1vIQUfgtBEXmQ97nUrnEq9qHUBl1oOdQ/+0ys4alOs/AGA5xbtGMnziXfPvA=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:6674:61c7:b01a:7f98])
 (user=haoluo job=sendgmr) by 2002:a25:42d6:0:b0:61b:3589:a42 with SMTP id
 p205-20020a2542d6000000b0061b35890a42mr103506yba.31.1645051948700; Wed, 16
 Feb 2022 14:52:28 -0800 (PST)
Date:   Wed, 16 Feb 2022 14:52:06 -0800
In-Reply-To: <20220216225209.2196865-1-haoluo@google.com>
Message-Id: <20220216225209.2196865-7-haoluo@google.com>
Mime-Version: 1.0
References: <20220216225209.2196865-1-haoluo@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH stable linux-5.16.y 6/9] bpf: Convert PTR_TO_MEM_OR_NULL to
 composable types.
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

commit cf9f2f8d62eca810afbd1ee6cc0800202b000e57 upstream.

Remove PTR_TO_MEM_OR_NULL and replace it with PTR_TO_MEM combined with
flag PTR_MAYBE_NULL.

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211217003152.48334-7-haoluo@google.com
Cc: stable@vger.kernel.org # 5.16.x
---
 include/linux/bpf.h   | 1 -
 kernel/bpf/btf.c      | 2 +-
 kernel/bpf/verifier.c | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6da8b219e4d7..8cf336bd874e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -506,7 +506,6 @@ enum bpf_reg_type {
 	PTR_TO_SOCK_COMMON_OR_NULL	= PTR_MAYBE_NULL | PTR_TO_SOCK_COMMON,
 	PTR_TO_TCP_SOCK_OR_NULL		= PTR_MAYBE_NULL | PTR_TO_TCP_SOCK,
 	PTR_TO_BTF_ID_OR_NULL		= PTR_MAYBE_NULL | PTR_TO_BTF_ID,
-	PTR_TO_MEM_OR_NULL		= PTR_MAYBE_NULL | PTR_TO_MEM,
 
 	/* This must be the last entry. Its purpose is to ensure the enum is
 	 * wide enough to hold the higher bits reserved for bpf_type_flag.
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 39e77aa763a9..cbee90bcc66d 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5847,7 +5847,7 @@ int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 				return -EINVAL;
 			}
 
-			reg->type = PTR_TO_MEM_OR_NULL;
+			reg->type = PTR_TO_MEM | PTR_MAYBE_NULL;
 			reg->id = ++env->id_gen;
 
 			continue;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 989ee0247161..45094975cf05 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13336,7 +13336,7 @@ static int do_check_common(struct bpf_verifier_env *env, int subprog)
 				mark_reg_known_zero(env, regs, i);
 			else if (regs[i].type == SCALAR_VALUE)
 				mark_reg_unknown(env, regs, i);
-			else if (regs[i].type == PTR_TO_MEM_OR_NULL) {
+			else if (base_type(regs[i].type) == PTR_TO_MEM) {
 				const u32 mem_size = regs[i].mem_size;
 
 				mark_reg_known_zero(env, regs, i);
-- 
2.35.1.265.g69c8d7142f-goog

