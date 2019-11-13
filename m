Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDB36FA1EF
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730537AbfKMCAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:00:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730532AbfKMCAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:00:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1404222CF;
        Wed, 13 Nov 2019 02:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610437;
        bh=14FlT2T4HOKsRc4HOSfLaCX/No1gD8cptgNS7B/0/z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1AUm3633KW0aBItU9pgHUaENHPkuEwtL/ATvgzjsbruEVfqYmbCOzEMSt/Qw0Hm2
         n4pCYgS2wp8aa02TL0jQNEOkI3Gs0b6CokFCwvyhh4rkWGUJiZMU7bFyEkJhrFiE3T
         gzJPRN1wdF7czaJJwAE20CWwFW7kVhmWpEpUbtWk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 37/68] NFSv4.x: fix lock recovery during delegation recall
Date:   Tue, 12 Nov 2019 20:59:01 -0500
Message-Id: <20191113015932.12655-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 44f411c353bf6d98d5a34f8f1b8605d43b2e50b8 ]

Running "./nfstest_delegation --runtest recall26" uncovers that
client doesn't recover the lock when we have an appending open,
where the initial open got a write delegation.

Instead of checking for the passed in open context against
the file lock's open context. Check that the state is the same.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index dff600ae0d747..6d7e27354ab94 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -91,7 +91,7 @@ int nfs4_check_delegation(struct inode *inode, fmode_t flags)
 	return nfs4_do_check_delegation(inode, flags, false);
 }
 
-static int nfs_delegation_claim_locks(struct nfs_open_context *ctx, struct nfs4_state *state, const nfs4_stateid *stateid)
+static int nfs_delegation_claim_locks(struct nfs4_state *state, const nfs4_stateid *stateid)
 {
 	struct inode *inode = state->inode;
 	struct file_lock *fl;
@@ -106,7 +106,7 @@ static int nfs_delegation_claim_locks(struct nfs_open_context *ctx, struct nfs4_
 	spin_lock(&flctx->flc_lock);
 restart:
 	list_for_each_entry(fl, list, fl_list) {
-		if (nfs_file_open_context(fl->fl_file) != ctx)
+		if (nfs_file_open_context(fl->fl_file)->state != state)
 			continue;
 		spin_unlock(&flctx->flc_lock);
 		status = nfs4_lock_delegation_recall(fl, state, stateid);
@@ -153,7 +153,7 @@ static int nfs_delegation_claim_opens(struct inode *inode,
 		seq = raw_seqcount_begin(&sp->so_reclaim_seqcount);
 		err = nfs4_open_delegation_recall(ctx, state, stateid, type);
 		if (!err)
-			err = nfs_delegation_claim_locks(ctx, state, stateid);
+			err = nfs_delegation_claim_locks(state, stateid);
 		if (!err && read_seqcount_retry(&sp->so_reclaim_seqcount, seq))
 			err = -EAGAIN;
 		mutex_unlock(&sp->so_delegreturn_mutex);
-- 
2.20.1

