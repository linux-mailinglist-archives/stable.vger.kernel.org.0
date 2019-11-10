Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC42F657D
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbfKJCpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:45:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728788AbfKJCpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:45:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC388222BE;
        Sun, 10 Nov 2019 02:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353919;
        bh=6zIYvAQLeAqmRqLZCnOGn1hGP8lmOux0Wh75nSABTTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=isbFdRsoULsWqnRqnukhJf5Y2YP710nsKXd3zs+1YUabLu+RYjqiqI4OjoJErJsT7
         E/SsXg09h+220/pu7SIw59KGUzWhcRdhcpeGKbyS9mkFlpc+hQA7jPwQ449qsaCOb9
         MfJkrJzIXaWVYrKwKtIvyVD9j8O39ZIkRT6BDUfw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 182/191] rtc: armada38x: fix possible race condition
Date:   Sat,  9 Nov 2019 21:40:04 -0500
Message-Id: <20191110024013.29782-182-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

