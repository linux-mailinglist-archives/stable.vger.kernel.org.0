Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FDE21FE29
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 22:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbgGNUGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 16:06:51 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:53264 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729442AbgGNUGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 16:06:51 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21820071-1500050 
        for multiple; Tue, 14 Jul 2020 21:06:47 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Gustavo Padovan <gustavo@padovan.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] dma-buf/sw_sync: Avoid recursive lock during fence signal.
Date:   Tue, 14 Jul 2020 21:06:44 +0100
Message-Id: <20200714200646.14041-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

Calltree:
  timeline_fence_release
  drm_sched_entity_wakeup
  dma_fence_signal_locked
  sync_timeline_signal
  sw_sync_ioctl

Releasing the reference to the fence in the fence signal callback
seems reasonable to me, so this patch avoids the locking issue in
sw_sync.

d3862e44daa7 ("dma-buf/sw-sync: Fix locking around sync_timeline lists")
fixed the recursive locking issue but caused an use-after-free. Later
d3c6dd1fb30d ("dma-buf/sw_sync: Synchronize signal vs syncpt free")
fixed the use-after-free but reintroduced the recursive locking issue.

In this attempt we avoid the use-after-free still because the release
function still always locks, and outside of the locking region in the
signal function we have properly refcounted references.

We furthermore also avoid the recurive lock by making sure that either:

1) We have a properly refcounted reference, preventing the signal from
   triggering the release function inside the locked region.
2) The refcount was already zero, and hence nobody will be able to trigger
   the release function from the signal function.

v2: Move dma_fence_signal() into second loop in preparation to moving
the callback out of the timeline obj->lock.

Fixes: d3c6dd1fb30d ("dma-buf/sw_sync: Synchronize signal vs syncpt free")
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Christian König <christian.koenig@amd.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/dma-buf/sw_sync.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 348b3a9170fa..807c82148062 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -192,6 +192,7 @@ static const struct dma_fence_ops timeline_fence_ops = {
 static void sync_timeline_signal(struct sync_timeline *obj, unsigned int inc)
 {
 	struct sync_pt *pt, *next;
+	LIST_HEAD(signal);
 
 	trace_sync_timeline(obj);
 
@@ -203,21 +204,32 @@ static void sync_timeline_signal(struct sync_timeline *obj, unsigned int inc)
 		if (!timeline_fence_signaled(&pt->base))
 			break;
 
-		list_del_init(&pt->link);
-		rb_erase(&pt->node, &obj->pt_tree);
-
 		/*
-		 * A signal callback may release the last reference to this
-		 * fence, causing it to be freed. That operation has to be
-		 * last to avoid a use after free inside this loop, and must
-		 * be after we remove the fence from the timeline in order to
-		 * prevent deadlocking on timeline->lock inside
-		 * timeline_fence_release().
+		 * We need to take a reference to avoid a release during
+		 * signalling (which can cause a recursive lock of obj->lock).
+		 * If refcount was already zero, another thread is already
+		 * taking care of destroying the fence.
 		 */
-		dma_fence_signal_locked(&pt->base);
+		if (!dma_fence_get_rcu(&pt->base))
+			continue;
+
+		list_move_tail(&pt->link, &signal);
+		rb_erase(&pt->node, &obj->pt_tree);
 	}
 
 	spin_unlock_irq(&obj->lock);
+
+	list_for_each_entry_safe(pt, next, &signal, link) {
+		/*
+		 * This needs to be cleared before release, otherwise the
+		 * timeline_fence_release function gets confused about also
+		 * removing the fence from the pt_tree.
+		 */
+		list_del_init(&pt->link);
+
+		dma_fence_signal(&pt->base);
+		dma_fence_put(&pt->base);
+	}
 }
 
 /**
-- 
2.20.1

