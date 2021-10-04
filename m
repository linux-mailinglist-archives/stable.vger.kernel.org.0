Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78122420E10
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbhJDNVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236339AbhJDNTR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:19:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6482961BBE;
        Mon,  4 Oct 2021 13:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352898;
        bh=Xbkdq9uOlq0W0ojR4ntt1ytqvtNWxvxwStH9xYAxCXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5r8l4SFraB0OHPB9e9lAxzlffIgKwzuZEPT/tJOfkFIVivaH6v+Cocw1WtRoiQZl
         nxVySlBRkhzlz0ZDwxi3Yvu+pTX+HKJ5cno85VFejgnYrX02exSNWSqzdmSfeC8IyI
         flsaBv6Ltq0/vfC3QGOT5HjiPm09gaGdVIWQS7/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadezda Lutovinova <lutovinova@ispras.ru>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 11/93] hwmon: (w83792d) Fix NULL pointer dereference by removing unnecessary structure field
Date:   Mon,  4 Oct 2021 14:52:09 +0200
Message-Id: <20211004125034.954842315@linuxfoundation.org>
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

From: Nadezda Lutovinova <lutovinova@ispras.ru>

commit 0f36b88173f028e372668ae040ab1a496834d278 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/w83792d.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

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
@@ -927,7 +924,6 @@ w83792d_detect_subclients(struct i2c_cli
 	int address = new_client->addr;
 	u8 val;
 	struct i2c_adapter *adapter = new_client->adapter;
-	struct w83792d_data *data = i2c_get_clientdata(new_client);
 
 	id = i2c_adapter_id(adapter);
 	if (force_subclients[0] == id && force_subclients[1] == address) {
@@ -946,21 +942,19 @@ w83792d_detect_subclients(struct i2c_cli
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
 


