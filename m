Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388D43BBFF5
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhGEPd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232320AbhGEPdU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:33:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1FE5619B2;
        Mon,  5 Jul 2021 15:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499029;
        bh=ey2+mX30mnDZCz714q+4hWcWtDJtwgG5E2ENIyZPmZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSiFGx57X+U2/ZGoZDnpYtEQMYXRG6mbcf8Ht8QC/l2t+TMgGV8ukw+t+KQB8f7xQ
         5fLUr87GiGAxneXHDJy8Su+2wPbN2BFvq7KXdTJnwwd6/NbeCS5seyoJn06QswDdEJ
         uf3Y8+V1frrJGtPt4gDpArtk7A2ph68A4qxxCJlTpPVuhF7Z6Z8zs9bIm32QaoMy4d
         GwrQShL6jK61Ji8VH3y1vVwlQIBRguy5Sd/Xtk/xaEQEJVW9tfqpRsZUS5FU6B0af8
         EkwqEnd+NPrcYu8fI5b/RLeruik3urX2qNoiB6YwiPJuhrC1dkpSQHH1gKWVMOJxea
         hzVFHqwis0JcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Luke D. Jones" <luke@ljones.dev>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 22/41] platform/x86: asus-nb-wmi: Revert "Drop duplicate DMI quirk structures"
Date:   Mon,  5 Jul 2021 11:29:42 -0400
Message-Id: <20210705153001.1521447-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153001.1521447-1-sashal@kernel.org>
References: <20210705153001.1521447-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Luke D. Jones" <luke@ljones.dev>

[ Upstream commit 98c0c85b1040db24f0d04d3e1d315c6c7b05cc07 ]

This is a preparation revert for reverting the "add support for ASUS ROG
Zephyrus G14 and G15" change. This reverts
commit 67186653c903 ("platform/x86: asus-nb-wmi: Drop duplicate DMI quirk
structures")

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20210419074915.393433-2-luke@ljones.dev
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 1d9fbabd02fb..ff39079e2d75 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -110,7 +110,12 @@ static struct quirk_entry quirk_asus_forceals = {
 	.wmi_force_als_set = true,
 };
 
-static struct quirk_entry quirk_asus_vendor_backlight = {
+static struct quirk_entry quirk_asus_ga401i = {
+	.wmi_backlight_power = true,
+	.wmi_backlight_set_devstate = true,
+};
+
+static struct quirk_entry quirk_asus_ga502i = {
 	.wmi_backlight_power = true,
 	.wmi_backlight_set_devstate = true,
 };
@@ -427,7 +432,7 @@ static const struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IH"),
 		},
-		.driver_data = &quirk_asus_vendor_backlight,
+		.driver_data = &quirk_asus_ga401i,
 	},
 	{
 		.callback = dmi_matched,
@@ -436,7 +441,7 @@ static const struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "GA401II"),
 		},
-		.driver_data = &quirk_asus_vendor_backlight,
+		.driver_data = &quirk_asus_ga401i,
 	},
 	{
 		.callback = dmi_matched,
@@ -445,7 +450,7 @@ static const struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IU"),
 		},
-		.driver_data = &quirk_asus_vendor_backlight,
+		.driver_data = &quirk_asus_ga401i,
 	},
 	{
 		.callback = dmi_matched,
@@ -454,7 +459,7 @@ static const struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IV"),
 		},
-		.driver_data = &quirk_asus_vendor_backlight,
+		.driver_data = &quirk_asus_ga401i,
 	},
 	{
 		.callback = dmi_matched,
@@ -463,7 +468,7 @@ static const struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IVC"),
 		},
-		.driver_data = &quirk_asus_vendor_backlight,
+		.driver_data = &quirk_asus_ga401i,
 	},
 		{
 		.callback = dmi_matched,
@@ -472,7 +477,7 @@ static const struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "GA502II"),
 		},
-		.driver_data = &quirk_asus_vendor_backlight,
+		.driver_data = &quirk_asus_ga502i,
 	},
 	{
 		.callback = dmi_matched,
@@ -481,7 +486,7 @@ static const struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "GA502IU"),
 		},
-		.driver_data = &quirk_asus_vendor_backlight,
+		.driver_data = &quirk_asus_ga502i,
 	},
 	{
 		.callback = dmi_matched,
@@ -490,7 +495,7 @@ static const struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "GA502IV"),
 		},
-		.driver_data = &quirk_asus_vendor_backlight,
+		.driver_data = &quirk_asus_ga502i,
 	},
 	{
 		.callback = dmi_matched,
-- 
2.30.2

