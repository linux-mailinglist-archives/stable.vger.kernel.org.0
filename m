Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6ED56B485F
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbjCJPB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbjCJPB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:01:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B033512A17B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:54:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E07A3B82317
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41457C4339B;
        Fri, 10 Mar 2023 14:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460065;
        bh=UM/bUg3u7jw5KzIim48Z2bxrtB08curykIV3qGVj2a0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2zfXbbOcy6REdHPgPKJwrbnX0SgJ2959ERQygQWgEY3YUKqiA6awlKEfgE49lqQF
         X7EqPW/nH5w8kLj7KNW0qDqEPtagHvn8mieRLyHbPuy7vcm7vWBB4BaxzxqQqt4IGg
         lKN3rynN6gDyqir2JJQ0cYK11IPAKcnVFM6tREYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/529] NFSv4: keep state manager thread active if swap is enabled
Date:   Fri, 10 Mar 2023 14:35:53 +0100
Message-Id: <20230310133814.737827951@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

[ Upstream commit 4dc73c679114a2f408567e2e44770ed934190db2 ]

If we are swapping over NFSv4, we may not be able to allocate memory to
start the state-manager thread at the time when we need it.
So keep it always running when swap is enabled, and just signal it to
start.

This requires updating and testing the cl_swapper count on the root
rpc_clnt after following all ->cl_parent links.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: b46d80bd2d6e ("nfs4trace: fix state manager flag printing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/file.c           | 15 ++++++++++++---
 fs/nfs/nfs4_fs.h        |  1 +
 fs/nfs/nfs4proc.c       | 20 ++++++++++++++++++++
 fs/nfs/nfs4state.c      | 40 +++++++++++++++++++++++++++++++++-------
 include/linux/nfs_xdr.h |  2 ++
 net/sunrpc/clnt.c       |  2 ++
 6 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index ad856b7b9a46c..7be1a7f7fcb2a 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -487,8 +487,9 @@ static int nfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 {
 	unsigned long blocks;
 	long long isize;
-	struct rpc_clnt *clnt = NFS_CLIENT(file->f_mapping->host);
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = file_inode(file);
+	struct rpc_clnt *clnt = NFS_CLIENT(inode);
+	struct nfs_client *cl = NFS_SERVER(inode)->nfs_client;
 
 	spin_lock(&inode->i_lock);
 	blocks = inode->i_blocks;
@@ -501,14 +502,22 @@ static int nfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 
 	*span = sis->pages;
 
+
+	if (cl->rpc_ops->enable_swap)
+		cl->rpc_ops->enable_swap(inode);
+
 	return rpc_clnt_swap_activate(clnt);
 }
 
 static void nfs_swap_deactivate(struct file *file)
 {
-	struct rpc_clnt *clnt = NFS_CLIENT(file->f_mapping->host);
+	struct inode *inode = file_inode(file);
+	struct rpc_clnt *clnt = NFS_CLIENT(inode);
+	struct nfs_client *cl = NFS_SERVER(inode)->nfs_client;
 
 	rpc_clnt_swap_deactivate(clnt);
+	if (cl->rpc_ops->disable_swap)
+		cl->rpc_ops->disable_swap(file_inode(file));
 }
 
 const struct address_space_operations nfs_file_aops = {
diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index 6d916563356ef..8b41c0b8624e3 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -42,6 +42,7 @@ enum nfs4_client_state {
 	NFS4CLNT_LEASE_MOVED,
 	NFS4CLNT_DELEGATION_EXPIRED,
 	NFS4CLNT_RUN_MANAGER,
+	NFS4CLNT_MANAGER_AVAILABLE,
 	NFS4CLNT_RECALL_RUNNING,
 	NFS4CLNT_RECALL_ANY_LAYOUT_READ,
 	NFS4CLNT_RECALL_ANY_LAYOUT_RW,
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index ee46ab09e3306..8f502e2ac34fd 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10385,6 +10385,24 @@ static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
 	return error + error2 + error3;
 }
 
+static void nfs4_enable_swap(struct inode *inode)
+{
+	/* The state manager thread must always be running.
+	 * It will notice the client is a swapper, and stay put.
+	 */
+	struct nfs_client *clp = NFS_SERVER(inode)->nfs_client;
+
+	nfs4_schedule_state_manager(clp);
+}
+
+static void nfs4_disable_swap(struct inode *inode)
+{
+	/* The state manager thread will now exit once it is
+	 * woken.
+	 */
+	wake_up_var(&NFS_SERVER(inode)->nfs_client->cl_state);
+}
+
 static const struct inode_operations nfs4_dir_inode_operations = {
 	.create		= nfs_create,
 	.lookup		= nfs_lookup,
@@ -10461,6 +10479,8 @@ const struct nfs_rpc_ops nfs_v4_clientops = {
 	.free_client	= nfs4_free_client,
 	.create_server	= nfs4_create_server,
 	.clone_server	= nfs_clone_server,
+	.enable_swap	= nfs4_enable_swap,
+	.disable_swap	= nfs4_disable_swap,
 };
 
 static const struct xattr_handler nfs4_xattr_nfs4_acl_handler = {
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 175b2e064003e..628e030f8e3ba 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1208,10 +1208,17 @@ void nfs4_schedule_state_manager(struct nfs_client *clp)
 {
 	struct task_struct *task;
 	char buf[INET6_ADDRSTRLEN + sizeof("-manager") + 1];
+	struct rpc_clnt *cl = clp->cl_rpcclient;
+
+	while (cl != cl->cl_parent)
+		cl = cl->cl_parent;
 
 	set_bit(NFS4CLNT_RUN_MANAGER, &clp->cl_state);
-	if (test_and_set_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state) != 0)
+	if (test_and_set_bit(NFS4CLNT_MANAGER_AVAILABLE, &clp->cl_state) != 0) {
+		wake_up_var(&clp->cl_state);
 		return;
+	}
+	set_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state);
 	__module_get(THIS_MODULE);
 	refcount_inc(&clp->cl_count);
 
@@ -1229,6 +1236,7 @@ void nfs4_schedule_state_manager(struct nfs_client *clp)
 		if (!nfs_client_init_is_complete(clp))
 			nfs_mark_client_ready(clp, PTR_ERR(task));
 		nfs4_clear_state_manager_bit(clp);
+		clear_bit(NFS4CLNT_MANAGER_AVAILABLE, &clp->cl_state);
 		nfs_put_client(clp);
 		module_put(THIS_MODULE);
 	}
@@ -2680,12 +2688,8 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			clear_bit(NFS4CLNT_RECALL_RUNNING, &clp->cl_state);
 		}
 
-		/* Did we race with an attempt to give us more work? */
-		if (!test_bit(NFS4CLNT_RUN_MANAGER, &clp->cl_state))
-			return;
-		if (test_and_set_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state) != 0)
-			return;
-		memflags = memalloc_nofs_save();
+		return;
+
 	} while (refcount_read(&clp->cl_count) > 1 && !signalled());
 	goto out_drain;
 
