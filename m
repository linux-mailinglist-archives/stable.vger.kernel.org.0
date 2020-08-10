Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B4C240859
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgHJPUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727956AbgHJPUR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:20:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75A4220772;
        Mon, 10 Aug 2020 15:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072817;
        bh=lI6E/4lPK/biapph8fLlSw8m7Ev/Xq7lJP/iubY+u2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubfWQLs8+T+U9PbZm1nQz58vvGokOH0Dk08tC0KvU40SHdhOqXPkvIWGetPJpO8aC
         EorS6q1wQGC8ZScaydoK+G/dcH0U4QY3oAxhVvLxl7sBvQ/hQzhO1oNgvGW9yGSN5T
         dgok6CPO0pZhwkTpfTYCvL3cqXmV2LiAqOPp3GQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        Johan Hovold <johan@kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 5.8 28/38] leds: lm3533: fix use-after-free on unbind
Date:   Mon, 10 Aug 2020 17:19:18 +0200
Message-Id: <20200810151805.287213549@linuxfoundation.org>
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

commit d584221e683bbd173738603b83a315f27d27d043 upstream.

Several MFD child drivers register their class devices directly under
the parent device. This means you cannot blindly do devres conversions
so that deregistration ends up being tied to the parent device,
something which leads to use-after-free on driver unbind when the class
device is released while still being registered.

Fixes: 50154e29e5cc ("leds: lm3533: Use devm_led_classdev_register")
Cc: stable <stable@vger.kernel.org>     # 4.6
Cc: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/leds/leds-lm3533.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/leds/leds-lm3533.c
+++ b/drivers/leds/leds-lm3533.c
@@ -694,7 +694,7 @@ static int lm3533_led_probe(struct platf
 
 	platform_set_drvdata(pdev, led);
 
-	ret = devm_led_classdev_register(pdev->dev.parent, &led->cdev);
+	ret = led_classdev_register(pdev->dev.parent, &led->cdev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register LED %d\n", pdev->id);
 		return ret;
@@ -704,13 +704,18 @@ static int lm3533_led_probe(struct platf
 
 	ret = lm3533_led_setup(led, pdata);
 	if (ret)
-		return ret;
+		goto err_deregister;
 
 	ret = lm3533_ctrlbank_enable(&led->cb);
 	if (ret)
-		return ret;
+		goto err_deregister;
 
 	return 0;
+
+err_deregister:
+	led_classdev_unregister(&led->cdev);
+
+	return ret;
 }
 
 static int lm3533_led_remove(struct platform_device *pdev)
@@ -720,6 +725,7 @@ static int lm3533_led_remove(struct plat
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
 	lm3533_ctrlbank_disable(&led->cb);
+	led_classdev_unregister(&led->cdev);
 
 	return 0;
 }


