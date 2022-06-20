Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA835511DA
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 09:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239564AbiFTHvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 03:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239560AbiFTHvL (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 20 Jun 2022 03:51:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6B3101F7
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 00:51:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87D8261208
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 07:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9903EC3411B;
        Mon, 20 Jun 2022 07:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655711470;
        bh=sI/3jlw9XHEmHklUL5Z5HyWbgw8WPlI14+aEMbOTXYs=;
        h=Subject:To:From:Date:From;
        b=mT2kL6V4W3DV2+2XUlW9qlyQgfLDEO20x/Tj6vw709h0pD3T7UMr83vaTWEv6b92Q
         iCKNSqYtvkGCmShJYVugwK5AXyC6FfQjM9MiHKgnYl5qFKpJcOBuSrviRXMdOP3kLn
         TrKaz/X7WxBX+3kFE5jEXYlBD9uwv2RNxIX6/b4M=
Subject: patch "iio: adc: stm32: Fix ADCs iteration in irq handler" added to char-misc-linus
To:     yannick.brosseau@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, fabrice.gasnier@foss.st.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 09:50:41 +0200
Message-ID: <165571144175229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: stm32: Fix ADCs iteration in irq handler

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d2214cca4d3eadc74eac9e30301ec7cad5355f00 Mon Sep 17 00:00:00 2001
From: Yannick Brosseau <yannick.brosseau@gmail.com>
Date: Mon, 16 May 2022 16:39:38 -0400
Subject: iio: adc: stm32: Fix ADCs iteration in irq handler

The irq handler was only checking the mask for the first ADCs in the case of the
F4 and H7 generation, since it was iterating up to the num_irq value. This patch add
the maximum number of ADC in the common register, which map to the number of entries of
eoc_msk and ovr_msk in stm32_adc_common_regs. This allow the handler to check all ADCs in
that module.

Tested on a STM32F429NIH6.

Fixes: 695e2f5c289b ("iio: adc: stm32-adc: fix a regression when using dma and irq")
Signed-off-by: Yannick Brosseau <yannick.brosseau@gmail.com>
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20220516203939.3498673-2-yannick.brosseau@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/stm32-adc-core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/stm32-adc-core.c b/drivers/iio/adc/stm32-adc-core.c
index 142656232157..bb04deeb7992 100644
--- a/drivers/iio/adc/stm32-adc-core.c
+++ b/drivers/iio/adc/stm32-adc-core.c
@@ -64,6 +64,7 @@ struct stm32_adc_priv;
  * @max_clk_rate_hz: maximum analog clock rate (Hz, from datasheet)
  * @has_syscfg: SYSCFG capability flags
  * @num_irqs:	number of interrupt lines
+ * @num_adcs:   maximum number of ADC instances in the common registers
  */
 struct stm32_adc_priv_cfg {
 	const struct stm32_adc_common_regs *regs;
@@ -71,6 +72,7 @@ struct stm32_adc_priv_cfg {
 	u32 max_clk_rate_hz;
 	unsigned int has_syscfg;
 	unsigned int num_irqs;
+	unsigned int num_adcs;
 };
 
 /**
@@ -352,7 +354,7 @@ static void stm32_adc_irq_handler(struct irq_desc *desc)
 	 * before invoking the interrupt handler (e.g. call ISR only for
 	 * IRQ-enabled ADCs).
 	 */
-	for (i = 0; i < priv->cfg->num_irqs; i++) {
+	for (i = 0; i < priv->cfg->num_adcs; i++) {
 		if ((status & priv->cfg->regs->eoc_msk[i] &&
 		     stm32_adc_eoc_enabled(priv, i)) ||
 		     (status & priv->cfg->regs->ovr_msk[i]))
@@ -792,6 +794,7 @@ static const struct stm32_adc_priv_cfg stm32f4_adc_priv_cfg = {
 	.clk_sel = stm32f4_adc_clk_sel,
 	.max_clk_rate_hz = 36000000,
 	.num_irqs = 1,
+	.num_adcs = 3,
 };
 
 static const struct stm32_adc_priv_cfg stm32h7_adc_priv_cfg = {
@@ -800,6 +803,7 @@ static const struct stm32_adc_priv_cfg stm32h7_adc_priv_cfg = {
 	.max_clk_rate_hz = 36000000,
 	.has_syscfg = HAS_VBOOSTER,
 	.num_irqs = 1,
+	.num_adcs = 2,
 };
 
 static const struct stm32_adc_priv_cfg stm32mp1_adc_priv_cfg = {
@@ -808,6 +812,7 @@ static const struct stm32_adc_priv_cfg stm32mp1_adc_priv_cfg = {
 	.max_clk_rate_hz = 40000000,
 	.has_syscfg = HAS_VBOOSTER | HAS_ANASWVDD,
 	.num_irqs = 2,
+	.num_adcs = 2,
 };
 
 static const struct of_device_id stm32_adc_of_match[] = {
-- 
2.36.1


