Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB6AB2EBE3
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbfE3DQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730734AbfE3DQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:36 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73631245F8;
        Thu, 30 May 2019 03:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186196;
        bh=thiQbOlfxqJZyvdYRAbL63KGaSN2f9Fz6AwelGLDbRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8m8t1p9kY8H3z8V9Cnu9UdEW6UiGtZH3Wd6A45j7MnqP7/WfDRim5QG3znOUwzJu
         8U1RAiRt0fc1kXy0D0Puv7NNU04t9rXWyREQuRW2ZpZOqVOrETZHPdF++jgdxh2sWe
         H+6ccs91LOXfD6/JIBnIUSoW4K24WlnkZzHVvkUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Dessenne <fabien.dessenne@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 070/276] media: stm32-dcmi: return appropriate error codes during probe
Date:   Wed, 29 May 2019 20:03:48 -0700
Message-Id: <20190530030530.607146114@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
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



