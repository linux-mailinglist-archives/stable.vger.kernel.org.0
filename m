Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D90EDD41E
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbfJRWGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:06:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730287AbfJRWGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A11E205F4;
        Fri, 18 Oct 2019 22:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436359;
        bh=pSHZH/4w3nOlLE17v+y+HwO+fJvTz+CXttg0x1Q+dhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WapOEtKA0+7gNdiaX3yJgvv0QOcOJlV8C3k4dM+rvmDmy8BQOksOLVnWxSE4Cn57e
         SotgrAVlp47dbZ8sEBnlLQbaTNxIxtPRaeUQ4uNt9Tuja9ZV7Ch0SJEwqZX5ijoP5c
         eJ6vue+vM+a963soJ1Dx60kDtH23nR9rmMsSXa90=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 018/100] HID: i2c-hid: Ignore input report if there's no data present on Elan touchpanels
Date:   Fri, 18 Oct 2019 18:04:03 -0400
Message-Id: <20191018220525.9042-18-sashal@kernel.org>
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

[ Upstream commit 1475af255e18f35dc46f8a7acc18354c73d45149 ]

While using Elan touchpads, the message floods:
[  136.138487] i2c_hid i2c-DELL08D6:00: i2c_hid_get_input: incomplete report (14/65535)

Though the message flood is annoying, the device it self works without
any issue. I suspect that the device in question takes too much time to
pull the IRQ back to high after I2C host has done reading its data.

Since the host receives all useful data, let's ignore the input report
when there's no data.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 8555ce7e737b3..2f940c1de6169 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -50,6 +50,7 @@
 #define I2C_HID_QUIRK_NO_IRQ_AFTER_RESET	BIT(1)
 #define I2C_HID_QUIRK_NO_RUNTIME_PM		BIT(2)
 #define I2C_HID_QUIRK_DELAY_AFTER_SLEEP		BIT(3)
+#define I2C_HID_QUIRK_BOGUS_IRQ			BIT(4)
 
 /* flags */
 #define I2C_HID_STARTED		0
@@ -179,6 +180,8 @@ static const struct i2c_hid_quirks {
 		I2C_HID_QUIRK_DELAY_AFTER_SLEEP },
 	{ USB_VENDOR_ID_LG, I2C_DEVICE_ID_LG_8001,
 		I2C_HID_QUIRK_NO_RUNTIME_PM },
+	{ USB_VENDOR_ID_ELAN, HID_ANY_ID,
+		 I2C_HID_QUIRK_BOGUS_IRQ },
 	{ 0, 0 }
 };
 
@@ -503,6 +506,12 @@ static void i2c_hid_get_input(struct i2c_hid *ihid)
 		return;
 	}
 
+	if (ihid->quirks & I2C_HID_QUIRK_BOGUS_IRQ && ret_size == 0xffff) {
+		dev_warn_once(&ihid->client->dev, "%s: IRQ triggered but "
+			      "there's no data\n", __func__);
+		return;
+	}
+
 	if ((ret_size > size) || (ret_size < 2)) {
 		dev_err(&ihid->client->dev, "%s: incomplete report (%d/%d)\n",
 			__func__, size, ret_size);
-- 
2.20.1

