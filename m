Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7623314848E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388851AbgAXLMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:12:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389947AbgAXLMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:12:03 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 743702071A;
        Fri, 24 Jan 2020 11:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864322;
        bh=NvpeZlpEACeNqrHU6EvRidRzNpRRgevTlo31rs9aT2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNf4dMoqeqdkX5R07NXusH4CRG912WbGQnb2GL2SBQ/iu31ovTEUbc596iCRUACgj
         7JPXfDWl4gHZmzXS3hfb4CL6idw79l0lTOT2qT2s1V64nVKktZE60QXpQ7cKT9DWoL
         YgjT4ujFM+XMIHEs/6bFZqu5Ko5SOPE4PWoCficI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 221/639] driver core: Fix PM-runtime for links added during consumer probe
Date:   Fri, 24 Jan 2020 10:26:31 +0100
Message-Id: <20200124093114.615259956@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 36003d4cf57ca431fb3f94d317bcca426a2394d6 ]

Commit 4c06c4e6cf63 ("driver core: Fix possible supplier PM-usage
counter imbalance") introduced a regression that causes suppliers
to be suspended prematurely for device links added during consumer
driver probe if the initial PM-runtime status of the consumer is
"suspended" and the consumer is resumed after adding the link and
before pm_runtime_put_suppliers() is called.  In that case,
pm_runtime_put_suppliers() will drop the rpm_active refcount for
the link by one and (since rpm_active is equal to two after the
preceding consumer resume) the supplier's PM-runtime usage counter
will be decremented, which may cause the supplier to suspend even
though the consumer's PM-runtime status is "active".

For this reason, partially revert commit 4c06c4e6cf63 as the problem
it tried to fix needs to be addressed somewhat differently, and
change pm_runtime_get_suppliers() and pm_runtime_put_suppliers() so
that the latter only drops rpm_active references acquired by the
former.  [This requires adding a new field to struct device_link,
but I coulnd't find a cleaner way to address the issue that would
work in all cases.]

This causes pm_runtime_put_suppliers() to effectively ignore device
links added during consumer probe, so device_link_add() doesn't need
to worry about ensuring that suppliers will remain active after
pm_runtime_put_suppliers() for links created with DL_FLAG_RPM_ACTIVE
set and it only needs to bump up rpm_active by one for those links,
so pm_runtime_active_link() is not necessary any more.

Fixes: 4c06c4e6cf63 ("driver core: Fix possible supplier PM-usage counter imbalance")
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c          |  4 ++--
 drivers/base/power/runtime.c | 29 ++++++-----------------------
 include/linux/device.h       |  1 +
 include/linux/pm_runtime.h   |  4 ----
 4 files changed, 9 insertions(+), 29 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index ab08211ba5d2d..742bc60e9ccac 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -253,7 +253,7 @@ struct device_link *device_link_add(struct device *consumer,
 				link->flags |= DL_FLAG_PM_RUNTIME;
 			}
 			if (flags & DL_FLAG_RPM_ACTIVE)
-				pm_runtime_active_link(link, supplier);
+				refcount_inc(&link->rpm_active);
 		}
 
 		kref_get(&link->kref);
@@ -268,7 +268,7 @@ struct device_link *device_link_add(struct device *consumer,
 
 	if (flags & DL_FLAG_PM_RUNTIME) {
 		if (flags & DL_FLAG_RPM_ACTIVE)
-			pm_runtime_active_link(link, supplier);
+			refcount_inc(&link->rpm_active);
 
 		pm_runtime_new_link(consumer);
 	}
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 0527890b4c191..303ce7d54a306 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1571,6 +1571,7 @@ void pm_runtime_get_suppliers(struct device *dev)
 
 	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node)
 		if (link->flags & DL_FLAG_PM_RUNTIME) {
+			link->supplier_preactivated = true;
 			refcount_inc(&link->rpm_active);
 			pm_runtime_get_sync(link->supplier);
 		}
@@ -1590,9 +1591,11 @@ void pm_runtime_put_suppliers(struct device *dev)
 	idx = device_links_read_lock();
 
 	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node)
-		if (link->flags & DL_FLAG_PM_RUNTIME &&
-		    refcount_dec_not_one(&link->rpm_active))
-			pm_runtime_put(link->supplier);
+		if (link->supplier_preactivated) {
+			link->supplier_preactivated = false;
+			if (refcount_dec_not_one(&link->rpm_active))
+				pm_runtime_put(link->supplier);
+		}
 
 	device_links_read_unlock(idx);
 }
@@ -1604,26 +1607,6 @@ void pm_runtime_new_link(struct device *dev)
 	spin_unlock_irq(&dev->power.lock);
 }
 
-/**
- * pm_runtime_active_link - Set up new device link as active for PM-runtime.
- * @link: Device link to be set up as active.
- * @supplier: Supplier end of the link.
- *
- * Add 2 to the rpm_active refcount of @link and increment the PM-runtime
- * usage counter of @supplier once more in case the link is being added while
- * the consumer driver is probing and pm_runtime_put_suppliers() will be called
- * subsequently.
- *
- * Note that this doesn't prevent rpm_put_suppliers() from decreasing the link's
- * rpm_active refcount down to one, so runtime suspend of the consumer end of
- * @link is not affected.
- */
-void pm_runtime_active_link(struct device_link *link, struct device *supplier)
-{
-	refcount_add(2, &link->rpm_active);
-	pm_runtime_get_noresume(supplier);
-}
-
 void pm_runtime_drop_link(struct device *dev)
 {
 	spin_lock_irq(&dev->power.lock);
diff --git a/include/linux/device.h b/include/linux/device.h
index b8fd2a1f859db..e9d1c768f972a 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -854,6 +854,7 @@ struct device_link {
 #ifdef CONFIG_SRCU
 	struct rcu_head rcu_head;
 #endif
+	bool supplier_preactivated; /* Owned by consumer probe. */
 };
 
 /**
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index bace7df51af4d..f0fc4700b6ff5 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -59,8 +59,6 @@ extern void pm_runtime_clean_up_links(struct device *dev);
 extern void pm_runtime_get_suppliers(struct device *dev);
 extern void pm_runtime_put_suppliers(struct device *dev);
 extern void pm_runtime_new_link(struct device *dev);
-extern void pm_runtime_active_link(struct device_link *link,
-				   struct device *supplier);
 extern void pm_runtime_drop_link(struct device *dev);
 
 static inline void pm_suspend_ignore_children(struct device *dev, bool enable)
@@ -178,8 +176,6 @@ static inline void pm_runtime_clean_up_links(struct device *dev) {}
 static inline void pm_runtime_get_suppliers(struct device *dev) {}
 static inline void pm_runtime_put_suppliers(struct device *dev) {}
 static inline void pm_runtime_new_link(struct device *dev) {}
-static inline void pm_runtime_active_link(struct device_link *link,
-					  struct device *supplier) {}
 static inline void pm_runtime_drop_link(struct device *dev) {}
 
 #endif /* !CONFIG_PM */
-- 
2.20.1



