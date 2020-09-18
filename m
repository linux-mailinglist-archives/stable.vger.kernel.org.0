Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C64A26F1A2
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgIRCws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727074AbgIRCIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4445C238A1;
        Fri, 18 Sep 2020 02:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394886;
        bh=iIoe9rF3fxuu/KeHKsyO6kcjW6wrMwwZhFy097x6dj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUYJCTiQyrcpyNGOp6CpqIt8G8Em5u5H3f/tw9VluDUrQGYkRDD4GlqsncmPH6QRN
         M2DbYI90pIyYVt6TvY4VS0fA+oa2mU5gbmqKU0P0qjySwhVEi+hIVZI68mq1Wof6yj
         cqlEvMktewWxDuwzQuwLjOWocLr/D4IYI6zlsRTo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 002/206] media: mc-device.c: fix memleak in media_device_register_entity
Date:   Thu, 17 Sep 2020 22:04:38 -0400
Message-Id: <20200918020802.2065198-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

