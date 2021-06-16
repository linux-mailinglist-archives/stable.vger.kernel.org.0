Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F003A9FDC
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbhFPPmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235320AbhFPPkF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:40:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C1D3613C7;
        Wed, 16 Jun 2021 15:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857850;
        bh=lsGOWXhD4OzgtUhYUTTH4aLc++DtqV6hC8pZ+bn7B3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X58sa82dfJvArEeA7pWHO3dMhXygpgzA4OdF/X1Sqr5dQx2qpug0NF/fpWrjZfxwE
         x3x+dxUK3dCJBZtBCkNE5mmtfusTL+UNSOAKXL/P81Tb96nXFXtAyhs7O0GYDYbkvC
         HVpG9nDroir+yYv1QRgGMdy7h78OjxpRm8GXPhzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 05/48] HID: a4tech: use A4_2WHEEL_MOUSE_HACK_B8 for A4TECH NB-95
Date:   Wed, 16 Jun 2021 17:33:15 +0200
Message-Id: <20210616152836.822190130@linuxfoundation.org>
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

From: Mateusz Jończyk <mat.jonczyk@o2.pl>

[ Upstream commit 9858c74c29e12be5886280725e781cb735b2aca6 ]

This mouse has a horizontal wheel that requires special handling.
Without this patch, the horizontal wheel acts like a vertical wheel.

In the output of `hidrd-convert` for this mouse, there is a
`Usage (B8h)` field. It corresponds to a byte in packets sent by the
device that specifies which wheel generated an input event.

The name "A4TECH" is spelled in all capitals on the company website.

Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/Kconfig      | 4 ++--
 drivers/hid/hid-a4tech.c | 2 ++
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 786b71ef7738..c6a643f4fc5f 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -93,11 +93,11 @@ menu "Special HID drivers"
 	depends on HID
 
 config HID_A4TECH
-	tristate "A4 tech mice"
+	tristate "A4TECH mice"
 	depends on HID
 	default !EXPERT
 	help
-	Support for A4 tech X5 and WOP-35 / Trust 450L mice.
+	Support for some A4TECH mice with two scroll wheels.
 
 config HID_ACCUTOUCH
 	tristate "Accutouch touch device"
diff --git a/drivers/hid/hid-a4tech.c b/drivers/hid/hid-a4tech.c
index 3a8c4a5971f7..2cbc32dda7f7 100644
--- a/drivers/hid/hid-a4tech.c
+++ b/drivers/hid/hid-a4tech.c
@@ -147,6 +147,8 @@ static const struct hid_device_id a4_devices[] = {
 		.driver_data = A4_2WHEEL_MOUSE_HACK_B8 },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_RP_649),
 		.driver_data = A4_2WHEEL_MOUSE_HACK_B8 },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_NB_95),
+		.driver_data = A4_2WHEEL_MOUSE_HACK_B8 },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, a4_devices);
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6e25c505f813..20ac618f0f5b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -26,6 +26,7 @@
 #define USB_DEVICE_ID_A4TECH_WCP32PU	0x0006
 #define USB_DEVICE_ID_A4TECH_X5_005D	0x000a
 #define USB_DEVICE_ID_A4TECH_RP_649	0x001a
+#define USB_DEVICE_ID_A4TECH_NB_95	0x022b
 
 #define USB_VENDOR_ID_AASHIMA		0x06d6
 #define USB_DEVICE_ID_AASHIMA_GAMEPAD	0x0025
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 05d3f498fd44..2dcb5cb97f79 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -213,6 +213,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_WCP32PU) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_X5_005D) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_RP_649) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_NB_95) },
 #endif
 #if IS_ENABLED(CONFIG_HID_ACCUTOUCH)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_ACCUTOUCH_2216) },
-- 
2.30.2



