Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13FC23A401
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgHCMV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:21:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgHCMVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:21:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 796C820738;
        Mon,  3 Aug 2020 12:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457275;
        bh=6TKRQAx0bExw+dtJQ9fufqGombiOTqQtelaZgNQ8C6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTnzVTxbmJUOWgZi63eQu1zmANLqjjcz0XJut3pFy5jdUM6CPUaG9gMreYyExPkHo
         nO+iWnl829WhWwLtAswA8zEy5S3Lf+Rf7neqLilX2LrxDXsq8gyemENhvossCnbGbK
         vQe8rwv1BH7Js1UnOMQQMu9unn2L2QWm/LEM6BJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 001/120] sunrpc: check that domain table is empty at module unload.
Date:   Mon,  3 Aug 2020 14:17:39 +0200
Message-Id: <20200803121902.935547948@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

[ Upstream commit f45db2b909c7e76f35850e78f017221f30282b8e ]

The domain table should be empty at module unload.  If it isn't there is
a bug somewhere.  So check and report.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206651
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/sunrpc.h      |  1 +
 net/sunrpc/sunrpc_syms.c |  2 ++
 net/sunrpc/svcauth.c     | 25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/net/sunrpc/sunrpc.h b/net/sunrpc/sunrpc.h
index 47a756503d11c..f6fe2e6cd65a1 100644
--- a/net/sunrpc/sunrpc.h
+++ b/net/sunrpc/sunrpc.h
@@ -52,4 +52,5 @@ static inline int sock_is_loopback(struct sock *sk)
 
 int rpc_clients_notifier_register(void);
 void rpc_clients_notifier_unregister(void);
+void auth_domain_cleanup(void);
 #endif /* _NET_SUNRPC_SUNRPC_H */
diff --git a/net/sunrpc/sunrpc_syms.c b/net/sunrpc/sunrpc_syms.c
index f9edaa9174a43..236fadc4a4399 100644
--- a/net/sunrpc/sunrpc_syms.c
+++ b/net/sunrpc/sunrpc_syms.c
@@ -23,6 +23,7 @@
 #include <linux/sunrpc/rpc_pipe_fs.h>
 #include <linux/sunrpc/xprtsock.h>
 
+#include "sunrpc.h"
 #include "netns.h"
 
 unsigned int sunrpc_net_id;
@@ -131,6 +132,7 @@ cleanup_sunrpc(void)
 	unregister_rpc_pipefs();
 	rpc_destroy_mempool();
 	unregister_pernet_subsys(&sunrpc_net_ops);
+	auth_domain_cleanup();
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 	rpc_unregister_sysctl();
 #endif
diff --git a/net/sunrpc/svcauth.c b/net/sunrpc/svcauth.c
index 552617e3467bd..998b196b61767 100644
--- a/net/sunrpc/svcauth.c
+++ b/net/sunrpc/svcauth.c
@@ -21,6 +21,8 @@
 
 #include <trace/events/sunrpc.h>
 
+#include "sunrpc.h"
+
 #define RPCDBG_FACILITY	RPCDBG_AUTH
 
 
@@ -205,3 +207,26 @@ struct auth_domain *auth_domain_find(char *name)
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(auth_domain_find);
+
+/**
+ * auth_domain_cleanup - check that the auth_domain table is empty
+ *
+ * On module unload the auth_domain_table must be empty.  To make it
+ * easier to catch bugs which don't clean up domains properly, we
+ * warn if anything remains in the table at cleanup time.
+ *
+ * Note that we cannot proactively remove the domains at this stage.
+ * The ->release() function might be in a module that has already been
+ * unloaded.
+ */
+
+void auth_domain_cleanup(void)
+{
+	int h;
+	struct auth_domain *hp;
+
+	for (h = 0; h < DN_HASHMAX; h++)
+		hlist_for_each_entry(hp, &auth_domain_table[h], hash)
+			pr_warn("svc: domain %s still present at module unload.\n",
+				hp->name);
+}
-- 
2.25.1



