Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2055A6B496A
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbjCJPMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbjCJPLq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:11:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20239D332C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:03:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7653761A4E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A36C4339C;
        Fri, 10 Mar 2023 14:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460216;
        bh=cdoGp7VnpGH1rs8tAGy0dvnuR/BqSmia8wupWPQCxkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6MqNwwjDC5+gQd0IwJmJhCWvkUAYbJdKWYihHydED3O7VVM/zM8ovD346e02aW6z
         qxewWbh+BXChAxzc3Ve0eS7On8kan5mE23xG4r5fzzlAK+WgZJFTrwry1GLoAntBCb
         nqG9Ilhxs/BgXsVQbhszd6VsSCAov9PlIc7c8+e8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff LaBundy <jeff@labundy.com>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 262/529] Input: iqs269a - do not poll during suspend or resume
Date:   Fri, 10 Mar 2023 14:36:45 +0100
Message-Id: <20230310133817.101336723@linuxfoundation.org>
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

[ Upstream commit 18ab69c8ca5678324efbeed874b707ce7b2feae1 ]

Polling the device while it transitions from automatic to manual
power mode switching may keep the device from actually finishing
the transition. The process appears to time out depending on the
polling rate and the device's core clock frequency.

This is ultimately unnecessary in the first place; instead it is
sufficient to write the desired mode during initialization, then
disable automatic switching at suspend. This eliminates the need
to ensure the device is prepared for a manual change and removes
the 'suspend_mode' variable.

Similarly, polling the device while it transitions from one mode
to another under manual control may time out as well. This added
step does not appear to be necessary either, so drop it.

Fixes: 04e49867fad1 ("Input: add support for Azoteq IQS269A")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Link: https://lore.kernel.org/r/Y7Rs+eEXlRw4Vq57@nixie71
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/iqs269a.c | 118 +++++++++--------------------------
 1 file changed, 31 insertions(+), 87 deletions(-)

diff --git a/drivers/input/misc/iqs269a.c b/drivers/input/misc/iqs269a.c
index 1530efd301c24..814d1a898e7ff 100644
--- a/drivers/input/misc/iqs269a.c
+++ b/drivers/input/misc/iqs269a.c
@@ -148,9 +148,6 @@
 #define IQS269_ATI_POLL_TIMEOUT_US		(iqs269->delay_mult * 500000)
 #define IQS269_ATI_STABLE_DELAY_MS		(iqs269->delay_mult * 150)
 
