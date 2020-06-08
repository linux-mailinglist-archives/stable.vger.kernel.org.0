Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8CE1F290A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387395AbgFHXWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgFHXWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:22:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7C4120842;
        Mon,  8 Jun 2020 23:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658543;
        bh=95mQw3pyXUqcksGZvoa25uW50dFOr48wkL6V9bdfdcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSYZdoezPHMYGC58IPpjw2UJuQ0vN2PDkxWKByxWlONJWr9uFJ7CqDLP31a1tGhYc
         ggtx++nKulclbK6bUZV5ZD36rfzFzNxsPrXhJ+WzAH62jsi5pAsJbYQGRAF9nIYHel
         IcpD6ewq8IiVGnBeHswZr5J264QacG8Az+PpaW10=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Mario Limonciello <Mario.limonciello@dell.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 165/175] platform/x86: intel-vbtn: Only blacklist SW_TABLET_MODE on the 9 / "Laptop" chasis-type
Date:   Mon,  8 Jun 2020 19:18:38 -0400
Message-Id: <20200608231848.3366970-165-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
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
index 5acfa08b5dac..cb2a80fdd8f4 100644
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

