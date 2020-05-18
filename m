Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AD91D8514
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgERR6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731891AbgERR6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:58:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD1D320715;
        Mon, 18 May 2020 17:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824702;
        bh=aBpD8Zk58zULU1+vPiY62RVuKiddyR9oFgNH3T0LIJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgHI+GOKtMHpj4SVcypnh19KAfUQQsVq3hQ66r+YJsdP8Xo2nDgQUYnXrt04SzU3y
         h9dqDVL6pt45he8inLnCBUyftvztTrabuiGPFxF60CtWQe7hxW3V7YAX1NUXPmbbWA
         IH0Wy6wkJDyuYRqwpAkg6z9DSk8R2iXnZ4DJbEJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seiichi Ikarashi <s.ikarashi@fujitsu.com>,
        Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/147] nfs: fix NULL deference in nfs4_get_valid_delegation
Date:   Mon, 18 May 2020 19:36:43 +0200
Message-Id: <20200518173523.689033645@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 29fe839976266bc7c55b927360a1daae57477723 ]

We add the new state to the nfsi->open_states list, making it
potentially visible to other threads, before we've finished initializing
it.

That wasn't a problem when all the readers were also taking the i_lock
(as we do here), but since we switched to RCU, there's now a possibility
that a reader could see the partially initialized state.

Symptoms observed were a crash when another thread called
nfs4_get_valid_delegation() on a NULL inode, resulting in an oops like:

	BUG: unable to handle page fault for address: ffffffffffffffb0 ...
	RIP: 0010:nfs4_get_valid_delegation+0x6/0x30 [nfsv4] ...
	Call Trace:
	 nfs4_open_prepare+0x80/0x1c0 [nfsv4]
	 __rpc_execute+0x75/0x390 [sunrpc]
	 ? finish_task_switch+0x75/0x260
	 rpc_async_schedule+0x29/0x40 [sunrpc]
	 process_one_work+0x1ad/0x370
	 worker_thread+0x30/0x390
	 ? create_worker+0x1a0/0x1a0
	 kthread+0x10c/0x130
	 ? kthread_park+0x80/0x80
	 ret_from_fork+0x22/0x30

Fixes: 9ae075fdd190 "NFSv4: Convert open state lookup to use RCU"
Reviewed-by: Seiichi Ikarashi <s.ikarashi@fujitsu.com>
Tested-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Tested-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index b53bcf40e2a77..ea680f619438b 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -733,9 +733,9 @@ nfs4_get_open_state(struct inode *inode, struct nfs4_state_owner *owner)
 		state = new;
 		state->owner = owner;
 		atomic_inc(&owner->so_count);
-		list_add_rcu(&state->inode_states, &nfsi->open_states);
 		ihold(inode);
 		state->inode = inode;
+		list_add_rcu(&state->inode_states, &nfsi->open_states);
 		spin_unlock(&inode->i_lock);
 		/* Note: The reclaim code dictates that we add stateless
 		 * and read-only stateids to the end of the list */
-- 
2.20.1



