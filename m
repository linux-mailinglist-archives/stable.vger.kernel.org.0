Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCD72E797E
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727475AbgL3NKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:10:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727223AbgL3NE5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:04:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 938EB224D3;
        Wed, 30 Dec 2020 13:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333445;
        bh=V2Imo5LZn+YxBF+aA2Bqs5WS4RaXje0uYI8KxcWqzjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fM5Z9jO2E0ANrEVy0Z/6KFPFb+AHa/kXzbHkIxcIkFTxm4HaEW4/1vcrcwq98no68
         Z0UVxRD7TeAHmIoqfbLkX7KbUg2FJZx+0bCHdL+W84eGEz6yLjFFV5j9Lgo0xgnZJV
         yV3lKNcwb56gMXbBEdxNx7wmmALYdgk9ea9D6cbtaLE0E5OxZPsnPE7FB32X7fnr4P
         iE8MVpe7edPUcQx5o17mVA8mSSIo1phOYUrBkuvkn1DuEKr1oVKxGERRMWDTj4NgH2
         mm1Zz/iIjsubi+zJs05HzYkCocLv6LLuw8U4ugLDoW+OMb8ISys7SlLTD37hcd+MP6
         ztGTLx/9bMA8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Liang <zhengliang6@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/17] rtc: pl031: fix resource leak in pl031_probe
Date:   Wed, 30 Dec 2020 08:03:45 -0500
Message-Id: <20201230130357.3637261-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130357.3637261-1-sashal@kernel.org>
References: <20201230130357.3637261-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Liang <zhengliang6@huawei.com>

[ Upstream commit 1eab0fea2514b269e384c117f5b5772b882761f0 ]

When devm_rtc_allocate_device is failed in pl031_probe, it should release
mem regions with device.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Liang <zhengliang6@huawei.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20201112093139.32566-1-zhengliang6@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pl031.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index 180caebbd3552..9566958476dfc 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -379,8 +379,10 @@ static int pl031_probe(struct amba_device *adev, const struct amba_id *id)
 
 	device_init_wakeup(&adev->dev, true);
 	ldata->rtc = devm_rtc_allocate_device(&adev->dev);
-	if (IS_ERR(ldata->rtc))
-		return PTR_ERR(ldata->rtc);
+	if (IS_ERR(ldata->rtc)) {
+		ret = PTR_ERR(ldata->rtc);
+		goto out;
+	}
 
 	ldata->rtc->ops = ops;
 
-- 
2.27.0

