Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DF42E78DD
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgL3NEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:04:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:53386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbgL3NEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:04:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 122C922273;
        Wed, 30 Dec 2020 13:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333402;
        bh=0zJjSQYT2Lmkmhjj3YMXNHHmQ66jWl5KgvHAY3EgdHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O38LehLUPKf5ATmGvid17B+wxVgw3Ucjs/m0xKY0dSKWo87/6c1AaugfZ407cMJfd
         fWHR+753/xCp2fPA2iy1JN5bg9+RIk8HGw5CzmIXf1nqw2BTdYUrrR0FJJTynh1Onr
         7U1+NxVnm8o8xt+1AEWKlWMH6k4W+n7bC3x+g5SiE5F/lIQX8OFlyO3e/6NK5M7VDY
         fZ5G8o3s7OtJLsuOIQUOzaRbaPGIW706HoQGjyZ2F3zk2tILr95+A2McVk5BHQ+1b6
         8aop+56Vi5Il36XvsLl7/EGw+N4G5tb5Re+ysfXKd4RN3rgBv82wTfYCilbAyIFS6C
         6LB6rPw7jlaRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Liang <zhengliang6@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/31] rtc: pl031: fix resource leak in pl031_probe
Date:   Wed, 30 Dec 2020 08:02:47 -0500
Message-Id: <20201230130314.3636961-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130314.3636961-1-sashal@kernel.org>
References: <20201230130314.3636961-1-sashal@kernel.org>
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
index c6b89273feba8..d4b2ab7861266 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -361,8 +361,10 @@ static int pl031_probe(struct amba_device *adev, const struct amba_id *id)
 
 	device_init_wakeup(&adev->dev, true);
 	ldata->rtc = devm_rtc_allocate_device(&adev->dev);
-	if (IS_ERR(ldata->rtc))
-		return PTR_ERR(ldata->rtc);
+	if (IS_ERR(ldata->rtc)) {
+		ret = PTR_ERR(ldata->rtc);
+		goto out;
+	}
 
 	ldata->rtc->ops = ops;
 	ldata->rtc->range_min = vendor->range_min;
-- 
2.27.0

