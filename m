Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D837F333E2D
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbhCJNZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233185AbhCJNZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E89B64FD7;
        Wed, 10 Mar 2021 13:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382703;
        bh=QXZ5S/Acj15AmWdZhhP801cSifJnhspu68hy6BN/oSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KbPsx6awbEjWSQg01GNIpZ0ydvBqB/dm0G1OXyMZZQ0Ci1ADhG1kSt3nhQmWGuBNO
         G+PTqHociSwHMoYk+a2NhK0N52+AzbUrQ+Bcwd1v2etJEA/zGsklK9wQOyuQ90iqQE
         jZ6bEejYpRoBwX6QryHNgPYohmvO4HcnpCjmzmfQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elaine Zhang <zhangqing@rock-chips.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Elaine Zhang <zhangiqng@rock-chips.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 06/39] PM: runtime: Update device status before letting suppliers suspend
Date:   Wed, 10 Mar 2021 14:24:14 +0100
Message-Id: <20210310132319.932470905@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
References: <20210310132319.708237392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 44cc89f764646b2f1f2ea5d1a08b230131707851 upstream.

Because the PM-runtime status of the device is not updated in
__rpm_callback(), attempts to suspend the suppliers of the given
device triggered by rpm_put_suppliers() called by it may fail.

Fix this by making __rpm_callback() update the device's status to
RPM_SUSPENDED before calling rpm_put_suppliers() if the current
status of the device is RPM_SUSPENDING and the callback just invoked
by it has returned 0 (success).

While at it, modify the code in __rpm_callback() to always check
the device's PM-runtime status under its PM lock.

Link: https://lore.kernel.org/linux-pm/CAPDyKFqm06KDw_p8WXsM4dijDbho4bb6T4k50UqqvR1_COsp8g@mail.gmail.com/
Fixes: 21d5c57b3726 ("PM / runtime: Use device links")
Reported-by: Elaine Zhang <zhangqing@rock-chips.com>
Diagnosed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Elaine Zhang <zhangiqng@rock-chips.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: 4.10+ <stable@vger.kernel.org> # 4.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/runtime.c |   62 +++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 25 deletions(-)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -304,22 +304,22 @@ static void rpm_put_suppliers(struct dev
 static int __rpm_callback(int (*cb)(struct device *), struct device *dev)
 	__releases(&dev->power.lock) __acquires(&dev->power.lock)
 {
-	int retval, idx;
 	bool use_links = dev->power.links_count > 0;
+	bool get = false;
+	int retval, idx;
+	bool put;
 
 	if (dev->power.irq_safe) {
 		spin_unlock(&dev->power.lock);
+	} else if (!use_links) {
+		spin_unlock_irq(&dev->power.lock);
 	} else {
+		get = dev->power.runtime_status == RPM_RESUMING;
+
 		spin_unlock_irq(&dev->power.lock);
 
-		/*
-		 * Resume suppliers if necessary.
-		 *
-		 * The device's runtime PM status cannot change until this
-		 * routine returns, so it is safe to read the status outside of
-		 * the lock.
-		 */
-		if (use_links && dev->power.runtime_status == RPM_RESUMING) {
+		/* Resume suppliers if necessary. */
+		if (get) {
 			idx = device_links_read_lock();
 
 			retval = rpm_get_suppliers(dev);
@@ -334,24 +334,36 @@ static int __rpm_callback(int (*cb)(stru
 
 	if (dev->power.irq_safe) {
 		spin_lock(&dev->power.lock);
-	} else {
-		/*
-		 * If the device is suspending and the callback has returned
-		 * success, drop the usage counters of the suppliers that have
-		 * been reference counted on its resume.
-		 *
-		 * Do that if resume fails too.
-		 */
-		if (use_links
-		    && ((dev->power.runtime_status == RPM_SUSPENDING && !retval)
-		    || (dev->power.runtime_status == RPM_RESUMING && retval))) {
-			idx = device_links_read_lock();
+		return retval;
+	}
 
- fail:
-			rpm_put_suppliers(dev);
+	spin_lock_irq(&dev->power.lock);
 
-			device_links_read_unlock(idx);
-		}
+	if (!use_links)
+		return retval;
+
+	/*
+	 * If the device is suspending and the callback has returned success,
+	 * drop the usage counters of the suppliers that have been reference
+	 * counted on its resume.
+	 *
+	 * Do that if the resume fails too.
+	 */
+	put = dev->power.runtime_status == RPM_SUSPENDING && !retval;
+	if (put)
+		__update_runtime_status(dev, RPM_SUSPENDED);
+	else
+		put = get && retval;
+
+	if (put) {
+		spin_unlock_irq(&dev->power.lock);
+
+		idx = device_links_read_lock();
+
+fail:
+		rpm_put_suppliers(dev);
+
+		device_links_read_unlock(idx);
 
 		spin_lock_irq(&dev->power.lock);
 	}


