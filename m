Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7714F278C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbiDEIH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235959AbiDEIAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:00:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ED84838D;
        Tue,  5 Apr 2022 00:58:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 262E4B81B18;
        Tue,  5 Apr 2022 07:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704FEC340EE;
        Tue,  5 Apr 2022 07:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145531;
        bh=KTLwSTgDEzAbj911kue+HNBgznSoxQk32rT0DI32z1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xBQ46F5fGM7XsiKpHmCDUIxVzo09pTaMbES069UqvLtZFBHEJ5QmScaejQA+Yox+z
         Ek1C6RWS27VPMQVwAjKY5pyhjO8Tk1u9Xr2ek9AOBOUgwc975HrmL+rS3wcq6mCd5T
         2bbe7u6c66V8SoA5oTxq5a73MJL4esEnT1/MXku4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0440/1126] bpf: Fix UAF due to race between btf_try_get_module and load_module
Date:   Tue,  5 Apr 2022 09:19:47 +0200
Message-Id: <20220405070420.539054289@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

[ Upstream commit 18688de203b47e5d8d9d0953385bf30b5949324f ]

While working on code to populate kfunc BTF ID sets for module BTF from
its initcall, I noticed that by the time the initcall is invoked, the
module BTF can already be seen by userspace (and the BPF verifier). The
existing btf_try_get_module calls try_module_get which only fails if
mod->state == MODULE_STATE_GOING, i.e. it can increment module reference
when module initcall is happening in parallel.

Currently, BTF parsing happens from MODULE_STATE_COMING notifier
callback. At this point, the module initcalls have not been invoked.
The notifier callback parses and prepares the module BTF, allocates an
ID, which publishes it to userspace, and then adds it to the btf_modules
list allowing the kernel to invoke btf_try_get_module for the BTF.

However, at this point, the module has not been fully initialized (i.e.
its initcalls have not finished). The code in module.c can still fail
and free the module, without caring for other users. However, nothing
stops btf_try_get_module from succeeding between the state transition
from MODULE_STATE_COMING to MODULE_STATE_LIVE.

This leads to a use-after-free issue when BPF program loads
successfully in the state transition, load_module's do_init_module call
fails and frees the module, and BPF program fd on close calls module_put
for the freed module. Future patch has test case to verify we don't
regress in this area in future.

There are multiple points after prepare_coming_module (in load_module)
where failure can occur and module loading can return error. We
illustrate and test for the race using the last point where it can
practically occur (in module __init function).

An illustration of the race:

CPU 0                           CPU 1
			  load_module
			    notifier_call(MODULE_STATE_COMING)
			      btf_parse_module
			      btf_alloc_id	// Published to userspace
			      list_add(&btf_mod->list, btf_modules)
			    mod->init(...)
...				^
bpf_check		        |
check_pseudo_btf_id             |
  btf_try_get_module            |
    returns true                |  ...
...                             |  module __init in progress
return prog_fd                  |  ...
...                             V
			    if (ret < 0)
			      free_module(mod)
			    ...
close(prog_fd)
 ...
 bpf_prog_free_deferred
  module_put(used_btf.mod) // use-after-free

We fix this issue by setting a flag BTF_MODULE_F_LIVE, from the notifier
callback when MODULE_STATE_LIVE state is reached for the module, so that
we return NULL from btf_try_get_module for modules that are not fully
formed. Since try_module_get already checks that module is not in
MODULE_STATE_GOING state, and that is the only transition a live module
can make before being removed from btf_modules list, this is enough to
close the race and prevent the bug.

A later selftest patch crafts the race condition artifically to verify
that it has been fixed, and that verifier fails to load program (with
ENXIO).

Lastly, a couple of comments:

 1. Even if this race didn't exist, it seems more appropriate to only
    access resources (ksyms and kfuncs) of a fully formed module which
    has been initialized completely.

 2. This patch was born out of need for synchronization against module
    initcall for the next patch, so it is needed for correctness even
    without the aforementioned race condition. The BTF resources
    initialized by module initcall are set up once and then only looked
    up, so just waiting until the initcall has finished ensures correct
    behavior.

Fixes: 541c3bad8dc5 ("bpf: Support BPF ksym variables in kernel modules")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20220114163953.1455836-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 3e23b3fa79ff..a3b5a6bf99e7 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6201,12 +6201,17 @@ bool btf_id_set_contains(const struct btf_id_set *set, u32 id)
 	return bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func) != NULL;
 }
 
+enum {
+	BTF_MODULE_F_LIVE = (1 << 0),
+};
+
 #ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 struct btf_module {
 	struct list_head list;
 	struct module *module;
 	struct btf *btf;
 	struct bin_attribute *sysfs_attr;
+	int flags;
 };
 
 static LIST_HEAD(btf_modules);
@@ -6234,7 +6239,8 @@ static int btf_module_notify(struct notifier_block *nb, unsigned long op,
 	int err = 0;
 
 	if (mod->btf_data_size == 0 ||
-	    (op != MODULE_STATE_COMING && op != MODULE_STATE_GOING))
+	    (op != MODULE_STATE_COMING && op != MODULE_STATE_LIVE &&
+	     op != MODULE_STATE_GOING))
 		goto out;
 
 	switch (op) {
@@ -6292,6 +6298,17 @@ static int btf_module_notify(struct notifier_block *nb, unsigned long op,
 			btf_mod->sysfs_attr = attr;
 		}
 
+		break;
+	case MODULE_STATE_LIVE:
+		mutex_lock(&btf_module_mutex);
+		list_for_each_entry_safe(btf_mod, tmp, &btf_modules, list) {
+			if (btf_mod->module != module)
+				continue;
+
+			btf_mod->flags |= BTF_MODULE_F_LIVE;
+			break;
+		}
+		mutex_unlock(&btf_module_mutex);
 		break;
 	case MODULE_STATE_GOING:
 		mutex_lock(&btf_module_mutex);
@@ -6339,7 +6356,12 @@ struct module *btf_try_get_module(const struct btf *btf)
 		if (btf_mod->btf != btf)
 			continue;
 
-		if (try_module_get(btf_mod->module))
+		/* We must only consider module whose __init routine has
+		 * finished, hence we must check for BTF_MODULE_F_LIVE flag,
+		 * which is set from the notifier callback for
+		 * MODULE_STATE_LIVE.
+		 */
+		if ((btf_mod->flags & BTF_MODULE_F_LIVE) && try_module_get(btf_mod->module))
 			res = btf_mod->module;
 
 		break;
-- 
2.34.1



