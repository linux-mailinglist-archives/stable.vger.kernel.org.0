Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D34C818B707
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbgCSNUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729643AbgCSNUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:20:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A949E21556;
        Thu, 19 Mar 2020 13:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624046;
        bh=nzhtWCu/2h7sB1zXt+T3d4x6BLsqP1SsZCbbcIGoedg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlUVHfipJCIv6C6yNR5g40Fecq4LOI2MMmynervAjBqqArETGqcm5jwg0yeC+3nD2
         vhof2Ml7yWB0q4hXeCqQ9XHhIy+zM0arSV5NCEi/96Ekplr5+yKMvvYJ30ag5N0HjC
         jCftXsULDRb9fkr8SmvB/GAwLbEph0Au+MCW2pdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Saravana Kannan <saravanak@google.com>
Subject: [PATCH 4.19 39/48] driver core: Add device link flag DL_FLAG_AUTOPROBE_CONSUMER
Date:   Thu, 19 Mar 2020 14:04:21 +0100
Message-Id: <20200319123915.213596195@linuxfoundation.org>
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

commit e7dd40105aac9ba051e44ad711123bc53a5e4c71 upstream.

Add a new device link flag, DL_FLAG_AUTOPROBE_CONSUMER, to request the
driver core to probe for a consumer driver automatically after binding
a driver to the supplier device on a persistent managed device link.

As unbinding the supplier driver on a managed device link causes the
consumer driver to be detached from its device automatically, this
flag provides a complementary mechanism which is needed to address
some "composite device" use cases.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/driver-api/device_link.rst |    9 +++++++++
 drivers/base/core.c                      |   16 +++++++++++++++-
 drivers/base/dd.c                        |    2 +-
 include/linux/device.h                   |    3 +++
 4 files changed, 28 insertions(+), 2 deletions(-)

--- a/Documentation/driver-api/device_link.rst
+++ b/Documentation/driver-api/device_link.rst
@@ -94,6 +94,15 @@ Similarly, when the device link is added
 ``DL_FLAG_AUTOREMOVE_SUPPLIER`` causes the device link to be automatically
 purged when the supplier fails to probe or later unbinds.
 
+If neither ``DL_FLAG_AUTOREMOVE_CONSUMER`` nor ``DL_FLAG_AUTOREMOVE_SUPPLIER``
+is set, ``DL_FLAG_AUTOPROBE_CONSUMER`` can be used to request the driver core
+to probe for a driver for the consumer driver on the link automatically after
+a driver has been bound to the supplier device.
+
+Note, however, that any combinations of ``DL_FLAG_AUTOREMOVE_CONSUMER``,
+``DL_FLAG_AUTOREMOVE_SUPPLIER`` or ``DL_FLAG_AUTOPROBE_CONSUMER`` with
+``DL_FLAG_STATELESS`` are invalid and cannot be used.
+
 Limitations
 ===========
 
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -195,6 +195,12 @@ void device_pm_move_to_tail(struct devic
  * the link will be maintained until one of the devices pointed to by it (either
  * the consumer or the supplier) is unregistered.
  *
+ * Also, if DL_FLAG_STATELESS, DL_FLAG_AUTOREMOVE_CONSUMER and
+ * DL_FLAG_AUTOREMOVE_SUPPLIER are not set in @flags (that is, a persistent
+ * managed device link is being added), the DL_FLAG_AUTOPROBE_CONSUMER flag can
+ * be used to request the driver core to automaticall probe for a consmer
+ * driver after successfully binding a driver to the supplier device.
+ *
  * The combination of DL_FLAG_STATELESS and either DL_FLAG_AUTOREMOVE_CONSUMER
  * or DL_FLAG_AUTOREMOVE_SUPPLIER set in @flags at the same time is invalid and
  * will cause NULL to be returned upfront.
@@ -215,7 +221,12 @@ struct device_link *device_link_add(stru
 
 	if (!consumer || !supplier ||
 	    (flags & DL_FLAG_STATELESS &&
-	     flags & (DL_FLAG_AUTOREMOVE_CONSUMER | DL_FLAG_AUTOREMOVE_SUPPLIER)))
+	     flags & (DL_FLAG_AUTOREMOVE_CONSUMER |
+		      DL_FLAG_AUTOREMOVE_SUPPLIER |
+		      DL_FLAG_AUTOPROBE_CONSUMER)) ||
+	    (flags & DL_FLAG_AUTOPROBE_CONSUMER &&
+	     flags & (DL_FLAG_AUTOREMOVE_CONSUMER |
+		      DL_FLAG_AUTOREMOVE_SUPPLIER)))
 		return NULL;
 
 	if (flags & DL_FLAG_PM_RUNTIME && flags & DL_FLAG_RPM_ACTIVE) {
@@ -576,6 +587,9 @@ void device_links_driver_bound(struct de
 
 		WARN_ON(link->status != DL_STATE_DORMANT);
 		WRITE_ONCE(link->status, DL_STATE_AVAILABLE);
+
+		if (link->flags & DL_FLAG_AUTOPROBE_CONSUMER)
+			driver_deferred_probe_add(link->consumer);
 	}
 
 	list_for_each_entry(link, &dev->links.suppliers, c_node) {
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -116,7 +116,7 @@ static void deferred_probe_work_func(str
 }
 static DECLARE_WORK(deferred_probe_work, deferred_probe_work_func);
 
-static void driver_deferred_probe_add(struct device *dev)
+void driver_deferred_probe_add(struct device *dev)
 {
 	mutex_lock(&deferred_probe_mutex);
 	if (list_empty(&dev->p->deferred_probe)) {
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -339,6 +339,7 @@ struct device *driver_find_device(struct
 				  struct device *start, void *data,
 				  int (*match)(struct device *dev, void *data));
 
+void driver_deferred_probe_add(struct device *dev);
 int driver_deferred_probe_check_state(struct device *dev);
 
 /**
@@ -824,12 +825,14 @@ enum device_link_state {
  * PM_RUNTIME: If set, the runtime PM framework will use this link.
  * RPM_ACTIVE: Run pm_runtime_get_sync() on the supplier during link creation.
  * AUTOREMOVE_SUPPLIER: Remove the link automatically on supplier driver unbind.
+ * AUTOPROBE_CONSUMER: Probe consumer driver automatically after supplier binds.
  */
 #define DL_FLAG_STATELESS		BIT(0)
 #define DL_FLAG_AUTOREMOVE_CONSUMER	BIT(1)
 #define DL_FLAG_PM_RUNTIME		BIT(2)
 #define DL_FLAG_RPM_ACTIVE		BIT(3)
 #define DL_FLAG_AUTOREMOVE_SUPPLIER	BIT(4)
+#define DL_FLAG_AUTOPROBE_CONSUMER	BIT(5)
 
 /**
  * struct device_link - Device link representation.


