Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB22CD784
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbfJFRaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:30:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728405AbfJFRaZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:30:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2787B2087E;
        Sun,  6 Oct 2019 17:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383024;
        bh=l7NP07G1Ea8ObzNjqXfvhMjFFJVuFFmr/gpg2A2d3/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0NRMstMWEtcz8MeQO7fBSQb98B8iUPXL7fyNVG6UyOglLlLVOnUDWNzfyDt3/EiO
         GwmI+wZGH8x47mdhPenyCnEK4lUf7xAtPRFsu/hpv1SGrVh6O9DHo1rXQDWSKQmEkp
         SY/28PEKHZN/e26y1lAXfuBbkJPqp5ZsEJzMo/10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 058/106] rtc: snvs: fix possible race condition
Date:   Sun,  6 Oct 2019 19:21:04 +0200
Message-Id: <20191006171147.945904228@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit 6fd4fe9b496d9ba3382992ff4fde3871d1b6f63d ]

The RTC IRQ is requested before the struct rtc_device is allocated,
this may lead to a NULL pointer dereference in IRQ handler.

To fix this issue, allocating the rtc_device struct before requesting
the RTC IRQ using devm_rtc_allocate_device, and use rtc_register_device
to register the RTC device.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Link: https://lore.kernel.org/r/20190716071858.36750-1-Anson.Huang@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-snvs.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
index b2483a749ac45..3cf011e120530 100644
--- a/drivers/rtc/rtc-snvs.c
+++ b/drivers/rtc/rtc-snvs.c
@@ -273,6 +273,10 @@ static int snvs_rtc_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENOMEM;
 
+	data->rtc = devm_rtc_allocate_device(&pdev->dev);
+	if (IS_ERR(data->rtc))
+		return PTR_ERR(data->rtc);
+
 	data->regmap = syscon_regmap_lookup_by_phandle(pdev->dev.of_node, "regmap");
 
 	if (IS_ERR(data->regmap)) {
@@ -335,10 +339,9 @@ static int snvs_rtc_probe(struct platform_device *pdev)
 		goto error_rtc_device_register;
 	}
 
-	data->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
-					&snvs_rtc_ops, THIS_MODULE);
-	if (IS_ERR(data->rtc)) {
-		ret = PTR_ERR(data->rtc);
+	data->rtc->ops = &snvs_rtc_ops;
+	ret = rtc_register_device(data->rtc);
+	if (ret) {
 		dev_err(&pdev->dev, "failed to register rtc: %d\n", ret);
 		goto error_rtc_device_register;
 	}
-- 
2.20.1



