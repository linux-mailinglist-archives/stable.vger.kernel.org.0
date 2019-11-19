Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C03AB101787
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbfKSGCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 01:02:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730672AbfKSFmt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:42:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A407421783;
        Tue, 19 Nov 2019 05:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142168;
        bh=6zIYvAQLeAqmRqLZCnOGn1hGP8lmOux0Wh75nSABTTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEM/Xisf9L7sdhTOIYYlXNLt+jenKWanvmkRzT3XhBbTCqvxa0e494qZVFo7WUGfS
         GwiCG3hmOPjhBSS7usP8ERcChfCLknqp+c8sDtXM4eOdGQ/zHVY9iXgaRO5Tk1Ltx1
         //ruXGNyIBfdgvy18ALkoQu4vwAyK/cWvAKxrFqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 413/422] rtc: armada38x: fix possible race condition
Date:   Tue, 19 Nov 2019 06:20:10 +0100
Message-Id: <20191119051425.956631885@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
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
index bde53c8ccee2c..b74338d6dde60 100644
--- a/drivers/rtc/rtc-armada38x.c
+++ b/drivers/rtc/rtc-armada38x.c
@@ -514,7 +514,6 @@ MODULE_DEVICE_TABLE(of, armada38x_rtc_of_match_table);
 
 static __init int armada38x_rtc_probe(struct platform_device *pdev)
 {
-	const struct rtc_class_ops *ops;
 	struct resource *res;
 	struct armada38x_rtc *rtc;
 	const struct of_device_id *match;
@@ -551,6 +550,11 @@ static __init int armada38x_rtc_probe(struct platform_device *pdev)
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
@@ -560,28 +564,24 @@ static __init int armada38x_rtc_probe(struct platform_device *pdev)
 
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



