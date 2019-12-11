Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA15F11AF45
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbfLKPMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:12:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731086AbfLKPMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 658F02467D;
        Wed, 11 Dec 2019 15:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077138;
        bh=1p+VIhW29w2XPh91R1wTJ43eATvNT1qf2y1Fw9muaBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvOf4ZnikqDApXfm5idDcZ0daOm88g/B8ZA7dPSlLjR5IHMyhfmHoK9phsZubLvbR
         29m4McEgrNXEZsFINZ50u2bUeeD+MGdaKwTR00jxuF/ZvhoB1vtNBuhqxtvIKrGJOQ
         kMXY1filHsDGu0JGwvknvGziV/sLht1xNb5DCNOs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Matthias Fend <Matthias.Fend@wolfvision.net>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 025/134] Input: st1232 - do not reset the chip too early
Date:   Wed, 11 Dec 2019 10:10:01 -0500
Message-Id: <20191211151150.19073-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit efd7bb08a762d4f6322054c6824bd942971ac563 ]

We should not be putting the chip into reset while interrupts are enabled
and ISR may be running. Fix this by installing a custom devm action and
powering off the device/resetting GPIO line from there. This ensures proper
ordering.

Tested-by: Matthias Fend <Matthias.Fend@wolfvision.net>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/st1232.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/input/touchscreen/st1232.c b/drivers/input/touchscreen/st1232.c
index 1139714e72e26..1c5f8875cb795 100644
--- a/drivers/input/touchscreen/st1232.c
+++ b/drivers/input/touchscreen/st1232.c
@@ -149,6 +149,11 @@ static void st1232_ts_power(struct st1232_ts_data *ts, bool poweron)
 		gpiod_set_value_cansleep(ts->reset_gpio, !poweron);
 }
 
+static void st1232_ts_power_off(void *data)
+{
+	st1232_ts_power(data, false);
+}
+
 static const struct st_chip_info st1232_chip_info = {
 	.have_z		= true,
 	.max_x		= 0x31f, /* 800 - 1 */
@@ -229,6 +234,13 @@ static int st1232_ts_probe(struct i2c_client *client,
 
 	st1232_ts_power(ts, true);
 
+	error = devm_add_action_or_reset(&client->dev, st1232_ts_power_off, ts);
+	if (error) {
+		dev_err(&client->dev,
+			"Failed to install power off action: %d\n", error);
+		return error;
+	}
+
 	input_dev->name = "st1232-touchscreen";
 	input_dev->id.bustype = BUS_I2C;
 	input_dev->dev.parent = &client->dev;
@@ -271,15 +283,6 @@ static int st1232_ts_probe(struct i2c_client *client,
 	return 0;
 }
 
-static int st1232_ts_remove(struct i2c_client *client)
-{
-	struct st1232_ts_data *ts = i2c_get_clientdata(client);
-
-	st1232_ts_power(ts, false);
-
-	return 0;
-}
-
 static int __maybe_unused st1232_ts_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
@@ -329,7 +332,6 @@ MODULE_DEVICE_TABLE(of, st1232_ts_dt_ids);
 
 static struct i2c_driver st1232_ts_driver = {
 	.probe		= st1232_ts_probe,
-	.remove		= st1232_ts_remove,
 	.id_table	= st1232_ts_id,
 	.driver = {
 		.name	= ST1232_TS_NAME,
-- 
2.20.1

