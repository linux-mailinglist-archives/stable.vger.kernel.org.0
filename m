Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9AE22C9D3E
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389346AbgLAJUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:20:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:46298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389343AbgLAJIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:08:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3B7621D46;
        Tue,  1 Dec 2020 09:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813693;
        bh=+FkfsfP5YrhoJ+XdiRO7JNn+eNdNoUAaUE3R5Ue9FE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jv+ByPxS16noY61xr+dgGFzjUnGyNq3KRTzu5DNH/Nj6jSImHJ6dDi5FIb/SzGEXx
         UOqX3XQi6FMx1LZlL3F6SPLa16yZCLpTqPj6Oevm1m/KCxZwh9aH7WLZMR0y30sRRO
         g3MLo0MqRXffFlBt7UAm+xPzHtPTAdqUlaKa6mcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amit Sunil Dhamne <amit.sunil.dhamne@xilinx.com>,
        =?UTF-8?q?Arnd=20Bergmann=C2=A0?= <arnd@arndb.de>,
        Ravi Patel <ravi.patel@xilinx.com>,
        Rajan Vaja <rajan.vaja@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH 5.9 027/152] firmware: xilinx: Use hash-table for api feature check
Date:   Tue,  1 Dec 2020 09:52:22 +0100
Message-Id: <20201201084715.437318122@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Sunil Dhamne <amit.sunil.dhamne@xilinx.com>

commit acfdd18591eaac25446e976a0c0d190f8b3dbfb1 upstream.

Currently array of fix length PM_API_MAX is used to cache
the pm_api version (valid or invalid). However ATF based
PM APIs values are much higher then PM_API_MAX.
So to include ATF based PM APIs also, use hash-table to
store the pm_api version status.

Signed-off-by: Amit Sunil Dhamne <amit.sunil.dhamne@xilinx.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ravi Patel <ravi.patel@xilinx.com>
Signed-off-by: Rajan Vaja <rajan.vaja@xilinx.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Michal Simek <michal.simek@xilinx.com>
Fixes: f3217d6f2f7a ("firmware: xilinx: fix out-of-bounds access")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1606197161-25976-1-git-send-email-rajan.vaja@xilinx.com
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/xilinx/zynqmp.c     |   63 +++++++++++++++++++++++++++--------
 include/linux/firmware/xlnx-zynqmp.h |    4 --
 2 files changed, 49 insertions(+), 18 deletions(-)

--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -20,12 +20,28 @@
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/hashtable.h>
 
 #include <linux/firmware/xlnx-zynqmp.h>
 #include "zynqmp-debug.h"
 
+/* Max HashMap Order for PM API feature check (1<<7 = 128) */
+#define PM_API_FEATURE_CHECK_MAX_ORDER  7
+
 static bool feature_check_enabled;
-static u32 zynqmp_pm_features[PM_API_MAX];
+DEFINE_HASHTABLE(pm_api_features_map, PM_API_FEATURE_CHECK_MAX_ORDER);
+
+/**
+ * struct pm_api_feature_data - PM API Feature data
+ * @pm_api_id:		PM API Id, used as key to index into hashmap
+ * @feature_status:	status of PM API feature: valid, invalid
+ * @hentry:		hlist_node that hooks this entry into hashtable
+ */
+struct pm_api_feature_data {
+	u32 pm_api_id;
+	int feature_status;
+	struct hlist_node hentry;
+};
 
 static const struct mfd_cell firmware_devs[] = {
 	{
@@ -142,29 +158,37 @@ static int zynqmp_pm_feature(u32 api_id)
 	int ret;
 	u32 ret_payload[PAYLOAD_ARG_CNT];
 	u64 smc_arg[2];
+	struct pm_api_feature_data *feature_data;
 
 	if (!feature_check_enabled)
 		return 0;
 
-	/* Return value if feature is already checked */
-	if (api_id > ARRAY_SIZE(zynqmp_pm_features))
-		return PM_FEATURE_INVALID;
+	/* Check for existing entry in hash table for given api */
+	hash_for_each_possible(pm_api_features_map, feature_data, hentry,
+			       api_id) {
+		if (feature_data->pm_api_id == api_id)
+			return feature_data->feature_status;
+	}
 
-	if (zynqmp_pm_features[api_id] != PM_FEATURE_UNCHECKED)
-		return zynqmp_pm_features[api_id];
+	/* Add new entry if not present */
+	feature_data = kmalloc(sizeof(*feature_data), GFP_KERNEL);
+	if (!feature_data)
+		return -ENOMEM;
 
+	feature_data->pm_api_id = api_id;
 	smc_arg[0] = PM_SIP_SVC | PM_FEATURE_CHECK;
 	smc_arg[1] = api_id;
 
 	ret = do_fw_call(smc_arg[0], smc_arg[1], 0, ret_payload);
-	if (ret) {
-		zynqmp_pm_features[api_id] = PM_FEATURE_INVALID;
-		return PM_FEATURE_INVALID;
-	}
+	if (ret)
+		ret = -EOPNOTSUPP;
+	else
+		ret = ret_payload[1];
 
-	zynqmp_pm_features[api_id] = ret_payload[1];
+	feature_data->feature_status = ret;
+	hash_add(pm_api_features_map, &feature_data->hentry, api_id);
 
-	return zynqmp_pm_features[api_id];
+	return ret;
 }
 
 /**
@@ -200,9 +224,12 @@ int zynqmp_pm_invoke_fn(u32 pm_api_id, u
 	 * Make sure to stay in x0 register
 	 */
 	u64 smc_arg[4];
+	int ret;
 
-	if (zynqmp_pm_feature(pm_api_id) == PM_FEATURE_INVALID)
-		return -ENOTSUPP;
+	/* Check if feature is supported or not */
+	ret = zynqmp_pm_feature(pm_api_id);
+	if (ret < 0)
+		return ret;
 
 	smc_arg[0] = PM_SIP_SVC | pm_api_id;
 	smc_arg[1] = ((u64)arg1 << 32) | arg0;
@@ -1252,9 +1279,17 @@ static int zynqmp_firmware_probe(struct
 
 static int zynqmp_firmware_remove(struct platform_device *pdev)
 {
+	struct pm_api_feature_data *feature_data;
+	int i;
+
 	mfd_remove_devices(&pdev->dev);
 	zynqmp_pm_api_debugfs_exit();
 
+	hash_for_each(pm_api_features_map, i, feature_data, hentry) {
+		hash_del(&feature_data->hentry);
+		kfree(feature_data);
+	}
+
 	return 0;
 }
 
--- a/include/linux/firmware/xlnx-zynqmp.h
+++ b/include/linux/firmware/xlnx-zynqmp.h
@@ -50,10 +50,6 @@
 #define	ZYNQMP_PM_CAPABILITY_WAKEUP	0x4U
 #define	ZYNQMP_PM_CAPABILITY_UNUSABLE	0x8U
 
-/* Feature check status */
-#define PM_FEATURE_INVALID		-1
-#define PM_FEATURE_UNCHECKED		0
-
 /*
  * Firmware FPGA Manager flags
  * XILINX_ZYNQMP_PM_FPGA_FULL:	FPGA full reconfiguration


