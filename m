Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D4A1F2512
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731702AbgFHXY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:24:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731693AbgFHXY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:24:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68E042089D;
        Mon,  8 Jun 2020 23:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658695;
        bh=jmAKpld+lTOVjuEKHUlx8HpjpNQaUm30K9TiwyuX2OA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgxuCbuenZkG8sZjBDq5WZYiUlPMnTsVjoRW45/RmDbp7qDAw92LbwsaM6Mlw7zZH
         KsRnCiTj3gh5WnnUb7V1iu2rIh2Tk9k3IPd9y9G40JIChsZhWORM7m+haPJ3pdaxFO
         u8SWn2Zw/1g6ziXcZRhLdKUG7/3hHL3PRQ+f3BvE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Mario Limonciello <Mario.limonciello@dell.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 103/106] platform/x86: intel-vbtn: Only blacklist SW_TABLET_MODE on the 9 / "Laptop" chasis-type
Date:   Mon,  8 Jun 2020 19:22:35 -0400
Message-Id: <20200608232238.3368589-103-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232238.3368589-1-sashal@kernel.org>
References: <20200608232238.3368589-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit cfae58ed681c5fe0185db843013ecc71cd265ebf ]

The HP Stream x360 11-p000nd no longer report SW_TABLET_MODE state / events
with recent kernels. This model reports a chassis-type of 10 / "Notebook"
which is not on the recently introduced chassis-type whitelist

Commit de9647efeaa9 ("platform/x86: intel-vbtn: Only activate tablet mode
switch on 2-in-1's") added a chassis-type whitelist and only listed 31 /
"Convertible" as being capable of generating valid SW_TABLET_MOD events.

Commit 1fac39fd0316 ("platform/x86: intel-vbtn: Also handle tablet-mode
switch on "Detachable" and "Portable" chassis-types") extended the
whitelist with chassis-types 8 / "Portable" and 32 / "Detachable".

And now we need to exten the whitelist again with 10 / "Notebook"...

The issue original fixed by the whitelist is really a ACPI DSDT bug on
the Dell XPS 9360 where it has a VGBS which reports it is in tablet mode
even though it is not a 2-in-1 at all, but a regular laptop.

So since this is a workaround for a DSDT issue on that specific model,
instead of extending the whitelist over and over again, lets switch to
a blacklist and only blacklist the chassis-type of the model for which
the chassis-type check was added.

Note this also fixes the current version of the code no longer checking
if dmi_get_system_info(DMI_CHASSIS_TYPE) returns NULL.

Fixes: 1fac39fd0316 ("platform/x86: intel-vbtn: Also handle tablet-mode switch on "Detachable" and "Portable" chassis-types")
Cc: Mario Limonciello <mario.limonciello@dell.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Mario Limonciello <Mario.limonciello@dell.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-vbtn.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
index 5f8120d12859..d122f33d43ac 100644
--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -157,21 +157,18 @@ static void detect_tablet_mode(struct platform_device *device)
 static bool intel_vbtn_has_switches(acpi_handle handle)
 {
 	const char *chassis_type = dmi_get_system_info(DMI_CHASSIS_TYPE);
-	unsigned long chassis_type_int;
 	unsigned long long vgbs;
 	acpi_status status;
 
-	if (kstrtoul(chassis_type, 10, &chassis_type_int))
-		return false;
-
-	switch (chassis_type_int) {
-	case  8: /* Portable */
-	case 31: /* Convertible */
-	case 32: /* Detachable */
-		break;
-	default:
+	/*
+	 * Some normal laptops have a VGBS method despite being non-convertible
+	 * and their VGBS method always returns 0, causing detect_tablet_mode()
+	 * to report SW_TABLET_MODE=1 to userspace, which causes issues.
+	 * These laptops have a DMI chassis_type of 9 ("Laptop"), do not report
+	 * switches on any devices with a DMI chassis_type of 9.
+	 */
+	if (chassis_type && strcmp(chassis_type, "9") == 0)
 		return false;
-	}
 
 	status = acpi_evaluate_integer(handle, "VGBS", NULL, &vgbs);
 	return ACPI_SUCCESS(status);
-- 
2.25.1

