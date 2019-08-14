Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96EA18C8EA
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbfHNCez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:34:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728393AbfHNCNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:13:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35D8C20874;
        Wed, 14 Aug 2019 02:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748821;
        bh=HhuOvXsRRQdUoKPWkyqwEaCj+LcSW+xjFEAQmCwzBfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F24UVST1a7aaI7AdVYYp0HxJAxAP7hIqPD7fRqua0vXz9Y/qkSHaxNCBtNDduTugy
         3KYHC6dNbIyMGtQK5A+yfUUtKrDqUPb/es+XnChNdaa1WZw2CeD8a30giM6sLJRQ2w
         8+N1b1VFb41MHPIA0Exonz7SoRwk2qqBzER41E98=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 082/123] NFSv4.1: Fix open stateid recovery
Date:   Tue, 13 Aug 2019 22:10:06 -0400
Message-Id: <20190814021047.14828-82-sashal@kernel.org>
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

[ Upstream commit 27a30cf64a5cbe2105e4ff9613246b32d584766a ]

The logic for checking in nfs41_check_open_stateid() whether the state
is supported by a delegation is inverted. In addition, it makes more
sense to perform that check before we check for expired locks.

Fixes: 8a64c4ef106d1 ("NFSv4.1: Even if the stateid is OK,...")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 65 +++++++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 27 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 11a5aa46e64c3..b3fd75c8629a4 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1654,6 +1654,14 @@ static void nfs_state_set_open_stateid(struct nfs4_state *state,
 	write_sequnlock(&state->seqlock);
 }
 
+static void nfs_state_clear_open_state_flags(struct nfs4_state *state)
+{
+	clear_bit(NFS_O_RDWR_STATE, &state->flags);
+	clear_bit(NFS_O_WRONLY_STATE, &state->flags);
+	clear_bit(NFS_O_RDONLY_STATE, &state->flags);
+	clear_bit(NFS_OPEN_STATE, &state->flags);
+}
+
 static void nfs_state_set_delegation(struct nfs4_state *state,
 		const nfs4_stateid *deleg_stateid,
 		fmode_t fmode)
