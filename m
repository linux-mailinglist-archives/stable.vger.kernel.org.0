Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3926F32AF11
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhCCAOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:14:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244081AbhCBMAu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:00:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A41D64F23;
        Tue,  2 Mar 2021 11:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686157;
        bh=O8iCR+ufXG5da08A5k7EHS6L3ddwSAeFK1K1H7ZjOYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7Sef9u81IRqOPpdK12r6wESe8kMLJ7WetCc5m03NwjiwYpA/JvnO2EtQl0yZSNiw
         jNC2q3AhuVnQpZtuxwFLYL80CUmpXqPrdGDUqKwJJX5I7acIUXc4eOFWcTq8kQ4CfA
         g1sBwkWJhUGISO+um7/kJAXpm+8GTm5S8W0w7M5PY41pHgBsOHIiHNA+KawwlhTMla
         wZizsHsO/dW1RMiG6KMgc0u05LC+O11erYf5Ae/TAx5rIRyCmdGi0tfifwS29ctXSl
         SZU3PMaF5WKhJR5EN/PdgX6rHHaGrM5/HRU5XThDABolnNq0WcVHVST3+kfcIg9lvl
         TyBELEZXqYUpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 17/52] HID: i2c-hid: Add I2C_HID_QUIRK_NO_IRQ_AFTER_RESET for ITE8568 EC on Voyo Winpad A15
Date:   Tue,  2 Mar 2021 06:54:58 -0500
Message-Id: <20210302115534.61800-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit fc6a31b00739356809dd566e16f2c4325a63285d ]

The ITE8568 EC on the Voyo Winpad A15 presents itself as an I2C-HID
attached keyboard and mouse (which seems to never send any events).

This needs the I2C_HID_QUIRK_NO_IRQ_AFTER_RESET quirk, otherwise we get
the following errors:

[ 3688.770850] i2c_hid i2c-ITE8568:00: failed to reset device.
[ 3694.915865] i2c_hid i2c-ITE8568:00: failed to reset device.
[ 3701.059717] i2c_hid i2c-ITE8568:00: failed to reset device.
[ 3707.205944] i2c_hid i2c-ITE8568:00: failed to reset device.
[ 3708.227940] i2c_hid i2c-ITE8568:00: can't add hid device: -61
[ 3708.236518] i2c_hid: probe of i2c-ITE8568:00 failed with error -61

Which leads to a significant boot delay.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h              | 2 ++
 drivers/hid/i2c-hid/i2c-hid-core.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 5ba0aa1d2335..b60279aaed43 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -641,6 +641,8 @@
 #define USB_DEVICE_ID_INNEX_GENESIS_ATARI	0x4745
 
 #define USB_VENDOR_ID_ITE               0x048d
+#define I2C_VENDOR_ID_ITE		0x103c
+#define I2C_DEVICE_ID_ITE_VOYO_WINPAD_A15	0x184f
 #define USB_DEVICE_ID_ITE_LENOVO_YOGA   0x8386
 #define USB_DEVICE_ID_ITE_LENOVO_YOGA2  0x8350
 #define I2C_DEVICE_ID_ITE_LENOVO_LEGION_Y720	0x837a
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index bfe716d7ea44..c586acf2fc0b 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -171,6 +171,8 @@ static const struct i2c_hid_quirks {
 		I2C_HID_QUIRK_SET_PWR_WAKEUP_DEV },
 	{ I2C_VENDOR_ID_HANTICK, I2C_PRODUCT_ID_HANTICK_5288,
 		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
+	{ I2C_VENDOR_ID_ITE, I2C_DEVICE_ID_ITE_VOYO_WINPAD_A15,
+		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
 	{ I2C_VENDOR_ID_RAYDIUM, I2C_PRODUCT_ID_RAYDIUM_3118,
 		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
 	{ USB_VENDOR_ID_ELAN, HID_ANY_ID,
-- 
2.30.1

