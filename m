Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C8125970E
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgIAQKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729968AbgIAPia (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:38:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F4A421534;
        Tue,  1 Sep 2020 15:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974710;
        bh=f8pxtx+OyrES5Ep2lPtPO/PT39Gfc/bkyv0MwzHa3LY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJ3A18BU7pSeHzcBgyjhurEQI3X4MxQ3qeUbKR8qXUMAk4belvyF1ommuj9+K/flW
         +oovJnNgIsevl2ESdczRlyHgfFeh8QOB1qRHYD6y1vlTROp49CoErLN4Y/nInQ0pR6
         FT6FemsrBswkXeMAxoqZi4V+BJHt0Es0DQgA8feg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 065/255] media: i2c: imx290: fix reset GPIO pin handling
Date:   Tue,  1 Sep 2020 17:08:41 +0200
Message-Id: <20200901151003.842944928@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Konovalov <andrey.konovalov@linaro.org>

[ Upstream commit 3909a92d7df622b41b9ceeeea694e641cad7667b ]

According to https://www.kernel.org/doc/Documentation/gpio/consumer.txt,

- all of the gpiod_set_value_xxx() functions operate with the *logical*
value. So in imx290_power_on() the reset signal should be cleared
(de-asserted) with gpiod_set_value_cansleep(imx290->rst_gpio, 0), and in
imx290_power_off() the value of 1 must be used to apply/assert the reset
to the sensor. In the device tree the reset pin is described as
GPIO_ACTIVE_LOW, and gpiod_set_value_xxx() functions take this into
account,

- when devm_gpiod_get_optional() is called with GPIOD_ASIS, the GPIO is
not initialized, and the direction must be set later; using a GPIO
without setting its direction first is illegal and will result in undefined
behavior. Fix this by using GPIOD_OUT_HIGH instead of GPIOD_ASIS (this
asserts the reset signal to the sensor initially).

Signed-off-by: Andrey Konovalov <andrey.konovalov@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx290.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/imx290.c b/drivers/media/i2c/imx290.c
index f7678e5a5d879..157a0ed0a8856 100644
--- a/drivers/media/i2c/imx290.c
+++ b/drivers/media/i2c/imx290.c
@@ -628,7 +628,7 @@ static int imx290_power_on(struct device *dev)
 	}
 
 	usleep_range(1, 2);
-	gpiod_set_value_cansleep(imx290->rst_gpio, 1);
+	gpiod_set_value_cansleep(imx290->rst_gpio, 0);
 	usleep_range(30000, 31000);
 
 	return 0;
@@ -641,7 +641,7 @@ static int imx290_power_off(struct device *dev)
 	struct imx290 *imx290 = to_imx290(sd);
 
 	clk_disable_unprepare(imx290->xclk);
-	gpiod_set_value_cansleep(imx290->rst_gpio, 0);
+	gpiod_set_value_cansleep(imx290->rst_gpio, 1);
 	regulator_bulk_disable(IMX290_NUM_SUPPLIES, imx290->supplies);
 
 	return 0;
@@ -760,7 +760,8 @@ static int imx290_probe(struct i2c_client *client)
 		goto free_err;
 	}
 
-	imx290->rst_gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_ASIS);
+	imx290->rst_gpio = devm_gpiod_get_optional(dev, "reset",
+						   GPIOD_OUT_HIGH);
 	if (IS_ERR(imx290->rst_gpio)) {
 		dev_err(dev, "Cannot get reset gpio\n");
 		ret = PTR_ERR(imx290->rst_gpio);
-- 
2.25.1



