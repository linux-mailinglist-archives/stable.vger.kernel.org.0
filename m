Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7AD2E6804
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441850AbgL1Qbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:31:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730489AbgL1NEj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:04:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B44322582;
        Mon, 28 Dec 2020 13:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160639;
        bh=dk4t7gfGTMw5YQaATINpxtv/8lOtwfdQJeyfNPjtTl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DuTukr2UQrqgDZn8lobX1S0U1J4vMTsN1VSj/XqIzfkvoIZpZZ6glTIQeL1LTDLs9
         Cb3eqGyl8CTjM8zlZ4m02BCZmvuIkKtCnIC+6iovxH3xeIk6B/Z+2rP2NnUt6obuZq
         Zr5COOFVFHGKgeQhIWV4WIuovFaSAPg6a9sxEp2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 089/175] NFS: switch nfsiod to be an UNBOUND workqueue.
Date:   Mon, 28 Dec 2020 13:49:02 +0100
Message-Id: <20201228124857.561327172@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
index 851274b25d394..6c0035761d170 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1995,7 +1995,7 @@ static int nfsiod_start(void)
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



