Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8082D4A8E0E
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344427AbiBCUe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354308AbiBCUde (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:33:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09D6C061744;
        Thu,  3 Feb 2022 12:33:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FA67B835A4;
        Thu,  3 Feb 2022 20:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693F5C340E8;
        Thu,  3 Feb 2022 20:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920379;
        bh=gkL8Vhx+Y2W9TmcfN1hjq7QpuebVaxEuzgFbJ3u5pww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ffe7JEkg8bIwUI35HGHpGL5w2OOpo3v+anf+NG6ejjP14UPj7V8ZNYV1buNAXa1MW
         CMCfPq8EHK5IVMQZGUa6WaLrRZ0ZVjTnNZZ9+jqrrwdfhIPaJC2c+HEJF84QgSfQ13
         tK7RweqRBcbQ5Kw7qp0DoEpsVg4Th/wC66wCl2DPhiZd9vjW5i7VYcKIYXlGQjfYFj
         ua5nclIFYVWPLr6zk8TqIBWKv1C7LRr+5hAlmA2bEA9vZLudmxZ4CA+fqGdc474Xp9
         lUQeQyvSjoXLxhS9rwNNjtRMCWyDJbfoFj8B7BCFkv/JlZwBmC/5Y+1rPPArdPrd7b
         JjfdXQlG15nNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 08/41] NFSv4.1 query for fs_location attr on a new file system
Date:   Thu,  3 Feb 2022 15:32:12 -0500
Message-Id: <20220203203245.3007-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 1976b2b31462151403c9fc110204fcc2a77bdfd1 ]

Query the server for other possible trunkable locations for a given
file system on a 4.1+ mount.

v2:
-- added missing static to nfs4_discover_trunking,
reported by the kernel test robot

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/client.c         |  7 ++++
 fs/nfs/nfs4_fs.h        |  9 ++---
 fs/nfs/nfs4proc.c       | 76 +++++++++++++++++++++++++++++++++++------
 fs/nfs/nfs4state.c      |  3 +-
 include/linux/nfs_xdr.h |  1 +
 5 files changed, 81 insertions(+), 15 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 23e165d5ec9ca..d7a8636581266 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -860,6 +860,13 @@ int nfs_probe_fsinfo(struct nfs_server *server, struct nfs_fh *mntfh, struct nfs
 			server->namelen = pathinfo.max_namelen;
 	}
 
+	if (clp->rpc_ops->discover_trunking != NULL &&
+			(server->caps & NFS_CAP_FS_LOCATIONS)) {
+		error = clp->rpc_ops->discover_trunking(server, mntfh);
+		if (error < 0)
+			return error;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nfs_probe_fsinfo);
diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index ba78df4b13d94..1a048ee653a11 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -261,8 +261,8 @@ struct nfs4_state_maintenance_ops {
 };
 
 struct nfs4_mig_recovery_ops {
-	int (*get_locations)(struct inode *, struct nfs4_fs_locations *,
-		struct page *, const struct cred *);
+	int (*get_locations)(struct nfs_server *, struct nfs_fh *,
+		struct nfs4_fs_locations *, struct page *, const struct cred *);
 	int (*fsid_present)(struct inode *, const struct cred *);
 };
 
@@ -303,8 +303,9 @@ extern int nfs4_do_close(struct nfs4_state *state, gfp_t gfp_mask, int wait);
 extern int nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *fhandle);
 extern int nfs4_proc_fs_locations(struct rpc_clnt *, struct inode *, const struct qstr *,
 				  struct nfs4_fs_locations *, struct page *);
-extern int nfs4_proc_get_locations(struct inode *, struct nfs4_fs_locations *,
-		struct page *page, const struct cred *);
+extern int nfs4_proc_get_locations(struct nfs_server *, struct nfs_fh *,
+				   struct nfs4_fs_locations *,
+				   struct page *page, const struct cred *);
 extern int nfs4_proc_fsid_present(struct inode *, const struct cred *);
 extern struct rpc_clnt *nfs4_proc_lookup_mountpoint(struct inode *,
 						    struct dentry *,
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 367a1b99b7550..389fa72d4ca98 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3952,6 +3952,60 @@ int nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *fhandle)
 	return err;
 }
 
