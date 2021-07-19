Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08B43CDDCC
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245484AbhGSPAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343785AbhGSO7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DB3161400;
        Mon, 19 Jul 2021 15:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709026;
        bh=dNMDX0yeP7Lhgmi9O4rPagiGeruxu2zsPOFAHtUz8tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zP3qijmz9R+Ri8fwARaJ5o8bGv+SfhKSOkoZvit9BAnOadBpi8zxauWmEwOxSlycV
         IW+Z88c7y0b+lzyzax7drIsIB5Pqfg+5xcBoC4+Lcr6sf4vaLCJsaw+hzYEoxxL0qJ
         tsiqiDyGDGGvIObZHtm2oKYEAP0CQgEVv4C3J9xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 217/421] leds: ktd2692: Fix an error handling path
Date:   Mon, 19 Jul 2021 16:50:28 +0200
Message-Id: <20210719144953.848976469@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ee78b9360e14c276f5ceaa4a0d06f790f04ccdad ]

In 'ktd2692_parse_dt()', if an error occurs after a successful
'regulator_enable()' call, we should call 'regulator_enable()'.

This is the same in 'ktd2692_probe()', if an error occurs after a
successful 'ktd2692_parse_dt()' call.

Instead of adding 'regulator_enable()' in several places, implement a
resource managed solution and simplify the remove function accordingly.

Fixes: b7da8c5c725c ("leds: Add ktd2692 flash LED driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-ktd2692.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/leds/leds-ktd2692.c b/drivers/leds/leds-ktd2692.c
index 45296aaca9da..02738b5b1dbf 100644
--- a/drivers/leds/leds-ktd2692.c
+++ b/drivers/leds/leds-ktd2692.c
@@ -259,6 +259,17 @@ static void ktd2692_setup(struct ktd2692_context *led)
 				 | KTD2692_REG_FLASH_CURRENT_BASE);
 }
 
+static void regulator_disable_action(void *_data)
+{
+	struct device *dev = _data;
+	struct ktd2692_context *led = dev_get_drvdata(dev);
+	int ret;
+
+	ret = regulator_disable(led->regulator);
+	if (ret)
+		dev_err(dev, "Failed to disable supply: %d\n", ret);
+}
+
 static int ktd2692_parse_dt(struct ktd2692_context *led, struct device *dev,
 			    struct ktd2692_led_config_data *cfg)
 {
@@ -289,8 +300,14 @@ static int ktd2692_parse_dt(struct ktd2692_context *led, struct device *dev,
 
 	if (led->regulator) {
 		ret = regulator_enable(led->regulator);
-		if (ret)
+		if (ret) {
 			dev_err(dev, "Failed to enable supply: %d\n", ret);
+		} else {
+			ret = devm_add_action_or_reset(dev,
+						regulator_disable_action, dev);
+			if (ret)
+				return ret;
+		}
 	}
 
 	child_node = of_get_next_available_child(np, NULL);
@@ -380,17 +397,9 @@ static int ktd2692_probe(struct platform_device *pdev)
 static int ktd2692_remove(struct platform_device *pdev)
 {
 	struct ktd2692_context *led = platform_get_drvdata(pdev);
-	int ret;
 
 	led_classdev_flash_unregister(&led->fled_cdev);
 
-	if (led->regulator) {
-		ret = regulator_disable(led->regulator);
-		if (ret)
-			dev_err(&pdev->dev,
-				"Failed to disable supply: %d\n", ret);
-	}
-
 	mutex_destroy(&led->lock);
 
 	return 0;
-- 
2.30.2



