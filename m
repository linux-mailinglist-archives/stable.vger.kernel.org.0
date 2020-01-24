Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB9E614764D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbgAXBRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:17:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730738AbgAXBRq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 20:17:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1E5F21D7D;
        Fri, 24 Jan 2020 01:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579828665;
        bh=AFL1qKM9zkNwovEGBFMBJ83gzXsaN62cIGTEMx7HV5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFaCsm1xGJWHMbaV+PzJddlnZzgqL6XK+MiZBte7gfYwIZ4dKuHEu+AcckrutMRa7
         EQWzWQKaq6oQN9HC16mSFYczebEaTNqjqCYCzaXzpHWnRB6yFdmfM07C2GcrxLeMJ2
         2m+nACtf7QQPRAa9zFpsfWXWLP/wDCFl/YVND0sc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Balan <admin@kryma.net>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 32/33] HID: Add quirk for incorrect input length on Lenovo Y720
Date:   Thu, 23 Jan 2020 20:17:07 -0500
Message-Id: <20200124011708.18232-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124011708.18232-1-sashal@kernel.org>
References: <20200124011708.18232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c99d56308fbc9..df786df0c0ab9 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -631,6 +631,7 @@
 #define USB_VENDOR_ID_ITE               0x048d
 #define USB_DEVICE_ID_ITE_LENOVO_YOGA   0x8386
 #define USB_DEVICE_ID_ITE_LENOVO_YOGA2  0x8350
+#define I2C_DEVICE_ID_ITE_LENOVO_LEGION_Y720	0x837a
 #define USB_DEVICE_ID_ITE_LENOVO_YOGA900	0x8396
 #define USB_DEVICE_ID_ITE8595		0x8595
 
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index ac44bf752ff1f..479934f7d2411 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -49,6 +49,8 @@
 #define I2C_HID_QUIRK_NO_IRQ_AFTER_RESET	BIT(1)
 #define I2C_HID_QUIRK_BOGUS_IRQ			BIT(4)
 #define I2C_HID_QUIRK_RESET_ON_RESUME		BIT(5)
+#define I2C_HID_QUIRK_BAD_INPUT_SIZE		BIT(6)
+
 
 /* flags */
 #define I2C_HID_STARTED		0
@@ -177,6 +179,8 @@ static const struct i2c_hid_quirks {
 		 I2C_HID_QUIRK_BOGUS_IRQ },
 	{ USB_VENDOR_ID_ALPS_JP, HID_ANY_ID,
 		 I2C_HID_QUIRK_RESET_ON_RESUME },
+	{ USB_VENDOR_ID_ITE, I2C_DEVICE_ID_ITE_LENOVO_LEGION_Y720,
+		I2C_HID_QUIRK_BAD_INPUT_SIZE },
 	{ 0, 0 }
 };
 
@@ -498,9 +502,15 @@ static void i2c_hid_get_input(struct i2c_hid *ihid)
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

