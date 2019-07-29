Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A491A795DC
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390209AbfG2Tqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:46:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390200AbfG2Tqi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:46:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 823E2217D7;
        Mon, 29 Jul 2019 19:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429597;
        bh=mWccI4xWigLd6uiRvL/JVMP3itla6nFDg60Gd8TVgGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yiWgXPpkdm959RTb9kozg5kB6Te5hTVupxQ+R40ffCsLyyT5mzSgFdeE6rgg+LtmN
         F3rPXT3MSB/FSZTse/Kwqieaup8X6WnNu8Azi5Lig6GqUO0joxmMessaBJPobOI3mN
         8dL00klMfYH3fMXXt2EEsmcuTKQszcFVc7zw8TIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Dessenne <fabien.dessenne@st.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 007/215] iio: adc: stm32-dfsdm: missing error case during probe
Date:   Mon, 29 Jul 2019 21:20:03 +0200
Message-Id: <20190729190740.935777268@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



