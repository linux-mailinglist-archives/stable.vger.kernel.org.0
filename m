Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713A14DD94B
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 12:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236012AbiCRL6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 07:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236013AbiCRL6l (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 18 Mar 2022 07:58:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629502C5425
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 04:57:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F372B821D7
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 11:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE8AC340E8;
        Fri, 18 Mar 2022 11:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647604640;
        bh=AhMhK8V1zo6/4fMuCLbBxyANSYouqw9SIpx2UHlkl8w=;
        h=Subject:To:From:Date:From;
        b=Z3cOzCWknri85zxcIhWXDlTp1NLERZHAw0CMLZi+mMKP28YGFidRGgSCEnSPAPXh2
         az06uewSJXPGEOacFGs3w9o5sBE7yYv1vWUpNkaIOltQ5RBqbEglrBa3ZzLzYwHPw+
         JgpoXir+Rvfh27WrVmeN6l6jnXK/vVuQ36ZU4/10=
Subject: patch "iio: adc: aspeed: Add divider flag to fix incorrect voltage reading." added to char-misc-testing
To:     billy_tsai@aspeedtech.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, joel@jms.id.au, kitsok@yandex-team.ru
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Mar 2022 12:43:48 +0100
Message-ID: <1647603828216124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: aspeed: Add divider flag to fix incorrect voltage reading.

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 571426631acf46e2999c7ecd1e9d048172969a43 Mon Sep 17 00:00:00 2001
From: Billy Tsai <billy_tsai@aspeedtech.com>
Date: Mon, 21 Feb 2022 09:27:05 +0800
Subject: iio: adc: aspeed: Add divider flag to fix incorrect voltage reading.

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
---
 drivers/iio/adc/aspeed_adc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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
 
-- 
2.35.1


