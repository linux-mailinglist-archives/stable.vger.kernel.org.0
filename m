Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2257A13F6DB
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388032AbgAPRBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:01:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:51862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388017AbgAPRBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:01:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C603C20730;
        Thu, 16 Jan 2020 17:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194069;
        bh=s4VGQsOh4uTPPhC30DK8IdAQ4ha3SYFnlXROxtFDQcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=me6sP5FI4G0SyCWKKzrnaIuhmOYkwdjWMSZ1vBwWDieQAWXvlAGRut73dwxOrtUAA
         PlFrBfwZjt0mPb/RTQiAzTUfmp16O+vXlUhyoD6mc5HeMvP1C+NOF/OzsOvoGREUQB
         sVxFKEkNwji1nPTly5N11X80SwvBRbI/TDDi69Lo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 179/671] driver core: Fix possible supplier PM-usage counter imbalance
Date:   Thu, 16 Jan 2020 11:51:28 -0500
Message-Id: <20200116165940.10720-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 4c06c4e6cf63d7f3d5dfe62593a073253d750a59 ]

If a stateless device link to a certain supplier with
DL_FLAG_PM_RUNTIME set in the flags is added and then removed by the
consumer driver's probe callback, the supplier's PM-runtime usage
counter will be nonzero after that which effectively causes the
supplier to remain "always on" going forward.

Namely, device_link_add() called to add the link invokes
device_link_rpm_prepare() which notices that the consumer driver is
probing, so it increments the supplier's PM-runtime usage counter
with the assumption that the link will stay around until
pm_runtime_put_suppliers() is called by driver_probe_device(),
but if the link goes away before that point, the supplier's
PM-runtime usage counter will remain nonzero.

To prevent that from happening, first rework pm_runtime_get_suppliers()
and pm_runtime_put_suppliers() to use the rpm_active refounts of device
links and make the latter only drop rpm_active and the supplier's
PM-runtime usage counter for each link by one, unless rpm_active is
one already for it.  Next, modify device_link_add() to bump up the
new link's rpm_active refcount and the suppliers PM-runtime usage
counter by two, to prevent pm_runtime_put_suppliers(), if it is
called subsequently, from suspending the supplier prematurely (in
case its PM-runtime usage counter goes down to 0 in there).

Due to the way rpm_put_suppliers() works, this change does not
affect runtime suspend of the consumer ends of new device links (or,
generally, device links for which DL_FLAG_PM_RUNTIME has just been
set).

Fixes: e2f3cd831a28 ("driver core: Fix handling of runtime PM flags in device_link_add()")
Reported-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Tested-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c          | 21 ++++-----------------
 drivers/base/power/runtime.c | 27 +++++++++++++++++++++++++--
 include/linux/pm_runtime.h   |  4 ++++
 3 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 7599147d5f83..ab08211ba5d2 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -165,19 +165,6 @@ void device_pm_move_to_tail(struct device *dev)
 	device_links_read_unlock(idx);
 }
 
