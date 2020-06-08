Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997461F2C77
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgFHXRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:17:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730399AbgFHXRH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:17:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 367EC2083E;
        Mon,  8 Jun 2020 23:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658227;
        bh=jZy1as2piln0ccgJTMijtHWVIfUeLePmLd17SQs+ztc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZRTiBoEtGWDOXqrhnTDRI2LAgU2lwrpRe8V/rPXON18ofurM7TLEupHxNtH/uJ3x3
         ih4XYWGjDxVzKhMScTFfhxmpcOJjvH38SYdSpuejZ1moHe/Bop0Ce7Gkyjkkunh3Gp
         4s29a0N3fEn5JQxrFJ6NAFbt2YhQWO9TSovjCxgA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.6 240/606] Revert "virtio-balloon: Revert "virtio-balloon: Switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM""
Date:   Mon,  8 Jun 2020 19:06:05 -0400
Message-Id: <20200608231211.3363633-240-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 37681282be8e89ae8baf26753bf489837d74e08e which is
commit 835a6a649d0dd1b1f46759eb60fff2f63ed253a7 upstream.

Jiri and David agree that it is not needed in the 5.6.y tree, so revert
it.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: David Hildenbrand <david@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/virtio_balloon.c | 107 +++++++++++++-------------------
 1 file changed, 44 insertions(+), 63 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 341458fd95ca..44375a22307b 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/balloon_compaction.h>
+#include <linux/oom.h>
 #include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/mount.h>
@@ -27,7 +28,9 @@
  */
 #define VIRTIO_BALLOON_PAGES_PER_PAGE (unsigned)(PAGE_SIZE >> VIRTIO_BALLOON_PFN_SHIFT)
 #define VIRTIO_BALLOON_ARRAY_PFNS_MAX 256
-#define VIRTBALLOON_OOM_NOTIFY_PRIORITY 80
+/* Maximum number of (4k) pages to deflate on OOM notifications. */
+#define VIRTIO_BALLOON_OOM_NR_PAGES 256
+#define VIRTIO_BALLOON_OOM_NOTIFY_PRIORITY 80
 
 #define VIRTIO_BALLOON_FREE_PAGE_ALLOC_FLAG (__GFP_NORETRY | __GFP_NOWARN | \
 					     __GFP_NOMEMALLOC)
