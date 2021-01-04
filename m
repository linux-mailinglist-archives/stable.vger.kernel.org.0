Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731532E99E0
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbhADQEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:04:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729172AbhADQEJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:04:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A64B2250E;
        Mon,  4 Jan 2021 16:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776208;
        bh=0zJjSQYT2Lmkmhjj3YMXNHHmQ66jWl5KgvHAY3EgdHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QM04V7F9CrP/S1WKVsRUxSEqrOSd++QjqTUAVbP4/lNvEZkqhqRpjwsPCjrqNenPv
         keYHBEEmXUYvUJ6b2C+p5NAOE2/33gqSt2UXgaeHQPFqSAJ9c+E9eNGK8mYtlU6Yf2
         Dv6dIqTVmQ6EbzaQ7Z+CAADNy9gM52O/2OhpM0mA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zheng Liang <zhengliang6@huawei.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 42/63] rtc: pl031: fix resource leak in pl031_probe
Date:   Mon,  4 Jan 2021 16:57:35 +0100
Message-Id: <20210104155710.863667274@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



