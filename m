Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A8064EBAE
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 13:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiLPM5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 07:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbiLPM5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 07:57:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BE0528A0;
        Fri, 16 Dec 2022 04:57:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3646BCE1DFA;
        Fri, 16 Dec 2022 12:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA94CC433D2;
        Fri, 16 Dec 2022 12:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671195429;
        bh=s0Hd4iLCY0fteWII4tHI7Hd06DUk+a9vS+JCwVaF3IM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sixobG5HoKP8nb3K0HH6Frow6mJQbgtr3duZ2cT/uMZhZPWqAP0ZH9QDTlQHbZRsA
         Ei7LQUdRZd8/dliT9ft0jABbM1VS30QNYs3uRCRKyoj2a1taqotNn8wc++qBMc4Y+R
         fLTyFH+3NKISVeBOgSfzTXFVWUwXyLnbfX4yM0fQT3x8y4ujL5Nh5dDSBlyrYHwoaC
         eZsZR91B1dmALAWobKToFyY9vZQE766l7UNlMH77lkMwobuDP5dM/F1udNPUR+Up8N
         aMXNGkj27jW/ChaQiL+nb1mOcaPGwTOTAViREjt1X8R+XNziBmlkfYF6NYgVri/aeY
         egf1xI8ujtEBQ==
From:   Jiri Olsa <jolsa@kernel.org>
To:     stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Martynas Pumputis <m@lambda.lt>
Subject: [PATCH stable 6.0 4/8] bpf: Take module reference on kprobe_multi link
Date:   Fri, 16 Dec 2022 13:56:24 +0100
Message-Id: <20221216125628.1622505-5-jolsa@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221216125628.1622505-1-jolsa@kernel.org>
References: <20221216125628.1622505-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e22061b2d3095c12f90336479f24bf5eeb70e1bd upstream.

Currently we allow to create kprobe multi link on function from kernel
module, but we don't take the module reference to ensure it's not
unloaded while we are tracing it.

The multi kprobe link is based on fprobe/ftrace layer which takes
different approach and releases ftrace hooks when module is unloaded
even if there's tracer registered on top of it.

Adding code that gathers all the related modules for the link and takes
their references before it's attached. All kernel module references are
released after link is unregistered.

Note that we do it the same way already for trampoline probes
(but for single address).

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221025134148.3300700-5-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/trace/bpf_trace.c | 92 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 5f3a65ab6ba3..da8e7b695179 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2264,6 +2264,8 @@ struct bpf_kprobe_multi_link {
 	unsigned long *addrs;
 	u64 *cookies;
 	u32 cnt;
+	u32 mods_cnt;
+	struct module **mods;
 };
 
 struct bpf_kprobe_multi_run_ctx {
@@ -2319,6 +2321,14 @@ static int copy_user_syms(struct user_syms *us, unsigned long __user *usyms, u32
 	return err;
 }
 
+static void kprobe_multi_put_modules(struct module **mods, u32 cnt)
+{
+	u32 i;
+
+	for (i = 0; i < cnt; i++)
+		module_put(mods[i]);
+}
+
 static void free_user_syms(struct user_syms *us)
 {
 	kvfree(us->syms);
@@ -2331,6 +2341,7 @@ static void bpf_kprobe_multi_link_release(struct bpf_link *link)
 
 	kmulti_link = container_of(link, struct bpf_kprobe_multi_link, link);
 	unregister_fprobe(&kmulti_link->fp);
+	kprobe_multi_put_modules(kmulti_link->mods, kmulti_link->mods_cnt);
 }
 
 static void bpf_kprobe_multi_link_dealloc(struct bpf_link *link)
@@ -2340,6 +2351,7 @@ static void bpf_kprobe_multi_link_dealloc(struct bpf_link *link)
 	kmulti_link = container_of(link, struct bpf_kprobe_multi_link, link);
 	kvfree(kmulti_link->addrs);
 	kvfree(kmulti_link->cookies);
+	kfree(kmulti_link->mods);
 	kfree(kmulti_link);
 }
 
@@ -2475,6 +2487,71 @@ static void symbols_swap_r(void *a, void *b, int size, const void *priv)
 	}
 }
 
+struct module_addr_args {
+	unsigned long *addrs;
+	u32 addrs_cnt;
+	struct module **mods;
+	int mods_cnt;
+	int mods_cap;
+};
+
+static int module_callback(void *data, const char *name,
+			   struct module *mod, unsigned long addr)
+{
+	struct module_addr_args *args = data;
+	struct module **mods;
+
+	/* We iterate all modules symbols and for each we:
+	 * - search for it in provided addresses array
+	 * - if found we check if we already have the module pointer stored
+	 *   (we iterate modules sequentially, so we can check just the last
+	 *   module pointer)
+	 * - take module reference and store it
+	 */
+	if (!bsearch(&addr, args->addrs, args->addrs_cnt, sizeof(addr),
+		       bpf_kprobe_multi_addrs_cmp))
+		return 0;
+
+	if (args->mods && args->mods[args->mods_cnt - 1] == mod)
+		return 0;
+
+	if (args->mods_cnt == args->mods_cap) {
+		args->mods_cap = max(16, args->mods_cap * 3 / 2);
+		mods = krealloc_array(args->mods, args->mods_cap, sizeof(*mods), GFP_KERNEL);
+		if (!mods)
+			return -ENOMEM;
+		args->mods = mods;
+	}
+
+	if (!try_module_get(mod))
+		return -EINVAL;
+
+	args->mods[args->mods_cnt] = mod;
+	args->mods_cnt++;
+	return 0;
+}
+
+static int get_modules_for_addrs(struct module ***mods, unsigned long *addrs, u32 addrs_cnt)
+{
+	struct module_addr_args args = {
+		.addrs     = addrs,
+		.addrs_cnt = addrs_cnt,
+	};
+	int err;
+
+	/* We return either err < 0 in case of error, ... */
+	err = module_kallsyms_on_each_symbol(module_callback, &args);
+	if (err) {
+		kprobe_multi_put_modules(args.mods, args.mods_cnt);
+		kfree(args.mods);
+		return err;
+	}
+
+	/* or number of modules found if everything is ok. */
+	*mods = args.mods;
+	return args.mods_cnt;
+}
+
 int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 {
 	struct bpf_kprobe_multi_link *link = NULL;
@@ -2585,10 +2662,25 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 		       bpf_kprobe_multi_cookie_cmp,
 		       bpf_kprobe_multi_cookie_swap,
 		       link);
+	} else {
+		/*
+		 * We need to sort addrs array even if there are no cookies
+		 * provided, to allow bsearch in get_modules_for_addrs.
+		 */
+		sort(addrs, cnt, sizeof(*addrs),
+		       bpf_kprobe_multi_addrs_cmp, NULL);
+	}
+
+	err = get_modules_for_addrs(&link->mods, addrs, cnt);
+	if (err < 0) {
+		bpf_link_cleanup(&link_primer);
+		return err;
 	}
+	link->mods_cnt = err;
 
 	err = register_fprobe_ips(&link->fp, addrs, cnt);
 	if (err) {
+		kprobe_multi_put_modules(link->mods, link->mods_cnt);
 		bpf_link_cleanup(&link_primer);
 		return err;
 	}
-- 
2.38.1

