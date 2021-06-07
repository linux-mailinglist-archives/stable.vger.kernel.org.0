Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84AF739E248
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhFGQQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:16:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232001AbhFGQPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:15:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 016F9613D0;
        Mon,  7 Jun 2021 16:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082403;
        bh=nju6YQpYseMnUGSdtKJTqaUpq2DQe+MUe1ZihKW0XQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y36xm6avNTBIx6OrdykrJ+KM1KU28U5OpMzjTSjzNwMNoDizlpNFHrtn8YL940sOD
         gitoAy568iQUTaVLJAz5jlWcI5jkb4Yt4wlC1ykX5hhMscIiA50skkLAwuaEdYxcB6
         nYdUTLdLu/NcMhc8GQ9L0zGwmUplnorWNRn6NfNI6Jum8ChyyjZ1wtTgdNGN5uHmLd
         JO755Xaw1ewYCTLnPH+9wbRoaV2quzoma8n3xECV6G895cbkNua+b7wv03zzCWC9Z4
         XbSAd6nJivQAHfy3X63QsOdvOkLHe8IyLhi0aqgPizFxlJ7UOM/82JB0+8WOvH6A+k
         ZoNRm6QcQk4OQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/39] HID: a4tech: use A4_2WHEEL_MOUSE_HACK_B8 for A4TECH NB-95
Date:   Mon,  7 Jun 2021 12:12:42 -0400
Message-Id: <20210607161318.3583636-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index 9b56226ce0d1..54bc563a8dff 100644
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
index c2e0c65b111b..951d0637cfb9 100644
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
index 2bda94199aaf..9acfa075d4f3 100644
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

