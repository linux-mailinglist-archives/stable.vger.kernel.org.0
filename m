Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57C7E8295D
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 03:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731066AbfHFBqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 21:46:03 -0400
Received: from mga14.intel.com ([192.55.52.115]:16400 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728870AbfHFBqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 21:46:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 18:46:03 -0700
X-IronPort-AV: E=Sophos;i="5.64,350,1559545200"; 
   d="scan'208";a="185497079"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 18:46:03 -0700
Subject: [4.19-stable PATCH 1/6] driver core: Establish order of operations
 for device_add and device_del via bitflag
From:   Dan Williams <dan.j.williams@intel.com>
To:     stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        vishal.l.verma@intel.com
Date:   Mon, 05 Aug 2019 18:31:45 -0700
Message-ID: <156505510583.1044139.614343013775015214.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-2-gc94f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

commit 3451a495ef244a88ed6317a035299d835554d579 upstream.

Add an additional bit flag to the device_private struct named "dead".

This additional flag provides a guarantee that when a device_del is
executed on a given interface an async worker will not attempt to attach
the driver following the earlier device_del call. Previously this
guarantee was not present and could result in the device_del call
attempting to remove a driver from an interface only to have the async
worker attempt to probe the driver later when it finally completes the
asynchronous probe call.

One additional change added was that I pulled the check for dev->driver
out of the __device_attach_driver call and instead placed it in the
__device_attach_async_helper call. This was motivated by the fact that the
only other caller of this, __device_attach, had already taken the
device_lock() and checked for dev->driver. Instead of testing for this
twice in this path it makes more sense to just consolidate the dev->dead
and dev->driver checks together into one set of checks.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/base.h |    4 ++++
 drivers/base/core.c |   11 +++++++++++
 drivers/base/dd.c   |   22 +++++++++++-----------
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 7a419a7a6235..559b047de9f7 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -66,6 +66,9 @@ struct driver_private {
  *	probed first.
  * @device - pointer back to the struct device that this structure is
  * associated with.
+ * @dead - This device is currently either in the process of or has been
+ *	removed from the system. Any asynchronous events scheduled for this
+ *	device should exit without taking any action.
  *
  * Nothing outside of the driver core should ever touch these fields.
  */
@@ -76,6 +79,7 @@ struct device_private {
 	struct klist_node knode_bus;
 	struct list_head deferred_probe;
 	struct device *device;
+	u8 dead:1;
 };
 #define to_device_private_parent(obj)	\
 	container_of(obj, struct device_private, knode_parent)
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 92e2c32c2227..37a90d72f373 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2050,6 +2050,17 @@ void device_del(struct device *dev)
 	struct kobject *glue_dir = NULL;
 	struct class_interface *class_intf;
 
+	/*
+	 * Hold the device lock and set the "dead" flag to guarantee that
+	 * the update behavior is consistent with the other bitfields near
+	 * it and that we cannot have an asynchronous probe routine trying
+	 * to run while we are tearing out the bus/class/sysfs from
+	 * underneath the device.
+	 */
+	device_lock(dev);
+	dev->p->dead = true;
+	device_unlock(dev);
+
 	/* Notify clients of device removal.  This call must come
 	 * before dpm_sysfs_remove().
 	 */
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index d48b310c4760..11d24a552ee4 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -725,15 +725,6 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
 	bool async_allowed;
 	int ret;
 
-	/*
-	 * Check if device has already been claimed. This may
-	 * happen with driver loading, device discovery/registration,
-	 * and deferred probe processing happens all at once with
-	 * multiple threads.
-	 */
-	if (dev->driver)
-		return -EBUSY;
-
 	ret = driver_match_device(drv, dev);
 	if (ret == 0) {
 		/* no match */
@@ -768,6 +759,15 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
 
 	device_lock(dev);
 
+	/*
+	 * Check if device has already been removed or claimed. This may
+	 * happen with driver loading, device discovery/registration,
+	 * and deferred probe processing happens all at once with
+	 * multiple threads.
+	 */
+	if (dev->p->dead || dev->driver)
+		goto out_unlock;
+
 	if (dev->parent)
 		pm_runtime_get_sync(dev->parent);
 
@@ -778,7 +778,7 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
 
 	if (dev->parent)
 		pm_runtime_put(dev->parent);
-
+out_unlock:
 	device_unlock(dev);
 
 	put_device(dev);
@@ -891,7 +891,7 @@ static int __driver_attach(struct device *dev, void *data)
 	if (dev->parent && dev->bus->need_parent_lock)
 		device_lock(dev->parent);
 	device_lock(dev);
-	if (!dev->driver)
+	if (!dev->p->dead && !dev->driver)
 		driver_probe_device(drv, dev);
 	device_unlock(dev);
 	if (dev->parent && dev->bus->need_parent_lock)

