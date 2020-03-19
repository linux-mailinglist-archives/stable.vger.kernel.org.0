Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0A1C18B5B2
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730002AbgCSNUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728786AbgCSNUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:20:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 970272166E;
        Thu, 19 Mar 2020 13:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624042;
        bh=5nLrWCES3KQ6aDOHOe8Z7mxo2FpvMmVEDBf2SpwIX+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PV0UjRsnMzg/lrgLW6Ig4pgkV9m30VtYZYakvlnZF3ttKsD2ngHNzs7hikWbLTH4g
         WiRHJtqr9sxQfOS4zokHlc7HDEFDCl1V89wr/ea+lgqPcGtb8ZYjSftkjDXo/Tcub7
         OnI7LY+FP99Mzc0TXHH+6XfiCa+EDJ+9HJvW5Ihs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Saravana Kannan <saravanak@google.com>
Subject: [PATCH 4.19 38/48] driver core: Make driver core own stateful device links
Date:   Thu, 19 Mar 2020 14:04:20 +0100
Message-Id: <20200319123914.936500139@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
References: <20200319123902.941451241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 72175d4ea4c442d95cf690c3e968eeee90fd43ca upstream.

Even though stateful device links are managed by the driver core in
principle, their creators are allowed and sometimes even expected
to drop references to them via device_link_del() or
device_link_remove(), but that doesn't really play well with the
"persistent" link concept.

If "persistent" managed device links are created from driver
probe callbacks, device_link_add() called to do that will take a
new reference on the link each time the callback runs and those
references will never be dropped, which kind of isn't nice.

This issues arises because of the link reference counting carried
out by device_link_add() for existing links, but that is only done to
avoid deleting device links that may still be necessary, which
shouldn't be a concern for managed (stateful) links.  These device
links are managed by the driver core and whoever creates one of them
will need it at least as long as until the consumer driver is detached
from its device and deleting it may be left to the driver core just
fine.

For this reason, rework device_link_add() to apply the reference
counting to stateless links only and make device_link_del() and
device_link_remove() drop references to stateless links only too.
After this change, if called to add a stateful device link for
a consumer-supplier pair for which a stateful device link is
present already, device_link_add() will return the existing link
without incrementing its reference counter.  Accordingly,
device_link_del() and device_link_remove() will WARN() and do
nothing when called to drop a reference to a stateful link.  Thus,
effectively, all stateful device links will be owned by the driver
core.

In addition, clean up the handling of the link management flags,
DL_FLAG_AUTOREMOVE_CONSUMER and DL_FLAG_AUTOREMOVE_SUPPLIER, so that
(a) they are never set at the same time and (b) if device_link_add()
is called for a consumer-supplier pair with an existing stateful link
between them, the flags of that link will be combined with the flags
passed to device_link_add() to ensure that the life time of the link
is sufficient for all of the callers of device_link_add() for the
same consumer-supplier pair.

Update the device_link_add() kerneldoc comment to reflect the
above changes.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/driver-api/device_link.rst |   42 +++++++++++-------
 drivers/base/core.c                      |   69 ++++++++++++++++++++++++-------
 2 files changed, 79 insertions(+), 32 deletions(-)

--- a/Documentation/driver-api/device_link.rst
+++ b/Documentation/driver-api/device_link.rst
@@ -25,8 +25,8 @@ suspend/resume and shutdown ordering.
 
 Device links allow representation of such dependencies in the driver core.
 
-In its standard form, a device link combines *both* dependency types:
-It guarantees correct suspend/resume and shutdown ordering between a
+In its standard or *managed* form, a device link combines *both* dependency
+types:  It guarantees correct suspend/resume and shutdown ordering between a
 "supplier" device and its "consumer" devices, and it guarantees driver
 presence on the supplier.  The consumer devices are not probed before the
 supplier is bound to a driver, and they're unbound before the supplier
@@ -69,12 +69,14 @@ know that the supplier is functional alr
 the case, for instance, if the consumer has just acquired some resources that
 would not have been available had the supplier not been functional then).]
 
