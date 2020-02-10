Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD810157BDC
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgBJNdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:33:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbgBJMfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:40 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F045124676;
        Mon, 10 Feb 2020 12:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338139;
        bh=3iWbfAP+PG1KW8y63o4x49d5mJdWLWyQ+qpsewFAmDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1jt2TLEPXrH/bn8sGevCwpnaAh/9HtSEw6wfFeLOVWoxxYjOUm6aweC/PN1Y6h2+b
         CjGwbrS4BXJeypI0kqqN6kONAr43ovW59BGBXAsJsq5b4UeVLB3vJUswbcBwsc2Git
         3BdrqVPLbsXb76uABgHR+PxFoj0rO1Ongrs68dhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chanho Min <chanho.min@lge.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 084/195] PM: core: Fix handling of devices deleted during system-wide resume
Date:   Mon, 10 Feb 2020 04:32:22 -0800
Message-Id: <20200210122313.698514623@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 0552e05fdfea191a2cf3a0abd33574b5ef9ca818 upstream.

If a device is deleted by one of its system-wide resume callbacks
(for example, because it does not appear to be present or accessible
any more) along with its children, the resume of the children may
continue leading to use-after-free errors and other issues
(potentially).

Namely, if the device's children are resumed asynchronously, their
resume may have been scheduled already before the device's callback
runs and so the device may be deleted while dpm_wait_for_superior()
is being executed for them.  The memory taken up by the parent device
object may be freed then while dpm_wait() is waiting for the parent's
resume callback to complete, which leads to a use-after-free.
Moreover, the resume of the children is really not expected to
continue after they have been unregistered, so it must be terminated
right away in that case.

To address this problem, modify dpm_wait_for_superior() to check
if the target device is still there in the system-wide PM list of
devices and if so, to increment its parent's reference counter, both
under dpm_list_mtx which prevents device_del() running for the child
from dropping the parent's reference counter prematurely.

If the device is not present in the system-wide PM list of devices
any more, the resume of it cannot continue, so check that again after
dpm_wait() returns, which means that the parent's callback has been
completed, and pass the result of that check to the caller of
dpm_wait_for_superior() to allow it to abort the device's resume
if it is not there any more.

Link: https://lore.kernel.org/linux-pm/1579568452-27253-1-git-send-email-chanho.min@lge.com
Reported-by: Chanho Min <chanho.min@lge.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/main.c |   42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -265,10 +265,38 @@ static void dpm_wait_for_suppliers(struc
 	device_links_read_unlock(idx);
 }
 
-static void dpm_wait_for_superior(struct device *dev, bool async)
+static bool dpm_wait_for_superior(struct device *dev, bool async)
 {
-	dpm_wait(dev->parent, async);
+	struct device *parent;
+
+	/*
+	 * If the device is resumed asynchronously and the parent's callback
+	 * deletes both the device and the parent itself, the parent object may
+	 * be freed while this function is running, so avoid that by reference
+	 * counting the parent once more unless the device has been deleted
+	 * already (in which case return right away).
+	 */
+	mutex_lock(&dpm_list_mtx);
+
+	if (!device_pm_initialized(dev)) {
+		mutex_unlock(&dpm_list_mtx);
+		return false;
+	}
+
+	parent = get_device(dev->parent);
+
+	mutex_unlock(&dpm_list_mtx);
+
+	dpm_wait(parent, async);
+	put_device(parent);
+
 	dpm_wait_for_suppliers(dev, async);
+
+	/*
+	 * If the parent's callback has deleted the device, attempting to resume
+	 * it would be invalid, so avoid doing that then.
+	 */
+	return device_pm_initialized(dev);
 }
 
 static void dpm_wait_for_consumers(struct device *dev, bool async)
@@ -628,7 +656,8 @@ static int device_resume_noirq(struct de
 	if (!dev->power.is_noirq_suspended)
 		goto Out;
 
-	dpm_wait_for_superior(dev, async);
+	if (!dpm_wait_for_superior(dev, async))
+		goto Out;
 
 	skip_resume = dev_pm_may_skip_resume(dev);
 
@@ -829,7 +858,8 @@ static int device_resume_early(struct de
 	if (!dev->power.is_late_suspended)
 		goto Out;
 
-	dpm_wait_for_superior(dev, async);
+	if (!dpm_wait_for_superior(dev, async))
+		goto Out;
 
 	callback = dpm_subsys_resume_early_cb(dev, state, &info);
 
@@ -949,7 +979,9 @@ static int device_resume(struct device *
 		goto Complete;
 	}
 
-	dpm_wait_for_superior(dev, async);
+	if (!dpm_wait_for_superior(dev, async))
+		goto Complete;
+
 	dpm_watchdog_set(&wd, dev);
 	device_lock(dev);
 


