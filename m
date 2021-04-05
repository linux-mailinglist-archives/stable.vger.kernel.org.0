Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C9F353F09
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237981AbhDEJJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:09:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238706AbhDEJIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:08:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3FF761399;
        Mon,  5 Apr 2021 09:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613724;
        bh=N35o62fbSEOSuqmsqry1AgPULNdNIjR4VW3kwET2dVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CwJsHRD/CFondDvz2QmztcD9553/0BFBeZahPrKViikAENPe8tIm48K4QOrnNW1cd
         tDIE57uMbmedXmD0e0Efwl8pTduVTdd0jzAkNpp6m4olKn+losQzSiDF8bij2moUT7
         CjphTWAWM9X54XoTwrisjwSNAzH3zxBf+/H/Bq2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 067/126] PM: runtime: Fix race getting/putting suppliers at probe
Date:   Mon,  5 Apr 2021 10:53:49 +0200
Message-Id: <20210405085033.273872417@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 9dfacc54a8661bc8be6e08cffee59596ec59f263 upstream.

pm_runtime_put_suppliers() must not decrement rpm_active unless the
consumer is suspended. That is because, otherwise, it could suspend
suppliers for an active consumer.

That can happen as follows:

 static int driver_probe_device(struct device_driver *drv, struct device *dev)
 {
	int ret = 0;

	if (!device_is_registered(dev))
		return -ENODEV;

	dev->can_match = true;
	pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
		 drv->bus->name, __func__, dev_name(dev), drv->name);

	pm_runtime_get_suppliers(dev);
	if (dev->parent)
		pm_runtime_get_sync(dev->parent);

 At this point, dev can runtime suspend so rpm_put_suppliers() can run,
 rpm_active becomes 1 (the lowest value).

	pm_runtime_barrier(dev);
	if (initcall_debug)
		ret = really_probe_debug(dev, drv);
	else
		ret = really_probe(dev, drv);

 Probe callback can have runtime resumed dev, and then runtime put
 so dev is awaiting autosuspend, but rpm_active is 2.

	pm_request_idle(dev);

	if (dev->parent)
		pm_runtime_put(dev->parent);

	pm_runtime_put_suppliers(dev);

 Now pm_runtime_put_suppliers() will put the supplier
 i.e. rpm_active 2 -> 1, but consumer can still be active.

	return ret;
 }

Fix by checking the runtime status. For any status other than
RPM_SUSPENDED, rpm_active can be considered to be "owned" by
rpm_[get/put]_suppliers() and pm_runtime_put_suppliers() need do nothing.

Reported-by: Asutosh Das <asutoshd@codeaurora.org>
Fixes: 4c06c4e6cf63 ("driver core: Fix possible supplier PM-usage counter imbalance")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: 5.1+ <stable@vger.kernel.org> # 5.1+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/runtime.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1704,6 +1704,8 @@ void pm_runtime_get_suppliers(struct dev
 void pm_runtime_put_suppliers(struct device *dev)
 {
 	struct device_link *link;
+	unsigned long flags;
+	bool put;
 	int idx;
 
 	idx = device_links_read_lock();
@@ -1712,7 +1714,11 @@ void pm_runtime_put_suppliers(struct dev
 				device_links_read_lock_held())
 		if (link->supplier_preactivated) {
 			link->supplier_preactivated = false;
-			if (refcount_dec_not_one(&link->rpm_active))
+			spin_lock_irqsave(&dev->power.lock, flags);
+			put = pm_runtime_status_suspended(dev) &&
+			      refcount_dec_not_one(&link->rpm_active);
+			spin_unlock_irqrestore(&dev->power.lock, flags);
+			if (put)
 				pm_runtime_put(link->supplier);
 		}
 