-static void device_link_rpm_prepare(struct device *consumer,
-				    struct device *supplier)
-{
-	pm_runtime_new_link(consumer);
-	/*
-	 * If the link is being added by the consumer driver at probe time,
-	 * balance the decrementation of the supplier's runtime PM usage counter
-	 * after consumer probe in driver_probe_device().
-	 */
-	if (consumer->links.status == DL_DEV_PROBING)
-		pm_runtime_get_noresume(supplier);
-}
-
 /**
  * device_link_add - Create a link between two devices.
  * @consumer: Consumer end of the link.
@@ -262,11 +249,11 @@ struct device_link *device_link_add(struct device *consumer,
 
 		if (flags & DL_FLAG_PM_RUNTIME) {
 			if (!(link->flags & DL_FLAG_PM_RUNTIME)) {
-				device_link_rpm_prepare(consumer, supplier);
+				pm_runtime_new_link(consumer);
 				link->flags |= DL_FLAG_PM_RUNTIME;
 			}
 			if (flags & DL_FLAG_RPM_ACTIVE)
-				refcount_inc(&link->rpm_active);
+				pm_runtime_active_link(link, supplier);
 		}
 
 		kref_get(&link->kref);
@@ -281,9 +268,9 @@ struct device_link *device_link_add(struct device *consumer,
 
 	if (flags & DL_FLAG_PM_RUNTIME) {
 		if (flags & DL_FLAG_RPM_ACTIVE)
-			refcount_inc(&link->rpm_active);
+			pm_runtime_active_link(link, supplier);
 
-		device_link_rpm_prepare(consumer, supplier);
+		pm_runtime_new_link(consumer);
 	}
 
 	get_device(supplier);
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index ab454c4533ba..0527890b4c19 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1570,8 +1570,10 @@ void pm_runtime_get_suppliers(struct device *dev)
 	idx = device_links_read_lock();
 
 	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node)
-		if (link->flags & DL_FLAG_PM_RUNTIME)
+		if (link->flags & DL_FLAG_PM_RUNTIME) {
+			refcount_inc(&link->rpm_active);
 			pm_runtime_get_sync(link->supplier);
+		}
 
 	device_links_read_unlock(idx);
 }
@@ -1588,7 +1590,8 @@ void pm_runtime_put_suppliers(struct device *dev)
 	idx = device_links_read_lock();
 
 	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node)
-		if (link->flags & DL_FLAG_PM_RUNTIME)
+		if (link->flags & DL_FLAG_PM_RUNTIME &&
+		    refcount_dec_not_one(&link->rpm_active))
 			pm_runtime_put(link->supplier);
 
 	device_links_read_unlock(idx);
@@ -1601,6 +1604,26 @@ void pm_runtime_new_link(struct device *dev)
 	spin_unlock_irq(&dev->power.lock);
 }
 
+/**
+ * pm_runtime_active_link - Set up new device link as active for PM-runtime.
+ * @link: Device link to be set up as active.
+ * @supplier: Supplier end of the link.
+ *
+ * Add 2 to the rpm_active refcount of @link and increment the PM-runtime
+ * usage counter of @supplier once more in case the link is being added while
+ * the consumer driver is probing and pm_runtime_put_suppliers() will be called
+ * subsequently.
+ *
+ * Note that this doesn't prevent rpm_put_suppliers() from decreasing the link's
+ * rpm_active refcount down to one, so runtime suspend of the consumer end of
+ * @link is not affected.
+ */
+void pm_runtime_active_link(struct device_link *link, struct device *supplier)
+{
+	refcount_add(2, &link->rpm_active);
+	pm_runtime_get_noresume(supplier);
+}
+
 void pm_runtime_drop_link(struct device *dev)
 {
 	spin_lock_irq(&dev->power.lock);
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index f0fc4700b6ff..bace7df51af4 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -59,6 +59,8 @@ extern void pm_runtime_clean_up_links(struct device *dev);
 extern void pm_runtime_get_suppliers(struct device *dev);
 extern void pm_runtime_put_suppliers(struct device *dev);
 extern void pm_runtime_new_link(struct device *dev);
+extern void pm_runtime_active_link(struct device_link *link,
+				   struct device *supplier);
 extern void pm_runtime_drop_link(struct device *dev);
 
 static inline void pm_suspend_ignore_children(struct device *dev, bool enable)
@@ -176,6 +178,8 @@ static inline void pm_runtime_clean_up_links(struct device *dev) {}
 static inline void pm_runtime_get_suppliers(struct device *dev) {}
 static inline void pm_runtime_put_suppliers(struct device *dev) {}
 static inline void pm_runtime_new_link(struct device *dev) {}
+static inline void pm_runtime_active_link(struct device_link *link,
+					  struct device *supplier) {}
 static inline void pm_runtime_drop_link(struct device *dev) {}
 
 #endif /* !CONFIG_PM */
-- 
2.20.1

