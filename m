Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D8B56FD87
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbiGKJ45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbiGKJ4k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:56:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FE0B38E7;
        Mon, 11 Jul 2022 02:26:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E83EBB80E91;
        Mon, 11 Jul 2022 09:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBA6C34115;
        Mon, 11 Jul 2022 09:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531601;
        bh=NL2ogyRTiRWJHJiqmYU+cNarar9DcAoC2rgdkm966C0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z84AN8+/+SN57c3muZAe4S8srGHnl+93FwGxNj64YvY5h+r8U9nyKvnhJyjJAPajm
         ZiEhBSP5yfQsQuXhfPpG/2hrAK8oyR5lazXdQ+ix2S/nOsorwaAyeIlD/lqe3/o4lf
         5AABo+suCPdQE0W4sgaRWu9VrFSXetn2X6PkHuPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 163/230] PM: runtime: Redefine pm_runtime_release_supplier()
Date:   Mon, 11 Jul 2022 11:06:59 +0200
Message-Id: <20220711090608.686442021@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

commit 07358194badf73e267289b40b761f5dc56928eab upstream.

Instead of passing an extra bool argument to pm_runtime_release_supplier(),
make its callers take care of triggering a runtime-suspend of the
supplier device as needed.

No expected functional impact.

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: 5.1+ <stable@vger.kernel.org> # 5.1+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c          |    3 ++-
 drivers/base/power/runtime.c |   20 +++++++++-----------
 include/linux/pm_runtime.h   |    5 ++---
 3 files changed, 13 insertions(+), 15 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -485,7 +485,8 @@ static void device_link_release_fn(struc
 	/* Ensure that all references to the link object have been dropped. */
 	device_link_synchronize_removal();
 
-	pm_runtime_release_supplier(link, true);
+	pm_runtime_release_supplier(link);
+	pm_request_idle(link->supplier);
 
 	put_device(link->consumer);
 	put_device(link->supplier);
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -308,13 +308,10 @@ static int rpm_get_suppliers(struct devi
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
 
@@ -327,9 +324,6 @@ void pm_runtime_release_supplier(struct
 	while (refcount_dec_not_one(&link->rpm_active) &&
 	       atomic_read(&supplier->power.usage_count) > 0)
 		pm_runtime_put_noidle(supplier);
-
-	if (check_idle)
-		pm_request_idle(supplier);
 }
 
 static void __rpm_put_suppliers(struct device *dev, bool try_to_suspend)
@@ -337,8 +331,11 @@ static void __rpm_put_suppliers(struct d
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
@@ -1791,7 +1788,8 @@ void pm_runtime_drop_link(struct device_
 		return;
 
 	pm_runtime_drop_link_count(link->consumer);
-	pm_runtime_release_supplier(link, true);
+	pm_runtime_release_supplier(link);
+	pm_request_idle(link->supplier);
 }
 
 static bool pm_runtime_need_not_resume(struct device *dev)
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -58,7 +58,7 @@ extern void pm_runtime_get_suppliers(str
 extern void pm_runtime_put_suppliers(struct device *dev);
 extern void pm_runtime_new_link(struct device *dev);
 extern void pm_runtime_drop_link(struct device_link *link);
-extern void pm_runtime_release_supplier(struct device_link *link, bool check_idle);
+extern void pm_runtime_release_supplier(struct device_link *link);
 
 extern int devm_pm_runtime_enable(struct device *dev);
 
@@ -284,8 +284,7 @@ static inline void pm_runtime_get_suppli
 static inline void pm_runtime_put_suppliers(struct device *dev) {}
 static inline void pm_runtime_new_link(struct device *dev) {}
 static inline void pm_runtime_drop_link(struct device_link *link) {}
-static inline void pm_runtime_release_supplier(struct device_link *link,
-					       bool check_idle) {}
+static inline void pm_runtime_release_supplier(struct device_link *link) {}
 
 #endif /* !CONFIG_PM */
 


