Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D4A9E12E
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732025AbfH0ICj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:02:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731940AbfH0ICi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:02:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C232920828;
        Tue, 27 Aug 2019 08:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892957;
        bh=YF3+U7geCuDQPe8rFKBx2FiswkJi7N/YuISwY29Nb30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ec7QFNpVVjnsI9Q+kIfCKf5yzqUhICBpzVI8rCTM1QsiziCF17KfbwDqcQurPQpj1
         GjkEb+aivCEWrBMPqEWYMnToXdNkHHpMb2Vyzq1JIyS1w66GQoV9XbN42800f8NPtx
         nvGX/J7AvsU0vljcuJuR0M/FOMGWiqIddu/Qc5OE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 074/162] NFSv4.1: Only reap expired delegations
Date:   Tue, 27 Aug 2019 09:50:02 +0200
Message-Id: <20190827072740.698239855@linuxfoundation.org>
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

[ Upstream commit ad11408970df79d5f481aa9964e91f183133424c ]

Fix nfs_reap_expired_delegations() to ensure that we only reap delegations
that are actually expired, rather than triggering on random errors.

Fixes: 45870d6909d5a ("NFSv4.1: Test delegation stateids when server...")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 0af854cce8ffa..071b90a45933a 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -1046,6 +1046,22 @@ void nfs_test_expired_all_delegations(struct nfs_client *clp)
 	nfs4_schedule_state_manager(clp);
 }
 
+static void
+nfs_delegation_test_free_expired(struct inode *inode,
+		nfs4_stateid *stateid,
+		const struct cred *cred)
+{
+	struct nfs_server *server = NFS_SERVER(inode);
+	const struct nfs4_minor_version_ops *ops = server->nfs_client->cl_mvops;
+	int status;
+
+	if (!cred)
+		return;
+	status = ops->test_and_free_expired(server, stateid, cred);
+	if (status == -NFS4ERR_EXPIRED || status == -NFS4ERR_BAD_STATEID)
+		nfs_remove_bad_delegation(inode, stateid);
+}
+
 /**
  * nfs_reap_expired_delegations - reap expired delegations
  * @clp: nfs_client to process
@@ -1057,7 +1073,6 @@ void nfs_test_expired_all_delegations(struct nfs_client *clp)
  */
 void nfs_reap_expired_delegations(struct nfs_client *clp)
 {
-	const struct nfs4_minor_version_ops *ops = clp->cl_mvops;
 	struct nfs_delegation *delegation;
 	struct nfs_server *server;
 	struct inode *inode;
@@ -1088,11 +1103,7 @@ restart:
 			nfs4_stateid_copy(&stateid, &delegation->stateid);
 			clear_bit(NFS_DELEGATION_TEST_EXPIRED, &delegation->flags);
 			rcu_read_unlock();
-			if (cred != NULL &&
-			    ops->test_and_free_expired(server, &stateid, cred) < 0) {
-				nfs_revoke_delegation(inode, &stateid);
-				nfs_inode_find_state_and_recover(inode, &stateid);
-			}
+			nfs_delegation_test_free_expired(inode, &stateid, cred);
 			put_cred(cred);
 			if (nfs4_server_rebooted(clp)) {
 				nfs_inode_mark_test_expired_delegation(server,inode);
-- 
2.20.1



