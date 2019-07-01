Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445EF5B764
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 11:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbfGAJCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 05:02:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728196AbfGAJCK (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 1 Jul 2019 05:02:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C901217D9;
        Mon,  1 Jul 2019 09:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561971728;
        bh=6NTdJ10c2XbenmGqAJoRMKr0iha2JG7ymgBHgQ29lkw=;
        h=Subject:To:From:Date:From;
        b=fBCtgmNRCRskq6DrNdIQah19gUw0diSICCbwtgpqb1BPZlPswX/Q+HwF/DhjVd3G5
         4XFQWeFFAa2wbwHdbJ+zYEgl/Lq1FUGBF41DbzAV/Colbyz75HJ1PXGREL+4RjQu0q
         BcHOb7HuYEbTS8yPjf567D+JvzK0XRwwfJpQI/T0=
Subject: patch "iio: adc: stm32-adc: add missing vdda-supply" added to staging-testing
To:     fabrice.gasnier@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Jul 2019 10:59:57 +0200
Message-ID: <1561971597188147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: stm32-adc: add missing vdda-supply

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 7685010fca2ba0284f31fd1380df3cffc96d847e Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@st.com>
Date: Wed, 19 Jun 2019 14:29:55 +0200
Subject: iio: adc: stm32-adc: add missing vdda-supply

Add missing vdda-supply, analog power supply, to STM32 ADC. When vdda is
an independent supply, it needs to be properly turned on or off to supply
the ADC.

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Fixes: 1add69880240 ("iio: adc: Add support for STM32 ADC core").
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/stm32-adc-core.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/stm32-adc-core.c b/drivers/iio/adc/stm32-adc-core.c
index 2327ec18b40c..1f7ce5186dfc 100644
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
@@ -394,10 +396,16 @@ static int stm32_adc_core_hw_start(struct device *dev)
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
@@ -425,6 +433,8 @@ static int stm32_adc_core_hw_start(struct device *dev)
 		clk_disable_unprepare(priv->bclk);
 err_regulator_disable:
 	regulator_disable(priv->vref);
+err_vdda_disable:
+	regulator_disable(priv->vdda);
 
 	return ret;
 }
@@ -441,6 +451,7 @@ static void stm32_adc_core_hw_stop(struct device *dev)
 	if (priv->bclk)
 		clk_disable_unprepare(priv->bclk);
 	regulator_disable(priv->vref);
+	regulator_disable(priv->vdda);
 }
 
 static int stm32_adc_probe(struct platform_device *pdev)
@@ -468,6 +479,14 @@ static int stm32_adc_probe(struct platform_device *pdev)
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
-- 
2.22.0


