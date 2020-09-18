Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130E726F495
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgIRDPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbgIRCBT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 223C921707;
        Fri, 18 Sep 2020 02:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394479;
        bh=ZWXCHAIhOxLvBohGGN9gIS4oL85Z+wVf83WCgrQzrfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBZtwxDmCyiu3Dwwu7j6hBUw13b/Ao8djJ/WCUjbedcbZDdwGhXwMvH/6K4MLG4iV
         QjFoD0+PDKCee6Mt2c8kmvpWNfGwWiFGszINg60V0APtJIB88/EHyalk8/VSPEmYx/
         Idy+pxojTMifM2y5ZQmE+c1OtTnqPPlcJaGVCSSI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 006/330] media: mc-device.c: fix memleak in media_device_register_entity
Date:   Thu, 17 Sep 2020 21:55:46 -0400
Message-Id: <20200918020110.2063155-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
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
 drivers/media/mc/mc-device.c | 65 ++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/media/mc/mc-device.c b/drivers/media/mc/mc-device.c
index e19df5165e78c..da80883511352 100644
--- a/drivers/media/mc/mc-device.c
+++ b/drivers/media/mc/mc-device.c
@@ -575,6 +575,38 @@ static void media_device_release(struct media_devnode *devnode)
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
@@ -632,6 +664,7 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 		 */
 		ret = media_graph_walk_init(&new, mdev);
 		if (ret) {
+			__media_device_unregister_entity(entity);
 			mutex_unlock(&mdev->graph_mutex);
 			return ret;
 		}
@@ -644,38 +677,6 @@ int __must_check media_device_register_entity(struct media_device *mdev,
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

