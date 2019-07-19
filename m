Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47C36D987
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 05:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfGSD4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfGSD4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:56:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E38A21851;
        Fri, 19 Jul 2019 03:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508611;
        bh=/3jVZssMR/YyoaqWeVSE/kuJ6bjnTmEqFpM1Pt0JQak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcQOZxVXi7nZ5ZyY20kFOT5OmHz/e1V5SYskd+tBRqYO8Qdbvj7qTY3mfwSZHHNhK
         EMXJIN/1n5z/FjBjDjl7ZHnXvpR+Dz77dBqDvyhQjeTBRl+ZE/gdZRR9KZnroNMiJG
         akp8s7tslywLshUoXHykgKtA1mLqBd7bsMfPaDlQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabien Dessenne <fabien.dessenne@st.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 004/171] iio: adc: stm32-dfsdm: missing error case during probe
Date:   Thu, 18 Jul 2019 23:53:55 -0400
Message-Id: <20190719035643.14300-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
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
index 0a4d3746d21c..26e2011c5868 100644
--- a/drivers/iio/adc/stm32-dfsdm-core.c
+++ b/drivers/iio/adc/stm32-dfsdm-core.c
@@ -233,6 +233,8 @@ static int stm32_dfsdm_parse_of(struct platform_device *pdev,
 	}
 	priv->dfsdm.phys_base = res->start;
 	priv->dfsdm.base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->dfsdm.base))
+		return PTR_ERR(priv->dfsdm.base);
 
 	/*
 	 * "dfsdm" clock is mandatory for DFSDM peripheral clocking.
@@ -242,8 +244,10 @@ static int stm32_dfsdm_parse_of(struct platform_device *pdev,
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

