Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5C35F95C5
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiJJAZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbiJJAWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:22:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC84A1277B;
        Sun,  9 Oct 2022 16:56:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98120B80DDF;
        Sun,  9 Oct 2022 23:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E6EC43470;
        Sun,  9 Oct 2022 23:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359793;
        bh=pdGMhIrgUGiG/1VDSAW3lZe3G2hQ8vMxmf7VPvD8ZJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhRFxyEWdNDPGNxazXt3vlOuj/Mijv9cmnT0oetAxjP77L2Fsh2qKPSPaWoQkyU7f
         MQ8rX80isQihgByOTLFdb6i51NcdnjyMKhTvO7+yuMfS9lPz18GF0tVY1saHb3cU5I
         wMgNKXCZ5SND3YkAl6SZhq6PzFIzTUNJqLkrLG8d5spivcGxNFbQT/+4hX8Dsp80Th
         Z3E8ftOAtCcqfDANu/kGKRVOidg4JWlvcWbf5kF9cSBYkLm1ytLhr8HPuQRY1w9Ebm
         gWqd+y9ikhBv56U6mM1D6JWTKyZJcvxGMo2CDqnYckc4t7+REM7NzQmLPI5JvMZ4iV
         lKJPvvQUBFBMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Arvid Norlander <lkml@vorpal.se>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/22] ACPI: video: Change disable_backlight_sysfs_if quirks to acpi_backlight=native
Date:   Sun,  9 Oct 2022 19:55:29 -0400
Message-Id: <20221009235540.1231640-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235540.1231640-1-sashal@kernel.org>
References: <20221009235540.1231640-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c5b94f5b7819348c59f9949b2b75c341a114cdd4 ]

Some Toshibas have a broken acpi-video interface for brightness control
and need a special firmware call on resume to turn the panel back on.
So far these have been using the disable_backlight_sysfs_if workaround
to deal with this.

The recent x86/acpi backlight refactoring has broken this workaround:
1. This workaround relies on acpi_video_get_backlight_type() returning
   acpi_video so that the acpi_video code actually runs; and
2. this relies on the actual native GPU driver to offer the sysfs
   backlight interface to userspace.

After the refactor this breaks since the native driver will no
longer register its backlight-device if acpi_video_get_backlight_type()
does not return native and making it return native breaks 1.

Keeping the acpi_video backlight handling on resume active, while not
using it to set the brightness, is necessary because it does a _BCM
call on resume which is necessary to turn the panel back on on resume.

Looking at the DSDT shows that this _BCM call results in a Toshiba
HCI_SET HCI_LCD_BRIGHTNESS call, which turns the panel back on.

This kind of special vendor specific handling really belongs in
the vendor specific acpi driver. An earlier patch in this series
modifies toshiba_acpi to make the necessary HCI_SET call on resume
on affected models.

With toshiba_acpi taking care of the HCI_SET call on resume,
the acpi_video code no longer needs to call _BCM on resume.

So instead of using the (now broken) disable_backlight_sysfs_if
workaround, simply setting acpi_backlight=native to disable
the broken apci-video interface is sufficient fix things now.

After this there are no more users of the disable_backlight_sysfs_if
flag and as discussed above the flag also no longer works as intended,
so remove the disable_backlight_sysfs_if flag entirely.

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Arvid Norlander <lkml@vorpal.se>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_video.c   | 48 -------------------------------------
 drivers/acpi/video_detect.c | 35 +++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 48 deletions(-)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index eb04b2f828ee..befe7b66c3aa 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -50,9 +50,6 @@ module_param(brightness_switch_enabled, bool, 0644);
 static bool allow_duplicates;
 module_param(allow_duplicates, bool, 0644);
 
-static int disable_backlight_sysfs_if = -1;
-module_param(disable_backlight_sysfs_if, int, 0444);
-
 #define REPORT_OUTPUT_KEY_EVENTS		0x01
 #define REPORT_BRIGHTNESS_KEY_EVENTS		0x02
 static int report_key_events = -1;
@@ -384,14 +381,6 @@ static int video_set_bqc_offset(const struct dmi_system_id *d)
 	return 0;
 }
 
-static int video_disable_backlight_sysfs_if(
-	const struct dmi_system_id *d)
-{
-	if (disable_backlight_sysfs_if == -1)
-		disable_backlight_sysfs_if = 1;
-	return 0;
-}
-
 static int video_set_device_id_scheme(const struct dmi_system_id *d)
 {
 	device_id_scheme = true;
@@ -464,40 +453,6 @@ static const struct dmi_system_id video_dmi_table[] = {
 		},
 	},
 
-	/*
-	 * Some machines have a broken acpi-video interface for brightness
-	 * control, but still need an acpi_video_device_lcd_set_level() call
-	 * on resume to turn the backlight power on.  We Enable backlight
-	 * control on these systems, but do not register a backlight sysfs
-	 * as brightness control does not work.
-	 */
-	{
-	 /* https://bugzilla.kernel.org/show_bug.cgi?id=21012 */
-	 .callback = video_disable_backlight_sysfs_if,
-	 .ident = "Toshiba Portege R700",
-	 .matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE R700"),
-		},
-	},
-	{
-	 /* https://bugs.freedesktop.org/show_bug.cgi?id=82634 */
-	 .callback = video_disable_backlight_sysfs_if,
-	 .ident = "Toshiba Portege R830",
-	 .matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE R830"),
-		},
-	},
-	{
-	 /* https://bugzilla.kernel.org/show_bug.cgi?id=21012 */
-	 .callback = video_disable_backlight_sysfs_if,
-	 .ident = "Toshiba Satellite R830",
-	 .matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE R830"),
-		},
-	},
 	/*
 	 * Some machine's _DOD IDs don't have bit 31(Device ID Scheme) set
 	 * but the IDs actually follow the Device ID Scheme.
@@ -1764,9 +1719,6 @@ static void acpi_video_dev_register_backlight(struct acpi_video_device *device)
 	if (result)
 		return;
 
-	if (disable_backlight_sysfs_if > 0)
-		return;
-
 	name = kasprintf(GFP_KERNEL, "acpi_video%d", count);
 	if (!name)
 		return;
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index e39d59ad6496..3a27f2364159 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -500,6 +500,41 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_BOARD_NAME, "PF5LUXG"),
 		},
 	},
+	/*
+	 * These Toshibas have a broken acpi-video interface for brightness
+	 * control. They also have an issue where the panel is off after
+	 * suspend until a special firmware call is made to turn it back
+	 * on. This is handled by the toshiba_acpi kernel module, so that
+	 * module must be enabled for these models to work correctly.
+	 */
+	{
+	 /* https://bugzilla.kernel.org/show_bug.cgi?id=21012 */
+	 .callback = video_detect_force_native,
+	 /* Toshiba Portégé R700 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE R700"),
+		},
+	},
+	{
+	 /* Portégé: https://bugs.freedesktop.org/show_bug.cgi?id=82634 */
+	 /* Satellite: https://bugzilla.kernel.org/show_bug.cgi?id=21012 */
+	 .callback = video_detect_force_native,
+	 /* Toshiba Satellite/Portégé R830 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "R830"),
+		},
+	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Toshiba Satellite/Portégé Z830 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Z830"),
+		},
+	},
+
 	/*
 	 * Desktops which falsely report a backlight and which our heuristics
 	 * for this do not catch.
-- 
2.35.1

