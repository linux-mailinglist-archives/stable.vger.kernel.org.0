Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2814027C55E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgI2Les (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:34:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729575AbgI2Ld0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:33:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BADAE23B83;
        Tue, 29 Sep 2020 11:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378795;
        bh=fQJrEi1be1uFQFhv9+0guO+MFD8DKU7SupD2Oq/Rnck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ul5CsORDU+BEdQW+8QPBptF5XDktj79a7KdANucSVrZ7t3F4115lwjaurByS2k0u1
         3SFA/Ej6T1OL4yH++SXGxcIRmBNmIqK87UKduQ6p3EmFptbAg6dZcEDcwidQd3cqNh
         2iQKkF4NjaVJX+Zr2QDd7VJTvStixZHBqA4mW1sQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/245] rtc: sa1100: fix possible race condition
Date:   Tue, 29 Sep 2020 12:59:22 +0200
Message-Id: <20200929105952.387270668@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit f2997775b111c6d660c32a18d5d44d37cb7361b1 ]

Both RTC IRQs are requested before the struct rtc_device is allocated,
this may lead to a NULL pointer dereference in the IRQ handler.

To fix this issue, allocating the rtc_device struct before requesting
the IRQs using devm_rtc_allocate_device, and use rtc_register_device
to register the RTC device.

Link: https://lore.kernel.org/r/20200306010146.39762-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-sa1100.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 304d905cb23fd..56f625371735f 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -186,7 +186,6 @@ static const struct rtc_class_ops sa1100_rtc_ops = {
 
 int sa1100_rtc_init(struct platform_device *pdev, struct sa1100_rtc *info)
 {
-	struct rtc_device *rtc;
 	int ret;
 
 	spin_lock_init(&info->lock);
@@ -215,15 +214,14 @@ int sa1100_rtc_init(struct platform_device *pdev, struct sa1100_rtc *info)
 		writel_relaxed(0, info->rcnr);
 	}
 
-	rtc = devm_rtc_device_register(&pdev->dev, pdev->name, &sa1100_rtc_ops,
-					THIS_MODULE);
-	if (IS_ERR(rtc)) {
+	info->rtc->ops = &sa1100_rtc_ops;
+	info->rtc->max_user_freq = RTC_FREQ;
+
+	ret = rtc_register_device(info->rtc);
+	if (ret) {
 		clk_disable_unprepare(info->clk);
-		return PTR_ERR(rtc);
+		return ret;
 	}
-	info->rtc = rtc;
-
-	rtc->max_user_freq = RTC_FREQ;
 
 	/* Fix for a nasty initialization problem the in SA11xx RTSR register.
 	 * See also the comments in sa1100_rtc_interrupt().
@@ -272,6 +270,10 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
 	info->irq_1hz = irq_1hz;
 	info->irq_alarm = irq_alarm;
 
+	info->rtc = devm_rtc_allocate_device(&pdev->dev);
+	if (IS_ERR(info->rtc))
+		return PTR_ERR(info->rtc);
+
 	ret = devm_request_irq(&pdev->dev, irq_1hz, sa1100_rtc_interrupt, 0,
 			       "rtc 1Hz", &pdev->dev);
 	if (ret) {
-- 
2.25.1



