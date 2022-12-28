Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3100657D93
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbiL1Poi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbiL1Pog (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:44:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15A317423
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:44:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 909316155E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A325BC433F0;
        Wed, 28 Dec 2022 15:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242275;
        bh=gLMAYmGvZXOm+sdEvg9NA9/6gcoOyK5lv4EWGoSi33Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTtGniQTiET+nHU0WCQ5ppvj9V5osGbODg7RlIUwf7V4rnB1bmkbHaoCON6YZ5GTW
         J8/0qBJgBGoLuIwnBf7usNUpZSvuZ2Hoy7GLQQvWDbZyuCkhyQfuiN/E+VzvDKWBx5
         BRYDN0pNUAjLwJWIvRTF3wmKc9hXQuBck6GDMamE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Douglas Anderson <dianders@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0349/1146] Input: elants_i2c - properly handle the reset GPIO when power is off
Date:   Wed, 28 Dec 2022 15:31:28 +0100
Message-Id: <20221228144339.641668378@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit a85fbd6498441694475716a4d5c65f9d3e073faf ]

As can be seen in elants_i2c_power_off(), we want the reset GPIO
asserted when power is off. The reset GPIO is active low so we need
the reset line logic low when power is off to avoid leakage.

We have a problem, though, at probe time. At probe time we haven't
powered the regulators on yet but we have:

  devm_gpiod_get(&client->dev, "reset", GPIOD_OUT_LOW);

While that _looks_ right, it turns out that it's not. The
GPIOD_OUT_LOW doesn't mean to init the GPIO to low. It means init the
GPIO to "not asserted". Since this is an active low GPIO that inits it
to be high.

Let's fix this to properly init the GPIO. Now after both probe and
power off the state of the GPIO is consistent (it's "asserted" or
level low).

Once we fix this, we can see that at power on time we no longer to
assert the reset GPIO as the first thing. The reset GPIO is _always_
asserted before powering on. Let's fix powering on to account for
this.

Fixes: afe10358e47a ("Input: elants_i2c - wire up regulator support")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20221117123805.1.I9959ac561dd6e1e8e1ce7085e4de6167b27c574f@changeid
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/elants_i2c.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/elants_i2c.c b/drivers/input/touchscreen/elants_i2c.c
index 879a4d984c90..e1308e179dd6 100644
--- a/drivers/input/touchscreen/elants_i2c.c
+++ b/drivers/input/touchscreen/elants_i2c.c
@@ -1329,14 +1329,12 @@ static int elants_i2c_power_on(struct elants_data *ts)
 	if (IS_ERR_OR_NULL(ts->reset_gpio))
 		return 0;
 
-	gpiod_set_value_cansleep(ts->reset_gpio, 1);
-
 	error = regulator_enable(ts->vcc33);
 	if (error) {
 		dev_err(&ts->client->dev,
 			"failed to enable vcc33 regulator: %d\n",
 			error);
-		goto release_reset_gpio;
+		return error;
 	}
 
 	error = regulator_enable(ts->vccio);
@@ -1345,7 +1343,7 @@ static int elants_i2c_power_on(struct elants_data *ts)
 			"failed to enable vccio regulator: %d\n",
 			error);
 		regulator_disable(ts->vcc33);
-		goto release_reset_gpio;
+		return error;
 	}
 
 	/*
@@ -1354,7 +1352,6 @@ static int elants_i2c_power_on(struct elants_data *ts)
 	 */
 	udelay(ELAN_POWERON_DELAY_USEC);
 
-release_reset_gpio:
 	gpiod_set_value_cansleep(ts->reset_gpio, 0);
 	if (error)
 		return error;
@@ -1462,7 +1459,7 @@ static int elants_i2c_probe(struct i2c_client *client)
 		return error;
 	}
 
-	ts->reset_gpio = devm_gpiod_get(&client->dev, "reset", GPIOD_OUT_LOW);
+	ts->reset_gpio = devm_gpiod_get(&client->dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(ts->reset_gpio)) {
 		error = PTR_ERR(ts->reset_gpio);
 
-- 
2.35.1



