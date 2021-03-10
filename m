Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7957C333E8E
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbhCJN0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233431AbhCJNZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3B1E6500C;
        Wed, 10 Mar 2021 13:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382735;
        bh=NiiI77OJxtbyNAUAzn7GDHJT+gADtBRhSw4GwwznSwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IdC09kw9FCNzsRry5tjGt0nMDbvsnHTWwt+TuN2FTk0sjNwIsAaRbC8NvYZlm2veA
         wfs1BUveYVqIAO8VwFZSWj/qEaptVTczgTWvt83HtiREFSFOCaqe3iGz0AVfNKdZ2X
         tsZ2NEwkZZqlhfTQXQUK5b98a07eIrPkeSOxWcTE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 6/7] platform/x86: acer-wmi: Add new force_caps module parameter
Date:   Wed, 10 Mar 2021 14:25:19 +0100
Message-Id: <20210310132319.389240094@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.155338551@linuxfoundation.org>
References: <20210310132319.155338551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 39aa009bb66f9d5fbd1e58ca4aa03d6e6f2c9915 ]

Add a new force_caps module parameter to allow overriding the drivers
builtin capability detection mechanism.

This can be used to for example:
-Disable rfkill functionality on devices where there is an AA OEM DMI
 record advertising non functional rfkill switches
-Force loading of the driver on devices with a missing AA OEM DMI record

Note that force_caps is -1 when unset, this allows forcing the
capability field to 0, which results in acer-wmi only providing WMI
hotkey handling while disabling all other (led, rfkill, backlight)
functionality.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20201019185628.264473-4-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index b336f2620f9d..e4f278fa6d69 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -229,6 +229,7 @@ static int mailled = -1;
 static int brightness = -1;
 static int threeg = -1;
 static int force_series;
+static int force_caps = -1;
 static bool ec_raw_mode;
 static bool has_type_aa;
 static u16 commun_func_bitmap;
@@ -238,11 +239,13 @@ module_param(mailled, int, 0444);
 module_param(brightness, int, 0444);
 module_param(threeg, int, 0444);
 module_param(force_series, int, 0444);
+module_param(force_caps, int, 0444);
 module_param(ec_raw_mode, bool, 0444);
 MODULE_PARM_DESC(mailled, "Set initial state of Mail LED");
 MODULE_PARM_DESC(brightness, "Set initial LCD backlight brightness");
 MODULE_PARM_DESC(threeg, "Set initial state of 3G hardware");
 MODULE_PARM_DESC(force_series, "Force a different laptop series");
+MODULE_PARM_DESC(force_caps, "Force the capability bitmask to this value");
 MODULE_PARM_DESC(ec_raw_mode, "Enable EC raw mode");
 
 struct acer_data {
@@ -2150,7 +2153,7 @@ static int __init acer_wmi_init(void)
 		}
 		/* WMID always provides brightness methods */
 		interface->capability |= ACER_CAP_BRIGHTNESS;
-	} else if (!wmi_has_guid(WMID_GUID2) && interface && !has_type_aa) {
+	} else if (!wmi_has_guid(WMID_GUID2) && interface && !has_type_aa && force_caps == -1) {
 		pr_err("No WMID device detection method found\n");
 		return -ENODEV;
 	}
@@ -2180,6 +2183,9 @@ static int __init acer_wmi_init(void)
 	if (acpi_video_get_backlight_type() != acpi_backlight_vendor)
 		interface->capability &= ~ACER_CAP_BRIGHTNESS;
 
+	if (force_caps != -1)
+		interface->capability = force_caps;
+
 	if (wmi_has_guid(WMID_GUID3)) {
 		if (ec_raw_mode) {
 			if (ACPI_FAILURE(acer_wmi_enable_ec_raw())) {
-- 
2.30.1