-If a device link is added in the ``->probe`` callback of the supplier or
-consumer driver, it is typically deleted in its ``->remove`` callback for
-symmetry.  That way, if the driver is compiled as a module, the device
-link is added on module load and orderly deleted on unload.  The same
-restrictions that apply to device link addition (e.g. exclusion of a
-parallel suspend/resume transition) apply equally to deletion.
+If a device link with ``DL_FLAG_STATELESS`` set (i.e. a stateless device link)
+is added in the ``->probe`` callback of the supplier or consumer driver, it is
+typically deleted in its ``->remove`` callback for symmetry.  That way, if the
+driver is compiled as a module, the device link is added on module load and
+orderly deleted on unload.  The same restrictions that apply to device link
+addition (e.g. exclusion of a parallel suspend/resume transition) apply equally
+to deletion.  Device links with ``DL_FLAG_STATELESS`` unset (i.e. managed
+device links) are deleted automatically by the driver core.
 
 Several flags may be specified on device link addition, two of which
 have already been mentioned above:  ``DL_FLAG_STATELESS`` to express that no
@@ -87,8 +89,6 @@ link is added from the consumer's ``->pr
 can be specified to runtime resume the supplier upon addition of the
 device link.  ``DL_FLAG_AUTOREMOVE_CONSUMER`` causes the device link to be
 automatically purged when the consumer fails to probe or later unbinds.
-This obviates the need to explicitly delete the link in the ``->remove``
-callback or in the error path of the ``->probe`` callback.
 
 Similarly, when the device link is added from supplier's ``->probe`` callback,
 ``DL_FLAG_AUTOREMOVE_SUPPLIER`` causes the device link to be automatically
@@ -97,12 +97,20 @@ purged when the supplier fails to probe
 Limitations
 ===========
 
-Driver authors should be aware that a driver presence dependency (i.e. when
-``DL_FLAG_STATELESS`` is not specified on link addition) may cause probing of
-the consumer to be deferred indefinitely.  This can become a problem if the
-consumer is required to probe before a certain initcall level is reached.
-Worse, if the supplier driver is blacklisted or missing, the consumer will
-never be probed.
+Driver authors should be aware that a driver presence dependency for managed
+device links (i.e. when ``DL_FLAG_STATELESS`` is not specified on link addition)
+may cause probing of the consumer to be deferred indefinitely.  This can become
+a problem if the consumer is required to probe before a certain initcall level
+is reached.  Worse, if the supplier driver is blacklisted or missing, the
+consumer will never be probed.
+
+Moreover, managed device links cannot be deleted directly.  They are deleted
+by the driver core when they are not necessary any more in accordance with the
+``DL_FLAG_AUTOREMOVE_CONSUMER`` and ``DL_FLAG_AUTOREMOVE_SUPPLIER`` flags.
+However, stateless device links (i.e. device links with ``DL_FLAG_STATELESS``
+set) are expected to be removed by whoever called :c:func:`device_link_add()`
+to add them with the help of either :c:func:`device_link_del()` or
+:c:func:`device_link_remove()`.
 
 Sometimes drivers depend on optional resources.  They are able to operate
 in a degraded mode (reduced feature set or performance) when those resources
@@ -286,4 +294,4 @@ API
 ===
 
 .. kernel-doc:: drivers/base/core.c
