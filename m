Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AED39D66AE
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 17:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732035AbfJNP63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 11:58:29 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:50855 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726304AbfJNP63 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 14 Oct 2019 11:58:29 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id ED6E56F6;
        Mon, 14 Oct 2019 11:58:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 14 Oct 2019 11:58:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=FRsGYd
        2ku9QY/FqJDAh5CyF8UGz27r2HSBnJuIwUcOE=; b=TRg7cEuJVlX5RnEF8Y0IvD
        CQf2qgWPqlA7hoMuCYLTCJfDg00bn9WGTgaA7ZyEQeIUY3cBKxGl8NJQfEZkCVUj
        WUYveqrXqfY5ATW+7G9+twasg+mDmidMEQCs0I/dr6QCiXV46hcpdspAGrSWMpQB
        8DpYoOByPc/t5rGNkVyKb5rjgXcWLhZZygp8qeCZTyg42bRQ/qsLCeInrAnDI4pr
        m4DQeRv6Oyz9h7ubb4DW3xRNyEiAzTDDjZBsFz5QRlkvq2SfpmPduRi9PH8kIqKU
        TFSr1ecwRFyg6ELtk/BZMW7LmcZ/mwiGlxC/EFFNgxlcWf3JyGTvXo/Das0zLgIw
        ==
X-ME-Sender: <xms:I5ukXW0Ymfeywr6G7y0kqhgT7iRR1rZgkxo7HSOKAVwkdUq1KZeSxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedugdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:I5ukXdVJwqMhCo3vJCkcrRH2cA4Ip5Fm_2ynfnHBF4Bk-gCNaSyW-Q>
    <xmx:I5ukXZ66FdCzQRYrvgJVWVMnLcdGYdiCglDt4augC1q80D20uxwIfA>
    <xmx:I5ukXcJykTviLTB__k8kyJpgbs76cQhNfXJ5lTrmtfM39BozKAH7Bw>
    <xmx:I5ukXSIQFDj4w4aevfBdKOIqnzNbiNZ-4_tyxSgw6busGCCswI_XFw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0D1458005A;
        Mon, 14 Oct 2019 11:58:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: adc: stm32-adc: fix a race when using several adcs with" failed to apply to 4.14-stable tree
To:     fabrice.gasnier@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Oct 2019 17:58:16 +0200
Message-ID: <1571068696152234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dcb10920179ab74caf88a6f2afadecfc2743b910 Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@st.com>
Date: Tue, 17 Sep 2019 14:38:16 +0200
Subject: [PATCH] iio: adc: stm32-adc: fix a race when using several adcs with
 dma and irq

End of conversion may be handled by using IRQ or DMA. There may be a
race when two conversions complete at the same time on several ADCs.
EOC can be read as 'set' for several ADCs, with:
- an ADC configured to use IRQs. EOCIE bit is set. The handler is normally
  called in this case.
- an ADC configured to use DMA. EOCIE bit isn't set. EOC triggers the DMA
  request instead. It's then automatically cleared by DMA read. But the
  handler gets called due to status bit is temporarily set (IRQ triggered
  by the other ADC).
So both EOC status bit in CSR and EOCIE control bit must be checked
before invoking the interrupt handler (e.g. call ISR only for
IRQ-enabled ADCs).

Fixes: 2763ea0585c9 ("iio: adc: stm32: add optional dma support")

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/adc/stm32-adc-core.c b/drivers/iio/adc/stm32-adc-core.c
index 84ac326bb714..93a096a91f8c 100644
--- a/drivers/iio/adc/stm32-adc-core.c
+++ b/drivers/iio/adc/stm32-adc-core.c
@@ -44,6 +44,8 @@
  * @eoc1:	adc1 end of conversion flag in @csr
  * @eoc2:	adc2 end of conversion flag in @csr
  * @eoc3:	adc3 end of conversion flag in @csr
