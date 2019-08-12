Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 093198A287
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 17:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfHLPmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 11:42:54 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:65245 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725648AbfHLPmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 11:42:54 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 17971654-1500050 
        for multiple; Mon, 12 Aug 2019 16:42:48 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Sean Paul <seanpaul@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH] dma-buf/sw_sync: Synchronize signal vs syncpt free
Date:   Mon, 12 Aug 2019 16:42:47 +0100
Message-Id: <20190812154247.20508-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During release of the syncpt, we remove it from the list of syncpt and
the tree, but only if it is not already been removed. However, during
signaling, we first remove the syncpt from the list. So, if we
concurrently free and signal the syncpt, the free may decide that it is
not part of the tree and immediately free itself -- meanwhile the
signaler goes onto to use the now freed datastructure.

In particular, we get struct by commit 0e2f733addbf ("dma-buf: make
dma_fence structure a bit smaller v2") as the cb_list is immediately
clobbered by the kfree_rcu.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111381
Fixes: d3862e44daa7 ("dma-buf/sw-sync: Fix locking around sync_timeline lists")
References: 0e2f733addbf ("dma-buf: make dma_fence structure a bit smaller v2")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Christian König <christian.koenig@amd.com>
Cc: <stable@vger.kernel.org> # v4.14+
---
 drivers/dma-buf/sw_sync.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 051f6c2873c7..27b1d549ed38 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -132,17 +132,14 @@ static void timeline_fence_release(struct dma_fence *fence)
 {
 	struct sync_pt *pt = dma_fence_to_sync_pt(fence);
 	struct sync_timeline *parent = dma_fence_parent(fence);
+	unsigned long flags;
 
+	spin_lock_irqsave(fence->lock, flags);
 	if (!list_empty(&pt->link)) {
-		unsigned long flags;
-
-		spin_lock_irqsave(fence->lock, flags);
-		if (!list_empty(&pt->link)) {
-			list_del(&pt->link);
-			rb_erase(&pt->node, &parent->pt_tree);
-		}
-		spin_unlock_irqrestore(fence->lock, flags);
+		list_del(&pt->link);
+		rb_erase(&pt->node, &parent->pt_tree);
 	}
+	spin_unlock_irqrestore(fence->lock, flags);
 
 	sync_timeline_put(parent);
 	dma_fence_free(fence);
-- 
2.23.0.rc1

