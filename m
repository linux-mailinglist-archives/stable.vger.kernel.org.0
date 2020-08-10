Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0055E24092C
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgHJP3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:29:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728758AbgHJP3j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:29:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 033CB22D07;
        Mon, 10 Aug 2020 15:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073378;
        bh=KaxY1NvNPtD69tQs/t0IdTuYAOTR+KNMEfLbGZkbrm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSq5639sLdo59uqbNcR97Jfvvbqu46yZc5Wxif3U8wHs6GUxL8u5xDSD9ELbvfORm
         vPWKk4RjdBQlCPzGm+CX9sjQt+xeFUJRApC3iHjDWbsnvW5NRepxJm9nYkop7Kt66A
         ItQs/jW0a+fXAiqvZuaPHtFl58c/DNzUJp5CfpMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        Johan Hovold <johan@kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 4.19 17/48] leds: lm3533: fix use-after-free on unbind
Date:   Mon, 10 Aug 2020 17:21:39 +0200
Message-Id: <20200810151805.062885325@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151804.199494191@linuxfoundation.org>
References: <20200810151804.199494191@linuxfoundation.org>
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
@@ -698,7 +698,7 @@ static int lm3533_led_probe(struct platf
 
 	platform_set_drvdata(pdev, led);
 
-	ret = devm_led_classdev_register(pdev->dev.parent, &led->cdev);
+	ret = led_classdev_register(pdev->dev.parent, &led->cdev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register LED %d\n", pdev->id);
 		return ret;
@@ -708,13 +708,18 @@ static int lm3533_led_probe(struct platf
 
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
@@ -724,6 +729,7 @@ static int lm3533_led_remove(struct plat
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
 	lm3533_ctrlbank_disable(&led->cb);
+	led_classdev_unregister(&led->cdev);
 
 	return 0;
 }


