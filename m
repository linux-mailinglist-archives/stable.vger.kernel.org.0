Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED6754168F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376979AbiFGUxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376862AbiFGUsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:48:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC011F6B4F;
        Tue,  7 Jun 2022 11:39:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEEDEB8233E;
        Tue,  7 Jun 2022 18:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E4AC34115;
        Tue,  7 Jun 2022 18:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627184;
        bh=Wzn/hK4cWaEOLU/IasUp3MU3BIEDv4cF6XkyHM9hXOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7nWPFMCskisiW5a7nI0G9t5QuLEGcdZvUrObpiaFlSnGc/E8jj68Sf1XK8cEvuAh
         hx5n0NYg+r49mObyq4ar4FEsGliIFs/H6dAXzfHDSAcIdTeA5Q6OIM3U8uQkr6fqay
         HIDKcP7DyRkDrrIv9IaSzVAKcB44roFndTyqRhxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 608/772] NFSv4.1 mark qualified async operations as MOVEABLE tasks
Date:   Tue,  7 Jun 2022 19:03:20 +0200
Message-Id: <20220607165006.857293822@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 118f09eda21d392e1eeb9f8a4bee044958cccf20 ]

Mark async operations such as RENAME, REMOVE, COMMIT MOVEABLE
for the nfsv4.1+ sessions.

Fixes: 85e39feead948 ("NFSv4.1 identify and mark RPC tasks that can move between transports")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c         | 26 ++++++++++++++------------
 fs/nfs/pagelist.c         |  3 +++
 fs/nfs/unlink.c           |  8 ++++++++
 fs/nfs/write.c            |  4 ++++
 include/linux/nfs_fs_sb.h |  1 +
 5 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index bbc99dbb3df5..476dca7ce7ab 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1162,7 +1162,7 @@ static int nfs4_call_sync_sequence(struct rpc_clnt *clnt,
 {
 	unsigned short task_flags = 0;
 
-	if (server->nfs_client->cl_minorversion)
+	if (server->caps & NFS_CAP_MOVEABLE)
 		task_flags = RPC_TASK_MOVEABLE;
 	return nfs4_do_call_sync(clnt, server, msg, args, res, task_flags);
 }
@@ -2573,7 +2573,7 @@ static int nfs4_run_open_task(struct nfs4_opendata *data,
 	};
 	int status;
 
-	if (server->nfs_client->cl_minorversion)
+	if (nfs_server_capable(dir, NFS_CAP_MOVEABLE))
 		task_setup_data.flags |= RPC_TASK_MOVEABLE;
 
 	kref_get(&data->kref);
@@ -3736,7 +3736,7 @@ int nfs4_do_close(struct nfs4_state *state, gfp_t gfp_mask, int wait)
 	};
 	int status = -ENOMEM;
 
