Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1C424088A
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgHJPVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbgHJPUU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:20:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A9CA22B4B;
        Mon, 10 Aug 2020 15:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072819;
        bh=OI8L8JHWA4I07xOnOfrugVYN6Wsn1SSxQOR6XVPL8Yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+2fOlymb0QreXYIqA2Sgux9MBcFmFDnWobQL74jI4/4PZ2o93Oxkmnjhj++cKTeE
         ecSX1m7as7atZHsbCJH49A7/nrpxSGkSiZd03rQ/R8BBbpvAQCmfA6yYzGr2zb2kyB
         bFZ9Z4VMW6Z6rUMPVLJxjO14JzN9p5rixWK3MAKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        Johan Hovold <johan@kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 5.8 29/38] leds: 88pm860x: fix use-after-free on unbind
Date:   Mon, 10 Aug 2020 17:19:19 +0200
Message-Id: <20200810151805.342635725@linuxfoundation.org>
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

commit eca21c2d8655387823d695b26e6fe78cf3975c05 upstream.

Several MFD child drivers register their class devices directly under
the parent device. This means you cannot blindly do devres conversions
so that deregistration ends up being tied to the parent device,
something which leads to use-after-free on driver unbind when the class
device is released while still being registered.

Fixes: 375446df95ee ("leds: 88pm860x: Use devm_led_classdev_register")
Cc: stable <stable@vger.kernel.org>     # 4.6
Cc: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/leds/leds-88pm860x.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/leds/leds-88pm860x.c
+++ b/drivers/leds/leds-88pm860x.c
@@ -203,21 +203,33 @@ static int pm860x_led_probe(struct platf
 	data->cdev.brightness_set_blocking = pm860x_led_set;
 	mutex_init(&data->lock);
 
-	ret = devm_led_classdev_register(chip->dev, &data->cdev);
+	ret = led_classdev_register(chip->dev, &data->cdev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register LED: %d\n", ret);
 		return ret;
 	}
 	pm860x_led_set(&data->cdev, 0);
+
+	platform_set_drvdata(pdev, data);
+
 	return 0;
 }
 
+static int pm860x_led_remove(struct platform_device *pdev)
+{
+	struct pm860x_led *data = platform_get_drvdata(pdev);
+
+	led_classdev_unregister(&data->cdev);
+
+	return 0;
+}
 
 static struct platform_driver pm860x_led_driver = {
 	.driver	= {
 		.name	= "88pm860x-led",
 	},
 	.probe	= pm860x_led_probe,
+	.remove	= pm860x_led_remove,
 };
 
 module_platform_driver(pm860x_led_driver);


