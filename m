Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAE143A108
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbhJYThH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236113AbhJYTde (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:33:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B6BF61166;
        Mon, 25 Oct 2021 19:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190137;
        bh=7bLD1MUDdpch80iXr8BwoGJ4m7QmXbw+3iJAhOjMmvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwNVejpNsGUZ6GmhMxtVTUkAjCfkPW+qAq9SuK0i1qhsrfmmSZUPcyi498nG6Po1Q
         CpdImICFFHJXAfxKRb+zv1gVLNgw4Si+3tYRevUvl2FwIu+DhqsH4ljaXeAb6qvMNt
         IXMgoMmVY2uWmehnG1T4tKk8knj/RmW55HM8YoYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 52/58] Input: snvs_pwrkey - add clk handling
Date:   Mon, 25 Oct 2021 21:15:09 +0200
Message-Id: <20211025190946.361691383@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e76b7a400a1c..248bb86f4b3f 100644
--- a/drivers/input/keyboard/snvs_pwrkey.c
+++ b/drivers/input/keyboard/snvs_pwrkey.c
@@ -3,6 +3,7 @@
 // Driver for the IMX SNVS ON/OFF Power Key
 // Copyright (C) 2015 Freescale Semiconductor, Inc. All Rights Reserved.
 
+#include <linux/clk.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -81,6 +82,11 @@ static irqreturn_t imx_snvs_pwrkey_interrupt(int irq, void *dev_id)
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
@@ -93,6 +99,7 @@ static int imx_snvs_pwrkey_probe(struct platform_device *pdev)
 	struct pwrkey_drv_data *pdata = NULL;
 	struct input_dev *input = NULL;
 	struct device_node *np;
+	struct clk *clk;
 	int error;
 
 	/* Get SNVS register Page */
@@ -115,6 +122,28 @@ static int imx_snvs_pwrkey_probe(struct platform_device *pdev)
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



