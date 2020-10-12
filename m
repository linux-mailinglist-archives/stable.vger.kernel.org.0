Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA97128B7CC
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389808AbgJLNp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389763AbgJLNpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69A0F22384;
        Mon, 12 Oct 2020 13:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510333;
        bh=4aPEhGyrdVhOMVP6qI7L5JKr0ha/U9Ksaf60ul+AzNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjAlGmiCUCs1TKHpkuUMYYKiaH4dTtcwoQqLblxNrz8x6QpbpqKsf4oQnFVd1KLmO
         xT+3PETjJyvBZay3Ty0iHs4tYKd9vO9x3YPeqCAv/P4g/I6h1ipH4VM02YT6NHaKFX
         JB81FFHmuaNUnVTCW2LJh+HstAUAlXKrnAveMlyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.8 024/124] platform/x86: intel-vbtn: Switch to an allow-list for SW_TABLET_MODE reporting
Date:   Mon, 12 Oct 2020 15:30:28 +0200
Message-Id: <20201012133148.016428231@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 8169bd3e6e193497cab781acddcff8fde5d0c416 upstream.

2 recent commits:
cfae58ed681c ("platform/x86: intel-vbtn: Only blacklist SW_TABLET_MODE
on the 9 / "Laptop" chasis-type")
1fac39fd0316 ("platform/x86: intel-vbtn: Also handle tablet-mode switch on
"Detachable" and "Portable" chassis-types")

Enabled reporting of SW_TABLET_MODE on more devices since the vbtn ACPI
interface is used by the firmware on some of those devices to report this.

Testing has shown that unconditionally enabling SW_TABLET_MODE reporting
on all devices with a chassis type of 8 ("Portable") or 10 ("Notebook")
which support the VGBS method is a very bad idea.

Many of these devices are normal laptops (non 2-in-1) models with a VGBS
which always returns 0, which we translate to SW_TABLET_MODE=1. This in
turn causes userspace (libinput) to suppress events from the builtin
keyboard and touchpad, making the laptop essentially unusable.

Since the problem of wrongly reporting SW_TABLET_MODE=1 in combination
with libinput, leads to a non-usable system. Where as OTOH many people will
not even notice when SW_TABLET_MODE is not being reported, this commit
changes intel_vbtn_has_switches() to use a DMI based allow-list.

The new DMI based allow-list matches on the 31 ("Convertible") and
32 ("Detachable") chassis-types, as these clearly are 2-in-1s and
so far if they support the intel-vbtn ACPI interface they all have
properly working SW_TABLET_MODE reporting.

Besides these 2 generic matches, it also contains model specific matches
for 2-in-1 models which use a different chassis-type and which are known
to have properly working SW_TABLET_MODE reporting.

This has been tested on the following 2-in-1 devices:

Dell Venue 11 Pro 7130 vPro
HP Pavilion X2 10-p002nd
HP Stream x360 Convertible PC 11
Medion E1239T

Fixes: cfae58ed681c ("platform/x86: intel-vbtn: Only blacklist SW_TABLET_MODE on the 9 / "Laptop" chasis-type")
BugLink: https://forum.manjaro.org/t/keyboard-and-touchpad-only-work-on-kernel-5-6/22668
BugLink: https://bugzilla.opensuse.org/show_bug.cgi?id=1175599
Cc: Barnabás Pőcze <pobrn@protonmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/intel-vbtn.c |   52 +++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 9 deletions(-)

--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -171,20 +171,54 @@ static bool intel_vbtn_has_buttons(acpi_
 	return ACPI_SUCCESS(status);
 }
 
+/*
+ * There are several laptops (non 2-in-1) models out there which support VGBS,
+ * but simply always return 0, which we translate to SW_TABLET_MODE=1. This in
+ * turn causes userspace (libinput) to suppress events from the builtin
+ * keyboard and touchpad, making the laptop essentially unusable.
+ *
+ * Since the problem of wrongly reporting SW_TABLET_MODE=1 in combination
+ * with libinput, leads to a non-usable system. Where as OTOH many people will
+ * not even notice when SW_TABLET_MODE is not being reported, a DMI based allow
+ * list is used here. This list mainly matches on the chassis-type of 2-in-1s.
+ *
+ * There are also some 2-in-1s which use the intel-vbtn ACPI interface to report
+ * SW_TABLET_MODE with a chassis-type of 8 ("Portable") or 10 ("Notebook"),
+ * these are matched on a per model basis, since many normal laptops with a
+ * possible broken VGBS ACPI-method also use these chassis-types.
+ */
+static const struct dmi_system_id dmi_switches_allow_list[] = {
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_CHASSIS_TYPE, "31" /* Convertible */),
+		},
+	},
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_CHASSIS_TYPE, "32" /* Detachable */),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Venue 11 Pro 7130"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Stream x360 Convertible PC 11"),
+		},
+	},
+	{} /* Array terminator */
+};
+
 static bool intel_vbtn_has_switches(acpi_handle handle)
 {
-	const char *chassis_type = dmi_get_system_info(DMI_CHASSIS_TYPE);
 	unsigned long long vgbs;
 	acpi_status status;
 
-	/*
-	 * Some normal laptops have a VGBS method despite being non-convertible
-	 * and their VGBS method always returns 0, causing detect_tablet_mode()
-	 * to report SW_TABLET_MODE=1 to userspace, which causes issues.
-	 * These laptops have a DMI chassis_type of 9 ("Laptop"), do not report
-	 * switches on any devices with a DMI chassis_type of 9.
-	 */
-	if (chassis_type && strcmp(chassis_type, "9") == 0)
+	if (!dmi_check_system(dmi_switches_allow_list))
 		return false;
 
 	status = acpi_evaluate_integer(handle, "VGBS", NULL, &vgbs);


