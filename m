Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB8EB1F73
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389869AbfIMNTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:19:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390422AbfIMNTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:19:39 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1B5B20640;
        Fri, 13 Sep 2019 13:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380778;
        bh=nbvMh1RIRXXzZ6TclUPYbZSby/FBqYy/SvJruTPaJuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvrLUhoADIz19eq0r0qA1oDEFkJaWLWK4D3jtdIGf9KOwHv4JUVnFJJdqPz/XPlJc
         sChdAtZlQD4A0GidJFWh2T0t1gGBhA62bmEKpETLhZsHyZImsycf7v5JphGZAaCJ0+
         mxFV8X1Ij4Jfe1R5UbZea2C1Afo+H4LeKkR/jDWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 176/190] NFSv4: Fix delegation state recovery
Date:   Fri, 13 Sep 2019 14:07:11 +0100
Message-Id: <20190913130613.814058908@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5eb8d18ca0e001c6055da2b7f30d8f6dca23a44f ]

Once we clear the NFS_DELEGATED_STATE flag, we're telling
nfs_delegation_claim_opens() that we're done recovering all open state
for that stateid, so we really need to ensure that we test for all
open modes that are currently cached and recover them before exiting
nfs4_open_delegation_recall().

Fixes: 24311f884189d ("NFSv4: Recovery of recalled read delegations...")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: stable@vger.kernel.org # v4.3+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c |  2 +-
 fs/nfs/delegation.h |  2 +-
 fs/nfs/nfs4proc.c   | 25 ++++++++++++-------------
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 75fe92eaa6818..1624618c2bc72 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -153,7 +153,7 @@ again:
 		/* Block nfs4_proc_unlck */
 		mutex_lock(&sp->so_delegreturn_mutex);
 		seq = raw_seqcount_begin(&sp->so_reclaim_seqcount);
-		err = nfs4_open_delegation_recall(ctx, state, stateid, type);
+		err = nfs4_open_delegation_recall(ctx, state, stateid);
 		if (!err)
 			err = nfs_delegation_claim_locks(ctx, state, stateid);
 		if (!err && read_seqcount_retry(&sp->so_reclaim_seqcount, seq))
diff --git a/fs/nfs/delegation.h b/fs/nfs/delegation.h
index bb1ef8c37af42..c95477823fa6b 100644
--- a/fs/nfs/delegation.h
+++ b/fs/nfs/delegation.h
@@ -61,7 +61,7 @@ void nfs_reap_expired_delegations(struct nfs_client *clp);
 
 /* NFSv4 delegation-related procedures */
 int nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred, const nfs4_stateid *stateid, int issync);
-int nfs4_open_delegation_recall(struct nfs_open_context *ctx, struct nfs4_state *state, const nfs4_stateid *stateid, fmode_t type);
+int nfs4_open_delegation_recall(struct nfs_open_context *ctx, struct nfs4_state *state, const nfs4_stateid *stateid);
 int nfs4_lock_delegation_recall(struct file_lock *fl, struct nfs4_state *state, const nfs4_stateid *stateid);
 bool nfs4_copy_delegation_stateid(struct inode *inode, fmode_t flags, nfs4_stateid *dst, struct rpc_cred **cred);
 bool nfs4_refresh_delegation_stateid(nfs4_stateid *dst, struct inode *inode);
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 31ae3bd5d9d20..621e3cf90f4eb 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2113,12 +2113,10 @@ static int nfs4_handle_delegation_recall_error(struct nfs_server *server, struct
 		case -NFS4ERR_BAD_HIGH_SLOT:
 		case -NFS4ERR_CONN_NOT_BOUND_TO_SESSION:
 		case -NFS4ERR_DEADSESSION:
-			set_bit(NFS_DELEGATED_STATE, &state->flags);
 			nfs4_schedule_session_recovery(server->nfs_client->cl_session, err);
 			return -EAGAIN;
 		case -NFS4ERR_STALE_CLIENTID:
 		case -NFS4ERR_STALE_STATEID:
-			set_bit(NFS_DELEGATED_STATE, &state->flags);
 			/* Don't recall a delegation if it was lost */
 			nfs4_schedule_lease_recovery(server->nfs_client);
 			return -EAGAIN;
@@ -2139,7 +2137,6 @@ static int nfs4_handle_delegation_recall_error(struct nfs_server *server, struct
 			return -EAGAIN;
 		case -NFS4ERR_DELAY:
 		case -NFS4ERR_GRACE:
-			set_bit(NFS_DELEGATED_STATE, &state->flags);
 			ssleep(1);
 			return -EAGAIN;
 		case -ENOMEM:
@@ -2155,8 +2152,7 @@ static int nfs4_handle_delegation_recall_error(struct nfs_server *server, struct
 }
 
 int nfs4_open_delegation_recall(struct nfs_open_context *ctx,
-		struct nfs4_state *state, const nfs4_stateid *stateid,
-		fmode_t type)
+		struct nfs4_state *state, const nfs4_stateid *stateid)
 {
 	struct nfs_server *server = NFS_SERVER(state->inode);
 	struct nfs4_opendata *opendata;
@@ -2167,20 +2163,23 @@ int nfs4_open_delegation_recall(struct nfs_open_context *ctx,
 	if (IS_ERR(opendata))
 		return PTR_ERR(opendata);
 	nfs4_stateid_copy(&opendata->o_arg.u.delegation, stateid);
-	nfs_state_clear_delegation(state);
-	switch (type & (FMODE_READ|FMODE_WRITE)) {
-	case FMODE_READ|FMODE_WRITE:
-	case FMODE_WRITE:
+	if (!test_bit(NFS_O_RDWR_STATE, &state->flags)) {
 		err = nfs4_open_recover_helper(opendata, FMODE_READ|FMODE_WRITE);
 		if (err)
-			break;
+			goto out;
+	}
+	if (!test_bit(NFS_O_WRONLY_STATE, &state->flags)) {
 		err = nfs4_open_recover_helper(opendata, FMODE_WRITE);
 		if (err)
-			break;
-		/* Fall through */
-	case FMODE_READ:
+			goto out;
+	}
+	if (!test_bit(NFS_O_RDONLY_STATE, &state->flags)) {
 		err = nfs4_open_recover_helper(opendata, FMODE_READ);
+		if (err)
+			goto out;
 	}
+	nfs_state_clear_delegation(state);
+out:
 	nfs4_opendata_put(opendata);
 	return nfs4_handle_delegation_recall_error(server, state, stateid, NULL, err);
 }
-- 
2.20.1



