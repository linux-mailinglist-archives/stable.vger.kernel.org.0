Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0481BCD47A
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbfJFR0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:26:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbfJFR0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:26:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F300C2080F;
        Sun,  6 Oct 2019 17:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382778;
        bh=QKRCG8f/z7TmRpXy/oFC4HCqvZVx9ImvcBK7A1PeQ10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMVc0OUZXiu083lTRy9/0lvf/TW3bPXkCSFNI/KVJ+VYNuKCSnaxjj4Fdc/NM/S0I
         CrafPORzC8l4bVsZQfEReifnzaCxs3Eb7wgamEYDjluEdzrjoR+rycxQ9kc/7SXaWg
         RAB8fy5vTPp2bEoeZ1qzoNzol+kOsXBJBNukNyVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/68] rtc: snvs: fix possible race condition
Date:   Sun,  6 Oct 2019 19:21:11 +0200
Message-Id: <20191006171124.973127408@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171108.150129403@linuxfoundation.org>
References: <20191006171108.150129403@linuxfoundation.org>
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
index 71eee39520f0b..7aa2c5ea0de4f 100644
--- a/drivers/rtc/rtc-snvs.c
+++ b/drivers/rtc/rtc-snvs.c
@@ -280,6 +280,10 @@ static int snvs_rtc_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENOMEM;
 
+	data->rtc = devm_rtc_allocate_device(&pdev->dev);
+	if (IS_ERR(data->rtc))
+		return PTR_ERR(data->rtc);
+
 	data->regmap = syscon_regmap_lookup_by_phandle(pdev->dev.of_node, "regmap");
 
 	if (IS_ERR(data->regmap)) {
@@ -342,10 +346,9 @@ static int snvs_rtc_probe(struct platform_device *pdev)
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



