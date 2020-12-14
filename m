Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2FC2D9F6C
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440496AbgLNSlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:41:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502290AbgLNRh5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:57 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 071/105] platform/x86: touchscreen_dmi: Add info for the Predia Basic tablet
Date:   Mon, 14 Dec 2020 18:28:45 +0100
Message-Id: <20201214172558.683932630@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 0f511edc6ac12f1ccf1c6c2d4412f5ed7ba426a6 ]

Add touchscreen info for the Predia Basic tablet.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20201015194949.50566-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 27 ++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index dda60f89c9512..26cbf7cc8129c 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -623,6 +623,23 @@ static const struct ts_dmi_data pov_mobii_wintab_p1006w_v10_data = {
 	.properties	= pov_mobii_wintab_p1006w_v10_props,
 };
 
+static const struct property_entry predia_basic_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-min-x", 3),
+	PROPERTY_ENTRY_U32("touchscreen-min-y", 10),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1728),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 1144),
+	PROPERTY_ENTRY_BOOL("touchscreen-swapped-x-y"),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl3680-predia-basic.fw"),
+	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	PROPERTY_ENTRY_BOOL("silead,home-button"),
+	{ }
+};
+
+static const struct ts_dmi_data predia_basic_data = {
+	.acpi_name	= "MSSL1680:00",
+	.properties	= predia_basic_props,
+};
+
 static const struct property_entry schneider_sct101ctm_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-size-x", 1715),
 	PROPERTY_ENTRY_U32("touchscreen-size-y", 1140),
@@ -1109,6 +1126,16 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_DATE, "10/24/2014"),
 		},
 	},
+	{
+		/* Predia Basic tablet) */
+		.driver_data = (void *)&predia_basic_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CherryTrail"),
+			/* Above matches are too generic, add bios-version match */
+			DMI_MATCH(DMI_BIOS_VERSION, "Mx.WT107.KUBNGEA"),
+		},
+	},
 	{
 		/* Point of View mobii wintab p800w (v2.1) */
 		.driver_data = (void *)&pov_mobii_wintab_p800w_v21_data,
-- 
2.27.0



