Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91DF913F748
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388787AbgAPTKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:10:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:50004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387756AbgAPRA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38A7A22525;
        Thu, 16 Jan 2020 17:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194025;
        bh=EvyQTSCwApfIzbqvTtgS2nbBk6bnptvEBkfzbA7qbGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ov3la+Yvk2ORJlfDDf30QOZ42Pt2mCuQjR9+zF6vmIeUPaF8WvZQpJAO8dTHq1Prs
         w/tsuVvpfy+KLtHpH8b7ZSZYryDdJCKt8f0TOkLQBvufwW9iv+62VCdL/Adil4KLcI
         ivS2tt2YnQKkKA7C50BvI/laG4p0sX6nkVJIiN/s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 145/671] driver core: Fix handling of runtime PM flags in device_link_add()
Date:   Thu, 16 Jan 2020 11:50:54 -0500
Message-Id: <20200116165940.10720-28-sashal@kernel.org>
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

[ Upstream commit e2f3cd831a280fc226118d9369bf3f77aab58c56 ]

After commit ead18c23c263 ("driver core: Introduce device links
reference counting"), if there is a link between the given supplier
and the given consumer already, device_link_add() will refcount it
and return it unconditionally without updating its flags.  It is
possible, however, that the second (or any subsequent) caller of
device_link_add() for the same consumer-supplier pair will pass
DL_FLAG_PM_RUNTIME, possibly along with DL_FLAG_RPM_ACTIVE, in flags
to it and the existing link may not behave as expected then.

First, if DL_FLAG_PM_RUNTIME is not set in the existing link's flags
at all, it needs to be set like during the original initialization of
the link.

Second, if DL_FLAG_RPM_ACTIVE is passed to device_link_add() in flags
(in addition to DL_FLAG_PM_RUNTIME), the existing link should to be
updated to reflect the "active" runtime PM configuration of the
consumer-supplier pair and extra care must be taken here to avoid
possible destructive races with runtime PM of the consumer.

To that end, redefine the rpm_active field in struct device_link
as a refcount, initialize it to 1 and make rpm_resume() (for the
consumer) and device_link_add() increment it whenever they acquire
a runtime PM reference on the supplier device.  Accordingly, make
rpm_suspend() (for the consumer) and pm_runtime_clean_up_links()
decrement it and drop runtime PM references to the supplier
device in a loop until rpm_active becones 1 again.

Fixes: ead18c23c263 ("driver core: Introduce device links reference counting")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c          | 45 ++++++++++++++++++++++++------------
 drivers/base/power/runtime.c | 26 +++++++++------------
 include/linux/device.h       |  2 +-
 3 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index c228b4ebf554..20ae18f44dcd 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -165,6 +165,19 @@ void device_pm_move_to_tail(struct device *dev)
 	device_links_read_unlock(idx);
 }
 
+static void device_link_rpm_prepare(struct device *consumer,
+				    struct device *supplier)
+{
+	pm_runtime_new_link(consumer);
+	/*
+	 * If the link is being added by the consumer driver at probe time,
+	 * balance the decrementation of the supplier's runtime PM usage counter
+	 * after consumer probe in driver_probe_device().
+	 */
+	if (consumer->links.status == DL_DEV_PROBING)
+		pm_runtime_get_noresume(supplier);
+}
+
 /**
  * device_link_add - Create a link between two devices.
  * @consumer: Consumer end of the link.
@@ -201,7 +214,6 @@ struct device_link *device_link_add(struct device *consumer,
 				    struct device *supplier, u32 flags)
 {
 	struct device_link *link;
-	bool rpm_put_supplier = false;
 
 	if (!consumer || !supplier ||
 	    (flags & DL_FLAG_STATELESS &&
@@ -213,7 +225,6 @@ struct device_link *device_link_add(struct device *consumer,
 			pm_runtime_put_noidle(supplier);
 			return NULL;
 		}
-		rpm_put_supplier = true;
 	}
 
 	device_links_write_lock();
@@ -249,6 +260,15 @@ struct device_link *device_link_add(struct device *consumer,
 		if (flags & DL_FLAG_AUTOREMOVE_SUPPLIER)
 			link->flags |= DL_FLAG_AUTOREMOVE_SUPPLIER;
 
+		if (flags & DL_FLAG_PM_RUNTIME) {
+			if (!(link->flags & DL_FLAG_PM_RUNTIME)) {
+				device_link_rpm_prepare(consumer, supplier);
+				link->flags |= DL_FLAG_PM_RUNTIME;
+			}
+			if (flags & DL_FLAG_RPM_ACTIVE)
+				refcount_inc(&link->rpm_active);
+		}
+
 		kref_get(&link->kref);
 		goto out;
 	}
@@ -257,20 +277,15 @@ struct device_link *device_link_add(struct device *consumer,
 	if (!link)
 		goto out;
 
+	refcount_set(&link->rpm_active, 1);
+
 	if (flags & DL_FLAG_PM_RUNTIME) {
-		if (flags & DL_FLAG_RPM_ACTIVE) {
-			link->rpm_active = true;
-			rpm_put_supplier = false;
-		}
-		pm_runtime_new_link(consumer);
-		/*
-		 * If the link is being added by the consumer driver at probe
-		 * time, balance the decrementation of the supplier's runtime PM
-		 * usage counter after consumer probe in driver_probe_device().
-		 */
-		if (consumer->links.status == DL_DEV_PROBING)
-			pm_runtime_get_noresume(supplier);
+		if (flags & DL_FLAG_RPM_ACTIVE)
+			refcount_inc(&link->rpm_active);
+
+		device_link_rpm_prepare(consumer, supplier);
 	}
