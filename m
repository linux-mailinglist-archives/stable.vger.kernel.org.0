Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E2D6AF049
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbjCGS3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbjCGS3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:29:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CBCA401C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:22:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 948CCCE1C81
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF42C433EF;
        Tue,  7 Mar 2023 18:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213346;
        bh=Nk5H0I7JPaC3ue5FS+EFek00NnTSwadlxPbiPou7tHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zx0jjV9mG3L+ACLvpWojBI2VaydP/XqUiiZoP2QdHLBHxQa6XrqUMij/rJQo9uiHv
         RYHoZ+mkM/INchFjrTnSjLV48hIKLgEQDqh0kvr1m5eL7qtyhHjJ0pALLzgc5/Vo5o
         v2bJSH/yTRw/zaRGEFylpswjITEB7/FGZE6/lddE=
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
Subject: [PATCH 6.1 471/885] driver core: fw_devlink: Allow marking a fwnode link as being part of a cycle
Date:   Tue,  7 Mar 2023 17:56:45 +0100
Message-Id: <20230307170022.964168381@linuxfoundation.org>
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

[ Upstream commit 6a6dfdf8b3ff337be5a447e9f4e71969f18370ad ]

To improve detection and handling of dependency cycles, we need to be
able to mark fwnode links as being part of cycles. fwnode links marked
as being part of a cycle should not block their consumers from probing.

Fixes: 2de9d8e0d2fe ("driver core: fw_devlink: Improve handling of cyclic dependencies")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Tested-by: Colin Foster <colin.foster@in-advantage.com>
Tested-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Luca Weiss <luca.weiss@fairphone.com> # qcom/sm7225-fairphone-fp4
Link: https://lore.kernel.org/r/20230207014207.1678715-7-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c    | 50 +++++++++++++++++++++++++++++++++---------
 include/linux/fwnode.h | 11 +++++++++-
 2 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index d74a07ca36dff..24c48fe3a0252 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -75,13 +75,15 @@ static bool fw_devlink_best_effort;
  * are ignored and there is no reference counting.
  */
 static int __fwnode_link_add(struct fwnode_handle *con,
-			     struct fwnode_handle *sup)
+			     struct fwnode_handle *sup, u8 flags)
 {
 	struct fwnode_link *link;
 
 	list_for_each_entry(link, &sup->consumers, s_hook)
-		if (link->consumer == con)
+		if (link->consumer == con) {
+			link->flags |= flags;
 			return 0;
+		}
 
 	link = kzalloc(sizeof(*link), GFP_KERNEL);
 	if (!link)
@@ -91,6 +93,7 @@ static int __fwnode_link_add(struct fwnode_handle *con,
 	INIT_LIST_HEAD(&link->s_hook);
 	link->consumer = con;
 	INIT_LIST_HEAD(&link->c_hook);
+	link->flags = flags;
 
 	list_add(&link->s_hook, &sup->consumers);
 	list_add(&link->c_hook, &con->suppliers);
@@ -105,7 +108,7 @@ int fwnode_link_add(struct fwnode_handle *con, struct fwnode_handle *sup)
 	int ret;
 
 	mutex_lock(&fwnode_link_lock);
-	ret = __fwnode_link_add(con, sup);
+	ret = __fwnode_link_add(con, sup, 0);
 	mutex_unlock(&fwnode_link_lock);
 	return ret;
 }
@@ -125,6 +128,19 @@ static void __fwnode_link_del(struct fwnode_link *link)
 	kfree(link);
 }
 
