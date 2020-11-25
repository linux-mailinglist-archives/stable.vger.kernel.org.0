Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D71F2C43A4
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbgKYPgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:36:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730376AbgKYPgC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:36:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2CF22087C;
        Wed, 25 Nov 2020 15:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318561;
        bh=T5rnfp3F3wYg2Pn8TDnxMX2cqai5pwu2xJg82n5oltc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XeiKjFG1zSeJZyeN9TPKsBtLskXzL/TBJVUJs4YhKmSzQ7Bi6b9lzqazY5pPG/9Tt
         y7cZpvuLh+YPi75/uHaWC+cUJWkqMOfFFry2rTCdYbm+KTyZ6LxO4kBq4H8Eo0Lvxh
         18OPVa/7hjPZ0kAtCWIwyT8aXrZXbfWC8+7OcH6Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Ye <lzye@google.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 08/33] HID: add HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE for Gamevice devices
Date:   Wed, 25 Nov 2020 10:35:25 -0500
Message-Id: <20201125153550.810101-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153550.810101-1-sashal@kernel.org>
References: <20201125153550.810101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Ye <lzye@google.com>

[ Upstream commit f59ee399de4a8ca4d7d19cdcabb4b63e94867f09 ]

Kernel 5.4 introduces HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE, devices need to
be set explicitly with this flag.

Signed-off-by: Chris Ye <lzye@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 4 ++++
 drivers/hid/hid-quirks.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6d6c961f8fee7..96e84a51f6b2c 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -445,6 +445,10 @@
 #define USB_VENDOR_ID_FRUCTEL	0x25B6
 #define USB_DEVICE_ID_GAMETEL_MT_MODE	0x0002
 
+#define USB_VENDOR_ID_GAMEVICE	0x27F8
+#define USB_DEVICE_ID_GAMEVICE_GV186	0x0BBE
+#define USB_DEVICE_ID_GAMEVICE_KISHI	0x0BBF
+
 #define USB_VENDOR_ID_GAMERON		0x0810
 #define USB_DEVICE_ID_GAMERON_DUAL_PSX_ADAPTOR	0x0001
 #define USB_DEVICE_ID_GAMERON_DUAL_PCS_ADAPTOR	0x0002
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index b154e11d43bfa..bf7ecab5d9e5e 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -85,6 +85,10 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_FUTABA, USB_DEVICE_ID_LED_DISPLAY), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, USB_DEVICE_ID_GREENASIA_DUAL_SAT_ADAPTOR), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, USB_DEVICE_ID_GREENASIA_DUAL_USB_JOYPAD), HID_QUIRK_MULTI_INPUT },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_GAMEVICE, USB_DEVICE_ID_GAMEVICE_GV186),
+		HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMEVICE, USB_DEVICE_ID_GAMEVICE_KISHI),
+		HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_DRIVING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FLYING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
-- 
2.27.0

