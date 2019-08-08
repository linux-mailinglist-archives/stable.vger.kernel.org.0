Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06BF386996
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404988AbfHHTIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404518AbfHHTIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A4DC214C6;
        Thu,  8 Aug 2019 19:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291328;
        bh=lmreystj+/u7Ao2YRC/eCXKnhPR102zWldgpG09ZbDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2VZorU7dvoVSf+evVRY9oZTEHuHZ+ZBlKM1QHumQEvn4M3J0cXfCALM6yqV7mYKuv
         jaXOrvy5vHc7ofDYKAyeWV9xOH/xjz59zYVtOYvz0fub64BcXfOZqer4bdfJxu+umY
         RW0vNWMvOvLwnP0LScCQ5PElAdlKSvbI5Js/eq5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        Jane Chu <jane.chu@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/45] drivers/base: Introduce kill_device()
Date:   Thu,  8 Aug 2019 21:04:50 +0200
Message-Id: <20190808190454.048361275@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 00289cd87676e14913d2d8492d1ce05c4baafdae upstream.

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
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/156341207332.292348.14959761496009347574.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c    | 27 +++++++++++++++++++--------
 include/linux/device.h |  1 +
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 37a90d72f3736..e1a8d5c06f65e 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2031,6 +2031,24 @@ void put_device(struct device *dev)
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
@@ -2050,15 +2068,8 @@ void device_del(struct device *dev)
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
index 3f1066a9e1c3a..19dd8852602c4 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1332,6 +1332,7 @@ extern int (*platform_notify_remove)(struct device *dev);
  */
 extern struct device *get_device(struct device *dev);
 extern void put_device(struct device *dev);
+extern bool kill_device(struct device *dev);
 
 #ifdef CONFIG_DEVTMPFS
 extern int devtmpfs_create_node(struct device *dev);
-- 
2.20.1