@@ -2045,13 +2053,7 @@ static int nfs4_open_recover(struct nfs4_opendata *opendata, struct nfs4_state *
 {
 	int ret;
 
-	/* Don't trigger recovery in nfs_test_and_clear_all_open_stateid */
-	clear_bit(NFS_O_RDWR_STATE, &state->flags);
-	clear_bit(NFS_O_WRONLY_STATE, &state->flags);
-	clear_bit(NFS_O_RDONLY_STATE, &state->flags);
 	/* memory barrier prior to reading state->n_* */
-	clear_bit(NFS_DELEGATED_STATE, &state->flags);
-	clear_bit(NFS_OPEN_STATE, &state->flags);
 	smp_rmb();
 	ret = nfs4_open_recover_helper(opendata, FMODE_READ|FMODE_WRITE);
 	if (ret != 0)
@@ -2127,6 +2129,8 @@ static int nfs4_open_reclaim(struct nfs4_state_owner *sp, struct nfs4_state *sta
 	ctx = nfs4_state_find_open_context(state);
 	if (IS_ERR(ctx))
 		return -EAGAIN;
+	clear_bit(NFS_DELEGATED_STATE, &state->flags);
+	nfs_state_clear_open_state_flags(state);
 	ret = nfs4_do_open_reclaim(ctx, state);
 	put_nfs_open_context(ctx);
 	return ret;
@@ -2669,6 +2673,7 @@ static int nfs40_open_expired(struct nfs4_state_owner *sp, struct nfs4_state *st
 {
 	/* NFSv4.0 doesn't allow for delegation recovery on open expire */
 	nfs40_clear_delegation_stateid(state);
+	nfs_state_clear_open_state_flags(state);
 	return nfs4_open_expired(sp, state);
 }
 
@@ -2711,13 +2716,13 @@ static int nfs41_test_and_free_expired_stateid(struct nfs_server *server,
 	return -NFS4ERR_EXPIRED;
 }
 
-static void nfs41_check_delegation_stateid(struct nfs4_state *state)
+static int nfs41_check_delegation_stateid(struct nfs4_state *state)
 {
 	struct nfs_server *server = NFS_SERVER(state->inode);
 	nfs4_stateid stateid;
 	struct nfs_delegation *delegation;
 	const struct cred *cred = NULL;
-	int status;
+	int status, ret = NFS_OK;
 
 	/* Get the delegation credential for use by test/free_stateid */
 	rcu_read_lock();
@@ -2725,20 +2730,15 @@ static void nfs41_check_delegation_stateid(struct nfs4_state *state)
 	if (delegation == NULL) {
 		rcu_read_unlock();
 		nfs_state_clear_delegation(state);
-		return;
+		return NFS_OK;
 	}
 
 	nfs4_stateid_copy(&stateid, &delegation->stateid);
-	if (test_bit(NFS_DELEGATION_REVOKED, &delegation->flags)) {
-		rcu_read_unlock();
-		nfs_state_clear_delegation(state);
-		return;
-	}
 
 	if (!test_and_clear_bit(NFS_DELEGATION_TEST_EXPIRED,
 				&delegation->flags)) {
 		rcu_read_unlock();
-		return;
+		return NFS_OK;
 	}
 
 	if (delegation->cred)
@@ -2748,8 +2748,24 @@ static void nfs41_check_delegation_stateid(struct nfs4_state *state)
 	trace_nfs4_test_delegation_stateid(state, NULL, status);
 	if (status == -NFS4ERR_EXPIRED || status == -NFS4ERR_BAD_STATEID)
 		nfs_finish_clear_delegation_stateid(state, &stateid);
+	else
+		ret = status;
 
 	put_cred(cred);
+	return ret;
+}
+
+static void nfs41_delegation_recover_stateid(struct nfs4_state *state)
+{
+	nfs4_stateid tmp;
+
+	if (test_bit(NFS_DELEGATED_STATE, &state->flags) &&
+	    nfs4_copy_delegation_stateid(state->inode, state->state,
+				&tmp, NULL) &&
+	    nfs4_stateid_match_other(&state->stateid, &tmp))
+		nfs_state_set_delegation(state, &tmp, state->state);
+	else
+		nfs_state_clear_delegation(state);
 }
 
 /**
@@ -2819,21 +2835,12 @@ static int nfs41_check_open_stateid(struct nfs4_state *state)
 	const struct cred *cred = state->owner->so_cred;
 	int status;
 
-	if (test_bit(NFS_OPEN_STATE, &state->flags) == 0) {
-		if (test_bit(NFS_DELEGATED_STATE, &state->flags) == 0)  {
-			if (nfs4_have_delegation(state->inode, state->state))
-				return NFS_OK;
-			return -NFS4ERR_OPENMODE;
-		}
+	if (test_bit(NFS_OPEN_STATE, &state->flags) == 0)
 		return -NFS4ERR_BAD_STATEID;
-	}
 	status = nfs41_test_and_free_expired_stateid(server, stateid, cred);
 	trace_nfs4_test_open_stateid(state, NULL, status);
 	if (status == -NFS4ERR_EXPIRED || status == -NFS4ERR_BAD_STATEID) {
-		clear_bit(NFS_O_RDONLY_STATE, &state->flags);
-		clear_bit(NFS_O_WRONLY_STATE, &state->flags);
-		clear_bit(NFS_O_RDWR_STATE, &state->flags);
-		clear_bit(NFS_OPEN_STATE, &state->flags);
+		nfs_state_clear_open_state_flags(state);
 		stateid->type = NFS4_INVALID_STATEID_TYPE;
 		return status;
 	}
@@ -2846,7 +2853,11 @@ static int nfs41_open_expired(struct nfs4_state_owner *sp, struct nfs4_state *st
 {
 	int status;
 
-	nfs41_check_delegation_stateid(state);
+	status = nfs41_check_delegation_stateid(state);
+	if (status != NFS_OK)
+		return status;
+	nfs41_delegation_recover_stateid(state);
+
 	status = nfs41_check_expired_locks(state);
 	if (status != NFS_OK)
 		return status;
-- 
2.20.1

