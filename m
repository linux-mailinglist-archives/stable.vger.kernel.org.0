Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1A64196073
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 22:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbgC0Vdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 17:33:46 -0400
Received: from mga06.intel.com ([134.134.136.31]:35671 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727707AbgC0Vdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 17:33:45 -0400
IronPort-SDR: WA8aq6lQRrHdQd4qMpCpeflMOPOEurCX/VBGRZoZUjl9054NP/kcoQMIikNKK00Ew2U2KR1OtV
 tPfxeV2AIZUw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 14:33:44 -0700
IronPort-SDR: GWBxbGZ4a2SnP5jVDcNJzPcCIzrD84ngJLqG6GFcUOrDFNHk2xfblK2gEETZBr+aJhJFtYCwfA
 MaK66qRkGc6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,313,1580803200"; 
   d="scan'208";a="358607255"
Received: from gayuk-dev-mach.sc.intel.com ([10.3.79.171])
  by fmsmga001.fm.intel.com with ESMTP; 27 Mar 2020 14:33:45 -0700
From:   Gayatri Kammela <gayatri.kammela@intel.com>
To:     linux-pm@vger.kernel.org
Cc:     platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org, dvhart@infradead.org, alex.hung@canonical.com,
        rui.zhang@intel.com, daniel.lezcano@linaro.org,
        amit.kucheria@verdurent.com, mika.westerberg@intel.com,
        peterz@infradead.org, charles.d.prestopine@intel.com,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        "5 . 6+" <stable@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v2 1/3] ACPI: fix: Update Tiger Lake ACPI device IDs
Date:   Fri, 27 Mar 2020 14:28:19 -0700
Message-Id: <9359b8e261d69983b1eed2b8e53ef9eabfdfdd51.1585343507.git.gayatri.kammela@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585343507.git.gayatri.kammela@intel.com>
References: <cover.1585343507.git.gayatri.kammela@intel.com>
In-Reply-To: <cover.1585343507.git.gayatri.kammela@intel.com>
References: <cover.1585343507.git.gayatri.kammela@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tiger Lake's new unique ACPI device IDs for DPTF and fan drivers are not
valid as the IDs are missing 'C'. Fix the IDs by updating them.

After the update, the new IDs should now look like
INT1047 --> INTC1047
INT1040 --> INTC1040
INT1043 --> INTC1043
INT1044 --> INTC1044

Fixes: 55cfe6a5c582 ("ACPI: DPTF: Add Tiger Lake ACPI device IDs")
Fixes: c248dfe7e0ca ("ACPI: fan: Add Tiger Lake ACPI device ID")
Cc: 5.6+ <stable@vger.kernel.org> # 5.6+
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Suggested-by: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
---
 drivers/acpi/device_pm.c            | 2 +-
 drivers/acpi/dptf/dptf_power.c      | 2 +-
 drivers/acpi/dptf/int340x_thermal.c | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index b64c62bfcea5..80dae3b3c36a 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -1321,7 +1321,7 @@ int acpi_dev_pm_attach(struct device *dev, bool power_on)
 	 */
 	static const struct acpi_device_id special_pm_ids[] = {
 		{"PNP0C0B", }, /* Generic ACPI fan */
-		{"INT1044", }, /* Fan for Tiger Lake generation */
+		{"INTC1044", }, /* Fan for Tiger Lake generation */
 		{"INT3404", }, /* Fan */
 		{}
 	};
diff --git a/drivers/acpi/dptf/dptf_power.c b/drivers/acpi/dptf/dptf_power.c
index 387f27ef3368..e5fb34bfa52c 100644
--- a/drivers/acpi/dptf/dptf_power.c
+++ b/drivers/acpi/dptf/dptf_power.c
@@ -97,7 +97,7 @@ static int dptf_power_remove(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id int3407_device_ids[] = {
-	{"INT1047", 0},
+	{"INTC1047", 0},
 	{"INT3407", 0},
 	{"", 0},
 };
diff --git a/drivers/acpi/dptf/int340x_thermal.c b/drivers/acpi/dptf/int340x_thermal.c
index 1ec7b6900662..29b5c77256dd 100644
--- a/drivers/acpi/dptf/int340x_thermal.c
+++ b/drivers/acpi/dptf/int340x_thermal.c
@@ -13,10 +13,10 @@
 
 #define INT3401_DEVICE 0X01
 static const struct acpi_device_id int340x_thermal_device_ids[] = {
-	{"INT1040"},
-	{"INT1043"},
-	{"INT1044"},
-	{"INT1047"},
+	{"INTC1040"},
+	{"INTC1043"},
+	{"INTC1044"},
+	{"INTC1047"},
 	{"INT3400"},
 	{"INT3401", INT3401_DEVICE},
 	{"INT3402"},
-- 
2.17.1

