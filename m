Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112DA4B9411
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 23:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237649AbiBPWwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 17:52:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237766AbiBPWwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 17:52:31 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC6445AE7
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 14:52:17 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 128-20020a251286000000b0062234a636b0so7148297ybs.16
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 14:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6G+1jUA6T8Mw4r4ODWxkakrjC/pbHs5sramwkTIMaWE=;
        b=VqYsUtOaqB8C7tT8yYb4UOb1lLcHpIWpzhuGKZ9bvxivqnWXIgi1MfSeY9C2A9pA4I
         +fybwxVxk7SjNisUXyfoIkJe1IfbJqyykoVBx6PRNNPSIAlhjKHQjhcJQ1m0ySdDrMBP
         o2eRDUFXeOgZLZdjYdlw/dNnUWK7fZLzb1iMshv2YiWTYEvCMhY7mHshf0qMtA36cH8B
         QLv0e2T6NnkDulCjHaiYux08oJRWTSoDT7YceKB0XGHFSTQGLie2fajtI/etHRDBS47J
         igDKypGlHD2wYDB8xVk05hIb5MI2L2QNZCv7/MRynfwSmcAIQrSjp5WAK/dyAvTsHNlW
         aQBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6G+1jUA6T8Mw4r4ODWxkakrjC/pbHs5sramwkTIMaWE=;
        b=Qe4MPcEs2r4vh79c3SyLofiRTxbSXD0ydxhmW79cwrGds9CPwvf/+6tKurfIb7gB5+
         sNHI0VkqK/5VOmwAJT26vs9LejH7SNxDLmntpHPfXmrFQx9KYteKL+V6WbPR4TqHu4NJ
         o7WIKWxT+MyzAPE+Quw6RBBFg0a1mSG4Xhteau+R9Zic2S5zf79CXrcBaQVAf0YkOqk2
         dbi1P9bnLVI/bktyCEnT3UYguJGauMpQqIx0rvmBIJ9AzRZqBoMPDxYRmyRtiAQh2s69
         6rzpXkKP3aqrbT6wsSW8Zk4xyRswybJwQxjxFk8aG7rssl8DvFrI4NXQCfveKH/3jsNp
         C+cA==
X-Gm-Message-State: AOAM530BpfhLLTB8lUTJLPgnPFfiDo4dj7ZH2YbfgPeBk52MwUNmi9Tc
        6RInxCCNNu7xB+BUsk09wTG6PYc3V3Y=
X-Google-Smtp-Source: ABdhPJyqxkq/kY+5+g9TWvFV0AydA6BpO4TDCy+7xb0EGj5J4fNDIWl8u0fE528B5mBApzeKuL2QILFIliQ=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:6674:61c7:b01a:7f98])
 (user=haoluo job=sendgmr) by 2002:a25:b209:0:b0:622:393f:e5f6 with SMTP id
 i9-20020a25b209000000b00622393fe5f6mr105077ybj.145.1645051936655; Wed, 16 Feb
 2022 14:52:16 -0800 (PST)
Date:   Wed, 16 Feb 2022 14:52:01 -0800
In-Reply-To: <20220216225209.2196865-1-haoluo@google.com>
Message-Id: <20220216225209.2196865-2-haoluo@google.com>
Mime-Version: 1.0
References: <20220216225209.2196865-1-haoluo@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH stable linux-5.16.y 1/9] bpf: Introduce composable reg, ret
 and arg types.
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

commit d639b9d13a39cf15639cbe6e8b2c43eb60148a73 upstream.

There are some common properties shared between bpf reg, ret and arg
values. For instance, a value may be a NULL pointer, or a pointer to
a read-only memory. Previously, to express these properties, enumeration
was used. For example, in order to test whether a reg value can be NULL,
reg_type_may_be_null() simply enumerates all types that are possibly
NULL. The problem of this approach is that it's not scalable and causes
a lot of duplication. These properties can be combined, for example, a
type could be either MAYBE_NULL or RDONLY, or both.

This patch series rewrites the layout of reg_type, arg_type and
ret_type, so that common properties can be extracted and represented as
composable flag. For example, one can write

 ARG_PTR_TO_MEM | PTR_MAYBE_NULL

which is equivalent to the previous

 ARG_PTR_TO_MEM_OR_NULL

The type ARG_PTR_TO_MEM are called "base type" in this patch. Base
types can be extended with flags. A flag occupies the higher bits while
base types sits in the lower bits.

