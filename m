Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7433B205EE4
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390495AbgFWU1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390538AbgFWU1G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:27:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1704206EB;
        Tue, 23 Jun 2020 20:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944025;
        bh=E0vol963znMy9m2ePZE+9fOxempRSj6cd3mauL2dhXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9WwSekwLXE5llEeoKLD1vKin84F4Tlckzmi1jZkBo2K608TLBBTkDc4ReKGHWK1G
         RyCiHVltsVvVrgaBXmJDo8ar1UhB94vRzmA0p46PuNKS/R72f0b6/q5CUdPSTCN3eO
         Q3pJdzo+skJY6Fq98Wuj0WNAMVnYxa2tBc6W5Q+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Klein <cristian.klein@elastisys.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 144/314] HID: Add quirks for Trust Panora Graphic Tablet
Date:   Tue, 23 Jun 2020 21:55:39 +0200
Message-Id: <20200623195345.727365042@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 13b7222ef2c91..c552a6bc627eb 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1147,6 +1147,9 @@
 #define USB_DEVICE_ID_TPV_OPTICAL_TOUCHSCREEN_8882	0x8882
 #define USB_DEVICE_ID_TPV_OPTICAL_TOUCHSCREEN_8883	0x8883
 
+#define USB_VENDOR_ID_TRUST             0x145f
+#define USB_DEVICE_ID_TRUST_PANORA_TABLET   0x0212
+
 #define USB_VENDOR_ID_TURBOX		0x062a
 #define USB_DEVICE_ID_TURBOX_KEYBOARD	0x0201
 #define USB_DEVICE_ID_ASUS_MD_5110	0x5110
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 90ec2390ef688..168fdaa1999fe 100644
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



