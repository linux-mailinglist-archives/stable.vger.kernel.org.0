Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6836241A7CC
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbhI1F7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239202AbhI1F6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58FFE611F0;
        Tue, 28 Sep 2021 05:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808606;
        bh=1BDI3ZVdJ/s08tnw6uvuhb79UtVnXik7lPZ9T5LzB1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z0mhbLSnwWfagD7iAOMbwHXpHZWKMHY1YZRh6mqC5VJQWfC2y9yLHh2Ck2kRxpJEQ
         dAlonYEwzju+qH7Umm3RyHZTlsblvepPsrght5uMuJYBsZSWwUCaCBwUFgQtPg2B4F
         n+5qCeDqJt2nNhFVQ2Oh1Z8Wz3s30nmX7nwmP6IT9SjeDBubwxNabJoumM+A/gCHkL
         YbOEkAkZs2pxpFuLrc2GWvAjhJWUr/i6e4YoFJt6L1SqW22mykVTbJ6mllQ2pQeZK2
         ZaBPPwGMzsDc3i327xMbBsSjkhjsEUudoYSzkBJWrLi6zS42ABUMWvIFEAP8E0D2vk
         mnPL2/FFX76+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mgross@linux.intel.com,
        linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/23] platform/x86: touchscreen_dmi: Update info for the Chuwi Hi10 Plus (CWI527) tablet
Date:   Tue, 28 Sep 2021 01:56:24 -0400
Message-Id: <20210928055645.172544-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055645.172544-1-sashal@kernel.org>
References: <20210928055645.172544-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

