Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA2991456A7
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgAVN2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:28:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729475AbgAVN2V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:28:21 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD745205F4;
        Wed, 22 Jan 2020 13:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699700;
        bh=B0o91/X1hA5pHnJBim6slfSMQUUad8ZS+O7ujX7kfsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wF+/ZCs5qV69Ha5k4OmTzv5Vu0ONF7eUS5mtJluHSUU7iJAGkX0UPZ2UAx1F/GSHT
         dv2bFctAWHYDY0M61wbYkeg1pfTpFasKwLkqw4XI71nj/HRMuDgCjcjWLFVWZrXaGn
         PVLq/Xm2QeD4cwtGqtwemUlTreIOiwVm9DuCnRzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 222/222] hwmon: (pmbus/ibm-cffps) Fix LED blink behavior
Date:   Wed, 22 Jan 2020 10:30:08 +0100
Message-Id: <20200122092849.577706593@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

commit 92b39ad440968bab38eb6577d63c12994601ed94 upstream.

The LED blink_set function incorrectly did not tell the PSU LED to blink
if brightness was LED_OFF. Fix this, and also correct the LED_OFF
command data, which should give control of the LED back to the PSU
firmware. Also prevent I2C failures from getting the driver LED state
out of sync and add some dev_dbg statements.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20191106200106.29519-3-eajames@linux.ibm.com
Fixes: ef9e1cdf419a3 ("hwmon: (pmbus/cffps) Add led class device for power supply fault led")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/pmbus/ibm-cffps.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/drivers/hwmon/pmbus/ibm-cffps.c
+++ b/drivers/hwmon/pmbus/ibm-cffps.c
@@ -39,9 +39,13 @@
 #define CFFPS_MFR_VAUX_FAULT			BIT(6)
 #define CFFPS_MFR_CURRENT_SHARE_WARNING		BIT(7)
 
+/*
+ * LED off state actually relinquishes LED control to PSU firmware, so it can
+ * turn on the LED for faults.
+ */
+#define CFFPS_LED_OFF				0
 #define CFFPS_LED_BLINK				BIT(0)
 #define CFFPS_LED_ON				BIT(1)
-#define CFFPS_LED_OFF				BIT(2)
 #define CFFPS_BLINK_RATE_MS			250
 
 enum {
@@ -296,23 +300,31 @@ static int ibm_cffps_led_brightness_set(
 					enum led_brightness brightness)
 {
 	int rc;
+	u8 next_led_state;
 	struct ibm_cffps *psu = container_of(led_cdev, struct ibm_cffps, led);
 
 	if (brightness == LED_OFF) {
-		psu->led_state = CFFPS_LED_OFF;
+		next_led_state = CFFPS_LED_OFF;
 	} else {
 		brightness = LED_FULL;
+
 		if (psu->led_state != CFFPS_LED_BLINK)
-			psu->led_state = CFFPS_LED_ON;
+			next_led_state = CFFPS_LED_ON;
+		else
+			next_led_state = CFFPS_LED_BLINK;
 	}
 
+	dev_dbg(&psu->client->dev, "LED brightness set: %d. Command: %d.\n",
+		brightness, next_led_state);
+
 	pmbus_set_page(psu->client, 0);
 
 	rc = i2c_smbus_write_byte_data(psu->client, CFFPS_SYS_CONFIG_CMD,
-				       psu->led_state);
+				       next_led_state);
 	if (rc < 0)
 		return rc;
 
+	psu->led_state = next_led_state;
 	led_cdev->brightness = brightness;
 
 	return 0;
@@ -325,10 +337,7 @@ static int ibm_cffps_led_blink_set(struc
 	int rc;
 	struct ibm_cffps *psu = container_of(led_cdev, struct ibm_cffps, led);
 
-	psu->led_state = CFFPS_LED_BLINK;
-
-	if (led_cdev->brightness == LED_OFF)
-		return 0;
+	dev_dbg(&psu->client->dev, "LED blink set.\n");
 
 	pmbus_set_page(psu->client, 0);
 
@@ -337,6 +346,8 @@ static int ibm_cffps_led_blink_set(struc
 	if (rc < 0)
 		return rc;
 
+	psu->led_state = CFFPS_LED_BLINK;
+	led_cdev->brightness = LED_FULL;
 	*delay_on = CFFPS_BLINK_RATE_MS;
 	*delay_off = CFFPS_BLINK_RATE_MS;
 


