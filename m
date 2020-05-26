Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DC31E2C59
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392154AbgEZTOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392149AbgEZTON (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:14:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A00820776;
        Tue, 26 May 2020 19:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520452;
        bh=4i048bTUX/rzSs3itOaoHVsC8lHmJIDaC2ihTsfRJjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIUJFLT7CmHFzU3k6Qq3zJEynze6jPLckNAF54TRFWS+2PqNC52o4OIYOeildZXB/
         spTzoqYj38u58iFYP5L0VJSxZA9hyhrRnJbh7o57XzfG42nyPV/ikmCN1AmYvlxWrX
         102nCHNNFlWN7NdcljRG0/Q9ftqGfg/f0CMDIHn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 086/126] virtio-balloon: Revert "virtio-balloon: Switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM"
Date:   Tue, 26 May 2020 20:53:43 +0200
Message-Id: <20200526183945.237904570@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 835a6a649d0dd1b1f46759eb60fff2f63ed253a7 ]

This reverts commit 5a6b4cc5b7a1892a8d7f63d6cbac6e0ae2a9d031.

It has been queued properly in the akpm tree, this version is just
creating conflicts.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_balloon.c | 107 +++++++++++++++++++-------------
 1 file changed, 63 insertions(+), 44 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 44375a22307b..341458fd95ca 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -14,7 +14,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/balloon_compaction.h>
-#include <linux/oom.h>
 #include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/mount.h>
@@ -28,9 +27,7 @@
  */
 #define VIRTIO_BALLOON_PAGES_PER_PAGE (unsigned)(PAGE_SIZE >> VIRTIO_BALLOON_PFN_SHIFT)
 #define VIRTIO_BALLOON_ARRAY_PFNS_MAX 256
-/* Maximum number of (4k) pages to deflate on OOM notifications. */
-#define VIRTIO_BALLOON_OOM_NR_PAGES 256
-#define VIRTIO_BALLOON_OOM_NOTIFY_PRIORITY 80
+#define VIRTBALLOON_OOM_NOTIFY_PRIORITY 80
 
 #define VIRTIO_BALLOON_FREE_PAGE_ALLOC_FLAG (__GFP_NORETRY | __GFP_NOWARN | \
 					     __GFP_NOMEMALLOC)
