Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B78F11014A3
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbfKSFgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:36:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729417AbfKSFgE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:36:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72F58206EC;
        Tue, 19 Nov 2019 05:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141762;
        bh=iPEPDvHbozR84hkIztkr8rhaoWmU3zId6OhRs5uz0Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Brf+wRM7GmuwyxQwhuTFw9VnjeiiK8sscUhu4/e9WpI/Q0/S921vbbmfg7GG9qcRV
         m8qaNDhw5SckNDEpSrbA0JS6++Phm1c3lmJqj7h2DygBUWYwpSbC679HTqxCeSezd4
         EBp/DTTFKfMGvFsxlNTQGhZBd4C/VxCnlfvKXgx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 232/422] ACPI / LPSS: Exclude I2C busses shared with PUNIT from pmc_atom_d3_mask
Date:   Tue, 19 Nov 2019 06:17:09 +0100
Message-Id: <20191119051414.117333838@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