-#define IQS269_PWR_MODE_POLL_SLEEP_US		IQS269_ATI_POLL_SLEEP_US
-#define IQS269_PWR_MODE_POLL_TIMEOUT_US		IQS269_ATI_POLL_TIMEOUT_US
-
 #define iqs269_irq_wait()			usleep_range(200, 250)
 
 enum iqs269_local_cap_size {
@@ -295,7 +292,6 @@ struct iqs269_private {
 	struct input_dev *keypad;
 	struct input_dev *slider[IQS269_NUM_SL];
 	unsigned int keycode[ARRAY_SIZE(iqs269_events) * IQS269_NUM_CH];
-	unsigned int suspend_mode;
 	unsigned int delay_mult;
 	unsigned int ch_num;
 	bool hall_enable;
@@ -767,17 +763,6 @@ static int iqs269_parse_prop(struct iqs269_private *iqs269)
 	iqs269->hall_enable = device_property_present(&client->dev,
 						      "azoteq,hall-enable");
 
-	if (!device_property_read_u32(&client->dev, "azoteq,suspend-mode",
-				      &val)) {
-		if (val > IQS269_SYS_SETTINGS_PWR_MODE_MAX) {
-			dev_err(&client->dev, "Invalid suspend mode: %u\n",
-				val);
-			return -EINVAL;
-		}
-
-		iqs269->suspend_mode = val;
-	}
-
 	error = regmap_raw_read(iqs269->regmap, IQS269_SYS_SETTINGS, sys_reg,
 				sizeof(*sys_reg));
 	if (error)
@@ -1005,6 +990,17 @@ static int iqs269_parse_prop(struct iqs269_private *iqs269)
 	general &= ~IQS269_SYS_SETTINGS_DIS_AUTO;
 	general &= ~IQS269_SYS_SETTINGS_PWR_MODE_MASK;
 
+	if (!device_property_read_u32(&client->dev, "azoteq,suspend-mode",
+				      &val)) {
+		if (val > IQS269_SYS_SETTINGS_PWR_MODE_MAX) {
+			dev_err(&client->dev, "Invalid suspend mode: %u\n",
+				val);
+			return -EINVAL;
+		}
+
+		general |= (val << IQS269_SYS_SETTINGS_PWR_MODE_SHIFT);
+	}
+
 	if (!device_property_read_u32(&client->dev, "azoteq,ulp-update",
 				      &val)) {
 		if (val > IQS269_SYS_SETTINGS_ULP_UPDATE_MAX) {
@@ -1687,59 +1683,30 @@ static int iqs269_probe(struct i2c_client *client)
 	return error;
 }
 
+static u16 iqs269_general_get(struct iqs269_private *iqs269)
+{
+	u16 general = be16_to_cpu(iqs269->sys_reg.general);
+
+	general &= ~IQS269_SYS_SETTINGS_REDO_ATI;
+	general &= ~IQS269_SYS_SETTINGS_ACK_RESET;
+
+	return general | IQS269_SYS_SETTINGS_DIS_AUTO;
+}
+
 static int __maybe_unused iqs269_suspend(struct device *dev)
 {
 	struct iqs269_private *iqs269 = dev_get_drvdata(dev);
 	struct i2c_client *client = iqs269->client;
-	unsigned int val;
 	int error;
+	u16 general = iqs269_general_get(iqs269);
 
-	if (!iqs269->suspend_mode)
+	if (!(general & IQS269_SYS_SETTINGS_PWR_MODE_MASK))
 		return 0;
 
 	disable_irq(client->irq);
 
-	/*
-	 * Automatic power mode switching must be disabled before the device is
-	 * forced into any particular power mode. In this case, the device will
-	 * transition into normal-power mode.
-	 */
-	error = regmap_update_bits(iqs269->regmap, IQS269_SYS_SETTINGS,
-				   IQS269_SYS_SETTINGS_DIS_AUTO, ~0);
-	if (error)
-		goto err_irq;
-
-	/*
-	 * The following check ensures the device has completed its transition
-	 * into normal-power mode before a manual mode switch is performed.
-	 */
-	error = regmap_read_poll_timeout(iqs269->regmap, IQS269_SYS_FLAGS, val,
-					!(val & IQS269_SYS_FLAGS_PWR_MODE_MASK),
-					 IQS269_PWR_MODE_POLL_SLEEP_US,
-					 IQS269_PWR_MODE_POLL_TIMEOUT_US);
-	if (error)
-		goto err_irq;
-
-	error = regmap_update_bits(iqs269->regmap, IQS269_SYS_SETTINGS,
-				   IQS269_SYS_SETTINGS_PWR_MODE_MASK,
-				   iqs269->suspend_mode <<
-				   IQS269_SYS_SETTINGS_PWR_MODE_SHIFT);
-	if (error)
-		goto err_irq;
-
-	/*
-	 * This last check ensures the device has completed its transition into
-	 * the desired power mode to prevent any spurious interrupts from being
-	 * triggered after iqs269_suspend has already returned.
-	 */
-	error = regmap_read_poll_timeout(iqs269->regmap, IQS269_SYS_FLAGS, val,
-					 (val & IQS269_SYS_FLAGS_PWR_MODE_MASK)
-					 == (iqs269->suspend_mode <<
-					     IQS269_SYS_FLAGS_PWR_MODE_SHIFT),
-					 IQS269_PWR_MODE_POLL_SLEEP_US,
-					 IQS269_PWR_MODE_POLL_TIMEOUT_US);
+	error = regmap_write(iqs269->regmap, IQS269_SYS_SETTINGS, general);
 
-err_irq:
 	iqs269_irq_wait();
 	enable_irq(client->irq);
 
@@ -1750,43 +1717,20 @@ static int __maybe_unused iqs269_resume(struct device *dev)
 {
 	struct iqs269_private *iqs269 = dev_get_drvdata(dev);
 	struct i2c_client *client = iqs269->client;
-	unsigned int val;
 	int error;
+	u16 general = iqs269_general_get(iqs269);
 
-	if (!iqs269->suspend_mode)
+	if (!(general & IQS269_SYS_SETTINGS_PWR_MODE_MASK))
 		return 0;
 
 	disable_irq(client->irq);
 
-	error = regmap_update_bits(iqs269->regmap, IQS269_SYS_SETTINGS,
-				   IQS269_SYS_SETTINGS_PWR_MODE_MASK, 0);
-	if (error)
-		goto err_irq;
-
-	/*
-	 * This check ensures the device has returned to normal-power mode
-	 * before automatic power mode switching is re-enabled.
-	 */
-	error = regmap_read_poll_timeout(iqs269->regmap, IQS269_SYS_FLAGS, val,
-					!(val & IQS269_SYS_FLAGS_PWR_MODE_MASK),
-					 IQS269_PWR_MODE_POLL_SLEEP_US,
-					 IQS269_PWR_MODE_POLL_TIMEOUT_US);
-	if (error)
-		goto err_irq;
-
-	error = regmap_update_bits(iqs269->regmap, IQS269_SYS_SETTINGS,
-				   IQS269_SYS_SETTINGS_DIS_AUTO, 0);
-	if (error)
-		goto err_irq;
-
-	/*
-	 * This step reports any events that may have been "swallowed" as a
-	 * result of polling PWR_MODE (which automatically acknowledges any
-	 * pending interrupts).
-	 */
-	error = iqs269_report(iqs269);
+	error = regmap_write(iqs269->regmap, IQS269_SYS_SETTINGS,
+			     general & ~IQS269_SYS_SETTINGS_PWR_MODE_MASK);
+	if (!error)
+		error = regmap_write(iqs269->regmap, IQS269_SYS_SETTINGS,
+				     general & ~IQS269_SYS_SETTINGS_DIS_AUTO);
 
-err_irq:
 	iqs269_irq_wait();
 	enable_irq(client->irq);
 
-- 
2.39.2



