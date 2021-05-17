Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1073831D8
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239861AbhEQOl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240886AbhEQOjU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:39:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0F2961935;
        Mon, 17 May 2021 14:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261100;
        bh=bL8ChzVeQkW6b0eLm0zdaTKfl/1CCGxbzYAwhkpID0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1u5h3PLFGzf5y5FtZ/Chfhb5qQj+44Ir4O3kIWog8a7o6QIw0Bs1e3zLHnkb+uPBD
         SLmeBm669dFQwZukoxXA4gnznZI+s3fbAF7hRkiqR79JTQuZpzFnrqLYHORKO6q0l9
         T/dAb3S1RlL9S7mxhoD2Nlk/QZlwnwUtaYcJz+0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 005/141] PM: runtime: Fix unpaired parent child_count for force_resume
Date:   Mon, 17 May 2021 16:00:57 +0200
Message-Id: <20210517140242.943260142@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
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
@@ -1610,6 +1610,7 @@ void pm_runtime_init(struct device *dev)
 	dev->power.request_pending = false;
 	dev->power.request = RPM_REQ_NONE;
 	dev->power.deferred_resume = false;
+	dev->power.needs_force_resume = 0;
 	INIT_WORK(&dev->power.work, pm_runtime_work);
 
 	dev->power.timer_expires = 0;
@@ -1777,10 +1778,12 @@ int pm_runtime_force_suspend(struct devi
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
 
@@ -1807,7 +1810,7 @@ int pm_runtime_force_resume(struct devic
 	int (*callback)(struct device *);
 	int ret = 0;
 
-	if (!pm_runtime_status_suspended(dev) || pm_runtime_need_not_resume(dev))
+	if (!pm_runtime_status_suspended(dev) || !dev->power.needs_force_resume)
 		goto out;
 
 	/*
@@ -1826,6 +1829,7 @@ int pm_runtime_force_resume(struct devic
 
 	pm_runtime_mark_last_busy(dev);
 out:
+	dev->power.needs_force_resume = 0;
 	pm_runtime_enable(dev);
 	return ret;
 }
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -608,6 +608,7 @@ struct dev_pm_info {
 	unsigned int		idle_notification:1;
 	unsigned int		request_pending:1;
 	unsigned int		deferred_resume:1;
+	unsigned int		needs_force_resume:1;
 	unsigned int		runtime_auto:1;
 	bool			ignore_children:1;
 	unsigned int		no_callbacks:1;


