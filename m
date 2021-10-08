Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02E142695A
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241856AbhJHLgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241274AbhJHLeH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:34:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A197461283;
        Fri,  8 Oct 2021 11:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692691;
        bh=1BDI3ZVdJ/s08tnw6uvuhb79UtVnXik7lPZ9T5LzB1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROt3RofDPjiQjq8n71dRQZcGSDan/VDdBiagrVT2daBFuai1qm4ce+h5ADTvkFD/b
         BVMiQg3N7zVazUCZXDM/2RNhtS/5GmTwdVRoh7sCPLI4Mv6x2YnJZnirLT7mV/m+O/
         SXFVK5jh8Ja09M5awmlBP70V/TcGZsn+09bxRPUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 03/29] platform/x86: touchscreen_dmi: Update info for the Chuwi Hi10 Plus (CWI527) tablet
Date:   Fri,  8 Oct 2021 13:27:50 +0200
Message-Id: <20211008112717.040167258@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112716.914501436@linuxfoundation.org>
References: <20211008112716.914501436@linuxfoundation.org>
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
index 4f5d53b585db..59b7e90cd587 100644
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



