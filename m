Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B683C4CBF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242814AbhGLHHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:07:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241932AbhGLHGI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:06:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13D6361221;
        Mon, 12 Jul 2021 07:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073377;
        bh=Uh8Cx8R6eJK7PKWsCYdNNZ/zeqIELNIHsJ1mw2YVby4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPs12ilQj8Ogpt6PdOhQa+C2P3fZHHVLsOPD+ozkFQutKsxgEKQwVBjxeG3VQO7sL
         OQWcNJrtSvSBSdAMQF3B3JbgdoMLZfuXwe2C0+n/PMCS9tq1DuzVrBAgFCttETHRf9
         h0NNgO0f0Y/ipW2MGMGdp/1bB8ylcWDo7IWbQVq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Luke D. Jones" <luke@ljones.dev>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 222/700] platform/x86: asus-nb-wmi: Revert "Drop duplicate DMI quirk structures"
Date:   Mon, 12 Jul 2021 08:05:05 +0200
Message-Id: <20210712060958.234646543@linuxfoundation.org>
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
index d41d7ad14be0..b07b1288346e 100644
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
@@ -432,7 +437,7 @@ static const struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IH"),
 		},
-		.driver_data = &quirk_asus_vendor_backlight,
+		.driver_data = &quirk_asus_ga401i,
 	},
 	{
 		.callback = dmi_matched,
@@ -441,7 +446,7 @@ static const struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "GA401II"),
 		},
-		.driver_data = &quirk_asus_vendor_backlight,
+		.driver_data = &quirk_asus_ga401i,
 	},
 	{
 		.callback = dmi_matched,
@@ -450,7 +455,7 @@ static const struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IU"),
 		},
-		.driver_data = &quirk_asus_vendor_backlight,
+		.driver_data = &quirk_asus_ga401i,
 	},
 	{
 		.callback = dmi_matched,
@@ -459,7 +464,7 @@ static const struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IV"),
 		},
-		.driver_data = &quirk_asus_vendor_backlight,
+		.driver_data = &quirk_asus_ga401i,
 	},
 	{
 		.callback = dmi_matched,
@@ -468,7 +473,7 @@ static const struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IVC"),
 		},
-		.driver_data = &quirk_asus_vendor_backlight,
+		.driver_data = &quirk_asus_ga401i,
 	},
 		{
 		.callback = dmi_matched,
@@ -477,7 +482,7 @@ static const struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "GA502II"),
 		},
-		.driver_data = &quirk_asus_vendor_backlight,
+		.driver_data = &quirk_asus_ga502i,
 	},
 	{
 		.callback = dmi_matched,
@@ -486,7 +491,7 @@ static const struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "GA502IU"),
 		},
-		.driver_data = &quirk_asus_vendor_backlight,
+		.driver_data = &quirk_asus_ga502i,
 	},
 	{
 		.callback = dmi_matched,
@@ -495,7 +500,7 @@ static const struct dmi_system_id asus_quirks[] = {
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



