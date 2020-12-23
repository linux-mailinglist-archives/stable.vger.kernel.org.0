Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996BB2E14FE
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbgLWCql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:46:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729649AbgLWCWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB443225AB;
        Wed, 23 Dec 2020 02:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690125;
        bh=RnD1vpNEhi2D5VYICGoBIdtjERm7FhHLY4PJIooBO/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aiW8qvByahH7klY0SGpV/4U0Tof3B9F89tnUjG6zmTFbGQOsRgpiLSXgS9FB1dSje
         Y65WyHOWZk2OUYGb5cD2XAf+D2/9rE7yEHzUEJJkMYUIjTq0yKmNYo9tKcA3vFVb33
         TGkPFD7N2ElZL89d8CtBlPVvK896xtqmfBbJAC1PEJJDSomM3qj4GleCr5V3M3Z+sg
         Y0iikIA36wVjc66iENLy3TF++Nz7TTbQhSmuMquxOvnCFGSqKW93aQLdXLcigWVzYA
         pMjSYofpl0SQi6gzVOui3N82rFjbxNrqbGbsgcV20JZug8JIZRn/q6nUrLdVOXXFY3
         LzkEe+RNl21vg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ethan Warth <redyoshi49q@gmail.com>,
        "Wladimir J . van der Laan" <laanwj@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 50/87] HID: mf: add support for 0079:1846 Mayflash/Dragonrise USB Gamecube Adapter
Date:   Tue, 22 Dec 2020 21:20:26 -0500
Message-Id: <20201223022103.2792705-50-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ethan Warth <redyoshi49q@gmail.com>

[ Upstream commit 1008230f2abeb624f6d71b2e1c424fa4eeebbf84 ]

Mayflash/Dragonrise seems to have yet another device ID for one of their
Gamecube controller adapters.  Previous to this commit, the adapter
registered only one /dev/input/js* device, and all controller inputs (from
any controller) were mapped to this device.  This patch defines the 1846
USB device ID and enables the HID_QUIRK_MULTI_INPUT quirk for it, which
fixes that (with the patch, four /dev/input/js* devices are created, one
for each of the four controller ports).

Signed-off-by: Ethan Warth <redyoshi49q@gmail.com>
Tested-by: Wladimir J. van der Laan <laanwj@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-mf.c     | 2 ++
 drivers/hid/hid-quirks.c | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6d118da1615d4..1b2ac2bf4598a 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -358,6 +358,7 @@
 #define USB_DEVICE_ID_DRAGONRISE_DOLPHINBAR	0x1803
 #define USB_DEVICE_ID_DRAGONRISE_GAMECUBE1	0x1843
 #define USB_DEVICE_ID_DRAGONRISE_GAMECUBE2	0x1844
+#define USB_DEVICE_ID_DRAGONRISE_GAMECUBE3	0x1846
 
 #define USB_VENDOR_ID_DWAV		0x0eef
 #define USB_DEVICE_ID_EGALAX_TOUCHCONTROLLER	0x0001
diff --git a/drivers/hid/hid-mf.c b/drivers/hid/hid-mf.c
index 03f10516131df..a41202d385096 100644
--- a/drivers/hid/hid-mf.c
+++ b/drivers/hid/hid-mf.c
@@ -161,6 +161,8 @@ static const struct hid_device_id mf_devices[] = {
 		.driver_data = HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_GAMECUBE2),
 		.driver_data = 0 }, /* No quirk required */
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_GAMECUBE3),
+		.driver_data = HID_QUIRK_MULTI_INPUT },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, mf_devices);
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 10cb42a00fe87..8fbe7b9cd84a3 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -74,6 +74,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_REDRAGON_SEYMUR2), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_DOLPHINBAR), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_GAMECUBE1), HID_QUIRK_MULTI_INPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_GAMECUBE3), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_PS3), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_WIIU), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_EGALAX_TOUCHCONTROLLER), HID_QUIRK_MULTI_INPUT | HID_QUIRK_NOGET },
@@ -498,6 +499,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_DOLPHINBAR) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_GAMECUBE1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_GAMECUBE2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_GAMECUBE3) },
 #endif
 #if IS_ENABLED(CONFIG_HID_MICROSOFT)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_COMFORT_MOUSE_4500) },
-- 
2.27.0

