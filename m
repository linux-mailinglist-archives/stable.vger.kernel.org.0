Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F334EEB1B
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 12:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245177AbiDAKTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 06:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245095AbiDAKTA (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 1 Apr 2022 06:19:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCD926B39F
        for <Stable@vger.kernel.org>; Fri,  1 Apr 2022 03:17:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3CC7B823FB
        for <Stable@vger.kernel.org>; Fri,  1 Apr 2022 10:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53ADAC34110;
        Fri,  1 Apr 2022 10:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648808227;
        bh=8nxaEZ6eHrdKzCAtSSEb7GmdzPfYoiRN4Jy1vZ/oLUM=;
        h=Subject:To:Cc:From:Date:From;
        b=Ibi04ArTcUZ09GD1c1lPZ0YPW/lw4gqeHoLYwaPTdqegnNU3SbU6WDDYl+tl+BkJg
         sDs66w/UsOKmvUAMaPWCvNH0PwLAHg4wyuQm9b1j/V15+MWxH7pL8uFD11sWBgsMEx
         uSayzR5ziKvRTFNMWES4wnQKz/D0GC8P0rJIlGDQ=
Subject: FAILED: patch "[PATCH] iio: adc: aspeed: Add divider flag to fix incorrect voltage" failed to apply to 5.15-stable tree
To:     billy_tsai@aspeedtech.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, joel@jms.id.au, kitsok@yandex-team.ru
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 01 Apr 2022 12:17:04 +0200
Message-ID: <164880822419287@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 571426631acf46e2999c7ecd1e9d048172969a43 Mon Sep 17 00:00:00 2001
From: Billy Tsai <billy_tsai@aspeedtech.com>
Date: Mon, 21 Feb 2022 09:27:05 +0800
Subject: [PATCH] iio: adc: aspeed: Add divider flag to fix incorrect voltage
 reading.

The formula for the ADC sampling period in ast2400/ast2500 is:
ADC clock period = PCLK * 2 * (ADC0C[31:17] + 1) * (ADC0C[9:0])
When ADC0C[9:0] is set to 0 the sampling voltage will be lower than
expected, because the hardware may not have enough time to
charge/discharge to a stable voltage. This patch use the flag
CLK_DIVIDER_ONE_BASED which will use the raw value read from the
register, with the value of zero considered invalid to conform to the
corrected formula.

Fixes: 573803234e72 ("iio: Aspeed ADC")
Reported-by: Konstantin Klubnichkin <kitsok@yandex-team.ru>
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20220221012705.22008-1-billy_tsai@aspeedtech.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/adc/aspeed_adc.c b/drivers/iio/adc/aspeed_adc.c
index e939b84cbb56..0793d2474cdc 100644
--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -539,7 +539,9 @@ static int aspeed_adc_probe(struct platform_device *pdev)
 	data->clk_scaler = devm_clk_hw_register_divider(
 		&pdev->dev, clk_name, clk_parent_name, scaler_flags,
 		data->base + ASPEED_REG_CLOCK_CONTROL, 0,
-		data->model_data->scaler_bit_width, 0, &data->clk_lock);
+		data->model_data->scaler_bit_width,
+		data->model_data->need_prescaler ? CLK_DIVIDER_ONE_BASED : 0,
+		&data->clk_lock);
 	if (IS_ERR(data->clk_scaler))
 		return PTR_ERR(data->clk_scaler);
 

