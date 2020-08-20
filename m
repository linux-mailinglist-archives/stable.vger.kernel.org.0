Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607F924B8AC
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbgHTLZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729738AbgHTKGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:06:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB45A20724;
        Thu, 20 Aug 2020 10:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917993;
        bh=72cAI67VtDDZt1mKfeA6RIpba9BunW+7lZj51ljgIhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amPr52cx9dwtRZA616f1iXKptbtlwCFdU0QKouoOt0mnNBLSxaStoQyL2S0bQlzgA
         SbhvsYuAvi/isMCKxp50zJwpA1kG5OSma9oglmh+2s49SOrkXuAI9CaCWjk42qoIll
         pAJ1vZGE+up3ZyC5ZX/UTONhNU+W+qcRAKlW+BOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        Johan Hovold <johan@kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 4.14 016/228] leds: da903x: fix use-after-free on unbind
Date:   Thu, 20 Aug 2020 11:19:51 +0200
Message-Id: <20200820091608.345582525@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
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
@@ -113,12 +113,23 @@ static int da903x_led_probe(struct platf
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
 
@@ -127,6 +138,7 @@ static struct platform_driver da903x_led
 		.name	= "da903x-led",
 	},
 	.probe		= da903x_led_probe,
+	.remove		= da903x_led_remove,
 };
 
 module_platform_driver(da903x_led_driver);


