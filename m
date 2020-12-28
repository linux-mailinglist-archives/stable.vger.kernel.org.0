Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15592E670F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732276AbgL1NNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:13:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732263AbgL1NNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:13:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB041207CF;
        Mon, 28 Dec 2020 13:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161177;
        bh=NjVV+9KOdz4eRl+QE0xrsLLpG973f98FJxbwA9QoqPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vYyXNR504u4m1RYLSZAVFHLGyuGtoCpyi2Ji0hH5+UDgtsw7UhR76PfpKs58CHzf6
         ODtgsmm8d4csGeAyiMpUa4ACOQ8ithYvcAyZU7qXU7bzpo8rdyL8pxqn815rdi/KST
         7VkZiL2/aVbflpA9ObNhPnIBVc9Ank0Iqgn3eMhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 127/242] NFS: switch nfsiod to be an UNBOUND workqueue.
Date:   Mon, 28 Dec 2020 13:48:52 +0100
Message-Id: <20201228124910.950363440@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

[ Upstream commit bf701b765eaa82dd164d65edc5747ec7288bb5c3 ]

nfsiod is currently a concurrency-managed workqueue (CMWQ).
This means that workitems scheduled to nfsiod on a given CPU are queued
behind all other work items queued on any CMWQ on the same CPU.  This
can introduce unexpected latency.

Occaionally nfsiod can even cause excessive latency.  If the work item
to complete a CLOSE request calls the final iput() on an inode, the
address_space of that inode will be dismantled.  This takes time
proportional to the number of in-memory pages, which on a large host
working on large files (e.g..  5TB), can be a large number of pages
resulting in a noticable number of seconds.

We can avoid these latency problems by switching nfsiod to WQ_UNBOUND.
This causes each concurrent work item to gets a dedicated thread which
can be scheduled to an idle CPU.

There is precedent for this as several other filesystems use WQ_UNBOUND
workqueue for handling various async events.

Signed-off-by: NeilBrown <neilb@suse.de>
Fixes: ada609ee2ac2 ("workqueue: use WQ_MEM_RECLAIM instead of WQ_RESCUER")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 71a399f6805ac..f0534b356f071 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -2053,7 +2053,7 @@ static int nfsiod_start(void)
 {
 	struct workqueue_struct *wq;
 	dprintk("RPC:       creating workqueue nfsiod\n");
-	wq = alloc_workqueue("nfsiod", WQ_MEM_RECLAIM, 0);
+	wq = alloc_workqueue("nfsiod", WQ_MEM_RECLAIM | WQ_UNBOUND, 0);
 	if (wq == NULL)
 		return -ENOMEM;
 	nfsiod_workqueue = wq;
-- 
2.27.0



