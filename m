Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9703A4FD679
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351863AbiDLHWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352996AbiDLHOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:14:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1811A326E4;
        Mon, 11 Apr 2022 23:55:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9280860B2E;
        Tue, 12 Apr 2022 06:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A067CC385A6;
        Tue, 12 Apr 2022 06:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746535;
        bh=h4uSfY9INpPXUqgYSJ/2rq3gryC+/atjzzc+2MPpzak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TnyQSbt4ADtXBrE+DQUc027omjJiKOr/pXMQZ8z4K9O1klLpfsAQhPwtDAU8kR67e
         Ab11Z9Epkai81Pn1m+7SHA5Mj6K+fdaYE+bSwKzIsIDGgcSV7uTMYrbnaPsAJAIVIJ
         7/fUZ5+p3vF0hLYmKGl1nLZNvzxL4Knb+V/0Dzlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 041/285] net: initialize init_net earlier
Date:   Tue, 12 Apr 2022 08:28:18 +0200
Message-Id: <20220412062944.860853402@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9c1be1935fb68b2413796cdc03d019b8cf35ab51 ]

While testing a patch that will follow later
("net: add netns refcount tracker to struct nsproxy")
I found that devtmpfs_init() was called before init_net
was initialized.

This is a bug, because devtmpfs_setup() calls
ksys_unshare(CLONE_NEWNS);

This has the effect of increasing init_net refcount,
which will be later overwritten to 1, as part of setup_net(&init_net)

We had too many prior patches [1] trying to work around the root cause.

Really, make sure init_net is in BSS section, and that net_ns_init()
is called earlier at boot time.

Note that another patch ("vfs: add netns refcount tracker
to struct fs_context") also will need net_ns_init() being called
before vfs_caches_init()

As a bonus, this patch saves around 4KB in .data section.

[1]

f8c46cb39079 ("netns: do not call pernet ops for not yet set up init_net namespace")
b5082df8019a ("net: Initialise init_net.count to 1")
734b65417b24 ("net: Statically initialize init_net.dev_base_head")

v2: fixed a build error reported by kernel build bots (CONFIG_NET=n)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/net_namespace.h |  6 ++++++
 init/main.c                 |  2 ++
 net/core/dev.c              |  3 +--
 net/core/net_namespace.c    | 17 +++++------------
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index bb5fa5914032..2ba326f9e004 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -479,4 +479,10 @@ static inline void fnhe_genid_bump(struct net *net)
 	atomic_inc(&net->fnhe_genid);
 }
 
+#ifdef CONFIG_NET
+void net_ns_init(void);
+#else
+static inline void net_ns_init(void) {}
+#endif
+
 #endif /* __NET_NET_NAMESPACE_H */
diff --git a/init/main.c b/init/main.c
index bb984ed79de0..cb68bc48a682 100644
--- a/init/main.c
+++ b/init/main.c
@@ -99,6 +99,7 @@
 #include <linux/kcsan.h>
 #include <linux/init_syscalls.h>
 #include <linux/stackdepot.h>
+#include <net/net_namespace.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -1113,6 +1114,7 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 	key_init();
 	security_init();
 	dbg_late_init();
+	net_ns_init();
 	vfs_caches_init();
 	pagecache_init();
 	signals_init();
diff --git a/net/core/dev.c b/net/core/dev.c
index 2078d04c6482..8c47e0f2075d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11403,8 +11403,7 @@ static int __net_init netdev_init(struct net *net)
 	BUILD_BUG_ON(GRO_HASH_BUCKETS >
 		     8 * sizeof_field(struct napi_struct, gro_bitmask));
 
-	if (net != &init_net)
-		INIT_LIST_HEAD(&net->dev_base_head);
+	INIT_LIST_HEAD(&net->dev_base_head);
 
 	net->dev_name_head = netdev_create_hash();
 	if (net->dev_name_head == NULL)
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 9702d2b0d920..9745cb6fdf51 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -44,13 +44,7 @@ EXPORT_SYMBOL_GPL(net_rwsem);
 static struct key_tag init_net_key_domain = { .usage = REFCOUNT_INIT(1) };
 #endif
 
-struct net init_net = {
-	.ns.count	= REFCOUNT_INIT(1),
-	.dev_base_head	= LIST_HEAD_INIT(init_net.dev_base_head),
-#ifdef CONFIG_KEYS
-	.key_domain	= &init_net_key_domain,
-#endif
-};
+struct net init_net;
 EXPORT_SYMBOL(init_net);
 
 static bool init_net_initialized;
@@ -1081,7 +1075,7 @@ static void rtnl_net_notifyid(struct net *net, int cmd, int id, u32 portid,
 	rtnl_set_sk_err(net, RTNLGRP_NSID, err);
 }
 
-static int __init net_ns_init(void)
+void __init net_ns_init(void)
 {
 	struct net_generic *ng;
 
@@ -1102,6 +1096,9 @@ static int __init net_ns_init(void)
 
 	rcu_assign_pointer(init_net.gen, ng);
 
+#ifdef CONFIG_KEYS
+	init_net.key_domain = &init_net_key_domain;
+#endif
 	down_write(&pernet_ops_rwsem);
 	if (setup_net(&init_net, &init_user_ns))
 		panic("Could not setup the initial network namespace");
@@ -1116,12 +1113,8 @@ static int __init net_ns_init(void)
 		      RTNL_FLAG_DOIT_UNLOCKED);
 	rtnl_register(PF_UNSPEC, RTM_GETNSID, rtnl_net_getid, rtnl_net_dumpid,
 		      RTNL_FLAG_DOIT_UNLOCKED);
-
-	return 0;
 }
 
-pure_initcall(net_ns_init);
-
 static void free_exit_list(struct pernet_operations *ops, struct list_head *net_exit_list)
 {
 	ops_pre_exit_list(ops, net_exit_list);
-- 
2.35.1



