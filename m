Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B417A5146FD
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357747AbiD2Kq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357890AbiD2Kp6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:45:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA67C74A2;
        Fri, 29 Apr 2022 03:42:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D1D462356;
        Fri, 29 Apr 2022 10:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21C6C385A4;
        Fri, 29 Apr 2022 10:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228952;
        bh=9SJEWbZg+I1bE+nYZD11RlSuif+eP9MLYe6W5R62kgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LUGzBJqNiN9e52PLASmvd+3+E+rI/diVA8v7FGOqdYyqK2bePktgTM8FavzgdO3E3
         lLzjcSiyW0fw7XbTU9P5d7PLN5uj0O0UxB4AJPcP91Bz6wtGGkFWMc7rXJdGjJAYy2
         41gVCddUMs7IsSGPNhkipRXyn+8Q55ZqaoMTGTSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 02/33] bpf: Introduce composable reg, ret and arg types.
Date:   Fri, 29 Apr 2022 12:41:49 +0200
Message-Id: <20220429104052.416312840@linuxfoundation.org>
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

From: Hao Luo <haoluo@google.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h          |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/bpf_verifier.h |   14 ++++++++++++++
 2 files changed, 56 insertions(+)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -293,6 +293,29 @@ bool bpf_map_meta_equal(const struct bpf
 
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
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -535,4 +535,18 @@ int bpf_check_attach_target(struct bpf_v
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


