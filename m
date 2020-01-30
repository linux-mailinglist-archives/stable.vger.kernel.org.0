Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C71D814E1CB
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbgA3Sri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:47:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731157AbgA3Sri (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:47:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3D4120674;
        Thu, 30 Jan 2020 18:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410057;
        bh=wHPonvutOoxd/qL4Er+BAu1NwV+YwyWbafCbpcSJIzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oq10pmOkkemwwj7iiJdmHPrW8DXXF1JpWbDiFv+XszW1N0oM3nYSXQgsNn/UaRhtz
         LUnU99LNLdvcoGiu9QrCfJaPJOkqvlSVGfG5gGw8KP/l58k26QR029MNxGs3k8myhj
         m/LAzClaBtTC21+TGtVbN4qtKI8Bxwj2kYEqSoxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Balan <admin@kryma.net>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/55] HID: Add quirk for incorrect input length on Lenovo Y720
Date:   Thu, 30 Jan 2020 19:39:10 +0100
Message-Id: <20200130183613.975173189@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Balan <admin@kryma.net>

[ Upstream commit fd0913768701612fc2b8ab9c8a5c019133e8d978 ]

Apply it to the Lenovo Y720 gaming laptop I2C peripheral then.

This fixes dmesg being flooded with errors visible on un-suspend
in Linux Mint 19 Cinnamon.

Example of error log:

<...>
[    4.326588] i2c_hid i2c-ITE33D1:00: i2c_hid_get_input: incomplete report (2/4)
[    4.326845] i2c_hid i2c-ITE33D1:00: i2c_hid_get_input: incomplete report (2/4)
[    4.327095] i2c_hid i2c-ITE33D1:00: i2c_hid_get_input: incomplete report (2/4)
[    4.327341] i2c_hid i2c-ITE33D1:00: i2c_hid_get_input: incomplete report (2/4)
[    4.327609] i2c_hid i2c-ITE33D1:00: i2c_hid_get_input: incomplete report (2/4)
<...>

Example of fixed log (debug on)

<...>
[ 3731.333183] i2c_hid i2c-ITE33D1:00: input: 02 00
[ 3731.333581] i2c_hid i2c-ITE33D1:00: input: 02 00
[ 3731.333842] i2c_hid i2c-ITE33D1:00: input: 02 00
[ 3731.334107] i2c_hid i2c-ITE33D1:00: input: 02 00
[ 3731.334367] i2c_hid i2c-ITE33D1:00: input: 02 00
<...>

[jkosina@suse.cz: rebase onto more recent codebase]
Signed-off-by: Pavel Balan <admin@kryma.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h              |  1 +
 drivers/hid/i2c-hid/i2c-hid-core.c | 16 +++++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 03d65b6910673..f491092f36ff9 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -620,6 +620,7 @@
 #define USB_VENDOR_ID_ITE               0x048d
 #define USB_DEVICE_ID_ITE_LENOVO_YOGA   0x8386
 #define USB_DEVICE_ID_ITE_LENOVO_YOGA2  0x8350
+#define I2C_DEVICE_ID_ITE_LENOVO_LEGION_Y720	0x837a
 #define USB_DEVICE_ID_ITE_LENOVO_YOGA900	0x8396
 #define USB_DEVICE_ID_ITE8595		0x8595
 
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 0a39e444e3080..f2c8c59fc5823 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -52,6 +52,8 @@
 #define I2C_HID_QUIRK_DELAY_AFTER_SLEEP		BIT(3)
 #define I2C_HID_QUIRK_BOGUS_IRQ			BIT(4)
 #define I2C_HID_QUIRK_RESET_ON_RESUME		BIT(5)
+#define I2C_HID_QUIRK_BAD_INPUT_SIZE		BIT(6)
+
 
 /* flags */
 #define I2C_HID_STARTED		0
@@ -185,6 +187,8 @@ static const struct i2c_hid_quirks {
 		 I2C_HID_QUIRK_BOGUS_IRQ },
 	{ USB_VENDOR_ID_ALPS_JP, HID_ANY_ID,
 		 I2C_HID_QUIRK_RESET_ON_RESUME },
+	{ USB_VENDOR_ID_ITE, I2C_DEVICE_ID_ITE_LENOVO_LEGION_Y720,
+		I2C_HID_QUIRK_BAD_INPUT_SIZE },
 	{ 0, 0 }
 };
 
@@ -516,9 +520,15 @@ static void i2c_hid_get_input(struct i2c_hid *ihid)
 	}
 
 	if ((ret_size > size) || (ret_size < 2)) {
-		dev_err(&ihid->client->dev, "%s: incomplete report (%d/%d)\n",
-			__func__, size, ret_size);
-		return;
+		if (ihid->quirks & I2C_HID_QUIRK_BAD_INPUT_SIZE) {
+			ihid->inbuf[0] = size & 0xff;
+			ihid->inbuf[1] = size >> 8;
+			ret_size = size;
+		} else {
+			dev_err(&ihid->client->dev, "%s: incomplete report (%d/%d)\n",
+				__func__, size, ret_size);
+			return;
+		}
 	}
 
 	i2c_hid_dbg(ihid, "input: %*ph\n", ret_size, ihid->inbuf);
-- 
2.20.1



