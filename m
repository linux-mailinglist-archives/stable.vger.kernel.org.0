Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A854B18B711
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbgCSNal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729711AbgCSNUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:20:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25C3121655;
        Thu, 19 Mar 2020 13:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624039;
        bh=tgVYRqV6JMuZm7TIS7KcxNGTdY3e2roGcCe/+kmzE0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njzfsKMGvuHlpV1BQRaPhxavMlucBWHY2A7dlAuudd2t+8Gby7+Eawky5hx+fUNus
         bOkLQWtmGhjOvmNdK29D6PLjHknWtjFajVOLpHwn7oU+A3hTjRRq7mQaOSJtfyYIUn
         1NAEaqDOh26r9euuJcvGQUwhrNN40fgIQ3KhmmgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Saravana Kannan <saravanak@google.com>
Subject: [PATCH 4.19 37/48] driver core: Fix adding device links to probing suppliers
Date:   Thu, 19 Mar 2020 14:04:19 +0100
Message-Id: <20200319123914.596712114@linuxfoundation.org>
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

commit 15cfb094160385cc0b303c4cda483caa102af654 upstream.

Currently, it is not valid to add a device link from a consumer
driver ->probe callback to a supplier that is still probing too, but
generally this is a valid use case.  For example, if the consumer has
just acquired a resource that can only be available if the supplier
is functional, adding a device link to that supplier right away
should be safe (and even desirable arguably), but device_link_add()
doesn't handle that case correctly and the initial state of the link
created by it is wrong then.

To address this problem, change the initial state of device links
added between a probing supplier and a probing consumer to
DL_STATE_CONSUMER_PROBE and update device_links_driver_bound() to
skip such links on the supplier side.

With this change, if the supplier probe completes first,
device_links_driver_bound() called for it will skip the link state
update and when it is called for the consumer, the link state will
be updated to "active".  In turn, if the consumer probe completes
first, device_links_driver_bound() called for it will change the
state of the link to "active" and when it is called for the
supplier, the link status update will be skipped.

However, in principle the supplier or consumer probe may still fail
after the link has been added, so modify device_links_no_driver() to
change device links in the "active" or "consumer probe" state to
"dormant" on the supplier side and update __device_links_no_driver()
to change the link state to "available" only if it is "consumer
probe" or "active".

Then, if the supplier probe fails first, the leftover link to the
probing consumer will become "dormant" and device_links_no_driver()
called for the consumer (when its probe fails) will clean it up.
In turn, if the consumer probe fails first, it will either drop the
link, or change its state to "available" and, in the latter case,
when device_links_no_driver() is called for the supplier, it will
update the link state to "dormant".  [If the supplier probe fails,
but the consumer probe succeeds, which should not happen as long as
the consumer driver is correct, the link still will be around, but
it will be "dormant" until the supplier is probed again.]

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/driver-api/device_link.rst |   10 ++--
 drivers/base/core.c                      |   74 +++++++++++++++++++++++++++----
 2 files changed, 73 insertions(+), 11 deletions(-)

--- a/Documentation/driver-api/device_link.rst
+++ b/Documentation/driver-api/device_link.rst
@@ -59,11 +59,15 @@ device ``->probe`` callback or a boot-ti
 
 Another example for an inconsistent state would be a device link that
 represents a driver presence dependency, yet is added from the consumer's
-``->probe`` callback while the supplier hasn't probed yet:  Had the driver
-core known about the device link earlier, it wouldn't have probed the
+``->probe`` callback while the supplier hasn't started to probe yet:  Had the
+driver core known about the device link earlier, it wouldn't have probed the
 consumer in the first place.  The onus is thus on the consumer to check
 presence of the supplier after adding the link, and defer probing on
