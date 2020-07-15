Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A61C22097B
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 12:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgGOKEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 06:04:45 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:56683 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727883AbgGOKEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 06:04:44 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21824638-1500050 
        for multiple; Wed, 15 Jul 2020 11:04:39 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] dma-buf/sw_sync: Avoid recursive lock during fence signal
Date:   Wed, 15 Jul 2020 11:04:31 +0100
Message-Id: <20200715100432.13928-2-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200715100432.13928-1-chris@chris-wilson.co.uk>
References: <20200715100432.13928-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a signal callback releases the sw_sync fence, that will trigger a
deadlock as the timeline_fence_release recurses onto the fence->lock
(used both for signaling and the the timeline tree).

If we always hold a reference for an unsignaled fence held by the
timeline, we no longer need to detach the fence from the timeline upon
release. This is only possible since commit ea4d5a270b57
("dma-buf/sw_sync: force signal all unsignaled fences on dying timeline")
where we introduced decoupling of the fences from the timeline upon release.

Reported-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Fixes: d3c6dd1fb30d ("dma-buf/sw_sync: Synchronize signal vs syncpt free")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Christian König <christian.koenig@amd.com>
Cc: <stable@vger.kernel.org>
---
 drivers/dma-buf/sw_sync.c | 32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 348b3a9170fa..4cc2ac03a84a 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -130,16 +130,7 @@ static const char *timeline_fence_get_timeline_name(struct dma_fence *fence)
 
 static void timeline_fence_release(struct dma_fence *fence)
 {
-	struct sync_pt *pt = dma_fence_to_sync_pt(fence);
 	struct sync_timeline *parent = dma_fence_parent(fence);
-	unsigned long flags;
-
-	spin_lock_irqsave(fence->lock, flags);
-	if (!list_empty(&pt->link)) {
-		list_del(&pt->link);
-		rb_erase(&pt->node, &parent->pt_tree);
-	}
-	spin_unlock_irqrestore(fence->lock, flags);
 
 	sync_timeline_put(parent);
 	dma_fence_free(fence);
@@ -203,18 +194,11 @@ static void sync_timeline_signal(struct sync_timeline *obj, unsigned int inc)
 		if (!timeline_fence_signaled(&pt->base))
 			break;
 
-		list_del_init(&pt->link);
+		list_del(&pt->link);
 		rb_erase(&pt->node, &obj->pt_tree);
 
-		/*
-		 * A signal callback may release the last reference to this
-		 * fence, causing it to be freed. That operation has to be
-		 * last to avoid a use after free inside this loop, and must
-		 * be after we remove the fence from the timeline in order to
-		 * prevent deadlocking on timeline->lock inside
-		 * timeline_fence_release().
-		 */
 		dma_fence_signal_locked(&pt->base);
+		dma_fence_put(&pt->base);
 	}
 
 	spin_unlock_irq(&obj->lock);
@@ -261,13 +245,9 @@ static struct sync_pt *sync_pt_create(struct sync_timeline *obj,
 			} else if (cmp < 0) {
 				p = &parent->rb_left;
 			} else {
-				if (dma_fence_get_rcu(&other->base)) {
-					sync_timeline_put(obj);
-					kfree(pt);
-					pt = other;
-					goto unlock;
-				}
-				p = &parent->rb_left;
+				dma_fence_put(&pt->base);
+				pt = other;
+				goto unlock;
 			}
 		}
 		rb_link_node(&pt->node, parent, p);
@@ -278,6 +258,7 @@ static struct sync_pt *sync_pt_create(struct sync_timeline *obj,
 			      parent ? &rb_entry(parent, typeof(*pt), node)->link : &obj->pt_list);
 	}
 unlock:
+	dma_fence_get(&pt->base); /* keep a ref for the timeline */
 	spin_unlock_irq(&obj->lock);
 
 	return pt;
@@ -316,6 +297,7 @@ static int sw_sync_debugfs_release(struct inode *inode, struct file *file)
 	list_for_each_entry_safe(pt, next, &obj->pt_list, link) {
 		dma_fence_set_error(&pt->base, -ENOENT);
 		dma_fence_signal_locked(&pt->base);
+		dma_fence_put(&pt->base);
 	}
 
 	spin_unlock_irq(&obj->lock);
-- 
2.20.1