-	if (server->nfs_client->cl_minorversion)
+	if (nfs_server_capable(state->inode, NFS_CAP_MOVEABLE))
 		task_setup_data.flags |= RPC_TASK_MOVEABLE;
 
 	nfs4_state_protect(server->nfs_client, NFS_SP4_MACH_CRED_CLEANUP,
@@ -4406,7 +4406,7 @@ static int _nfs4_proc_lookup(struct rpc_clnt *clnt, struct inode *dir,
 	};
 	unsigned short task_flags = 0;
 
-	if (server->nfs_client->cl_minorversion)
+	if (nfs_server_capable(dir, NFS_CAP_MOVEABLE))
 		task_flags = RPC_TASK_MOVEABLE;
 
 	/* Is this is an attribute revalidation, subject to softreval? */
@@ -6614,10 +6614,13 @@ static int _nfs4_proc_delegreturn(struct inode *inode, const struct cred *cred,
 		.rpc_client = server->client,
 		.rpc_message = &msg,
 		.callback_ops = &nfs4_delegreturn_ops,
-		.flags = RPC_TASK_ASYNC | RPC_TASK_TIMEOUT | RPC_TASK_MOVEABLE,
+		.flags = RPC_TASK_ASYNC | RPC_TASK_TIMEOUT,
 	};
 	int status = 0;
 
+	if (nfs_server_capable(inode, NFS_CAP_MOVEABLE))
+		task_setup_data.flags |= RPC_TASK_MOVEABLE;
+
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
@@ -6931,10 +6934,8 @@ static struct rpc_task *nfs4_do_unlck(struct file_lock *fl,
 		.workqueue = nfsiod_workqueue,
 		.flags = RPC_TASK_ASYNC,
 	};
-	struct nfs_client *client =
-		NFS_SERVER(lsp->ls_state->inode)->nfs_client;
 
-	if (client->cl_minorversion)
+	if (nfs_server_capable(lsp->ls_state->inode, NFS_CAP_MOVEABLE))
 		task_setup_data.flags |= RPC_TASK_MOVEABLE;
 
 	nfs4_state_protect(NFS_SERVER(lsp->ls_state->inode)->nfs_client,
@@ -7205,9 +7206,8 @@ static int _nfs4_do_setlk(struct nfs4_state *state, int cmd, struct file_lock *f
 		.flags = RPC_TASK_ASYNC | RPC_TASK_CRED_NOREF,
 	};
 	int ret;
-	struct nfs_client *client = NFS_SERVER(state->inode)->nfs_client;
 
-	if (client->cl_minorversion)
+	if (nfs_server_capable(state->inode, NFS_CAP_MOVEABLE))
 		task_setup_data.flags |= RPC_TASK_MOVEABLE;
 
 	data = nfs4_alloc_lockdata(fl, nfs_file_open_context(fl->fl_file),
@@ -10380,7 +10380,8 @@ static const struct nfs4_minor_version_ops nfs_v4_1_minor_ops = {
 		| NFS_CAP_POSIX_LOCK
 		| NFS_CAP_STATEID_NFSV41
 		| NFS_CAP_ATOMIC_OPEN_V1
-		| NFS_CAP_LGOPEN,
+		| NFS_CAP_LGOPEN
+		| NFS_CAP_MOVEABLE,
 	.init_client = nfs41_init_client,
 	.shutdown_client = nfs41_shutdown_client,
 	.match_stateid = nfs41_match_stateid,
@@ -10415,7 +10416,8 @@ static const struct nfs4_minor_version_ops nfs_v4_2_minor_ops = {
 		| NFS_CAP_LAYOUTSTATS
 		| NFS_CAP_CLONE
 		| NFS_CAP_LAYOUTERROR
-		| NFS_CAP_READ_PLUS,
+		| NFS_CAP_READ_PLUS
+		| NFS_CAP_MOVEABLE,
 	.init_client = nfs41_init_client,
 	.shutdown_client = nfs41_shutdown_client,
 	.match_stateid = nfs41_match_stateid,
diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index 9157dd19b8b4..317cedfa52bf 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -767,6 +767,9 @@ int nfs_initiate_pgio(struct rpc_clnt *clnt, struct nfs_pgio_header *hdr,
 		.flags = RPC_TASK_ASYNC | flags,
 	};
 
+	if (nfs_server_capable(hdr->inode, NFS_CAP_MOVEABLE))
+		task_setup_data.flags |= RPC_TASK_MOVEABLE;
+
 	hdr->rw_ops->rw_initiate(hdr, &msg, rpc_ops, &task_setup_data, how);
 
 	dprintk("NFS: initiated pgio call "
diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index 5fa11e1aca4c..d5ccf095b2a7 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -102,6 +102,10 @@ static void nfs_do_call_unlink(struct inode *inode, struct nfs_unlinkdata *data)
 	};
 	struct rpc_task *task;
 	struct inode *dir = d_inode(data->dentry->d_parent);
+
+	if (nfs_server_capable(inode, NFS_CAP_MOVEABLE))
+		task_setup_data.flags |= RPC_TASK_MOVEABLE;
+
 	nfs_sb_active(dir->i_sb);
 	data->args.fh = NFS_FH(dir);
 	nfs_fattr_init(data->res.dir_attr);
@@ -344,6 +348,10 @@ nfs_async_rename(struct inode *old_dir, struct inode *new_dir,
 		.flags = RPC_TASK_ASYNC | RPC_TASK_CRED_NOREF,
 	};
 
+	if (nfs_server_capable(old_dir, NFS_CAP_MOVEABLE) &&
+	    nfs_server_capable(new_dir, NFS_CAP_MOVEABLE))
+		task_setup_data.flags |= RPC_TASK_MOVEABLE;
+
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return ERR_PTR(-ENOMEM);
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 477162d2e8a2..fda854de808b 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1701,6 +1701,10 @@ int nfs_initiate_commit(struct rpc_clnt *clnt, struct nfs_commit_data *data,
 		.flags = RPC_TASK_ASYNC | flags,
 		.priority = priority,
 	};
+
+	if (nfs_server_capable(data->inode, NFS_CAP_MOVEABLE))
+		task_setup_data.flags |= RPC_TASK_MOVEABLE;
+
 	/* Set up the initial task struct.  */
 	nfs_ops->commit_setup(data, &msg, &task_setup_data.rpc_client);
 	trace_nfs_initiate_commit(data);
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index ca0959e51e81..1fdf560dddd8 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -285,4 +285,5 @@ struct nfs_server {
 #define NFS_CAP_XATTR		(1U << 28)
 #define NFS_CAP_READ_PLUS	(1U << 29)
 #define NFS_CAP_FS_LOCATIONS	(1U << 30)
+#define NFS_CAP_MOVEABLE	(1U << 31)
 #endif
-- 
2.35.1



