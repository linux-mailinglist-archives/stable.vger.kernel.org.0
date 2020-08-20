Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF0E24BA57
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbgHTJ6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729652AbgHTJ6n (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:58:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CA442067C;
        Thu, 20 Aug 2020 09:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917522;
        bh=sB3O8RsK+WNH9GoiGeAlv0G4heZHl6LbPgI8bJi86mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jor7D8PRGeoSPKj2dSEtfSLFDT4CkFCW+e9AgC0fv2YujPkeiNG9jt4ZnRQvShsDu
         ogNfW4/zwAQqn3ejc43XoYhB0+TmbR3EB9LGSV2xAzEzTpAW3ZBLtWBOQo8TJS6914
         t2FgRTVxtrnrxQlCzBDmgw2bFdrBWHxsPwuk6AE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        Johan Hovold <johan@kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 4.9 060/212] leds: wm831x-status: fix use-after-free on unbind
Date:   Thu, 20 Aug 2020 11:20:33 +0200
Message-Id: <20200820091605.400259432@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
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
@@ -283,12 +283,23 @@ static int wm831x_status_probe(struct pl
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
 
@@ -297,6 +308,7 @@ static struct platform_driver wm831x_sta
 		   .name = "wm831x-status",
 		   },
 	.probe = wm831x_status_probe,
+	.remove = wm831x_status_remove,
 };
 
 module_platform_driver(wm831x_status_driver);


