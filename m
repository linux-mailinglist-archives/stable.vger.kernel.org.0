Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49D734C8FC
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhC2IZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:25:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232888AbhC2IYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:24:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DA2C61878;
        Mon, 29 Mar 2021 08:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006243;
        bh=jNHaVENm51uWt+A854LCb3jgPp4vzZ8MXIcs+i0G22M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1rF2Bk1KoasLkZUk+GExUZF8UhSG6jtFXnIFhd5G7Nyj43POHHEZAY0sZAdMUZFO7
         NdmFwYMmFegmHcE7jgR4Icf7a1qHFE+PBxSHm/dYnzqWbw5J5svkIU7NLZc2ay+Eip
         y0tDV+PxP/B0b6VQaZ8DUB86qJyW0ayohCaz7lb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "elaine.zhang" <zhangqing@rock-chips.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 169/221] PM: runtime: Defer suspending suppliers
Date:   Mon, 29 Mar 2021 09:58:20 +0200
Message-Id: <20210329075634.792559720@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 5244f5e2d801259af877ee759e8c22364c607072 ]

Because the PM-runtime status of the device is not updated in
__rpm_callback(), attempts to suspend the suppliers of the given
device triggered by the rpm_put_suppliers() call in there may
cause a supplier to be suspended completely before the status of
the consumer is updated to RPM_SUSPENDED, which is confusing.

To avoid that (1) modify __rpm_callback() to only decrease the
PM-runtime usage counter of each supplier and (2) make rpm_suspend()
try to suspend the suppliers after changing the consumer's status to
RPM_SUSPENDED, in analogy with the device's parent.

Link: https://lore.kernel.org/linux-pm/CAPDyKFqm06KDw_p8WXsM4dijDbho4bb6T4k50UqqvR1_COsp8g@mail.gmail.com/
Fixes: 21d5c57b3726 ("PM / runtime: Use device links")
Reported-by: elaine.zhang <zhangqing@rock-chips.com>
Diagnosed-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/runtime.c | 45 +++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index bfda153b1a41..5ef67bacb585 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -305,7 +305,7 @@ static int rpm_get_suppliers(struct device *dev)
 	return 0;
 }
 
-static void rpm_put_suppliers(struct device *dev)
+static void __rpm_put_suppliers(struct device *dev, bool try_to_suspend)
 {
 	struct device_link *link;
 
@@ -313,10 +313,30 @@ static void rpm_put_suppliers(struct device *dev)
 				device_links_read_lock_held()) {
 
 		while (refcount_dec_not_one(&link->rpm_active))
-			pm_runtime_put(link->supplier);
+			pm_runtime_put_noidle(link->supplier);
+
+		if (try_to_suspend)
+			pm_request_idle(link->supplier);
 	}
 }
 
+static void rpm_put_suppliers(struct device *dev)
+{
+	__rpm_put_suppliers(dev, true);
+}
+
+static void rpm_suspend_suppliers(struct device *dev)
+{
+	struct device_link *link;
+	int idx = device_links_read_lock();
+
+	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
+				device_links_read_lock_held())
+		pm_request_idle(link->supplier);
+
+	device_links_read_unlock(idx);
+}
+
 /**
  * __rpm_callback - Run a given runtime PM callback for a given device.
  * @cb: Runtime PM callback to run.
@@ -344,8 +364,10 @@ static int __rpm_callback(int (*cb)(struct device *), struct device *dev)
 			idx = device_links_read_lock();
 
 			retval = rpm_get_suppliers(dev);
-			if (retval)
+			if (retval) {
+				rpm_put_suppliers(dev);
 				goto fail;
+			}
 
 			device_links_read_unlock(idx);
 		}
@@ -368,9 +390,9 @@ static int __rpm_callback(int (*cb)(struct device *), struct device *dev)
 		    || (dev->power.runtime_status == RPM_RESUMING && retval))) {
 			idx = device_links_read_lock();
 
- fail:
-			rpm_put_suppliers(dev);
+			__rpm_put_suppliers(dev, false);
 
+fail:
 			device_links_read_unlock(idx);
 		}
 
@@ -642,8 +664,11 @@ static int rpm_suspend(struct device *dev, int rpmflags)
 		goto out;
 	}
 
+	if (dev->power.irq_safe)
+		goto out;
+
 	/* Maybe the parent is now able to suspend. */
-	if (parent && !parent->power.ignore_children && !dev->power.irq_safe) {
+	if (parent && !parent->power.ignore_children) {
 		spin_unlock(&dev->power.lock);
 
 		spin_lock(&parent->power.lock);
@@ -652,6 +677,14 @@ static int rpm_suspend(struct device *dev, int rpmflags)
 
 		spin_lock(&dev->power.lock);
 	}
+	/* Maybe the suppliers are now able to suspend. */
+	if (dev->power.links_count > 0) {
+		spin_unlock_irq(&dev->power.lock);
+
+		rpm_suspend_suppliers(dev);
+
+		spin_lock_irq(&dev->power.lock);
+	}
 
  out:
 	trace_rpm_return_int_rcuidle(dev, _THIS_IP_, retval);
-- 
2.30.1



