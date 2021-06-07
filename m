Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AAF39E2C0
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbhFGQTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:19:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232640AbhFGQRc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:17:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 387506145F;
        Mon,  7 Jun 2021 16:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082453;
        bh=e1RglGgceQVgT5a6PSzAFDyPTmrBP5cXQChYJClxZF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cW49iqVXE2cX3O2S8OtlX4q4S5NYxbLBJD1PFCMwA83LkUAC6AtnywI9H0kfOMdvO
         +90VDAfVyX38d0i3Jeuf35dKN8ItM8eY1mrJLbQe3wDy1jsUJUM0hIE/KVngMMieFg
         MfVJsTr42DKo77ueuv7ueUjv1i24csbInwKNttt21GIR3rCXUPLGOeCvM8yqwX+yKK
         0qHQoli+MaiKAPB/im11OIbnWtfj6WCdepZgtqcSlc7z4kxeWVIDxo1mJvWH9QiW+3
         9KDbbwylHagdbGM3ovT9UAF30uISy0BFynI+XX1ksmBzKc+O3+8q2g7FceIuayLaOR
         /WuGDKHl8+qEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nirenjan Krishnan <nirenjan@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/29] HID: quirks: Set INCREMENT_USAGE_ON_DUPLICATE for Saitek X65
Date:   Mon,  7 Jun 2021 12:13:43 -0400
Message-Id: <20210607161410.3584036-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirenjan Krishnan <nirenjan@gmail.com>

[ Upstream commit 25bdbfbb2d8331a67824dd03d0087e9c98835f3a ]

The Saitek X65 joystick has a pair of axes that were used as mouse
pointer controls by the Windows driver. The corresponding usage page is
the Game Controls page, which is not recognized by the generic HID
driver, and therefore, both axes get mapped to ABS_MISC. The quirk makes
the second axis get mapped to ABS_MISC+1, and therefore made available
separately.

Signed-off-by: Nirenjan Krishnan <nirenjan@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 1bfa690143d7..ec1b9555d10e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1028,6 +1028,7 @@
 #define USB_DEVICE_ID_SAITEK_X52	0x075c
 #define USB_DEVICE_ID_SAITEK_X52_2	0x0255
 #define USB_DEVICE_ID_SAITEK_X52_PRO	0x0762
+#define USB_DEVICE_ID_SAITEK_X65	0x0b6a
 
 #define USB_VENDOR_ID_SAMSUNG		0x0419
 #define USB_DEVICE_ID_SAMSUNG_IR_REMOTE	0x0001
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index f35d919c4eba..4e7a89790746 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -158,6 +158,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X52), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X52_2), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X52_PRO), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X65), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SEMICO, USB_DEVICE_ID_SEMICO_USB_KEYKOARD2), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SEMICO, USB_DEVICE_ID_SEMICO_USB_KEYKOARD), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SENNHEISER, USB_DEVICE_ID_SENNHEISER_BTD500USB), HID_QUIRK_NOGET },
-- 
2.30.2

