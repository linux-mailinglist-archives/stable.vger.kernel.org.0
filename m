Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD33148117
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388424AbgAXLQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:16:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390441AbgAXLQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:16:57 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1194820704;
        Fri, 24 Jan 2020 11:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864616;
        bh=n43RFo5JEOZ4VT2lqumPAiFlSakH+Y0EotHVlDZsGdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Bb7N6W95ARby6j2AuwLBbZQ8xErJ98vGkygM4NuC5z558+xisELKltXJUMHOvuqs
         WBPV8vxo/v7h8bg5zDM2OkI3iWmOpoSzBsR/nf5Rjtu3yvYz3nDhNk0+mgyUkpND69
         lWtPIogQ1R9HG/iRSfZUn3z5khjb/9K6ErLBS3kY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pi-Hsun Shih <pihsun@chromium.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 293/639] rtc: mt6397: Dont call irq_dispose_mapping.
Date:   Fri, 24 Jan 2020 10:27:43 +0100
Message-Id: <20200124093123.590052813@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f85f1fc29e32e..964ed91416e1b 100644
--- a/drivers/rtc/rtc-mt6397.c
+++ b/drivers/rtc/rtc-mt6397.c
@@ -362,7 +362,7 @@ static int mtk_rtc_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
 			rtc->irq, ret);
-		goto out_dispose_irq;
+		return ret;
 	}
 
 	device_init_wakeup(&pdev->dev, 1);
@@ -378,9 +378,7 @@ static int mtk_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 out_free_irq:
-	free_irq(rtc->irq, rtc->rtc_dev);
-out_dispose_irq:
-	irq_dispose_mapping(rtc->irq);
+	free_irq(rtc->irq, rtc);
 	return ret;
 }
 
@@ -388,8 +386,7 @@ static int mtk_rtc_remove(struct platform_device *pdev)
 {
 	struct mt6397_rtc *rtc = platform_get_drvdata(pdev);
 
-	free_irq(rtc->irq, rtc->rtc_dev);
-	irq_dispose_mapping(rtc->irq);
+	free_irq(rtc->irq, rtc);
 
 	return 0;
 }
-- 
2.20.1



