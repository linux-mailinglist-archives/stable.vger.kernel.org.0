Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0E414E24B
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730973AbgA3SpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:45:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730967AbgA3SpL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:45:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 115BA205F4;
        Thu, 30 Jan 2020 18:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409910;
        bh=we9Q9vZM3fRN0P7XpVa4W3a77BMdSXDk9LtUjGvXW74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pF/V70vV7Z8xfL5jGCMGsXRJhzlyzAWLlAwZCRwZp47nXiCvE1RSg/02iq25YiPAH
         ZMBiUHT+3HwTxHaxKI5uNKePESpY72Sc/woJGiKTYz8f/9UbQy96PJpGnxaoTIB6xV
         WqTHRNfJoCk9bcCvFHWTp3ML/eh73qmh/QHTlVyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pacien TRAN-GIRARD <pacien.trangirard@pacien.net>,
        Mario Limonciello <mario.limonciello@dell.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/110] platform/x86: dell-laptop: disable kbd backlight on Inspiron 10xx
Date:   Thu, 30 Jan 2020 19:38:56 +0100
Message-Id: <20200130183623.712199808@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pacien TRAN-GIRARD <pacien.trangirard@pacien.net>

[ Upstream commit 10b65e2915b2fcc606d173e98a972850101fb4c4 ]

This patch adds a quirk disabling keyboard backlight support for the
Dell Inspiron 1012 and 1018.

Those models wrongly report supporting keyboard backlight control
features (through SMBIOS tokens) even though they're not equipped with
a backlit keyboard. This led to broken controls being exposed
through sysfs by this driver which froze the system when used.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=107651
Signed-off-by: Pacien TRAN-GIRARD <pacien.trangirard@pacien.net>
Reviewed-by: Mario Limonciello <mario.limonciello@dell.com>
Reviewed-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell-laptop.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index d27be2836bc21..74e988f839e85 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -33,6 +33,7 @@
 
 struct quirk_entry {
 	bool touchpad_led;
+	bool kbd_led_not_present;
 	bool kbd_led_levels_off_1;
 	bool kbd_missing_ac_tag;
 
@@ -73,6 +74,10 @@ static struct quirk_entry quirk_dell_latitude_e6410 = {
 	.kbd_led_levels_off_1 = true,
 };
 
+static struct quirk_entry quirk_dell_inspiron_1012 = {
+	.kbd_led_not_present = true,
+};
+
 static struct platform_driver platform_driver = {
 	.driver = {
 		.name = "dell-laptop",
@@ -310,6 +315,24 @@ static const struct dmi_system_id dell_quirks[] __initconst = {
 		},
 		.driver_data = &quirk_dell_latitude_e6410,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Dell Inspiron 1012",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1012"),
+		},
+		.driver_data = &quirk_dell_inspiron_1012,
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Dell Inspiron 1018",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1018"),
+		},
+		.driver_data = &quirk_dell_inspiron_1012,
+	},
 	{ }
 };
 
@@ -1493,6 +1516,9 @@ static void kbd_init(void)
 {
 	int ret;
 
+	if (quirks && quirks->kbd_led_not_present)
+		return;
+
 	ret = kbd_init_info();
 	kbd_init_tokens();
 
-- 
2.20.1



