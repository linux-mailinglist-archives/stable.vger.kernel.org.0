Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0CDD6B49B1
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbjCJPPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbjCJPOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:14:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF9F125AE4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:05:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0864AB82303
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64395C4339B;
        Fri, 10 Mar 2023 14:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460219;
        bh=/XlHwpKnBlsOxotJvp6PPz3TOLrNtpT1McSsI53qTqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TvOSBky8i+giYi0ZopgpMfKXxBlczIYGfCx0WdI12XL+zmnZtiE8yclxl/PzttMKj
         52XrCNLssRXazjUhxUqXSrDBiFqPA5fd3P36hNTlgWD9/NvKYFN1krtr6vU2Nr6ERp
         uLeGAfI5mwaaYsQcP5XV/HE9VlRr5+ifmrFc0noY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff LaBundy <jeff@labundy.com>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 263/529] Input: iqs269a - do not poll during ATI
Date:   Fri, 10 Mar 2023 14:36:46 +0100
Message-Id: <20230310133817.147463135@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit b08134eb254db56e9ce8170d9b82f0d7a616b6f8 ]

After initial start-up, the driver triggers ATI (calibration) with
the newly loaded register configuration in place. Next, the driver
polls a register field to ensure ATI completed in a timely fashion
and that the device is ready to sense.

However, communicating with the device over I2C while ATI is under-
way may induce noise in the device and cause ATI to fail. As such,
the vendor recommends not to poll the device during ATI.

To solve this problem, let the device naturally signal to the host
that ATI is complete by way of an interrupt. A completion prevents
the device from successfully probing until this happens.

As an added benefit, initial switch states are now reported in the
interrupt handler at the same time ATI status is checked. As such,
duplicate code that reports initial switch states has been removed
from iqs269_input_init().

The former logic that scaled ATI timeout and filter settling delay
is not carried forward with the new implementation, as it produces
overly conservative delays at the lower clock rate.

Rather, a single timeout that covers both clock rates is used. The
filter settling delay does not happen to be necessary and has been
removed as well.

Fixes: 04e49867fad1 ("Input: add support for Azoteq IQS269A")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Link: https://lore.kernel.org/r/Y7RtB2T7AF9rYMjK@nixie71
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/iqs269a.c | 97 +++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 51 deletions(-)

diff --git a/drivers/input/misc/iqs269a.c b/drivers/input/misc/iqs269a.c
index 814d1a898e7ff..8b30c911f7899 100644
--- a/drivers/input/misc/iqs269a.c
+++ b/drivers/input/misc/iqs269a.c
@@ -9,6 +9,7 @@
  * axial sliders presented by the device.
  */
 
+#include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -144,10 +145,6 @@
 #define IQS269_NUM_CH				8
 #define IQS269_NUM_SL				2
 
