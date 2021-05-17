Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE0A38308A
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239342AbhEQO2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:28:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238624AbhEQO0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:26:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C3A561350;
        Mon, 17 May 2021 14:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260808;
        bh=PeEuDQ1RPr0AL0urufJWxpvRE4VsKXS8HuL0uvj1oms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLFMh7w14Cf6pD7pbv5YLzm02o8UXZ+KBaoLWK/EScycjDE/TthBwnOtHFo0n6IBB
         9aZv2bhA2f4R9sGfuxpT6pUwoUg1JTxwMVRJTudK964f15UoDllAy1QPZbcduxR5Gg
         9O3QBirSYEsSjbXRfyH2749J9qcH+uTrcr1LXgLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.11 009/329] PM: runtime: Fix unpaired parent child_count for force_resume
Date:   Mon, 17 May 2021 15:58:40 +0200
Message-Id: <20210517140302.358557966@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit c745253e2a691a40c66790defe85c104a887e14a upstream.

As pm_runtime_need_not_resume() relies also on usage_count, it can return
a different value in pm_runtime_force_suspend() compared to when called in
pm_runtime_force_resume(). Different return values can happen if anything
calls PM runtime functions in between, and causes the parent child_count
to increase on every resume.

So far I've seen the issue only for omapdrm that does complicated things
with PM runtime calls during system suspend for legacy reasons:

omap_atomic_commit_tail() for omapdrm.0
 dispc_runtime_get()
  wakes up 58000000.dss as it's the dispc parent
   dispc_runtime_resume()
    rpm_resume() increases parent child_count
 dispc_runtime_put() won't idle, PM runtime suspend blocked
pm_runtime_force_suspend() for 58000000.dss, !pm_runtime_need_not_resume()
 __update_runtime_status()
system suspended
pm_runtime_force_resume() for 58000000.dss, pm_runtime_need_not_resume()
 pm_runtime_enable() only called because of pm_runtime_need_not_resume()
omap_atomic_commit_tail() for omapdrm.0
 dispc_runtime_get()
  wakes up 58000000.dss as it's the dispc parent
   dispc_runtime_resume()
    rpm_resume() increases parent child_count
 dispc_runtime_put() won't idle, PM runtime suspend blocked
...
rpm_suspend for 58000000.dss but parent child_count is now unbalanced

Let's fix the issue by adding a flag for needs_force_resume and use it in
pm_runtime_force_resume() instead of pm_runtime_need_not_resume().

Additionally omapdrm system suspend could be simplified later on to avoid
lots of unnecessary PM runtime calls and the complexity it adds. The
driver can just use internal functions that are shared between the PM
runtime and system suspend related functions.

Fixes: 4918e1f87c5f ("PM / runtime: Rework pm_runtime_force_suspend/resume()")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Cc: 4.16+ <stable@vger.kernel.org> # 4.16+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/runtime.c |   10 +++++++---
 include/linux/pm.h           |    1 +
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1637,6 +1637,7 @@ void pm_runtime_init(struct device *dev)
 	dev->power.request_pending = false;
 	dev->power.request = RPM_REQ_NONE;
 	dev->power.deferred_resume = false;
+	dev->power.needs_force_resume = 0;
 	INIT_WORK(&dev->power.work, pm_runtime_work);
 
 	dev->power.timer_expires = 0;
@@ -1804,10 +1805,12 @@ int pm_runtime_force_suspend(struct devi
 	 * its parent, but set its status to RPM_SUSPENDED anyway in case this
 	 * function will be called again for it in the meantime.
 	 */
-	if (pm_runtime_need_not_resume(dev))
+	if (pm_runtime_need_not_resume(dev)) {
 		pm_runtime_set_suspended(dev);
-	else
+	} else {
 		__update_runtime_status(dev, RPM_SUSPENDED);
+		dev->power.needs_force_resume = 1;
+	}
 
 	return 0;
 
@@ -1834,7 +1837,7 @@ int pm_runtime_force_resume(struct devic
 	int (*callback)(struct device *);
 	int ret = 0;
 
-	if (!pm_runtime_status_suspended(dev) || pm_runtime_need_not_resume(dev))
+	if (!pm_runtime_status_suspended(dev) || !dev->power.needs_force_resume)
 		goto out;
 
 	/*
@@ -1853,6 +1856,7 @@ int pm_runtime_force_resume(struct devic
 
 	pm_runtime_mark_last_busy(dev);
 out:
+	dev->power.needs_force_resume = 0;
 	pm_runtime_enable(dev);
 	return ret;
 }
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -600,6 +600,7 @@ struct dev_pm_info {
 	unsigned int		idle_notification:1;
 	unsigned int		request_pending:1;
 	unsigned int		deferred_resume:1;
+	unsigned int		needs_force_resume:1;
 	unsigned int		runtime_auto:1;
 	bool			ignore_children:1;
 	unsigned int		no_callbacks:1;


