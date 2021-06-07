Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFC339E244
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhFGQQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232000AbhFGQPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:15:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACD2C61405;
        Mon,  7 Jun 2021 16:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082402;
        bh=8NROY7982HeFSxDEn9mkhUirj3sifUv/lZZ+MmRV36g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=if/2X7twSChJ9nKEJjvRkcscY/9qrk+8Fh2FUsFUwS9Lra9mLxDBJ8pcjtCl8cyu7
         CUFcaNpZxLxBKSKJhrDohlq8ozoR2Z5238YI/6EDk43OmyspOK610pHE5PnduAxxa8
         G1juaXM/REwnZ4pgaQXNGNLUMhbMNyk1t4wj2XHoSSWvagN5PB2BQi0tq2LzXyzm7I
         dqzfUAW8IA35i2rB86uzJNmZGY/6I1TiirzzGdW3PsEDfEy4Pyp6EVC+oc6R+99Ooc
         XzxJzubY8KGfrduqepzgpKX1KkHDeLg9OFuSmM0V7OILZRGaLc3USSXPr6RI4WQxme
         ytTmyw9oKry3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nirenjan Krishnan <nirenjan@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 02/39] HID: quirks: Set INCREMENT_USAGE_ON_DUPLICATE for Saitek X65
Date:   Mon,  7 Jun 2021 12:12:41 -0400
Message-Id: <20210607161318.3583636-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
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
index e220a05a05b4..c2e0c65b111b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1034,6 +1034,7 @@
 #define USB_DEVICE_ID_SAITEK_X52	0x075c
 #define USB_DEVICE_ID_SAITEK_X52_2	0x0255
 #define USB_DEVICE_ID_SAITEK_X52_PRO	0x0762
+#define USB_DEVICE_ID_SAITEK_X65	0x0b6a
 
 #define USB_VENDOR_ID_SAMSUNG		0x0419
 #define USB_DEVICE_ID_SAMSUNG_IR_REMOTE	0x0001
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 2e38340e19df..2bda94199aaf 100644
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

