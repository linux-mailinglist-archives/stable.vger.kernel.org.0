Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCDB26F0AA
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgIRCp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728420AbgIRCKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:10:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE16323A05;
        Fri, 18 Sep 2020 02:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395016;
        bh=BK5x3yg1WtDHgsbiPOGElnw8lWh4BW1Nka4Uaa9FLUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETqiMhNrjJ/6ec66gLVFTno4MQrglRq1DYMdkpM386aXLaVKlCwOwiICeQZyUBiF1
         x8jIFS58M5r9TRLVnIz/0HJmWRduPgBuLs47Ir5Hpmsxm937BCrhsw9MinCl3iXsJ+
         BT2YLVyj22EoaZE52Ihiqewlzk4F07wfMQnL1pws=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, rtc-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 111/206] rtc: ds1374: fix possible race condition
Date:   Thu, 17 Sep 2020 22:06:27 -0400
Message-Id: <20200918020802.2065198-111-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit c11af8131a4e7ba1960faed731ee7e84c2c13c94 ]

The RTC IRQ is requested before the struct rtc_device is allocated,
this may lead to a NULL pointer dereference in the IRQ handler.

To fix this issue, allocating the rtc_device struct before requesting
the RTC IRQ using devm_rtc_allocate_device, and use rtc_register_device
to register the RTC device.

Link: https://lore.kernel.org/r/20200306073404.56921-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1374.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index 38a2e9e684df4..77a106e90124b 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -620,6 +620,10 @@ static int ds1374_probe(struct i2c_client *client,
 	if (!ds1374)
 		return -ENOMEM;
 
+	ds1374->rtc = devm_rtc_allocate_device(&client->dev);
+	if (IS_ERR(ds1374->rtc))
+		return PTR_ERR(ds1374->rtc);
+
 	ds1374->client = client;
 	i2c_set_clientdata(client, ds1374);
 
@@ -641,12 +645,11 @@ static int ds1374_probe(struct i2c_client *client,
 		device_set_wakeup_capable(&client->dev, 1);
 	}
 
-	ds1374->rtc = devm_rtc_device_register(&client->dev, client->name,
-						&ds1374_rtc_ops, THIS_MODULE);
-	if (IS_ERR(ds1374->rtc)) {
-		dev_err(&client->dev, "unable to register the class device\n");
-		return PTR_ERR(ds1374->rtc);
-	}
+	ds1374->rtc->ops = &ds1374_rtc_ops;
+
+	ret = rtc_register_device(ds1374->rtc);
+	if (ret)
+		return ret;
 
 #ifdef CONFIG_RTC_DRV_DS1374_WDT
 	save_client = client;
-- 
2.25.1

