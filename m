Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C1E1EF7D4
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 14:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgFEMZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 08:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726630AbgFEMZV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 08:25:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4CF82074B;
        Fri,  5 Jun 2020 12:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591359920;
        bh=Z3DGRWOMQLerGZ/bOAAQDfRxRmJUKGSB4aII1yOLWlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2lMUOfx6LUw6bs6Sw/St4yUxTA1OJnBssB8iEUxtuD2eYeI8PWHFd9Im52qTdzjE
         ML+hY2l16AXtK/dFKowhzSnHaqIJD7g05oUHAt2CL71qoRoxdlWUeL/eNyenIZqVvc
         1MShL2+0YJPRY/fwATzLNMtrt6tvDSW6S27tbOAs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>, Chen-Yu Tsai <wens@csie.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 02/17] Input: axp20x-pek - always register interrupt handlers
Date:   Fri,  5 Jun 2020 08:25:01 -0400
Message-Id: <20200605122517.2882338-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200605122517.2882338-1-sashal@kernel.org>
References: <20200605122517.2882338-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 9747070c11d6ae021ed7a8e96e2950ed46cd53a9 ]

On some X86 devices we do not register an input-device, because the
power-button is also handled by the soc_button_array (GPIO) input driver,
and we want to avoid reporting power-button presses to userspace twice.

Sofar when we did this we also did not register our interrupt handlers,
since those were only necessary to report input events.

But on at least 2 device models the Medion Akoya E1239T and the GPD win,
the GPIO pin used by the soc_button_array driver for the power-button
cannot wakeup the system from suspend. Why this does not work is not clear,
I've tried comparing the value of all relevant registers on the Cherry
Trail SoC, with those from models where this does work. I've checked:
PMC registers: FUNC_DIS, FUNC_DIS2, SOIX_WAKE_EN, D3_STS_0, D3_STS_1,
D3_STDBY_STS_0, D3_STDBY_STS_1; PMC ACPI I/O regs: PM1_STS_EN, GPE0a_EN
and they all have identical contents in the working and non working cases.
I suspect that the firmware either sets some unknown register to a value
causing this, or that it turns off a power-plane which is necessary for
GPIO wakeups to work during suspend.

What does work on the Medion Akoya E1239T is letting the AXP288 wakeup
the system on a power-button press (the GPD win has a different PMIC).

Move the registering of the power-button press/release interrupt-handler
from axp20x_pek_probe_input_device() to axp20x_pek_probe() so that the
PMIC will wakeup the system on a power-button press, even if we do not
register an input device.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20200426155757.297087-1-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/axp20x-pek.c | 72 +++++++++++++++++----------------
 1 file changed, 37 insertions(+), 35 deletions(-)

