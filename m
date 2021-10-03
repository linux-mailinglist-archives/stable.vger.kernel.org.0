Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C13420178
	for <lists+stable@lfdr.de>; Sun,  3 Oct 2021 14:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhJCMTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 08:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhJCMTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 Oct 2021 08:19:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C361C613A0;
        Sun,  3 Oct 2021 12:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633263452;
        bh=XE4JgPJCyenDY7iXuE4K3Vl9di0AT3to+CP7vRrxMSY=;
        h=Subject:To:Cc:From:Date:From;
        b=VCYK0WIwC8fzsTzIPgvWqy2zciIpqyKqjU11cMn7tobTwou4nm/k4nurrTgc+V2sb
         OacglucoHydfn1AA7lahL7rdoGtsxODPquK+92FfVgnRbFry61515RrOBDlkaUdIbe
         M3+tL9amL9NpvNpB1daAmavotbOjnrMjLB/2dXrM=
Subject: FAILED: patch "[PATCH] hwmon: (tmp421) handle I2C errors" failed to apply to 4.14-stable tree
To:     fercerpav@gmail.com, linux@roeck-us.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Oct 2021 14:17:22 +0200
Message-ID: <1633263442226101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2938b2978a70d4cc10777ee71c9e512ffe4e0f4b Mon Sep 17 00:00:00 2001
From: Paul Fertser <fercerpav@gmail.com>
Date: Fri, 24 Sep 2021 12:30:09 +0300
Subject: [PATCH] hwmon: (tmp421) handle I2C errors

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

diff --git a/drivers/hwmon/tmp421.c b/drivers/hwmon/tmp421.c
index ede66ea6a730..8fd8c3a94dfe 100644
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

