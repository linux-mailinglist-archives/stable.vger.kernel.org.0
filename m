Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F992E1752
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgLWDI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:08:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbgLWCSk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F06C233A1;
        Wed, 23 Dec 2020 02:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689853;
        bh=BnD4m4xKrpPxY9xWGHYxrs1RJ0e+d30Max0vGx1I3c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4yjS+RDn0eU3LadMcWu9OSBLkgfntaavoQSRXuN/WdGnJaXUPjUhA2B4C+1wd7i3
         8vTu22xfpTddx6vxYnKVCrppTUFG2lv1twc3RotTvyIyApIz+DIEr//3yNGiFG5WiC
         /Ft/FO9UWAYzPmgqzZcJ3cc2ESXBWaYr2AGXwB2ax8VWmUGszW1FyjyIJK4e+aIo2V
         j5NhdmvhLBsZuFM7JYUQG2LebGVdz/aznJ1pVwuZw7AaGUHBMHu+iepNz594qcAPzh
         Up51rEiI6gfl1OiMtk22+Pd7GKjiZoxJZniPgaKHnXJh216r5HLIMC+eY7jje9oyZ7
         oxb2mhFAOngjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 051/217] thermal: intel: pch: fix S0ix failure due to PCH temperature above threshold
Date:   Tue, 22 Dec 2020 21:13:40 -0500
Message-Id: <20201223021626.2790791-51-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>

[ Upstream commit ef63b043ac8645d2540d7b50dd3e09c53db3d504 ]

When system tries to enter S0ix suspend state, just after active load
scenarios, it fails due to PCH current temperature is higher than set
threshold.
This patch introduces delay loop mechanism that allows PCH temperature
to go down below threshold during suspend so it won't fail to enter S0ix.
Add delay loop timeout and count as module parameters for user to tune it,
if required based on system design. This change notifies the different
warning messages like when PCH temperature above the threshold and
executing delay loop. Also, notify the messages when it success or
failure for S0ix entry.
Previously out of 1000 runs around 3 to 5 times it might fail to enter
S0ix just after heavy workload. With this change, S0ix failures reduced
as PCH cools down below threshold.

Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20201106170633.20838-1-sumeet.r.pawnikar@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/intel_pch_thermal.c | 76 +++++++++++++++++++++--
 1 file changed, 70 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/intel/intel_pch_thermal.c b/drivers/thermal/intel/intel_pch_thermal.c
index 3b813ebb6ca1d..0a9e4458bc3a5 100644
--- a/drivers/thermal/intel/intel_pch_thermal.c
+++ b/drivers/thermal/intel/intel_pch_thermal.c
@@ -7,14 +7,16 @@
  *     Tushar Dave <tushar.n.dave@intel.com>
  */
 
+#include <linux/acpi.h>
+#include <linux/delay.h>
 #include <linux/module.h>
-#include <linux/types.h>
 #include <linux/init.h>
 #include <linux/pci.h>
-#include <linux/acpi.h>
+#include <linux/pm.h>
+#include <linux/suspend.h>
 #include <linux/thermal.h>
+#include <linux/types.h>
 #include <linux/units.h>
-#include <linux/pm.h>
 
 /* Intel PCH thermal Device IDs */
 #define PCH_THERMAL_DID_HSW_1	0x9C24 /* Haswell PCH */
@@ -35,6 +37,7 @@
 #define WPT_TSREL	0x0A	/* Thermal Sensor Report Enable and Lock */
 #define WPT_TSMIC	0x0C	/* Thermal Sensor SMI Control */
 #define WPT_CTT	0x0010	/* Catastrophic Trip Point */
+#define WPT_TSPM	0x001C	/* Thermal Sensor Power Management */
 #define WPT_TAHV	0x0014	/* Thermal Alert High Value */
 #define WPT_TALV	0x0018	/* Thermal Alert Low Value */
 #define WPT_TL		0x00000040	/* Throttle Value */
@@ -55,6 +58,22 @@
 #define WPT_TL_T1L	0x1ff00000	/* T1 Level */
 #define WPT_TL_TTEN	0x20000000	/* TT Enable */
 
+/* Resolution of 1/2 degree C and an offset of -50C */
+#define PCH_TEMP_OFFSET	(-50)
+#define GET_WPT_TEMP(x)	((x) * MILLIDEGREE_PER_DEGREE / 2 + WPT_TEMP_OFFSET)
+#define WPT_TEMP_OFFSET	(PCH_TEMP_OFFSET * MILLIDEGREE_PER_DEGREE)
+#define GET_PCH_TEMP(x)	(((x) / 2) + PCH_TEMP_OFFSET)
+
+/* Amount of time for each cooling delay, 100ms by default for now */
+static unsigned int delay_timeout = 100;
+module_param(delay_timeout, int, 0644);
+MODULE_PARM_DESC(delay_timeout, "amount of time delay for each iteration.");
+
+/* Number of iterations for cooling delay, 10 counts by default for now */
+static unsigned int delay_cnt = 10;
+module_param(delay_cnt, int, 0644);
+MODULE_PARM_DESC(delay_cnt, "total number of iterations for time delay.");
+
 static char driver_name[] = "Intel PCH thermal driver";
 
 struct pch_thermal_device {
@@ -183,13 +202,58 @@ static int pch_wpt_get_temp(struct pch_thermal_device *ptd, int *temp)
 static int pch_wpt_suspend(struct pch_thermal_device *ptd)
 {
 	u8 tsel;
+	u8 pch_delay_cnt = 1;
+	u16 pch_thr_temp, pch_cur_temp;
 
-	if (ptd->bios_enabled)
+	/* Shutdown the thermal sensor if it is not enabled by BIOS */
+	if (!ptd->bios_enabled) {
+		tsel = readb(ptd->hw_base + WPT_TSEL);
+		writeb(tsel & 0xFE, ptd->hw_base + WPT_TSEL);
+		return 0;
+	}
+
+	/* Do not check temperature if it is not a S0ix capable platform */
+	if (!(acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0))
 		return 0;
 
-	tsel = readb(ptd->hw_base + WPT_TSEL);
+	/* Do not check temperature if it is not s2idle */
+	if (pm_suspend_via_firmware())
+		return 0;
+
+	/* Get the PCH temperature threshold value */
+	pch_thr_temp = GET_PCH_TEMP(WPT_TEMP_TSR & readw(ptd->hw_base + WPT_TSPM));
+
+	/* Get the PCH current temperature value */
+	pch_cur_temp = GET_PCH_TEMP(WPT_TEMP_TSR & readw(ptd->hw_base + WPT_TEMP));
 
-	writeb(tsel & 0xFE, ptd->hw_base + WPT_TSEL);
+	/*
+	 * If current PCH temperature is higher than configured PCH threshold
+	 * value, run some delay loop with sleep to let the current temperature
+	 * go down below the threshold value which helps to allow system enter
+	 * lower power S0ix suspend state. Even after delay loop if PCH current
+	 * temperature stays above threshold, notify the warning message
+	 * which helps to indentify the reason why S0ix entry was rejected.
+	 */
+	while (pch_delay_cnt <= delay_cnt) {
+		if (pch_cur_temp <= pch_thr_temp)
+			break;
+
+		dev_warn(&ptd->pdev->dev,
+			"CPU-PCH current temp [%dC] higher than the threshold temp [%dC], sleep %d times for %d ms duration\n",
+			pch_cur_temp, pch_thr_temp, pch_delay_cnt, delay_timeout);
+		msleep(delay_timeout);
+		/* Read the PCH current temperature for next cycle. */
+		pch_cur_temp = GET_PCH_TEMP(WPT_TEMP_TSR & readw(ptd->hw_base + WPT_TEMP));
+		pch_delay_cnt++;
+	}
+
+	if (pch_cur_temp > pch_thr_temp)
+		dev_warn(&ptd->pdev->dev,
+			"CPU-PCH is hot [%dC] even after delay, continue to suspend. S0ix might fail\n",
+			pch_cur_temp);
+	else
+		dev_info(&ptd->pdev->dev,
+			"CPU-PCH is cool [%dC], continue to suspend\n", pch_cur_temp);
 
 	return 0;
 }
-- 
2.27.0

