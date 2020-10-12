Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546E028B7D6
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389792AbgJLNp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389762AbgJLNpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4307322363;
        Mon, 12 Oct 2020 13:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510324;
        bh=/vEKOfBVAdSUXg7vpFiuvRc7ed89OPqetGKPyKNUaZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=etVBj3O2K4pHQGJCNM/W61NBYt9j8UrOXbHxJ3y4nMaqDmGIPTLYKVXG2OKSquzHK
         hVqfttYVQsABxMWRbvjRU42alx6YjercsxG3GYcCNelrf6rt8jeb7Dt2KrtfHPWI+6
         D7U7lUDTvBqWYJ6jtI21xpP74p+X5Hu5EgD3QTvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Samuel=20=C4=8Cavoj?= <samuel@cavoj.net>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.8 020/124] platform/x86: asus-wmi: Fix SW_TABLET_MODE always reporting 1 on many different models
Date:   Mon, 12 Oct 2020 15:30:24 +0200
Message-Id: <20201012133147.825899849@linuxfoundation.org>
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

commit 1797d588af15174d4a4e7159dac8c800538e4f8c upstream.

Commit b0dbd97de1f1 ("platform/x86: asus-wmi: Add support for
SW_TABLET_MODE") added support for reporting SW_TABLET_MODE using the
Asus 0x00120063 WMI-device-id to see if various transformer models were
docked into their keyboard-dock (SW_TABLET_MODE=0) or if they were
being used as a tablet.

The new SW_TABLET_MODE support (naively?) assumed that non Transformer
devices would either not support the 0x00120063 WMI-device-id at all,
or would NOT set ASUS_WMI_DSTS_PRESENCE_BIT in their reply when querying
the device-id.

Unfortunately this is not true and we have received many bug reports about
this change causing the asus-wmi driver to always report SW_TABLET_MODE=1
on non Transformer devices. This causes libinput to think that these are
360 degree hinges style 2-in-1s folded into tablet-mode. Making libinput
suppress keyboard and touchpad events from the builtin keyboard and
touchpad. So effectively this causes the keyboard and touchpad to not work
on many non Transformer Asus models.

This commit fixes this by using the existing DMI based quirk mechanism in
asus-nb-wmi.c to allow using the 0x00120063 device-id for reporting
SW_TABLET_MODE on Transformer models and ignoring it on all other models.

Fixes: b0dbd97de1f1 ("platform/x86: asus-wmi: Add support for SW_TABLET_MODE")
Link: https://patchwork.kernel.org/patch/11780901/
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=209011
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1876997
Reported-by: Samuel Čavoj <samuel@cavoj.net>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/asus-nb-wmi.c |   32 ++++++++++++++++++++++++++++++++
 drivers/platform/x86/asus-wmi.c    |   16 +++++++++-------
 drivers/platform/x86/asus-wmi.h    |    1 +
 3 files changed, 42 insertions(+), 7 deletions(-)

--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -120,6 +120,10 @@ static struct quirk_entry quirk_asus_ga5
 	.wmi_backlight_set_devstate = true,
 };
 
+static struct quirk_entry quirk_asus_use_kbd_dock_devid = {
+	.use_kbd_dock_devid = true,
+};
+
 static int dmi_matched(const struct dmi_system_id *dmi)
 {
 	pr_info("Identified laptop model '%s'\n", dmi->ident);
@@ -493,6 +497,34 @@ static const struct dmi_system_id asus_q
 		},
 		.driver_data = &quirk_asus_ga502i,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Asus Transformer T100TA / T100HA / T100CHI",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			/* Match *T100* */
+			DMI_MATCH(DMI_PRODUCT_NAME, "T100"),
+		},
+		.driver_data = &quirk_asus_use_kbd_dock_devid,
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Asus Transformer T101HA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "T101HA"),
+		},
+		.driver_data = &quirk_asus_use_kbd_dock_devid,
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Asus Transformer T200TA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "T200TA"),
+		},
+		.driver_data = &quirk_asus_use_kbd_dock_devid,
+	},
 	{},
 };
 
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -365,12 +365,14 @@ static int asus_wmi_input_init(struct as
 	if (err)
 		goto err_free_dev;
 
-	result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_KBD_DOCK);
-	if (result >= 0) {
-		input_set_capability(asus->inputdev, EV_SW, SW_TABLET_MODE);
-		input_report_switch(asus->inputdev, SW_TABLET_MODE, !result);
-	} else if (result != -ENODEV) {
-		pr_err("Error checking for keyboard-dock: %d\n", result);
+	if (asus->driver->quirks->use_kbd_dock_devid) {
+		result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_KBD_DOCK);
+		if (result >= 0) {
+			input_set_capability(asus->inputdev, EV_SW, SW_TABLET_MODE);
+			input_report_switch(asus->inputdev, SW_TABLET_MODE, !result);
+		} else if (result != -ENODEV) {
+			pr_err("Error checking for keyboard-dock: %d\n", result);
+		}
 	}
 
 	err = input_register_device(asus->inputdev);
@@ -2114,7 +2116,7 @@ static void asus_wmi_handle_event_code(i
 		return;
 	}
 
-	if (code == NOTIFY_KBD_DOCK_CHANGE) {
+	if (asus->driver->quirks->use_kbd_dock_devid && code == NOTIFY_KBD_DOCK_CHANGE) {
 		result = asus_wmi_get_devstate_simple(asus,
 						      ASUS_WMI_DEVID_KBD_DOCK);
 		if (result >= 0) {
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -33,6 +33,7 @@ struct quirk_entry {
 	bool wmi_backlight_native;
 	bool wmi_backlight_set_devstate;
 	bool wmi_force_als_set;
+	bool use_kbd_dock_devid;
 	int wapf;
 	/*
 	 * For machines with AMD graphic chips, it will send out WMI event


