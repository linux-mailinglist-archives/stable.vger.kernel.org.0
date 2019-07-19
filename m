Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC6A6DF34
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbfGSEdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:33:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728763AbfGSECy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:02:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E0C321873;
        Fri, 19 Jul 2019 04:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508973;
        bh=Q2SEaEAU3FeOtqv5GUeAciOTGA6J81HutJNlYGYF0XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bme/rG9xwWXhZ9TkNM3JRvXlwu3r7RhpmDD76aKXMHyCt8wCgbJVmquYfAd7zx2UE
         BKwzxxcSKxPHDsxC2nqnWPgE1kGxfpo3uZ+NFlzNZDXYLlK0iLgMJcxHG9UVJ3qVXV
         NzzN3EM7rP24lN094OtFWaIAr/Y0jcDjyjgYy7Wc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabien Dessenne <fabien.dessenne@st.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 003/141] iio: adc: stm32-dfsdm: missing error case during probe
Date:   Fri, 19 Jul 2019 00:00:28 -0400
Message-Id: <20190719040246.15945-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Dessenne <fabien.dessenne@st.com>

[ Upstream commit d2fc0156963cae8f1eec8e2dd645fbbf1e1c1c8e ]

During probe, check the devm_ioremap_resource() error value.
Also return the devm_clk_get() error value instead of -EINVAL.

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
Acked-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stm32-dfsdm-core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/stm32-dfsdm-core.c b/drivers/iio/adc/stm32-dfsdm-core.c
index bf089f5d6225..941630615e88 100644
--- a/drivers/iio/adc/stm32-dfsdm-core.c
+++ b/drivers/iio/adc/stm32-dfsdm-core.c
@@ -213,6 +213,8 @@ static int stm32_dfsdm_parse_of(struct platform_device *pdev,
 	}
 	priv->dfsdm.phys_base = res->start;
 	priv->dfsdm.base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->dfsdm.base))
+		return PTR_ERR(priv->dfsdm.base);
 
 	/*
 	 * "dfsdm" clock is mandatory for DFSDM peripheral clocking.
@@ -222,8 +224,10 @@ static int stm32_dfsdm_parse_of(struct platform_device *pdev,
 	 */
 	priv->clk = devm_clk_get(&pdev->dev, "dfsdm");
 	if (IS_ERR(priv->clk)) {
-		dev_err(&pdev->dev, "No stm32_dfsdm_clk clock found\n");
-		return -EINVAL;
+		ret = PTR_ERR(priv->clk);
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "Failed to get clock (%d)\n", ret);
+		return ret;
 	}
 
 	priv->aclk = devm_clk_get(&pdev->dev, "audio");
-- 
2.20.1

