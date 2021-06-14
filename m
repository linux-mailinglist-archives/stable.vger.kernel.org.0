Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5093A617A
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbhFNKsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233238AbhFNKqK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:46:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF69B6143B;
        Mon, 14 Jun 2021 10:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666996;
        bh=xUjZAa8t+1HDLsFaw352ooMRbx2q9ldjzJYlQkWfFPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kijDiWXCKYynVe6O/pP/VMm7zDRnfdQ43Fk7mXR4hp1sK1YgM6QIXjG9A5mbdDUwZ
         CYw4DGrEfKlp7t86aNlO0VJ53Y1zZQBMWh3gbObqasyPeHi62Lps7cKUoQJQzmHULw
         BFM54aapN6GIRvhlNeeVqB/W6EAxUjJa1rBH9bH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 57/67] NFSv4: Fix deadlock between nfs4_evict_inode() and nfs4_opendata_get_inode()
Date:   Mon, 14 Jun 2021 12:27:40 +0200
Message-Id: <20210614102645.691476458@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
References: <20210614102643.797691914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit dfe1fe75e00e4c724ede7b9e593f6f680e446c5f ]

If the inode is being evicted, but has to return a delegation first,
then it can cause a deadlock in the corner case where the server reboots
before the delegreturn completes, but while the call to iget5_locked() in
nfs4_opendata_get_inode() is waiting for the inode free to complete.
Since the open call still holds a session slot, the reboot recovery
cannot proceed.

In order to break the logjam, we can turn the delegation return into a
privileged operation for the case where we're evicting the inode. We
know that in that case, there can be no other state recovery operation
that conflicts.

Reported-by: zhangxiaoxu (A) <zhangxiaoxu5@huawei.com>
Fixes: 5fcdfacc01f3 ("NFSv4: Return delegations synchronously in evict_inode")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4_fs.h  |  1 +
 fs/nfs/nfs4proc.c | 12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index 5b61520dce88..4dc9bd7ddf07 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -201,6 +201,7 @@ struct nfs4_exception {
 	struct inode *inode;
 	nfs4_stateid *stateid;
 	long timeout;
+	unsigned char task_is_privileged : 1;
 	unsigned char delay : 1,
 		      recovering : 1,
 		      retry : 1;
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index bcad052db065..8bd5037125b3 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -550,6 +550,8 @@ int nfs4_handle_exception(struct nfs_server *server, int errorcode, struct nfs4_
 		goto out_retry;
 	}
 	if (exception->recovering) {
+		if (exception->task_is_privileged)
+			return -EDEADLOCK;
 		ret = nfs4_wait_clnt_recover(clp);
 		if (test_bit(NFS_MIG_FAILED, &server->mig_status))
 			return -EIO;
@@ -575,6 +577,8 @@ nfs4_async_handle_exception(struct rpc_task *task, struct nfs_server *server,
 		goto out_retry;
 	}
 	if (exception->recovering) {
+		if (exception->task_is_privileged)
+			return -EDEADLOCK;
 		rpc_sleep_on(&clp->cl_rpcwaitq, task, NULL);
 		if (test_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state) == 0)
 			rpc_wake_up_queued_task(&clp->cl_rpcwaitq, task);
@@ -6017,6 +6021,7 @@ static void nfs4_delegreturn_done(struct rpc_task *task, void *calldata)
 	struct nfs4_exception exception = {
 		.inode = data->inode,
 		.stateid = &data->stateid,
+		.task_is_privileged = data->args.seq_args.sa_privileged,
 	};
 
 	if (!nfs4_sequence_done(task, &data->res.seq_res))
@@ -6160,7 +6165,6 @@ static int _nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred, co
 	data = kzalloc(sizeof(*data), GFP_NOFS);
 	if (data == NULL)
 		return -ENOMEM;
-	nfs4_init_sequence(&data->args.seq_args, &data->res.seq_res, 1, 0);
 
 	nfs4_state_protect(server->nfs_client,
 			NFS_SP4_MACH_CRED_CLEANUP,
@@ -6190,6 +6194,12 @@ static int _nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred, co
 		data->lr.roc = false;
 	}
 
+	if (!data->inode)
+		nfs4_init_sequence(&data->args.seq_args, &data->res.seq_res, 1,
+				   1);
+	else
+		nfs4_init_sequence(&data->args.seq_args, &data->res.seq_res, 1,
+				   0);
 	task_setup_data.callback_data = data;
 	msg.rpc_argp = &data->args;
 	msg.rpc_resp = &data->res;
-- 
2.30.2



