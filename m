Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC14217FCF3
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729915AbgCJM6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:58:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729743AbgCJM6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:58:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2A0024693;
        Tue, 10 Mar 2020 12:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845115;
        bh=2HC14OJD8sm2GYzsUeOeNLtimAmjef6iXcyHaCfw8aE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCbs25/tdxw4GhX/54sog1Eubtpv+ss18ApPw2aaW9FAj6/iJAS16JariS1G258yU
         J9X9gBNP3dRJBSzy3WX5sEaWxXUrs/+Aesyz99ORZMe3S6ZQOebYq3axxNdjBAjzld
         3UIzhCCGX4pS0jKSJyLgurpuAifH8xPNMcA0hTEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>
Subject: [PATCH 5.5 066/189] driver core: Call sync_state() even if supplier has no consumers
Date:   Tue, 10 Mar 2020 13:38:23 +0100
Message-Id: <20200310123646.283600281@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

commit 21eb93f432b1a785df193df1a56a59e9eb3a985f upstream.

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
 drivers/base/core.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -745,25 +745,31 @@ static void __device_links_queue_sync_st
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
@@ -801,7 +807,7 @@ void device_links_supplier_sync_state_re
 out:
 	device_links_write_unlock();
 
-	device_links_flush_sync_list(&sync_list);
+	device_links_flush_sync_list(&sync_list, NULL);
 }
 
 static int sync_state_resume_initcall(void)
@@ -865,6 +871,11 @@ void device_links_driver_bound(struct de
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
@@ -883,7 +894,7 @@ void device_links_driver_bound(struct de
 
 	device_links_write_unlock();
 
-	device_links_flush_sync_list(&sync_list);
+	device_links_flush_sync_list(&sync_list, dev);
 }
 
 static void device_link_drop_managed(struct device_link *link)