@@ -2706,9 +2710,31 @@ static void nfs4_state_manager(struct nfs_client *clp)
 static int nfs4_run_state_manager(void *ptr)
 {
 	struct nfs_client *clp = ptr;
+	struct rpc_clnt *cl = clp->cl_rpcclient;
+
+	while (cl != cl->cl_parent)
+		cl = cl->cl_parent;
 
 	allow_signal(SIGKILL);
+again:
+	set_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state);
 	nfs4_state_manager(clp);
+	if (atomic_read(&cl->cl_swapper)) {
+		wait_var_event_interruptible(&clp->cl_state,
+					     test_bit(NFS4CLNT_RUN_MANAGER,
+						      &clp->cl_state));
+		if (atomic_read(&cl->cl_swapper) &&
+		    test_bit(NFS4CLNT_RUN_MANAGER, &clp->cl_state))
+			goto again;
+		/* Either no longer a swapper, or were signalled */
+	}
+	clear_bit(NFS4CLNT_MANAGER_AVAILABLE, &clp->cl_state);
+
+	if (refcount_read(&clp->cl_count) > 1 && !signalled() &&
+	    test_bit(NFS4CLNT_RUN_MANAGER, &clp->cl_state) &&
+	    !test_and_set_bit(NFS4CLNT_MANAGER_AVAILABLE, &clp->cl_state))
+		goto again;
+
 	nfs_put_client(clp);
 	module_put_and_exit(0);
 	return 0;
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 5491ad5f48a94..33442fd018a06 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1789,6 +1789,8 @@ struct nfs_rpc_ops {
 	struct nfs_server *(*create_server)(struct fs_context *);
 	struct nfs_server *(*clone_server)(struct nfs_server *, struct nfs_fh *,
 					   struct nfs_fattr *, rpc_authflavor_t);
+	void	(*enable_swap)(struct inode *inode);
+	void	(*disable_swap)(struct inode *inode);
 };
 
 /*
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index c478108ca6a65..e190d38c4c827 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -3026,6 +3026,8 @@ rpc_clnt_swap_activate_callback(struct rpc_clnt *clnt,
 int
 rpc_clnt_swap_activate(struct rpc_clnt *clnt)
 {
+	while (clnt != clnt->cl_parent)
+		clnt = clnt->cl_parent;
 	if (atomic_inc_return(&clnt->cl_swapper) == 1)
 		return rpc_clnt_iterate_for_each_xprt(clnt,
 				rpc_clnt_swap_activate_callback, NULL);
-- 
2.39.2



