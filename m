Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370A5540CA1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344586AbiFGSiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345751AbiFGSh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:37:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E0A183167;
        Tue,  7 Jun 2022 10:58:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CA516188F;
        Tue,  7 Jun 2022 17:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FE0C34115;
        Tue,  7 Jun 2022 17:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624684;
        bh=bRY/gw9+Ff/WWGwoCHJHW/oLysNKgFiDMq+PAeNHfTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u2SiCmtd28Ai4u4Vzfjd/aumQ5rW1qaqqR+h/2Pvxv/L5A9MeoQXccf8Wal2d8t4a
         quyzwB1O+nzrTdvwWP/4Hhel1GPxzJMkR78nrheqsocJ4pt1nxT32P7bFoGCAETGNb
         7qK64MWQUYHV9IELM89G0TzU8sjdgLCRCxYU4+lg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Caleb Connolly <kc@postmarketos.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 416/667] pinctrl/rockchip: support deferring other gpio params
Date:   Tue,  7 Jun 2022 19:01:21 +0200
Message-Id: <20220607164947.214625947@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Caleb Connolly <kc@postmarketos.org>

[ Upstream commit 8ce5ef64546850294b021497046588a7abcebe96 ]

Add support for deferring other params like PIN_CONFIG_INPUT_ENABLE.
This will be used to add support for PIN_CONFIG_INPUT_ENABLE to the
driver.

Fixes: e7165b1dff06 ("pinctrl/rockchip: add a queue for deferred pin output settings on probe")
Fixes: 59dd178e1d7c ("gpio/rockchip: fetch deferred output settings on probe")
Signed-off-by: Caleb Connolly <kc@postmarketos.org>
Link: https://lore.kernel.org/r/20220328005005.72492-2-kc@postmarketos.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-rockchip.c       | 24 ++++++++-----
 drivers/pinctrl/pinctrl-rockchip.c | 54 ++++++++++++++++--------------
 drivers/pinctrl/pinctrl-rockchip.h |  7 ++--
 3 files changed, 50 insertions(+), 35 deletions(-)

diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index 24155c038f6d..22b8f0aa80f1 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -19,6 +19,7 @@
 #include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
+#include <linux/pinctrl/pinconf-generic.h>
 #include <linux/regmap.h>
 
 #include "../pinctrl/core.h"
@@ -691,7 +692,7 @@ static int rockchip_gpio_probe(struct platform_device *pdev)
 	struct device_node *pctlnp = of_get_parent(np);
 	struct pinctrl_dev *pctldev = NULL;
 	struct rockchip_pin_bank *bank = NULL;
-	struct rockchip_pin_output_deferred *cfg;
+	struct rockchip_pin_deferred *cfg;
 	static int gpio;
 	int id, ret;
 