diff --git a/drivers/input/misc/axp20x-pek.c b/drivers/input/misc/axp20x-pek.c
index c8f87df93a50..9c6386b2af33 100644
--- a/drivers/input/misc/axp20x-pek.c
+++ b/drivers/input/misc/axp20x-pek.c
@@ -205,8 +205,11 @@ ATTRIBUTE_GROUPS(axp20x);
 
 static irqreturn_t axp20x_pek_irq(int irq, void *pwr)
 {
-	struct input_dev *idev = pwr;
-	struct axp20x_pek *axp20x_pek = input_get_drvdata(idev);
+	struct axp20x_pek *axp20x_pek = pwr;
+	struct input_dev *idev = axp20x_pek->input;
+
+	if (!idev)
+		return IRQ_HANDLED;
 
 	/*
 	 * The power-button is connected to ground so a falling edge (dbf)
@@ -225,22 +228,9 @@ static irqreturn_t axp20x_pek_irq(int irq, void *pwr)
 static int axp20x_pek_probe_input_device(struct axp20x_pek *axp20x_pek,
 					 struct platform_device *pdev)
 {
-	struct axp20x_dev *axp20x = axp20x_pek->axp20x;
 	struct input_dev *idev;
 	int error;
 
-	axp20x_pek->irq_dbr = platform_get_irq_byname(pdev, "PEK_DBR");
-	if (axp20x_pek->irq_dbr < 0)
-		return axp20x_pek->irq_dbr;
-	axp20x_pek->irq_dbr = regmap_irq_get_virq(axp20x->regmap_irqc,
-						  axp20x_pek->irq_dbr);
-
-	axp20x_pek->irq_dbf = platform_get_irq_byname(pdev, "PEK_DBF");
-	if (axp20x_pek->irq_dbf < 0)
-		return axp20x_pek->irq_dbf;
-	axp20x_pek->irq_dbf = regmap_irq_get_virq(axp20x->regmap_irqc,
-						  axp20x_pek->irq_dbf);
-
 	axp20x_pek->input = devm_input_allocate_device(&pdev->dev);
 	if (!axp20x_pek->input)
 		return -ENOMEM;
@@ -255,24 +245,6 @@ static int axp20x_pek_probe_input_device(struct axp20x_pek *axp20x_pek,
 
 	input_set_drvdata(idev, axp20x_pek);
 
-	error = devm_request_any_context_irq(&pdev->dev, axp20x_pek->irq_dbr,
-					     axp20x_pek_irq, 0,
-					     "axp20x-pek-dbr", idev);
-	if (error < 0) {
-		dev_err(&pdev->dev, "Failed to request dbr IRQ#%d: %d\n",
-			axp20x_pek->irq_dbr, error);
-		return error;
-	}
-
-	error = devm_request_any_context_irq(&pdev->dev, axp20x_pek->irq_dbf,
-					  axp20x_pek_irq, 0,
-					  "axp20x-pek-dbf", idev);
-	if (error < 0) {
-		dev_err(&pdev->dev, "Failed to request dbf IRQ#%d: %d\n",
-			axp20x_pek->irq_dbf, error);
-		return error;
-	}
-
 	error = input_register_device(idev);
 	if (error) {
 		dev_err(&pdev->dev, "Can't register input device: %d\n",
@@ -280,8 +252,6 @@ static int axp20x_pek_probe_input_device(struct axp20x_pek *axp20x_pek,
 		return error;
 	}
 
-	device_init_wakeup(&pdev->dev, true);
-
 	return 0;
 }
 
@@ -339,6 +309,18 @@ static int axp20x_pek_probe(struct platform_device *pdev)
 
 	axp20x_pek->axp20x = dev_get_drvdata(pdev->dev.parent);
 
+	axp20x_pek->irq_dbr = platform_get_irq_byname(pdev, "PEK_DBR");
+	if (axp20x_pek->irq_dbr < 0)
+		return axp20x_pek->irq_dbr;
+	axp20x_pek->irq_dbr = regmap_irq_get_virq(
+			axp20x_pek->axp20x->regmap_irqc, axp20x_pek->irq_dbr);
+
+	axp20x_pek->irq_dbf = platform_get_irq_byname(pdev, "PEK_DBF");
+	if (axp20x_pek->irq_dbf < 0)
+		return axp20x_pek->irq_dbf;
+	axp20x_pek->irq_dbf = regmap_irq_get_virq(
+			axp20x_pek->axp20x->regmap_irqc, axp20x_pek->irq_dbf);
+
 	if (axp20x_pek_should_register_input(axp20x_pek, pdev)) {
 		error = axp20x_pek_probe_input_device(axp20x_pek, pdev);
 		if (error)
@@ -347,6 +329,26 @@ static int axp20x_pek_probe(struct platform_device *pdev)
 
 	axp20x_pek->info = (struct axp20x_info *)match->driver_data;
 
+	error = devm_request_any_context_irq(&pdev->dev, axp20x_pek->irq_dbr,
+					     axp20x_pek_irq, 0,
+					     "axp20x-pek-dbr", axp20x_pek);
+	if (error < 0) {
+		dev_err(&pdev->dev, "Failed to request dbr IRQ#%d: %d\n",
+			axp20x_pek->irq_dbr, error);
+		return error;
+	}
+
+	error = devm_request_any_context_irq(&pdev->dev, axp20x_pek->irq_dbf,
+					  axp20x_pek_irq, 0,
+					  "axp20x-pek-dbf", axp20x_pek);
+	if (error < 0) {
+		dev_err(&pdev->dev, "Failed to request dbf IRQ#%d: %d\n",
+			axp20x_pek->irq_dbf, error);
+		return error;
+	}
+
+	device_init_wakeup(&pdev->dev, true);
+
 	platform_set_drvdata(pdev, axp20x_pek);
 
 	return 0;
-- 
2.25.1

