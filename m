Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427FA3B6A9E
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235890AbhF1WAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 18:00:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:2809 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233976AbhF1WAe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 18:00:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10029"; a="205033799"
X-IronPort-AV: E=Sophos;i="5.83,306,1616482800"; 
   d="scan'208";a="205033799"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2021 14:58:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,306,1616482800"; 
   d="scan'208";a="419328113"
Received: from spandruv-desk.jf.intel.com ([10.54.75.21])
  by fmsmga007.fm.intel.com with ESMTP; 28 Jun 2021 14:58:06 -0700
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     daniel.lezcano@linaro.org, rui.zhang@intel.com, amitk@kernel.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        stable@vger.kernel.org
Subject: [UPDATE][PATCH] thermal: int340x: processor_thermal: Fix tcc setting
Date:   Mon, 28 Jun 2021 14:58:03 -0700
Message-Id: <20210628215803.75038-1-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following fixes are done for tcc sysfs interface:
- TCC is 6 bits only from bit 29-24
- TCC of 0 is valid
- When BIT(31) is set, this register is read only
- Check for invalid tcc value
- Error for negative values

Fixes: fdf4f2fb8e899 ("drivers: thermal: processor_thermal_device:
Export sysfs interface for TCC offset"
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org
---
Update
	Added Fixes tag and cc to stable

 .../processor_thermal_device.c                | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
index de4fc640deb0..0f0038af2ad4 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -78,24 +78,27 @@ static ssize_t tcc_offset_degree_celsius_show(struct device *dev,
 	if (err)
 		return err;
 
-	val = (val >> 24) & 0xff;
+	val = (val >> 24) & 0x3f;
 	return sprintf(buf, "%d\n", (int)val);
 }
 
-static int tcc_offset_update(int tcc)
+static int tcc_offset_update(unsigned int tcc)
 {
 	u64 val;
 	int err;
 
-	if (!tcc)
+	if (tcc > 63)
 		return -EINVAL;
 
 	err = rdmsrl_safe(MSR_IA32_TEMPERATURE_TARGET, &val);
 	if (err)
 		return err;
 
-	val &= ~GENMASK_ULL(31, 24);
-	val |= (tcc & 0xff) << 24;
+	if (val & BIT(31))
+		return -EPERM;
+
+	val &= ~GENMASK_ULL(29, 24);
+	val |= (tcc & 0x3f) << 24;
 
 	err = wrmsrl_safe(MSR_IA32_TEMPERATURE_TARGET, val);
 	if (err)
@@ -104,14 +107,15 @@ static int tcc_offset_update(int tcc)
 	return 0;
 }
 
-static int tcc_offset_save;
+static unsigned int tcc_offset_save;
 
 static ssize_t tcc_offset_degree_celsius_store(struct device *dev,
 				struct device_attribute *attr, const char *buf,
 				size_t count)
 {
+	unsigned int tcc;
 	u64 val;
-	int tcc, err;
+	int err;
 
 	err = rdmsrl_safe(MSR_PLATFORM_INFO, &val);
 	if (err)
@@ -120,7 +124,7 @@ static ssize_t tcc_offset_degree_celsius_store(struct device *dev,
 	if (!(val & BIT(30)))
 		return -EACCES;
 
-	if (kstrtoint(buf, 0, &tcc))
+	if (kstrtouint(buf, 0, &tcc))
 		return -EINVAL;
 
 	err = tcc_offset_update(tcc);
-- 
2.27.0

