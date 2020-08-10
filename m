Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8235240FAE
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729997AbgHJTX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729602AbgHJTMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:12:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78F9321775;
        Mon, 10 Aug 2020 19:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086761;
        bh=k2GYCMWzh/jmM7oR8EjJp5e5VzW0nQwvXmFEn3MWkZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QuTk1W1Ye7A9li4Wyre1nb/zB6trzH2Zkgx1xxqbuQGQS161yjabpvOn+ufJCoia1
         j068BDIoeHOzMALdWlj7iGMvKqDwUqljmZC0GeSwfBdU4bPMnTjS3QqTlNX95U/iVe
         tAExzt+Il2D3QqjtXfSidxa8f5kLh8gdCN0NXKP4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Armas Spann <zappel@retarded.farm>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 33/45] platform/x86: asus-nb-wmi: add support for ASUS ROG Zephyrus G14 and G15
Date:   Mon, 10 Aug 2020 15:11:41 -0400
Message-Id: <20200810191153.3794446-33-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191153.3794446-1-sashal@kernel.org>
References: <20200810191153.3794446-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Armas Spann <zappel@retarded.farm>

[ Upstream commit 13bceda68fb9ef388ad40d355ab8d03ee64d14c2 ]

Add device support for the new ASUS ROG Zephyrus G14 (GA401I) and
G15 (GA502I) series.

This is accomplished by two new quirk entries (one per each series),
as well as all current available G401I/G502I DMI_PRODUCT_NAMEs to match
the corresponding devices.

Signed-off-by: Armas Spann <zappel@retarded.farm>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 82 ++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 0d42477946f32..59b78a181723b 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -110,6 +110,16 @@ static struct quirk_entry quirk_asus_forceals = {
 	.wmi_force_als_set = true,
 };
 
+static struct quirk_entry quirk_asus_ga401i = {
+	.wmi_backlight_power = true,
+	.wmi_backlight_set_devstate = true,
+};
+
+static struct quirk_entry quirk_asus_ga502i = {
+	.wmi_backlight_power = true,
+	.wmi_backlight_set_devstate = true,
+};
+
 static int dmi_matched(const struct dmi_system_id *dmi)
 {
 	pr_info("Identified laptop model '%s'\n", dmi->ident);
@@ -411,6 +421,78 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_forceals,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. GA401IH",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IH"),
+		},
+		.driver_data = &quirk_asus_ga401i,
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. GA401II",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GA401II"),
+		},
+		.driver_data = &quirk_asus_ga401i,
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. GA401IU",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IU"),
+		},
+		.driver_data = &quirk_asus_ga401i,
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. GA401IV",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IV"),
+		},
+		.driver_data = &quirk_asus_ga401i,
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. GA401IVC",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IVC"),
+		},
+		.driver_data = &quirk_asus_ga401i,
+	},
+		{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. GA502II",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GA502II"),
+		},
+		.driver_data = &quirk_asus_ga502i,
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. GA502IU",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GA502IU"),
+		},
+		.driver_data = &quirk_asus_ga502i,
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. GA502IV",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GA502IV"),
+		},
+		.driver_data = &quirk_asus_ga502i,
+	},
 	{},
 };
 
-- 
2.25.1

