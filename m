Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9828C8D0
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfHNCNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728398AbfHNCNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:13:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 258ED20989;
        Wed, 14 Aug 2019 02:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748822;
        bh=kExvK5XJy3kOSZcfaVrBsAKrSed5Fx2Sr9lNz2OakCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GERjbELciteTif9fz4DsmeRSeMiA1sbM21Z+vjKfU+qSpqs4Z0o6nV22rDjjLHcQT
         xtFgIpS6mKUfL6I8s8uJ773UwrlD0knfmmA/6IRjmTW4Wcka1RVrP/Kqf/fIAWCdwN
         IfwpOpldr97fCL/Za4vuLvvK6MOEPReFhqdQRS7g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 083/123] NFSv4.1: Only reap expired delegations
Date:   Tue, 13 Aug 2019 22:10:07 -0400
Message-Id: <20190814021047.14828-83-sashal@kernel.org>
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
index 0ff3facf81dac..be22ab982d256 100644
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
@@ -1088,11 +1103,7 @@ void nfs_reap_expired_delegations(struct nfs_client *clp)
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