+
 	get_device(supplier);
 	link->supplier = supplier;
 	INIT_LIST_HEAD(&link->s_node);
@@ -333,7 +348,7 @@ struct device_link *device_link_add(struct device *consumer,
 	device_pm_unlock();
 	device_links_write_unlock();
 
-	if (rpm_put_supplier)
+	if ((flags & DL_FLAG_PM_RUNTIME && flags & DL_FLAG_RPM_ACTIVE) && !link)
 		pm_runtime_put(supplier);
 
 	return link;
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index beb85c31f3fa..b914932d3ca1 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -268,11 +268,8 @@ static int rpm_get_suppliers(struct device *dev)
 	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node) {
 		int retval;
 
-		if (!(link->flags & DL_FLAG_PM_RUNTIME))
-			continue;
-
-		if (READ_ONCE(link->status) == DL_STATE_SUPPLIER_UNBIND ||
-		    link->rpm_active)
+		if (!(link->flags & DL_FLAG_PM_RUNTIME) ||
+		    READ_ONCE(link->status) == DL_STATE_SUPPLIER_UNBIND)
 			continue;
 
 		retval = pm_runtime_get_sync(link->supplier);
@@ -281,7 +278,7 @@ static int rpm_get_suppliers(struct device *dev)
 			pm_runtime_put_noidle(link->supplier);
 			return retval;
 		}
-		link->rpm_active = true;
+		refcount_inc(&link->rpm_active);
 	}
 	return 0;
 }
@@ -290,12 +287,13 @@ static void rpm_put_suppliers(struct device *dev)
 {
 	struct device_link *link;
 
-	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node)
-		if (link->rpm_active &&
-		    READ_ONCE(link->status) != DL_STATE_SUPPLIER_UNBIND) {
+	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node) {
+		if (READ_ONCE(link->status) == DL_STATE_SUPPLIER_UNBIND)
+			continue;
+
+		while (refcount_dec_not_one(&link->rpm_active))
 			pm_runtime_put(link->supplier);
-			link->rpm_active = false;
-		}
+	}
 }
 
 /**
@@ -1531,7 +1529,7 @@ void pm_runtime_remove(struct device *dev)
  *
  * Check links from this device to any consumers and if any of them have active
  * runtime PM references to the device, drop the usage counter of the device
- * (once per link).
+ * (as many times as needed).
  *
  * Links with the DL_FLAG_STATELESS flag set are ignored.
  *
@@ -1553,10 +1551,8 @@ void pm_runtime_clean_up_links(struct device *dev)
 		if (link->flags & DL_FLAG_STATELESS)
 			continue;
 
-		if (link->rpm_active) {
+		while (refcount_dec_not_one(&link->rpm_active))
 			pm_runtime_put_noidle(dev);
-			link->rpm_active = false;
-		}
 	}
 
 	device_links_read_unlock(idx);
diff --git a/include/linux/device.h b/include/linux/device.h
index 19dd8852602c..b8fd2a1f859d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -849,7 +849,7 @@ struct device_link {
 	struct list_head c_node;
 	enum device_link_state status;
 	u32 flags;
-	bool rpm_active;
+	refcount_t rpm_active;
 	struct kref kref;
 #ifdef CONFIG_SRCU
 	struct rcu_head rcu_head;
-- 
2.20.1

