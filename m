Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C2F28B6FB
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731367AbgJLNjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731242AbgJLNio (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:38:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28D3B22202;
        Mon, 12 Oct 2020 13:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509907;
        bh=tLxdMqLT8QxChfXR/jy3a00D2pfMQ+Y54lQM1YFDLNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SA5GclmvY6ohCPKEU9603vXFbAs18JfYfpkMGHZ1dpjQQ/OwhutzGFwKUyqHhupVQ
         HTl7njNUnE+h4YOgbMf3J8N+okC2BavJbOO2UDawcxrAJKTellbLdwF71X+LIHZB7r
         lMlLmFmkv9FKvoaLeC9u1+g0Sof1E47ysPv3kd5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.19 10/49] platform/x86: intel-vbtn: Switch to an allow-list for SW_TABLET_MODE reporting
Date:   Mon, 12 Oct 2020 15:26:56 +0200
Message-Id: <20201012132629.912609892@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.469542486@linuxfoundation.org>
References: <20201012132629.469542486@linuxfoundation.org>
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
@@ -158,20 +158,54 @@ static void detect_tablet_mode(struct pl
 	input_report_switch(priv->input_dev, SW_DOCK, m);
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


