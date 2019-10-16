Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF289DA032
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439124AbfJPWJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:09:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395502AbfJPV5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:57:39 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0136222D3;
        Wed, 16 Oct 2019 21:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263058;
        bh=xqxhwZQAPTYk3yF0JMsCSmn0mzoykXeQq/k1xTHvKyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8mIfr8rzTziyvTaSr1W4PVuWqwYDsbrWvHJAAHWty2eMbUCfjgFzSf5xthpxRzB6
         Mkifdl4yGPLUGfm3SDdunVdSVXpQDSQrdezPc/fJ7UrWfA+GWOYx+eLICkxZbNeVi7
         XoQcZVuSe2qsmPzqZMVWjsFMbpbmzVJSQ1/lBtCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabrice Gasnier <fabrice.gasnier@st.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 60/81] iio: adc: stm32-adc: move registers definitions
Date:   Wed, 16 Oct 2019 14:51:11 -0700
Message-Id: <20191016214843.701704296@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@st.com>

[ Upstream commit 31922f62bb527d749b99dbc776e514bcba29b7fe ]

Move STM32 ADC registers definitions to common header.
This is precursor patch to:
- iio: adc: stm32-adc: fix a race when using several adcs with dma and irq

It keeps registers definitions as a whole block, to ease readability and
allow simple access path to EOC bits (readl) in stm32-adc-core driver.

Fixes: 2763ea0585c9 ("iio: adc: stm32: add optional dma support")

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stm32-adc-core.c |  27 ------
 drivers/iio/adc/stm32-adc-core.h | 136 +++++++++++++++++++++++++++++++
 drivers/iio/adc/stm32-adc.c      | 109 -------------------------
 3 files changed, 136 insertions(+), 136 deletions(-)

diff --git a/drivers/iio/adc/stm32-adc-core.c b/drivers/iio/adc/stm32-adc-core.c
index ca432e7b6ff1d..ce2cc61395d63 100644
--- a/drivers/iio/adc/stm32-adc-core.c
+++ b/drivers/iio/adc/stm32-adc-core.c
@@ -21,33 +21,6 @@
 
 #include "stm32-adc-core.h"
 
