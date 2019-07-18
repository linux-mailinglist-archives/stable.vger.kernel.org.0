Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 506E16C787
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389082AbfGRDFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732249AbfGRDFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:05:09 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D717021848;
        Thu, 18 Jul 2019 03:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419109;
        bh=fqgnhXlZWvwpVYR9LVed7+3xHcorhXb1GK1XtkUk98w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7yH7OG0DTwoi+/bxngoVHz5V4rYVd10fkv06NKzSvLnIX8/TRCMChhRDFhtSlu/m
         7aGg0SGS1jbjpNLbBkXKtQglYwWCP0F4WryI6Qok+wbxBPXEwywIQe9LrXhXciz+Ba
         Tt2MkCl2MVSvfPNo2qxFZEVf2LLfS9Lqe3fqK3AE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksandr Natalenko <oleksandr@redhat.com>,
        Sebastian Parschauer <s.parschauer@gmx.de>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 32/54] HID: chicony: add another quirk for PixArt mouse
Date:   Thu, 18 Jul 2019 12:01:27 +0900
Message-Id: <20190718030055.842427058@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit dcf768b0ac868630e7bdb6f2f1c9fe72788012fa ]

I've spotted another Chicony PixArt mouse in the wild, which requires
HID_QUIRK_ALWAYS_POLL quirk, otherwise it disconnects each minute.

USB ID of this device is 0x04f2:0x0939.

We've introduced quirks like this for other models before, so lets add
this mouse too.

Link: https://github.com/sriemer/fix-linux-mouse#usb-mouse-disconnectsreconnects-every-minute-on-linux
Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
Acked-by: Sebastian Parschauer <s.parschauer@gmx.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6537086fb145..f10f5cce7aa9 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -272,6 +272,7 @@
 #define USB_DEVICE_ID_CHICONY_MULTI_TOUCH	0xb19d
 #define USB_DEVICE_ID_CHICONY_WIRELESS	0x0618
 #define USB_DEVICE_ID_CHICONY_PIXART_USB_OPTICAL_MOUSE	0x1053
+#define USB_DEVICE_ID_CHICONY_PIXART_USB_OPTICAL_MOUSE2	0x0939
 #define USB_DEVICE_ID_CHICONY_WIRELESS2	0x1123
 #define USB_DEVICE_ID_ASUS_AK1D		0x1125
 #define USB_DEVICE_ID_CHICONY_TOSHIBA_WT10A	0x1408
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 189bf68eb35c..74c0ad21b267 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -45,6 +45,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_UC100KM), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_MULTI_TOUCH), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_PIXART_USB_OPTICAL_MOUSE), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_PIXART_USB_OPTICAL_MOUSE2), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHIC, USB_DEVICE_ID_CHIC_GAMEPAD), HID_QUIRK_BADPAD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_3AXIS_5BUTTON_STICK), HID_QUIRK_NOGET },
-- 
2.20.1