@@ -732,15 +733,22 @@ static int rockchip_gpio_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	while (!list_empty(&bank->deferred_output)) {
-		cfg = list_first_entry(&bank->deferred_output,
-				       struct rockchip_pin_output_deferred, head);
+	while (!list_empty(&bank->deferred_pins)) {
+		cfg = list_first_entry(&bank->deferred_pins,
+				       struct rockchip_pin_deferred, head);
 		list_del(&cfg->head);
 
-		ret = rockchip_gpio_direction_output(&bank->gpio_chip, cfg->pin, cfg->arg);
-		if (ret)
-			dev_warn(dev, "setting output pin %u to %u failed\n", cfg->pin, cfg->arg);
-
+		switch (cfg->param) {
+		case PIN_CONFIG_OUTPUT:
+			ret = rockchip_gpio_direction_output(&bank->gpio_chip, cfg->pin, cfg->arg);
+			if (ret)
+				dev_warn(dev, "setting output pin %u to %u failed\n", cfg->pin,
+					 cfg->arg);
+			break;
+		default:
+			dev_warn(dev, "unknown deferred config param %d\n", cfg->param);
+			break;
+		}
 		kfree(cfg);
 	}
 
diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 543a4991cf70..d80842034939 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2107,19 +2107,20 @@ static bool rockchip_pinconf_pull_valid(struct rockchip_pin_ctrl *ctrl,
 	return false;
 }
 
-static int rockchip_pinconf_defer_output(struct rockchip_pin_bank *bank,
-					 unsigned int pin, u32 arg)
+static int rockchip_pinconf_defer_pin(struct rockchip_pin_bank *bank,
+					 unsigned int pin, u32 param, u32 arg)
 {
-	struct rockchip_pin_output_deferred *cfg;
+	struct rockchip_pin_deferred *cfg;
 
 	cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
 	if (!cfg)
 		return -ENOMEM;
 
 	cfg->pin = pin;
+	cfg->param = param;
 	cfg->arg = arg;
 
-	list_add_tail(&cfg->head, &bank->deferred_output);
+	list_add_tail(&cfg->head, &bank->deferred_pins);
 
 	return 0;
 }
@@ -2140,6 +2141,25 @@ static int rockchip_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 		param = pinconf_to_config_param(configs[i]);
 		arg = pinconf_to_config_argument(configs[i]);
 
+		if (param == (PIN_CONFIG_OUTPUT | PIN_CONFIG_INPUT_ENABLE)) {
+			/*
+			 * Check for gpio driver not being probed yet.
+			 * The lock makes sure that either gpio-probe has completed
+			 * or the gpio driver hasn't probed yet.
+			 */
+			mutex_lock(&bank->deferred_lock);
+			if (!gpio || !gpio->direction_output) {
+				rc = rockchip_pinconf_defer_pin(bank, pin - bank->pin_base, param,
+								arg);
+				mutex_unlock(&bank->deferred_lock);
+				if (rc)
+					return rc;
+
+				break;
+			}
+			mutex_unlock(&bank->deferred_lock);
+		}
+
 		switch (param) {
 		case PIN_CONFIG_BIAS_DISABLE:
 			rc =  rockchip_set_pull(bank, pin - bank->pin_base,
@@ -2168,22 +2188,6 @@ static int rockchip_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 			if (rc != RK_FUNC_GPIO)
 				return -EINVAL;
 
-			/*
-			 * Check for gpio driver not being probed yet.
-			 * The lock makes sure that either gpio-probe has completed
-			 * or the gpio driver hasn't probed yet.
-			 */
-			mutex_lock(&bank->deferred_lock);
-			if (!gpio || !gpio->direction_output) {
-				rc = rockchip_pinconf_defer_output(bank, pin - bank->pin_base, arg);
-				mutex_unlock(&bank->deferred_lock);
-				if (rc)
-					return rc;
-
-				break;
-			}
-			mutex_unlock(&bank->deferred_lock);
-
 			rc = gpio->direction_output(gpio, pin - bank->pin_base,
 						    arg);
 			if (rc)
@@ -2504,7 +2508,7 @@ static int rockchip_pinctrl_register(struct platform_device *pdev,
 			pdesc++;
 		}
 
-		INIT_LIST_HEAD(&pin_bank->deferred_output);
+		INIT_LIST_HEAD(&pin_bank->deferred_pins);
 		mutex_init(&pin_bank->deferred_lock);
 	}
 
@@ -2778,7 +2782,7 @@ static int rockchip_pinctrl_remove(struct platform_device *pdev)
 {
 	struct rockchip_pinctrl *info = platform_get_drvdata(pdev);
 	struct rockchip_pin_bank *bank;
-	struct rockchip_pin_output_deferred *cfg;
+	struct rockchip_pin_deferred *cfg;
 	int i;
 
 	of_platform_depopulate(&pdev->dev);
@@ -2787,9 +2791,9 @@ static int rockchip_pinctrl_remove(struct platform_device *pdev)
 		bank = &info->ctrl->pin_banks[i];
 
 		mutex_lock(&bank->deferred_lock);
-		while (!list_empty(&bank->deferred_output)) {
-			cfg = list_first_entry(&bank->deferred_output,
-					       struct rockchip_pin_output_deferred, head);
+		while (!list_empty(&bank->deferred_pins)) {
+			cfg = list_first_entry(&bank->deferred_pins,
+					       struct rockchip_pin_deferred, head);
 			list_del(&cfg->head);
 			kfree(cfg);
 		}
diff --git a/drivers/pinctrl/pinctrl-rockchip.h b/drivers/pinctrl/pinctrl-rockchip.h
index 91f10279d084..98a01a616da6 100644
--- a/drivers/pinctrl/pinctrl-rockchip.h
+++ b/drivers/pinctrl/pinctrl-rockchip.h
@@ -171,7 +171,7 @@ struct rockchip_pin_bank {
 	u32				toggle_edge_mode;
 	u32				recalced_mask;
 	u32				route_mask;
-	struct list_head		deferred_output;
+	struct list_head		deferred_pins;
 	struct mutex			deferred_lock;
 };
 
@@ -247,9 +247,12 @@ struct rockchip_pin_config {
 	unsigned int		nconfigs;
 };
 
-struct rockchip_pin_output_deferred {
+enum pin_config_param;
+
+struct rockchip_pin_deferred {
 	struct list_head head;
 	unsigned int pin;
+	enum pin_config_param param;
 	u32 arg;
 };
 
-- 
2.35.1



