Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE773A9FF6
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235163AbhFPPnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235186AbhFPPlK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:41:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D43EB613F8;
        Wed, 16 Jun 2021 15:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857859;
        bh=kUA23yUgl7IrtVW/G2QOlpxZgPwa6p5hBfUETR0eW3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+VCZdMeOWSu4izr+UqQJAoWW+Y8SALYNQ/q8sM1tAO8vVCM00DlaRkKppatwebNH
         ZF5HDcVCUUVsvtxceBG74LBZ96fWiN+sDDNnguSSh72GV3iAqgrvwmzM4x/nCjLOWi
         srBbscDWHsGSpOHwoNQnpE6VkTIUAg3WLHTq93Yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 09/48] HID: quirks: Add quirk for Lenovo optical mouse
Date:   Wed, 16 Jun 2021 17:33:19 +0200
Message-Id: <20210616152836.946816049@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>

[ Upstream commit 3b2520076822f15621509a6da3bc4a8636cd33b4 ]

The Lenovo optical mouse with vendor id of 0x17ef and product id of
0x600e experiences disconnecting issues every 55 seconds:

[38565.706242] usb 1-1.4: Product: Lenovo Optical Mouse
[38565.728603] input: Lenovo Optical Mouse as /devices/platform/scb/fd500000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0/usb1/1-1/1-1.4/1-1.4:1.0/0003:17EF:600E.029A/input/input665
[38565.755949] hid-generic 0003:17EF:600E.029A: input,hidraw1: USB HID v1.11 Mouse [Lenovo Optical Mouse] on usb-0000:01:00.0-1.4/input0
[38619.360692] usb 1-1.4: USB disconnect, device number 48
[38620.864990] usb 1-1.4: new low-speed USB device number 49 using xhci_hcd
[38620.984011] usb 1-1.4: New USB device found, idVendor=17ef,idProduct=600e, bcdDevice= 1.00
[38620.998117] usb 1-1.4: New USB device strings: Mfr=0, Product=2,SerialNumber=0

This adds HID_QUIRK_ALWAYS_POLL for this device in order to work properly.

Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 20ac618f0f5b..03978111d944 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -750,6 +750,7 @@
 #define USB_DEVICE_ID_LENOVO_X1_COVER	0x6085
 #define USB_DEVICE_ID_LENOVO_X1_TAB	0x60a3
 #define USB_DEVICE_ID_LENOVO_X1_TAB3	0x60b5
+#define USB_DEVICE_ID_LENOVO_OPTICAL_USB_MOUSE_600E	0x600e
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D	0x608d
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019	0x6019
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_602E	0x602e
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 2dcb5cb97f79..bb2b60bc618f 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -110,6 +110,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_PENSKETCH_M912), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M406XE), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE_ID2), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_OPTICAL_USB_MOUSE_600E), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_602E), HID_QUIRK_ALWAYS_POLL },
-- 
2.30.2