+static int _nfs4_discover_trunking(struct nfs_server *server,
+				   struct nfs_fh *fhandle)
+{
+	struct nfs4_fs_locations *locations = NULL;
+	struct page *page;
+	const struct cred *cred;
+	struct nfs_client *clp = server->nfs_client;
+	const struct nfs4_state_maintenance_ops *ops =
+		clp->cl_mvops->state_renewal_ops;
+	int status = -ENOMEM;
+
+	cred = ops->get_state_renewal_cred(clp);
+	if (cred == NULL) {
+		cred = nfs4_get_clid_cred(clp);
+		if (cred == NULL)
+			return -ENOKEY;
+	}
+
+	page = alloc_page(GFP_KERNEL);
+	locations = kmalloc(sizeof(struct nfs4_fs_locations), GFP_KERNEL);
+	if (page == NULL || locations == NULL)
+		goto out;
+
+	status = nfs4_proc_get_locations(server, fhandle, locations, page,
+					 cred);
+	if (status)
+		goto out;
+out:
+	if (page)
+		__free_page(page);
+	kfree(locations);
+	return status;
+}
+
+static int nfs4_discover_trunking(struct nfs_server *server,
+				  struct nfs_fh *fhandle)
+{
+	struct nfs4_exception exception = {
+		.interruptible = true,
+	};
+	struct nfs_client *clp = server->nfs_client;
+	int err = 0;
+
+	if (!nfs4_has_session(clp))
+		goto out;
+	do {
+		err = nfs4_handle_exception(server,
+				_nfs4_discover_trunking(server, fhandle),
+				&exception);
+	} while (exception.retry);
+out:
+	return err;
+}
+
 static int _nfs4_lookup_root(struct nfs_server *server, struct nfs_fh *fhandle,
 		struct nfs_fsinfo *info)
 {
@@ -7886,18 +7940,18 @@ int nfs4_proc_fs_locations(struct rpc_clnt *client, struct inode *dir,
  * appended to this compound to identify the client ID which is
  * performing recovery.
  */
-static int _nfs40_proc_get_locations(struct inode *inode,
+static int _nfs40_proc_get_locations(struct nfs_server *server,
+				     struct nfs_fh *fhandle,
 				     struct nfs4_fs_locations *locations,
 				     struct page *page, const struct cred *cred)
 {
-	struct nfs_server *server = NFS_SERVER(inode);
 	struct rpc_clnt *clnt = server->client;
 	u32 bitmask[2] = {
 		[0] = FATTR4_WORD0_FSID | FATTR4_WORD0_FS_LOCATIONS,
 	};
 	struct nfs4_fs_locations_arg args = {
 		.clientid	= server->nfs_client->cl_clientid,
-		.fh		= NFS_FH(inode),
+		.fh		= fhandle,
 		.page		= page,
 		.bitmask	= bitmask,
 		.migration	= 1,		/* skip LOOKUP */
@@ -7943,17 +7997,17 @@ static int _nfs40_proc_get_locations(struct inode *inode,
  * When the client supports GETATTR(fs_locations_info), it can
  * be plumbed in here.
  */
-static int _nfs41_proc_get_locations(struct inode *inode,
+static int _nfs41_proc_get_locations(struct nfs_server *server,
+				     struct nfs_fh *fhandle,
 				     struct nfs4_fs_locations *locations,
 				     struct page *page, const struct cred *cred)
 {
-	struct nfs_server *server = NFS_SERVER(inode);
 	struct rpc_clnt *clnt = server->client;
 	u32 bitmask[2] = {
 		[0] = FATTR4_WORD0_FSID | FATTR4_WORD0_FS_LOCATIONS,
 	};
 	struct nfs4_fs_locations_arg args = {
-		.fh		= NFS_FH(inode),
+		.fh		= fhandle,
 		.page		= page,
 		.bitmask	= bitmask,
 		.migration	= 1,		/* skip LOOKUP */
@@ -8002,11 +8056,11 @@ static int _nfs41_proc_get_locations(struct inode *inode,
  * -NFS4ERR_LEASE_MOVED is returned if the server still has leases
  * from this client that require migration recovery.
  */
-int nfs4_proc_get_locations(struct inode *inode,
+int nfs4_proc_get_locations(struct nfs_server *server,
+			    struct nfs_fh *fhandle,
 			    struct nfs4_fs_locations *locations,
 			    struct page *page, const struct cred *cred)
 {
-	struct nfs_server *server = NFS_SERVER(inode);
 	struct nfs_client *clp = server->nfs_client;
 	const struct nfs4_mig_recovery_ops *ops =
 					clp->cl_mvops->mig_recovery_ops;
@@ -8019,10 +8073,11 @@ int nfs4_proc_get_locations(struct inode *inode,
 		(unsigned long long)server->fsid.major,
 		(unsigned long long)server->fsid.minor,
 		clp->cl_hostname);
-	nfs_display_fhandle(NFS_FH(inode), __func__);
+	nfs_display_fhandle(fhandle, __func__);
 
 	do {
-		status = ops->get_locations(inode, locations, page, cred);
+		status = ops->get_locations(server, fhandle, locations, page,
+					    cred);
 		if (status != -NFS4ERR_DELAY)
 			break;
 		nfs4_handle_exception(server, status, &exception);
@@ -10516,6 +10571,7 @@ const struct nfs_rpc_ops nfs_v4_clientops = {
 	.free_client	= nfs4_free_client,
 	.create_server	= nfs4_create_server,
 	.clone_server	= nfs_clone_server,
+	.discover_trunking = nfs4_discover_trunking,
 };
 
 static const struct xattr_handler nfs4_xattr_nfs4_acl_handler = {
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index acc1cd3e63a48..51f5cb41e87a4 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2097,7 +2097,8 @@ static int nfs4_try_migration(struct nfs_server *server, const struct cred *cred
 	}
 
 	inode = d_inode(server->super->s_root);
-	result = nfs4_proc_get_locations(inode, locations, page, cred);
+	result = nfs4_proc_get_locations(server, NFS_FH(inode), locations,
+					 page, cred);
 	if (result) {
 		dprintk("<-- %s: failed to retrieve fs_locations: %d\n",
 			__func__, result);
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index e9698b6278a52..ecd74cc347974 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1805,6 +1805,7 @@ struct nfs_rpc_ops {
 	struct nfs_server *(*create_server)(struct fs_context *);
 	struct nfs_server *(*clone_server)(struct nfs_server *, struct nfs_fh *,
 					   struct nfs_fattr *, rpc_authflavor_t);
+	int	(*discover_trunking)(struct nfs_server *, struct nfs_fh *);
 };
 
 /*
-- 
2.34.1

