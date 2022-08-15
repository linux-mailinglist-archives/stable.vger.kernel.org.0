Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9378E593F1A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiHOVME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242255AbiHOVIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:08:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4483754673;
        Mon, 15 Aug 2022 12:18:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71516B81106;
        Mon, 15 Aug 2022 19:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A86C433D6;
        Mon, 15 Aug 2022 19:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591124;
        bh=vlb04FSZDe5zBy0a8n/JpcWfjR8IY7CPYEu8zaATBEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1JU3xHBJM1y697mC/+O9SWZ1uHvydUb3LVcDEIVNgxQl4kzC7asB+GMabYPb2N7i
         xkFz98TLy3gRw2Omhvc0CfjBcmgyumrl/RMG9iR+cIJi4KFq/kszNpA1Mjyjd0GFD+
         v+58plinjM6URLf3oG/urjC/oVjJchLJYQzX9Aic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0480/1095] bpf: Populate pairs of btf_id and destructor kfunc in btf
Date:   Mon, 15 Aug 2022 19:57:59 +0200
Message-Id: <20220815180449.436699917@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 5ce937d613a423ca3102f53d9f3daf4210c1b6e2 ]

To support storing referenced PTR_TO_BTF_ID in maps, we require
associating a specific BTF ID with a 'destructor' kfunc. This is because
we need to release a live referenced pointer at a certain offset in map
value from the map destruction path, otherwise we end up leaking
resources.

Hence, introduce support for passing an array of btf_id, kfunc_btf_id
pairs that denote a BTF ID and its associated release function. Then,
add an accessor 'btf_find_dtor_kfunc' which can be used to look up the
destructor kfunc of a certain BTF ID. If found, we can use it to free
the object from the map free path.

The registration of these pairs also serve as a whitelist of structures
which are allowed as referenced PTR_TO_BTF_ID in a BPF map, because
without finding the destructor kfunc, we will bail and return an error.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220424214901.2743946-7-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/btf.h |  17 +++++++
 kernel/bpf/btf.c    | 108 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 19c297f9a52f..fea424681d66 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -40,6 +40,11 @@ struct btf_kfunc_id_set {
 	};
 };
 
+struct btf_id_dtor_kfunc {
+	u32 btf_id;
+	u32 kfunc_btf_id;
+};
+
 extern const struct file_operations btf_fops;
 
 void btf_get(struct btf *btf);
@@ -346,6 +351,9 @@ bool btf_kfunc_id_set_contains(const struct btf *btf,
 			       enum btf_kfunc_type type, u32 kfunc_btf_id);
 int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 			      const struct btf_kfunc_id_set *s);
+s32 btf_find_dtor_kfunc(struct btf *btf, u32 btf_id);
+int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dtors, u32 add_cnt,
+				struct module *owner);
 #else
 static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
 						    u32 type_id)
@@ -369,6 +377,15 @@ static inline int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 {
 	return 0;
 }
