Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAFE55C1FC
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbiF0L21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235018AbiF0L0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:26:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A0A65AC;
        Mon, 27 Jun 2022 04:26:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65251614AE;
        Mon, 27 Jun 2022 11:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741EEC3411D;
        Mon, 27 Jun 2022 11:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329202;
        bh=6MGD7FQmuZqCGtpyq5/mysob2juBKQYP6BIpYM70IIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0in/TjXJkga8IB3edrrKBu/llSYVBq6LwFQYp2WttquAo9nEcwJxOx5LYwPjkxMC/
         xJkhFblRMUFpgxRRegeCYkmKtacqUe1vMLyQW4tfd5tIi+3PGbJn6CrsrL/8xWsRx8
         7aUVVEtMWvCYmkzuAScJRS7DaP/QTKTeZ8osakps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yannick Brosseau <yannick.brosseau@gmail.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 082/102] iio: adc: stm32: Fix IRQs on STM32F4 by removing custom spurious IRQs message
Date:   Mon, 27 Jun 2022 13:21:33 +0200
Message-Id: <20220627111935.900652709@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yannick Brosseau <yannick.brosseau@gmail.com>

commit 99bded02dae5e1e2312813506c41dc8db2fb656c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/stm32-adc.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -1265,7 +1265,6 @@ static irqreturn_t stm32_adc_threaded_is
 	struct stm32_adc *adc = iio_priv(indio_dev);
 	const struct stm32_adc_regspec *regs = adc->cfg->regs;
 	u32 status = stm32_adc_readl(adc, regs->isr_eoc.reg);
-	u32 mask = stm32_adc_readl(adc, regs->ier_eoc.reg);
 
 	/* Check ovr status right now, as ovr mask should be already disabled */
 	if (status & regs->isr_ovr.mask) {
@@ -1280,11 +1279,6 @@ static irqreturn_t stm32_adc_threaded_is
 		return IRQ_HANDLED;
 	}
 
-	if (!(status & mask))
-		dev_err_ratelimited(&indio_dev->dev,
-				    "Unexpected IRQ: IER=0x%08x, ISR=0x%08x\n",
-				    mask, status);
-
 	return IRQ_NONE;
 }
 
@@ -1294,10 +1288,6 @@ static irqreturn_t stm32_adc_isr(int irq
 	struct stm32_adc *adc = iio_priv(indio_dev);
 	const struct stm32_adc_regspec *regs = adc->cfg->regs;
 	u32 status = stm32_adc_readl(adc, regs->isr_eoc.reg);
-	u32 mask = stm32_adc_readl(adc, regs->ier_eoc.reg);
-
-	if (!(status & mask))
-		return IRQ_WAKE_THREAD;
 
 	if (status & regs->isr_ovr.mask) {
 		/*


