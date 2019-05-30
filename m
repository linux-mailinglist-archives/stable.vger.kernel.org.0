Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 194612EB18
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbfE3DKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:10:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727922AbfE3DKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:05 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DA1824485;
        Thu, 30 May 2019 03:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185804;
        bh=ttLh+ckpVc5RVPBST4JMsgoTePgU8TMjDpQTS1LxvbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LumMgQ2lZi5l1S4UjJA7JT+PBGQ3fEg6k3JxY90Oy+3uonAZUOzcfaTlAx/EVfSv2
         p31P3ud0n294rfvsuLGpJQrWL0g/pxbdWof33WZ/LCiwK564BQ1obO2fPm8Ca6PVvX
         ZE8CtmuzrbcRKDOo5hWldStqq84DQ/o1iMw8h0i0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Dessenne <fabien.dessenne@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 084/405] media: stm32-dcmi: return appropriate error codes during probe
Date:   Wed, 29 May 2019 20:01:22 -0700
Message-Id: <20190530030545.269740596@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 5fe5b38fa901d..a1f0801081ba9 100644
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
 
 	if (ep.bus_type == V4L2_MBUS_CSI2_DPHY) {
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



