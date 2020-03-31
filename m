Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10A3C198F95
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbgCaJEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:04:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730981AbgCaJEg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:04:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CEBB20675;
        Tue, 31 Mar 2020 09:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645475;
        bh=ztCb4QjpjJS95pKFatfKpFF+V1RYi6Jlppehs5ldGno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwPmGtX/8oPRZ3ZlG8dveNWBJ+GlrlSJhJ+v/o47ttw/317rmTV3ZKaUCYb9scjPs
         2ppL7d3H2RZt+w4e2JiPKf4HTEDy9PzAFl6BKaDlRG64jbgf0pB5bY37tZRbvQZQw5
         LLNG8AA+dKg5+gJVxKJjm8/kXIGxq1/tmBx2mCoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Mayhew <smayhew@redhat.com>,
        Dave Wysochanski <dwysocha@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 065/170] nfs: add minor version to nfs_server_key for fscache
Date:   Tue, 31 Mar 2020 10:57:59 +0200
Message-Id: <20200331085431.384466427@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit 55dee1bc0d72877b99805e42e0205087e98b9edd ]

An NFS client that mounts multiple exports from the same NFS
server with higher NFSv4 versions disabled (i.e. 4.2) and without
forcing a specific NFS version results in fscache index cookie
collisions and the following messages:
[  570.004348] FS-Cache: Duplicate cookie detected

Each nfs_client structure should have its own fscache index cookie,
so add the minorversion to nfs_server_key.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=200145
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/client.c     | 1 +
 fs/nfs/fscache.c    | 2 ++
 fs/nfs/nfs4client.c | 1 -
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 02110a30a49ea..a851339defeb5 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -153,6 +153,7 @@ struct nfs_client *nfs_alloc_client(const struct nfs_client_initdata *cl_init)
 	if ((clp = kzalloc(sizeof(*clp), GFP_KERNEL)) == NULL)
 		goto error_0;
 
+	clp->cl_minorversion = cl_init->minorversion;
 	clp->cl_nfs_mod = cl_init->nfs_mod;
 	if (!try_module_get(clp->cl_nfs_mod->owner))
 		goto error_dealloc;
diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index 3800ab6f08fa8..a6dcc2151e779 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -31,6 +31,7 @@ static DEFINE_SPINLOCK(nfs_fscache_keys_lock);
 struct nfs_server_key {
 	struct {
 		uint16_t	nfsversion;		/* NFS protocol version */
+		uint32_t	minorversion;		/* NFSv4 minor version */
 		uint16_t	family;			/* address family */
 		__be16		port;			/* IP port */
 	} hdr;
@@ -55,6 +56,7 @@ void nfs_fscache_get_client_cookie(struct nfs_client *clp)
 
 	memset(&key, 0, sizeof(key));
 	key.hdr.nfsversion = clp->rpc_ops->version;
+	key.hdr.minorversion = clp->cl_minorversion;
 	key.hdr.family = clp->cl_addr.ss_family;
 
 	switch (clp->cl_addr.ss_family) {
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 460d6251c405f..2c274fea80937 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -216,7 +216,6 @@ struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
 	INIT_LIST_HEAD(&clp->cl_ds_clients);
 	rpc_init_wait_queue(&clp->cl_rpcwaitq, "NFS client");
 	clp->cl_state = 1 << NFS4CLNT_LEASE_EXPIRED;
-	clp->cl_minorversion = cl_init->minorversion;
 	clp->cl_mvops = nfs_v4_minor_ops[cl_init->minorversion];
 	clp->cl_mig_gen = 1;
 #if IS_ENABLED(CONFIG_NFS_V4_1)
-- 
2.20.1



