Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5741C621561
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbiKHOL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235222AbiKHOLN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:11:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E62862C6
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:10:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90AE06157D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C55C433D6;
        Tue,  8 Nov 2022 14:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916659;
        bh=SfO4Iv7uKZ8ittWyBlBjvLzRxOw671/UV8nTeBXcgIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUyW0qeE/I9uDMJ8tmRrFU7HgiR4Tjf9KJL90lYWbsRgRoHDOpQnUDV7XvoD9MT4/
         Pl1RU1TyCSNrhFc6zr3/2oigN2u2B1LsJINJTFxocwvXQAo5hCZsceBWEDynjZ7JV9
         yHGq0F2YTHeWL6ySmQlDiQO2EBdDBpdwCK6YuCNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 063/197] iio: adc: stm32-adc: fix channel sampling time init
Date:   Tue,  8 Nov 2022 14:38:21 +0100
Message-Id: <20221108133357.707820078@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@foss.st.com>

[ Upstream commit 174dac5dc800e4e2e4552baf6340846a344d01a3 ]

Fix channel init for ADC generic channel bindings.
In generic channel initialization, stm32_adc_smpr_init() is called to
initialize channel sampling time. The "st,min-sample-time-ns" property
is an optional property. If it is not defined, stm32_adc_smpr_init() is
currently skipped.
However stm32_adc_smpr_init() must always be called, to force a minimum
sampling time for the internal channels, as the minimum sampling time is
known. Make stm32_adc_smpr_init() call unconditional.

Fixes: 796e5d0b1e9b ("iio: adc: stm32-adc: use generic binding for sample-time")
Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20221012142205.13041-2-olivier.moysan@foss.st.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stm32-adc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index 130e8dd6f0c8..7719f7f93c3f 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -2064,18 +2064,19 @@ static int stm32_adc_generic_chan_init(struct iio_dev *indio_dev,
 		stm32_adc_chan_init_one(indio_dev, &channels[scan_index], val,
 					vin[1], scan_index, differential);
 
+		val = 0;
 		ret = of_property_read_u32(child, "st,min-sample-time-ns", &val);
 		/* st,min-sample-time-ns is optional */
-		if (!ret) {
-			stm32_adc_smpr_init(adc, channels[scan_index].channel, val);
-			if (differential)
-				stm32_adc_smpr_init(adc, vin[1], val);
-		} else if (ret != -EINVAL) {
+		if (ret && ret != -EINVAL) {
 			dev_err(&indio_dev->dev, "Invalid st,min-sample-time-ns property %d\n",
 				ret);
 			goto err;
 		}
 
+		stm32_adc_smpr_init(adc, channels[scan_index].channel, val);
+		if (differential)
+			stm32_adc_smpr_init(adc, vin[1], val);
+
 		scan_index++;
 	}
 
-- 
2.35.1



