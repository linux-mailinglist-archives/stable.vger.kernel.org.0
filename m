Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D1C1F2FA8
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgFIAwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728544AbgFHXKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:10:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1B0B20890;
        Mon,  8 Jun 2020 23:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657800;
        bh=qViuOa0tFAuzGHOi+ZLjbhAYpuI3NFwXYEk9AAsSz0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxaUUpDQg643gAXaoUjAc1CCjtsgK0pdbMl3LQFc5bzIw/LCW6p3DIXScdXn8r1+Y
         yJSqSaFYKuXjfGGUoBpT7P4jys9CmlToOxrW0ilgTHkjalpYrWtnFGhcCudU2QZ7GX
         JFGI+mh2wfcFCOfY8QPXId/td/gId2NHOjk5e23k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mario Limonciello <Mario.limonciello@dell.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 178/274] platform/x86: intel-vbtn: Also handle tablet-mode switch on "Detachable" and "Portable" chassis-types
Date:   Mon,  8 Jun 2020 19:04:31 -0400
Message-Id: <20200608230607.3361041-178-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 1fac39fd0316b19c3e57a182524332332d1643ce ]

Commit de9647efeaa9 ("platform/x86: intel-vbtn: Only activate tablet mode
switch on 2-in-1's") added a DMI chassis-type check to avoid accidentally
reporting SW_TABLET_MODE = 1 to userspace on laptops.

Some devices with a detachable keyboard and using the intel-vbnt (INT33D6)
interface to report if they are in tablet mode (keyboard detached) or not,
report 32 / "Detachable" as chassis-type, e.g. the HP Pavilion X2 series.

Other devices with a detachable keyboard and using the intel-vbnt (INT33D6)
interface to report SW_TABLET_MODE, report 8 / "Portable" as chassis-type.
The Dell Venue 11 Pro 7130 is an example of this.

Extend the DMI chassis-type check to also accept Portables and Detachables
so that the intel-vbtn driver will report SW_TABLET_MODE on these devices.

Note the chassis-type check was originally added to avoid a false-positive
tablet-mode report on the Dell XPS 9360 laptop. To the best of my knowledge
that laptop is using a chassis-type of 9 / "Laptop", so after this commit
we still ignore the tablet-switch for that chassis-type.

Fixes: de9647efeaa9 ("platform/x86: intel-vbtn: Only activate tablet mode switch on 2-in-1's")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Mario Limonciello <Mario.limonciello@dell.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-vbtn.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
index 500fae82e12c..4921fc15dc6c 100644
--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -158,12 +158,22 @@ static void detect_tablet_mode(struct platform_device *device)
 static bool intel_vbtn_has_switches(acpi_handle handle)
 {
 	const char *chassis_type = dmi_get_system_info(DMI_CHASSIS_TYPE);
+	unsigned long chassis_type_int;
 	unsigned long long vgbs;
 	acpi_status status;
 
-	if (!(chassis_type && strcmp(chassis_type, "31") == 0))
+	if (kstrtoul(chassis_type, 10, &chassis_type_int))
 		return false;
 
+	switch (chassis_type_int) {
+	case  8: /* Portable */
+	case 31: /* Convertible */
+	case 32: /* Detachable */
+		break;
+	default:
+		return false;
+	}
+
 	status = acpi_evaluate_integer(handle, "VGBS", NULL, &vgbs);
 	return ACPI_SUCCESS(status);
 }
-- 
2.25.1

