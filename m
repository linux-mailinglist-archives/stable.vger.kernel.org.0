Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B6A6AF087
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjCGSbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjCGSaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:30:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A18CAA24C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:24:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1533661549
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B48DC433D2;
        Tue,  7 Mar 2023 18:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213447;
        bh=Y9H0vfzBfuRJlO5+f3HU3XYFQBL4lVqLRRUyYSIzmbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XeWMloSMjToKIRqDWR1TItEiS1SoMUjUhId4xpnnDvZ9iApn9AklQqQW9fycD/Hhy
         t3qoKIwBLPDyg9redfiEQg+v50mC/x0nrKnkufv1Xy8aXbKfxYfRi00JDF9vQEAPVp
         IKhC/1IZXuAkWOw44jF+O5WqKwwo4Ka3q5z0mmTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Saravana Kannan <saravanak@google.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Douglas Anderson <dianders@chromium.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH 6.1 470/885] driver core: fw_devlink: Dont purge child fwnodes consumer links
Date:   Tue,  7 Mar 2023 17:56:44 +0100
Message-Id: <20230307170022.920618564@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 3a2dbc510c437ca392516b0105bad8e7970e6614 ]

When a device X is bound successfully to a driver, if it has a child
firmware node Y that doesn't have a struct device created by then, we
delete fwnode links where the child firmware node Y is the supplier. We
did this to avoid blocking the consumers of the child firmware node Y
from deferring probe indefinitely.

While that a step in the right direction, it's better to make the
consumers of the child firmware node Y to be consumers of the device X
because device X is probably implementing whatever functionality is
represented by child firmware node Y. By doing this, we capture the
device dependencies more accurately and ensure better
probe/suspend/resume ordering.

Signed-off-by: Saravana Kannan <saravanak@google.com>
Tested-by: Colin Foster <colin.foster@in-advantage.com>
Tested-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Luca Weiss <luca.weiss@fairphone.com> # qcom/sm7225-fairphone-fp4
Link: https://lore.kernel.org/r/20230207014207.1678715-2-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 6a6dfdf8b3ff ("driver core: fw_devlink: Allow marking a fwnode link as being part of a cycle")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 97 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 79 insertions(+), 18 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 816b0288579fd..d74a07ca36dff 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -53,11 +53,12 @@ static LIST_HEAD(deferred_sync);
 static unsigned int defer_sync_state_count = 1;
 static DEFINE_MUTEX(fwnode_link_lock);
 static bool fw_devlink_is_permissive(void);
+static void __fw_devlink_link_to_consumers(struct device *dev);
 static bool fw_devlink_drv_reg_done;
 static bool fw_devlink_best_effort;
 
 /**
- * fwnode_link_add - Create a link between two fwnode_handles.
+ * __fwnode_link_add - Create a link between two fwnode_handles.
  * @con: Consumer end of the link.
  * @sup: Supplier end of the link.
  *
@@ -73,22 +74,18 @@ static bool fw_devlink_best_effort;
  * Attempts to create duplicate links between the same pair of fwnode handles
  * are ignored and there is no reference counting.
  */
-int fwnode_link_add(struct fwnode_handle *con, struct fwnode_handle *sup)
+static int __fwnode_link_add(struct fwnode_handle *con,
+			     struct fwnode_handle *sup)
 {
 	struct fwnode_link *link;
-	int ret = 0;
-
-	mutex_lock(&fwnode_link_lock);
 
 	list_for_each_entry(link, &sup->consumers, s_hook)
 		if (link->consumer == con)
-			goto out;
+			return 0;
 
 	link = kzalloc(sizeof(*link), GFP_KERNEL);
-	if (!link) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!link)
+		return -ENOMEM;
 
 	link->supplier = sup;
 	INIT_LIST_HEAD(&link->s_hook);
@@ -99,9 +96,17 @@ int fwnode_link_add(struct fwnode_handle *con, struct fwnode_handle *sup)
 	list_add(&link->c_hook, &con->suppliers);
 	pr_debug("%pfwP Linked as a fwnode consumer to %pfwP\n",
 		 con, sup);
-out:
-	mutex_unlock(&fwnode_link_lock);
 
+	return 0;
+}
+
+int fwnode_link_add(struct fwnode_handle *con, struct fwnode_handle *sup)
+{
+	int ret;
+
+	mutex_lock(&fwnode_link_lock);
+	ret = __fwnode_link_add(con, sup);
+	mutex_unlock(&fwnode_link_lock);
 	return ret;
 }
 
