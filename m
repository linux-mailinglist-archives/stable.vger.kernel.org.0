Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F2CEEC80
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388615AbfKDV5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:57:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:54056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387932AbfKDV5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:57:40 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5BCD20659;
        Mon,  4 Nov 2019 21:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904659;
        bh=DNsavMn9AsrBUB0Q82v+6fzdVdaj+YGTYgPJXT7NkOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yPyY7h2KPjael/8z/i2BUwzFxsW252U7UC+cTq9VWC1uwgb/3+2KgLEzkh5AxxA/Y
         y2yLjWVMYYihBPUUz/7M/F+NnJ9jZIgyho48aJ3Z7EHJPLFcoYcUo+VsDCiYUA6j8L
         jRgNftuVQtcF38ElYS7Mk13SjnLeHMbSDz9zZEew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 024/149] HID: i2c-hid: Disable runtime PM for LG touchscreen
Date:   Mon,  4 Nov 2019 22:43:37 +0100
Message-Id: <20191104212137.429614542@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 86c31524b27c7e686841dd4a79eda95cfd989f16 ]

LG touchscreen (1fd2:8001) stops working after reboot:
[ 4.859153] i2c_hid i2c-SAPS2101:00: i2c_hid_get_input: incomplete report (64/66)
[ 4.936070] i2c_hid i2c-SAPS2101:00: i2c_hid_get_input: incomplete report (64/66)
[ 9.948224] i2c_hid i2c-SAPS2101:00: failed to reset device.

The device in question stops working after receives SLEEP, ON, SLEEP
commands in a short period. The scenario is like this:
- Once the desktop session closes, it also closed the hid device, so the
device gets runtime suspended and receives a SLEEP command.
- Before calling shutdown callback, it gets runtime resumed and received
an ON command.
- In the shutdown callback, it receives another SLEEP command.

I failed to find a reliable interval between ON/SLEEP commands that can
make it work, so let's simply disable runtime PM for the device.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h              | 1 +
 drivers/hid/i2c-hid/i2c-hid-core.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 0eeb273fb73d2..6b33117ca60e5 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -713,6 +713,7 @@
 #define USB_VENDOR_ID_LG		0x1fd2
 #define USB_DEVICE_ID_LG_MULTITOUCH	0x0064
 #define USB_DEVICE_ID_LG_MELFAS_MT	0x6007
+#define I2C_DEVICE_ID_LG_8001		0x8001
 
 #define USB_VENDOR_ID_LOGITECH		0x046d
 #define USB_DEVICE_ID_LOGITECH_AUDIOHUB 0x0a0e
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 3cde7c1b9c33c..8555ce7e737b3 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -177,6 +177,8 @@ static const struct i2c_hid_quirks {
 		I2C_HID_QUIRK_NO_RUNTIME_PM },
 	{ I2C_VENDOR_ID_RAYDIUM, I2C_PRODUCT_ID_RAYDIUM_4B33,
 		I2C_HID_QUIRK_DELAY_AFTER_SLEEP },
+	{ USB_VENDOR_ID_LG, I2C_DEVICE_ID_LG_8001,
+		I2C_HID_QUIRK_NO_RUNTIME_PM },
 	{ 0, 0 }
 };
 
-- 
2.20.1



