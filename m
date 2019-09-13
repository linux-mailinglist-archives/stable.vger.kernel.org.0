Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84866B2014
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389151AbfIMNPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:15:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389726AbfIMNPi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:15:38 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0524214AE;
        Fri, 13 Sep 2019 13:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380537;
        bh=glaAkWpahE1sgKI34qcF2w15f41BDvcFRLMcHeDjOR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kUgCROXY4v5K0rVtIKawwwOB8IHvjCq9aLaibZKj86DcLowA3A5sPhcO0IIBlGP/T
         XHyi3wCmIPO0Nexq8KWdwFPPvg3yklfVJoI7csMLGt304W77aHk+lDuQFAimaxc512
         OWGRbaddec4ZaFYuQn/PJhezL6i8bSPVgWoooZ7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 090/190] iio: adc: exynos-adc: Use proper number of channels for Exynos4x12
Date:   Fri, 13 Sep 2019 14:05:45 +0100
Message-Id: <20190913130606.807045201@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 103cda6a3b8d2c10d5f8cd7abad118e9db8f4776 ]

Exynos4212 and Exynos4412 have only four ADC channels so using
"samsung,exynos-adc-v1" compatible (for eight channels ADCv1) on them is
wrong.  Add a new compatible for Exynos4x12.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/iio/adc/samsung,exynos-adc.txt     |  4 +++-
 drivers/iio/adc/exynos_adc.c                    | 17 +++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/iio/adc/samsung,exynos-adc.txt b/Documentation/devicetree/bindings/iio/adc/samsung,exynos-adc.txt
index a10c1f89037de..e1fe02f3e3e9c 100644
--- a/Documentation/devicetree/bindings/iio/adc/samsung,exynos-adc.txt
+++ b/Documentation/devicetree/bindings/iio/adc/samsung,exynos-adc.txt
@@ -11,11 +11,13 @@ New driver handles the following
 
 Required properties:
 - compatible:		Must be "samsung,exynos-adc-v1"
-				for exynos4412/5250 controllers.
+				for Exynos5250 controllers.
 			Must be "samsung,exynos-adc-v2" for
 				future controllers.
 			Must be "samsung,exynos3250-adc" for
 				controllers compatible with ADC of Exynos3250.
+			Must be "samsung,exynos4212-adc" for
+				controllers compatible with ADC of Exynos4212 and Exynos4412.
 			Must be "samsung,exynos7-adc" for
 				the ADC in Exynos7 and compatibles
 			Must be "samsung,s3c2410-adc" for
diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index 41da522fc6735..1ca2c4d39f878 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -115,6 +115,7 @@
 #define MAX_ADC_V2_CHANNELS		10
 #define MAX_ADC_V1_CHANNELS		8
 #define MAX_EXYNOS3250_ADC_CHANNELS	2
+#define MAX_EXYNOS4212_ADC_CHANNELS	4
 #define MAX_S5PV210_ADC_CHANNELS	10
 
 /* Bit definitions common for ADC_V1 and ADC_V2 */
@@ -271,6 +272,19 @@ static void exynos_adc_v1_start_conv(struct exynos_adc *info,
 	writel(con1 | ADC_CON_EN_START, ADC_V1_CON(info->regs));
 }
 
+/* Exynos4212 and 4412 is like ADCv1 but with four channels only */
+static const struct exynos_adc_data exynos4212_adc_data = {
+	.num_channels	= MAX_EXYNOS4212_ADC_CHANNELS,
+	.mask		= ADC_DATX_MASK,	/* 12 bit ADC resolution */
+	.needs_adc_phy	= true,
+	.phy_offset	= EXYNOS_ADCV1_PHY_OFFSET,
+
+	.init_hw	= exynos_adc_v1_init_hw,
+	.exit_hw	= exynos_adc_v1_exit_hw,
+	.clear_irq	= exynos_adc_v1_clear_irq,
+	.start_conv	= exynos_adc_v1_start_conv,
+};
+
 static const struct exynos_adc_data exynos_adc_v1_data = {
 	.num_channels	= MAX_ADC_V1_CHANNELS,
 	.mask		= ADC_DATX_MASK,	/* 12 bit ADC resolution */
@@ -492,6 +506,9 @@ static const struct of_device_id exynos_adc_match[] = {
 	}, {
 		.compatible = "samsung,s5pv210-adc",
 		.data = &exynos_adc_s5pv210_data,
+	}, {
+		.compatible = "samsung,exynos4212-adc",
+		.data = &exynos4212_adc_data,
 	}, {
 		.compatible = "samsung,exynos-adc-v1",
 		.data = &exynos_adc_v1_data,
-- 
2.20.1