-non-presence.
+non-presence.  [Note that it is valid to create a link from the consumer's
+``->probe`` callback while the supplier is still probing, but the consumer must
+know that the supplier is functional already at the link creation time (that is
+the case, for instance, if the consumer has just acquired some resources that
+would not have been available had the supplier not been functional then).]
 
 If a device link is added in the ``->probe`` callback of the supplier or
 consumer driver, it is typically deleted in its ``->remove`` callback for
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -287,17 +287,26 @@ struct device_link *device_link_add(stru
 		link->status = DL_STATE_NONE;
 	} else {
 		switch (supplier->links.status) {
-		case DL_DEV_DRIVER_BOUND:
+		case DL_DEV_PROBING:
 			switch (consumer->links.status) {
 			case DL_DEV_PROBING:
 				/*
-				 * Some callers expect the link creation during
-				 * consumer driver probe to resume the supplier
-				 * even without DL_FLAG_RPM_ACTIVE.
+				 * A consumer driver can create a link to a
+				 * supplier that has not completed its probing
+				 * yet as long as it knows that the supplier is
+				 * already functional (for example, it has just
+				 * acquired some resources from the supplier).
 				 */
-				if (flags & DL_FLAG_PM_RUNTIME)
-					pm_runtime_resume(supplier);
-
+				link->status = DL_STATE_CONSUMER_PROBE;
+				break;
+			default:
+				link->status = DL_STATE_DORMANT;
+				break;
+			}
+			break;
+		case DL_DEV_DRIVER_BOUND:
+			switch (consumer->links.status) {
+			case DL_DEV_PROBING:
 				link->status = DL_STATE_CONSUMER_PROBE;
 				break;
 			case DL_DEV_DRIVER_BOUND:
@@ -318,6 +327,14 @@ struct device_link *device_link_add(stru
 	}
 
 	/*
+	 * Some callers expect the link creation during consumer driver probe to
+	 * resume the supplier even without DL_FLAG_RPM_ACTIVE.
+	 */
+	if (link->status == DL_STATE_CONSUMER_PROBE &&
+	    flags & DL_FLAG_PM_RUNTIME)
+		pm_runtime_resume(supplier);
+
+	/*
 	 * Move the consumer and all of the devices depending on it to the end
 	 * of dpm_list and the devices_kset list.
 	 *
@@ -508,6 +525,16 @@ void device_links_driver_bound(struct de
 		if (link->flags & DL_FLAG_STATELESS)
 			continue;
 
+		/*
+		 * Links created during consumer probe may be in the "consumer
+		 * probe" state to start with if the supplier is still probing
+		 * when they are created and they may become "active" if the
+		 * consumer probe returns first.  Skip them here.
+		 */
+		if (link->status == DL_STATE_CONSUMER_PROBE ||
+		    link->status == DL_STATE_ACTIVE)
+			continue;
+
 		WARN_ON(link->status != DL_STATE_DORMANT);
 		WRITE_ONCE(link->status, DL_STATE_AVAILABLE);
 	}
@@ -547,17 +574,48 @@ static void __device_links_no_driver(str
 
 		if (link->flags & DL_FLAG_AUTOREMOVE_CONSUMER)
 			__device_link_del(&link->kref);
-		else if (link->status != DL_STATE_SUPPLIER_UNBIND)
+		else if (link->status == DL_STATE_CONSUMER_PROBE ||
+			 link->status == DL_STATE_ACTIVE)
 			WRITE_ONCE(link->status, DL_STATE_AVAILABLE);
 	}
 
 	dev->links.status = DL_DEV_NO_DRIVER;
 }
 
+/**
+ * device_links_no_driver - Update links after failing driver probe.
+ * @dev: Device whose driver has just failed to probe.
+ *
+ * Clean up leftover links to consumers for @dev and invoke
+ * %__device_links_no_driver() to update links to suppliers for it as
+ * appropriate.
+ *
+ * Links with the DL_FLAG_STATELESS flag set are ignored.
+ */
 void device_links_no_driver(struct device *dev)
 {
+	struct device_link *link;
+
 	device_links_write_lock();
+
+	list_for_each_entry(link, &dev->links.consumers, s_node) {
+		if (link->flags & DL_FLAG_STATELESS)
+			continue;
+
+		/*
+		 * The probe has failed, so if the status of the link is
+		 * "consumer probe" or "active", it must have been added by
+		 * a probing consumer while this device was still probing.
+		 * Change its state to "dormant", as it represents a valid
+		 * relationship, but it is not functionally meaningful.
+		 */
+		if (link->status == DL_STATE_CONSUMER_PROBE ||
+		    link->status == DL_STATE_ACTIVE)
+			WRITE_ONCE(link->status, DL_STATE_DORMANT);
+	}
+
 	__device_links_no_driver(dev);
+
 	device_links_write_unlock();
 }
 


