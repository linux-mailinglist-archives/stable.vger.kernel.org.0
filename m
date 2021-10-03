Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E29420181
	for <lists+stable@lfdr.de>; Sun,  3 Oct 2021 14:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhJCMUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 08:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230050AbhJCMUM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 Oct 2021 08:20:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D620661A10;
        Sun,  3 Oct 2021 12:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633263505;
        bh=uOnN+B1FWsn9SJYkeHAf/H0WMfzcntYN2liIBs1b344=;
        h=Subject:To:Cc:From:Date:From;
        b=exfFs0opgIxlS3cvkkFL0X/j4CkubpqEmigtenft02Llg5AYnvf0LZPsPprGVkSdx
         uiTpCdsLzDoxt6NAChvtc4EV0wmM723MV9PrSes6gzhpUDJdE2F0cUT6NDxxdQoHGU
         Ei2neTOSobIKdfh/y4L8QL5uhDBvKsoH/BsSgo7k=
Subject: FAILED: patch "[PATCH] hwmon: (w83792d) Fix NULL pointer dereference by removing" failed to apply to 4.19-stable tree
To:     lutovinova@ispras.ru, linux@roeck-us.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Oct 2021 14:18:13 +0200
Message-ID: <1633263493107118@kroah.com>
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

From 0f36b88173f028e372668ae040ab1a496834d278 Mon Sep 17 00:00:00 2001
From: Nadezda Lutovinova <lutovinova@ispras.ru>
Date: Tue, 21 Sep 2021 18:51:52 +0300
Subject: [PATCH] hwmon: (w83792d) Fix NULL pointer dereference by removing
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
Link: https://lore.kernel.org/r/20210921155153.28098-2-lutovinova@ispras.ru
[groeck: Dropped unnecessary continuation lines, fixed multipline alignment]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>

diff --git a/drivers/hwmon/w83792d.c b/drivers/hwmon/w83792d.c
index abd5c3a722b9..1f175f381350 100644
--- a/drivers/hwmon/w83792d.c
+++ b/drivers/hwmon/w83792d.c
@@ -264,9 +264,6 @@ struct w83792d_data {
 	char valid;		/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
 
-	/* array of 2 pointers to subclients */
-	struct i2c_client *lm75[2];
-
 	u8 in[9];		/* Register value */
 	u8 in_max[9];		/* Register value */
 	u8 in_min[9];		/* Register value */
@@ -927,7 +924,6 @@ w83792d_detect_subclients(struct i2c_client *new_client)
 	int address = new_client->addr;
 	u8 val;
 	struct i2c_adapter *adapter = new_client->adapter;
-	struct w83792d_data *data = i2c_get_clientdata(new_client);
 
 	id = i2c_adapter_id(adapter);
 	if (force_subclients[0] == id && force_subclients[1] == address) {
@@ -946,21 +942,19 @@ w83792d_detect_subclients(struct i2c_client *new_client)
 	}
 
 	val = w83792d_read_value(new_client, W83792D_REG_I2C_SUBADDR);
-	if (!(val & 0x08))
-		data->lm75[0] = devm_i2c_new_dummy_device(&new_client->dev, adapter,
-							  0x48 + (val & 0x7));
-	if (!(val & 0x80)) {
-		if (!IS_ERR(data->lm75[0]) &&
-			((val & 0x7) == ((val >> 4) & 0x7))) {
-			dev_err(&new_client->dev,
-				"duplicate addresses 0x%x, use force_subclient\n",
-				data->lm75[0]->addr);
-			return -ENODEV;
-		}
-		data->lm75[1] = devm_i2c_new_dummy_device(&new_client->dev, adapter,
-							  0x48 + ((val >> 4) & 0x7));
+
+	if (!(val & 0x88) && (val & 0x7) == ((val >> 4) & 0x7)) {
+		dev_err(&new_client->dev,
+			"duplicate addresses 0x%x, use force_subclient\n", 0x48 + (val & 0x7));
+		return -ENODEV;
 	}
 
+	if (!(val & 0x08))
+		devm_i2c_new_dummy_device(&new_client->dev, adapter, 0x48 + (val & 0x7));
+
+	if (!(val & 0x80))
+		devm_i2c_new_dummy_device(&new_client->dev, adapter, 0x48 + ((val >> 4) & 0x7));
+
 	return 0;
 }
 

