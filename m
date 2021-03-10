Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51B4333E15
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhCJNZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232971AbhCJNYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4A4164FF4;
        Wed, 10 Mar 2021 13:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382684;
        bh=7Gth+oEoH+K1gAOpS7eCmT9C4QyvuWQdsS9p9ugfx0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EIbFkvM7qgALXNrMrvWoofdxhXf8ND3CHMDrWPjjaftjj5H5ZTZfw6JFGFlzjf5/6
         nH7VWYiQPRFstXLDIdHYg/wdarLhz3LaxwjRxCauf3yDN/+sSkbsTHxxVnb0zW9MSA
         gEdnMTqFP0VvqI/aJ23hMXvlx1kaRr3UAXa7j8F8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ethan Warth <redyoshi49q@gmail.com>,
        "Wladimir J. van der Laan" <laanwj@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 21/49] HID: mf: add support for 0079:1846 Mayflash/Dragonrise USB Gamecube Adapter
Date:   Wed, 10 Mar 2021 14:23:32 +0100
Message-Id: <20210310132322.625544181@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
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
index 94180c63571e..4b0033d48863 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -359,6 +359,7 @@
 #define USB_DEVICE_ID_DRAGONRISE_DOLPHINBAR	0x1803
 #define USB_DEVICE_ID_DRAGONRISE_GAMECUBE1	0x1843
 #define USB_DEVICE_ID_DRAGONRISE_GAMECUBE2	0x1844
+#define USB_DEVICE_ID_DRAGONRISE_GAMECUBE3	0x1846
 
 #define USB_VENDOR_ID_DWAV		0x0eef
 #define USB_DEVICE_ID_EGALAX_TOUCHCONTROLLER	0x0001
diff --git a/drivers/hid/hid-mf.c b/drivers/hid/hid-mf.c
index fc75f30f537c..92d7ecd41a78 100644
--- a/drivers/hid/hid-mf.c
+++ b/drivers/hid/hid-mf.c
@@ -153,6 +153,8 @@ static const struct hid_device_id mf_devices[] = {
 		.driver_data = HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_GAMECUBE2),
 		.driver_data = 0 }, /* No quirk required */
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_GAMECUBE3),
+		.driver_data = HID_QUIRK_MULTI_INPUT },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, mf_devices);
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index bf7ecab5d9e5..2e38340e19df 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -72,6 +72,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_REDRAGON_SEYMUR2), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_DOLPHINBAR), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_GAMECUBE1), HID_QUIRK_MULTI_INPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_GAMECUBE3), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_PS3), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_WIIU), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_EGALAX_TOUCHCONTROLLER), HID_QUIRK_MULTI_INPUT | HID_QUIRK_NOGET },
@@ -484,6 +485,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_DOLPHINBAR) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_GAMECUBE1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_GAMECUBE2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_GAMECUBE3) },
 #endif
 #if IS_ENABLED(CONFIG_HID_MICROSOFT)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_COMFORT_MOUSE_4500) },
-- 
2.30.1



