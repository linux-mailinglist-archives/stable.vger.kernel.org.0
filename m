Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F895511E5
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 09:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239560AbiFTHvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 03:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239567AbiFTHvR (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 20 Jun 2022 03:51:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E329ADEEF
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 00:51:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8316961213
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 07:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92853C341C4;
        Mon, 20 Jun 2022 07:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655711476;
        bh=HVARpJJm6HdVEuGlhlR/QzlRporuJ50Kz8kGEgi/CnU=;
        h=Subject:To:From:Date:From;
        b=tq0TArmcrxbBIzpIBI3diMOl7QuH0cjlVJLc5rIFxIxoN7wAAGGh/iADiR9g0WIiL
         asDcAQKgHR4F4k+VptZSrbLueh5ZBsLEgsKFNwRvAF9kLwI0lQAV+MS1Ov0nboiIF0
         lkpW21DWjbxxCePEdvgT/wvZYU9yGuKuDvcHnKKg=
Subject: patch "iio: adc: stm32: Fix IRQs on STM32F4 by removing custom spurious IRQs" added to char-misc-linus
To:     yannick.brosseau@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, fabrice.gasnier@foss.st.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 09:50:42 +0200
Message-ID: <16557114425119@kroah.com>
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

    iio: adc: stm32: Fix IRQs on STM32F4 by removing custom spurious IRQs

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 99bded02dae5e1e2312813506c41dc8db2fb656c Mon Sep 17 00:00:00 2001
From: Yannick Brosseau <yannick.brosseau@gmail.com>
Date: Mon, 16 May 2022 16:39:39 -0400
Subject: iio: adc: stm32: Fix IRQs on STM32F4 by removing custom spurious IRQs
 message

The check for spurious IRQs introduced in 695e2f5c289bb assumed that the bits
in the control and status registers are aligned. This is true for the H7 and MP1
version, but not the F4. The interrupt was then never handled on the F4.

Instead of increasing the complexity of the comparison and check each bit specifically,
we remove this check completely and rely on the generic handler for spurious IRQs.

Fixes: 695e2f5c289b ("iio: adc: stm32-adc: fix a regression when using dma and irq")
Signed-off-by: Yannick Brosseau <yannick.brosseau@gmail.com>
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20220516203939.3498673-3-yannick.brosseau@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/stm32-adc.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index a68ecbda6480..8c5f05f593ab 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -1407,7 +1407,6 @@ static irqreturn_t stm32_adc_threaded_isr(int irq, void *data)
 	struct stm32_adc *adc = iio_priv(indio_dev);
 	const struct stm32_adc_regspec *regs = adc->cfg->regs;
 	u32 status = stm32_adc_readl(adc, regs->isr_eoc.reg);
-	u32 mask = stm32_adc_readl(adc, regs->ier_eoc.reg);
 
 	/* Check ovr status right now, as ovr mask should be already disabled */
 	if (status & regs->isr_ovr.mask) {
@@ -1422,11 +1421,6 @@ static irqreturn_t stm32_adc_threaded_isr(int irq, void *data)
 		return IRQ_HANDLED;
 	}
 
-	if (!(status & mask))
-		dev_err_ratelimited(&indio_dev->dev,
-				    "Unexpected IRQ: IER=0x%08x, ISR=0x%08x\n",
-				    mask, status);
-
 	return IRQ_NONE;
 }
 
@@ -1436,10 +1430,6 @@ static irqreturn_t stm32_adc_isr(int irq, void *data)
 	struct stm32_adc *adc = iio_priv(indio_dev);
 	const struct stm32_adc_regspec *regs = adc->cfg->regs;
 	u32 status = stm32_adc_readl(adc, regs->isr_eoc.reg);
-	u32 mask = stm32_adc_readl(adc, regs->ier_eoc.reg);
-
-	if (!(status & mask))
-		return IRQ_WAKE_THREAD;
 
 	if (status & regs->isr_ovr.mask) {
 		/*
-- 
2.36.1


