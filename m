Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8146420F2E
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237288AbhJDNb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237272AbhJDNaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E28663213;
        Mon,  4 Oct 2021 13:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353215;
        bh=6XxndlJ+hbnPD+TaMAe645ki6TjPjn91KhRQqbaYJ/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4UlLFItDsTCh1jXj3YMxlaZboZet4XySb+3/FiNWoMMOwEhY8sPzrT7qwusP9cLr
         CXHRyoE+REbEoUTh6k3Vz7gyc4STZpUSlyFOHgf6C8wZ5dHWzbw5JsJOAgIHgx/Kzf
         iwKsx+T4nS4nbes0O3rY/o7F10H/oukxazKRz5oY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadezda Lutovinova <lutovinova@ispras.ru>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.14 041/172] hwmon: (w83793) Fix NULL pointer dereference by removing unnecessary structure field
Date:   Mon,  4 Oct 2021 14:51:31 +0200
Message-Id: <20211004125046.314916360@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadezda Lutovinova <lutovinova@ispras.ru>

commit dd4d747ef05addab887dc8ff0d6ab9860bbcd783 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/w83793.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -202,7 +202,6 @@ static inline s8 TEMP_TO_REG(long val, s
 }
 
 struct w83793_data {
-	struct i2c_client *lm75[2];
 	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid;			/* !=0 if following fields are valid */
@@ -1566,7 +1565,6 @@ w83793_detect_subclients(struct i2c_clie
 	int address = client->addr;
 	u8 tmp;
 	struct i2c_adapter *adapter = client->adapter;
-	struct w83793_data *data = i2c_get_clientdata(client);
 
 	id = i2c_adapter_id(adapter);
 	if (force_subclients[0] == id && force_subclients[1] == address) {
@@ -1586,21 +1584,19 @@ w83793_detect_subclients(struct i2c_clie
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
 


