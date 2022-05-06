Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A8551D77C
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 14:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391801AbiEFMZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 08:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391785AbiEFMYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 08:24:50 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E4869288;
        Fri,  6 May 2022 05:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651839662; x=1683375662;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bNlWVZBGsCe3HZ1F4wDWDUdYtwtvMD+wGTDxUy08Iwk=;
  b=Iu3RYfugvajJf+KuJcM0m+VGqgxKmUMbT7UonF7LYMNcXSesODqUZVSM
   oE2ZXGXFR/GiHEM67NTXpgTrPtrZ3N0O+a8DLTBVKGZKnvX+81vNY354X
   eonwKIgLydwnzXfybKZcs6pm42Xx9hp5vPI85k5h2I/1iQIzRBcurvRTR
   efXgkIXASvBhjKwALMH2+oSR7241vHNMAbApg1GQwgW8VGDnv5a53GDf5
   OfrPM7NNq3aT59TqvkG5qA0DyGGCt8sug6QQTIedXMn2d7qvLA+B+bgkz
   YuKsypd9QncplQkQeLUmYz5GOwBRJOIYWRI+2DsmHzrR/lbekpM7UPiFG
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="267290929"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="267290929"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 05:21:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="891816225"
Received: from spandruv-desk.jf.intel.com ([10.54.75.8])
  by fmsmga005.fm.intel.com with ESMTP; 06 May 2022 05:21:01 -0700
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     rafael@kernel.org, daniel.lezcano@linaro.org, amitk@kernel.org,
        rui.zhang@intel.com
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] thermal: int340x: Mode setting with new OS handshake
Date:   Fri,  6 May 2022 05:20:52 -0700
Message-Id: <20220506122052.659129-1-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
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

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org
---
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

