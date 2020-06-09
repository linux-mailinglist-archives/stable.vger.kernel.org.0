Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0225A1F2D0E
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgFIAa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730093AbgFHXPq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AA3120760;
        Mon,  8 Jun 2020 23:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658145;
        bh=TyJAmAg2IxYVcbNEVfhBJ2zxbSBuEzLHuikDs16VLFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWezgcUWadk1gGcMiMIVs7Wl95tRVgVXHJGNliVWTIpyPDBnstsCSeWNsgTAZpTg+
         M2KTkEKZQdik9AOjG7xus61XgdZm/6+bjdcDUT8HvlTYIQNhvWzxobIpn6IiHhW67M
         jBtB3cZ/+N64UlF8u4qkgsG49I58NR4kMss+nOz8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saravana Kannan <saravanak@google.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 5.6 178/606] driver core: Fix SYNC_STATE_ONLY device link implementation
Date:   Mon,  8 Jun 2020 19:05:03 -0400
Message-Id: <20200608231211.3363633-178-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

commit 21c27f06587d2c18150d27ca2382a509ec55c482 upstream.

When SYNC_STATE_ONLY support was added in commit 05ef983e0d65 ("driver
core: Add device link support for SYNC_STATE_ONLY flag"),
device_link_add() incorrectly skipped adding the new SYNC_STATE_ONLY
device link to the supplier's and consumer's "device link" list.

This causes multiple issues:
- The device link is lost forever from driver core if the caller
  didn't keep track of it (caller typically isn't expected to). This is
  a memory leak.
- The device link is also never visible to any other code path after
  device_link_add() returns.

If we fix the "device link" list handling, that exposes a bunch of
issues.

1. The device link "status" state management code rightfully doesn't
handle the case where a DL_FLAG_MANAGED device link exists between a
supplier and consumer, but the consumer manages to probe successfully
before the supplier. The addition of DL_FLAG_SYNC_STATE_ONLY links break
this assumption. This causes device_links_driver_bound() to throw a
warning when this happens.

Since DL_FLAG_SYNC_STATE_ONLY device links are mainly used for creating
proxy device links for child device dependencies and aren't useful once
the consumer device probes successfully, this patch just deletes
DL_FLAG_SYNC_STATE_ONLY device links once its consumer device probes.
This way, we avoid the warning, free up some memory and avoid
complicating the device links "status" state management code.

2. Creating a DL_FLAG_STATELESS device link between two devices that
already have a DL_FLAG_SYNC_STATE_ONLY device link will result in the
DL_FLAG_STATELESS flag not getting set correctly. This patch also fixes
this.

Lastly, this patch also fixes minor whitespace issues.

Cc: stable@vger.kernel.org
Fixes: 05ef983e0d65 ("driver core: Add device link support for SYNC_STATE_ONLY flag")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20200519063000.128819-1-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c | 61 +++++++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index d32a3aefff32..7fb7ffdeb015 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -360,13 +360,12 @@ struct device_link *device_link_add(struct device *consumer,
 
 		if (flags & DL_FLAG_STATELESS) {
 			kref_get(&link->kref);
+			link->flags |= DL_FLAG_STATELESS;
 			if (link->flags & DL_FLAG_SYNC_STATE_ONLY &&
-			    !(link->flags & DL_FLAG_STATELESS)) {
-				link->flags |= DL_FLAG_STATELESS;
+			    !(link->flags & DL_FLAG_STATELESS))
 				goto reorder;
-			} else {
+			else
 				goto out;
-			}
 		}
 
 		/*
@@ -433,12 +432,16 @@ struct device_link *device_link_add(struct device *consumer,
 	    flags & DL_FLAG_PM_RUNTIME)
 		pm_runtime_resume(supplier);
 
+	list_add_tail_rcu(&link->s_node, &supplier->links.consumers);
+	list_add_tail_rcu(&link->c_node, &consumer->links.suppliers);
+
 	if (flags & DL_FLAG_SYNC_STATE_ONLY) {
 		dev_dbg(consumer,
 			"Linked as a sync state only consumer to %s\n",
 			dev_name(supplier));
 		goto out;
 	}
+
 reorder:
 	/*
 	 * Move the consumer and all of the devices depending on it to the end
@@ -449,12 +452,9 @@ struct device_link *device_link_add(struct device *consumer,
 	 */
 	device_reorder_to_tail(consumer, NULL);
 
