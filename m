Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFADD333E65
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbhCJN0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:47046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233282AbhCJNZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBF6164FF6;
        Wed, 10 Mar 2021 13:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382717;
        bh=xlKZADZowqjonhakEuVUhDKq3MlV1MdeGYf7cDLsMFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m0xQSwXg1S2v+U42P1mLEwNbe85m5TuFepMFvfl9rTbAC3q5P2ymu5bwCexn2MD1X
         0ZwmywXNfmojFUNBYCGeTpoUzAXkvqLrSfQl4/bDOIngVfVmQ/FrYuSLsFhUoSfrog
         CDhypSoL2YZirJgV1vyHY7dX+UqWsxKttUUAHiyc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/49] HID: i2c-hid: Add I2C_HID_QUIRK_NO_IRQ_AFTER_RESET for ITE8568 EC on Voyo Winpad A15
Date:   Wed, 10 Mar 2021 14:23:51 +0100
Message-Id: <20210310132323.216679445@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
index 4b0033d48863..06813f297dcc 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -639,6 +639,8 @@
 #define USB_DEVICE_ID_INNEX_GENESIS_ATARI	0x4745
 
 #define USB_VENDOR_ID_ITE               0x048d
+#define I2C_VENDOR_ID_ITE		0x103c
+#define I2C_DEVICE_ID_ITE_VOYO_WINPAD_A15	0x184f
 #define USB_DEVICE_ID_ITE_LENOVO_YOGA   0x8386
 #define USB_DEVICE_ID_ITE_LENOVO_YOGA2  0x8350
 #define I2C_DEVICE_ID_ITE_LENOVO_LEGION_Y720	0x837a
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index aeff1ffb0c8b..cb7758d59014 100644
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



