Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D520C8C66D
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfHNCP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728714AbfHNCOY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:14:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62C5E20842;
        Wed, 14 Aug 2019 02:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748863;
        bh=Y0flpr7SM2SrV0eMr6RjFTOsrFxL7Qqx4oksAdmTAA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUgOywhyPbLC476bUDL2W5KkCi50DKw2X1ROZWXXCJASvS7oTe53EXPx7lG7QaIS2
         p2Ylcv1PGXmkResFNwi+q2YEvatOcTAY4BjFp/NzTjU24KOt0RIU5XRjDOhLp/XFxq
         rxBXCw/cK+nZlbXPE9gFBfDkSLoKdJ9Q6bBgys08=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 110/123] NFSv4: Ensure state recovery handles ETIMEDOUT correctly
Date:   Tue, 13 Aug 2019 22:10:34 -0400
Message-Id: <20190814021047.14828-110-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 67e7b52d44e3d539dfbfcd866c3d3d69da23a909 ]

Ensure that the state recovery code handles ETIMEDOUT correctly,
and also that we set RPC_TASK_TIMEOUT when recovering open state.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c  | 2 ++
 fs/nfs/nfs4state.c | 7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index b3fd75c8629a4..c738b0b65178e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2146,6 +2146,7 @@ static int nfs4_handle_delegation_recall_error(struct nfs_server *server, struct
 		case -ENOENT:
 		case -EAGAIN:
 		case -ESTALE:
+		case -ETIMEDOUT:
 			break;
 		case -NFS4ERR_BADSESSION:
 		case -NFS4ERR_BADSLOT:
@@ -2467,6 +2468,7 @@ static int nfs4_run_open_task(struct nfs4_opendata *data,
 	if (!ctx) {
 		nfs4_init_sequence(&o_arg->seq_args, &o_res->seq_res, 1, 1);
 		data->is_recover = true;
+		task_setup_data.flags |= RPC_TASK_TIMEOUT;
 	} else {
 		nfs4_init_sequence(&o_arg->seq_args, &o_res->seq_res, 1, 0);
 		pnfs_lgopen_prepare(data, ctx);
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 261de26d897f7..0e69cd846afb5 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1528,6 +1528,7 @@ static int nfs4_reclaim_locks(struct nfs4_state *state, const struct nfs4_state_
 		switch (status) {
 		case 0:
 			break;
+		case -ETIMEDOUT:
 		case -ESTALE:
 		case -NFS4ERR_ADMIN_REVOKED:
 		case -NFS4ERR_STALE_STATEID:
@@ -1681,11 +1682,13 @@ static int nfs4_reclaim_open_state(struct nfs4_state_owner *sp, const struct nfs
 		case -NFS4ERR_EXPIRED:
 		case -NFS4ERR_NO_GRACE:
 			nfs4_state_mark_reclaim_nograce(sp->so_server->nfs_client, state);
+			/* Fall through */
 		case -NFS4ERR_STALE_CLIENTID:
 		case -NFS4ERR_BADSESSION:
 		case -NFS4ERR_BADSLOT:
 		case -NFS4ERR_BAD_HIGH_SLOT:
 		case -NFS4ERR_CONN_NOT_BOUND_TO_SESSION:
+		case -ETIMEDOUT:
 			goto out_err;
 		}
 		nfs4_put_open_state(state);
@@ -1970,7 +1973,6 @@ static int nfs4_handle_reclaim_lease_error(struct nfs_client *clp, int status)
 		return -EPERM;
 	case -EACCES:
 	case -NFS4ERR_DELAY:
-	case -ETIMEDOUT:
 	case -EAGAIN:
 		ssleep(1);
 		break;
@@ -2599,7 +2601,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 		}
 
 		/* Now recover expired state... */
-		if (test_and_clear_bit(NFS4CLNT_RECLAIM_NOGRACE, &clp->cl_state)) {
+		if (test_bit(NFS4CLNT_RECLAIM_NOGRACE, &clp->cl_state)) {
 			section = "reclaim nograce";
 			status = nfs4_do_reclaim(clp,
 				clp->cl_mvops->nograce_recovery_ops);
@@ -2607,6 +2609,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 				continue;
 			if (status < 0)
 				goto out_error;
+			clear_bit(NFS4CLNT_RECLAIM_NOGRACE, &clp->cl_state);
 		}
 
 		nfs4_end_drain_session(clp);
-- 
2.20.1

