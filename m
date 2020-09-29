Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6B927CC27
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732711AbgI2Mdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:33:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729667AbgI2LW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:22:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7780123A79;
        Tue, 29 Sep 2020 11:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378427;
        bh=iIoe9rF3fxuu/KeHKsyO6kcjW6wrMwwZhFy097x6dj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1fTESVjpfRHhiFCvvCQooBrR2eKIykJvEdJDu5i11LOcMPM6ghQQ15PXfyeJu8XNJ
         Dp9nZcj7sh8VbsE/eiKWEpcId1X2DTz/a+/dwjzF5jR4oFg8XO4mVCVBYhh36K9bMH
         IrU+19qZGTyidFYD2WjlEcsT3dsz8/hdt7mJKt/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        zhengbin <zhengbin13@huawei.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 002/245] media: mc-device.c: fix memleak in media_device_register_entity
Date:   Tue, 29 Sep 2020 12:57:33 +0200
Message-Id: <20200929105947.106371476@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit 713f871b30a66dc4daff4d17b760c9916aaaf2e1 ]

In media_device_register_entity, if media_graph_walk_init fails,
need to free the previously memory.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/media-device.c | 65 ++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index ed518b1f82e4a..d04ed438a45de 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -568,6 +568,38 @@ static void media_device_release(struct media_devnode *devnode)
 	dev_dbg(devnode->parent, "Media device released\n");
 }
 
+static void __media_device_unregister_entity(struct media_entity *entity)
+{
+	struct media_device *mdev = entity->graph_obj.mdev;
+	struct media_link *link, *tmp;
+	struct media_interface *intf;
+	unsigned int i;
+
+	ida_free(&mdev->entity_internal_idx, entity->internal_idx);
+
+	/* Remove all interface links pointing to this entity */
+	list_for_each_entry(intf, &mdev->interfaces, graph_obj.list) {
+		list_for_each_entry_safe(link, tmp, &intf->links, list) {
+			if (link->entity == entity)
+				__media_remove_intf_link(link);
+		}
+	}
+
+	/* Remove all data links that belong to this entity */
+	__media_entity_remove_links(entity);
+
+	/* Remove all pads that belong to this entity */
+	for (i = 0; i < entity->num_pads; i++)
+		media_gobj_destroy(&entity->pads[i].graph_obj);
+
+	/* Remove the entity */
+	media_gobj_destroy(&entity->graph_obj);
+
+	/* invoke entity_notify callbacks to handle entity removal?? */
+
+	entity->graph_obj.mdev = NULL;
+}
+
 /**
  * media_device_register_entity - Register an entity with a media device
  * @mdev:	The media device
@@ -625,6 +657,7 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 		 */
 		ret = media_graph_walk_init(&new, mdev);
 		if (ret) {
+			__media_device_unregister_entity(entity);
 			mutex_unlock(&mdev->graph_mutex);
 			return ret;
 		}
@@ -637,38 +670,6 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 }
 EXPORT_SYMBOL_GPL(media_device_register_entity);
 
-static void __media_device_unregister_entity(struct media_entity *entity)
-{
-	struct media_device *mdev = entity->graph_obj.mdev;
-	struct media_link *link, *tmp;
-	struct media_interface *intf;
-	unsigned int i;
-
-	ida_free(&mdev->entity_internal_idx, entity->internal_idx);
-
-	/* Remove all interface links pointing to this entity */
-	list_for_each_entry(intf, &mdev->interfaces, graph_obj.list) {
-		list_for_each_entry_safe(link, tmp, &intf->links, list) {
-			if (link->entity == entity)
-				__media_remove_intf_link(link);
-		}
-	}
-
-	/* Remove all data links that belong to this entity */
-	__media_entity_remove_links(entity);
-
-	/* Remove all pads that belong to this entity */
-	for (i = 0; i < entity->num_pads; i++)
-		media_gobj_destroy(&entity->pads[i].graph_obj);
-
-	/* Remove the entity */
-	media_gobj_destroy(&entity->graph_obj);
-
-	/* invoke entity_notify callbacks to handle entity removal?? */
-
-	entity->graph_obj.mdev = NULL;
-}
-
 void media_device_unregister_entity(struct media_entity *entity)
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
-- 
2.25.1



