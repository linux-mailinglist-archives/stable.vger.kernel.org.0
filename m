Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16519420186
	for <lists+stable@lfdr.de>; Sun,  3 Oct 2021 14:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhJCMUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 08:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230050AbhJCMUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 Oct 2021 08:20:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D067461507;
        Sun,  3 Oct 2021 12:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633263527;
        bh=yozVZlVuOxDH/PBaGT4uwS3gW1b5dm7PrRwzV2Rl6Jg=;
        h=Subject:To:Cc:From:Date:From;
        b=GOWTdENVLG9wdh0TrYM4HuckFuH69qNFwlXQfom14h1OYQvsOvJLmO2U+Z/Jxx/VL
         NVNcVsabhddvFfaj/4Lw0yboBaW0wMLgq1mnAji30p+2/u52O60mXNqf5v8x/zBs1K
         bOCj31USkIBknLSrz6PLjiEy5Atv+VYVa8OSLXwE=
Subject: FAILED: patch "[PATCH] hwmon: (w83791d) Fix NULL pointer dereference by removing" failed to apply to 4.19-stable tree
To:     lutovinova@ispras.ru, linux@roeck-us.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Oct 2021 14:18:33 +0200
Message-ID: <1633263513187156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 943c15ac1b84d378da26bba41c83c67e16499ac4 Mon Sep 17 00:00:00 2001
From: Nadezda Lutovinova <lutovinova@ispras.ru>
Date: Tue, 21 Sep 2021 18:51:51 +0300
Subject: [PATCH] hwmon: (w83791d) Fix NULL pointer dereference by removing
 unnecessary structure field

If driver read val value sufficient for
(val & 0x08) && (!(val & 0x80)) && ((val & 0x7) == ((val >> 4) & 0x7))
from device then Null pointer dereference occurs.
(It is possible if tmp = 0b0xyz1xyz, where same literals mean same numbers)
Also lm75[] does not serve a purpose anymore after switching to
devm_i2c_new_dummy_device() in w83791d_detect_subclients().

The patch fixes possible NULL pointer dereference by removing lm75[].

Found by Linux Driver Verification project (linuxtesting.org).

Cc: stable@vger.kernel.org
Signed-off-by: Nadezda Lutovinova <lutovinova@ispras.ru>
Link: https://lore.kernel.org/r/20210921155153.28098-1-lutovinova@ispras.ru
[groeck: Dropped unnecessary continuation lines, fixed multi-line alignment]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>

diff --git a/drivers/hwmon/w83791d.c b/drivers/hwmon/w83791d.c
index 37b25a1474c4..3c1be2c11fdf 100644
--- a/drivers/hwmon/w83791d.c
+++ b/drivers/hwmon/w83791d.c
@@ -273,9 +273,6 @@ struct w83791d_data {
 	char valid;			/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
 
-	/* array of 2 pointers to subclients */
-	struct i2c_client *lm75[2];
-
 	/* volts */
 	u8 in[NUMBER_OF_VIN];		/* Register value */
 	u8 in_max[NUMBER_OF_VIN];	/* Register value */
@@ -1257,7 +1254,6 @@ static const struct attribute_group w83791d_group_fanpwm45 = {
 static int w83791d_detect_subclients(struct i2c_client *client)
 {
 	struct i2c_adapter *adapter = client->adapter;
-	struct w83791d_data *data = i2c_get_clientdata(client);
 	int address = client->addr;
 	int i, id;
 	u8 val;
@@ -1280,22 +1276,19 @@ static int w83791d_detect_subclients(struct i2c_client *client)
 	}
 
 	val = w83791d_read(client, W83791D_REG_I2C_SUBADDR);
-	if (!(val & 0x08))
-		data->lm75[0] = devm_i2c_new_dummy_device(&client->dev, adapter,
-							  0x48 + (val & 0x7));
-	if (!(val & 0x80)) {
-		if (!IS_ERR(data->lm75[0]) &&
-				((val & 0x7) == ((val >> 4) & 0x7))) {
-			dev_err(&client->dev,
-				"duplicate addresses 0x%x, "
-				"use force_subclient\n",
-				data->lm75[0]->addr);
-			return -ENODEV;
-		}
-		data->lm75[1] = devm_i2c_new_dummy_device(&client->dev, adapter,
-							  0x48 + ((val >> 4) & 0x7));
+
+	if (!(val & 0x88) && (val & 0x7) == ((val >> 4) & 0x7)) {
+		dev_err(&client->dev,
+			"duplicate addresses 0x%x, use force_subclient\n", 0x48 + (val & 0x7));
+		return -ENODEV;
 	}
 
+	if (!(val & 0x08))
+		devm_i2c_new_dummy_device(&client->dev, adapter, 0x48 + (val & 0x7));
+
+	if (!(val & 0x80))
+		devm_i2c_new_dummy_device(&client->dev, adapter, 0x48 + ((val >> 4) & 0x7));
+
 	return 0;
 }
 

