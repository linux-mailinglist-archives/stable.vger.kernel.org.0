Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF3C344324
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhCVMsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231147AbhCVMqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:46:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD71B6198E;
        Mon, 22 Mar 2021 12:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416953;
        bh=85xbLg0N24rYjYG9rU+hPSlW4FE4imDZ2NNfjYfcj2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3XATeiUiNn/mDkcsOoBquZ5dOjEJjDqYwkmh8iqbGJj3HW+BFALWcP3KoQjf1y0K
         OsR5UK7XIa0I4gfMYl03hJ/5Ob1+WmsEoXTtCPEEA8r2l2O5Q6kHyF0AchMnffyVgw
         8Y4NfpYXru6U7BtnyOPHXooK1JLHVU/4feHhFkrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 07/60] Revert "PM: runtime: Update device status before letting suppliers suspend"
Date:   Mon, 22 Mar 2021 13:27:55 +0100
Message-Id: <20210322121922.615018815@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 0cab893f409c53634d0d818fa414641cbcdb0dab upstream.

Revert commit 44cc89f76464 ("PM: runtime: Update device status
before letting suppliers suspend") that introduced a race condition
into __rpm_callback() which allowed a concurrent rpm_resume() to
run and resume the device prematurely after its status had been
changed to RPM_SUSPENDED by __rpm_callback().

Fixes: 44cc89f76464 ("PM: runtime: Update device status before letting suppliers suspend")
Link: https://lore.kernel.org/linux-pm/24dfb6fc-5d54-6ee2-9195-26428b7ecf8a@intel.com/
Reported-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: 4.10+ <stable@vger.kernel.org> # 4.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/runtime.c |   62 +++++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 37 deletions(-)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -325,22 +325,22 @@ static void rpm_put_suppliers(struct dev
 static int __rpm_callback(int (*cb)(struct device *), struct device *dev)
 	__releases(&dev->power.lock) __acquires(&dev->power.lock)
 {
-	bool use_links = dev->power.links_count > 0;
-	bool get = false;
 	int retval, idx;
-	bool put;
+	bool use_links = dev->power.links_count > 0;
 
 	if (dev->power.irq_safe) {
 		spin_unlock(&dev->power.lock);
-	} else if (!use_links) {
-		spin_unlock_irq(&dev->power.lock);
 	} else {
-		get = dev->power.runtime_status == RPM_RESUMING;
-
 		spin_unlock_irq(&dev->power.lock);
 
-		/* Resume suppliers if necessary. */
-		if (get) {
+		/*
+		 * Resume suppliers if necessary.
+		 *
+		 * The device's runtime PM status cannot change until this
+		 * routine returns, so it is safe to read the status outside of
+		 * the lock.
+		 */
+		if (use_links && dev->power.runtime_status == RPM_RESUMING) {
 			idx = device_links_read_lock();
 
 			retval = rpm_get_suppliers(dev);
@@ -355,36 +355,24 @@ static int __rpm_callback(int (*cb)(stru
 
 	if (dev->power.irq_safe) {
 		spin_lock(&dev->power.lock);
-		return retval;
-	}
-
-	spin_lock_irq(&dev->power.lock);
-
-	if (!use_links)
-		return retval;
-
-	/*
-	 * If the device is suspending and the callback has returned success,
-	 * drop the usage counters of the suppliers that have been reference
-	 * counted on its resume.
-	 *
-	 * Do that if the resume fails too.
-	 */
-	put = dev->power.runtime_status == RPM_SUSPENDING && !retval;
-	if (put)
-		__update_runtime_status(dev, RPM_SUSPENDED);
-	else
-		put = get && retval;
-
-	if (put) {
-		spin_unlock_irq(&dev->power.lock);
-
-		idx = device_links_read_lock();
+	} else {
+		/*
+		 * If the device is suspending and the callback has returned
+		 * success, drop the usage counters of the suppliers that have
+		 * been reference counted on its resume.
+		 *
+		 * Do that if resume fails too.
+		 */
+		if (use_links
+		    && ((dev->power.runtime_status == RPM_SUSPENDING && !retval)
+		    || (dev->power.runtime_status == RPM_RESUMING && retval))) {
+			idx = device_links_read_lock();
 
-fail:
-		rpm_put_suppliers(dev);
+ fail:
+			rpm_put_suppliers(dev);
 
-		device_links_read_unlock(idx);
+			device_links_read_unlock(idx);
+		}
 
 		spin_lock_irq(&dev->power.lock);
 	}