+/**
+ * __fwnode_link_cycle - Mark a fwnode link as being part of a cycle.
+ * @link: the fwnode_link to be marked
+ *
+ * The fwnode_link_lock needs to be held when this function is called.
+ */
+static void __fwnode_link_cycle(struct fwnode_link *link)
+{
+	pr_debug("%pfwf: Relaxing link with %pfwf\n",
+		 link->consumer, link->supplier);
+	link->flags |= FWLINK_FLAG_CYCLE;
+}
+
 /**
  * fwnode_links_purge_suppliers - Delete all supplier links of fwnode_handle.
  * @fwnode: fwnode whose supplier links need to be deleted
@@ -198,7 +214,7 @@ static void __fwnode_links_move_consumers(struct fwnode_handle *from,
 	struct fwnode_link *link, *tmp;
 
 	list_for_each_entry_safe(link, tmp, &from->consumers, s_hook) {
-		__fwnode_link_add(link->consumer, to);
+		__fwnode_link_add(link->consumer, to, link->flags);
 		__fwnode_link_del(link);
 	}
 }
@@ -1040,6 +1056,21 @@ static bool dev_is_best_effort(struct device *dev)
 		(dev->fwnode && (dev->fwnode->flags & FWNODE_FLAG_BEST_EFFORT));
 }
 
+static struct fwnode_handle *fwnode_links_check_suppliers(
+						struct fwnode_handle *fwnode)
+{
+	struct fwnode_link *link;
+
+	if (!fwnode || fw_devlink_is_permissive())
+		return NULL;
+
+	list_for_each_entry(link, &fwnode->suppliers, c_hook)
+		if (!(link->flags & FWLINK_FLAG_CYCLE))
+			return link->supplier;
+
+	return NULL;
+}
+
 /**
  * device_links_check_suppliers - Check presence of supplier drivers.
  * @dev: Consumer device.
@@ -1067,11 +1098,8 @@ int device_links_check_suppliers(struct device *dev)
 	 * probe.
 	 */
 	mutex_lock(&fwnode_link_lock);
-	if (dev->fwnode && !list_empty(&dev->fwnode->suppliers) &&
-	    !fw_devlink_is_permissive()) {
-		sup_fw = list_first_entry(&dev->fwnode->suppliers,
-					  struct fwnode_link,
-					  c_hook)->supplier;
+	sup_fw = fwnode_links_check_suppliers(dev->fwnode);
+	if (sup_fw) {
 		if (!dev_is_best_effort(dev)) {
 			fwnode_ret = -EPROBE_DEFER;
 			dev_err_probe(dev, -EPROBE_DEFER,
@@ -1260,7 +1288,9 @@ static ssize_t waiting_for_supplier_show(struct device *dev,
 	bool val;
 
 	device_lock(dev);
-	val = !list_empty(&dev->fwnode->suppliers);
+	mutex_lock(&fwnode_link_lock);
+	val = !!fwnode_links_check_suppliers(dev->fwnode);
+	mutex_unlock(&fwnode_link_lock);
 	device_unlock(dev);
 	return sysfs_emit(buf, "%u\n", val);
 }
diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
index 89b9bdfca925c..fdf2ee0285b7a 100644
--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -18,7 +18,7 @@ struct fwnode_operations;
 struct device;
 
 /*
- * fwnode link flags
+ * fwnode flags
  *
  * LINKS_ADDED:	The fwnode has already be parsed to add fwnode links.
  * NOT_DEVICE:	The fwnode will never be populated as a struct device.
@@ -36,6 +36,7 @@ struct device;
 #define FWNODE_FLAG_INITIALIZED			BIT(2)
 #define FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD	BIT(3)
 #define FWNODE_FLAG_BEST_EFFORT			BIT(4)
+#define FWNODE_FLAG_VISITED			BIT(5)
 
 struct fwnode_handle {
 	struct fwnode_handle *secondary;
@@ -46,11 +47,19 @@ struct fwnode_handle {
 	u8 flags;
 };
 
+/*
+ * fwnode link flags
+ *
+ * CYCLE:	The fwnode link is part of a cycle. Don't defer probe.
+ */
+#define FWLINK_FLAG_CYCLE			BIT(0)
+
 struct fwnode_link {
 	struct fwnode_handle *supplier;
 	struct list_head s_hook;
 	struct fwnode_handle *consumer;
 	struct list_head c_hook;
+	u8 flags;
 };
 
 /**
-- 
2.39.2



