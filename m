Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44087DD424
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391523AbfJRWWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730474AbfJRWF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:05:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 315DC20679;
        Fri, 18 Oct 2019 22:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436355;
        bh=DNsavMn9AsrBUB0Q82v+6fzdVdaj+YGTYgPJXT7NkOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToRknfFaDN8qFJlOfPaWFGHmlxojdaylXqnpgOgYqgg2FohK89XYt5BPFqfe5LoqT
         rAwKcpNkW2ywa79sxsCPQhfSH3UmviXgPmCP+qpbW0wff/k3xgIHCDEek7IAtRf+1P
         srNslYM/gQCkDUTWKPA5MVpA4WXXXBHXX0HMIWjc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 017/100] HID: i2c-hid: Disable runtime PM for LG touchscreen
Date:   Fri, 18 Oct 2019 18:04:02 -0400
Message-Id: <20191018220525.9042-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

