Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75F6A26B89
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732310AbfEVT1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731698AbfEVT1V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:27:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 062E4206BA;
        Wed, 22 May 2019 19:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553240;
        bh=TfnuAou9bIxDDruD1urpdqMhJo5/TS6S6Fx6NiY3rU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ub6f3yFVsLmK3V6CFgFIl2w6158OmewJcUg2vxiE+QANTZPH0j4GjFIrT/qHaRxtE
         gRYUziOMvbLpZcDaMG7IPujY3LGWopV6IRW2Y5+6gh7qBJpeM5U+3+DdpjruB7iDVO
         F8rsaREhgHhCXheE8LAV/hjQXN185JuKMTu51aAY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabien Dessenne <fabien.dessenne@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 030/244] media: stm32-dcmi: return appropriate error codes during probe
Date:   Wed, 22 May 2019 15:22:56 -0400
Message-Id: <20190522192630.24917-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192630.24917-1-sashal@kernel.org>
References: <20190522192630.24917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Dessenne <fabien.dessenne@st.com>

[ Upstream commit b5b5a27bee5884860798ffd0f08e611a3942064b ]

During probe, return the provided errors value instead of -ENODEV.
This allows the driver to be deferred probed if needed.

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
Acked-by: Hugues Fruchet <hugues.fruchet@st.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 721564176d8c0..100a5922d75fd 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1645,7 +1645,7 @@ static int dcmi_probe(struct platform_device *pdev)
 	dcmi->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
 	if (IS_ERR(dcmi->rstc)) {
 		dev_err(&pdev->dev, "Could not get reset control\n");
-		return -ENODEV;
+		return PTR_ERR(dcmi->rstc);
 	}
 
 	/* Get bus characteristics from devicetree */
@@ -1660,7 +1660,7 @@ static int dcmi_probe(struct platform_device *pdev)
 	of_node_put(np);
 	if (ret) {
 		dev_err(&pdev->dev, "Could not parse the endpoint\n");
-		return -ENODEV;
+		return ret;
 	}
 
 	if (ep.bus_type == V4L2_MBUS_CSI2) {
@@ -1673,8 +1673,9 @@ static int dcmi_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq <= 0) {
-		dev_err(&pdev->dev, "Could not get irq\n");
-		return -ENODEV;
+		if (irq != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "Could not get irq\n");
+		return irq;
 	}
 
 	dcmi->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1694,12 +1695,13 @@ static int dcmi_probe(struct platform_device *pdev)
 					dev_name(&pdev->dev), dcmi);
 	if (ret) {
 		dev_err(&pdev->dev, "Unable to request irq %d\n", irq);
-		return -ENODEV;
+		return ret;
 	}
 
 	mclk = devm_clk_get(&pdev->dev, "mclk");
 	if (IS_ERR(mclk)) {
-		dev_err(&pdev->dev, "Unable to get mclk\n");
+		if (PTR_ERR(mclk) != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "Unable to get mclk\n");
 		return PTR_ERR(mclk);
 	}
 
-- 
2.20.1

