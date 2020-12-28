Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790B72E6922
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441131AbgL1QpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:45:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:53214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728827AbgL1M4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:56:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D7E922582;
        Mon, 28 Dec 2020 12:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160167;
        bh=P5ggYJNhpB8IrdBefx32WiCzNydd6ToP4X3ZJroicdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxro5P6nI5JLmVki6CWfmXhJySt0qZ7jDo3MOE5jUaulu16O8tQIwFTyuQEOwK+Dj
         P/6AvjIWdLt14yRsN4xLcz52CGYqr5c+UmWXxHNmKPOYOr94EyWiOA0ir9e0eSJEHq
         mQ4tTkO0eRQw32iKAYhFNtcGSREq01fkINCxg24s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 062/132] NFS: switch nfsiod to be an UNBOUND workqueue.
Date:   Mon, 28 Dec 2020 13:49:06 +0100
Message-Id: <20201228124849.453204274@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
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
index d25b55ceb9d58..b152366411917 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1964,7 +1964,7 @@ static int nfsiod_start(void)
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



