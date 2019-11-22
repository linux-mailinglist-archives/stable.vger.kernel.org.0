Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95611106FF6
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbfKVKrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:47:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727642AbfKVKrq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:47:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D08B620637;
        Fri, 22 Nov 2019 10:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419665;
        bh=NKBfqAv6RndEcqs2ia5kpL1lCcer34AuTvHEDkQdefc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tU4V1d5gLVBP7EAL/PX5vZ3HONtc01dljn/j6QhyY/dzgyahB5GSa6UL2qzWz3ScU
         DZPn9gcHDZeGX+g6SW4XGZd2YDDLqms1OjIxhnQ3TovYEqHIJp290Doszl+hS4wRRv
         f5P6PtCdtZXc0t0hMyU9YGgci+HDW8XQeHQ9czu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 190/222] NFSv4.x: fix lock recovery during delegation recall
Date:   Fri, 22 Nov 2019 11:28:50 +0100
Message-Id: <20191122100916.019304202@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 46afd7cdcc378..9a8830a0f31f9 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -101,7 +101,7 @@ int nfs4_check_delegation(struct inode *inode, fmode_t flags)
 	return nfs4_do_check_delegation(inode, flags, false);
 }
 
-static int nfs_delegation_claim_locks(struct nfs_open_context *ctx, struct nfs4_state *state, const nfs4_stateid *stateid)
+static int nfs_delegation_claim_locks(struct nfs4_state *state, const nfs4_stateid *stateid)
 {
 	struct inode *inode = state->inode;
 	struct file_lock *fl;
@@ -116,7 +116,7 @@ static int nfs_delegation_claim_locks(struct nfs_open_context *ctx, struct nfs4_
 	spin_lock(&flctx->flc_lock);
 restart:
 	list_for_each_entry(fl, list, fl_list) {
-		if (nfs_file_open_context(fl->fl_file) != ctx)
+		if (nfs_file_open_context(fl->fl_file)->state != state)
 			continue;
 		spin_unlock(&flctx->flc_lock);
 		status = nfs4_lock_delegation_recall(fl, state, stateid);
@@ -163,7 +163,7 @@ static int nfs_delegation_claim_opens(struct inode *inode,
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



