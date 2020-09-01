Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4815B259CBE
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgIAPNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728407AbgIAPNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:13:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B71C52078B;
        Tue,  1 Sep 2020 15:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973217;
        bh=0kmkTFNsK2Lv9fGs/6hQNxiybJYvll7aL8HJRkNe6bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpcolHkkLeXwPTYZB/HPURagD9II191c3sk8EoQDrACr9akDyYNT4h21MND2kTWDg
         CS5kcSStRLpXJi4JhFxKRi5rP+0IuiRDed5aeXBeEa3KtunssWLBU8/MQNdd7MNgVi
         /9caic6eQQayroI9lzVO3kH7RdPlkRKWjVYsngTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Utkarsh H Patel <utkarsh.h.patel@intel.com>,
        Pengfei Xu <pengfei.xu@intel.com>
Subject: [PATCH 4.4 52/62] PM: sleep: core: Fix the handling of pending runtime resume requests
Date:   Tue,  1 Sep 2020 17:10:35 +0200
Message-Id: <20200901150923.330917902@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit e3eb6e8fba65094328b8dca635d00de74ba75b45 upstream.

It has been reported that system-wide suspend may be aborted in the
absence of any wakeup events due to unforseen interactions of it with
the runtume PM framework.

One failing scenario is when there are multiple devices sharing an
ACPI power resource and runtime-resume needs to be carried out for
one of them during system-wide suspend (for example, because it needs
to be reconfigured before the whole system goes to sleep).  In that
case, the runtime-resume of that device involves turning the ACPI
power resource "on" which in turn causes runtime-resume requests
to be queued up for all of the other devices sharing it.  Those
requests go to the runtime PM workqueue which is frozen during
system-wide suspend, so they are not actually taken care of until
the resume of the whole system, but the pm_runtime_barrier()
call in __device_suspend() sees them and triggers system wakeup
events for them which then cause the system-wide suspend to be
aborted if wakeup source objects are in active use.

Of course, the logic that leads to triggering those wakeup events is
questionable in the first place, because clearly there are cases in
which a pending runtime resume request for a device is not connected
to any real wakeup events in any way (like the one above).  Moreover,
it is racy, because the device may be resuming already by the time
the pm_runtime_barrier() runs and so if the driver doesn't take care
of signaling the wakeup event as appropriate, it will be lost.
However, if the driver does take care of that, the extra
pm_wakeup_event() call in the core is redundant.

Accordingly, drop the conditional pm_wakeup_event() call fron
__device_suspend() and make the latter call pm_runtime_barrier()
alone.  Also modify the comment next to that call to reflect the new
code and extend it to mention the need to avoid unwanted interactions
between runtime PM and system-wide device suspend callbacks.

Fixes: 1e2ef05bb8cf8 ("PM: Limit race conditions between runtime PM and system sleep (v2)")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Utkarsh H Patel <utkarsh.h.patel@intel.com>
Tested-by: Utkarsh H Patel <utkarsh.h.patel@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/main.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1361,13 +1361,17 @@ static int __device_suspend(struct devic
 	}
 
 	/*
-	 * If a device configured to wake up the system from sleep states
-	 * has been suspended at run time and there's a resume request pending
-	 * for it, this is equivalent to the device signaling wakeup, so the
-	 * system suspend operation should be aborted.
+	 * Wait for possible runtime PM transitions of the device in progress
+	 * to complete and if there's a runtime resume request pending for it,
+	 * resume it before proceeding with invoking the system-wide suspend
+	 * callbacks for it.
+	 *
+	 * If the system-wide suspend callbacks below change the configuration
+	 * of the device, they must disable runtime PM for it or otherwise
+	 * ensure that its runtime-resume callbacks will not be confused by that
+	 * change in case they are invoked going forward.
 	 */
-	if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
-		pm_wakeup_event(dev, 0);
+	pm_runtime_barrier(dev);
 
 	if (pm_wakeup_pending()) {
 		dev->power.direct_complete = false;


