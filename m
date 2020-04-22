Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06B21B3EEE
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730531AbgDVKcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730526AbgDVKZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:25:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D64C42075A;
        Wed, 22 Apr 2020 10:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551116;
        bh=0rcL6w+U3QxTPUxJYsUdrnHmbxHPVlcjvRNL/c8lbPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cpbIX5TeeQpXd1Pyr/G5PCWjOCJ1JtSQ0/tGqrpwQ7lB34MiguAqg0K3p+l26S4Iv
         82MdMf88zoMihpEMK/N8ual1H5bfWZd9fUnyP5YSY3p3GFg5VD1rdgerp5qcDUZYOX
         C6yQxREfRqxJc3DlH9BwHxfH1ZlEOzM34reTXgb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 070/166] rtc: 88pm860x: fix possible race condition
Date:   Wed, 22 Apr 2020 11:56:37 +0200
Message-Id: <20200422095056.412533753@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 9cf4789e6e4673d0b2c96fa6bb0c35e81b43111a ]

The RTC IRQ is requested before the struct rtc_device is allocated,
this may lead to a NULL pointer dereference in the IRQ handler.

To fix this issue, allocating the rtc_device struct before requesting
the RTC IRQ using devm_rtc_allocate_device, and use rtc_register_device
to register the RTC device.

Also remove the unnecessary error message as the core already prints the
info.

Link: https://lore.kernel.org/r/20200311223956.51352-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-88pm860x.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
index 4743b16a8d849..1526402e126b2 100644
--- a/drivers/rtc/rtc-88pm860x.c
+++ b/drivers/rtc/rtc-88pm860x.c
@@ -336,6 +336,10 @@ static int pm860x_rtc_probe(struct platform_device *pdev)
 	info->dev = &pdev->dev;
 	dev_set_drvdata(&pdev->dev, info);
 
+	info->rtc_dev = devm_rtc_allocate_device(&pdev->dev);
+	if (IS_ERR(info->rtc_dev))
+		return PTR_ERR(info->rtc_dev);
+
 	ret = devm_request_threaded_irq(&pdev->dev, info->irq, NULL,
 					rtc_update_handler, IRQF_ONESHOT, "rtc",
 					info);
@@ -377,13 +381,11 @@ static int pm860x_rtc_probe(struct platform_device *pdev)
 		}
 	}
 
-	info->rtc_dev = devm_rtc_device_register(&pdev->dev, "88pm860x-rtc",
-					    &pm860x_rtc_ops, THIS_MODULE);
-	ret = PTR_ERR(info->rtc_dev);
-	if (IS_ERR(info->rtc_dev)) {
-		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
+	info->rtc_dev->ops = &pm860x_rtc_ops;
+
+	ret = rtc_register_device(info->rtc_dev);
+	if (ret)
 		return ret;
-	}
 
 	/*
 	 * enable internal XO instead of internal 3.25MHz clock since it can
-- 
2.20.1



