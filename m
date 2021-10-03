Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9396C42017B
	for <lists+stable@lfdr.de>; Sun,  3 Oct 2021 14:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhJCMTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 08:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230050AbhJCMTm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 Oct 2021 08:19:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2725C61507;
        Sun,  3 Oct 2021 12:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633263475;
        bh=z136dtcMtXWTwROlHdd2zZS4E4rTM5K5FxrgKXm8/c8=;
        h=Subject:To:Cc:From:Date:From;
        b=uEd3h9BDpS0zr+bml11qB4+LmkP36k3tuc2oy+6RSewLpHHX28/U1YO2vTZK3pBI5
         +uQBdJJ+CDkbV9Fr2xC47TtzG/eA9pUKV/092nemHNJvgVYOGvGBSW8//1atc7Rz8p
         zTXJjAkqwopiZhuI5M7PYoP62BMlvyiMlYF4rNRo=
Subject: FAILED: patch "[PATCH] hwmon: (w83793) Fix NULL pointer dereference by removing" failed to apply to 4.4-stable tree
To:     lutovinova@ispras.ru, linux@roeck-us.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Oct 2021 14:17:53 +0200
Message-ID: <1633263473115130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dd4d747ef05addab887dc8ff0d6ab9860bbcd783 Mon Sep 17 00:00:00 2001
From: Nadezda Lutovinova <lutovinova@ispras.ru>
Date: Tue, 21 Sep 2021 18:51:53 +0300
Subject: [PATCH] hwmon: (w83793) Fix NULL pointer dereference by removing
 unnecessary structure field

If driver read tmp value sufficient for
(tmp & 0x08) && (!(tmp & 0x80)) && ((tmp & 0x7) == ((tmp >> 4) & 0x7))
from device then Null pointer dereference occurs.
(It is possible if tmp = 0b0xyz1xyz, where same literals mean same numbers)
Also lm75[] does not serve a purpose anymore after switching to
devm_i2c_new_dummy_device() in w83791d_detect_subclients().

The patch fixes possible NULL pointer dereference by removing lm75[].

Found by Linux Driver Verification project (linuxtesting.org).

Cc: stable@vger.kernel.org
Signed-off-by: Nadezda Lutovinova <lutovinova@ispras.ru>
Link: https://lore.kernel.org/r/20210921155153.28098-3-lutovinova@ispras.ru
[groeck: Dropped unnecessary continuation lines, fixed multi-line alignments]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>

diff --git a/drivers/hwmon/w83793.c b/drivers/hwmon/w83793.c
index e7d0484eabe4..1d2854de1cfc 100644
--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -202,7 +202,6 @@ static inline s8 TEMP_TO_REG(long val, s8 min, s8 max)
 }
 
 struct w83793_data {
-	struct i2c_client *lm75[2];
 	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid;			/* !=0 if following fields are valid */
@@ -1566,7 +1565,6 @@ w83793_detect_subclients(struct i2c_client *client)
 	int address = client->addr;
 	u8 tmp;
 	struct i2c_adapter *adapter = client->adapter;
-	struct w83793_data *data = i2c_get_clientdata(client);
 
 	id = i2c_adapter_id(adapter);
 	if (force_subclients[0] == id && force_subclients[1] == address) {
@@ -1586,21 +1584,19 @@ w83793_detect_subclients(struct i2c_client *client)
 	}
 
 	tmp = w83793_read_value(client, W83793_REG_I2C_SUBADDR);
-	if (!(tmp & 0x08))
-		data->lm75[0] = devm_i2c_new_dummy_device(&client->dev, adapter,
-							  0x48 + (tmp & 0x7));
-	if (!(tmp & 0x80)) {
-		if (!IS_ERR(data->lm75[0])
-		    && ((tmp & 0x7) == ((tmp >> 4) & 0x7))) {
-			dev_err(&client->dev,
-				"duplicate addresses 0x%x, "
-				"use force_subclients\n", data->lm75[0]->addr);
-			return -ENODEV;
-		}
-		data->lm75[1] = devm_i2c_new_dummy_device(&client->dev, adapter,
-							  0x48 + ((tmp >> 4) & 0x7));
+
+	if (!(tmp & 0x88) && (tmp & 0x7) == ((tmp >> 4) & 0x7)) {
+		dev_err(&client->dev,
+			"duplicate addresses 0x%x, use force_subclient\n", 0x48 + (tmp & 0x7));
+		return -ENODEV;
 	}
 
+	if (!(tmp & 0x08))
+		devm_i2c_new_dummy_device(&client->dev, adapter, 0x48 + (tmp & 0x7));
+
+	if (!(tmp & 0x80))
+		devm_i2c_new_dummy_device(&client->dev, adapter, 0x48 + ((tmp >> 4) & 0x7));
+
 	return 0;
 }
 

