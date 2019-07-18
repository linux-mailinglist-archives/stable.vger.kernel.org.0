Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD616C41F
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 03:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731973AbfGRBWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 21:22:11 -0400
Received: from mga05.intel.com ([192.55.52.43]:8190 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727658AbfGRBWL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 21:22:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 18:22:10 -0700
X-IronPort-AV: E=Sophos;i="5.64,276,1559545200"; 
   d="scan'208";a="179087622"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 18:22:10 -0700
Subject: [PATCH v2 1/7] drivers/base: Introduce kill_device()
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-nvdimm@lists.01.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        Jane Chu <jane.chu@oracle.com>, peterz@infradead.org,
        vishal.l.verma@intel.com, linux-kernel@vger.kernel.org
Date:   Wed, 17 Jul 2019 18:07:53 -0700
Message-ID: <156341207332.292348.14959761496009347574.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156341206785.292348.1660822720191643298.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156341206785.292348.1660822720191643298.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-2-gc94f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The libnvdimm subsystem arranges for devices to be destroyed as a result
of a sysfs operation. Since device_unregister() cannot be called from
an actively running sysfs attribute of the same device libnvdimm
arranges for device_unregister() to be performed in an out-of-line async
context.

The driver core maintains a 'dead' state for coordinating its own racing
async registration / de-registration requests. Rather than add local
'dead' state tracking infrastructure to libnvdimm device objects, export
the existing state tracking via a new kill_device() helper.

The kill_device() helper simply marks the device as dead, i.e. that it
is on its way to device_del(), or returns that the device was already
dead. This can be used in advance of calling device_unregister() for
subsystems like libnvdimm that might need to handle multiple user
threads racing to delete a device.

This refactoring does not change any behavior, but it is a pre-requisite
for follow-on fixes and therefore marked for -stable.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Fixes: 4d88a97aa9e8 ("libnvdimm, nvdimm: dimm driver and base libnvdimm device-driver...")
Cc: <stable@vger.kernel.org>
Tested-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/base/core.c    |   27 +++++++++++++++++++--------
 include/linux/device.h |    1 +
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index fd7511e04e62..eaf3aa0cb803 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2211,6 +2211,24 @@ void put_device(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(put_device);
 
+bool kill_device(struct device *dev)
+{
+	/*
+	 * Require the device lock and set the "dead" flag to guarantee that
+	 * the update behavior is consistent with the other bitfields near
+	 * it and that we cannot have an asynchronous probe routine trying
+	 * to run while we are tearing out the bus/class/sysfs from
+	 * underneath the device.
+	 */
+	lockdep_assert_held(&dev->mutex);
+
+	if (dev->p->dead)
+		return false;
+	dev->p->dead = true;
+	return true;
+}
+EXPORT_SYMBOL_GPL(kill_device);
+
 /**
  * device_del - delete device from system.
  * @dev: device.
@@ -2230,15 +2248,8 @@ void device_del(struct device *dev)
 	struct kobject *glue_dir = NULL;
 	struct class_interface *class_intf;
 
-	/*
-	 * Hold the device lock and set the "dead" flag to guarantee that
-	 * the update behavior is consistent with the other bitfields near
-	 * it and that we cannot have an asynchronous probe routine trying
-	 * to run while we are tearing out the bus/class/sysfs from
-	 * underneath the device.
-	 */
 	device_lock(dev);
-	dev->p->dead = true;
+	kill_device(dev);
 	device_unlock(dev);
 
 	/* Notify clients of device removal.  This call must come
diff --git a/include/linux/device.h b/include/linux/device.h
index e85264fb6616..0da5c67f6be1 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1373,6 +1373,7 @@ extern int (*platform_notify_remove)(struct device *dev);
  */
 extern struct device *get_device(struct device *dev);
 extern void put_device(struct device *dev);
+extern bool kill_device(struct device *dev);
 
 #ifdef CONFIG_DEVTMPFS
 extern int devtmpfs_create_node(struct device *dev);

