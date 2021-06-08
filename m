Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A353B3A00C5
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235537AbhFHSrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:47:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235813AbhFHSpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:45:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BA1E613E7;
        Tue,  8 Jun 2021 18:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177416;
        bh=aIVceECrece3lKh6IYH5h0B+zZvoHSSwcqkerJK00yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OkhpeRb0SUpzhuC3zgUq/DE9DEVSoEYzrFM+HAbW5qRDadooW/9OAvdyKd7kUzAt1
         6WEoaqf5V7DW670wSjdG0wp4t6RNiX+jS6GmG2v3+jcL5nznXI4xNem2Qy+yjOig6U
         fi+XP87OL/Vepm4IcLCjnwOHUGmPLWCaWnvxKgZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johnny Chuang <johnny.chuang.emc@gmail.com>,
        Harry Cutts <hcutts@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.4 44/78] HID: i2c-hid: Skip ELAN power-on command after reset
Date:   Tue,  8 Jun 2021 20:27:13 +0200
Message-Id: <20210608175936.753729257@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johnny Chuang <johnny.chuang.emc@gmail.com>

commit ca66a6770bd9d6d99e469debd1c7363ac455daf9 upstream.

For ELAN touchscreen, we found our boot code of IC was not flexible enough
to receive and handle this command.
Once the FW main code of our controller is crashed for some reason,
the controller could not be enumerated successfully to be recognized
by the system host. therefore, it lost touch functionality.

Add quirk for skip send power-on command after reset.
It will impact to ELAN touchscreen and touchpad on HID over I2C projects.

Fixes: 43b7029f475e ("HID: i2c-hid: Send power-on command after reset").

Cc: stable@vger.kernel.org
Signed-off-by: Johnny Chuang <johnny.chuang.emc@gmail.com>
Reviewed-by: Harry Cutts <hcutts@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -50,6 +50,7 @@
 #define I2C_HID_QUIRK_BOGUS_IRQ			BIT(4)
 #define I2C_HID_QUIRK_RESET_ON_RESUME		BIT(5)
 #define I2C_HID_QUIRK_BAD_INPUT_SIZE		BIT(6)
+#define I2C_HID_QUIRK_NO_WAKEUP_AFTER_RESET	BIT(7)
 
 
 /* flags */
@@ -185,6 +186,11 @@ static const struct i2c_hid_quirks {
 		 I2C_HID_QUIRK_RESET_ON_RESUME },
 	{ USB_VENDOR_ID_ITE, I2C_DEVICE_ID_ITE_LENOVO_LEGION_Y720,
 		I2C_HID_QUIRK_BAD_INPUT_SIZE },
+	/*
+	 * Sending the wakeup after reset actually break ELAN touchscreen controller
+	 */
+	{ USB_VENDOR_ID_ELAN, HID_ANY_ID,
+		 I2C_HID_QUIRK_NO_WAKEUP_AFTER_RESET },
 	{ 0, 0 }
 };
 
@@ -468,7 +474,8 @@ static int i2c_hid_hwreset(struct i2c_cl
 	}
 
 	/* At least some SIS devices need this after reset */
-	ret = i2c_hid_set_power(client, I2C_HID_PWR_ON);
+	if (!(ihid->quirks & I2C_HID_QUIRK_NO_WAKEUP_AFTER_RESET))
+		ret = i2c_hid_set_power(client, I2C_HID_PWR_ON);
 
 out_unlock:
 	mutex_unlock(&ihid->reset_lock);


