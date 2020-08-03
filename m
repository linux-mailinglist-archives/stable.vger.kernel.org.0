Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F6623A628
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgHCM1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:27:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728560AbgHCM1f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:27:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E98E207FC;
        Mon,  3 Aug 2020 12:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457654;
        bh=HkyT1WY2Jwb8f3wNOG+gg1AcitoVC2HNsjZbvGkzX9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SxDLhYpLt8K/B2iOo0KLEagsao855YdLxZ9Cv+AfI2PVlGRmmFirCeLjUs/ymp9Yn
         /zAWFfTR7ewZ+L+tHUvX82gPfqDkK56wFh44j9wVwtySDSKI+IbVcLb2t31nVjDpNM
         qwpV/QNIChgyPmncKHXLQX6rYbkN/LpfY6ZVEyRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/90] sunrpc: check that domain table is empty at module unload.
Date:   Mon,  3 Aug 2020 14:18:25 +0200
Message-Id: <20200803121857.711453768@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
 net/sunrpc/svcauth.c     | 27 +++++++++++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/net/sunrpc/sunrpc.h b/net/sunrpc/sunrpc.h
index c9bacb3c930fa..82035fa65b8f9 100644
--- a/net/sunrpc/sunrpc.h
+++ b/net/sunrpc/sunrpc.h
@@ -56,4 +56,5 @@ int svc_send_common(struct socket *sock, struct xdr_buf *xdr,
 
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
index 550b214cb0015..998b196b61767 100644
--- a/net/sunrpc/svcauth.c
+++ b/net/sunrpc/svcauth.c
@@ -19,6 +19,10 @@
 #include <linux/err.h>
 #include <linux/hash.h>
 
+#include <trace/events/sunrpc.h>
+
+#include "sunrpc.h"
+
 #define RPCDBG_FACILITY	RPCDBG_AUTH
 
 
@@ -203,3 +207,26 @@ struct auth_domain *auth_domain_find(char *name)
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



