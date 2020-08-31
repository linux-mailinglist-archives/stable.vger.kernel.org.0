Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11BB257D57
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgHaPga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728648AbgHaPam (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:30:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 568BB20FC3;
        Mon, 31 Aug 2020 15:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887842;
        bh=blTd4Osh+x10KjYAiwG/hP9wHMdGhUox6Z85e+Gitec=;
        h=From:To:Cc:Subject:Date:From;
        b=ZsjRj/e3aUAG9TRZw7HHPfi/NmcAGqKXT44xdFIFXtoInT/MPJzAAk6KzXgELhVlv
         mE9s7jaovQMJ62z+crr/V1WXI4WDmx0GzHFIBqyYXrDDNN7IttTGB8Wc2zY5pqAlCZ
         qcFdTYAGo4OBH4NVSQ0pTiINdUzHytw2wYxrntoc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Parschauer <s.parschauer@gmx.de>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/23] HID: quirks: Always poll three more Lenovo PixArt mice
Date:   Mon, 31 Aug 2020 11:30:17 -0400
Message-Id: <20200831153039.1024302-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Parschauer <s.parschauer@gmx.de>

[ Upstream commit 627a49975bdc3220f360a8237603a6344ee6a588 ]

The PixArt OEM mice are known for disconnecting every minute in
runlevel 1 or 3 if they are not always polled. One Lenovo PixArt
mouse is already fixed. Got two references for 17ef:602e and three
references for 17ef:6019 misbehaving like this. Got one direct bug
report for 17ef:6093 from Wyatt Ward (wyatt8740). So add
HID_QUIRK_ALWAYS_POLL for all of them.

Link: https://github.com/sriemer/fix-linux-mouse issue 22
Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 3 +++
 drivers/hid/hid-quirks.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 73e4590ea9c94..5e418d5f5439d 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -730,6 +730,9 @@
 #define USB_DEVICE_ID_LENOVO_X1_TAB	0x60a3
 #define USB_DEVICE_ID_LENOVO_X1_TAB3	0x60b5
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D	0x608d
+#define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019	0x6019
+#define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_602E	0x602e
+#define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6093	0x6093
 
 #define USB_VENDOR_ID_LG		0x1fd2
 #define USB_DEVICE_ID_LG_MULTITOUCH	0x0064
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index a49fa2b047cba..59491798d6c2a 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -105,6 +105,9 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M406XE), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE_ID2), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_602E), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6093), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_C007), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_C077), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_KEYBOARD_G710_PLUS), HID_QUIRK_NOGET },
-- 
2.25.1

