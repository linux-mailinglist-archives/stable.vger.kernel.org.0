Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8E4310EE1
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 18:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbhBEP4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 10:56:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233386AbhBEPyh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:54:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41C5E6504C;
        Fri,  5 Feb 2021 14:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534335;
        bh=Erx14mbGkChC7+4iB61+/EZf131CLbBj9OQzFV2gYgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0sZ3ONCJM0Q6NDlgdqBcE2EHuLNYSYsZVJtwQu4Dab0EDUxqBtGyBXdz0Xim5HrwT
         2fpwe9bxMDm+tQ/6/AKbMbjc7ndKzVkI6+k+hib79ZC242Sdxzr9jyuaoqUkhC1Us4
         PWUSWwsYqYtJH3XbXtLo3+HHajORdVN1oOW/BAsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 15/32] platform/x86: touchscreen_dmi: Add swap-x-y quirk for Goodix touchscreen on Estar Beauty HD tablet
Date:   Fri,  5 Feb 2021 15:07:30 +0100
Message-Id: <20210205140652.990546266@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 46c54cf2706122c37497896d56d67b0c0aca2ede ]

The Estar Beauty HD (MID 7316R) tablet uses a Goodix touchscreen,
with the X and Y coordinates swapped compared to the LCD panel.

Add a touchscreen_dmi entry for this adding a "touchscreen-swapped-x-y"
device-property to the i2c-client instantiated for this device before
the driver binds.

This is the first entry of a Goodix touchscreen to touchscreen_dmi.c,
so far DMI quirks for Goodix touchscreen's have been added directly
to drivers/input/touchscreen/goodix.c. Currently there are 3
DMI tables in goodix.c:
1. rotated_screen[] for devices where the touchscreen is rotated
   180 degrees vs the LCD panel
2. inverted_x_screen[] for devices where the X axis is inverted
3. nine_bytes_report[] for devices which use a non standard touch
   report size

Arguably only 3. really needs to be inside the driver and the other
2 cases are better handled through the generic touchscreen DMI quirk
mechanism from touchscreen_dmi.c, which allows adding device-props to
any i2c-client. Esp. now that goodix.c is using the generic
touchscreen_properties code.

Alternative to the approach from this patch we could add a 4th
dmi_system_id table for devices with swapped-x-y axis to goodix.c,
but that seems undesirable.

Cc: Bastien Nocera <hadess@hadess.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20201224135158.10976-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 1e072dbba30d6..7ed1189a7200c 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -231,6 +231,16 @@ static const struct ts_dmi_data digma_citi_e200_data = {
 	.properties	= digma_citi_e200_props,
 };
 
+static const struct property_entry estar_beauty_hd_props[] = {
+	PROPERTY_ENTRY_BOOL("touchscreen-swapped-x-y"),
+	{ }
+};
+
+static const struct ts_dmi_data estar_beauty_hd_data = {
+	.acpi_name	= "GDIX1001:00",
+	.properties	= estar_beauty_hd_props,
+};
+
 static const struct property_entry gp_electronic_t701_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-size-x", 960),
 	PROPERTY_ENTRY_U32("touchscreen-size-y", 640),
@@ -747,6 +757,14 @@ static const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
 		},
 	},
+	{
+		/* Estar Beauty HD (MID 7316R) */
+		.driver_data = (void *)&estar_beauty_hd_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Estar"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "eSTAR BEAUTY HD Intel Quad core"),
+		},
+	},
 	{
 		/* GP-electronic T701 */
 		.driver_data = (void *)&gp_electronic_t701_data,
-- 
2.27.0



