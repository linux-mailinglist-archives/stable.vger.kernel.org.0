Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6724626F321
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729704AbgIRDE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:04:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727374AbgIRCEq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A29C32389F;
        Fri, 18 Sep 2020 02:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394686;
        bh=mQG+ER7t6O6YlEQAv1Ijbqu6u1XNyaxYMTu5QO3wwfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IeIp5YUd9Nnau//YFo7J62m6c7tvjnZCa29pe3cSwKHnrCAnTRSLhjMOOBuJC4p3v
         38cDisvFyvj2n/ZSGOYgyFMB7YU39Obs6vn6eAR3g3pVvFt0zTY0s7gbAF2ufIc9L7
         n59F1Ebas0TuWftDFlqoQCYdTlbTyX496NHMBZKM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, rtc-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.4 175/330] rtc: sa1100: fix possible race condition
Date:   Thu, 17 Sep 2020 21:58:35 -0400
Message-Id: <20200918020110.2063155-175-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 86fa723b3b762..795273269d58e 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -182,7 +182,6 @@ static const struct rtc_class_ops sa1100_rtc_ops = {
 
 int sa1100_rtc_init(struct platform_device *pdev, struct sa1100_rtc *info)
 {
-	struct rtc_device *rtc;
 	int ret;
 
 	spin_lock_init(&info->lock);
@@ -211,15 +210,14 @@ int sa1100_rtc_init(struct platform_device *pdev, struct sa1100_rtc *info)
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
@@ -268,6 +266,10 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
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

