Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6823C470F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbhGLGbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236372AbhGLGaK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB0DE610A6;
        Mon, 12 Jul 2021 06:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071242;
        bh=Umzc23PRMOA9x+bTn11sbw1pQPLGyVJam2PZq0wXydw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jDNUuHnjZ24D6erhrZQgLuAYiObSNIc6NrSKaHn0vpaBAUjmS+hTgn7OzQtKkB79
         JfGfeEGaF90ilpSW3OjcILRg/LxWwDfar6ktQihLWLfn3YDW6fInjvrxp8S91Om9OH
         A6PqOHRRkJYwGjF5aZddo9WA7anv9evIGl8a/3YY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 334/348] leds: ktd2692: Fix an error handling path
Date:   Mon, 12 Jul 2021 08:11:58 +0200
Message-Id: <20210712060748.443993995@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index 670efee9b131..cd30b3b46e76 100644
--- a/drivers/leds/leds-ktd2692.c
+++ b/drivers/leds/leds-ktd2692.c
@@ -256,6 +256,17 @@ static void ktd2692_setup(struct ktd2692_context *led)
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
@@ -286,8 +297,14 @@ static int ktd2692_parse_dt(struct ktd2692_context *led, struct device *dev,
 
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
@@ -377,17 +394,9 @@ static int ktd2692_probe(struct platform_device *pdev)
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



