Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BF6420E32
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbhJDNWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:22:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236580AbhJDNUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:20:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9225561994;
        Mon,  4 Oct 2021 13:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352934;
        bh=4tqAWzyryKYmgALVAX8+oJ1ZlePLWu4Bus+uT4VdClg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSZqW1BkGheuUOAClHpq9O2ZWeHX8iIy2cO1DunyEM1I/ximJLopQ9e/bfUZGS+zX
         QW+Z8zL4isDolC0zSIFg3pxPADYbWof0CvFYpGHjUeg0ZvJLXd67ketLwtYIR4vaZU
         3/MCYfSYH8sbT8NheTDrJdiZvZ3U/wqIUoEDW8K8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Fertser <fercerpav@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 09/93] hwmon: (tmp421) handle I2C errors
Date:   Mon,  4 Oct 2021 14:52:07 +0200
Message-Id: <20211004125034.893357112@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Fertser <fercerpav@gmail.com>

commit 2938b2978a70d4cc10777ee71c9e512ffe4e0f4b upstream.

Function i2c_smbus_read_byte_data() can return a negative error number
instead of the data read if I2C transaction failed for whatever reason.

Lack of error checking can lead to serious issues on production
hardware, e.g. errors treated as temperatures produce spurious critical
temperature-crossed-threshold errors in BMC logs for OCP server
hardware. The patch was tested with Mellanox OCP Mezzanine card
emulating TMP421 protocol for temperature sensing which sometimes leads
to I2C protocol error during early boot up stage.

Fixes: 9410700b881f ("hwmon: Add driver for Texas Instruments TMP421/422/423 sensor chips")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Link: https://lore.kernel.org/r/20210924093011.26083-1-fercerpav@gmail.com
[groeck: dropped unnecessary line breaks]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/tmp421.c |   38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

--- a/drivers/hwmon/tmp421.c
+++ b/drivers/hwmon/tmp421.c
@@ -119,38 +119,56 @@ static int temp_from_u16(u16 reg)
 	return (temp * 1000 + 128) / 256;
 }
 
-static struct tmp421_data *tmp421_update_device(struct device *dev)
+static int tmp421_update_device(struct tmp421_data *data)
 {
-	struct tmp421_data *data = dev_get_drvdata(dev);
 	struct i2c_client *client = data->client;
+	int ret = 0;
 	int i;
 
 	mutex_lock(&data->update_lock);
 
 	if (time_after(jiffies, data->last_updated + (HZ / 2)) ||
 	    !data->valid) {
-		data->config = i2c_smbus_read_byte_data(client,
-			TMP421_CONFIG_REG_1);
+		ret = i2c_smbus_read_byte_data(client, TMP421_CONFIG_REG_1);
+		if (ret < 0)
+			goto exit;
+		data->config = ret;
 
 		for (i = 0; i < data->channels; i++) {
-			data->temp[i] = i2c_smbus_read_byte_data(client,
-				TMP421_TEMP_MSB[i]) << 8;
-			data->temp[i] |= i2c_smbus_read_byte_data(client,
-				TMP421_TEMP_LSB[i]);
+			ret = i2c_smbus_read_byte_data(client, TMP421_TEMP_MSB[i]);
+			if (ret < 0)
+				goto exit;
+			data->temp[i] = ret << 8;
+
+			ret = i2c_smbus_read_byte_data(client, TMP421_TEMP_LSB[i]);
+			if (ret < 0)
+				goto exit;
+			data->temp[i] |= ret;
 		}
 		data->last_updated = jiffies;
 		data->valid = 1;
 	}
 
+exit:
 	mutex_unlock(&data->update_lock);
 
-	return data;
+	if (ret < 0) {
+		data->valid = 0;
+		return ret;
+	}
+
+	return 0;
 }
 
 static int tmp421_read(struct device *dev, enum hwmon_sensor_types type,
 		       u32 attr, int channel, long *val)
 {
-	struct tmp421_data *tmp421 = tmp421_update_device(dev);
+	struct tmp421_data *tmp421 = dev_get_drvdata(dev);
+	int ret = 0;
+
+	ret = tmp421_update_device(tmp421);
+	if (ret)
+		return ret;
 
 	switch (attr) {
 	case hwmon_temp_input:


