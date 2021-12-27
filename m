Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FE7480082
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239881AbhL0Pqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:46:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44960 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239902AbhL0PoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:44:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CA2BB810B9;
        Mon, 27 Dec 2021 15:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE68FC36AFC;
        Mon, 27 Dec 2021 15:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619839;
        bh=AkBcoMqbbF0IQpohr7R48OB++gnVWHkK/oDcXZMppws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vRIPV83uz5FvqKUxk4xrepfJdGuu7ZD4qLp+PNazfyGpxBi2xZDlkfOORQHz4Yggo
         qcBgrjQNBjQXPBSEBdAejN8iLO0CelD3bvSIs7DK6yYSP1O1iRCC1pt/jBghXYubbW
         nfqzTR7rZMwW5w5BYwARnWsxWHbdH3nk6t4aQclM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David T. Wilson" <david.wilson@nasa.gov>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/128] hwmon: (lm90) Introduce flag indicating extended temperature support
Date:   Mon, 27 Dec 2021 16:30:30 +0100
Message-Id: <20211227151333.353278995@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit f347e249fcf920ad6974cbd898e2ec0b366a1c34 ]

A flag indicating extended temperature support makes it easier
to add support for additional chips with this functionality.

Cc: David T. Wilson <david.wilson@nasa.gov>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm90.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index f6e6c7c6c73f8..0463179be5504 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -182,7 +182,8 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
 #define LM90_HAVE_EMERGENCY_ALARM (1 << 5)/* emergency alarm		*/
 #define LM90_HAVE_TEMP3		(1 << 6) /* 3rd temperature sensor	*/
 #define LM90_HAVE_BROKEN_ALERT	(1 << 7) /* Broken alert		*/
-#define LM90_PAUSE_FOR_CONFIG	(1 << 8) /* Pause conversion for config	*/
+#define LM90_HAVE_EXTENDED_TEMP	(1 << 8) /* extended temperature support*/
+#define LM90_PAUSE_FOR_CONFIG	(1 << 9) /* Pause conversion for config	*/
 
 /* LM90 status */
 #define LM90_STATUS_LTHRM	(1 << 0) /* local THERM limit tripped */
@@ -350,7 +351,7 @@ static const struct lm90_params lm90_params[] = {
 	},
 	[adt7461] = {
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
-		  | LM90_HAVE_BROKEN_ALERT,
+		  | LM90_HAVE_BROKEN_ALERT | LM90_HAVE_EXTENDED_TEMP,
 		.alert_alarms = 0x7c,
 		.max_convrate = 10,
 	},
@@ -422,7 +423,7 @@ static const struct lm90_params lm90_params[] = {
 	},
 	[tmp451] = {
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
-		  | LM90_HAVE_BROKEN_ALERT,
+		  | LM90_HAVE_BROKEN_ALERT | LM90_HAVE_EXTENDED_TEMP,
 		.alert_alarms = 0x7c,
 		.max_convrate = 9,
 		.reg_local_ext = TMP451_REG_R_LOCAL_TEMPL,
@@ -998,7 +999,7 @@ static int lm90_get_temp11(struct lm90_data *data, int index)
 	s16 temp11 = data->temp11[index];
 	int temp;
 
-	if (data->kind == adt7461 || data->kind == tmp451)
+	if (data->flags & LM90_HAVE_EXTENDED_TEMP)
 		temp = temp_from_u16_adt7461(data, temp11);
 	else if (data->kind == max6646)
 		temp = temp_from_u16(temp11);
@@ -1035,7 +1036,7 @@ static int lm90_set_temp11(struct lm90_data *data, int index, long val)
 		val -= 16000;
 	}
 
-	if (data->kind == adt7461 || data->kind == tmp451)
+	if (data->flags & LM90_HAVE_EXTENDED_TEMP)
 		data->temp11[index] = temp_to_u16_adt7461(data, val);
 	else if (data->kind == max6646)
 		data->temp11[index] = temp_to_u8(val) << 8;
@@ -1062,7 +1063,7 @@ static int lm90_get_temp8(struct lm90_data *data, int index)
 	s8 temp8 = data->temp8[index];
 	int temp;
 
-	if (data->kind == adt7461 || data->kind == tmp451)
+	if (data->flags & LM90_HAVE_EXTENDED_TEMP)
 		temp = temp_from_u8_adt7461(data, temp8);
 	else if (data->kind == max6646)
 		temp = temp_from_u8(temp8);
@@ -1098,7 +1099,7 @@ static int lm90_set_temp8(struct lm90_data *data, int index, long val)
 		val -= 16000;
 	}
 
-	if (data->kind == adt7461 || data->kind == tmp451)
+	if (data->flags & LM90_HAVE_EXTENDED_TEMP)
 		data->temp8[index] = temp_to_u8_adt7461(data, val);
 	else if (data->kind == max6646)
 		data->temp8[index] = temp_to_u8(val);
@@ -1116,7 +1117,7 @@ static int lm90_get_temphyst(struct lm90_data *data, int index)
 {
 	int temp;
 
-	if (data->kind == adt7461 || data->kind == tmp451)
+	if (data->flags & LM90_HAVE_EXTENDED_TEMP)
 		temp = temp_from_u8_adt7461(data, data->temp8[index]);
 	else if (data->kind == max6646)
 		temp = temp_from_u8(data->temp8[index]);
@@ -1136,7 +1137,7 @@ static int lm90_set_temphyst(struct lm90_data *data, long val)
 	int temp;
 	int err;
 
-	if (data->kind == adt7461 || data->kind == tmp451)
+	if (data->flags & LM90_HAVE_EXTENDED_TEMP)
 		temp = temp_from_u8_adt7461(data, data->temp8[LOCAL_CRIT]);
 	else if (data->kind == max6646)
 		temp = temp_from_u8(data->temp8[LOCAL_CRIT]);
@@ -1684,7 +1685,7 @@ static int lm90_init_client(struct i2c_client *client, struct lm90_data *data)
 	lm90_set_convrate(client, data, 500); /* 500ms; 2Hz conversion rate */
 
 	/* Check Temperature Range Select */
-	if (data->kind == adt7461 || data->kind == tmp451) {
+	if (data->flags & LM90_HAVE_EXTENDED_TEMP) {
 		if (config & 0x04)
 			data->flags |= LM90_FLAG_ADT7461_EXT;
 	}
-- 
2.34.1



