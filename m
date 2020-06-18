Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E951FE73D
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgFRBMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728960AbgFRBMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 984882193E;
        Thu, 18 Jun 2020 01:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442761;
        bh=bLKs0F9qpncOMhNAxK3f8Z6dGYE3OeefVbpYvGQBLGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1u6xEgv9oDclzmJ3z2Xc5o7GtZcefa+y7mcLuzLnDXy8/jpWmn+Dmt91USI4xhab
         2QIFjRCHBx6Z10ABaHlDxUItp7BqI/pDwvoqjmOW0ItYXBE++ieIuW3tV5/4Cvsu3o
         JgeQedyV8yX37JWPLIvFVAv2cWcBO3tT+me3KllY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Klein <cristian.klein@elastisys.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 211/388] HID: Add quirks for Trust Panora Graphic Tablet
Date:   Wed, 17 Jun 2020 21:05:08 -0400
Message-Id: <20200618010805.600873-211-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Klein <cristian.klein@elastisys.com>

[ Upstream commit fb68ada81e65d593b51544fa43c284322107a742 ]

The Trust Panora Graphic Tablet has two interfaces. Interface zero reports pen
movement, pen pressure and pen buttons. Interface one reports tablet buttons
and tablet scroll. Both use the mouse protocol.

Without these quirks, libinput gets confused about what device it talks to.

For completeness, here is the usbhid-dump:

```
$ sudo usbhid-dump -d 145f:0212
003:013:001:DESCRIPTOR         1588949402.559961
 05 0D 09 01 A1 01 85 07 A1 02 09 00 75 08 95 07
 81 02 C0 C0 09 0E A1 01 85 05 09 23 A1 02 09 52
 09 53 25 0A 75 08 95 02 B1 02 C0 C0 05 0C 09 36
 A1 00 85 06 05 09 19 01 29 20 15 00 25 01 95 20
 75 01 81 02 C0

003:013:000:DESCRIPTOR         1588949402.563942
 05 01 09 02 A1 01 85 08 09 01 A1 00 05 09 19 01
 29 03 15 00 25 01 95 03 75 01 81 02 95 05 81 01
 05 01 09 30 09 31 09 38 09 00 15 81 25 7F 75 08
 95 04 81 06 C0 C0 05 01 09 02 A1 01 85 09 09 01
 A1 00 05 09 19 01 29 03 15 00 25 01 95 03 75 01
 81 02 95 05 81 01 05 01 09 30 09 31 26 FF 7F 95
 02 75 10 81 02 05 0D 09 30 26 FF 03 95 01 75 10
 81 02 C0 C0 05 01 09 00 A1 01 85 04 A1 00 26 FF
 00 09 00 75 08 95 07 B1 02 C0 C0
```

Signed-off-by: Cristian Klein <cristian.klein@elastisys.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 3 +++
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 1c71a1aa76b2..f03f1cc913ce 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1157,6 +1157,9 @@
 #define USB_DEVICE_ID_TPV_OPTICAL_TOUCHSCREEN_8882	0x8882
 #define USB_DEVICE_ID_TPV_OPTICAL_TOUCHSCREEN_8883	0x8883
 
+#define USB_VENDOR_ID_TRUST             0x145f
+#define USB_DEVICE_ID_TRUST_PANORA_TABLET   0x0212
+
 #define USB_VENDOR_ID_TURBOX		0x062a
 #define USB_DEVICE_ID_TURBOX_KEYBOARD	0x0201
 #define USB_DEVICE_ID_ASUS_MD_5110	0x5110
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index e4cb543de0cd..ca8b5c261c7c 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -168,6 +168,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TOUCHPACK, USB_DEVICE_ID_TOUCHPACK_RTS), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TPV, USB_DEVICE_ID_TPV_OPTICAL_TOUCHSCREEN_8882), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TPV, USB_DEVICE_ID_TPV_OPTICAL_TOUCHSCREEN_8883), HID_QUIRK_NOGET },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_TRUST, USB_DEVICE_ID_TRUST_PANORA_TABLET), HID_QUIRK_MULTI_INPUT | HID_QUIRK_HIDINPUT_FORCE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TURBOX, USB_DEVICE_ID_TURBOX_KEYBOARD), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_KNA5), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_TWA60), HID_QUIRK_MULTI_INPUT },
-- 
2.25.1

