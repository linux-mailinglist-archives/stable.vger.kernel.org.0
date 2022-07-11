Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29FFC56FC2F
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbiGKJke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233479AbiGKJjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:39:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE958B4BA;
        Mon, 11 Jul 2022 02:20:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDDF4B80D2C;
        Mon, 11 Jul 2022 09:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F707C34115;
        Mon, 11 Jul 2022 09:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531222;
        bh=ynAyWgoXiSjmNRHtxhcsHuqwdPZlXmQsgv73NX8sewQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2NJzizx+G15dsurdB4vBZmZm89+4CO4Vf/dTZMUQPAbPe73YZ7xhMtYa6ZrmUsx+f
         wmU8DRZHowIzqWwLIAtONsTVcKChP+V3eohbnnczKJjbVC07lgXwyilFUhfLf6HMYg
         AXpE/MBSv22f67FhW7uaPsHai07dIZtFHnlQGDeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/230] Input: goodix - refactor reset handling
Date:   Mon, 11 Jul 2022 11:04:43 +0200
Message-Id: <20220711090604.847577621@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 209bda4741f68f102cf2f272227bfc938e387b51 ]

Refactor reset handling a bit, change the main reset handler
into a new goodix_reset_no_int_sync() helper and add a
goodix_reset() wrapper which calls goodix_int_sync()
separately.

Also push the dev_err() call on reset failure into the
goodix_reset_no_int_sync() and goodix_int_sync() functions,
so that we don't need to have separate dev_err() calls in
all their callers.

This is a preparation patch for adding support for controllers
without flash, which need to have their firmware uploaded and
need some other special handling too.

Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210920150643.155872-4-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/goodix.c | 48 ++++++++++++++++++++----------
 drivers/input/touchscreen/goodix.h |  1 +
 2 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 5ccdd6abd868..2ca903a8af21 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -596,56 +596,76 @@ int goodix_int_sync(struct goodix_ts_data *ts)
 
 	error = goodix_irq_direction_output(ts, 0);
 	if (error)
-		return error;
+		goto error;
 
 	msleep(50);				/* T5: 50ms */
 
 	error = goodix_irq_direction_input(ts);
 	if (error)
-		return error;
+		goto error;
 
 	return 0;
+
+error:
+	dev_err(&ts->client->dev, "Controller irq sync failed.\n");
+	return error;
 }
 
 /**
- * goodix_reset - Reset device during power on
+ * goodix_reset_no_int_sync - Reset device, leaving interrupt line in output mode
  *
  * @ts: goodix_ts_data pointer
  */
-static int goodix_reset(struct goodix_ts_data *ts)
+int goodix_reset_no_int_sync(struct goodix_ts_data *ts)
 {
 	int error;
 
 	/* begin select I2C slave addr */
 	error = gpiod_direction_output(ts->gpiod_rst, 0);
 	if (error)
-		return error;
+		goto error;
 
 	msleep(20);				/* T2: > 10ms */
 
 	/* HIGH: 0x28/0x29, LOW: 0xBA/0xBB */
 	error = goodix_irq_direction_output(ts, ts->client->addr == 0x14);
 	if (error)
-		return error;
+		goto error;
 
 	usleep_range(100, 2000);		/* T3: > 100us */
 
 	error = gpiod_direction_output(ts->gpiod_rst, 1);
 	if (error)
-		return error;
+		goto error;
 
 	usleep_range(6000, 10000);		/* T4: > 5ms */
 
 	/* end select I2C slave addr */
 	error = gpiod_direction_input(ts->gpiod_rst);
 	if (error)
-		return error;
+		goto error;
 
-	error = goodix_int_sync(ts);
+	return 0;
+
+error:
+	dev_err(&ts->client->dev, "Controller reset failed.\n");
+	return error;
+}
+
+/**
+ * goodix_reset - Reset device during power on
+ *
+ * @ts: goodix_ts_data pointer
+ */
+static int goodix_reset(struct goodix_ts_data *ts)
+{
+	int error;
+
+	error = goodix_reset_no_int_sync(ts);
 	if (error)
 		return error;
 
-	return 0;
+	return goodix_int_sync(ts);
 }
 
 #ifdef ACPI_GPIO_SUPPORT
@@ -1144,10 +1164,8 @@ static int goodix_ts_probe(struct i2c_client *client,
 	if (ts->reset_controller_at_probe) {
 		/* reset the controller */
 		error = goodix_reset(ts);
-		if (error) {
-			dev_err(&client->dev, "Controller reset failed.\n");
+		if (error)
 			return error;
-		}
 	}
 
 	error = goodix_i2c_test(client);
@@ -1289,10 +1307,8 @@ static int __maybe_unused goodix_resume(struct device *dev)
 
 	if (error != 0 || config_ver != ts->config[0]) {
 		error = goodix_reset(ts);
-		if (error) {
-			dev_err(dev, "Controller reset failed.\n");
+		if (error)
 			return error;
-		}
 
 		error = goodix_send_cfg(ts, ts->config, ts->chip->config_len);
 		if (error)
diff --git a/drivers/input/touchscreen/goodix.h b/drivers/input/touchscreen/goodix.h
index cdaced4f2980..0b88554ba2ae 100644
--- a/drivers/input/touchscreen/goodix.h
+++ b/drivers/input/touchscreen/goodix.h
@@ -69,5 +69,6 @@ int goodix_i2c_write(struct i2c_client *client, u16 reg, const u8 *buf, int len)
 int goodix_i2c_write_u8(struct i2c_client *client, u16 reg, u8 value);
 int goodix_send_cfg(struct goodix_ts_data *ts, const u8 *cfg, int len);
 int goodix_int_sync(struct goodix_ts_data *ts);
+int goodix_reset_no_int_sync(struct goodix_ts_data *ts);
 
 #endif
-- 
2.35.1



