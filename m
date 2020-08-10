Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED40F24085A
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgHJPUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbgHJPUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:20:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86F4522B4B;
        Mon, 10 Aug 2020 15:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072814;
        bh=AGOMaizvFy9TjsAgvMYtf9C1QGamiHd6Zvyz19yNHMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrS2M9K5wC6B+UL/lXGqC5ZYPhbwKjOQtWGLfQMaE12BtZaX6X3CmmlAHg7qMnndf
         Noy1jh8GlB+XMRCW1/hIO6Zb1HaKfueGEmwODLR36IwLJYxHgZS7IwhbR+vzVwG5n1
         hjVpQV4wAHoxu9A5lVIqmaIT4j5zV98VcUDB6Q6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        Johan Hovold <johan@kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 5.8 27/38] leds: da903x: fix use-after-free on unbind
Date:   Mon, 10 Aug 2020 17:19:17 +0200
Message-Id: <20200810151805.236512093@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151803.920113428@linuxfoundation.org>
References: <20200810151803.920113428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 6f4aa35744f69ed9b0bf5a736c9ca9b44bc1dcea upstream.

Several MFD child drivers register their class devices directly under
the parent device. This means you cannot blindly do devres conversions
so that deregistration ends up being tied to the parent device,
something which leads to use-after-free on driver unbind when the class
device is released while still being registered.

Fixes: eed16255d66b ("leds: da903x: Use devm_led_classdev_register")
Cc: stable <stable@vger.kernel.org>     # 4.6
Cc: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/leds/leds-da903x.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/leds/leds-da903x.c
+++ b/drivers/leds/leds-da903x.c
@@ -110,12 +110,23 @@ static int da903x_led_probe(struct platf
 	led->flags = pdata->flags;
 	led->master = pdev->dev.parent;
 
-	ret = devm_led_classdev_register(led->master, &led->cdev);
+	ret = led_classdev_register(led->master, &led->cdev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register LED %d\n", id);
 		return ret;
 	}
 
+	platform_set_drvdata(pdev, led);
+
+	return 0;
+}
+
+static int da903x_led_remove(struct platform_device *pdev)
+{
+	struct da903x_led *led = platform_get_drvdata(pdev);
+
+	led_classdev_unregister(&led->cdev);
+
 	return 0;
 }
 
@@ -124,6 +135,7 @@ static struct platform_driver da903x_led
 		.name	= "da903x-led",
 	},
 	.probe		= da903x_led_probe,
+	.remove		= da903x_led_remove,
 };
 
 module_platform_driver(da903x_led_driver);


