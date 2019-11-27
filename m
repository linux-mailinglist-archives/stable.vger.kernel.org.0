Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC0210BFBE
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfK0Ud5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:33:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbfK0Ud5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:33:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99EF1207DD;
        Wed, 27 Nov 2019 20:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886836;
        bh=/ZRotHjey/YKP0r1aSt4Hx6GoatAfbEulyBQrcaXrGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iY9vmViSrHMFB9hsAxDbBQc0ESgAN+zcFbuePfXxbRgPHzrh6KiirlUrtzpFnSXql
         6x+tICiizB2UH90ZKubu8zLg5oVxUfZkYvQSANzsGGtKiLdFlUU5or79PHUpcskQut
         wN9pvLQHTFaETrjq+/7zsZNnNUG0nQQ3+27a17t8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <linux@rempel-privat.de>,
        Alex Henrie <alexhenrie24@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 012/132] platform/x86: asus-wmi: Filter buggy scan codes on ASUS Q500A
Date:   Wed, 27 Nov 2019 21:30:03 +0100
Message-Id: <20191127202909.678527786@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <linux@rempel-privat.de>

[ Upstream commit b5643539b82559b858b8efe3fc8343f66cf9a0b5 ]

Some revisions of the ASUS Q500A series have a keyboard related
issue which is reproducible only after Windows with installed ASUS
tools is started.

In this case the Linux side will have a blocked keyboard or
report incorrect or incomplete hotkey events.

To make Linux work properly again, a complete power down
(unplug power supply and remove battery) is needed.

Linux/atkbd after a clean start will get the following code on VOLUME_UP
key: {0xe0, 0x30, 0xe0, 0xb0}. After Windows, the same key will generate
this codes: {0xe1, 0x23, 0xe0, 0x30, 0xe0, 0xb0}. As result atkdb will
be confused by buggy codes.

This patch is filtering this buggy code out.

https://bugzilla.kernel.org/show_bug.cgi?id=119391

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
Cc: Alex Henrie <alexhenrie24@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>
Cc: acpi4asus-user@lists.sourceforge.net
Cc: platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

[dvhart: Add return after pr_warn to avoid false confirmation of filter]

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 45 ++++++++++++++++++++++++++++++
 drivers/platform/x86/asus-wmi.h    |  4 +++
 2 files changed, 49 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 734f95c09508f..904e28d4db528 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -27,6 +27,7 @@
 #include <linux/input/sparse-keymap.h>
 #include <linux/fb.h>
 #include <linux/dmi.h>
+#include <linux/i8042.h>
 
 #include "asus-wmi.h"
 
@@ -55,10 +56,34 @@ MODULE_PARM_DESC(wapf, "WAPF value");
 
 static struct quirk_entry *quirks;
 
+static bool asus_q500a_i8042_filter(unsigned char data, unsigned char str,
+			      struct serio *port)
+{
+	static bool extended;
+	bool ret = false;
+
+	if (str & I8042_STR_AUXDATA)
+		return false;
+
+	if (unlikely(data == 0xe1)) {
+		extended = true;
+		ret = true;
+	} else if (unlikely(extended)) {
+		extended = false;
+		ret = true;
+	}
+
+	return ret;
+}
+
 static struct quirk_entry quirk_asus_unknown = {
 	.wapf = 0,
 };
 
+static struct quirk_entry quirk_asus_q500a = {
+	.i8042_filter = asus_q500a_i8042_filter,
+};
+
 /*
  * For those machines that need software to control bt/wifi status
  * and can't adjust brightness through ACPI interface
@@ -94,6 +119,15 @@ static int dmi_matched(const struct dmi_system_id *dmi)
 }
 
 static const struct dmi_system_id asus_quirks[] = {
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. Q500A",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Q500A"),
+		},
+		.driver_data = &quirk_asus_q500a,
+	},
 	{
 		.callback = dmi_matched,
 		.ident = "ASUSTeK COMPUTER INC. U32U",
@@ -365,6 +399,8 @@ static const struct dmi_system_id asus_quirks[] = {
 
 static void asus_nb_wmi_quirks(struct asus_wmi_driver *driver)
 {
+	int ret;
+
 	quirks = &quirk_asus_unknown;
 	dmi_check_system(asus_quirks);
 
@@ -376,6 +412,15 @@ static void asus_nb_wmi_quirks(struct asus_wmi_driver *driver)
 		quirks->wapf = wapf;
 	else
 		wapf = quirks->wapf;
+
+	if (quirks->i8042_filter) {
+		ret = i8042_install_filter(quirks->i8042_filter);
+		if (ret) {
+			pr_warn("Unable to install key filter\n");
+			return;
+		}
+		pr_info("Using i8042 filter function for receiving events\n");
+	}
 }
 
 static const struct key_entry asus_nb_wmi_keymap[] = {
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index 5de1df510ebd8..dd2e6cc0f3d48 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -28,6 +28,7 @@
 #define _ASUS_WMI_H_
 
 #include <linux/platform_device.h>
+#include <linux/i8042.h>
 
 #define ASUS_WMI_KEY_IGNORE (-1)
 #define ASUS_WMI_BRN_DOWN	0x20
@@ -51,6 +52,9 @@ struct quirk_entry {
 	 * and let the ACPI interrupt to send out the key event.
 	 */
 	int no_display_toggle;
+
+	bool (*i8042_filter)(unsigned char data, unsigned char str,
+			     struct serio *serio);
 };
 
 struct asus_wmi_driver {
-- 
2.20.1



