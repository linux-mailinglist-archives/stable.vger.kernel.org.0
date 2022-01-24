Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BD549909A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245534AbiAXUBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:01:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44866 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359363AbiAXT7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:59:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAA2FB8119E;
        Mon, 24 Jan 2022 19:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349C7C340E5;
        Mon, 24 Jan 2022 19:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054373;
        bh=H866M6xCOcdYv+r6p734DGCGRCl35R3+8VLYrg5bNJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yoTZEiippC5IVv/nLR4Eg0BBkU0gMnf57zNBtRV+n0vOnV7tj4pu4zepahpVu+dV7
         qNOzD89nXidFLNcGMBc3yu4u46xVA/WlZpDQUdPVjxGi8v64rkv6jqotcW9d0s85i9
         ZbJnTz5JmuPGpk2nfcevw93PswewyecgAE9DXGto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 369/563] PM: runtime: Add safety net to supplier device release
Date:   Mon, 24 Jan 2022 19:42:14 +0100
Message-Id: <20220124184037.180762615@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit d1579e61192e0e686faa4208500ef4c3b529b16c ]

Because refcount_dec_not_one() returns true if the target refcount
becomes saturated, it is generally unsafe to use its return value as
a loop termination condition, but that is what happens when a device
link's supplier device is released during runtime PM suspend
operations and on device link removal.

To address this, introduce pm_runtime_release_supplier() to be used
in the above cases which will check the supplier device's runtime
PM usage counter in addition to the refcount_dec_not_one() return
value, so the loop can be terminated in case the rpm_active refcount
value becomes invalid, and update the code in question to use it as
appropriate.

This change is not expected to have any visible functional impact.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c          |  3 +--
 drivers/base/power/runtime.c | 41 ++++++++++++++++++++++++++----------
 include/linux/pm_runtime.h   |  3 +++
 3 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 389d13616d1df..c0566aff53551 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -348,8 +348,7 @@ static void device_link_release_fn(struct work_struct *work)
 	/* Ensure that all references to the link object have been dropped. */
 	device_link_synchronize_removal();
 
-	while (refcount_dec_not_one(&link->rpm_active))
-		pm_runtime_put(link->supplier);
+	pm_runtime_release_supplier(link, true);
 
 	put_device(link->consumer);
 	put_device(link->supplier);
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index bc649da4899a0..1573319404888 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -305,19 +305,40 @@ static int rpm_get_suppliers(struct device *dev)
 	return 0;
 }
 
+/**
+ * pm_runtime_release_supplier - Drop references to device link's supplier.
+ * @link: Target device link.
+ * @check_idle: Whether or not to check if the supplier device is idle.
+ *
+ * Drop all runtime PM references associated with @link to its supplier device
+ * and if @check_idle is set, check if that device is idle (and so it can be
+ * suspended).
+ */
+void pm_runtime_release_supplier(struct device_link *link, bool check_idle)
+{
+	struct device *supplier = link->supplier;
+
+	/*
+	 * The additional power.usage_count check is a safety net in case
+	 * the rpm_active refcount becomes saturated, in which case
+	 * refcount_dec_not_one() would return true forever, but it is not
+	 * strictly necessary.
+	 */
+	while (refcount_dec_not_one(&link->rpm_active) &&
+	       atomic_read(&supplier->power.usage_count) > 0)
+		pm_runtime_put_noidle(supplier);
+
+	if (check_idle)
+		pm_request_idle(supplier);
+}
+
 static void __rpm_put_suppliers(struct device *dev, bool try_to_suspend)
 {
 	struct device_link *link;
 
 	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
-				device_links_read_lock_held()) {
-
-		while (refcount_dec_not_one(&link->rpm_active))
-			pm_runtime_put_noidle(link->supplier);
-
-		if (try_to_suspend)
-			pm_request_idle(link->supplier);
-	}
+				device_links_read_lock_held())
+		pm_runtime_release_supplier(link, try_to_suspend);
 }
 
 static void rpm_put_suppliers(struct device *dev)
@@ -1755,9 +1776,7 @@ void pm_runtime_drop_link(struct device_link *link)
 		return;
 
 	pm_runtime_drop_link_count(link->consumer);
-
-	while (refcount_dec_not_one(&link->rpm_active))
-		pm_runtime_put(link->supplier);
+	pm_runtime_release_supplier(link, true);
 }
 
 static bool pm_runtime_need_not_resume(struct device *dev)
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index 161acd4ede448..30091ab5de287 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -58,6 +58,7 @@ extern void pm_runtime_get_suppliers(struct device *dev);
 extern void pm_runtime_put_suppliers(struct device *dev);
 extern void pm_runtime_new_link(struct device *dev);
 extern void pm_runtime_drop_link(struct device_link *link);
+extern void pm_runtime_release_supplier(struct device_link *link, bool check_idle);
 
 /**
  * pm_runtime_get_if_in_use - Conditionally bump up runtime PM usage counter.
@@ -279,6 +280,8 @@ static inline void pm_runtime_get_suppliers(struct device *dev) {}
 static inline void pm_runtime_put_suppliers(struct device *dev) {}
 static inline void pm_runtime_new_link(struct device *dev) {}
 static inline void pm_runtime_drop_link(struct device_link *link) {}
+static inline void pm_runtime_release_supplier(struct device_link *link,
+					       bool check_idle) {}
 
 #endif /* !CONFIG_PM */
 
-- 
2.34.1



