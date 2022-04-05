Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EA74F24E3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiDEHmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiDEHmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:42:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082A290FDC;
        Tue,  5 Apr 2022 00:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CC2161668;
        Tue,  5 Apr 2022 07:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86D4C340EE;
        Tue,  5 Apr 2022 07:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144398;
        bh=y4HzoPUx0g/Wg4u5UKwImFP7XoKjSKux0f3xg0dQGf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v7XlfogBc6W+7QymHx9o7sPty9VR62+r6I9U2kno1RFlkbXNdlxDnzbk0HvQcSHYF
         a1lfvColACtCHddoVcXOiKUMQNH5n2bAibGFU2T2OV4lI+IKbJQjQESqjEjYEKTcg1
         tp/F2cdbjdtf4HoHZz9YGzjaZ5dSkcF6GQh0EWOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Klubnichkin <kitsok@yandex-team.ru>,
        Billy Tsai <billy_tsai@aspeedtech.com>,
        Joel Stanley <joel@jms.id.au>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.17 0031/1126] iio: adc: aspeed: Add divider flag to fix incorrect voltage reading.
Date:   Tue,  5 Apr 2022 09:12:58 +0200
Message-Id: <20220405070408.467175161@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Billy Tsai <billy_tsai@aspeedtech.com>

commit 571426631acf46e2999c7ecd1e9d048172969a43 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/aspeed_adc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -539,7 +539,9 @@ static int aspeed_adc_probe(struct platf
 	data->clk_scaler = devm_clk_hw_register_divider(
 		&pdev->dev, clk_name, clk_parent_name, scaler_flags,
 		data->base + ASPEED_REG_CLOCK_CONTROL, 0,
-		data->model_data->scaler_bit_width, 0, &data->clk_lock);
+		data->model_data->scaler_bit_width,
+		data->model_data->need_prescaler ? CLK_DIVIDER_ONE_BASED : 0,
+		&data->clk_lock);
 	if (IS_ERR(data->clk_scaler))
 		return PTR_ERR(data->clk_scaler);
 


