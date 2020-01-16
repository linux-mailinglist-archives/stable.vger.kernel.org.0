Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 884E813E5DC
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390871AbgAPRN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:13:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:60194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390483AbgAPRN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:13:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E9EA2469E;
        Thu, 16 Jan 2020 17:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194836;
        bh=sjHvgJ//A5YxuNMWW1rGYSdxOcYiKmPBLe0uvbj0XZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2srN3Sd6NH2K8VBYJm1FJcxE4EkRtsRmFq3E9A5AMRsR+ujXaukEnqSCxnoTk9Cpj
         gAYn8osmIckuYA1K01I6g3ktamfzYb/eFlPLQHVdJzPeUVkw++XuUqgjEqtwiVldJk
         kAgFYqgCtI0bbQhrSxh5vhsztVCrA4YjPimCSjUc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 636/671] hwmon: (pmbus/ibm-cffps) Switch LEDs to blocking brightness call
Date:   Thu, 16 Jan 2020 12:04:34 -0500
Message-Id: <20200116170509.12787-373-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
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
index 93d9a9ea112b..edc70ac7d2d0 100644
--- a/drivers/hwmon/pmbus/ibm-cffps.c
+++ b/drivers/hwmon/pmbus/ibm-cffps.c
@@ -269,8 +269,8 @@ static int ibm_cffps_read_word_data(struct i2c_client *client, int page,
 	return rc;
 }
 
-static void ibm_cffps_led_brightness_set(struct led_classdev *led_cdev,
-					 enum led_brightness brightness)
+static int ibm_cffps_led_brightness_set(struct led_classdev *led_cdev,
+					enum led_brightness brightness)
 {
 	int rc;
 	struct ibm_cffps *psu = container_of(led_cdev, struct ibm_cffps, led);
@@ -286,9 +286,11 @@ static void ibm_cffps_led_brightness_set(struct led_classdev *led_cdev,
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
@@ -324,7 +326,7 @@ static void ibm_cffps_create_led_class(struct ibm_cffps *psu)
 		 client->addr);
 	psu->led.name = psu->led_name;
 	psu->led.max_brightness = LED_FULL;
-	psu->led.brightness_set = ibm_cffps_led_brightness_set;
+	psu->led.brightness_set_blocking = ibm_cffps_led_brightness_set;
 	psu->led.blink_set = ibm_cffps_led_blink_set;
 
 	rc = devm_led_classdev_register(dev, &psu->led);
-- 
2.20.1