-#define IQS269_ATI_POLL_SLEEP_US		(iqs269->delay_mult * 10000)
-#define IQS269_ATI_POLL_TIMEOUT_US		(iqs269->delay_mult * 500000)
-#define IQS269_ATI_STABLE_DELAY_MS		(iqs269->delay_mult * 150)
-
 #define iqs269_irq_wait()			usleep_range(200, 250)
 
 enum iqs269_local_cap_size {
@@ -289,10 +286,10 @@ struct iqs269_private {
 	struct mutex lock;
 	struct iqs269_switch_desc switches[ARRAY_SIZE(iqs269_events)];
 	struct iqs269_sys_reg sys_reg;
+	struct completion ati_done;
 	struct input_dev *keypad;
 	struct input_dev *slider[IQS269_NUM_SL];
 	unsigned int keycode[ARRAY_SIZE(iqs269_events) * IQS269_NUM_CH];
-	unsigned int delay_mult;
 	unsigned int ch_num;
 	bool hall_enable;
 	bool ati_current;
@@ -973,13 +970,8 @@ static int iqs269_parse_prop(struct iqs269_private *iqs269)
 
 	general = be16_to_cpu(sys_reg->general);
 
-	if (device_property_present(&client->dev, "azoteq,clk-div")) {
+	if (device_property_present(&client->dev, "azoteq,clk-div"))
 		general |= IQS269_SYS_SETTINGS_CLK_DIV;
-		iqs269->delay_mult = 4;
-	} else {
-		general &= ~IQS269_SYS_SETTINGS_CLK_DIV;
-		iqs269->delay_mult = 1;
-	}
 
 	/*
 	 * Configure the device to automatically switch between normal and low-
@@ -1036,7 +1028,6 @@ static int iqs269_parse_prop(struct iqs269_private *iqs269)
 
 static int iqs269_dev_init(struct iqs269_private *iqs269)
 {
-	unsigned int val;
 	int error;
 
 	mutex_lock(&iqs269->lock);
@@ -1052,14 +1043,12 @@ static int iqs269_dev_init(struct iqs269_private *iqs269)
 	if (error)
 		goto err_mutex;
 
-	error = regmap_read_poll_timeout(iqs269->regmap, IQS269_SYS_FLAGS, val,
-					!(val & IQS269_SYS_FLAGS_IN_ATI),
-					 IQS269_ATI_POLL_SLEEP_US,
-					 IQS269_ATI_POLL_TIMEOUT_US);
-	if (error)
-		goto err_mutex;
+	/*
+	 * The following delay gives the device time to deassert its RDY output
+	 * so as to prevent an interrupt from being serviced prematurely.
+	 */
+	usleep_range(2000, 2100);
 
-	msleep(IQS269_ATI_STABLE_DELAY_MS);
 	iqs269->ati_current = true;
 
 err_mutex:
@@ -1071,10 +1060,8 @@ static int iqs269_dev_init(struct iqs269_private *iqs269)
 static int iqs269_input_init(struct iqs269_private *iqs269)
 {
 	struct i2c_client *client = iqs269->client;
-	struct iqs269_flags flags;
 	unsigned int sw_code, keycode;
 	int error, i, j;
-	u8 dir_mask, state;
 
 	iqs269->keypad = devm_input_allocate_device(&client->dev);
 	if (!iqs269->keypad)
@@ -1087,23 +1074,7 @@ static int iqs269_input_init(struct iqs269_private *iqs269)
 	iqs269->keypad->name = "iqs269a_keypad";
 	iqs269->keypad->id.bustype = BUS_I2C;
 
-	if (iqs269->hall_enable) {
-		error = regmap_raw_read(iqs269->regmap, IQS269_SYS_FLAGS,
-					&flags, sizeof(flags));
-		if (error) {
-			dev_err(&client->dev,
-				"Failed to read initial status: %d\n", error);
-			return error;
-		}
-	}
-
 	for (i = 0; i < ARRAY_SIZE(iqs269_events); i++) {
-		dir_mask = flags.states[IQS269_ST_OFFS_DIR];
-		if (!iqs269_events[i].dir_up)
-			dir_mask = ~dir_mask;
-
-		state = flags.states[iqs269_events[i].st_offs] & dir_mask;
-
 		sw_code = iqs269->switches[i].code;
 
 		for (j = 0; j < IQS269_NUM_CH; j++) {
@@ -1116,13 +1087,9 @@ static int iqs269_input_init(struct iqs269_private *iqs269)
 			switch (j) {
 			case IQS269_CHx_HALL_ACTIVE:
 				if (iqs269->hall_enable &&
-				    iqs269->switches[i].enabled) {
+				    iqs269->switches[i].enabled)
 					input_set_capability(iqs269->keypad,
 							     EV_SW, sw_code);
-					input_report_switch(iqs269->keypad,
-							    sw_code,
-							    state & BIT(j));
-				}
 				fallthrough;
 
 			case IQS269_CHx_HALL_INACTIVE:
@@ -1138,14 +1105,6 @@ static int iqs269_input_init(struct iqs269_private *iqs269)
 		}
 	}
 
-	input_sync(iqs269->keypad);
-
-	error = input_register_device(iqs269->keypad);
-	if (error) {
-		dev_err(&client->dev, "Failed to register keypad: %d\n", error);
-		return error;
-	}
-
 	for (i = 0; i < IQS269_NUM_SL; i++) {
 		if (!iqs269->sys_reg.slider_select[i])
 			continue;
@@ -1205,6 +1164,9 @@ static int iqs269_report(struct iqs269_private *iqs269)
 		return error;
 	}
 
+	if (be16_to_cpu(flags.system) & IQS269_SYS_FLAGS_IN_ATI)
+		return 0;
+
 	error = regmap_raw_read(iqs269->regmap, IQS269_SLIDER_X, slider_x,
 				sizeof(slider_x));
 	if (error) {
@@ -1267,6 +1229,12 @@ static int iqs269_report(struct iqs269_private *iqs269)
 
 	input_sync(iqs269->keypad);
 
+	/*
+	 * The following completion signals that ATI has finished, any initial
+	 * switch states have been reported and the keypad can be registered.
+	 */
+	complete_all(&iqs269->ati_done);
+
 	return 0;
 }
 
@@ -1298,6 +1266,9 @@ static ssize_t counts_show(struct device *dev,
 	if (!iqs269->ati_current || iqs269->hall_enable)
 		return -EPERM;
 
+	if (!completion_done(&iqs269->ati_done))
+		return -EBUSY;
+
 	/*
 	 * Unsolicited I2C communication prompts the device to assert its RDY
 	 * pin, so disable the interrupt line until the operation is finished
@@ -1554,7 +1525,9 @@ static ssize_t ati_trigger_show(struct device *dev,
 {
 	struct iqs269_private *iqs269 = dev_get_drvdata(dev);
 
-	return scnprintf(buf, PAGE_SIZE, "%u\n", iqs269->ati_current);
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			 iqs269->ati_current &&
+			 completion_done(&iqs269->ati_done));
 }
 
 static ssize_t ati_trigger_store(struct device *dev,
@@ -1574,6 +1547,7 @@ static ssize_t ati_trigger_store(struct device *dev,
 		return count;
 
 	disable_irq(client->irq);
+	reinit_completion(&iqs269->ati_done);
 
 	error = iqs269_dev_init(iqs269);
 
@@ -1583,6 +1557,10 @@ static ssize_t ati_trigger_store(struct device *dev,
 	if (error)
 		return error;
 
+	if (!wait_for_completion_timeout(&iqs269->ati_done,
+					 msecs_to_jiffies(2000)))
+		return -ETIMEDOUT;
+
 	return count;
 }
 
@@ -1641,6 +1619,7 @@ static int iqs269_probe(struct i2c_client *client)
 	}
 
 	mutex_init(&iqs269->lock);
+	init_completion(&iqs269->ati_done);
 
 	error = regmap_raw_read(iqs269->regmap, IQS269_VER_INFO, &ver_info,
 				sizeof(ver_info));
@@ -1676,6 +1655,22 @@ static int iqs269_probe(struct i2c_client *client)
 		return error;
 	}
 
+	if (!wait_for_completion_timeout(&iqs269->ati_done,
+					 msecs_to_jiffies(2000))) {
+		dev_err(&client->dev, "Failed to complete ATI\n");
+		return -ETIMEDOUT;
+	}
+
+	/*
+	 * The keypad may include one or more switches and is not registered
+	 * until ATI is complete and the initial switch states are read.
+	 */
+	error = input_register_device(iqs269->keypad);
+	if (error) {
+		dev_err(&client->dev, "Failed to register keypad: %d\n", error);
+		return error;
+	}
+
 	error = devm_device_add_group(&client->dev, &iqs269_attr_group);
 	if (error)
 		dev_err(&client->dev, "Failed to add attributes: %d\n", error);
-- 
2.39.2



