Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8444C18A5E8
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 22:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbgCRVEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 17:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728257AbgCRUzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:55:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDA5F208E4;
        Wed, 18 Mar 2020 20:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564916;
        bh=8gWxQB1hy2Rs45/USgNRR4m1Ti7GPXXLLt/ZXidVBr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPE6kgigtu1BukX5TZmv3drvh2TSwTekEpAwY/i9zB58kex8uVL9r1iQHiZ1/abrh
         iGbs/2eDvY6xUZsCIKdQXZrUvB8bqT+CvaDiOfgZZ3IZg9T/kBEZXfH6Y9WDHZ7nS1
         4TC1mCGE6uZA3e5EN/IQBNtCFfDC7+iFqsD2eI58=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Scott Mayhew <smayhew@redhat.com>,
        Dave Wysochanski <dwysocha@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/37] nfs: add minor version to nfs_server_key for fscache
Date:   Wed, 18 Mar 2020 16:54:37 -0400
Message-Id: <20200318205509.17053-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205509.17053-1-sashal@kernel.org>
References: <20200318205509.17053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 0a2b59c1ecb3d..07c5ddd5d6d50 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -157,6 +157,7 @@ struct nfs_client *nfs_alloc_client(const struct nfs_client_initdata *cl_init)
 	if ((clp = kzalloc(sizeof(*clp), GFP_KERNEL)) == NULL)
 		goto error_0;
 
+	clp->cl_minorversion = cl_init->minorversion;
 	clp->cl_nfs_mod = cl_init->nfs_mod;
 	if (!try_module_get(clp->cl_nfs_mod->owner))
 		goto error_dealloc;
diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index a7bc4e0494f92..6f45b1a957397 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -35,6 +35,7 @@ static DEFINE_SPINLOCK(nfs_fscache_keys_lock);
 struct nfs_server_key {
 	struct {
 		uint16_t	nfsversion;		/* NFS protocol version */
+		uint32_t	minorversion;		/* NFSv4 minor version */
 		uint16_t	family;			/* address family */
 		__be16		port;			/* IP port */
 	} hdr;
@@ -59,6 +60,7 @@ void nfs_fscache_get_client_cookie(struct nfs_client *clp)
 
 	memset(&key, 0, sizeof(key));
 	key.hdr.nfsversion = clp->rpc_ops->version;
+	key.hdr.minorversion = clp->cl_minorversion;
 	key.hdr.family = clp->cl_addr.ss_family;
 
 	switch (clp->cl_addr.ss_family) {
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 86991bcfbeb12..faaabbedc891d 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -210,7 +210,6 @@ struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
 	INIT_LIST_HEAD(&clp->cl_ds_clients);
 	rpc_init_wait_queue(&clp->cl_rpcwaitq, "NFS client");
 	clp->cl_state = 1 << NFS4CLNT_LEASE_EXPIRED;
-	clp->cl_minorversion = cl_init->minorversion;
 	clp->cl_mvops = nfs_v4_minor_ops[cl_init->minorversion];
 	clp->cl_mig_gen = 1;
 #if IS_ENABLED(CONFIG_NFS_V4_1)
-- 
2.20.1

