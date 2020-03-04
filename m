Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B23151790A0
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 13:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgCDMtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 07:49:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:36430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728953AbgCDMtH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 07:49:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2872520848;
        Wed,  4 Mar 2020 12:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583326145;
        bh=UOoUJBuVsOHDAbBH3gx+vSxU7Kdhl5abeobUtN6QlX0=;
        h=Subject:To:From:Date:From;
        b=UYLYbuYWvHHNXoCG3bQdDaBm64u8jLyDGM8nhSyv2Bj6KzCIcWB4xutBsrNc6tSNZ
         mlIOmt9EbahqmuyMEchthJesiY6baHFhtzRjcAqGZNKJTi7dYZKRdc8YsjdSLJLypu
         aP1uedlIB0zrPB4nQwdibJn9gjnO8kQ8fQbBX9u8=
Subject: patch "driver core: Call sync_state() even if supplier has no consumers" added to driver-core-linus
To:     saravanak@google.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Mar 2020 13:49:02 +0100
Message-ID: <1583326142153148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    driver core: Call sync_state() even if supplier has no consumers

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 21eb93f432b1a785df193df1a56a59e9eb3a985f Mon Sep 17 00:00:00 2001
From: Saravana Kannan <saravanak@google.com>
Date: Fri, 21 Feb 2020 00:05:08 -0800
Subject: driver core: Call sync_state() even if supplier has no consumers

The initial patch that added sync_state() support didn't handle the case
where a supplier has no consumers. This was because when a device is
successfully bound with a driver, only its suppliers were checked to see
if they are eligible to get a sync_state(). This is not sufficient for
devices that have no consumers but still need to do device state clean
up. So fix this.

Fixes: fc5a251d0fd7ca90 (driver core: Add sync_state driver/bus callback)
Signed-off-by: Saravana Kannan <saravanak@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200221080510.197337-2-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 42a672456432..3306d5ae92a6 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -745,25 +745,31 @@ static void __device_links_queue_sync_state(struct device *dev,
 /**
  * device_links_flush_sync_list - Call sync_state() on a list of devices
  * @list: List of devices to call sync_state() on
+ * @dont_lock_dev: Device for which lock is already held by the caller
  *
  * Calls sync_state() on all the devices that have been queued for it. This
- * function is used in conjunction with __device_links_queue_sync_state().
+ * function is used in conjunction with __device_links_queue_sync_state(). The
+ * @dont_lock_dev parameter is useful when this function is called from a
+ * context where a device lock is already held.
  */
-static void device_links_flush_sync_list(struct list_head *list)
+static void device_links_flush_sync_list(struct list_head *list,
+					 struct device *dont_lock_dev)
 {
 	struct device *dev, *tmp;
 
 	list_for_each_entry_safe(dev, tmp, list, links.defer_sync) {
 		list_del_init(&dev->links.defer_sync);
 
-		device_lock(dev);
+		if (dev != dont_lock_dev)
+			device_lock(dev);
 
 		if (dev->bus->sync_state)
 			dev->bus->sync_state(dev);
 		else if (dev->driver && dev->driver->sync_state)
 			dev->driver->sync_state(dev);
 
-		device_unlock(dev);
+		if (dev != dont_lock_dev)
+			device_unlock(dev);
 
 		put_device(dev);
 	}
@@ -801,7 +807,7 @@ void device_links_supplier_sync_state_resume(void)
 out:
 	device_links_write_unlock();
 
-	device_links_flush_sync_list(&sync_list);
+	device_links_flush_sync_list(&sync_list, NULL);
 }
 
 static int sync_state_resume_initcall(void)
@@ -865,6 +871,11 @@ void device_links_driver_bound(struct device *dev)
 			driver_deferred_probe_add(link->consumer);
 	}
 
+	if (defer_sync_state_count)
+		__device_links_supplier_defer_sync(dev);
+	else
+		__device_links_queue_sync_state(dev, &sync_list);
+
 	list_for_each_entry(link, &dev->links.suppliers, c_node) {
 		if (!(link->flags & DL_FLAG_MANAGED))
 			continue;
@@ -883,7 +894,7 @@ void device_links_driver_bound(struct device *dev)
 
 	device_links_write_unlock();
 
-	device_links_flush_sync_list(&sync_list);
+	device_links_flush_sync_list(&sync_list, dev);
 }
 
 static void device_link_drop_managed(struct device_link *link)
-- 
2.25.1


