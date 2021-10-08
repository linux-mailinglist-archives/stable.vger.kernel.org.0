Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363C7426996
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240928AbhJHLjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241136AbhJHLhy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:37:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBC58610CE;
        Fri,  8 Oct 2021 11:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692756;
        bh=ExyREt/XcrYHk48FYfBTILroNXwt9sOu+gyw8t3dL3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GOTK9Ue2R4esIE7V+zaxVs6LN5gkq4nFzCmNBLrVUEefUQG54Tvo/V0q22wumBEv
         maH4qAGeayJUsaYgVtS3fbPM/C7Flh+4fcmvLsmmwuv7g4fOkKwJ+dI+/pW1Lqv6oH
         c07yt+JQ2IFcfE7Iv5P7ser2W4dwNuRcK1B8fpVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 03/48] platform/x86: touchscreen_dmi: Add info for the Chuwi HiBook (CWI514) tablet
Date:   Fri,  8 Oct 2021 13:27:39 +0200
Message-Id: <20211008112720.132332401@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 3bf1669b0e033c885ebcb1ddc2334088dd125f2d ]

Add touchscreen info for the Chuwi HiBook (CWI514) tablet. This includes
info for getting the firmware directly from the UEFI, so that the user does
not need to manually install the firmware in /lib/firmware/silead.

This change will make the touchscreen on these devices work OOTB,
without requiring any manual setup.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210905130210.32810-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 37 ++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 0e1451b1d9c6..1f9cb756b103 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -141,6 +141,33 @@ static const struct ts_dmi_data chuwi_hi10_pro_data = {
 	.properties     = chuwi_hi10_pro_props,
 };
 
+static const struct property_entry chuwi_hibook_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-min-x", 30),
+	PROPERTY_ENTRY_U32("touchscreen-min-y", 4),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1892),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 1276),
+	PROPERTY_ENTRY_BOOL("touchscreen-inverted-y"),
+	PROPERTY_ENTRY_BOOL("touchscreen-swapped-x-y"),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl1680-chuwi-hibook.fw"),
+	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	PROPERTY_ENTRY_BOOL("silead,home-button"),
+	{ }
+};
+
+static const struct ts_dmi_data chuwi_hibook_data = {
+	.embedded_fw = {
+		.name	= "silead/gsl1680-chuwi-hibook.fw",
+		.prefix = { 0xf0, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00 },
+		.length	= 40392,
+		.sha256	= { 0xf7, 0xc0, 0xe8, 0x5a, 0x6c, 0xf2, 0xeb, 0x8d,
+			    0x12, 0xc4, 0x45, 0xbf, 0x55, 0x13, 0x4c, 0x1a,
+			    0x13, 0x04, 0x31, 0x08, 0x65, 0x73, 0xf7, 0xa8,
+			    0x1b, 0x7d, 0x59, 0xc9, 0xe6, 0x97, 0xf7, 0x38 },
+	},
+	.acpi_name      = "MSSL0017:00",
+	.properties     = chuwi_hibook_props,
+};
+
 static const struct property_entry chuwi_vi8_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-min-x", 4),
 	PROPERTY_ENTRY_U32("touchscreen-min-y", 6),
@@ -979,6 +1006,16 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
 		},
 	},
+	{
+		/* Chuwi HiBook (CWI514) */
+		.driver_data = (void *)&chuwi_hibook_data,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Hampoo"),
+			DMI_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
+			/* Above matches are too generic, add bios-date match */
+			DMI_MATCH(DMI_BIOS_DATE, "05/07/2016"),
+		},
+	},
 	{
 		/* Chuwi Vi8 (CWI506) */
 		.driver_data = (void *)&chuwi_vi8_data,
-- 
2.33.0



