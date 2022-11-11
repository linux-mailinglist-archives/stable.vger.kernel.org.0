Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58AF06250DA
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbiKKCi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiKKCg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:36:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A3A686B3;
        Thu, 10 Nov 2022 18:35:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 603E061E8E;
        Fri, 11 Nov 2022 02:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D542CC433D6;
        Fri, 11 Nov 2022 02:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134158;
        bh=jfynGGSVh5zaIsDDbet+xvwFBxlcF950vurb84kfsXQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Xv9JZGOZBCjbqBq3Gro1eJJGzkmxSO7GKM11/mKSYv4TAIh6e6zwHfmkMgSaxCoN1
         A/zjv+SQ9aM8z/HpdYMM1/iRBU3SZ9pvFb+LF64EnlB1e0L/45MIfhzzVFNio/Isou
         mOx4GDRV0/bRO9psohLcBq+ZqVBqgwQHVa8XZWInY6iGpSCQ8uRVR/6Vc7J6J5OSCO
         kS3ZbPlULAdvZSK19op2xNyzglcWhrkLzbbAMWTG4YqtPXvkzs0wm6KHJQd1IKjvUD
         uIks7lJlO5NizCs5gGdp3MrVVQCo0MRB7r/jdvmVEpHtOPmSKdDn7WX6eRdh9PJekg
         bzhMKrwzD728w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Coddington <bcodding@redhat.com>,
        Gonzalo Siero Humet <gsierohu@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna@kernel.org,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 1/4] NFSv4: Retry LOCK on OLD_STATEID during delegation return
Date:   Thu, 10 Nov 2022 21:35:53 -0500
Message-Id: <20221111023556.228125-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit f5ea16137a3fa2858620dc9084466491c128535f ]

There's a small window where a LOCK sent during a delegation return can
race with another OPEN on client, but the open stateid has not yet been
updated.  In this case, the client doesn't handle the OLD_STATEID error
from the server and will lose this lock, emitting:
"NFS: nfs4_handle_delegation_recall_error: unhandled error -10024".

Fix this by sending the task through the nfs4 error handling in
nfs4_lock_done() when we may have to reconcile our stateid with what the
server believes it to be.  For this case, the result is a retry of the
LOCK operation with the updated stateid.

Reported-by: Gonzalo Siero Humet <gsierohu@redhat.com>
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index f9f76594b866..9a0f48f7f2b8 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6613,6 +6613,7 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 {
 	struct nfs4_lockdata *data = calldata;
 	struct nfs4_lock_state *lsp = data->lsp;
+	struct nfs_server *server = NFS_SERVER(d_inode(data->ctx->dentry));
 
 	dprintk("%s: begin!\n", __func__);
 
@@ -6622,8 +6623,7 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 	data->rpc_status = task->tk_status;
 	switch (task->tk_status) {
 	case 0:
-		renew_lease(NFS_SERVER(d_inode(data->ctx->dentry)),
-				data->timestamp);
+		renew_lease(server, data->timestamp);
 		if (data->arg.new_lock && !data->cancelled) {
 			data->fl.fl_flags &= ~(FL_SLEEP | FL_ACCESS);
 			if (locks_lock_inode_wait(lsp->ls_state->inode, &data->fl) < 0)
@@ -6644,6 +6644,8 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 			if (!nfs4_stateid_match(&data->arg.open_stateid,
 						&lsp->ls_state->open_stateid))
 				goto out_restart;
+			else if (nfs4_async_handle_error(task, server, lsp->ls_state, NULL) == -EAGAIN)
+				goto out_restart;
 		} else if (!nfs4_stateid_match(&data->arg.lock_stateid,
 						&lsp->ls_stateid))
 				goto out_restart;
-- 
2.35.1

