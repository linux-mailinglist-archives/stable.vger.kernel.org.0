Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7D0AF48AE
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390846AbfKHLok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:44:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390842AbfKHLoj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:44:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93F1522466;
        Fri,  8 Nov 2019 11:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213479;
        bh=DgnMDlLLXfeQeKctRy7xaYZdYGgwE1jsdDjdNnqBmGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HM7N2yAyo4h/GPPCMzS4+ZWP+QWilwtkChjEYJ9VwMm32upmPMh6xIaotc4lG85p/
         r5pKSFnUfIOob50V5RbElMo7VO5uLeGQlvTq/7AK27Xzy+LhAEeR3AXghKDP1bjOfZ
         Uw8WAGS+tFmJ14BxbD0sR0uZmQ7SHTvW1AWzM9Gs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 061/103] rtc: pl030: fix possible race condition
Date:   Fri,  8 Nov 2019 06:42:26 -0500
Message-Id: <20191108114310.14363-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit c778ec85825dc895936940072aea9fe9037db684 ]

The IRQ is requested before the struct rtc is allocated and registered, but
this struct is used in the IRQ handler. This may lead to a NULL pointer
dereference.

Switch to devm_rtc_allocate_device/rtc_register_device to allocate the rtc
before requesting the IRQ.

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pl030.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-pl030.c b/drivers/rtc/rtc-pl030.c
index f85a1a93e669f..343bb6ed17839 100644
--- a/drivers/rtc/rtc-pl030.c
+++ b/drivers/rtc/rtc-pl030.c
@@ -112,6 +112,13 @@ static int pl030_probe(struct amba_device *dev, const struct amba_id *id)
 		goto err_rtc;
 	}
 
+	rtc->rtc = devm_rtc_allocate_device(&dev->dev);
+	if (IS_ERR(rtc->rtc)) {
+		ret = PTR_ERR(rtc->rtc);
+		goto err_rtc;
+	}
+
+	rtc->rtc->ops = &pl030_ops;
 	rtc->base = ioremap(dev->res.start, resource_size(&dev->res));
 	if (!rtc->base) {
 		ret = -ENOMEM;
@@ -128,12 +135,9 @@ static int pl030_probe(struct amba_device *dev, const struct amba_id *id)
 	if (ret)
 		goto err_irq;
 
-	rtc->rtc = rtc_device_register("pl030", &dev->dev, &pl030_ops,
-				       THIS_MODULE);
-	if (IS_ERR(rtc->rtc)) {
-		ret = PTR_ERR(rtc->rtc);
+	ret = rtc_register_device(rtc->rtc);
+	if (ret)
 		goto err_reg;
-	}
 
 	return 0;
 
@@ -154,7 +158,6 @@ static int pl030_remove(struct amba_device *dev)
 	writel(0, rtc->base + RTC_CR);
 
 	free_irq(dev->irq[0], rtc);
-	rtc_device_unregister(rtc->rtc);
 	iounmap(rtc->base);
 	amba_release_regions(dev);
 
-- 
2.20.1

