Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6373498F54
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245198AbiAXTwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238002AbiAXT01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:26:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D845CC02B879;
        Mon, 24 Jan 2022 11:12:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F81DB8121A;
        Mon, 24 Jan 2022 19:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88A7C340EA;
        Mon, 24 Jan 2022 19:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051536;
        bh=1IvSxe8xKZxSOH1osGJiqjMhR5Nf6Fmyo66KyHc0iLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=syak8bdGY/9AFvq+ux/NiTyWrTjfrrMXzEN8qowHGjojSHZLN6ETSDD9+8Lh1f0Mw
         ZDwHDo9yWOdeiqLYvaOZixGQu7aPcKT4W/q68nbcVlgPL6MsYdWLFaplKkb3uxEYoj
         xyzRMwfu6KAUTVyaYoQY3+JM5Yucpe0+hTxIAbF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Wakabayashi <mwakabayashi@vmware.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.14 186/186] NFSv4: Initialise connection to the server in nfs4_alloc_client()
Date:   Mon, 24 Jan 2022 19:44:21 +0100
Message-Id: <20220124183943.090675630@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit dd99e9f98fbf423ff6d365b37a98e8879170f17c upstream.

Set up the connection to the NFSv4 server in nfs4_alloc_client(), before
we've added the struct nfs_client to the net-namespace's nfs_client_list
so that a downed server won't cause other mounts to hang in the trunking
detection code.

Reported-by: Michael Wakabayashi <mwakabayashi@vmware.com>
Fixes: 5c6e5b60aae4 ("NFS: Fix an Oops in the pNFS files and flexfiles connection setup to the DS")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4client.c |   82 ++++++++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 40 deletions(-)

--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -177,8 +177,11 @@ void nfs40_shutdown_client(struct nfs_cl
 
 struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
 {
-	int err;
+	char buf[INET6_ADDRSTRLEN + 1];
+	const char *ip_addr = cl_init->ip_addr;
 	struct nfs_client *clp = nfs_alloc_client(cl_init);
+	int err;
+
 	if (IS_ERR(clp))
 		return clp;
 
@@ -202,6 +205,44 @@ struct nfs_client *nfs4_alloc_client(con
 #if IS_ENABLED(CONFIG_NFS_V4_1)
 	init_waitqueue_head(&clp->cl_lock_waitq);
 #endif
+
+	if (cl_init->minorversion != 0)
+		__set_bit(NFS_CS_INFINITE_SLOTS, &clp->cl_flags);
+	__set_bit(NFS_CS_DISCRTRY, &clp->cl_flags);
+	__set_bit(NFS_CS_NO_RETRANS_TIMEOUT, &clp->cl_flags);
+
+	/*
+	 * Set up the connection to the server before we add add to the
+	 * global list.
+	 */
+	err = nfs_create_rpc_client(clp, cl_init, RPC_AUTH_GSS_KRB5I);
+	if (err == -EINVAL)
+		err = nfs_create_rpc_client(clp, cl_init, RPC_AUTH_UNIX);
+	if (err < 0)
+		goto error;
+
+	/* If no clientaddr= option was specified, find a usable cb address */
+	if (ip_addr == NULL) {
+		struct sockaddr_storage cb_addr;
+		struct sockaddr *sap = (struct sockaddr *)&cb_addr;
+
+		err = rpc_localaddr(clp->cl_rpcclient, sap, sizeof(cb_addr));
+		if (err < 0)
+			goto error;
+		err = rpc_ntop(sap, buf, sizeof(buf));
+		if (err < 0)
+			goto error;
+		ip_addr = (const char *)buf;
+	}
+	strlcpy(clp->cl_ipaddr, ip_addr, sizeof(clp->cl_ipaddr));
+
+	err = nfs_idmap_new(clp);
+	if (err < 0) {
+		dprintk("%s: failed to create idmapper. Error = %d\n",
+			__func__, err);
+		goto error;
+	}
+	__set_bit(NFS_CS_IDMAP, &clp->cl_res_state);
 	return clp;
 
 error:
@@ -354,8 +395,6 @@ static int nfs4_init_client_minor_versio
 struct nfs_client *nfs4_init_client(struct nfs_client *clp,
 				    const struct nfs_client_initdata *cl_init)
 {
-	char buf[INET6_ADDRSTRLEN + 1];
-	const char *ip_addr = cl_init->ip_addr;
 	struct nfs_client *old;
 	int error;
 
@@ -363,43 +402,6 @@ struct nfs_client *nfs4_init_client(stru
 		/* the client is initialised already */
 		return clp;
 
-	/* Check NFS protocol revision and initialize RPC op vector */
-	clp->rpc_ops = &nfs_v4_clientops;
-
-	if (clp->cl_minorversion != 0)
-		__set_bit(NFS_CS_INFINITE_SLOTS, &clp->cl_flags);
-	__set_bit(NFS_CS_DISCRTRY, &clp->cl_flags);
-	__set_bit(NFS_CS_NO_RETRANS_TIMEOUT, &clp->cl_flags);
-
-	error = nfs_create_rpc_client(clp, cl_init, RPC_AUTH_GSS_KRB5I);
-	if (error == -EINVAL)
-		error = nfs_create_rpc_client(clp, cl_init, RPC_AUTH_UNIX);
-	if (error < 0)
-		goto error;
-
-	/* If no clientaddr= option was specified, find a usable cb address */
-	if (ip_addr == NULL) {
-		struct sockaddr_storage cb_addr;
-		struct sockaddr *sap = (struct sockaddr *)&cb_addr;
-
-		error = rpc_localaddr(clp->cl_rpcclient, sap, sizeof(cb_addr));
-		if (error < 0)
-			goto error;
-		error = rpc_ntop(sap, buf, sizeof(buf));
-		if (error < 0)
-			goto error;
-		ip_addr = (const char *)buf;
-	}
-	strlcpy(clp->cl_ipaddr, ip_addr, sizeof(clp->cl_ipaddr));
-
-	error = nfs_idmap_new(clp);
-	if (error < 0) {
-		dprintk("%s: failed to create idmapper. Error = %d\n",
-			__func__, error);
-		goto error;
-	}
-	__set_bit(NFS_CS_IDMAP, &clp->cl_res_state);
-
 	error = nfs4_init_client_minor_version(clp);
 	if (error < 0)
 		goto error;


