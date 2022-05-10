Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D6B5223CB
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 20:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243917AbiEJSYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 14:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243132AbiEJSYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 14:24:47 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCD11D502A
        for <stable@vger.kernel.org>; Tue, 10 May 2022 11:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652206848; x=1683742848;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sSmQP3uhDLR96PsowzYCDVSU0HDCkoGesSibvvpbnN8=;
  b=QIU+fZ2C8JqPsoIVhics+QgHdHbkhVOy1c+IOmiXSqH4KvvvuHR9g34d
   RiOKnzDophmEdo8pUviOtOAbMAcNCCoM7uou4ecQ55sklgESfCmDK5S/n
   E5TSdtO1bgIt2CIp6PNVenZ1Z+w1WT5rymSKx8NBqHu8sQpUh0+qK7GCY
   Vdm43X0au4rI/TUXXVLzp456NI0RKlqjCeTB7x9BkVmONQSNXDy/aRPSu
   3RMqyLEpnFjgSx88jNXp3cUODVvqpnTcKaNiAEmQ+DM2bGwV5kcggmSCZ
   yMqIqfuaK0+moTjfHo+ESuY67HtXQ7hCPs6I2XVgbXj6k0iGrE6dXDDIV
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="257002182"
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="257002182"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 11:20:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="894993289"
Received: from spandruv-desk.jf.intel.com ([10.54.75.8])
  by fmsmga005.fm.intel.com with ESMTP; 10 May 2022 11:20:47 -0700
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     srinivas.pandruvada@linux.intel.com
Cc:     stable@vger.kernel.org
Subject: [UPDATE][PATCH] thermal: int340x: Mode setting with new OS handshake
Date:   Tue, 10 May 2022 11:20:44 -0700
Message-Id: <20220510182044.3990160-1-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With the new OS handshake introduced with the commit: "c7ff29763989
("thermal: int340x: Update OS policy capability handshake")",
thermal zone mode "enabled" doesn't work in the same way as the legacy
handshake. The mode "enabled" fails with -EINVAL using new handshake.

To address this issue, when the new OS UUID mask is set:
- When mode is "enabled", return 0 as the firmware already has the
latest policy mask.
- When mode is "disabled", update the firmware with UUID mask of zero.
In this way firmware can take control of the thermal control. Also
reset the OS UUID mask. This allows user space to update with new
set of policies.

Fixes: c7ff29763989 ("thermal: int340x: Update OS policy capability handshake")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org
---
update:
Added Fixes tag

 .../intel/int340x_thermal/int3400_thermal.c   | 48 ++++++++++++-------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index d97f496bab9b..1061728ad5a9 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -194,12 +194,31 @@ static int int3400_thermal_run_osc(acpi_handle handle, char *uuid_str, int *enab
 	return result;
 }
 
+static int set_os_uuid_mask(struct int3400_thermal_priv *priv, u32 mask)
+{
+	int cap = 0;
+
+	/*
+	 * Capability bits:
+	 * Bit 0: set to 1 to indicate DPTF is active
+	 * Bi1 1: set to 1 to active cooling is supported by user space daemon
+	 * Bit 2: set to 1 to passive cooling is supported by user space daemon
+	 * Bit 3: set to 1 to critical trip is handled by user space daemon
+	 */
+	if (mask)
+		cap = ((priv->os_uuid_mask << 1) | 0x01);
+
+	return int3400_thermal_run_osc(priv->adev->handle,
+				       "b23ba85d-c8b7-3542-88de-8de2ffcfd698",
+				       &cap);
+}
+
 static ssize_t current_uuid_store(struct device *dev,
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
 {
 	struct int3400_thermal_priv *priv = dev_get_drvdata(dev);
-	int i;
+	int ret, i;
 
 	for (i = 0; i < INT3400_THERMAL_MAXIMUM_UUID; ++i) {
 		if (!strncmp(buf, int3400_thermal_uuids[i],
@@ -231,19 +250,7 @@ static ssize_t current_uuid_store(struct device *dev,
 	}
 
 	if (priv->os_uuid_mask) {
-		int cap, ret;
-
-		/*
-		 * Capability bits:
-		 * Bit 0: set to 1 to indicate DPTF is active
-		 * Bi1 1: set to 1 to active cooling is supported by user space daemon
-		 * Bit 2: set to 1 to passive cooling is supported by user space daemon
-		 * Bit 3: set to 1 to critical trip is handled by user space daemon
-		 */
-		cap = ((priv->os_uuid_mask << 1) | 0x01);
-		ret = int3400_thermal_run_osc(priv->adev->handle,
-					      "b23ba85d-c8b7-3542-88de-8de2ffcfd698",
-					      &cap);
+		ret = set_os_uuid_mask(priv, priv->os_uuid_mask);
 		if (ret)
 			return ret;
 	}
@@ -469,17 +476,26 @@ static int int3400_thermal_change_mode(struct thermal_zone_device *thermal,
 	if (mode != thermal->mode) {
 		int enabled;
 
+		enabled = (mode == THERMAL_DEVICE_ENABLED);
+
+		if (priv->os_uuid_mask) {
+			if (!enabled) {
+				priv->os_uuid_mask = 0;
+				result = set_os_uuid_mask(priv, priv->os_uuid_mask);
+			}
+			goto eval_odvp;
+		}
+
 		if (priv->current_uuid_index < 0 ||
 		    priv->current_uuid_index >= INT3400_THERMAL_MAXIMUM_UUID)
 			return -EINVAL;
 
-		enabled = (mode == THERMAL_DEVICE_ENABLED);
 		result = int3400_thermal_run_osc(priv->adev->handle,
 						 int3400_thermal_uuids[priv->current_uuid_index],
 						 &enabled);
 	}
 
-
+eval_odvp:
 	evaluate_odvp(priv);
 
 	return result;
-- 
2.31.1

