Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8626F2ABAC5
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388170AbgKINWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:22:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388165AbgKINWH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:22:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B299E2076E;
        Mon,  9 Nov 2020 13:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928127;
        bh=+faYVdO1WfshJ8bh4372qEibr5R/3PtXIO3hJWRmLxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L0tzUhwc2vkM5nMTZ9UVSyxHiclShGzJVMxQtNcU3MoTFofhtouYpDk6zU1ePVVTk
         DAVq6Rz28E6eQijdMPD4k7KRhcS4BfOxvPsbdGU55dDA9klUcDIA4mKe4TOGQN+2TX
         HDEyiFBbfmSBs13/bd3n1wQvhBH0bOHxxXJkDPcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 5.9 129/133] PM: runtime: Drop pm_runtime_clean_up_links()
Date:   Mon,  9 Nov 2020 13:56:31 +0100
Message-Id: <20201109125036.892185949@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit d6e36668598154820177bfd78c1621d8e6c580a2 upstream.

After commit d12544fb2aa9 ("PM: runtime: Remove link state checks in
rpm_get/put_supplier()") nothing prevents the consumer device's
runtime PM from acquiring additional references to the supplier
device after pm_runtime_clean_up_links() has run (or even while it
is running), so calling this function from __device_release_driver()
may be pointless (or even harmful).

Moreover, it ignores stateless device links, so the runtime PM
handling of managed and stateless device links is inconsistent
because of it, so better get rid of it entirely.

Fixes: d12544fb2aa9 ("PM: runtime: Remove link state checks in rpm_get/put_supplier()")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 5.1+ <stable@vger.kernel.org> # 5.1+
Tested-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/dd.c            |    1 -
 drivers/base/power/runtime.c |   36 ------------------------------------
 include/linux/pm_runtime.h   |    2 --
 3 files changed, 39 deletions(-)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1133,7 +1133,6 @@ static void __device_release_driver(stru
 		}
 
 		pm_runtime_get_sync(dev);
-		pm_runtime_clean_up_links(dev);
 
 		driver_sysfs_remove(dev);
 
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1643,42 +1643,6 @@ void pm_runtime_remove(struct device *de
 }
 
 /**
- * pm_runtime_clean_up_links - Prepare links to consumers for driver removal.
- * @dev: Device whose driver is going to be removed.
- *
- * Check links from this device to any consumers and if any of them have active
- * runtime PM references to the device, drop the usage counter of the device
- * (as many times as needed).
- *
- * Links with the DL_FLAG_MANAGED flag unset are ignored.
- *
- * Since the device is guaranteed to be runtime-active at the point this is
- * called, nothing else needs to be done here.
- *
- * Moreover, this is called after device_links_busy() has returned 'false', so
- * the status of each link is guaranteed to be DL_STATE_SUPPLIER_UNBIND and
- * therefore rpm_active can't be manipulated concurrently.
- */
-void pm_runtime_clean_up_links(struct device *dev)
-{
-	struct device_link *link;
-	int idx;
-
-	idx = device_links_read_lock();
-
-	list_for_each_entry_rcu(link, &dev->links.consumers, s_node,
-				device_links_read_lock_held()) {
-		if (!(link->flags & DL_FLAG_MANAGED))
-			continue;
-
-		while (refcount_dec_not_one(&link->rpm_active))
-			pm_runtime_put_noidle(dev);
-	}
-
-	device_links_read_unlock(idx);
-}
-
-/**
  * pm_runtime_get_suppliers - Resume and reference-count supplier devices.
  * @dev: Consumer device.
  */
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -54,7 +54,6 @@ extern u64 pm_runtime_autosuspend_expira
 extern void pm_runtime_update_max_time_suspended(struct device *dev,
 						 s64 delta_ns);
 extern void pm_runtime_set_memalloc_noio(struct device *dev, bool enable);
-extern void pm_runtime_clean_up_links(struct device *dev);
 extern void pm_runtime_get_suppliers(struct device *dev);
 extern void pm_runtime_put_suppliers(struct device *dev);
 extern void pm_runtime_new_link(struct device *dev);
@@ -276,7 +275,6 @@ static inline u64 pm_runtime_autosuspend
 				struct device *dev) { return 0; }
 static inline void pm_runtime_set_memalloc_noio(struct device *dev,
 						bool enable){}
-static inline void pm_runtime_clean_up_links(struct device *dev) {}
 static inline void pm_runtime_get_suppliers(struct device *dev) {}
 static inline void pm_runtime_put_suppliers(struct device *dev) {}
 static inline void pm_runtime_new_link(struct device *dev) {}