-	list_add_tail_rcu(&link->s_node, &supplier->links.consumers);
-	list_add_tail_rcu(&link->c_node, &consumer->links.suppliers);
-
 	dev_dbg(consumer, "Linked as a consumer to %s\n", dev_name(supplier));
 
- out:
+out:
 	device_pm_unlock();
 	device_links_write_unlock();
 
@@ -829,6 +829,13 @@ static void __device_links_supplier_defer_sync(struct device *sup)
 		list_add_tail(&sup->links.defer_sync, &deferred_sync);
 }
 
+static void device_link_drop_managed(struct device_link *link)
+{
+	link->flags &= ~DL_FLAG_MANAGED;
+	WRITE_ONCE(link->status, DL_STATE_NONE);
+	kref_put(&link->kref, __device_link_del);
+}
+
 /**
  * device_links_driver_bound - Update device links after probing its driver.
  * @dev: Device to update the links for.
@@ -842,7 +849,7 @@ static void __device_links_supplier_defer_sync(struct device *sup)
  */
 void device_links_driver_bound(struct device *dev)
 {
-	struct device_link *link;
+	struct device_link *link, *ln;
 	LIST_HEAD(sync_list);
 
 	/*
@@ -882,18 +889,35 @@ void device_links_driver_bound(struct device *dev)
 	else
 		__device_links_queue_sync_state(dev, &sync_list);
 
-	list_for_each_entry(link, &dev->links.suppliers, c_node) {
+	list_for_each_entry_safe(link, ln, &dev->links.suppliers, c_node) {
+		struct device *supplier;
+
 		if (!(link->flags & DL_FLAG_MANAGED))
 			continue;
 
-		WARN_ON(link->status != DL_STATE_CONSUMER_PROBE);
-		WRITE_ONCE(link->status, DL_STATE_ACTIVE);
+		supplier = link->supplier;
+		if (link->flags & DL_FLAG_SYNC_STATE_ONLY) {
+			/*
+			 * When DL_FLAG_SYNC_STATE_ONLY is set, it means no
+			 * other DL_MANAGED_LINK_FLAGS have been set. So, it's
+			 * save to drop the managed link completely.
+			 */
+			device_link_drop_managed(link);
+		} else {
+			WARN_ON(link->status != DL_STATE_CONSUMER_PROBE);
+			WRITE_ONCE(link->status, DL_STATE_ACTIVE);
+		}
 
+		/*
+		 * This needs to be done even for the deleted
+		 * DL_FLAG_SYNC_STATE_ONLY device link in case it was the last
+		 * device link that was preventing the supplier from getting a
+		 * sync_state() call.
+		 */
 		if (defer_sync_state_count)
-			__device_links_supplier_defer_sync(link->supplier);
+			__device_links_supplier_defer_sync(supplier);
 		else
-			__device_links_queue_sync_state(link->supplier,
-							&sync_list);
+			__device_links_queue_sync_state(supplier, &sync_list);
 	}
 
 	dev->links.status = DL_DEV_DRIVER_BOUND;
@@ -903,13 +927,6 @@ void device_links_driver_bound(struct device *dev)
 	device_links_flush_sync_list(&sync_list, dev);
 }
 
-static void device_link_drop_managed(struct device_link *link)
-{
-	link->flags &= ~DL_FLAG_MANAGED;
-	WRITE_ONCE(link->status, DL_STATE_NONE);
-	kref_put(&link->kref, __device_link_del);
-}
-
 /**
  * __device_links_no_driver - Update links of a device without a driver.
  * @dev: Device without a drvier.
-- 
2.25.1

