Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221173C4C9A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242181AbhGLHGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243467AbhGLHE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:04:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D82DD610E6;
        Mon, 12 Jul 2021 07:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073330;
        bh=/zIf+I4JdXj6gXGuXn+Bgugw72VRZUQcxd3EkZMw6XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h82SJhK56RLUPRcNnbkN8pt/IjgTBoCADmQ7UmnJsIFnmyU4p55ljQF/6VILH1Ljq
         S69UQ+S9gn/IWQjMvTirxfuL7G+zwIeZT6sxWkT5EUYpYGilROvVWHLzmoMr5S24Hl
         MNvH85cxbmDNxgSM8HCPKgzdJZ9RLKUfrjD4bi0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 204/700] platform/x86: touchscreen_dmi: Add info for the Goodix GT912 panel of TM800A550L tablets
Date:   Mon, 12 Jul 2021 08:04:47 +0200
Message-Id: <20210712060955.684076344@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit fcd8cf0e3e48f4c66af82c8e799c37cb0cccffe0 ]

The Bay Trail Glavey TM800A550L tablet, which ships with Android installed
from the factory, uses a GT912 touchscreen controller which needs to have
its firmware uploaded by the OS to work (this is a first for a x86 based
device with a Goodix touchscreen controller).

Add a touchscreen_dmi entry for this which specifies the filenames
to use for the firmware and config files needed for this.

Note this matches on a GDIX1001 ACPI HID, while the original DSDT uses
a HID of GODX0911. For the touchscreen to work on these devices a DSDT
override is necessary to fix a missing IRQ and broken GPIO settings in
the ACPI-resources for the touchscreen. This override also changes the
HID to the standard GDIX1001 id typically used for Goodix touchscreens.
The DSDT override is available here:
https://fedorapeople.org/~jwrdegoede/glavey-tm800a550l-dsdt-override/

Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210504185746.175461-5-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index bbd8d80230cd..b47f6821615e 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -316,6 +316,18 @@ static const struct ts_dmi_data gdix1001_01_upside_down_data = {
 	.properties	= gdix1001_upside_down_props,
 };
 
+static const struct property_entry glavey_tm800a550l_props[] = {
+	PROPERTY_ENTRY_STRING("firmware-name", "gt912-glavey-tm800a550l.fw"),
+	PROPERTY_ENTRY_STRING("goodix,config-name", "gt912-glavey-tm800a550l.cfg"),
+	PROPERTY_ENTRY_U32("goodix,main-clk", 54),
+	{ }
+};
+
+static const struct ts_dmi_data glavey_tm800a550l_data = {
+	.acpi_name	= "GDIX1001:00",
+	.properties	= glavey_tm800a550l_props,
+};
+
 static const struct property_entry gp_electronic_t701_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-size-x", 960),
 	PROPERTY_ENTRY_U32("touchscreen-size-y", 640),
@@ -1029,6 +1041,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "eSTAR BEAUTY HD Intel Quad core"),
 		},
 	},
+	{	/* Glavey TM800A550L */
+		.driver_data = (void *)&glavey_tm800a550l_data,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "Aptio CRB"),
+			/* Above strings are too generic, also match on BIOS version */
+			DMI_MATCH(DMI_BIOS_VERSION, "ZY-8-BI-PX4S70VTR400-X423B-005-D"),
+		},
+	},
 	{
 		/* GP-electronic T701 */
 		.driver_data = (void *)&gp_electronic_t701_data,
-- 
2.30.2