This patch in particular sets up a set of macro for this purpose. The
following patches will rewrite arg_types, ret_types and reg_types
respectively.

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211217003152.48334-2-haoluo@google.com
Cc: stable@vger.kernel.org # 5.16.x
---
 include/linux/bpf.h          | 42 ++++++++++++++++++++++++++++++++++++
 include/linux/bpf_verifier.h | 13 +++++++++++
 2 files changed, 55 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9f20b0f539f7..afebe332898f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -297,6 +297,29 @@ bool bpf_map_meta_equal(const struct bpf_map *meta0,
 
 extern const struct bpf_map_ops bpf_map_offload_ops;
 
+/* bpf_type_flag contains a set of flags that are applicable to the values of
+ * arg_type, ret_type and reg_type. For example, a pointer value may be null,
+ * or a memory is read-only. We classify types into two categories: base types
+ * and extended types. Extended types are base types combined with a type flag.
+ *
+ * Currently there are no more than 32 base types in arg_type, ret_type and
+ * reg_types.
+ */
+#define BPF_BASE_TYPE_BITS	8
+
+enum bpf_type_flag {
+	/* PTR may be NULL. */
+	PTR_MAYBE_NULL		= BIT(0 + BPF_BASE_TYPE_BITS),
+
+	__BPF_TYPE_LAST_FLAG	= PTR_MAYBE_NULL,
+};
+
+/* Max number of base types. */
+#define BPF_BASE_TYPE_LIMIT	(1UL << BPF_BASE_TYPE_BITS)
+
+/* Max number of all types. */
+#define BPF_TYPE_LIMIT		(__BPF_TYPE_LAST_FLAG | (__BPF_TYPE_LAST_FLAG - 1))
+
 /* function argument constraints */
 enum bpf_arg_type {
 	ARG_DONTCARE = 0,	/* unused argument in helper function */
@@ -343,7 +366,13 @@ enum bpf_arg_type {
 	ARG_PTR_TO_CONST_STR,	/* pointer to a null terminated read-only string */
 	ARG_PTR_TO_TIMER,	/* pointer to bpf_timer */
 	__BPF_ARG_TYPE_MAX,
+
+	/* This must be the last entry. Its purpose is to ensure the enum is
+	 * wide enough to hold the higher bits reserved for bpf_type_flag.
+	 */
+	__BPF_ARG_TYPE_LIMIT	= BPF_TYPE_LIMIT,
 };
+static_assert(__BPF_ARG_TYPE_MAX <= BPF_BASE_TYPE_LIMIT);
 
 /* type of values returned from helper functions */
 enum bpf_return_type {
@@ -359,7 +388,14 @@ enum bpf_return_type {
 	RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL, /* returns a pointer to a valid memory or a btf_id or NULL */
 	RET_PTR_TO_MEM_OR_BTF_ID,	/* returns a pointer to a valid memory or a btf_id */
 	RET_PTR_TO_BTF_ID,		/* returns a pointer to a btf_id */
+	__BPF_RET_TYPE_MAX,
+
+	/* This must be the last entry. Its purpose is to ensure the enum is
+	 * wide enough to hold the higher bits reserved for bpf_type_flag.
+	 */
+	__BPF_RET_TYPE_LIMIT	= BPF_TYPE_LIMIT,
 };
+static_assert(__BPF_RET_TYPE_MAX <= BPF_BASE_TYPE_LIMIT);
 
 /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
  * to in-kernel helper functions and for adjusting imm32 field in BPF_CALL
@@ -461,7 +497,13 @@ enum bpf_reg_type {
 	PTR_TO_FUNC,		 /* reg points to a bpf program function */
 	PTR_TO_MAP_KEY,		 /* reg points to a map element key */
 	__BPF_REG_TYPE_MAX,
+
+	/* This must be the last entry. Its purpose is to ensure the enum is
+	 * wide enough to hold the higher bits reserved for bpf_type_flag.
+	 */
+	__BPF_REG_TYPE_LIMIT	= BPF_TYPE_LIMIT,
 };
+static_assert(__BPF_REG_TYPE_MAX <= BPF_BASE_TYPE_LIMIT);
 
 /* The information passed from prog-specific *_is_valid_access
  * back to the verifier.
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 182b16a91084..74ee73e79bce 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -536,5 +536,18 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 			    struct bpf_attach_target_info *tgt_info);
 void bpf_free_kfunc_btf_tab(struct bpf_kfunc_btf_tab *tab);
 
+#define BPF_BASE_TYPE_MASK	GENMASK(BPF_BASE_TYPE_BITS - 1, 0)
+
+/* extract base type from bpf_{arg, return, reg}_type. */
+static inline u32 base_type(u32 type)
+{
+	return type & BPF_BASE_TYPE_MASK;
+}
+
+/* extract flags from an extended type. See bpf_type_flag in bpf.h. */
+static inline u32 type_flag(u32 type)
+{
+	return type & ~BPF_BASE_TYPE_MASK;
+}
 
 #endif /* _LINUX_BPF_VERIFIER_H */
-- 
2.35.1.265.g69c8d7142f-goog

