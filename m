Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920C09E077
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730958AbfH0IEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730764AbfH0IDx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:03:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44FF8206BF;
        Tue, 27 Aug 2019 08:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893032;
        bh=RC199nhAYZRtj3va6zftvMHOLXIDuyiqPEEpAliMEkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OoXyzm8DG395oCe1crAKyEX1RvIE1wEqAMaQmBHfmEWEOagkj9mH+E/eSFLrjll6/
         lmtFMzwwXICfIQUPOiF6TN64AuNl8+SMHM2DYojRKJIa0YmITzbZ7z0cdYTVOVTLii
         lNNxv9k+w00A3H9bV19pz0mfRGG2/cDf9wSWSrjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 096/162] NFSv4: Ensure state recovery handles ETIMEDOUT correctly
Date:   Tue, 27 Aug 2019 09:50:24 +0200
Message-Id: <20190827072741.557647315@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 74e1732a4bd01..2023011c7a8fe 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2150,6 +2150,7 @@ static int nfs4_handle_delegation_recall_error(struct nfs_server *server, struct
 		case -ENOENT:
 		case -EAGAIN:
 		case -ESTALE:
+		case -ETIMEDOUT:
 			break;
 		case -NFS4ERR_BADSESSION:
 		case -NFS4ERR_BADSLOT:
@@ -2470,6 +2471,7 @@ static int nfs4_run_open_task(struct nfs4_opendata *data,
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
@@ -1528,6 +1528,7 @@ restart:
 		switch (status) {
 		case 0:
 			break;
+		case -ETIMEDOUT:
 		case -ESTALE:
 		case -NFS4ERR_ADMIN_REVOKED:
 		case -NFS4ERR_STALE_STATEID:
@@ -1681,11 +1682,13 @@ restart:
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



