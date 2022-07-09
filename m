Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA78256C7F6
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 10:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiGIIWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jul 2022 04:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGIIWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jul 2022 04:22:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C4F77480
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 01:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28A41B818C8
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 08:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A68AC3411C;
        Sat,  9 Jul 2022 08:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657354947;
        bh=6oWJbfHlfnCN0mk5Yyz4qmY2ISAS1wkPHLAz6BZ5vvs=;
        h=Subject:To:Cc:From:Date:From;
        b=2mTBwCc/eoqg3iSN6LT6stEkaI8q6bc/6HiIkmBi7xdS3IiWaVfLW3dFKigG9Qt/4
         vsBsqPI4VJ5buzM0nB94esAhIAuzSJ8clM6n6ceoMQlotudqUvTVJKykL6IUFGA5/R
         mcookargo3bHJFfGj15wqBCn6L+RwS1krSflIHL4=
Subject: FAILED: patch "[PATCH] PM: runtime: Fix supplier device management during consumer" failed to apply to 5.15-stable tree
To:     rafael.j.wysocki@intel.com, gregkh@linuxfoundation.org,
        peter.wang@mediatek.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 09 Jul 2022 10:22:24 +0200
Message-ID: <1657354944582@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 887371066039011144b4a94af97d9328df6869a2 Mon Sep 17 00:00:00 2001
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Thu, 30 Jun 2022 21:16:41 +0200
Subject: [PATCH] PM: runtime: Fix supplier device management during consumer
 probe

Because pm_runtime_get_suppliers() bumps up the rpm_active counter
of each device link to a supplier of the given device in addition
to bumping up the supplier's PM-runtime usage counter, a runtime
suspend of the consumer device may case the latter to go down to 0
when pm_runtime_put_suppliers() is running on a remote CPU.  If that
happens after pm_runtime_put_suppliers() has released power.lock for
the consumer device, and a runtime resume of that device takes place
immediately after it, before pm_runtime_put() is called for the
supplier, that pm_runtime_put() call may cause the supplier to be
suspended even though the consumer is active.

To prevent that from happening, modify pm_runtime_get_suppliers() to
call pm_runtime_get_sync() for the given device's suppliers without
touching the rpm_active counters of the involved device links
Accordingly, modify pm_runtime_put_suppliers() to call pm_runtime_put()
for the given device's suppliers without looking at the rpm_active
counters of the device links at hand.  [This is analogous to what
happened before commit 4c06c4e6cf63 ("driver core: Fix possible
supplier PM-usage counter imbalance").]

Since pm_runtime_get_suppliers() sets supplier_preactivated for each
device link where the supplier's PM-runtime usage counter has been
incremented and pm_runtime_put_suppliers() calls pm_runtime_put() for
the suppliers whose device links have supplier_preactivated set, the
PM-runtime usage counter is balanced for each supplier and this is
independent of the runtime suspend and resume of the consumer device.

However, in case a device link with DL_FLAG_PM_RUNTIME set is dropped
during the consumer device probe, so pm_runtime_get_suppliers() bumps
up the supplier's PM-runtime usage counter, but it cannot be dropped by
pm_runtime_put_suppliers(), make device_link_release_fn() take care of
that.

Fixes: 4c06c4e6cf63 ("driver core: Fix possible supplier PM-usage counter imbalance")
Reported-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Cc: 5.1+ <stable@vger.kernel.org> # 5.1+

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 58aa49527d3a..460d6f163e41 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -487,6 +487,16 @@ static void device_link_release_fn(struct work_struct *work)
 	device_link_synchronize_removal();
 
 	pm_runtime_release_supplier(link);
+	/*
+	 * If supplier_preactivated is set, the link has been dropped between
+	 * the pm_runtime_get_suppliers() and pm_runtime_put_suppliers() calls
+	 * in __driver_probe_device().  In that case, drop the supplier's
+	 * PM-runtime usage counter to remove the reference taken by
+	 * pm_runtime_get_suppliers().
+	 */
+	if (link->supplier_preactivated)
+		pm_runtime_put_noidle(link->supplier);
+
 	pm_request_idle(link->supplier);
 
 	put_device(link->consumer);
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 23cc4c377d77..949907e2e242 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1768,7 +1768,6 @@ void pm_runtime_get_suppliers(struct device *dev)
 		if (link->flags & DL_FLAG_PM_RUNTIME) {
 			link->supplier_preactivated = true;
 			pm_runtime_get_sync(link->supplier);
-			refcount_inc(&link->rpm_active);
 		}
 
 	device_links_read_unlock(idx);
@@ -1788,19 +1787,8 @@ void pm_runtime_put_suppliers(struct device *dev)
 	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
 				device_links_read_lock_held())
 		if (link->supplier_preactivated) {
-			bool put;
-
 			link->supplier_preactivated = false;
-
-			spin_lock_irq(&dev->power.lock);
-
-			put = pm_runtime_status_suspended(dev) &&
-			      refcount_dec_not_one(&link->rpm_active);
-
-			spin_unlock_irq(&dev->power.lock);
-
-			if (put)
-				pm_runtime_put(link->supplier);
+			pm_runtime_put(link->supplier);
 		}
 
 	device_links_read_unlock(idx);

