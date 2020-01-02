Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3993012F194
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgABWL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:11:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbgABWL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:11:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9915F22525;
        Thu,  2 Jan 2020 22:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003117;
        bh=dMcV83CY2sqhLoex5DJnJluwMpbZ7vzTK2T0DgtjQIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yyr6xzfApAVAAo2dym1HhQ0Zl/L6DdT7SMEVa9mQrJAg3F5mdjhZuNhBHrFk6jKWF
         z/Jo9y8Jo6EzOYY9F3idvubshZZojBKAqYEUrOp3L9+nT29v17D6CCfH6Iger0zu3y
         4v02J5LdHvdyJqPdBDS7BHl/Tjw2LFTF+ufQE/Nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Fend <Matthias.Fend@wolfvision.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/191] Input: st1232 - do not reset the chip too early
Date:   Thu,  2 Jan 2020 23:05:08 +0100
Message-Id: <20200102215832.776121397@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1139714e72e2..1c5f8875cb79 100644
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



