Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CF633B905
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbhCOOFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhCOOAo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF35964F0D;
        Mon, 15 Mar 2021 14:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816832;
        bh=G5Ly4m8YQK16F/DM72YCVJVXhsPGh8FQM0w0iDYFpkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pr3eDWRUa3BsYXuvzwQx8Ct0QG/xt1edrPYdpqILcKioOW5CLIvFn7BLEUux+lMvo
         urJFgJj3i67OAoNfs3ehXA/qxkh7lw2lNX95QhzYJYohxzrkRVQeVu26LhbUf1Fc8J
         2vV67e6PiZUQRKNr5nL3p9RV+nmLaPc2613fwglQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boyang Yu <byu@arista.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH 4.14 90/95] hwmon: (lm90) Fix max6658 sporadic wrong temperature reading
Date:   Mon, 15 Mar 2021 14:58:00 +0100
Message-Id: <20210315135743.244479697@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Boyang Yu <byu@arista.com>

commit 62456189f3292c62f87aef363f204886dc1d4b48 upstream.

max6658 may report unrealistically high temperature during
the driver initialization, for which, its overtemp alarm pin
also gets asserted. For certain devices implementing overtemp
protection based on that pin, it may further trigger a reset to
the device. By reproducing the problem, the wrong reading is
found to be coincident with changing the conversion rate.

To mitigate this issue, set the stop bit before changing the
conversion rate and unset it thereafter. After such change, the
wrong reading is not reproduced. Apply this change only to the
max6657 kind for now, controlled by flag LM90_PAUSE_ON_CONFIG.

Signed-off-by: Boyang Yu <byu@arista.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/lm90.c |   42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -187,6 +187,7 @@ enum chips { lm90, adm1032, lm99, lm86,
 #define LM90_HAVE_EMERGENCY_ALARM (1 << 5)/* emergency alarm		*/
 #define LM90_HAVE_TEMP3		(1 << 6) /* 3rd temperature sensor	*/
 #define LM90_HAVE_BROKEN_ALERT	(1 << 7) /* Broken alert		*/
+#define LM90_PAUSE_FOR_CONFIG	(1 << 8) /* Pause conversion for config	*/
 
 /* LM90 status */
 #define LM90_STATUS_LTHRM	(1 << 0) /* local THERM limit tripped */
@@ -380,6 +381,7 @@ static const struct lm90_params lm90_par
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
 	},
 	[max6657] = {
+		.flags = LM90_PAUSE_FOR_CONFIG,
 		.alert_alarms = 0x7c,
 		.max_convrate = 8,
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
@@ -580,6 +582,38 @@ static inline int lm90_select_remote_cha
 	return 0;
 }
 
+static int lm90_write_convrate(struct i2c_client *client,
+			       struct lm90_data *data, int val)
+{
+	int err;
+	int config_orig, config_stop;
+
+	/* Save config and pause conversion */
+	if (data->flags & LM90_PAUSE_FOR_CONFIG) {
+		config_orig = lm90_read_reg(client, LM90_REG_R_CONFIG1);
+		if (config_orig < 0)
+			return config_orig;
+		config_stop = config_orig | 0x40;
+		if (config_orig != config_stop) {
+			err = i2c_smbus_write_byte_data(client,
+							LM90_REG_W_CONFIG1,
+							config_stop);
+			if (err < 0)
+				return err;
+		}
+	}
+
+	/* Set conv rate */
+	err = i2c_smbus_write_byte_data(client, LM90_REG_W_CONVRATE, val);
+
+	/* Revert change to config */
+	if (data->flags & LM90_PAUSE_FOR_CONFIG && config_orig != config_stop)
+		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
+					  config_orig);
+
+	return err;
+}
+
 /*
  * Set conversion rate.
  * client->update_lock must be held when calling this function (unless we are
@@ -600,7 +634,7 @@ static int lm90_set_convrate(struct i2c_
 		if (interval >= update_interval * 3 / 4)
 			break;
 
-	err = i2c_smbus_write_byte_data(client, LM90_REG_W_CONVRATE, i);
+	err = lm90_write_convrate(client, data, i);
 	data->update_interval = DIV_ROUND_CLOSEST(update_interval, 64);
 	return err;
 }
@@ -1606,8 +1640,7 @@ static void lm90_restore_conf(void *_dat
 	struct i2c_client *client = data->client;
 
 	/* Restore initial configuration */
-	i2c_smbus_write_byte_data(client, LM90_REG_W_CONVRATE,
-				  data->convrate_orig);
+	lm90_write_convrate(client, data, data->convrate_orig);
 	i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
 				  data->config_orig);
 }
@@ -1624,12 +1657,13 @@ static int lm90_init_client(struct i2c_c
 	/*
 	 * Start the conversions.
 	 */
-	lm90_set_convrate(client, data, 500);	/* 500ms; 2Hz conversion rate */
 	config = lm90_read_reg(client, LM90_REG_R_CONFIG1);
 	if (config < 0)
 		return config;
 	data->config_orig = config;
 
+	lm90_set_convrate(client, data, 500); /* 500ms; 2Hz conversion rate */
+
 	/* Check Temperature Range Select */
 	if (data->kind == adt7461 || data->kind == tmp451) {
 		if (config & 0x04)


