Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2526101696
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732191AbfKSFyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732189AbfKSFyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:54:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF04D2084D;
        Tue, 19 Nov 2019 05:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142883;
        bh=zLBMsUvrWZHV7E188F4FwrNzMEHGylV/Lj4NfRV7Mao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtJ7KxdUVaBibPNyyRgrRSfHcB/PNdzGmG1GI+EPLa7sOCo77307DNbaK4Jj0G4+W
         3RGU5B/uicPB5NVsp09rNRLuS0Fa1OaS7QQw6c9zDNvTWLkuAPhpgdItt2h0JMxpeB
         N1mrdYeuJxUCAOx9g+uOQNodzTA5wc61peosI1O8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 233/239] rtc: armada38x: fix possible race condition
Date:   Tue, 19 Nov 2019 06:20:33 +0100
Message-Id: <20191119051342.190490630@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 7d61cbb945a753af08e247b5f10bdd5dbb8d6c80 ]

The IRQ is requested before the struct rtc is allocated and registered, but
this struct is used in the IRQ handler. This may lead to a NULL pointer
dereference.

Switch to devm_rtc_allocate_device/rtc_register_device to allocate the rtc
before requesting the IRQ.

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-armada38x.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-armada38x.c b/drivers/rtc/rtc-armada38x.c
index 21f355c37eab5..10b5c85490392 100644
--- a/drivers/rtc/rtc-armada38x.c
+++ b/drivers/rtc/rtc-armada38x.c
@@ -390,7 +390,6 @@ MODULE_DEVICE_TABLE(of, armada38x_rtc_of_match_table);
 
 static __init int armada38x_rtc_probe(struct platform_device *pdev)
 {
-	const struct rtc_class_ops *ops;
 	struct resource *res;
 	struct armada38x_rtc *rtc;
 	const struct of_device_id *match;
@@ -427,6 +426,11 @@ static __init int armada38x_rtc_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "no irq\n");
 		return rtc->irq;
 	}
+
+	rtc->rtc_dev = devm_rtc_allocate_device(&pdev->dev);
+	if (IS_ERR(rtc->rtc_dev))
+		return PTR_ERR(rtc->rtc_dev);
+
 	if (devm_request_irq(&pdev->dev, rtc->irq, armada38x_rtc_alarm_irq,
 				0, pdev->name, rtc) < 0) {
 		dev_warn(&pdev->dev, "Interrupt not available.\n");
@@ -436,28 +440,24 @@ static __init int armada38x_rtc_probe(struct platform_device *pdev)
 
 	if (rtc->irq != -1) {
 		device_init_wakeup(&pdev->dev, 1);
-		ops = &armada38x_rtc_ops;
+		rtc->rtc_dev->ops = &armada38x_rtc_ops;
 	} else {
 		/*
 		 * If there is no interrupt available then we can't
 		 * use the alarm
 		 */
-		ops = &armada38x_rtc_ops_noirq;
+		rtc->rtc_dev->ops = &armada38x_rtc_ops_noirq;
 	}
 	rtc->data = (struct armada38x_rtc_data *)match->data;
 
-
 	/* Update RTC-MBUS bridge timing parameters */
 	rtc->data->update_mbus_timing(rtc);
 
-	rtc->rtc_dev = devm_rtc_device_register(&pdev->dev, pdev->name,
-						ops, THIS_MODULE);
-	if (IS_ERR(rtc->rtc_dev)) {
-		ret = PTR_ERR(rtc->rtc_dev);
+	ret = rtc_register_device(rtc->rtc_dev);
+	if (ret)
 		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
-		return ret;
-	}
-	return 0;
+
+	return ret;
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.20.1