+ * @ier:	interrupt enable register offset for each adc
+ * @eocie_msk:	end of conversion interrupt enable mask in @ier
  */
 struct stm32_adc_common_regs {
 	u32 csr;
@@ -51,6 +53,8 @@ struct stm32_adc_common_regs {
 	u32 eoc1_msk;
 	u32 eoc2_msk;
 	u32 eoc3_msk;
+	u32 ier;
+	u32 eocie_msk;
 };
 
 struct stm32_adc_priv;
@@ -276,6 +280,8 @@ static const struct stm32_adc_common_regs stm32f4_adc_common_regs = {
 	.eoc1_msk = STM32F4_EOC1,
 	.eoc2_msk = STM32F4_EOC2,
 	.eoc3_msk = STM32F4_EOC3,
+	.ier = STM32F4_ADC_CR1,
+	.eocie_msk = STM32F4_EOCIE,
 };
 
 /* STM32H7 common registers definitions */
@@ -284,8 +290,24 @@ static const struct stm32_adc_common_regs stm32h7_adc_common_regs = {
 	.ccr = STM32H7_ADC_CCR,
 	.eoc1_msk = STM32H7_EOC_MST,
 	.eoc2_msk = STM32H7_EOC_SLV,
+	.ier = STM32H7_ADC_IER,
+	.eocie_msk = STM32H7_EOCIE,
 };
 
+static const unsigned int stm32_adc_offset[STM32_ADC_MAX_ADCS] = {
+	0, STM32_ADC_OFFSET, STM32_ADC_OFFSET * 2,
+};
+
+static unsigned int stm32_adc_eoc_enabled(struct stm32_adc_priv *priv,
+					  unsigned int adc)
+{
+	u32 ier, offset = stm32_adc_offset[adc];
+
+	ier = readl_relaxed(priv->common.base + offset + priv->cfg->regs->ier);
+
+	return ier & priv->cfg->regs->eocie_msk;
+}
+
 /* ADC common interrupt for all instances */
 static void stm32_adc_irq_handler(struct irq_desc *desc)
 {
@@ -296,13 +318,28 @@ static void stm32_adc_irq_handler(struct irq_desc *desc)
 	chained_irq_enter(chip, desc);
 	status = readl_relaxed(priv->common.base + priv->cfg->regs->csr);
 
-	if (status & priv->cfg->regs->eoc1_msk)
+	/*
+	 * End of conversion may be handled by using IRQ or DMA. There may be a
+	 * race here when two conversions complete at the same time on several
+	 * ADCs. EOC may be read 'set' for several ADCs, with:
+	 * - an ADC configured to use DMA (EOC triggers the DMA request, and
+	 *   is then automatically cleared by DR read in hardware)
+	 * - an ADC configured to use IRQs (EOCIE bit is set. The handler must
+	 *   be called in this case)
+	 * So both EOC status bit in CSR and EOCIE control bit must be checked
+	 * before invoking the interrupt handler (e.g. call ISR only for
+	 * IRQ-enabled ADCs).
+	 */
+	if (status & priv->cfg->regs->eoc1_msk &&
+	    stm32_adc_eoc_enabled(priv, 0))
 		generic_handle_irq(irq_find_mapping(priv->domain, 0));
 
-	if (status & priv->cfg->regs->eoc2_msk)
+	if (status & priv->cfg->regs->eoc2_msk &&
+	    stm32_adc_eoc_enabled(priv, 1))
 		generic_handle_irq(irq_find_mapping(priv->domain, 1));
 
-	if (status & priv->cfg->regs->eoc3_msk)
+	if (status & priv->cfg->regs->eoc3_msk &&
+	    stm32_adc_eoc_enabled(priv, 2))
 		generic_handle_irq(irq_find_mapping(priv->domain, 2));
 
 	chained_irq_exit(chip, desc);
diff --git a/drivers/iio/adc/stm32-adc-core.h b/drivers/iio/adc/stm32-adc-core.h
index 94aa2d2577dc..2579d514c2a3 100644
--- a/drivers/iio/adc/stm32-adc-core.h
+++ b/drivers/iio/adc/stm32-adc-core.h
@@ -25,6 +25,7 @@
  * --------------------------------------------------------
  */
 #define STM32_ADC_MAX_ADCS		3
+#define STM32_ADC_OFFSET		0x100
 #define STM32_ADCX_COMN_OFFSET		0x300
 
 /* STM32F4 - Registers for each ADC instance */

