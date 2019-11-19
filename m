Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E8710172D
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729233AbfKSFtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:49:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731486AbfKSFte (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:49:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E711421783;
        Tue, 19 Nov 2019 05:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142573;
        bh=Fu/I8ZnolOKDPg+/vRX8DzeqchGrL8EOnR20nT0rL9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILbquidxGKaM708GbRP/KweYD9vrtKJH05rEOEczfUHXtYE0o9CbvmfJQHa6DSzFO
         876OZo4JPTui7W6aKIPqO5rDun7fFfZ29FFGPJqhux1xqiOOp2eqqDL6Zv4H95os/l
         OK2NehuhT7KRfWrLhHqEMoZZYRH1evL5cztAFo0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie Huang <eddie.huang@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 087/239] rtc: mt6397: fix possible race condition
Date:   Tue, 19 Nov 2019 06:18:07 +0100
Message-Id: <20191119051318.516914131@linuxfoundation.org>
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

[ Upstream commit babab2f86440352d24e76118fdd7d40cab5fd7bf ]

The IRQ is requested before the struct rtc is allocated and registered, but
this struct is used in the IRQ handler. This may lead to a NULL pointer
dereference.

Switch to devm_rtc_allocate_device/rtc_register_device to allocate the rtc
before requesting the IRQ.

Acked-by: Eddie Huang <eddie.huang@mediatek.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mt6397.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-mt6397.c b/drivers/rtc/rtc-mt6397.c
index 1a61fa56f3ad7..e82df43e5ca28 100644
--- a/drivers/rtc/rtc-mt6397.c
+++ b/drivers/rtc/rtc-mt6397.c
@@ -333,6 +333,10 @@ static int mtk_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rtc);
 
+	rtc->rtc_dev = devm_rtc_allocate_device(rtc->dev);
+	if (IS_ERR(rtc->rtc_dev))
+		return PTR_ERR(rtc->rtc_dev);
+
 	ret = request_threaded_irq(rtc->irq, NULL,
 				   mtk_rtc_irq_handler_thread,
 				   IRQF_ONESHOT | IRQF_TRIGGER_HIGH,
@@ -345,11 +349,11 @@ static int mtk_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	rtc->rtc_dev = rtc_device_register("mt6397-rtc", &pdev->dev,
-					   &mtk_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc->rtc_dev)) {
+	rtc->rtc_dev->ops = &mtk_rtc_ops;
+
+	ret = rtc_register_device(rtc->rtc_dev);
+	if (ret) {
 		dev_err(&pdev->dev, "register rtc device failed\n");
-		ret = PTR_ERR(rtc->rtc_dev);
 		goto out_free_irq;
 	}
 
@@ -366,7 +370,6 @@ static int mtk_rtc_remove(struct platform_device *pdev)
 {
 	struct mt6397_rtc *rtc = platform_get_drvdata(pdev);
 
-	rtc_device_unregister(rtc->rtc_dev);
 	free_irq(rtc->irq, rtc->rtc_dev);
 	irq_dispose_mapping(rtc->irq);
 
-- 
2.20.1