+static inline s32 btf_find_dtor_kfunc(struct btf *btf, u32 btf_id)
+{
+	return -ENOENT;
+}
+static inline int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dtors,
+					      u32 add_cnt, struct module *owner)
+{
+	return 0;
+}
 #endif
 
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 58fd6896c403..57e3d9443ff3 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -207,12 +207,18 @@ enum btf_kfunc_hook {
 
 enum {
 	BTF_KFUNC_SET_MAX_CNT = 32,
+	BTF_DTOR_KFUNC_MAX_CNT = 256,
 };
 
 struct btf_kfunc_set_tab {
 	struct btf_id_set *sets[BTF_KFUNC_HOOK_MAX][BTF_KFUNC_TYPE_MAX];
 };
 
+struct btf_id_dtor_kfunc_tab {
+	u32 cnt;
+	struct btf_id_dtor_kfunc dtors[];
+};
+
 struct btf {
 	void *data;
 	struct btf_type **types;
@@ -228,6 +234,7 @@ struct btf {
 	u32 id;
 	struct rcu_head rcu;
 	struct btf_kfunc_set_tab *kfunc_set_tab;
+	struct btf_id_dtor_kfunc_tab *dtor_kfunc_tab;
 
 	/* split BTF support */
 	struct btf *base_btf;
@@ -1616,8 +1623,19 @@ static void btf_free_kfunc_set_tab(struct btf *btf)
 	btf->kfunc_set_tab = NULL;
 }
 
+static void btf_free_dtor_kfunc_tab(struct btf *btf)
+{
+	struct btf_id_dtor_kfunc_tab *tab = btf->dtor_kfunc_tab;
+
+	if (!tab)
+		return;
+	kfree(tab);
+	btf->dtor_kfunc_tab = NULL;
+}
+
 static void btf_free(struct btf *btf)
 {
+	btf_free_dtor_kfunc_tab(btf);
 	btf_free_kfunc_set_tab(btf);
 	kvfree(btf->types);
 	kvfree(btf->resolved_sizes);
@@ -7022,6 +7040,96 @@ int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 }
 EXPORT_SYMBOL_GPL(register_btf_kfunc_id_set);
 
+s32 btf_find_dtor_kfunc(struct btf *btf, u32 btf_id)
+{
+	struct btf_id_dtor_kfunc_tab *tab = btf->dtor_kfunc_tab;
+	struct btf_id_dtor_kfunc *dtor;
+
+	if (!tab)
+		return -ENOENT;
+	/* Even though the size of tab->dtors[0] is > sizeof(u32), we only need
+	 * to compare the first u32 with btf_id, so we can reuse btf_id_cmp_func.
+	 */
+	BUILD_BUG_ON(offsetof(struct btf_id_dtor_kfunc, btf_id) != 0);
+	dtor = bsearch(&btf_id, tab->dtors, tab->cnt, sizeof(tab->dtors[0]), btf_id_cmp_func);
+	if (!dtor)
+		return -ENOENT;
+	return dtor->kfunc_btf_id;
+}
+
+/* This function must be invoked only from initcalls/module init functions */
+int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dtors, u32 add_cnt,
+				struct module *owner)
+{
+	struct btf_id_dtor_kfunc_tab *tab;
+	struct btf *btf;
+	u32 tab_cnt;
+	int ret;
+
+	btf = btf_get_module_btf(owner);
+	if (!btf) {
+		if (!owner && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) {
+			pr_err("missing vmlinux BTF, cannot register dtor kfuncs\n");
+			return -ENOENT;
+		}
+		if (owner && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES)) {
+			pr_err("missing module BTF, cannot register dtor kfuncs\n");
+			return -ENOENT;
+		}
+		return 0;
+	}
+	if (IS_ERR(btf))
+		return PTR_ERR(btf);
+
+	if (add_cnt >= BTF_DTOR_KFUNC_MAX_CNT) {
+		pr_err("cannot register more than %d kfunc destructors\n", BTF_DTOR_KFUNC_MAX_CNT);
+		ret = -E2BIG;
+		goto end;
+	}
+
+	tab = btf->dtor_kfunc_tab;
+	/* Only one call allowed for modules */
+	if (WARN_ON_ONCE(tab && btf_is_module(btf))) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	tab_cnt = tab ? tab->cnt : 0;
+	if (tab_cnt > U32_MAX - add_cnt) {
+		ret = -EOVERFLOW;
+		goto end;
+	}
+	if (tab_cnt + add_cnt >= BTF_DTOR_KFUNC_MAX_CNT) {
+		pr_err("cannot register more than %d kfunc destructors\n", BTF_DTOR_KFUNC_MAX_CNT);
+		ret = -E2BIG;
+		goto end;
+	}
+
+	tab = krealloc(btf->dtor_kfunc_tab,
+		       offsetof(struct btf_id_dtor_kfunc_tab, dtors[tab_cnt + add_cnt]),
+		       GFP_KERNEL | __GFP_NOWARN);
+	if (!tab) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	if (!btf->dtor_kfunc_tab)
+		tab->cnt = 0;
+	btf->dtor_kfunc_tab = tab;
+
+	memcpy(tab->dtors + tab->cnt, dtors, add_cnt * sizeof(tab->dtors[0]));
+	tab->cnt += add_cnt;
+
+	sort(tab->dtors, tab->cnt, sizeof(tab->dtors[0]), btf_id_cmp_func, NULL);
+
+	return 0;
+end:
+	btf_free_dtor_kfunc_tab(btf);
+	btf_put(btf);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_btf_id_dtor_kfuncs);
+
 #define MAX_TYPES_ARE_COMPAT_DEPTH 2
 
 static
-- 
2.35.1



