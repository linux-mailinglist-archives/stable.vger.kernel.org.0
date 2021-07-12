Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082023C48EB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbhGLGlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237496AbhGLGj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:39:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2C32610FA;
        Mon, 12 Jul 2021 06:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071719;
        bh=fEHVmFxCRhjWjZj6a7CZ+2qNMwosdTHTJVUDYrfLuFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1EMnUHsFL0DuXtOh9s6hc1r/dU9uJfTPpQUKyqHbNjqR5knpZoa4YWCyzXkolO+O/
         TBs7ulyHc7E5vWo4BKxbnflpt/dE3pOB4wK4QqeR5l9LwRTs/eYG5KydLoCosGmloO
         a0YMs7G+l8gyWHZHRx2X2OtndUua5ZfKpBIx7eYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Luke D. Jones" <luke@ljones.dev>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 189/593] platform/x86: asus-nb-wmi: Revert "Drop duplicate DMI quirk structures"
Date:   Mon, 12 Jul 2021 08:05:49 +0200
Message-Id: <20210712060903.815676540@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke D. Jones <luke@ljones.dev>

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