-   :functions: device_link_add device_link_del
+   :functions: device_link_add device_link_del device_link_remove
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -179,10 +179,21 @@ void device_pm_move_to_tail(struct devic
  * of the link.  If DL_FLAG_PM_RUNTIME is not set, DL_FLAG_RPM_ACTIVE will be
  * ignored.
  *
- * If the DL_FLAG_AUTOREMOVE_CONSUMER flag is set, the link will be removed
- * automatically when the consumer device driver unbinds from it.  Analogously,
- * if DL_FLAG_AUTOREMOVE_SUPPLIER is set in @flags, the link will be removed
- * automatically when the supplier device driver unbinds from it.
+ * If DL_FLAG_STATELESS is set in @flags, the link is not going to be managed by
+ * the driver core and, in particular, the caller of this function is expected
+ * to drop the reference to the link acquired by it directly.
+ *
+ * If that flag is not set, however, the caller of this function is handing the
+ * management of the link over to the driver core entirely and its return value
+ * can only be used to check whether or not the link is present.  In that case,
+ * the DL_FLAG_AUTOREMOVE_CONSUMER and DL_FLAG_AUTOREMOVE_SUPPLIER device link
+ * flags can be used to indicate to the driver core when the link can be safely
+ * deleted.  Namely, setting one of them in @flags indicates to the driver core
+ * that the link is not going to be used (by the given caller of this function)
+ * after unbinding the consumer or supplier driver, respectively, from its
+ * device, so the link can be deleted at that point.  If none of them is set,
+ * the link will be maintained until one of the devices pointed to by it (either
+ * the consumer or the supplier) is unregistered.
  *
  * The combination of DL_FLAG_STATELESS and either DL_FLAG_AUTOREMOVE_CONSUMER
  * or DL_FLAG_AUTOREMOVE_SUPPLIER set in @flags at the same time is invalid and
@@ -228,6 +239,14 @@ struct device_link *device_link_add(stru
 		goto out;
 	}
 
+	/*
+	 * DL_FLAG_AUTOREMOVE_SUPPLIER indicates that the link will be needed
+	 * longer than for DL_FLAG_AUTOREMOVE_CONSUMER and setting them both
+	 * together doesn't make sense, so prefer DL_FLAG_AUTOREMOVE_SUPPLIER.
+	 */
+	if (flags & DL_FLAG_AUTOREMOVE_SUPPLIER)
+		flags &= ~DL_FLAG_AUTOREMOVE_CONSUMER;
+
 	list_for_each_entry(link, &supplier->links.consumers, s_node) {
 		if (link->consumer != consumer)
 			continue;
@@ -241,12 +260,6 @@ struct device_link *device_link_add(stru
 			goto out;
 		}
 
-		if (flags & DL_FLAG_AUTOREMOVE_CONSUMER)
-			link->flags |= DL_FLAG_AUTOREMOVE_CONSUMER;
-
-		if (flags & DL_FLAG_AUTOREMOVE_SUPPLIER)
-			link->flags |= DL_FLAG_AUTOREMOVE_SUPPLIER;
-
 		if (flags & DL_FLAG_PM_RUNTIME) {
 			if (!(link->flags & DL_FLAG_PM_RUNTIME)) {
 				pm_runtime_new_link(consumer);
@@ -256,7 +269,25 @@ struct device_link *device_link_add(stru
 				refcount_inc(&link->rpm_active);
 		}
 
-		kref_get(&link->kref);
+		if (flags & DL_FLAG_STATELESS) {
+			kref_get(&link->kref);
+			goto out;
+		}
+
+		/*
+		 * If the life time of the link following from the new flags is
+		 * longer than indicated by the flags of the existing link,
+		 * update the existing link to stay around longer.
+		 */
+		if (flags & DL_FLAG_AUTOREMOVE_SUPPLIER) {
+			if (link->flags & DL_FLAG_AUTOREMOVE_CONSUMER) {
+				link->flags &= ~DL_FLAG_AUTOREMOVE_CONSUMER;
+				link->flags |= DL_FLAG_AUTOREMOVE_SUPPLIER;
+			}
+		} else if (!(flags & DL_FLAG_AUTOREMOVE_CONSUMER)) {
+			link->flags &= ~(DL_FLAG_AUTOREMOVE_CONSUMER |
+					 DL_FLAG_AUTOREMOVE_SUPPLIER);
+		}
 		goto out;
 	}
 
@@ -406,8 +437,16 @@ static void __device_link_del(struct kre
 }
 #endif /* !CONFIG_SRCU */
 
+static void device_link_put_kref(struct device_link *link)
+{
+	if (link->flags & DL_FLAG_STATELESS)
+		kref_put(&link->kref, __device_link_del);
+	else
+		WARN(1, "Unable to drop a managed device link reference\n");
+}
+
 /**
- * device_link_del - Delete a link between two devices.
+ * device_link_del - Delete a stateless link between two devices.
  * @link: Device link to delete.
  *
  * The caller must ensure proper synchronization of this function with runtime
@@ -419,14 +458,14 @@ void device_link_del(struct device_link
 {
 	device_links_write_lock();
 	device_pm_lock();
-	kref_put(&link->kref, __device_link_del);
+	device_link_put_kref(link);
 	device_pm_unlock();
 	device_links_write_unlock();
 }
 EXPORT_SYMBOL_GPL(device_link_del);
 
 /**
- * device_link_remove - remove a link between two devices.
+ * device_link_remove - Delete a stateless link between two devices.
  * @consumer: Consumer end of the link.
  * @supplier: Supplier end of the link.
  *
@@ -445,7 +484,7 @@ void device_link_remove(void *consumer,
 
 	list_for_each_entry(link, &supplier->links.consumers, s_node) {
 		if (link->consumer == consumer) {
-			kref_put(&link->kref, __device_link_del);
+			device_link_put_kref(link);
 			break;
 		}
 	}


