Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DD33A6487
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbhFNL0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235960AbhFNLXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:23:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3ADA619A1;
        Mon, 14 Jun 2021 10:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667990;
        bh=VV28I5aePQigTmYHB7fwd+2+5YLuJASDqGsfPdHBZoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UeVzjvn3EM60Zz/+1uz5TVwl6L1dWOqilYPQY7v+WDo9YjW0C9A9UMgAA5cC3EKkU
         mZpwwmF00gLSCrYkEVzfeAHVpux7xWzXl+2SMWzhq/lAiUpsNKS1PJA1tXhT3PT6hH
         uohBIaba/WS/v+UM6ANdX/YsoCqTnmHE3l/9/YnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robert.marko@sartura.hr>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.12 135/173] hwmon: (tps23861) set current shunt value
Date:   Mon, 14 Jun 2021 12:27:47 +0200
Message-Id: <20210614102702.655392395@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Marko <robert.marko@sartura.hr>

commit b325d3526e14942d42c392c2ac9fbea59c22894c upstream.

TPS23861 has a configuration bit for setting of the
current shunt value used on the board.
Its bit 0 of the General Mask 1 register.

According to the datasheet bit values are:
0 for 255 mOhm (Default)
1 for 250 mOhm

So, configure the bit before registering the hwmon
device according to the value passed in the DTS or
default one if none is passed.

This caused potentially reading slightly skewed values
due to max current value being 1.02A when 250mOhm shunt
is used instead of 1.0A when 255mOhm is used.

Fixes: fff7b8ab2255 ("hwmon: add Texas Instruments TPS23861 driver")
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Link: https://lore.kernel.org/r/20210609220728.499879-2-robert.marko@sartura.hr
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/tps23861.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/hwmon/tps23861.c
+++ b/drivers/hwmon/tps23861.c
@@ -99,6 +99,9 @@
 #define POWER_ENABLE			0x19
 #define TPS23861_NUM_PORTS		4
 
+#define TPS23861_GENERAL_MASK_1		0x17
+#define TPS23861_CURRENT_SHUNT_MASK	BIT(0)
+
 #define TEMPERATURE_LSB			652 /* 0.652 degrees Celsius */
 #define VOLTAGE_LSB			3662 /* 3.662 mV */
 #define SHUNT_RESISTOR_DEFAULT		255000 /* 255 mOhm */
@@ -561,6 +564,15 @@ static int tps23861_probe(struct i2c_cli
 	else
 		data->shunt_resistor = SHUNT_RESISTOR_DEFAULT;
 
+	if (data->shunt_resistor == SHUNT_RESISTOR_DEFAULT)
+		regmap_clear_bits(data->regmap,
+				  TPS23861_GENERAL_MASK_1,
+				  TPS23861_CURRENT_SHUNT_MASK);
+	else
+		regmap_set_bits(data->regmap,
+				TPS23861_GENERAL_MASK_1,
+				TPS23861_CURRENT_SHUNT_MASK);
+
 	hwmon_dev = devm_hwmon_device_register_with_info(dev, client->name,
 							 data, &tps23861_chip_info,
 							 NULL);