@@ -112,8 +115,11 @@ struct virtio_balloon {
 	/* Memory statistics */
 	struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
 
-	/* To register a shrinker to shrink memory upon memory pressure */
+	/* Shrinker to return free pages - VIRTIO_BALLOON_F_FREE_PAGE_HINT */
 	struct shrinker shrinker;
+
+	/* OOM notifier to deflate on OOM - VIRTIO_BALLOON_F_DEFLATE_ON_OOM */
+	struct notifier_block oom_nb;
 };
 
 static struct virtio_device_id id_table[] = {
@@ -788,50 +794,13 @@ static unsigned long shrink_free_pages(struct virtio_balloon *vb,
 	return blocks_freed * VIRTIO_BALLOON_HINT_BLOCK_PAGES;
 }
 
-static unsigned long leak_balloon_pages(struct virtio_balloon *vb,
-                                          unsigned long pages_to_free)
-{
-	return leak_balloon(vb, pages_to_free * VIRTIO_BALLOON_PAGES_PER_PAGE) /
-		VIRTIO_BALLOON_PAGES_PER_PAGE;
-}
-
-static unsigned long shrink_balloon_pages(struct virtio_balloon *vb,
-					  unsigned long pages_to_free)
-{
-	unsigned long pages_freed = 0;
-
-	/*
-	 * One invocation of leak_balloon can deflate at most
-	 * VIRTIO_BALLOON_ARRAY_PFNS_MAX balloon pages, so we call it
-	 * multiple times to deflate pages till reaching pages_to_free.
-	 */
-	while (vb->num_pages && pages_freed < pages_to_free)
-		pages_freed += leak_balloon_pages(vb,
-						  pages_to_free - pages_freed);
-
-	update_balloon_size(vb);
-
-	return pages_freed;
-}
-
 static unsigned long virtio_balloon_shrinker_scan(struct shrinker *shrinker,
 						  struct shrink_control *sc)
 {
-	unsigned long pages_to_free, pages_freed = 0;
 	struct virtio_balloon *vb = container_of(shrinker,
 					struct virtio_balloon, shrinker);
 
-	pages_to_free = sc->nr_to_scan;
-
-	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
-		pages_freed = shrink_free_pages(vb, pages_to_free);
-
-	if (pages_freed >= pages_to_free)
-		return pages_freed;
-
-	pages_freed += shrink_balloon_pages(vb, pages_to_free - pages_freed);
-
-	return pages_freed;
+	return shrink_free_pages(vb, sc->nr_to_scan);
 }
 
 static unsigned long virtio_balloon_shrinker_count(struct shrinker *shrinker,
@@ -839,26 +808,22 @@ static unsigned long virtio_balloon_shrinker_count(struct shrinker *shrinker,
 {
 	struct virtio_balloon *vb = container_of(shrinker,
 					struct virtio_balloon, shrinker);
-	unsigned long count;
-
-	count = vb->num_pages / VIRTIO_BALLOON_PAGES_PER_PAGE;
-	count += vb->num_free_page_blocks * VIRTIO_BALLOON_HINT_BLOCK_PAGES;
 
-	return count;
+	return vb->num_free_page_blocks * VIRTIO_BALLOON_HINT_BLOCK_PAGES;
 }
 
-static void virtio_balloon_unregister_shrinker(struct virtio_balloon *vb)
+static int virtio_balloon_oom_notify(struct notifier_block *nb,
+				     unsigned long dummy, void *parm)
 {
-	unregister_shrinker(&vb->shrinker);
-}
+	struct virtio_balloon *vb = container_of(nb,
+						 struct virtio_balloon, oom_nb);
+	unsigned long *freed = parm;
 
-static int virtio_balloon_register_shrinker(struct virtio_balloon *vb)
-{
-	vb->shrinker.scan_objects = virtio_balloon_shrinker_scan;
-	vb->shrinker.count_objects = virtio_balloon_shrinker_count;
-	vb->shrinker.seeks = DEFAULT_SEEKS;
+	*freed += leak_balloon(vb, VIRTIO_BALLOON_OOM_NR_PAGES) /
+		  VIRTIO_BALLOON_PAGES_PER_PAGE;
+	update_balloon_size(vb);
 
-	return register_shrinker(&vb->shrinker);
+	return NOTIFY_OK;
 }
 
 static int virtballoon_probe(struct virtio_device *vdev)
@@ -935,22 +900,35 @@ static int virtballoon_probe(struct virtio_device *vdev)
 			virtio_cwrite(vb->vdev, struct virtio_balloon_config,
 				      poison_val, &poison_val);
 		}
-	}
-	/*
-	 * We continue to use VIRTIO_BALLOON_F_DEFLATE_ON_OOM to decide if a
-	 * shrinker needs to be registered to relieve memory pressure.
-	 */
-	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM)) {
-		err = virtio_balloon_register_shrinker(vb);
+
+		/*
+		 * We're allowed to reuse any free pages, even if they are
+		 * still to be processed by the host.
+		 */
+		vb->shrinker.scan_objects = virtio_balloon_shrinker_scan;
+		vb->shrinker.count_objects = virtio_balloon_shrinker_count;
+		vb->shrinker.seeks = DEFAULT_SEEKS;
+		err = register_shrinker(&vb->shrinker);
 		if (err)
 			goto out_del_balloon_wq;
 	}
+	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM)) {
+		vb->oom_nb.notifier_call = virtio_balloon_oom_notify;
+		vb->oom_nb.priority = VIRTIO_BALLOON_OOM_NOTIFY_PRIORITY;
+		err = register_oom_notifier(&vb->oom_nb);
+		if (err < 0)
+			goto out_unregister_shrinker;
+	}
+
 	virtio_device_ready(vdev);
 
 	if (towards_target(vb))
 		virtballoon_changed(vdev);
 	return 0;
 
+out_unregister_shrinker:
+	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
+		unregister_shrinker(&vb->shrinker);
 out_del_balloon_wq:
 	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
 		destroy_workqueue(vb->balloon_wq);
@@ -989,8 +967,11 @@ static void virtballoon_remove(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb = vdev->priv;
 
-	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
-		virtio_balloon_unregister_shrinker(vb);
+	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
+		unregister_oom_notifier(&vb->oom_nb);
+	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
+		unregister_shrinker(&vb->shrinker);
+
 	spin_lock_irq(&vb->stop_update_lock);
 	vb->stop_update = true;
 	spin_unlock_irq(&vb->stop_update_lock);
-- 
2.25.1

