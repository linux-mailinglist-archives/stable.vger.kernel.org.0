Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5114441A75D
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238896AbhI1F5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238869AbhI1F5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:57:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDBC1611CE;
        Tue, 28 Sep 2021 05:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808526;
        bh=IGAmy8EHtpG3/cXS3+JNmnGHYOY3G8U95yyMeAbJOmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvAmGva5VfRUhactKAbiJ7jleURwJyzY/22qwaVQvwneoBhdOJzAh1ijYsgf+/vMC
         oqeM26eMkcNzkexVRzZoG9/lzXr1No88h38nr44j1TMmaSnG+EJMRRmGyncb2+lnQV
         F4OKYKeOuazgTz3ETH0pJtzJMvz7DgaOQDxYOBmDRqa1YRPP6ISz4NELLU+e06vAPu
         oq/u2+0elZBZMeaV21+QPDzU+Gs1yspE9E9ukWuoVCtUpstiG7TaDhONwYISaZQP2l
         Xygp4yHr2hArnQVzzoGy9Z7qvMhRw4msfjVGKxa1HMZOmK658k/5uKztEiMF72mpXO
         zCc0+N7t2tbew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mgross@linux.intel.com,
        linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 04/40] platform/x86: touchscreen_dmi: Update info for the Chuwi Hi10 Plus (CWI527) tablet
Date:   Tue, 28 Sep 2021 01:54:48 -0400
Message-Id: <20210928055524.172051-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
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

