Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3098F7B4D
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfKKSe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:34:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:52696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728445AbfKKSe4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:34:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A7B52173B;
        Mon, 11 Nov 2019 18:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497295;
        bh=TEiizNpeGGn/64SlXyUHTweTnVZKaRelha1g5chG8j8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Elz9X8buQzX30V8y1EBE1o364hcaiXqXVxcP3BR0g3rqVqAksDo2BWbGvKsxTjw3q
         76TIsXgYcYWl019IH0qp6CSaWvUeoqlmp61MgCmFIN3whVtYYv7hMSSy5GDXMYxy70
         htaD/MZVjkd4YntYjZdP8cRNJ9eLQ/T9kQyrXuNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 56/65] NFSv4: Dont allow a cached open with a revoked delegation
Date:   Mon, 11 Nov 2019 19:28:56 +0100
Message-Id: <20191111181353.479829307@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
References: <20191111181331.917659011@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit be3df3dd4c70ee020587a943a31b98a0fb4b6424 ]

If the delegation is marked as being revoked, we must not use it
for cached opens.

Fixes: 869f9dfa4d6d ("NFSv4: Fix races between nfs_remove_bad_delegation() and delegation return")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 10 ++++++++++
 fs/nfs/delegation.h |  1 +
 fs/nfs/nfs4proc.c   |  7 ++-----
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index dff600ae0d747..46afd7cdcc378 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -52,6 +52,16 @@ nfs4_is_valid_delegation(const struct nfs_delegation *delegation,
 	return false;
 }
 
+struct nfs_delegation *nfs4_get_valid_delegation(const struct inode *inode)
+{
+	struct nfs_delegation *delegation;
+
+	delegation = rcu_dereference(NFS_I(inode)->delegation);
+	if (nfs4_is_valid_delegation(delegation, 0))
+		return delegation;
+	return NULL;
+}
+
 static int
 nfs4_do_check_delegation(struct inode *inode, fmode_t flags, bool mark)
 {
diff --git a/fs/nfs/delegation.h b/fs/nfs/delegation.h
index e9d5557968739..2c6cb7fb7d5ee 100644
--- a/fs/nfs/delegation.h
+++ b/fs/nfs/delegation.h
@@ -62,6 +62,7 @@ int nfs4_open_delegation_recall(struct nfs_open_context *ctx, struct nfs4_state
 int nfs4_lock_delegation_recall(struct file_lock *fl, struct nfs4_state *state, const nfs4_stateid *stateid);
 bool nfs4_copy_delegation_stateid(struct inode *inode, fmode_t flags, nfs4_stateid *dst, struct rpc_cred **cred);
 
+struct nfs_delegation *nfs4_get_valid_delegation(const struct inode *inode);
 void nfs_mark_delegation_referenced(struct nfs_delegation *delegation);
 int nfs4_have_delegation(struct inode *inode, fmode_t flags);
 int nfs4_check_delegation(struct inode *inode, fmode_t flags);
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 8354dfae7038e..ca4249ae644f2 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1368,8 +1368,6 @@ static int can_open_delegated(struct nfs_delegation *delegation, fmode_t fmode,
 		return 0;
 	if ((delegation->type & fmode) != fmode)
 		return 0;
-	if (test_bit(NFS_DELEGATION_RETURNING, &delegation->flags))
-		return 0;
 	switch (claim) {
 	case NFS4_OPEN_CLAIM_NULL:
 	case NFS4_OPEN_CLAIM_FH:
@@ -1628,7 +1626,6 @@ static void nfs4_return_incompatible_delegation(struct inode *inode, fmode_t fmo
 static struct nfs4_state *nfs4_try_open_cached(struct nfs4_opendata *opendata)
 {
 	struct nfs4_state *state = opendata->state;
-	struct nfs_inode *nfsi = NFS_I(state->inode);
 	struct nfs_delegation *delegation;
 	int open_mode = opendata->o_arg.open_flags;
 	fmode_t fmode = opendata->o_arg.fmode;
@@ -1645,7 +1642,7 @@ static struct nfs4_state *nfs4_try_open_cached(struct nfs4_opendata *opendata)
 		}
 		spin_unlock(&state->owner->so_lock);
 		rcu_read_lock();
-		delegation = rcu_dereference(nfsi->delegation);
+		delegation = nfs4_get_valid_delegation(state->inode);
 		if (!can_open_delegated(delegation, fmode, claim)) {
 			rcu_read_unlock();
 			break;
@@ -2142,7 +2139,7 @@ static void nfs4_open_prepare(struct rpc_task *task, void *calldata)
 		if (can_open_cached(data->state, data->o_arg.fmode, data->o_arg.open_flags))
 			goto out_no_action;
 		rcu_read_lock();
-		delegation = rcu_dereference(NFS_I(data->state->inode)->delegation);
+		delegation = nfs4_get_valid_delegation(data->state->inode);
 		if (can_open_delegated(delegation, data->o_arg.fmode, claim))
 			goto unlock_no_action;
 		rcu_read_unlock();
-- 
2.20.1



