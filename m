Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378A13CE2D2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241531AbhGSPcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346688AbhGSP2T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:28:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B045161376;
        Mon, 19 Jul 2021 16:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710932;
        bh=qlSoQXzTWJ0PPHGF4laKvOS2DjROVtRbFbYZ9XURl38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vCDC3TxJ2gFAwemn/25NdpIeWy2al8SwYLe0L22jQp6OZiyIwo4rgoGmDFGknMYOI
         Lr8mMLLefFugFQUVtfqJ+9gS4paVwgeIWBWhkULHX83hIjO2ba8asjxaeo1ihl+DZz
         A7lNzbOU6dKyV5F2qdc6Gx2sjYwnn8hJrpxu+r7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 162/351] NFSv4: Fix delegation return in cases where we have to retry
Date:   Mon, 19 Jul 2021 16:51:48 +0200
Message-Id: <20210719144950.332597775@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit be20037725d17935ec669044bd2b15bc40c3b5ab ]

If we're unable to immediately recover all locks because the server is
unable to immediately service our reclaim calls, then we want to retry
after we've finished servicing all the other asynchronous delegation
returns on our queue.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 71 +++++++++++++++++++++++++++++++++++----------
 fs/nfs/delegation.h |  1 +
 fs/nfs/nfs4_fs.h    |  1 +
 3 files changed, 58 insertions(+), 15 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index e6ec6f09ac6e..7c45ac3c3b0b 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -75,6 +75,13 @@ void nfs_mark_delegation_referenced(struct nfs_delegation *delegation)
 	set_bit(NFS_DELEGATION_REFERENCED, &delegation->flags);
 }
 
+static void nfs_mark_return_delegation(struct nfs_server *server,
+				       struct nfs_delegation *delegation)
+{
+	set_bit(NFS_DELEGATION_RETURN, &delegation->flags);
+	set_bit(NFS4CLNT_DELEGRETURN, &server->nfs_client->cl_state);
+}
+
 static bool
 nfs4_is_valid_delegation(const struct nfs_delegation *delegation,
 		fmode_t flags)
@@ -293,6 +300,7 @@ nfs_start_delegation_return_locked(struct nfs_inode *nfsi)
 		goto out;
 	spin_lock(&delegation->lock);
 	if (!test_and_set_bit(NFS_DELEGATION_RETURNING, &delegation->flags)) {
+		clear_bit(NFS_DELEGATION_RETURN_DELAYED, &delegation->flags);
 		/* Refcount matched in nfs_end_delegation_return() */
 		ret = nfs_get_delegation(delegation);
 	}
@@ -314,16 +322,17 @@ nfs_start_delegation_return(struct nfs_inode *nfsi)
 	return delegation;
 }
 
-static void
-nfs_abort_delegation_return(struct nfs_delegation *delegation,
-		struct nfs_client *clp)
+static void nfs_abort_delegation_return(struct nfs_delegation *delegation,
+					struct nfs_client *clp, int err)
 {
 
 	spin_lock(&delegation->lock);
 	clear_bit(NFS_DELEGATION_RETURNING, &delegation->flags);
-	set_bit(NFS_DELEGATION_RETURN, &delegation->flags);
+	if (err == -EAGAIN) {
+		set_bit(NFS_DELEGATION_RETURN_DELAYED, &delegation->flags);
+		set_bit(NFS4CLNT_DELEGRETURN_DELAYED, &clp->cl_state);
+	}
 	spin_unlock(&delegation->lock);
-	set_bit(NFS4CLNT_DELEGRETURN, &clp->cl_state);
 }
 
 static struct nfs_delegation *
@@ -539,7 +548,7 @@ static int nfs_end_delegation_return(struct inode *inode, struct nfs_delegation
 	} while (err == 0);
 
 	if (err) {
-		nfs_abort_delegation_return(delegation, clp);
+		nfs_abort_delegation_return(delegation, clp, err);
 		goto out;
 	}
 
