Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42897F6634
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfKJDME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:12:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727380AbfKJCnY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:43:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A43F21D7E;
        Sun, 10 Nov 2019 02:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353804;
        bh=qccNVmZMxv5kQtq0rUpntk6zxaeEGhRVlDuYNiPXVyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyUSeRVPniONhFotUQaMv0PP4WWSbqi/gOefp1bhvDkrm4XtSTA94NBl3VmIOQtKH
         kRGFzJyuQ28uHxxPBPqcWU2HFEsf5ogc1bDYDIzA1ZpTb+fAS1e6eAu9cOwlMpYBAu
         56XsRtIEwj0P6KSdJlPWruOoNuW6FwrNgt6J0fS0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 102/191] gpiolib: Fix gpio_direction_* for single direction GPIOs
Date:   Sat,  9 Nov 2019 21:38:44 -0500
Message-Id: <20191110024013.29782-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

[ Upstream commit ae9847f48a4b4bff0335da20be63ac84d94eb54c ]

GPIOs with no programmable direction are not required to implement
direction_output nor direction_input.

If we try to set an output direction on an output-only GPIO or input
direction on an input-only GPIO simply return 0.

This allows this single direction GPIO to be used by libgpiod.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 565ab945698ca..b81a27c7f89c4 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2541,19 +2541,27 @@ EXPORT_SYMBOL_GPL(gpiochip_free_own_desc);
 int gpiod_direction_input(struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
-	int			status = -EINVAL;
+	int			status = 0;
 
 	VALIDATE_DESC(desc);
 	chip = desc->gdev->chip;
 
-	if (!chip->get || !chip->direction_input) {
+	if (!chip->get && chip->direction_input) {
 		gpiod_warn(desc,
-			"%s: missing get() or direction_input() operations\n",
+			"%s: missing get() and direction_input() operations\n",
 			__func__);
 		return -EIO;
 	}
 
-	status = chip->direction_input(chip, gpio_chip_hwgpio(desc));
+	if (chip->direction_input) {
+		status = chip->direction_input(chip, gpio_chip_hwgpio(desc));
+	} else if (chip->get_direction &&
+		  (chip->get_direction(chip, gpio_chip_hwgpio(desc)) != 1)) {
+		gpiod_warn(desc,
+			"%s: missing direction_input() operation\n",
+			__func__);
+		return -EIO;
+	}
 	if (status == 0)
 		clear_bit(FLAG_IS_OUT, &desc->flags);
 
@@ -2575,16 +2583,28 @@ static int gpiod_direction_output_raw_commit(struct gpio_desc *desc, int value)
 {
 	struct gpio_chip *gc = desc->gdev->chip;
 	int val = !!value;
-	int ret;
+	int ret = 0;
 
-	if (!gc->set || !gc->direction_output) {
+	if (!gc->set && !gc->direction_output) {
 		gpiod_warn(desc,
-		       "%s: missing set() or direction_output() operations\n",
+		       "%s: missing set() and direction_output() operations\n",
 		       __func__);
 		return -EIO;
 	}
 
-	ret = gc->direction_output(gc, gpio_chip_hwgpio(desc), val);
+	if (gc->direction_output) {
+		ret = gc->direction_output(gc, gpio_chip_hwgpio(desc), val);
+	} else {
+		if (gc->get_direction &&
+		    gc->get_direction(gc, gpio_chip_hwgpio(desc))) {
+			gpiod_warn(desc,
+				"%s: missing direction_output() operation\n",
+				__func__);
+			return -EIO;
+		}
+		gc->set(gc, gpio_chip_hwgpio(desc), val);
+	}
+
 	if (!ret)
 		set_bit(FLAG_IS_OUT, &desc->flags);
 	trace_gpio_value(desc_to_gpio(desc), 0, val);
-- 
2.20.1

