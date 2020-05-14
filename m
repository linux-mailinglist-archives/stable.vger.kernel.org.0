Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B331D3B23
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbgENSzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728575AbgENSzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:55:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C10532076A;
        Thu, 14 May 2020 18:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482544;
        bh=QUFetR9UqtfJBD0l1eafaBNbAy+eu3AJDBGIyKjgDC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lboxmf33XnHH2uOkDp+DG+yNUgazOZtnJOd3w+q+Q6Dp8IE0G8zz0Yk8HWrb4tKeF
         KDChD78rnoWjFts2y1UdCbp2kosqhYNwuwABX3IBT/ObCwNq5kc+n/Guun6qUHzIaU
         n8eAIBB57BULeDJ1UyKAflmKDjfAWlH0GiAtKQ7o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 36/39] platform/x86: asus-nb-wmi: Do not load on Asus T100TA and T200TA
Date:   Thu, 14 May 2020 14:54:53 -0400
Message-Id: <20200514185456.21060-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185456.21060-1-sashal@kernel.org>
References: <20200514185456.21060-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 3bd12da7f50b8bc191fcb3bab1f55c582234df59 ]

asus-nb-wmi does not add any extra functionality on these Asus
Transformer books. They have detachable keyboards, so the hotkeys are
send through a HID device (and handled by the hid-asus driver) and also
the rfkill functionality is not used on these devices.

Besides not adding any extra functionality, initializing the WMI interface
on these devices actually has a negative side-effect. For some reason
the \_SB.ATKD.INIT() function which asus_wmi_platform_init() calls drives
GPO2 (INT33FC:02) pin 8, which is connected to the front facing webcam LED,
high and there is no (WMI or other) interface to drive this low again
causing the LED to be permanently on, even during suspend.

This commit adds a blacklist of DMI system_ids on which not to load the
asus-nb-wmi and adds these Transformer books to this list. This fixes
the webcam LED being permanently on under Linux.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 59f3a37a44d7a..8db2dc05b8cf2 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -517,9 +517,33 @@ static struct asus_wmi_driver asus_nb_wmi_driver = {
 	.detect_quirks = asus_nb_wmi_quirks,
 };
 
+static const struct dmi_system_id asus_nb_wmi_blacklist[] __initconst = {
+	{
+		/*
+		 * asus-nb-wm adds no functionality. The T100TA has a detachable
+		 * USB kbd, so no hotkeys and it has no WMI rfkill; and loading
+		 * asus-nb-wm causes the camera LED to turn and _stay_ on.
+		 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "T100TA"),
+		},
+	},
+	{
+		/* The Asus T200TA has the same issue as the T100TA */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "T200TA"),
+		},
+	},
+	{} /* Terminating entry */
+};
 
 static int __init asus_nb_wmi_init(void)
 {
+	if (dmi_check_system(asus_nb_wmi_blacklist))
+		return -ENODEV;
+
 	return asus_wmi_register_driver(&asus_nb_wmi_driver);
 }
 
-- 
2.20.1

