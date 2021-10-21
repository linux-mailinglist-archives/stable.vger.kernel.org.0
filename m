Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C541435748
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhJUAZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhJUAYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:24:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44BBB61374;
        Thu, 21 Oct 2021 00:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775753;
        bh=zLzP8MrJRYIhDm6FAqz1hOTnK6Rub1ZHl8XPTbOKq6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mUqp+NfRCcQ0S/OUoD/Jj9xgI4qFxxvRgBVYhVs9Yyfyqlmy5R4odIStRcQ5sLk8Z
         EGl72dE2y0rA4ZqhOyKLthEQ1qVK+llEKWNI/HJBvPNlOYNAlQ9ThntSDV4kgvoVMs
         bOUqHgYXOGbi3Z797ZmW+0+iHB6IXYUuOZF6u1oPKrGhxDUALpr+WmHK9R6AMIlM6g
         o2aTmXsyZ1WIjPvbPKSW/9Wb4n87QVvFpuosHAAQ5LiJ/rixARmoQL9GgH0AfKF6NH
         ShoLEyCoOY+7MXdi/E9YyOyLM5RxqXC8u+cuEdVEEZ6EnVfKmZ8ZdCLF02it6gsbxR
         8y1GOl3yl/yyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/14] Input: snvs_pwrkey - add clk handling
Date:   Wed, 20 Oct 2021 20:21:54 -0400
Message-Id: <20211021002155.1129292-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002155.1129292-1-sashal@kernel.org>
References: <20211021002155.1129292-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit d997cc1715df7b6c3df798881fb9941acf0079f8 ]

On i.MX7S and i.MX8M* (but not i.MX6*) the pwrkey device has an
associated clock. Accessing the registers requires that this clock is
enabled. Binding the driver on at least i.MX7S and i.MX8MP while not
having the clock enabled results in a complete hang of the machine.
(This usually only happens if snvs_pwrkey is built as a module and the
rtc-snvs driver isn't already bound because at bootup the required clk
is on and only gets disabled when the clk framework disables unused clks
late during boot.)

This completes the fix in commit 135be16d3505 ("ARM: dts: imx7s: add
snvs clock to pwrkey").

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20211013062848.2667192-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/snvs_pwrkey.c | 29 ++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/input/keyboard/snvs_pwrkey.c b/drivers/input/keyboard/snvs_pwrkey.c
index 2f5e3ab5ed63..65286762b02a 100644
--- a/drivers/input/keyboard/snvs_pwrkey.c
+++ b/drivers/input/keyboard/snvs_pwrkey.c
@@ -3,6 +3,7 @@
 // Driver for the IMX SNVS ON/OFF Power Key
 // Copyright (C) 2015 Freescale Semiconductor, Inc. All Rights Reserved.
 
+#include <linux/clk.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -99,6 +100,11 @@ static irqreturn_t imx_snvs_pwrkey_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void imx_snvs_pwrkey_disable_clk(void *data)
+{
+	clk_disable_unprepare(data);
+}
+
 static void imx_snvs_pwrkey_act(void *pdata)
 {
 	struct pwrkey_drv_data *pd = pdata;
@@ -111,6 +117,7 @@ static int imx_snvs_pwrkey_probe(struct platform_device *pdev)
 	struct pwrkey_drv_data *pdata;
 	struct input_dev *input;
 	struct device_node *np;
+	struct clk *clk;
 	int error;
 	u32 vid;
 
@@ -134,6 +141,28 @@ static int imx_snvs_pwrkey_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, "KEY_POWER without setting in dts\n");
 	}
 
+	clk = devm_clk_get_optional(&pdev->dev, NULL);
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "Failed to get snvs clock (%pe)\n", clk);
+		return PTR_ERR(clk);
+	}
+
+	error = clk_prepare_enable(clk);
+	if (error) {
+		dev_err(&pdev->dev, "Failed to enable snvs clock (%pe)\n",
+			ERR_PTR(error));
+		return error;
+	}
+
+	error = devm_add_action_or_reset(&pdev->dev,
+					 imx_snvs_pwrkey_disable_clk, clk);
+	if (error) {
+		dev_err(&pdev->dev,
+			"Failed to register clock cleanup handler (%pe)\n",
+			ERR_PTR(error));
+		return error;
+	}
+
 	pdata->wakeup = of_property_read_bool(np, "wakeup-source");
 
 	pdata->irq = platform_get_irq(pdev, 0);
-- 
2.33.0

