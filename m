Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE1F14502B
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388036AbgAVJoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:44:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387776AbgAVJoX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:44:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9BA52468B;
        Wed, 22 Jan 2020 09:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686263;
        bh=gEMbZSf7gz/38fyK2S0QNO50FzA33PkIo6Ay1nYgqT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DycamOghaO5tOni2q2frO4wY1bwON5mcQx4ubgFpau2LrdbtLlVjvrXPZPyemXkj2
         WS39eBtVkKyE2UVjQjaLd9L/4ZaNAFyZLEIlrD8lkeHtiphGA6OVfl+alydLvJKuG/
         6+891UYq+xhPUC5NpsLtAuR6KcR0mf6TbypY7L2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 103/103] hwmon: (pmbus/ibm-cffps) Switch LEDs to blocking brightness call
Date:   Wed, 22 Jan 2020 10:29:59 +0100
Message-Id: <20200122092817.056849882@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
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
@@ -269,8 +269,8 @@ static int ibm_cffps_read_word_data(stru
 	return rc;
 }
 
-static void ibm_cffps_led_brightness_set(struct led_classdev *led_cdev,
-					 enum led_brightness brightness)
+static int ibm_cffps_led_brightness_set(struct led_classdev *led_cdev,
+					enum led_brightness brightness)
 {
 	int rc;
 	struct ibm_cffps *psu = container_of(led_cdev, struct ibm_cffps, led);
@@ -286,9 +286,11 @@ static void ibm_cffps_led_brightness_set
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
@@ -324,7 +326,7 @@ static void ibm_cffps_create_led_class(s
 		 client->addr);
 	psu->led.name = psu->led_name;
 	psu->led.max_brightness = LED_FULL;
-	psu->led.brightness_set = ibm_cffps_led_brightness_set;
+	psu->led.brightness_set_blocking = ibm_cffps_led_brightness_set;
 	psu->led.blink_set = ibm_cffps_led_blink_set;
 
 	rc = devm_led_classdev_register(dev, &psu->led);


