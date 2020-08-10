Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F46024090D
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgHJP21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:28:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728852AbgHJP2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:28:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3412222B47;
        Mon, 10 Aug 2020 15:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073304;
        bh=317EpMwDFiRhWwkPj/R6GWOmMwQrCN5rBjTVaLkskPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sSjpj1llax/nHOR5fdLb8gYM7rkqrKcQi67Jj0axL1tZtV0KcDbiDY9dY4Gasxgm/
         x7ryHzTnV/q2APxR2FlxypPWNubxK8BZi9GdVmDs2+dzrboC0HWYpL2UUo/AKc74qH
         hmdlhQ2TQea561SXy3RJoTvTtEvCczgx+jr9VRUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Johan Hovold <johan@kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 5.4 27/67] leds: lm36274: fix use-after-free on unbind
Date:   Mon, 10 Aug 2020 17:21:14 +0200
Message-Id: <20200810151810.769207255@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit a0972fff09479dd09b731360a3a0b09e4fb4d415 upstream.

Several MFD child drivers register their class devices directly under
the parent device. This means you cannot use devres so that
deregistration ends up being tied to the parent device, something which
leads to use-after-free on driver unbind when the class device is
released while still being registered.

Fixes: 11e1bbc116a7 ("leds: lm36274: Introduce the TI LM36274 LED driver")
Cc: stable <stable@vger.kernel.org>     # 5.3
Cc: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/leds/leds-lm36274.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/leds/leds-lm36274.c
+++ b/drivers/leds/leds-lm36274.c
@@ -133,7 +133,7 @@ static int lm36274_probe(struct platform
 	lm36274_data->pdev = pdev;
 	lm36274_data->dev = lmu->dev;
 	lm36274_data->regmap = lmu->regmap;
-	dev_set_drvdata(&pdev->dev, lm36274_data);
+	platform_set_drvdata(pdev, lm36274_data);
 
 	ret = lm36274_parse_dt(lm36274_data);
 	if (ret) {
@@ -147,8 +147,16 @@ static int lm36274_probe(struct platform
 		return ret;
 	}
 
-	return devm_led_classdev_register(lm36274_data->dev,
-					 &lm36274_data->led_dev);
+	return led_classdev_register(lm36274_data->dev, &lm36274_data->led_dev);
+}
+
+static int lm36274_remove(struct platform_device *pdev)
+{
+	struct lm36274 *lm36274_data = platform_get_drvdata(pdev);
+
+	led_classdev_unregister(&lm36274_data->led_dev);
+
+	return 0;
 }
 
 static const struct of_device_id of_lm36274_leds_match[] = {
@@ -159,6 +167,7 @@ MODULE_DEVICE_TABLE(of, of_lm36274_leds_
 
 static struct platform_driver lm36274_driver = {
 	.probe  = lm36274_probe,
+	.remove = lm36274_remove,
 	.driver = {
 		.name = "lm36274-leds",
 	},


