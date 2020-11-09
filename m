Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC852ABB4C
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731329AbgKIN1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:27:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732466AbgKINPJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:15:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C53920789;
        Mon,  9 Nov 2020 13:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927708;
        bh=UBnIjRfLVo3LKn5v72bNqnU/QEVCU/7ptv8tPV2S+oQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSyK3Z9EavTsMh+zCGpcJ6pg/qBJTujn+mmAeQmmGgD/3gsdpMEIuNeYWJkMBdZpN
         qQjr0X0pNQwewtnEr2yok+eQEIVSELgT1ZQsoufGBRwZi9ccBs0Ag/e6j9RFp3p4EY
         /RiOjpH4Tv6TNU2yzkUcaa9mZ2m2O3mXHNpEQKUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 5.4 80/85] PM: runtime: Drop runtime PM references to supplier on link removal
Date:   Mon,  9 Nov 2020 13:56:17 +0100
Message-Id: <20201109125026.415600255@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit e0e398e204634db8fb71bd89cf2f6e3e5bd09b51 upstream.

While removing a device link, drop the supplier device's runtime PM
usage counter as many times as needed to drop all of the runtime PM
references to it from the consumer in addition to dropping the
consumer's link count.

Fixes: baa8809f6097 ("PM / runtime: Optimize the use of device links")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 5.1+ <stable@vger.kernel.org> # 5.1+
Tested-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/core.c          |    6 ++----
 drivers/base/power/runtime.c |   21 ++++++++++++++++++++-
 include/linux/pm_runtime.h   |    4 ++--
 3 files changed, 24 insertions(+), 7 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -454,8 +454,7 @@ static void __device_link_del(struct kre
 	dev_dbg(link->consumer, "Dropping the link to %s\n",
 		dev_name(link->supplier));
 
-	if (link->flags & DL_FLAG_PM_RUNTIME)
-		pm_runtime_drop_link(link->consumer);
+	pm_runtime_drop_link(link);
 
 	list_del_rcu(&link->s_node);
 	list_del_rcu(&link->c_node);
@@ -469,8 +468,7 @@ static void __device_link_del(struct kre
 	dev_info(link->consumer, "Dropping the link to %s\n",
 		 dev_name(link->supplier));
 
-	if (link->flags & DL_FLAG_PM_RUNTIME)
-		pm_runtime_drop_link(link->consumer);
+	pm_runtime_drop_link(link);
 
 	list_del(&link->s_node);
 	list_del(&link->c_node);
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1702,7 +1702,7 @@ void pm_runtime_new_link(struct device *
 	spin_unlock_irq(&dev->power.lock);
 }
 
-void pm_runtime_drop_link(struct device *dev)
+static void pm_runtime_drop_link_count(struct device *dev)
 {
 	spin_lock_irq(&dev->power.lock);
 	WARN_ON(dev->power.links_count == 0);
@@ -1710,6 +1710,25 @@ void pm_runtime_drop_link(struct device
 	spin_unlock_irq(&dev->power.lock);
 }
 
+/**
+ * pm_runtime_drop_link - Prepare for device link removal.
+ * @link: Device link going away.
+ *
+ * Drop the link count of the consumer end of @link and decrement the supplier
+ * device's runtime PM usage counter as many times as needed to drop all of the
+ * PM runtime reference to it from the consumer.
+ */
+void pm_runtime_drop_link(struct device_link *link)
+{
+	if (!(link->flags & DL_FLAG_PM_RUNTIME))
+		return;
+
+	pm_runtime_drop_link_count(link->consumer);
+
+	while (refcount_dec_not_one(&link->rpm_active))
+		pm_runtime_put(link->supplier);
+}
+
 static bool pm_runtime_need_not_resume(struct device *dev)
 {
 	return atomic_read(&dev->power.usage_count) <= 1 &&
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -58,7 +58,7 @@ extern void pm_runtime_clean_up_links(st
 extern void pm_runtime_get_suppliers(struct device *dev);
 extern void pm_runtime_put_suppliers(struct device *dev);
 extern void pm_runtime_new_link(struct device *dev);
-extern void pm_runtime_drop_link(struct device *dev);
+extern void pm_runtime_drop_link(struct device_link *link);
 
 static inline void pm_suspend_ignore_children(struct device *dev, bool enable)
 {
@@ -177,7 +177,7 @@ static inline void pm_runtime_clean_up_l
 static inline void pm_runtime_get_suppliers(struct device *dev) {}
 static inline void pm_runtime_put_suppliers(struct device *dev) {}
 static inline void pm_runtime_new_link(struct device *dev) {}
-static inline void pm_runtime_drop_link(struct device *dev) {}
+static inline void pm_runtime_drop_link(struct device_link *link) {}
 
 #endif /* !CONFIG_PM */
 