@@ -115,11 +112,8 @@ struct virtio_balloon {
 	/* Memory statistics */
 	struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
 
-	/* Shrinker to return free pages - VIRTIO_BALLOON_F_FREE_PAGE_HINT */
+	/* To register a shrinker to shrink memory upon memory pressure */
 	struct shrinker shrinker;
-
-	/* OOM notifier to deflate on OOM - VIRTIO_BALLOON_F_DEFLATE_ON_OOM */
-	struct notifier_block oom_nb;
 };
 
 static struct virtio_device_id id_table[] = {
@@ -794,13 +788,50 @@ static unsigned long shrink_free_pages(struct virtio_balloon *vb,
 	return blocks_freed * VIRTIO_BALLOON_HINT_BLOCK_PAGES;
 }
 
+static unsigned long leak_balloon_pages(struct virtio_balloon *vb,
+                                          unsigned long pages_to_free)
+{
+	return leak_balloon(vb, pages_to_free * VIRTIO_BALLOON_PAGES_PER_PAGE) /
+		VIRTIO_BALLOON_PAGES_PER_PAGE;
+}
+
+static unsigned long shrink_balloon_pages(struct virtio_balloon *vb,
+					  unsigned long pages_to_free)
+{
+	unsigned long pages_freed = 0;
+
+	/*
+	 * One invocation of leak_balloon can deflate at most
+	 * VIRTIO_BALLOON_ARRAY_PFNS_MAX balloon pages, so we call it
+	 * multiple times to deflate pages till reaching pages_to_free.
+	 */
+	while (vb->num_pages && pages_freed < pages_to_free)
+		pages_freed += leak_balloon_pages(vb,
+						  pages_to_free - pages_freed);
+
+	update_balloon_size(vb);
+
+	return pages_freed;
+}
+
 static unsigned long virtio_balloon_shrinker_scan(struct shrinker *shrinker,
 						  struct shrink_control *sc)
 {
+	unsigned long pages_to_free, pages_freed = 0;
 	struct virtio_balloon *vb = container_of(shrinker,
 					struct virtio_balloon, shrinker);
 
-	return shrink_free_pages(vb, sc->nr_to_scan);
+	pages_to_free = sc->nr_to_scan;
+
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
+		pages_freed = shrink_free_pages(vb, pages_to_free);
+
+	if (pages_freed >= pages_to_free)
+		return pages_freed;
+
+	pages_freed += shrink_balloon_pages(vb, pages_to_free - pages_freed);
+
+	return pages_freed;
 }
 
 static unsigned long virtio_balloon_shrinker_count(struct shrinker *shrinker,
@@ -808,22 +839,26 @@ static unsigned long virtio_balloon_shrinker_count(struct shrinker *shrinker,
 {
 	struct virtio_balloon *vb = container_of(shrinker,
 					struct virtio_balloon, shrinker);
+	unsigned long count;
+
+	count = vb->num_pages / VIRTIO_BALLOON_PAGES_PER_PAGE;
+	count += vb->num_free_page_blocks * VIRTIO_BALLOON_HINT_BLOCK_PAGES;
 
-	return vb->num_free_page_blocks * VIRTIO_BALLOON_HINT_BLOCK_PAGES;
+	return count;
 }
 
-static int virtio_balloon_oom_notify(struct notifier_block *nb,
-				     unsigned long dummy, void *parm)
+static void virtio_balloon_unregister_shrinker(struct virtio_balloon *vb)
 {
-	struct virtio_balloon *vb = container_of(nb,
-						 struct virtio_balloon, oom_nb);
-	unsigned long *freed = parm;
+	unregister_shrinker(&vb->shrinker);
+}
 
-	*freed += leak_balloon(vb, VIRTIO_BALLOON_OOM_NR_PAGES) /
-		  VIRTIO_BALLOON_PAGES_PER_PAGE;
-	update_balloon_size(vb);
+static int virtio_balloon_register_shrinker(struct virtio_balloon *vb)
+{
+	vb->shrinker.scan_objects = virtio_balloon_shrinker_scan;
+	vb->shrinker.count_objects = virtio_balloon_shrinker_count;
+	vb->shrinker.seeks = DEFAULT_SEEKS;
 
-	return NOTIFY_OK;
+	return register_shrinker(&vb->shrinker);
 }
 
 static int virtballoon_probe(struct virtio_device *vdev)
@@ -900,35 +935,22 @@ static int virtballoon_probe(struct virtio_device *vdev)
 			virtio_cwrite(vb->vdev, struct virtio_balloon_config,
 				      poison_val, &poison_val);
 		}
-
-		/*
-		 * We're allowed to reuse any free pages, even if they are
-		 * still to be processed by the host.
-		 */
-		vb->shrinker.scan_objects = virtio_balloon_shrinker_scan;
-		vb->shrinker.count_objects = virtio_balloon_shrinker_count;
-		vb->shrinker.seeks = DEFAULT_SEEKS;
-		err = register_shrinker(&vb->shrinker);
+	}
+	/*
+	 * We continue to use VIRTIO_BALLOON_F_DEFLATE_ON_OOM to decide if a
+	 * shrinker needs to be registered to relieve memory pressure.
+	 */
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM)) {
+		err = virtio_balloon_register_shrinker(vb);
 		if (err)
 			goto out_del_balloon_wq;
 	}
-	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM)) {
-		vb->oom_nb.notifier_call = virtio_balloon_oom_notify;
-		vb->oom_nb.priority = VIRTIO_BALLOON_OOM_NOTIFY_PRIORITY;
-		err = register_oom_notifier(&vb->oom_nb);
-		if (err < 0)
-			goto out_unregister_shrinker;
-	}
-
 	virtio_device_ready(vdev);
 
 	if (towards_target(vb))
 		virtballoon_changed(vdev);
 	return 0;
 
-out_unregister_shrinker:
-	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
-		unregister_shrinker(&vb->shrinker);
 out_del_balloon_wq:
 	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
 		destroy_workqueue(vb->balloon_wq);
@@ -967,11 +989,8 @@ static void virtballoon_remove(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb = vdev->priv;
 
-	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
-		unregister_oom_notifier(&vb->oom_nb);
-	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
-		unregister_shrinker(&vb->shrinker);
-
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
+		virtio_balloon_unregister_shrinker(vb);
 	spin_lock_irq(&vb->stop_update_lock);
 	vb->stop_update = true;
 	spin_unlock_irq(&vb->stop_update_lock);
-- 
2.25.1



