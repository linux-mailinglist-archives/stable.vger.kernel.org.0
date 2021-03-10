Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B998C333EAD
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhCJN0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233520AbhCJNZu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BE9E64FDA;
        Wed, 10 Mar 2021 13:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382750;
        bh=nDf8v/NkMj2iRCXOH9WW+ZvaX1z+KuY45HJfFiNlMOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7wavN09Gadbux8rJRVUQIm3V7e0wG4uAKnkcWzOHnPEe/D6L59OL9BopFDF2Yrp9
         P3gmfvdBb6tBnD1Ey3d1GS5NIquwAKtv/6GrsZFm3rocTQhiK4RQOJtX99tJMhPtiy
         gU6g2SUIduEA26V5TrforZ4GxEi5Dn6G8Ssql+N4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ethan Warth <redyoshi49q@gmail.com>,
        "Wladimir J. van der Laan" <laanwj@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 33/39] HID: mf: add support for 0079:1846 Mayflash/Dragonrise USB Gamecube Adapter
Date:   Wed, 10 Mar 2021 14:24:41 +0100
Message-Id: <20210310132320.749973503@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
References: <20210310132319.708237392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
index ab2be7a115d8..2f1516b32837 100644
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
index 03f10516131d..a41202d38509 100644
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
index 10cb42a00fe8..8fbe7b9cd84a 100644
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
2.30.1



