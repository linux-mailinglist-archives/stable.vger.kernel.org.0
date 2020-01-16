Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E46113E406
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388747AbgAPRFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:05:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:34396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388740AbgAPRFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:05:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4079A24684;
        Thu, 16 Jan 2020 17:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194331;
        bh=Hv37BfS55KKDAbh7Qq/n5MYz80MnjEqtZFsgK6Mdv/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQ/uDMdir2IB3IrBlV2W3YTW8sv0wY7TTiSHV3sflENNBUKSmnS7P1pyACU8+cnJS
         sUME1CAOQWUPYx/Veep3HNMjzg6eyPrnsBUnKAemLUQ6kh7KnFT0yYKwcQScsVmLC2
         sm5wloc9N4aqok52LqwZSQWVTYNTj32bMD1aYgMI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pi-Hsun Shih <pihsun@chromium.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 278/671] rtc: mt6397: Don't call irq_dispose_mapping.
Date:   Thu, 16 Jan 2020 11:58:36 -0500
Message-Id: <20200116170509.12787-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pi-Hsun Shih <pihsun@chromium.org>

[ Upstream commit 24db953e942bd7a983e97892bdaddf69d00b1199 ]

The IRQ mapping was changed to not being created in the rtc-mt6397
driver, so the irq_dispose_mapping is no longer needed.
Also the dev_id passed to free_irq should be the same as the last
argument passed to request_threaded_irq.
This prevents a "Trying to free already-free IRQ 274" warning when
unbinding the driver.

Fixes: e695d3a0b3b3 ("mfd: mt6397: Create irq mappings in mfd core driver")
Signed-off-by: Pi-Hsun Shih <pihsun@chromium.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mt6397.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-mt6397.c b/drivers/rtc/rtc-mt6397.c
index e9a25ec4d434..c06cf5202e02 100644
--- a/drivers/rtc/rtc-mt6397.c
+++ b/drivers/rtc/rtc-mt6397.c
@@ -343,7 +343,7 @@ static int mtk_rtc_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
 			rtc->irq, ret);
-		goto out_dispose_irq;
+		return ret;
 	}
 
 	device_init_wakeup(&pdev->dev, 1);
@@ -359,9 +359,7 @@ static int mtk_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 out_free_irq:
-	free_irq(rtc->irq, rtc->rtc_dev);
-out_dispose_irq:
-	irq_dispose_mapping(rtc->irq);
+	free_irq(rtc->irq, rtc);
 	return ret;
 }
 
@@ -369,8 +367,7 @@ static int mtk_rtc_remove(struct platform_device *pdev)
 {
 	struct mt6397_rtc *rtc = platform_get_drvdata(pdev);
 
-	free_irq(rtc->irq, rtc->rtc_dev);
-	irq_dispose_mapping(rtc->irq);
+	free_irq(rtc->irq, rtc);
 
 	return 0;
 }
-- 
2.20.1

