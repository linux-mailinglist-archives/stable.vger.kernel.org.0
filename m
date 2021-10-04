Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94EC1420DB7
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbhJDNRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:17:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236165AbhJDNP5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:15:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D1AD61BB1;
        Mon,  4 Oct 2021 13:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352783;
        bh=J2cbfPo+jXvz+Ybtz1scyw8vr+JE42uix/3FzEJs3Co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVeEPM0JNpl4bd11cmc7bMPGJhPVaizbyNekNcTshh9RGZHOtVefTRq3DsuLd+dxD
         CsbEVw2pVpmYrN0yXK2HxyjyeEEPu5AbVdyhPqJsCxxLo/pcX3Cd8lA18gY1GBvSZ/
         V1iAybmh4pNYjb23fHdYpS4w/V7khRDsrfqcoAYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadezda Lutovinova <lutovinova@ispras.ru>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 08/56] hwmon: (w83791d) Fix NULL pointer dereference by removing unnecessary structure field
Date:   Mon,  4 Oct 2021 14:52:28 +0200
Message-Id: <20211004125030.274671840@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadezda Lutovinova <lutovinova@ispras.ru>

commit 943c15ac1b84d378da26bba41c83c67e16499ac4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/w83791d.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

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
@@ -1258,7 +1255,6 @@ static const struct attribute_group w837
 static int w83791d_detect_subclients(struct i2c_client *client)
 {
 	struct i2c_adapter *adapter = client->adapter;
-	struct w83791d_data *data = i2c_get_clientdata(client);
 	int address = client->addr;
 	int i, id;
 	u8 val;
@@ -1281,22 +1277,19 @@ static int w83791d_detect_subclients(str
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
 


