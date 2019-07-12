Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A92066E26
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbfGLMbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727603AbfGLMbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:31:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF7CE2166E;
        Fri, 12 Jul 2019 12:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934710;
        bh=z2PB0owPThVnK2H60EQBS4IbVg/99sL+l3sZvBSv2fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udvJGnO+RJOh39kXqAsOkGHtyE7mM9g3+NMPpHen31CTmtaWBbAEENuUiqJaD08gE
         zHM0IuxpCNw7s/hdHGqKBswxS15S/BVHwLLeoGpLrVksfZth2JSh6gOrRyq4uOzfjt
         jxlnTrmqehjxPcngqhPghep6hJ/GOfPfBYnoRFhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabrice Gasnier <fabrice.gasnier@st.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.1 127/138] iio: adc: stm32-adc: add missing vdda-supply
Date:   Fri, 12 Jul 2019 14:19:51 +0200
Message-Id: <20190712121633.605114520@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@st.com>

commit 7685010fca2ba0284f31fd1380df3cffc96d847e upstream.

Add missing vdda-supply, analog power supply, to STM32 ADC. When vdda is
an independent supply, it needs to be properly turned on or off to supply
the ADC.

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Fixes: 1add69880240 ("iio: adc: Add support for STM32 ADC core").
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/stm32-adc-core.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/stm32-adc-core.c
+++ b/drivers/iio/adc/stm32-adc-core.c
@@ -87,6 +87,7 @@ struct stm32_adc_priv_cfg {
  * @domain:		irq domain reference
  * @aclk:		clock reference for the analog circuitry
  * @bclk:		bus clock common for all ADCs, depends on part used
+ * @vdda:		vdda analog supply reference
  * @vref:		regulator reference
  * @cfg:		compatible configuration data
  * @common:		common data for all ADC instances
@@ -97,6 +98,7 @@ struct stm32_adc_priv {
 	struct irq_domain		*domain;
 	struct clk			*aclk;
 	struct clk			*bclk;
+	struct regulator		*vdda;
 	struct regulator		*vref;
 	const struct stm32_adc_priv_cfg	*cfg;
 	struct stm32_adc_common		common;
@@ -394,10 +396,16 @@ static int stm32_adc_core_hw_start(struc
 	struct stm32_adc_priv *priv = to_stm32_adc_priv(common);
 	int ret;
 
+	ret = regulator_enable(priv->vdda);
+	if (ret < 0) {
+		dev_err(dev, "vdda enable failed %d\n", ret);
+		return ret;
+	}
+
 	ret = regulator_enable(priv->vref);
 	if (ret < 0) {
 		dev_err(dev, "vref enable failed\n");
-		return ret;
+		goto err_vdda_disable;
 	}
 
 	if (priv->bclk) {
@@ -425,6 +433,8 @@ err_bclk_disable:
 		clk_disable_unprepare(priv->bclk);
 err_regulator_disable:
 	regulator_disable(priv->vref);
+err_vdda_disable:
+	regulator_disable(priv->vdda);
 
 	return ret;
 }
@@ -441,6 +451,7 @@ static void stm32_adc_core_hw_stop(struc
 	if (priv->bclk)
 		clk_disable_unprepare(priv->bclk);
 	regulator_disable(priv->vref);
+	regulator_disable(priv->vdda);
 }
 
 static int stm32_adc_probe(struct platform_device *pdev)
@@ -468,6 +479,14 @@ static int stm32_adc_probe(struct platfo
 		return PTR_ERR(priv->common.base);
 	priv->common.phys_base = res->start;
 
+	priv->vdda = devm_regulator_get(&pdev->dev, "vdda");
+	if (IS_ERR(priv->vdda)) {
+		ret = PTR_ERR(priv->vdda);
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "vdda get failed, %d\n", ret);
+		return ret;
+	}
+
 	priv->vref = devm_regulator_get(&pdev->dev, "vref");
 	if (IS_ERR(priv->vref)) {
 		ret = PTR_ERR(priv->vref);


