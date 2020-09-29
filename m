Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F24627C8E3
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731533AbgI2MFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:05:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730272AbgI2Lhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEE54208FE;
        Tue, 29 Sep 2020 11:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379452;
        bh=yvSfY/wFuXDNcZOalTPhO9jKbqjuz1HOllkdtnBtnqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbznGHsD3l3XwKTR43lICtqDc39yn74CzUcrCUYnMjfn5BqJq739zRe4nylzsk/5A
         P/b8joIcY6Cv0MruPV5SgBHd7IbjMaL3/rOjt0OiY+qMpVtslqIvA1l07GBKhsRIvw
         2HTC7O5knSx0BIX+lSq5QrN3C48A6AJjUi2nAArs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 170/388] rtc: ds1374: fix possible race condition
Date:   Tue, 29 Sep 2020 12:58:21 +0200
Message-Id: <20200929110018.710658201@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 367497914c100..28eb96cbaf98b 100644
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



