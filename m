Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7847113F1CD
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391921AbgAPRZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:25:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:32938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391910AbgAPRZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:25:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D34D3246C2;
        Thu, 16 Jan 2020 17:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195519;
        bh=h53+j/01JZX1bOOeMLrpac4PzNOjahGiNC9oFjDcpo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTPYY/ViuYISSHbPi4Y4ebxfHZQQDQfiv54fmBghXQbAYmWP31KylWjpGwKk44gOC
         qHcGCUbGo7gShRd3cYfqSBpFeUzHj4azZezZBGcE72xuo8T5e1vTkoy0j1r1JeMuMx
         NHSJ8dCH/F/pVnWuBH1tYQVgDtsN2ilBZBWeg3L4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 117/371] NFS: Fix a soft lockup in the delegation recovery code
Date:   Thu, 16 Jan 2020 12:19:49 -0500
Message-Id: <20200116172403.18149-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 6f9449be53f3ce383caed797708b332ede8d952c ]

Fix a soft lockup when NFS client delegation recovery is attempted
but the inode is in the process of being freed. When the
igrab(inode) call fails, and we have to restart the recovery process,
we need to ensure that we won't attempt to recover the same delegation
again.

Fixes: 45870d6909d5a ("NFSv4.1: Test delegation stateids when server...")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 20 ++++++++++++--------
 fs/nfs/delegation.h |  1 +
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 04d57e11577e..09b3bcb86d32 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -234,6 +234,8 @@ static struct inode *nfs_delegation_grab_inode(struct nfs_delegation *delegation
 	spin_lock(&delegation->lock);
 	if (delegation->inode != NULL)
 		inode = igrab(delegation->inode);
+	if (!inode)
+		set_bit(NFS_DELEGATION_INODE_FREEING, &delegation->flags);
 	spin_unlock(&delegation->lock);
 	return inode;
 }
@@ -863,10 +865,11 @@ void nfs_delegation_reap_unclaimed(struct nfs_client *clp)
 	list_for_each_entry_rcu(server, &clp->cl_superblocks, client_link) {
 		list_for_each_entry_rcu(delegation, &server->delegations,
 								super_list) {
-			if (test_bit(NFS_DELEGATION_RETURNING,
-						&delegation->flags))
-				continue;
-			if (test_bit(NFS_DELEGATION_NEED_RECLAIM,
+			if (test_bit(NFS_DELEGATION_INODE_FREEING,
+						&delegation->flags) ||
+			    test_bit(NFS_DELEGATION_RETURNING,
+						&delegation->flags) ||
+			    test_bit(NFS_DELEGATION_NEED_RECLAIM,
 						&delegation->flags) == 0)
 				continue;
 			if (!nfs_sb_active(server->super))
@@ -971,10 +974,11 @@ void nfs_reap_expired_delegations(struct nfs_client *clp)
 	list_for_each_entry_rcu(server, &clp->cl_superblocks, client_link) {
 		list_for_each_entry_rcu(delegation, &server->delegations,
 								super_list) {
-			if (test_bit(NFS_DELEGATION_RETURNING,
-						&delegation->flags))
-				continue;
-			if (test_bit(NFS_DELEGATION_TEST_EXPIRED,
+			if (test_bit(NFS_DELEGATION_INODE_FREEING,
+						&delegation->flags) ||
+			    test_bit(NFS_DELEGATION_RETURNING,
+						&delegation->flags) ||
+			    test_bit(NFS_DELEGATION_TEST_EXPIRED,
 						&delegation->flags) == 0)
 				continue;
 			if (!nfs_sb_active(server->super))
diff --git a/fs/nfs/delegation.h b/fs/nfs/delegation.h
index df41d16dc6ab..510c9edcc712 100644
--- a/fs/nfs/delegation.h
+++ b/fs/nfs/delegation.h
@@ -34,6 +34,7 @@ enum {
 	NFS_DELEGATION_RETURNING,
 	NFS_DELEGATION_REVOKED,
 	NFS_DELEGATION_TEST_EXPIRED,
+	NFS_DELEGATION_INODE_FREEING,
 };
 
 int nfs_inode_set_delegation(struct inode *inode, struct rpc_cred *cred, struct nfs_openres *res);
-- 
2.20.1

