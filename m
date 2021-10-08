Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8F3426992
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241936AbhJHLjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241079AbhJHLhz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:37:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 470A461440;
        Fri,  8 Oct 2021 11:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692762;
        bh=IGAmy8EHtpG3/cXS3+JNmnGHYOY3G8U95yyMeAbJOmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zlBTNica+8Dby6+Bu+76kYRQ/Qmne9yD5PK8uQSykp5oeNscz1R+8QHy1uYg3i1At
         ISSGgv3KHgJF+o+o3jzIers4DSVziUXu2/bS7PmJuPdIQjzMn5h6iigKzdMwIAnlRG
         YGz67S2BaI8OhBbqRhvdePtmkOfflqERB51xHCyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 04/48] platform/x86: touchscreen_dmi: Update info for the Chuwi Hi10 Plus (CWI527) tablet
Date:   Fri,  8 Oct 2021 13:27:40 +0200
Message-Id: <20211008112720.163881456@linuxfoundation.org>
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

[ Upstream commit 196159d278ae3b49e7bbb7c76822e6008fd89b97 ]

Add info for getting the firmware directly from the UEFI for the Chuwi Hi10
Plus (CWI527), so that the user does not need to manually install the
firmware in /lib/firmware/silead.

This change will make the touchscreen on these devices work OOTB,
without requiring any manual setup.

Also tweak the min and width/height values a bit for more accurate position
reporting.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210905130210.32810-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 1f9cb756b103..033f797861d8 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -100,10 +100,10 @@ static const struct ts_dmi_data chuwi_hi10_air_data = {
 };
 
 static const struct property_entry chuwi_hi10_plus_props[] = {
-	PROPERTY_ENTRY_U32("touchscreen-min-x", 0),
-	PROPERTY_ENTRY_U32("touchscreen-min-y", 5),
-	PROPERTY_ENTRY_U32("touchscreen-size-x", 1914),
-	PROPERTY_ENTRY_U32("touchscreen-size-y", 1283),
+	PROPERTY_ENTRY_U32("touchscreen-min-x", 12),
+	PROPERTY_ENTRY_U32("touchscreen-min-y", 10),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1908),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 1270),
 	PROPERTY_ENTRY_STRING("firmware-name", "gsl1680-chuwi-hi10plus.fw"),
 	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
 	PROPERTY_ENTRY_BOOL("silead,home-button"),
@@ -111,6 +111,15 @@ static const struct property_entry chuwi_hi10_plus_props[] = {
 };
 
 static const struct ts_dmi_data chuwi_hi10_plus_data = {
+	.embedded_fw = {
+		.name	= "silead/gsl1680-chuwi-hi10plus.fw",
+		.prefix = { 0xf0, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00 },
+		.length	= 34056,
+		.sha256	= { 0xfd, 0x0a, 0x08, 0x08, 0x3c, 0xa6, 0x34, 0x4e,
+			    0x2c, 0x49, 0x9c, 0xcd, 0x7d, 0x44, 0x9d, 0x38,
+			    0x10, 0x68, 0xb5, 0xbd, 0xb7, 0x2a, 0x63, 0xb5,
+			    0x67, 0x0b, 0x96, 0xbd, 0x89, 0x67, 0x85, 0x09 },
+	},
 	.acpi_name      = "MSSL0017:00",
 	.properties     = chuwi_hi10_plus_props,
 };
-- 
2.33.0



