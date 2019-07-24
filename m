Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34DF873F45
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbfGXTbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729137AbfGXTbH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:31:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E633A20659;
        Wed, 24 Jul 2019 19:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996666;
        bh=ZGjHeyQUMbx1Gh9QwJq9WrZcByKj9BknvPXN3e4fnX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qXiEzKXRhePGLIzX/DPI0Ez2P/lxpyoaebKzfvCRDlmfZeI11AytuCvGToH59FZVu
         XX1aSr3qq6uMmvaCb0OXufdbBjOv7W0tYVBg8QWxSA951LUEDmgcA8ACbku/2ZESkS
         rVgv4nv6+w1LIQgr0mTK9wFEvP4QYHxVjl7c7740=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Georg Waibel <georg.waibel@sensor-technik.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 176/413] gpio: Fix return value mismatch of function gpiod_get_from_of_node()
Date:   Wed, 24 Jul 2019 21:17:47 +0200
Message-Id: <20190724191747.477033721@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 025bf37725f1929542361eef2245df30badf242e ]

In case the requested gpio property is not found in the device tree, some
callers of gpiod_get_from_of_node() expect a return value of NULL, others
expect -ENOENT.
In particular devm_fwnode_get_index_gpiod_from_child() expects -ENOENT.
Currently it gets a NULL, which breaks the loop that tries all
gpio_suffixes. The result is that a gpio property is not found, even
though it is there.

This patch changes gpiod_get_from_of_node() to return -ENOENT instead
of NULL when the requested gpio property is not found in the device
tree. Additionally it modifies all calling functions to properly
evaluate the return value.

Another approach would be to leave the return value of
gpiod_get_from_of_node() as is and fix the bug in
devm_fwnode_get_index_gpiod_from_child(). Other callers would still need
to be reworked. The effort would be the same as with the chosen solution.

Signed-off-by: Georg Waibel <georg.waibel@sensor-technik.de>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c                 | 6 +-----
 drivers/regulator/da9211-regulator.c   | 2 ++
 drivers/regulator/s2mps11.c            | 4 +++-
 drivers/regulator/s5m8767.c            | 4 +++-
 drivers/regulator/tps65090-regulator.c | 7 ++++---
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index e013d417a936..be1d1d2f8aaa 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -4244,8 +4244,7 @@ EXPORT_SYMBOL_GPL(gpiod_get_index);
  *
  * Returns:
  * On successful request the GPIO pin is configured in accordance with
- * provided @dflags. If the node does not have the requested GPIO
- * property, NULL is returned.
+ * provided @dflags.
  *
  * In case of error an ERR_PTR() is returned.
  */
@@ -4267,9 +4266,6 @@ struct gpio_desc *gpiod_get_from_of_node(struct device_node *node,
 					index, &flags);
 
 	if (!desc || IS_ERR(desc)) {
-		/* If it is not there, just return NULL */
-		if (PTR_ERR(desc) == -ENOENT)
-			return NULL;
 		return desc;
 	}
 
diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
index da37b4ccd834..0309823d2c72 100644
--- a/drivers/regulator/da9211-regulator.c
+++ b/drivers/regulator/da9211-regulator.c
@@ -289,6 +289,8 @@ static struct da9211_pdata *da9211_parse_regulators_dt(
 				  0,
 				  GPIOD_OUT_HIGH | GPIOD_FLAGS_BIT_NONEXCLUSIVE,
 				  "da9211-enable");
+		if (IS_ERR(pdata->gpiod_ren[n]))
+			pdata->gpiod_ren[n] = NULL;
 		n++;
 	}
 
diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 134c62db36c5..b518a81f75a3 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -821,7 +821,9 @@ static void s2mps14_pmic_dt_parse_ext_control_gpio(struct platform_device *pdev,
 				0,
 				GPIOD_OUT_HIGH | GPIOD_FLAGS_BIT_NONEXCLUSIVE,
 				"s2mps11-regulator");
-		if (IS_ERR(gpio[reg])) {
+		if (PTR_ERR(gpio[reg]) == -ENOENT)
+			gpio[reg] = NULL;
+		else if (IS_ERR(gpio[reg])) {
 			dev_err(&pdev->dev, "Failed to get control GPIO for %d/%s\n",
 				reg, rdata[reg].name);
 			continue;
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index bb9d1a083299..6ca27e9d5ef7 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -574,7 +574,9 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 			0,
 			GPIOD_OUT_HIGH | GPIOD_FLAGS_BIT_NONEXCLUSIVE,
 			"s5m8767");
-		if (IS_ERR(rdata->ext_control_gpiod))
+		if (PTR_ERR(rdata->ext_control_gpiod) == -ENOENT)
+			rdata->ext_control_gpiod = NULL;
+		else if (IS_ERR(rdata->ext_control_gpiod))
 			return PTR_ERR(rdata->ext_control_gpiod);
 
 		rdata->id = i;
diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index ca39b3d55123..10ea4b5a0f55 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -371,11 +371,12 @@ static struct tps65090_platform_data *tps65090_parse_dt_reg_data(
 								    "dcdc-ext-control-gpios", 0,
 								    gflags,
 								    "tps65090");
-			if (IS_ERR(rpdata->gpiod))
-				return ERR_CAST(rpdata->gpiod);
-			if (!rpdata->gpiod)
+			if (PTR_ERR(rpdata->gpiod) == -ENOENT) {
 				dev_err(&pdev->dev,
 					"could not find DCDC external control GPIO\n");
+				rpdata->gpiod = NULL;
+			} else if (IS_ERR(rpdata->gpiod))
+				return ERR_CAST(rpdata->gpiod);
 		}
 
 		if (of_property_read_u32(tps65090_matches[idx].of_node,
-- 
2.20.1



