Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECB887BAA
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406921AbfHINqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:46:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406518AbfHINqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:46:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D2A3217F4;
        Fri,  9 Aug 2019 13:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358368;
        bh=zMmiBR71GlW3l1nMHrzxMH4Vf1MCCTt/NYA9dWdzv7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHJeqBAezbBKAud2c0tj05cZJJq0Be3eWZdADA61a03rQ77G7OFZPVLS6p4qCu66y
         mnS7wagkT3gsVpg5TLDjQ7kuj8bYQSziy18UT2VDJDdcemNnVgmK8eZGdo99DUgXIe
         ZnJZt1iZQ3zkfO7T7xp2wT94NMMDMPx8sAjO2Ccc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sebastian Parschauer <s.parschauer@gmx.de>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.4 04/21] HID: Add quirk for HP X1200 PIXART OEM mouse
Date:   Fri,  9 Aug 2019 15:45:08 +0200
Message-Id: <20190809134241.751925322@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809134241.565496442@linuxfoundation.org>
References: <20190809134241.565496442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Parschauer <s.parschauer@gmx.de>

commit 49869d2ea9eecc105a10724c1abf035151a3c4e2 upstream.

The PixArt OEM mice are known for disconnecting every minute in
runlevel 1 or 3 if they are not always polled. So add quirk
ALWAYS_POLL for this one as well.

Jonathan Teh (@jonathan-teh) reported and tested the quirk.
Reference: https://github.com/sriemer/fix-linux-mouse/issues/15

Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
CC: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ids.h           |    1 +
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -470,6 +470,7 @@
 #define USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0A4A	0x0a4a
 #define USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0B4A	0x0b4a
 #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE		0x134a
+#define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0641	0x0641
 
 #define USB_VENDOR_ID_HUION		0x256c
 #define USB_DEVICE_ID_HUION_TABLET	0x006e
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -82,6 +82,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0A4A, HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0B4A, HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE, HID_QUIRK_ALWAYS_POLL },
+	{ USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0641, HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_C077, HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_KEYBOARD_G710_PLUS, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOUSE_C01A, HID_QUIRK_ALWAYS_POLL },


