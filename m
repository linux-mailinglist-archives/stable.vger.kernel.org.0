Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116173A6350
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbhFNLL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235332AbhFNLJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:09:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14C1561939;
        Mon, 14 Jun 2021 10:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667614;
        bh=xziSFdnAwMDDGKdSzpAciJj3k+e4RNL1gpBubW3Lqz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQDCsEdGnVbKarhcQC6lZ4MgTpopMbxcLaIq/vfkmIJd/Ial9AB13GkgZEyZE9Cra
         GFeQXI52SdlnBXIxzokHQ5v65svT9jplB0P8Z4/nKq62nmYn8dANNILx1rU0hhEzmd
         p0SFoyS2jCbeC8ZEjxRlKRxM6EgCJGDv4pzgOURk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/131] NFSv4: Fix deadlock between nfs4_evict_inode() and nfs4_opendata_get_inode()
Date:   Mon, 14 Jun 2021 12:28:02 +0200
Message-Id: <20210614102657.123649011@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
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
index 065cb04222a1..543d916f79ab 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -205,6 +205,7 @@ struct nfs4_exception {
 	struct inode *inode;
 	nfs4_stateid *stateid;
 	long timeout;
+	unsigned char task_is_privileged : 1;
 	unsigned char delay : 1,
 		      recovering : 1,
 		      retry : 1;
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index c92d6ff0fcea..959c2aa2180d 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -592,6 +592,8 @@ int nfs4_handle_exception(struct nfs_server *server, int errorcode, struct nfs4_
 		goto out_retry;
 	}
 	if (exception->recovering) {
+		if (exception->task_is_privileged)
+			return -EDEADLOCK;
 		ret = nfs4_wait_clnt_recover(clp);
 		if (test_bit(NFS_MIG_FAILED, &server->mig_status))
 			return -EIO;
@@ -617,6 +619,8 @@ nfs4_async_handle_exception(struct rpc_task *task, struct nfs_server *server,
 		goto out_retry;
 	}
 	if (exception->recovering) {
+		if (exception->task_is_privileged)
+			return -EDEADLOCK;
 		rpc_sleep_on(&clp->cl_rpcwaitq, task, NULL);
 		if (test_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state) == 0)
 			rpc_wake_up_queued_task(&clp->cl_rpcwaitq, task);
@@ -6383,6 +6387,7 @@ static void nfs4_delegreturn_done(struct rpc_task *task, void *calldata)
 	struct nfs4_exception exception = {
 		.inode = data->inode,
 		.stateid = &data->stateid,
+		.task_is_privileged = data->args.seq_args.sa_privileged,
 	};
 
 	if (!nfs4_sequence_done(task, &data->res.seq_res))
@@ -6506,7 +6511,6 @@ static int _nfs4_proc_delegreturn(struct inode *inode, const struct cred *cred,
 	data = kzalloc(sizeof(*data), GFP_NOFS);
 	if (data == NULL)
 		return -ENOMEM;
-	nfs4_init_sequence(&data->args.seq_args, &data->res.seq_res, 1, 0);
 
 	nfs4_state_protect(server->nfs_client,
 			NFS_SP4_MACH_CRED_CLEANUP,
@@ -6537,6 +6541,12 @@ static int _nfs4_proc_delegreturn(struct inode *inode, const struct cred *cred,
 		}
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



