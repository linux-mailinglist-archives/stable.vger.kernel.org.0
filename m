Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9CC147C55
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733183AbgAXJvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:51:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:52358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730738AbgAXJvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:51:14 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF5DC214AF;
        Fri, 24 Jan 2020 09:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859473;
        bh=E0IC9ExeDYq24uIjpOHqlMMq+cnmSCI5V04gzU4UAQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mot1pbovG24+PCG6LEANG/qoAezfIs3TPBwpBSxQf17ogGlXI+guKSo7lVUyKZyNs
         /x5Nh4hemgX4W1LGPOmmxHPMVE+xG6SnOvJHVSwU6wNkp/K/8OacCzZb3s+hYOQABJ
         n5Z4VRiDlNheMzoUFshryOhLehSwJ4xd+0bpGiHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 124/343] NFS: Fix a soft lockup in the delegation recovery code
Date:   Fri, 24 Jan 2020 10:29:02 +0100
Message-Id: <20200124092936.305935173@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 04d57e11577e0..09b3bcb86d328 100644
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
@@ -863,10 +865,11 @@ restart:
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
@@ -971,10 +974,11 @@ restart:
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
index df41d16dc6ab4..510c9edcc712d 100644
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



