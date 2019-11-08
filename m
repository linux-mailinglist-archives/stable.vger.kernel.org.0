Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A570F4956
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390249AbfKHLnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:43:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390256AbfKHLm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:42:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3C85222C6;
        Fri,  8 Nov 2019 11:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213378;
        bh=iPEPDvHbozR84hkIztkr8rhaoWmU3zId6OhRs5uz0Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0RfyYkSnEHLKSK+ZKn7WpLjWZjA6Q/YP+Jjm9x1tc2rUNwjDHy7/ZJSM/1dIKKAT
         B0rEqMyZLhuK1wmOhsjSYI73qBcQkzZ3Oz7MpoITX/KOPWyVYz6cxfGY0PmpoJ1O75
         jqZotgUQvVR5p9g9BEKugVQ0yXkR8a18pSXS1Iyo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 202/205] ACPI / LPSS: Exclude I2C busses shared with PUNIT from pmc_atom_d3_mask
Date:   Fri,  8 Nov 2019 06:37:49 -0500
Message-Id: <20191108113752.12502-202-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 86b62e5cd8965d3056f9e9ccdec51631c37add81 ]

lpss_iosf_enter_d3_state() checks if all hw-blocks using the DMA
controllers are in d3 before powering down the DMA controllers.

But on devices, where the I2C bus connected to the PMIC is shared by
the PUNIT, the controller for that bus will never reach d3 since it has
an effectively empty _PS3 method. Instead it appears to automatically
power-down during S0i3 and we never see it as being in d3.

This causes the DMA controllers to never be powered-down on these devices,
causing them to never reach S0i3. This commit uses the ACPI _SEM method
to detect if an I2C bus is shared with the PUNIT and if it is, it removes
it from the mask of devices which lpss_iosf_enter_d3_state() checks for.

This fixes these devices never reaching any S0ix states.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_lpss.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index c651e206d7960..7eda27d43b482 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -99,6 +99,9 @@ struct lpss_private_data {
 	u32 prv_reg_ctx[LPSS_PRV_REG_COUNT];
 };
 
+/* Devices which need to be in D3 before lpss_iosf_enter_d3_state() proceeds */
+static u32 pmc_atom_d3_mask = 0xfe000ffe;
+
 /* LPSS run time quirks */
 static unsigned int lpss_quirks;
 
@@ -175,6 +178,21 @@ static void byt_pwm_setup(struct lpss_private_data *pdata)
 
 static void byt_i2c_setup(struct lpss_private_data *pdata)
 {
+	const char *uid_str = acpi_device_uid(pdata->adev);
+	acpi_handle handle = pdata->adev->handle;
+	unsigned long long shared_host = 0;
+	acpi_status status;
+	long uid = 0;
+
+	/* Expected to always be true, but better safe then sorry */
+	if (uid_str)
+		uid = simple_strtol(uid_str, NULL, 10);
+
+	/* Detect I2C bus shared with PUNIT and ignore its d3 status */
+	status = acpi_evaluate_integer(handle, "_SEM", NULL, &shared_host);
+	if (ACPI_SUCCESS(status) && shared_host && uid)
+		pmc_atom_d3_mask &= ~(BIT_LPSS2_F1_I2C1 << (uid - 1));
+
 	lpss_deassert_reset(pdata);
 
 	if (readl(pdata->mmio_base + pdata->dev_desc->prv_offset))
@@ -894,7 +912,7 @@ static void lpss_iosf_enter_d3_state(void)
 	 * Here we read the values related to LPSS power island, i.e. LPSS
 	 * devices, excluding both LPSS DMA controllers, along with SCC domain.
 	 */
-	u32 func_dis, d3_sts_0, pmc_status, pmc_mask = 0xfe000ffe;
+	u32 func_dis, d3_sts_0, pmc_status;
 	int ret;
 
 	ret = pmc_atom_read(PMC_FUNC_DIS, &func_dis);
@@ -912,7 +930,7 @@ static void lpss_iosf_enter_d3_state(void)
 	 * Shutdown both LPSS DMA controllers if and only if all other devices
 	 * are already in D3hot.
 	 */
-	pmc_status = (~(d3_sts_0 | func_dis)) & pmc_mask;
+	pmc_status = (~(d3_sts_0 | func_dis)) & pmc_atom_d3_mask;
 	if (pmc_status)
 		goto exit;
 
-- 
2.20.1

