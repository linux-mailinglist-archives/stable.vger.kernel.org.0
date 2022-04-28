Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A2C513F42
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 01:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353459AbiD2ACc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 20:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiD2ACc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 20:02:32 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3173A146B
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:15 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d134-20020a25e68c000000b006483b1adcc3so6002723ybh.11
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bwYMTHq83CYfDXJ/AFPHvHePsWWp/A3QUlLPKzabZZs=;
        b=eMAXmuTn7DzYyoNg6YdPkeNl1KjaiZzgckYs8cPqvP0aXdIEHLSwwFg1Md02oztwdO
         rI9PB/HqKcRcV3/ROBXzBdLlxLY9NEo1Y/cq7CVcXV2S88YWiXxxL282V7slL3T8/rvY
         W4XCXQamqxkH6DXod79WWOFbGtFpiaZSS3X2FxDXCSKhOREX2ddfQ1TGIw4BvLlxHAkZ
         rdmAcf6McqAx08O6UYol4ec41Y6A1pnybgFcfgaD4192vfU/S4MLwHP2btnYj8SRCC+d
         iLHPw115EqseKPyQi54NRw6bYHntZlhQzRgztCKPYujfZjLTINBNkY5JBIQn+STQh6uY
         kZlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bwYMTHq83CYfDXJ/AFPHvHePsWWp/A3QUlLPKzabZZs=;
        b=LVxRoeR4duUpGpd737HHbSpOsRA/NUqH+Lv8sms1G6Hy+4UrwaPpDXUUuDYoHFIm5i
         AIgtHJ2t3giO5v/itxFMc31WoOYI5S5c6G2yKHfuwDIweDebIxfMHjBhhjKZMtJzkbd9
         PsszBdPm6sDLm2Z8UiDR0dBbraWtT6e765g1sJKis6wX4NevnTAjflNHbPZtQXY3fulE
         e1FBapWcjf89qefw6Hq0WiPWwVQLXK1w9kaGrc9fvdD9zMBqKz49QQQ/Jlwc/D2l19zN
         kM6cIy5R31Jsw0LfSKvm9ZTsd18OM3FdcZlavA2jmLibb0PoTq7X9px5KomwXChuqPqx
         KZqg==
X-Gm-Message-State: AOAM5314hzeL9mxcXTqlhRa36kb6gv0rIRt4oDtvSu7JC8CEdz82kM7A
        Ylo6hkC7bdnIk8O3yirgOsfHPXTDWtU=
X-Google-Smtp-Source: ABdhPJzuS+NgdpvYg4maQ3wHNoUzdeBoh+I97prQJb3uFYETiH0spX1gztJA3jBd7llR5F4oognTGnaotes=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:25cd:1665:36bc:f38e])
 (user=haoluo job=sendgmr) by 2002:a05:6902:c8:b0:633:ee0c:bca2 with SMTP id
 i8-20020a05690200c800b00633ee0cbca2mr35521223ybs.82.1651190354883; Thu, 28
 Apr 2022 16:59:14 -0700 (PDT)
Date:   Thu, 28 Apr 2022 16:57:42 -0700
In-Reply-To: <20220428235751.103203-1-haoluo@google.com>
Message-Id: <20220428235751.103203-2-haoluo@google.com>
Mime-Version: 1.0
References: <20220428235751.103203-1-haoluo@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH stable linux-5.15.y 01/10] bpf: Introduce composable reg, ret
 and arg types.
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
Cc: stable@vger.kernel.org # 5.15.x
---
 include/linux/bpf.h          | 42 ++++++++++++++++++++++++++++++++++++
 include/linux/bpf_verifier.h | 14 ++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 15b690a0cecb..864af1285d7f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -293,6 +293,29 @@ bool bpf_map_meta_equal(const struct bpf_map *meta0,
 
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
@@ -339,7 +362,13 @@ enum bpf_arg_type {
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
@@ -355,7 +384,14 @@ enum bpf_return_type {
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
@@ -457,7 +493,13 @@ enum bpf_reg_type {
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
index 364550dd19c4..2e612f3fd385 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -535,4 +535,18 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 			    u32 btf_id,
 			    struct bpf_attach_target_info *tgt_info);
 
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
+
 #endif /* _LINUX_BPF_VERIFIER_H */
-- 
2.36.0.464.gb9c8b46e94-goog

