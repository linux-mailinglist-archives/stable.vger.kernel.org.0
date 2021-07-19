Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853EE3CDEE0
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344712AbhGSPGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:32940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345460AbhGSPE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:04:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36B3B6124B;
        Mon, 19 Jul 2021 15:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709439;
        bh=xwVusAZo2l4+4OovzmQa90BurM6osiTiK5JpcBU55to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFZ5Kg5sEWkDoFVijcinDRpREzkW0hzzbAo8wbOl73UNoOpfdc+XLrXuZ4GB07vGQ
         NtDUGkrUWngyrhwj5gp4ZpXS9qHYytOjcaM9VU4h+d/ea0NMbWXc9MxBtuxrohERrt
         IEijgdQddrz7c4aMsHl9rHSvMbV3SkBOSKQhWrSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Wakabayashi <mwakabayashi@vmware.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 384/421] NFSv4: Initialise connection to the server in nfs4_alloc_client()
Date:   Mon, 19 Jul 2021 16:53:15 +0200
Message-Id: <20210719144959.693404606@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit dd99e9f98fbf423ff6d365b37a98e8879170f17c ]

Set up the connection to the NFSv4 server in nfs4_alloc_client(), before
we've added the struct nfs_client to the net-namespace's nfs_client_list
so that a downed server won't cause other mounts to hang in the trunking
detection code.

Reported-by: Michael Wakabayashi <mwakabayashi@vmware.com>
Fixes: 5c6e5b60aae4 ("NFS: Fix an Oops in the pNFS files and flexfiles connection setup to the DS")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4client.c | 82 +++++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 40 deletions(-)

diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index b5ce70c4ec87..43659326b519 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -191,8 +191,11 @@ void nfs40_shutdown_client(struct nfs_client *clp)
 
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
 
@@ -216,6 +219,44 @@ struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
 	init_waitqueue_head(&clp->cl_lock_waitq);
 #endif
 	INIT_LIST_HEAD(&clp->pending_cb_stateids);
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
@@ -368,8 +409,6 @@ static int nfs4_init_client_minor_version(struct nfs_client *clp)
 struct nfs_client *nfs4_init_client(struct nfs_client *clp,
 				    const struct nfs_client_initdata *cl_init)
 {
-	char buf[INET6_ADDRSTRLEN + 1];
-	const char *ip_addr = cl_init->ip_addr;
 	struct nfs_client *old;
 	int error;
 
@@ -377,43 +416,6 @@ struct nfs_client *nfs4_init_client(struct nfs_client *clp,
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
-- 
2.30.2