-/* STM32F4 - common registers for all ADC instances: 1, 2 & 3 */
-#define STM32F4_ADC_CSR			(STM32_ADCX_COMN_OFFSET + 0x00)
-#define STM32F4_ADC_CCR			(STM32_ADCX_COMN_OFFSET + 0x04)
-
-/* STM32F4_ADC_CSR - bit fields */
-#define STM32F4_EOC3			BIT(17)
-#define STM32F4_EOC2			BIT(9)
-#define STM32F4_EOC1			BIT(1)
-
-/* STM32F4_ADC_CCR - bit fields */
-#define STM32F4_ADC_ADCPRE_SHIFT	16
-#define STM32F4_ADC_ADCPRE_MASK		GENMASK(17, 16)
-
-/* STM32H7 - common registers for all ADC instances */
-#define STM32H7_ADC_CSR			(STM32_ADCX_COMN_OFFSET + 0x00)
-#define STM32H7_ADC_CCR			(STM32_ADCX_COMN_OFFSET + 0x08)
-
-/* STM32H7_ADC_CSR - bit fields */
-#define STM32H7_EOC_SLV			BIT(18)
-#define STM32H7_EOC_MST			BIT(2)
-
-/* STM32H7_ADC_CCR - bit fields */
-#define STM32H7_PRESC_SHIFT		18
-#define STM32H7_PRESC_MASK		GENMASK(21, 18)
-#define STM32H7_CKMODE_SHIFT		16
-#define STM32H7_CKMODE_MASK		GENMASK(17, 16)
-
 /**
  * stm32_adc_common_regs - stm32 common registers, compatible dependent data
  * @csr:	common status register offset
diff --git a/drivers/iio/adc/stm32-adc-core.h b/drivers/iio/adc/stm32-adc-core.h
index 8af507b3f32d9..94aa2d2577dc9 100644
--- a/drivers/iio/adc/stm32-adc-core.h
+++ b/drivers/iio/adc/stm32-adc-core.h
@@ -27,6 +27,142 @@
 #define STM32_ADC_MAX_ADCS		3
 #define STM32_ADCX_COMN_OFFSET		0x300
 
+/* STM32F4 - Registers for each ADC instance */
+#define STM32F4_ADC_SR			0x00
+#define STM32F4_ADC_CR1			0x04
+#define STM32F4_ADC_CR2			0x08
+#define STM32F4_ADC_SMPR1		0x0C
+#define STM32F4_ADC_SMPR2		0x10
+#define STM32F4_ADC_HTR			0x24
+#define STM32F4_ADC_LTR			0x28
+#define STM32F4_ADC_SQR1		0x2C
+#define STM32F4_ADC_SQR2		0x30
+#define STM32F4_ADC_SQR3		0x34
+#define STM32F4_ADC_JSQR		0x38
+#define STM32F4_ADC_JDR1		0x3C
+#define STM32F4_ADC_JDR2		0x40
+#define STM32F4_ADC_JDR3		0x44
+#define STM32F4_ADC_JDR4		0x48
+#define STM32F4_ADC_DR			0x4C
+
+/* STM32F4 - common registers for all ADC instances: 1, 2 & 3 */
+#define STM32F4_ADC_CSR			(STM32_ADCX_COMN_OFFSET + 0x00)
+#define STM32F4_ADC_CCR			(STM32_ADCX_COMN_OFFSET + 0x04)
+
+/* STM32F4_ADC_SR - bit fields */
+#define STM32F4_STRT			BIT(4)
+#define STM32F4_EOC			BIT(1)
+
+/* STM32F4_ADC_CR1 - bit fields */
+#define STM32F4_RES_SHIFT		24
+#define STM32F4_RES_MASK		GENMASK(25, 24)
+#define STM32F4_SCAN			BIT(8)
+#define STM32F4_EOCIE			BIT(5)
+
+/* STM32F4_ADC_CR2 - bit fields */
+#define STM32F4_SWSTART			BIT(30)
+#define STM32F4_EXTEN_SHIFT		28
+#define STM32F4_EXTEN_MASK		GENMASK(29, 28)
+#define STM32F4_EXTSEL_SHIFT		24
+#define STM32F4_EXTSEL_MASK		GENMASK(27, 24)
+#define STM32F4_EOCS			BIT(10)
+#define STM32F4_DDS			BIT(9)
+#define STM32F4_DMA			BIT(8)
+#define STM32F4_ADON			BIT(0)
+
+/* STM32F4_ADC_CSR - bit fields */
+#define STM32F4_EOC3			BIT(17)
+#define STM32F4_EOC2			BIT(9)
+#define STM32F4_EOC1			BIT(1)
+
+/* STM32F4_ADC_CCR - bit fields */
+#define STM32F4_ADC_ADCPRE_SHIFT	16
+#define STM32F4_ADC_ADCPRE_MASK		GENMASK(17, 16)
+
+/* STM32H7 - Registers for each ADC instance */
+#define STM32H7_ADC_ISR			0x00
+#define STM32H7_ADC_IER			0x04
+#define STM32H7_ADC_CR			0x08
+#define STM32H7_ADC_CFGR		0x0C
+#define STM32H7_ADC_SMPR1		0x14
+#define STM32H7_ADC_SMPR2		0x18
+#define STM32H7_ADC_PCSEL		0x1C
+#define STM32H7_ADC_SQR1		0x30
+#define STM32H7_ADC_SQR2		0x34
+#define STM32H7_ADC_SQR3		0x38
+#define STM32H7_ADC_SQR4		0x3C
+#define STM32H7_ADC_DR			0x40
+#define STM32H7_ADC_DIFSEL		0xC0
+#define STM32H7_ADC_CALFACT		0xC4
+#define STM32H7_ADC_CALFACT2		0xC8
+
+/* STM32H7 - common registers for all ADC instances */
+#define STM32H7_ADC_CSR			(STM32_ADCX_COMN_OFFSET + 0x00)
+#define STM32H7_ADC_CCR			(STM32_ADCX_COMN_OFFSET + 0x08)
+
+/* STM32H7_ADC_ISR - bit fields */
+#define STM32MP1_VREGREADY		BIT(12)
+#define STM32H7_EOC			BIT(2)
+#define STM32H7_ADRDY			BIT(0)
+
+/* STM32H7_ADC_IER - bit fields */
+#define STM32H7_EOCIE			STM32H7_EOC
+
+/* STM32H7_ADC_CR - bit fields */
+#define STM32H7_ADCAL			BIT(31)
+#define STM32H7_ADCALDIF		BIT(30)
+#define STM32H7_DEEPPWD			BIT(29)
+#define STM32H7_ADVREGEN		BIT(28)
+#define STM32H7_LINCALRDYW6		BIT(27)
+#define STM32H7_LINCALRDYW5		BIT(26)
+#define STM32H7_LINCALRDYW4		BIT(25)
+#define STM32H7_LINCALRDYW3		BIT(24)
+#define STM32H7_LINCALRDYW2		BIT(23)
+#define STM32H7_LINCALRDYW1		BIT(22)
+#define STM32H7_ADCALLIN		BIT(16)
+#define STM32H7_BOOST			BIT(8)
+#define STM32H7_ADSTP			BIT(4)
+#define STM32H7_ADSTART			BIT(2)
+#define STM32H7_ADDIS			BIT(1)
+#define STM32H7_ADEN			BIT(0)
+
+/* STM32H7_ADC_CFGR bit fields */
+#define STM32H7_EXTEN_SHIFT		10
+#define STM32H7_EXTEN_MASK		GENMASK(11, 10)
+#define STM32H7_EXTSEL_SHIFT		5
+#define STM32H7_EXTSEL_MASK		GENMASK(9, 5)
+#define STM32H7_RES_SHIFT		2
+#define STM32H7_RES_MASK		GENMASK(4, 2)
+#define STM32H7_DMNGT_SHIFT		0
+#define STM32H7_DMNGT_MASK		GENMASK(1, 0)
+
+enum stm32h7_adc_dmngt {
+	STM32H7_DMNGT_DR_ONLY,		/* Regular data in DR only */
+	STM32H7_DMNGT_DMA_ONESHOT,	/* DMA one shot mode */
+	STM32H7_DMNGT_DFSDM,		/* DFSDM mode */
+	STM32H7_DMNGT_DMA_CIRC,		/* DMA circular mode */
+};
+
+/* STM32H7_ADC_CALFACT - bit fields */
+#define STM32H7_CALFACT_D_SHIFT		16
+#define STM32H7_CALFACT_D_MASK		GENMASK(26, 16)
+#define STM32H7_CALFACT_S_SHIFT		0
+#define STM32H7_CALFACT_S_MASK		GENMASK(10, 0)
+
+/* STM32H7_ADC_CALFACT2 - bit fields */
+#define STM32H7_LINCALFACT_SHIFT	0
+#define STM32H7_LINCALFACT_MASK		GENMASK(29, 0)
+
+/* STM32H7_ADC_CSR - bit fields */
+#define STM32H7_EOC_SLV			BIT(18)
+#define STM32H7_EOC_MST			BIT(2)
+
+/* STM32H7_ADC_CCR - bit fields */
+#define STM32H7_PRESC_SHIFT		18
+#define STM32H7_PRESC_MASK		GENMASK(21, 18)
+#define STM32H7_CKMODE_SHIFT		16
+#define STM32H7_CKMODE_MASK		GENMASK(17, 16)
+
 /**
  * struct stm32_adc_common - stm32 ADC driver common data (for all instances)
  * @base:		control registers base cpu addr
diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index 378411853d751..c52d20f7ca2ed 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -27,115 +27,6 @@
 
 #include "stm32-adc-core.h"
 
-/* STM32F4 - Registers for each ADC instance */
-#define STM32F4_ADC_SR			0x00
-#define STM32F4_ADC_CR1			0x04
-#define STM32F4_ADC_CR2			0x08
-#define STM32F4_ADC_SMPR1		0x0C
-#define STM32F4_ADC_SMPR2		0x10
-#define STM32F4_ADC_HTR			0x24
-#define STM32F4_ADC_LTR			0x28
-#define STM32F4_ADC_SQR1		0x2C
-#define STM32F4_ADC_SQR2		0x30
-#define STM32F4_ADC_SQR3		0x34
-#define STM32F4_ADC_JSQR		0x38
-#define STM32F4_ADC_JDR1		0x3C
-#define STM32F4_ADC_JDR2		0x40
-#define STM32F4_ADC_JDR3		0x44
-#define STM32F4_ADC_JDR4		0x48
-#define STM32F4_ADC_DR			0x4C
-
-/* STM32F4_ADC_SR - bit fields */
-#define STM32F4_STRT			BIT(4)
-#define STM32F4_EOC			BIT(1)
-
-/* STM32F4_ADC_CR1 - bit fields */
-#define STM32F4_RES_SHIFT		24
-#define STM32F4_RES_MASK		GENMASK(25, 24)
-#define STM32F4_SCAN			BIT(8)
-#define STM32F4_EOCIE			BIT(5)
-
-/* STM32F4_ADC_CR2 - bit fields */
-#define STM32F4_SWSTART			BIT(30)
-#define STM32F4_EXTEN_SHIFT		28
-#define STM32F4_EXTEN_MASK		GENMASK(29, 28)
-#define STM32F4_EXTSEL_SHIFT		24
-#define STM32F4_EXTSEL_MASK		GENMASK(27, 24)
-#define STM32F4_EOCS			BIT(10)
-#define STM32F4_DDS			BIT(9)
-#define STM32F4_DMA			BIT(8)
-#define STM32F4_ADON			BIT(0)
-
-/* STM32H7 - Registers for each ADC instance */
-#define STM32H7_ADC_ISR			0x00
-#define STM32H7_ADC_IER			0x04
-#define STM32H7_ADC_CR			0x08
-#define STM32H7_ADC_CFGR		0x0C
-#define STM32H7_ADC_SMPR1		0x14
-#define STM32H7_ADC_SMPR2		0x18
-#define STM32H7_ADC_PCSEL		0x1C
-#define STM32H7_ADC_SQR1		0x30
-#define STM32H7_ADC_SQR2		0x34
-#define STM32H7_ADC_SQR3		0x38
-#define STM32H7_ADC_SQR4		0x3C
-#define STM32H7_ADC_DR			0x40
-#define STM32H7_ADC_DIFSEL		0xC0
-#define STM32H7_ADC_CALFACT		0xC4
-#define STM32H7_ADC_CALFACT2		0xC8
-
-/* STM32H7_ADC_ISR - bit fields */
-#define STM32MP1_VREGREADY		BIT(12)
-#define STM32H7_EOC			BIT(2)
-#define STM32H7_ADRDY			BIT(0)
-
-/* STM32H7_ADC_IER - bit fields */
-#define STM32H7_EOCIE			STM32H7_EOC
-
-/* STM32H7_ADC_CR - bit fields */
-#define STM32H7_ADCAL			BIT(31)
-#define STM32H7_ADCALDIF		BIT(30)
-#define STM32H7_DEEPPWD			BIT(29)
-#define STM32H7_ADVREGEN		BIT(28)
-#define STM32H7_LINCALRDYW6		BIT(27)
-#define STM32H7_LINCALRDYW5		BIT(26)
-#define STM32H7_LINCALRDYW4		BIT(25)
-#define STM32H7_LINCALRDYW3		BIT(24)
-#define STM32H7_LINCALRDYW2		BIT(23)
-#define STM32H7_LINCALRDYW1		BIT(22)
-#define STM32H7_ADCALLIN		BIT(16)
-#define STM32H7_BOOST			BIT(8)
-#define STM32H7_ADSTP			BIT(4)
-#define STM32H7_ADSTART			BIT(2)
-#define STM32H7_ADDIS			BIT(1)
-#define STM32H7_ADEN			BIT(0)
-
-/* STM32H7_ADC_CFGR bit fields */
-#define STM32H7_EXTEN_SHIFT		10
-#define STM32H7_EXTEN_MASK		GENMASK(11, 10)
-#define STM32H7_EXTSEL_SHIFT		5
-#define STM32H7_EXTSEL_MASK		GENMASK(9, 5)
-#define STM32H7_RES_SHIFT		2
-#define STM32H7_RES_MASK		GENMASK(4, 2)
-#define STM32H7_DMNGT_SHIFT		0
-#define STM32H7_DMNGT_MASK		GENMASK(1, 0)
-
-enum stm32h7_adc_dmngt {
-	STM32H7_DMNGT_DR_ONLY,		/* Regular data in DR only */
-	STM32H7_DMNGT_DMA_ONESHOT,	/* DMA one shot mode */
-	STM32H7_DMNGT_DFSDM,		/* DFSDM mode */
-	STM32H7_DMNGT_DMA_CIRC,		/* DMA circular mode */
-};
-
-/* STM32H7_ADC_CALFACT - bit fields */
-#define STM32H7_CALFACT_D_SHIFT		16
-#define STM32H7_CALFACT_D_MASK		GENMASK(26, 16)
-#define STM32H7_CALFACT_S_SHIFT		0
-#define STM32H7_CALFACT_S_MASK		GENMASK(10, 0)
-
-/* STM32H7_ADC_CALFACT2 - bit fields */
-#define STM32H7_LINCALFACT_SHIFT	0
-#define STM32H7_LINCALFACT_MASK		GENMASK(29, 0)
-
 /* Number of linear calibration shadow registers / LINCALRDYW control bits */
 #define STM32H7_LINCALFACT_NUM		6
 
-- 
2.20.1



