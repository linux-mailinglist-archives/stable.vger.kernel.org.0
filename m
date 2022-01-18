Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1F3491861
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344696AbiARCq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:46:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34546 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245507AbiARCnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:43:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DB5161269;
        Tue, 18 Jan 2022 02:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B11C36B04;
        Tue, 18 Jan 2022 02:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473791;
        bh=lMEBuMlvnB1Pwb+Tnv2fUmVQFddWQ68uoefQrCW//Rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKujjtFabwLhlY+x96Ww23TWMGxQPpEBZwySAdALSrZbneAax2YnI6fFOwIVnkPKl
         WwpN0iQ9BBaofs4OBVfPKXUfEdarbDNFnAakbevmGR+fBv2YAUxPzqP1DbtEBsmueO
         LQuuJCtOqRTXfYcHclPPtJyB3h53Id1oEibQOGHDsiFpwFlqDq6voyiYOilFfOHJ/P
         TDpjxQVWWmYliO/SlbzU1adlyGQNgO+LknCGvUS8vyjh7l9aixhOwROK73UdFdROOJ
         KyW3rtdAAjfvNjjD0AzERrbRYRcGUk6X+MUXzyaxINGRVS4CpTcPxtktKvwTdBj6CZ
         ZNd+ks1OJMCag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 074/116] PM: runtime: Add safety net to supplier device release
Date:   Mon, 17 Jan 2022 21:39:25 -0500
Message-Id: <20220118024007.1950576-74-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

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

