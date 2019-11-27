Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB2910BFBF
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfK0UeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:34:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727386AbfK0Ud7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:33:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1013A20866;
        Wed, 27 Nov 2019 20:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886838;
        bh=0BvNAF82J2aX7JVS6HiVRCDpFBp7S8bgVdgtKRtVTvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qP+ZSRWmO8J4KAgu6qZwalk9xSFrdx83GZbg+34ZLdB0gjDjMtY9aqgHYWbFtNNot
         5436TuvEaaeoWXzpjdnLSVcKg1RcZfXwjOpvtl6b1XIg2GXu+gZqpHrAIYzGqeIEXv
         B94GHkvw1iz93ts27AQE+arnoNkpoUdy3BcN8M7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zino lin <linzino7@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 013/132] platform/x86: asus-wmi: fix asus ux303ub brightness issue
Date:   Wed, 27 Nov 2019 21:30:04 +0100
Message-Id: <20191127202911.094115133@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zino lin <linzino7@gmail.com>

[ Upstream commit 999d4376c62828b260fbb59d5ab6bc28918ca448 ]

acpi_video0 doesn't work, asus-wmi brightness interface doesn't work, too.
So, we use native brightness interface to handle the brightness adjustion,
and add quirk_asus_ux303ub.

Signed-off-by: zino lin <linzino7@gmail.com>
Acked-by: Corentin Chary <corentin.chary@gmail.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 13 +++++++++++++
 drivers/platform/x86/asus-wmi.c    |  3 +++
 drivers/platform/x86/asus-wmi.h    |  1 +
 3 files changed, 17 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 904e28d4db528..a619cbe4e852f 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -112,6 +112,10 @@ static struct quirk_entry quirk_no_rfkill_wapf4 = {
 	.no_rfkill = true,
 };
 
+static struct quirk_entry quirk_asus_ux303ub = {
+	.wmi_backlight_native = true,
+};
+
 static int dmi_matched(const struct dmi_system_id *dmi)
 {
 	quirks = dmi->driver_data;
@@ -394,6 +398,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_no_rfkill,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. UX303UB",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "UX303UB"),
+		},
+		.driver_data = &quirk_asus_ux303ub,
+	},
 	{},
 };
 
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 823f85b1b4dc6..de131cf4d2e4d 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -2082,6 +2082,9 @@ static int asus_wmi_add(struct platform_device *pdev)
 	if (asus->driver->quirks->wmi_backlight_power)
 		acpi_video_set_dmi_backlight_type(acpi_backlight_vendor);
 
+	if (asus->driver->quirks->wmi_backlight_native)
+		acpi_video_set_dmi_backlight_type(acpi_backlight_native);
+
 	if (acpi_video_get_backlight_type() == acpi_backlight_vendor) {
 		err = asus_wmi_backlight_init(asus);
 		if (err && err != -ENODEV)
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index dd2e6cc0f3d48..0e19014e9f542 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -44,6 +44,7 @@ struct quirk_entry {
 	bool scalar_panel_brightness;
 	bool store_backlight_power;
 	bool wmi_backlight_power;
+	bool wmi_backlight_native;
 	int wapf;
 	/*
 	 * For machines with AMD graphic chips, it will send out WMI event
-- 
2.20.1



