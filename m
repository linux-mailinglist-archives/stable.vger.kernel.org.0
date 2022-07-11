Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FFB56FBCC
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbiGKJdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiGKJcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:32:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BB17822A;
        Mon, 11 Jul 2022 02:17:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 774B1B80E74;
        Mon, 11 Jul 2022 09:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4747C341CE;
        Mon, 11 Jul 2022 09:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531050;
        bh=YVnFkwa8Y6Ua+2s8C/87eVG7a1hYAbDX9XzAqUxF8pU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKpre+DunpdAOKlOFGvQ+Mm3GmoyY+9EwTJYDXmd3jvUduZQtB7GYLuAYsQet8jN7
         3aluaxs5hDFKcdJZXzDTSxXMR1n9afjjyZpKSy5GAFydcatjFEhXo4dBGlo29+/s3L
         7QMiqQy8M65zT0zYuYKfV9WGKL4lZ7N8ZT0LC46Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Wang <peter.wang@mediatek.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.18 038/112] PM: runtime: Fix supplier device management during consumer probe
Date:   Mon, 11 Jul 2022 11:06:38 +0200
Message-Id: <20220711090550.653474614@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 887371066039011144b4a94af97d9328df6869a2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c          |   10 ++++++++++
 drivers/base/power/runtime.c |   14 +-------------
 2 files changed, 11 insertions(+), 13 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -486,6 +486,16 @@ static void device_link_release_fn(struc
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
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1737,7 +1737,6 @@ void pm_runtime_get_suppliers(struct dev
 		if (link->flags & DL_FLAG_PM_RUNTIME) {
 			link->supplier_preactivated = true;
 			pm_runtime_get_sync(link->supplier);
-			refcount_inc(&link->rpm_active);
 		}
 
 	device_links_read_unlock(idx);
@@ -1757,19 +1756,8 @@ void pm_runtime_put_suppliers(struct dev
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