@@ -568,6 +577,7 @@ static bool nfs_delegation_need_return(struct nfs_delegation *delegation)
 	if (ret)
 		clear_bit(NFS_DELEGATION_RETURN_IF_CLOSED, &delegation->flags);
 	if (test_bit(NFS_DELEGATION_RETURNING, &delegation->flags) ||
+	    test_bit(NFS_DELEGATION_RETURN_DELAYED, &delegation->flags) ||
 	    test_bit(NFS_DELEGATION_REVOKED, &delegation->flags))
 		ret = false;
 
@@ -647,6 +657,38 @@ out:
 	return err;
 }
 
+static bool nfs_server_clear_delayed_delegations(struct nfs_server *server)
+{
+	struct nfs_delegation *d;
+	bool ret = false;
+
+	list_for_each_entry_rcu (d, &server->delegations, super_list) {
+		if (!test_bit(NFS_DELEGATION_RETURN_DELAYED, &d->flags))
+			continue;
+		nfs_mark_return_delegation(server, d);
+		clear_bit(NFS_DELEGATION_RETURN_DELAYED, &d->flags);
+		ret = true;
+	}
+	return ret;
+}
+
+static bool nfs_client_clear_delayed_delegations(struct nfs_client *clp)
+{
+	struct nfs_server *server;
+	bool ret = false;
+
+	if (!test_and_clear_bit(NFS4CLNT_DELEGRETURN_DELAYED, &clp->cl_state))
+		goto out;
+	rcu_read_lock();
+	list_for_each_entry_rcu (server, &clp->cl_superblocks, client_link) {
+		if (nfs_server_clear_delayed_delegations(server))
+			ret = true;
+	}
+	rcu_read_unlock();
+out:
+	return ret;
+}
+
 /**
  * nfs_client_return_marked_delegations - return previously marked delegations
  * @clp: nfs_client to process
@@ -659,8 +701,14 @@ out:
  */
 int nfs_client_return_marked_delegations(struct nfs_client *clp)
 {
-	return nfs_client_for_each_server(clp,
-			nfs_server_return_marked_delegations, NULL);
+	int err = nfs_client_for_each_server(
+		clp, nfs_server_return_marked_delegations, NULL);
+	if (err)
+		return err;
+	/* If a return was delayed, sleep to prevent hard looping */
+	if (nfs_client_clear_delayed_delegations(clp))
+		ssleep(1);
+	return 0;
 }
 
 /**
@@ -775,13 +823,6 @@ static void nfs_mark_return_if_closed_delegation(struct nfs_server *server,
 	set_bit(NFS4CLNT_DELEGRETURN, &server->nfs_client->cl_state);
 }
 
-static void nfs_mark_return_delegation(struct nfs_server *server,
-		struct nfs_delegation *delegation)
-{
-	set_bit(NFS_DELEGATION_RETURN, &delegation->flags);
-	set_bit(NFS4CLNT_DELEGRETURN, &server->nfs_client->cl_state);
-}
-
 static bool nfs_server_mark_return_all_delegations(struct nfs_server *server)
 {
 	struct nfs_delegation *delegation;
diff --git a/fs/nfs/delegation.h b/fs/nfs/delegation.h
index c19b4fd20781..1c378992b7c0 100644
--- a/fs/nfs/delegation.h
+++ b/fs/nfs/delegation.h
@@ -36,6 +36,7 @@ enum {
 	NFS_DELEGATION_REVOKED,
 	NFS_DELEGATION_TEST_EXPIRED,
 	NFS_DELEGATION_INODE_FREEING,
+	NFS_DELEGATION_RETURN_DELAYED,
 };
 
 int nfs_inode_set_delegation(struct inode *inode, const struct cred *cred,
diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index 543d916f79ab..3e344bec3647 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -45,6 +45,7 @@ enum nfs4_client_state {
 	NFS4CLNT_RECALL_RUNNING,
 	NFS4CLNT_RECALL_ANY_LAYOUT_READ,
 	NFS4CLNT_RECALL_ANY_LAYOUT_RW,
+	NFS4CLNT_DELEGRETURN_DELAYED,
 };
 
 #define NFS4_RENEW_TIMEOUT		0x01
-- 
2.30.2



