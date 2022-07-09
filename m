Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81ED956C7F4
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 10:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiGIIV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jul 2022 04:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGIIV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jul 2022 04:21:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4794677480
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 01:21:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D682960EB4
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 08:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD75BC3411C;
        Sat,  9 Jul 2022 08:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657354885;
        bh=xdySjptKgXNRemeFWXlzVf+DDzUuDgGQJsY98Mkj6UY=;
        h=Subject:To:Cc:From:Date:From;
        b=bUWd+MS1y7z/NSYBPF2W597I6/WLVO3trJQrbFtg1mVDuoyM20VqVLSvf9jj7rBbm
         5cQZ8bXsaKK4bKEvAToylqbGAe1O4hJnN69Codkb+yjmvEJmEIt+5EVeu3QPEl7LGM
         Qj5+Dm30G+H3ky3/T0XI0H2AKeF3vlCZ+cxXj76M=
Subject: FAILED: patch "[PATCH] PM: runtime: Redefine pm_runtime_release_supplier()" failed to apply to 5.4-stable tree
To:     rafael.j.wysocki@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 09 Jul 2022 10:21:22 +0200
Message-ID: <1657354882158179@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 07358194badf73e267289b40b761f5dc56928eab Mon Sep 17 00:00:00 2001
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Mon, 27 Jun 2022 20:42:18 +0200
Subject: [PATCH] PM: runtime: Redefine pm_runtime_release_supplier()

Instead of passing an extra bool argument to pm_runtime_release_supplier(),
make its callers take care of triggering a runtime-suspend of the
supplier device as needed.

No expected functional impact.

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: 5.1+ <stable@vger.kernel.org> # 5.1+

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 7cd789c4985d..58aa49527d3a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -486,7 +486,8 @@ static void device_link_release_fn(struct work_struct *work)
 	/* Ensure that all references to the link object have been dropped. */
 	device_link_synchronize_removal();
 
-	pm_runtime_release_supplier(link, true);
+	pm_runtime_release_supplier(link);
+	pm_request_idle(link->supplier);
 
 	put_device(link->consumer);
 	put_device(link->supplier);
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 676dc72d912d..23cc4c377d77 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -308,13 +308,10 @@ static int rpm_get_suppliers(struct device *dev)
 /**
  * pm_runtime_release_supplier - Drop references to device link's supplier.
  * @link: Target device link.
- * @check_idle: Whether or not to check if the supplier device is idle.
  *
- * Drop all runtime PM references associated with @link to its supplier device
- * and if @check_idle is set, check if that device is idle (and so it can be
- * suspended).
+ * Drop all runtime PM references associated with @link to its supplier device.
  */
-void pm_runtime_release_supplier(struct device_link *link, bool check_idle)
+void pm_runtime_release_supplier(struct device_link *link)
 {
 	struct device *supplier = link->supplier;
 
@@ -327,9 +324,6 @@ void pm_runtime_release_supplier(struct device_link *link, bool check_idle)
 	while (refcount_dec_not_one(&link->rpm_active) &&
 	       atomic_read(&supplier->power.usage_count) > 0)
 		pm_runtime_put_noidle(supplier);
-
-	if (check_idle)
-		pm_request_idle(supplier);
 }
 
 static void __rpm_put_suppliers(struct device *dev, bool try_to_suspend)
@@ -337,8 +331,11 @@ static void __rpm_put_suppliers(struct device *dev, bool try_to_suspend)
 	struct device_link *link;
 
 	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
-				device_links_read_lock_held())
-		pm_runtime_release_supplier(link, try_to_suspend);
+				device_links_read_lock_held()) {
+		pm_runtime_release_supplier(link);
+		if (try_to_suspend)
+			pm_request_idle(link->supplier);
+	}
 }
 
 static void rpm_put_suppliers(struct device *dev)
@@ -1838,7 +1835,8 @@ void pm_runtime_drop_link(struct device_link *link)
 		return;
 
 	pm_runtime_drop_link_count(link->consumer);
-	pm_runtime_release_supplier(link, true);
+	pm_runtime_release_supplier(link);
+	pm_request_idle(link->supplier);
 }
 
 static bool pm_runtime_need_not_resume(struct device *dev)
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index 9e4d056967c6..0a41b2dcccad 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -88,7 +88,7 @@ extern void pm_runtime_get_suppliers(struct device *dev);
 extern void pm_runtime_put_suppliers(struct device *dev);
 extern void pm_runtime_new_link(struct device *dev);
 extern void pm_runtime_drop_link(struct device_link *link);
-extern void pm_runtime_release_supplier(struct device_link *link, bool check_idle);
+extern void pm_runtime_release_supplier(struct device_link *link);
 
 extern int devm_pm_runtime_enable(struct device *dev);
 
@@ -314,8 +314,7 @@ static inline void pm_runtime_get_suppliers(struct device *dev) {}
 static inline void pm_runtime_put_suppliers(struct device *dev) {}
 static inline void pm_runtime_new_link(struct device *dev) {}
 static inline void pm_runtime_drop_link(struct device_link *link) {}
-static inline void pm_runtime_release_supplier(struct device_link *link,
-					       bool check_idle) {}
+static inline void pm_runtime_release_supplier(struct device_link *link) {}
 
 #endif /* !CONFIG_PM */
 

