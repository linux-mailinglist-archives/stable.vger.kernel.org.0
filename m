Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C0D1456A4
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgAVN2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:28:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730266AbgAVN2S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:28:18 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D48512071E;
        Wed, 22 Jan 2020 13:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699697;
        bh=ja63mQTeTWmf6LIxLrZKkAvOkCsQUOyH+pMv6e6ZBNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hyVxTOQ3CKJL5U4BLWdFOoleYWKvii4bHUSLrAdksUvZLRSOd5DOEIUr2N0y5mhAm
         QNompD6di7xzMwyrK25Gq+Zod9xQf6sF6hqJlvhsxpLdvVnX5BJSgH0l6tRU/2hO3E
         m/p0w9zALNUc2o/iEpBDRXXnnSeGjgHK4wTM8SIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 221/222] hwmon: (pmbus/ibm-cffps) Switch LEDs to blocking brightness call
Date:   Wed, 22 Jan 2020 10:30:07 +0100
Message-Id: <20200122092849.507081748@linuxfoundation.org>
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

commit 9861ff954c7e83e2f738ce16fbe15f8a1e121771 upstream.

Since i2c_smbus functions can sleep, the brightness setting function
for this driver must be the blocking version to avoid scheduling while
atomic.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20191106200106.29519-2-eajames@linux.ibm.com
Fixes: ef9e1cdf419a3 ("hwmon: (pmbus/cffps) Add led class device for power supply fault led")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/pmbus/ibm-cffps.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/pmbus/ibm-cffps.c
+++ b/drivers/hwmon/pmbus/ibm-cffps.c
@@ -292,8 +292,8 @@ static int ibm_cffps_read_word_data(stru
 	return rc;
 }
 
-static void ibm_cffps_led_brightness_set(struct led_classdev *led_cdev,
-					 enum led_brightness brightness)
+static int ibm_cffps_led_brightness_set(struct led_classdev *led_cdev,
+					enum led_brightness brightness)
 {
 	int rc;
 	struct ibm_cffps *psu = container_of(led_cdev, struct ibm_cffps, led);
@@ -311,9 +311,11 @@ static void ibm_cffps_led_brightness_set
 	rc = i2c_smbus_write_byte_data(psu->client, CFFPS_SYS_CONFIG_CMD,
 				       psu->led_state);
 	if (rc < 0)
-		return;
+		return rc;
 
 	led_cdev->brightness = brightness;
+
+	return 0;
 }
 
 static int ibm_cffps_led_blink_set(struct led_classdev *led_cdev,
@@ -351,7 +353,7 @@ static void ibm_cffps_create_led_class(s
 		 client->addr);
 	psu->led.name = psu->led_name;
 	psu->led.max_brightness = LED_FULL;
-	psu->led.brightness_set = ibm_cffps_led_brightness_set;
+	psu->led.brightness_set_blocking = ibm_cffps_led_brightness_set;
 	psu->led.blink_set = ibm_cffps_led_blink_set;
 
 	rc = devm_led_classdev_register(dev, &psu->led);


