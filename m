Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997CB2409BC
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgHJPfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:35:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728611AbgHJP2W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:28:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22CB722BEA;
        Mon, 10 Aug 2020 15:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073301;
        bh=wkqj1qoeprJlvfQN9/RlfNpdpvKWXthNynLbTT69KSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FV8IRDCYl+kHutX8O3g9Ef1Bb819OgnuXCjkuzuOGqdo5sC2ZaG8wwM59oYquOH3K
         fMFVjSIdB9rSastN3sk8kOBEpHktwXQo/vGWgJMY5cPLnGZXArsLLK7rD50wK7DwKt
         LpfHXI4FQTZkmJGVRMtZSFwn2INZg+O/GWI8e8Tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        Johan Hovold <johan@kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 5.4 26/67] leds: wm831x-status: fix use-after-free on unbind
Date:   Mon, 10 Aug 2020 17:21:13 +0200
Message-Id: <20200810151810.715918442@linuxfoundation.org>
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

commit 47a459ecc800a17109d0c496a4e21e478806ee40 upstream.

Several MFD child drivers register their class devices directly under
the parent device. This means you cannot blindly do devres conversions
so that deregistration ends up being tied to the parent device,
something which leads to use-after-free on driver unbind when the class
device is released while still being registered.

Fixes: 8d3b6a4001ce ("leds: wm831x-status: Use devm_led_classdev_register")
Cc: stable <stable@vger.kernel.org>     # 4.6
Cc: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/leds/leds-wm831x-status.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/leds/leds-wm831x-status.c
+++ b/drivers/leds/leds-wm831x-status.c
@@ -269,12 +269,23 @@ static int wm831x_status_probe(struct pl
 	drvdata->cdev.blink_set = wm831x_status_blink_set;
 	drvdata->cdev.groups = wm831x_status_groups;
 
-	ret = devm_led_classdev_register(wm831x->dev, &drvdata->cdev);
+	ret = led_classdev_register(wm831x->dev, &drvdata->cdev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register LED: %d\n", ret);
 		return ret;
 	}
 
+	platform_set_drvdata(pdev, drvdata);
+
+	return 0;
+}
+
+static int wm831x_status_remove(struct platform_device *pdev)
+{
+	struct wm831x_status *drvdata = platform_get_drvdata(pdev);
+
+	led_classdev_unregister(&drvdata->cdev);
+
 	return 0;
 }
 
@@ -283,6 +294,7 @@ static struct platform_driver wm831x_sta
 		   .name = "wm831x-status",
 		   },
 	.probe = wm831x_status_probe,
+	.remove = wm831x_status_remove,
 };
 
 module_platform_driver(wm831x_status_driver);


