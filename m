Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3140511B6AF
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbfLKPNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:13:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:36288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731372AbfLKPNN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6607C22B48;
        Wed, 11 Dec 2019 15:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077192;
        bh=Rh5ce0QnwACFW34gLI8wpJiDmwUoZjCSxe/Za8lhpTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6goPbJ03qAMtOswMfzoB44J4zdJXMR9Hb0aS1tGjJVtOUCw54fvBpV2IbVks1fpN
         U8BqKbZb2meTe6+BrWgZdmMpoLaURYr3TeDqksefyqV56EG7Wwny4Z56VLnLsliDOF
         4JEG6xFcAeZGq8CE1SSQZpV82I5VrfzjdjCsm+bs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jinke Fan <fanjinke@hygon.cn>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 075/134] HID: quirks: Add quirk for HP MSU1465 PIXART OEM mouse
Date:   Wed, 11 Dec 2019 10:10:51 -0500
Message-Id: <20191211151150.19073-75-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jinke Fan <fanjinke@hygon.cn>

[ Upstream commit f1a0094cbbe97a5f8aca7bdc64bfe43ac9dc6879 ]

The PixArt OEM mouse disconnets/reconnects every minute on
Linux. All contents of dmesg are repetitive:

[ 1465.810014] usb 1-2.2: USB disconnect, device number 20
[ 1467.431509] usb 1-2.2: new low-speed USB device number 21 using xhci_hcd
[ 1467.654982] usb 1-2.2: New USB device found, idVendor=03f0,idProduct=1f4a, bcdDevice= 1.00
[ 1467.654985] usb 1-2.2: New USB device strings: Mfr=1, Product=2,SerialNumber=0
[ 1467.654987] usb 1-2.2: Product: HP USB Optical Mouse
[ 1467.654988] usb 1-2.2: Manufacturer: PixArt
[ 1467.699722] input: PixArt HP USB Optical Mouse as /devices/pci0000:00/0000:00:07.1/0000:05:00.3/usb1/1-2/1-2.2/1-2.2:1.0/0003:03F0:1F4A.0012/input/input19
[ 1467.700124] hid-generic 0003:03F0:1F4A.0012: input,hidraw0: USB HID v1.11 Mouse [PixArt HP USB Optical Mouse] on usb-0000:05:00.3-2.2/input0

So add HID_QUIRK_ALWAYS_POLL for this one as well.
Test the patch, the mouse is no longer disconnected and there are no
duplicate logs in dmesg.

Reference:
https://github.com/sriemer/fix-linux-mouse

Signed-off-by: Jinke Fan <fanjinke@hygon.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 447e8db21174a..00904537e17c4 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -573,6 +573,7 @@
 #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_094A	0x094a
 #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0941	0x0941
 #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0641	0x0641
+#define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_1f4a	0x1f4a
 
 #define USB_VENDOR_ID_HUION		0x256c
 #define USB_DEVICE_ID_HUION_TABLET	0x006e
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index c50bcd967d994..9a35af1e26623 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -94,6 +94,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_094A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0941), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0641), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_1f4a), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_IDEACOM, USB_DEVICE_ID_IDEACOM_IDC6680), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_INNOMEDIA, USB_DEVICE_ID_INNEX_GENESIS_ATARI), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X), HID_QUIRK_MULTI_INPUT },
-- 
2.20.1

