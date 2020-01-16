Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 312A213F96D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbgAPTY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:24:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:35864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728898AbgAPQwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:52:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0184205F4;
        Thu, 16 Jan 2020 16:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193560;
        bh=JgnKv5qtm9Jl4MrO1BVLyEM5NkFXfJa8YpVsvA5uuds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOCgmMUXdAmM4/ll+uhZuV2uPEc7Fa71OquQlPLVvK8NlJ5L/dUwAF440Dz1kr26R
         3XqJlIZBin0yPxC3y+rVPGWgkT7b2ADjWSncWTbfUSR73QCM6rE0Xe6/8+Qu2LmEX4
         9PveBegS8ifok+N2TgYOs4pbSHXNtG6BUE89WZEs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 105/205] hwmon: (pmbus/ibm-cffps) Switch LEDs to blocking brightness call
Date:   Thu, 16 Jan 2020 11:41:20 -0500
Message-Id: <20200116164300.6705-105-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 9861ff954c7e83e2f738ce16fbe15f8a1e121771 ]

Since i2c_smbus functions can sleep, the brightness setting function
for this driver must be the blocking version to avoid scheduling while
atomic.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20191106200106.29519-2-eajames@linux.ibm.com
Fixes: ef9e1cdf419a3 ("hwmon: (pmbus/cffps) Add led class device for power supply fault led")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/ibm-cffps.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/pmbus/ibm-cffps.c b/drivers/hwmon/pmbus/ibm-cffps.c
index d44745e498e7..aa4cdbbb100a 100644
--- a/drivers/hwmon/pmbus/ibm-cffps.c
+++ b/drivers/hwmon/pmbus/ibm-cffps.c
@@ -292,8 +292,8 @@ static int ibm_cffps_read_word_data(struct i2c_client *client, int page,
 	return rc;
 }
 
-static void ibm_cffps_led_brightness_set(struct led_classdev *led_cdev,
-					 enum led_brightness brightness)
+static int ibm_cffps_led_brightness_set(struct led_classdev *led_cdev,
+					enum led_brightness brightness)
 {
 	int rc;
 	struct ibm_cffps *psu = container_of(led_cdev, struct ibm_cffps, led);
@@ -311,9 +311,11 @@ static void ibm_cffps_led_brightness_set(struct led_classdev *led_cdev,
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
@@ -351,7 +353,7 @@ static void ibm_cffps_create_led_class(struct ibm_cffps *psu)
 		 client->addr);
 	psu->led.name = psu->led_name;
 	psu->led.max_brightness = LED_FULL;
-	psu->led.brightness_set = ibm_cffps_led_brightness_set;
+	psu->led.brightness_set_blocking = ibm_cffps_led_brightness_set;
 	psu->led.blink_set = ibm_cffps_led_blink_set;
 
 	rc = devm_led_classdev_register(dev, &psu->led);
-- 
2.20.1