@@ -180,6 +185,51 @@ void fw_devlink_purge_absent_suppliers(struct fwnode_handle *fwnode)
 }
 EXPORT_SYMBOL_GPL(fw_devlink_purge_absent_suppliers);
 
+/**
+ * __fwnode_links_move_consumers - Move consumer from @from to @to fwnode_handle
+ * @from: move consumers away from this fwnode
+ * @to: move consumers to this fwnode
+ *
+ * Move all consumer links from @from fwnode to @to fwnode.
+ */
+static void __fwnode_links_move_consumers(struct fwnode_handle *from,
+					  struct fwnode_handle *to)
+{
+	struct fwnode_link *link, *tmp;
+
+	list_for_each_entry_safe(link, tmp, &from->consumers, s_hook) {
+		__fwnode_link_add(link->consumer, to);
+		__fwnode_link_del(link);
+	}
+}
+
+/**
+ * __fw_devlink_pickup_dangling_consumers - Pick up dangling consumers
+ * @fwnode: fwnode from which to pick up dangling consumers
+ * @new_sup: fwnode of new supplier
+ *
+ * If the @fwnode has a corresponding struct device and the device supports
+ * probing (that is, added to a bus), then we want to let fw_devlink create
+ * MANAGED device links to this device, so leave @fwnode and its descendant's
+ * fwnode links alone.
+ *
+ * Otherwise, move its consumers to the new supplier @new_sup.
+ */
+static void __fw_devlink_pickup_dangling_consumers(struct fwnode_handle *fwnode,
+						   struct fwnode_handle *new_sup)
+{
+	struct fwnode_handle *child;
+
+	if (fwnode->dev && fwnode->dev->bus)
+		return;
+
+	fwnode->flags |= FWNODE_FLAG_NOT_DEVICE;
+	__fwnode_links_move_consumers(fwnode, new_sup);
+
+	fwnode_for_each_available_child_node(fwnode, child)
+		__fw_devlink_pickup_dangling_consumers(child, new_sup);
+}
+
 #ifdef CONFIG_SRCU
 static DEFINE_MUTEX(device_links_lock);
 DEFINE_STATIC_SRCU(device_links_srcu);
@@ -1273,16 +1323,23 @@ void device_links_driver_bound(struct device *dev)
 	 * them. So, fw_devlink no longer needs to create device links to any
 	 * of the device's suppliers.
 	 *
-	 * Also, if a child firmware node of this bound device is not added as
-	 * a device by now, assume it is never going to be added and make sure
-	 * other devices don't defer probe indefinitely by waiting for such a
-	 * child device.
+	 * Also, if a child firmware node of this bound device is not added as a
+	 * device by now, assume it is never going to be added. Make this bound
+	 * device the fallback supplier to the dangling consumers of the child
+	 * firmware node because this bound device is probably implementing the
+	 * child firmware node functionality and we don't want the dangling
+	 * consumers to defer probe indefinitely waiting for a device for the
+	 * child firmware node.
 	 */
 	if (dev->fwnode && dev->fwnode->dev == dev) {
 		struct fwnode_handle *child;
 		fwnode_links_purge_suppliers(dev->fwnode);
+		mutex_lock(&fwnode_link_lock);
 		fwnode_for_each_available_child_node(dev->fwnode, child)
-			fw_devlink_purge_absent_suppliers(child);
+			__fw_devlink_pickup_dangling_consumers(child,
+							       dev->fwnode);
+		__fw_devlink_link_to_consumers(dev);
+		mutex_unlock(&fwnode_link_lock);
 	}
 	device_remove_file(dev, &dev_attr_waiting_for_supplier);
 
@@ -1862,7 +1919,11 @@ static int fw_devlink_create_devlink(struct device *con,
 	    fwnode_is_ancestor_of(sup_handle, con->fwnode))
 		return -EINVAL;
 
-	sup_dev = get_dev_from_fwnode(sup_handle);
+	if (sup_handle->flags & FWNODE_FLAG_NOT_DEVICE)
+		sup_dev = fwnode_get_next_parent_dev(sup_handle);
+	else
+		sup_dev = get_dev_from_fwnode(sup_handle);
+
 	if (sup_dev) {
 		/*
 		 * If it's one of those drivers that don't actually bind to
-- 
2.39.2



