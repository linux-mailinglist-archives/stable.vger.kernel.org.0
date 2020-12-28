Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545062E39FA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390431AbgL1Naj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:30:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:59552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390425AbgL1Nai (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:30:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7968220719;
        Mon, 28 Dec 2020 13:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162197;
        bh=TJaK6RGvHcg4PTIAB2hYD/H2Sndx4AYOdDIzcb7Gqkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjMfsd8Oo6UwG1hiu9d5U33Cr9oZWGuiaDwFNzmLhUXQwbnUazeuWGyTBd9iighNo
         6y9NbPW1sS4DAAOwQsOWZwwhv5gVVoJM3qRqnRpmZLTztSq11UOjrX7xygov0fvxEy
         1yW6jn7JkY+L1dLhHUadX6V/l5Z2CDNgz/8cb0IM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 190/346] SUNRPC: xprt_load_transport() needs to support the netid "rdma6"
Date:   Mon, 28 Dec 2020 13:48:29 +0100
Message-Id: <20201228124928.972934332@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit d5aa6b22e2258f05317313ecc02efbb988ed6d38 ]

According to RFC5666, the correct netid for an IPv6 addressed RDMA
transport is "rdma6", which we've supported as a mount option since
Linux-4.7. The problem is when we try to load the module "xprtrdma6",
that will fail, since there is no modulealias of that name.

Fixes: 181342c5ebe8 ("xprtrdma: Add rdma6 option to support NFS/RDMA IPv6")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xprt.h     |  1 +
 net/sunrpc/xprt.c               | 65 +++++++++++++++++++++++++--------
 net/sunrpc/xprtrdma/module.c    |  1 +
 net/sunrpc/xprtrdma/transport.c |  1 +
 net/sunrpc/xprtsock.c           |  4 ++
 5 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index e7bbd82908b10..69fed13e633b7 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -317,6 +317,7 @@ struct xprt_class {
 	struct rpc_xprt *	(*setup)(struct xprt_create *);
 	struct module		*owner;
 	char			name[32];
+	const char *		netid[];
 };
 
 /*
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 5e7c13aa66d0d..9c4235ce57894 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -143,31 +143,64 @@ out:
 }
 EXPORT_SYMBOL_GPL(xprt_unregister_transport);
 
+static void
+xprt_class_release(const struct xprt_class *t)
+{
+	module_put(t->owner);
+}
+
+static const struct xprt_class *
+xprt_class_find_by_netid_locked(const char *netid)
+{
+	const struct xprt_class *t;
+	unsigned int i;
+
+	list_for_each_entry(t, &xprt_list, list) {
+		for (i = 0; t->netid[i][0] != '\0'; i++) {
+			if (strcmp(t->netid[i], netid) != 0)
+				continue;
+			if (!try_module_get(t->owner))
+				continue;
+			return t;
+		}
+	}
+	return NULL;
+}
+
+static const struct xprt_class *
+xprt_class_find_by_netid(const char *netid)
+{
+	const struct xprt_class *t;
+
+	spin_lock(&xprt_list_lock);
+	t = xprt_class_find_by_netid_locked(netid);
+	if (!t) {
+		spin_unlock(&xprt_list_lock);
+		request_module("rpc%s", netid);
+		spin_lock(&xprt_list_lock);
+		t = xprt_class_find_by_netid_locked(netid);
+	}
+	spin_unlock(&xprt_list_lock);
+	return t;
+}
+
 /**
  * xprt_load_transport - load a transport implementation
- * @transport_name: transport to load
+ * @netid: transport to load
  *
  * Returns:
  * 0:		transport successfully loaded
  * -ENOENT:	transport module not available
  */
-int xprt_load_transport(const char *transport_name)
+int xprt_load_transport(const char *netid)
 {
-	struct xprt_class *t;
-	int result;
+	const struct xprt_class *t;
 
-	result = 0;
-	spin_lock(&xprt_list_lock);
-	list_for_each_entry(t, &xprt_list, list) {
-		if (strcmp(t->name, transport_name) == 0) {
-			spin_unlock(&xprt_list_lock);
-			goto out;
-		}
-	}
-	spin_unlock(&xprt_list_lock);
-	result = request_module("xprt%s", transport_name);
-out:
-	return result;
+	t = xprt_class_find_by_netid(netid);
+	if (!t)
+		return -ENOENT;
+	xprt_class_release(t);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(xprt_load_transport);
 
diff --git a/net/sunrpc/xprtrdma/module.c b/net/sunrpc/xprtrdma/module.c
index 620327c01302c..45c5b41ac8dc9 100644
--- a/net/sunrpc/xprtrdma/module.c
+++ b/net/sunrpc/xprtrdma/module.c
@@ -24,6 +24,7 @@ MODULE_DESCRIPTION("RPC/RDMA Transport");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_ALIAS("svcrdma");
 MODULE_ALIAS("xprtrdma");
+MODULE_ALIAS("rpcrdma6");
 
 static void __exit rpc_rdma_cleanup(void)
 {
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index f56f36b4d742d..fdd14908eacbd 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -854,6 +854,7 @@ static struct xprt_class xprt_rdma = {
 	.owner			= THIS_MODULE,
 	.ident			= XPRT_TRANSPORT_RDMA,
 	.setup			= xprt_setup_rdma,
+	.netid			= { "rdma", "rdma6", "" },
 };
 
 void xprt_rdma_cleanup(void)
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 9dc059dea689d..798fbd89ed42f 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -3241,6 +3241,7 @@ static struct xprt_class	xs_local_transport = {
 	.owner		= THIS_MODULE,
 	.ident		= XPRT_TRANSPORT_LOCAL,
 	.setup		= xs_setup_local,
+	.netid		= { "" },
 };
 
 static struct xprt_class	xs_udp_transport = {
@@ -3249,6 +3250,7 @@ static struct xprt_class	xs_udp_transport = {
 	.owner		= THIS_MODULE,
 	.ident		= XPRT_TRANSPORT_UDP,
 	.setup		= xs_setup_udp,
+	.netid		= { "udp", "udp6", "" },
 };
 
 static struct xprt_class	xs_tcp_transport = {
@@ -3257,6 +3259,7 @@ static struct xprt_class	xs_tcp_transport = {
 	.owner		= THIS_MODULE,
 	.ident		= XPRT_TRANSPORT_TCP,
 	.setup		= xs_setup_tcp,
+	.netid		= { "tcp", "tcp6", "" },
 };
 
 static struct xprt_class	xs_bc_tcp_transport = {
@@ -3265,6 +3268,7 @@ static struct xprt_class	xs_bc_tcp_transport = {
 	.owner		= THIS_MODULE,
 	.ident		= XPRT_TRANSPORT_BC_TCP,
 	.setup		= xs_setup_bc_tcp,
+	.netid		= { "" },
 };
 
 /**
-- 
2.27.0



