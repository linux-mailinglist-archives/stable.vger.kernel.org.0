Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF0D2ABAC3
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388163AbgKINWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:22:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733228AbgKINWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:22:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9B0120663;
        Mon,  9 Nov 2020 13:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928124;
        bh=4neTZfsWsgDJac2MUCAwgoPtEy1/kmvoM43g7TTrffY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOnWSRiKYm9Y21zc8otPMxLK+HGvJS0I7DOmsqEEmVPYoEE4Bf4z7+ew86Xyhyqhm
         5UqQFObHrfAVEAinigLYVHdJ1BNFFsQDL8DGlzv24MsXaeA+7aNN6QY5n/0R4wpHzq
         oxtWuWqfzRvtiN5Gz0fkZtLjqGyQ+vH3npdgIrxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 5.9 128/133] PM: runtime: Drop runtime PM references to supplier on link removal
Date:   Mon,  9 Nov 2020 13:56:30 +0100
Message-Id: <20201109125036.844040612@linuxfoundation.org>
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
@@ -763,8 +763,7 @@ static void __device_link_del(struct kre
 	dev_dbg(link->consumer, "Dropping the link to %s\n",
 		dev_name(link->supplier));
 
-	if (link->flags & DL_FLAG_PM_RUNTIME)
-		pm_runtime_drop_link(link->consumer);
+	pm_runtime_drop_link(link);
 
 	list_del_rcu(&link->s_node);
 	list_del_rcu(&link->c_node);
@@ -778,8 +777,7 @@ static void __device_link_del(struct kre
 	dev_info(link->consumer, "Dropping the link to %s\n",
 		 dev_name(link->supplier));
 
-	if (link->flags & DL_FLAG_PM_RUNTIME)
-		pm_runtime_drop_link(link->consumer);
+	pm_runtime_drop_link(link);
 
 	list_del(&link->s_node);
 	list_del(&link->c_node);
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1729,7 +1729,7 @@ void pm_runtime_new_link(struct device *
 	spin_unlock_irq(&dev->power.lock);
 }
 
-void pm_runtime_drop_link(struct device *dev)
+static void pm_runtime_drop_link_count(struct device *dev)
 {
 	spin_lock_irq(&dev->power.lock);
 	WARN_ON(dev->power.links_count == 0);
@@ -1737,6 +1737,25 @@ void pm_runtime_drop_link(struct device
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
 
 /**
  * pm_runtime_get_if_in_use - Conditionally bump up runtime PM usage counter.
@@ -280,7 +280,7 @@ static inline void pm_runtime_clean_up_l
 static inline void pm_runtime_get_suppliers(struct device *dev) {}
 static inline void pm_runtime_put_suppliers(struct device *dev) {}
 static inline void pm_runtime_new_link(struct device *dev) {}
-static inline void pm_runtime_drop_link(struct device *dev) {}
+static inline void pm_runtime_drop_link(struct device_link *link) {}
 
 #endif /* !CONFIG_PM */
 


