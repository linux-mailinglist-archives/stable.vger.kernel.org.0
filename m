Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3117055D638
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238757AbiF0Ly3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238308AbiF0Lvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:51:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3465565EA;
        Mon, 27 Jun 2022 04:44:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9A2A60DF7;
        Mon, 27 Jun 2022 11:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CC7C3411D;
        Mon, 27 Jun 2022 11:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330283;
        bh=NpYFXr003tbfA2D33lVsxV2LZLJF1Qx54dSTcz5DN98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rm67xIsZuf4GknjWjg5Xcp0YVDMJkdCtdC6cy8OWZxkSy6cFA7HPZ3DZ/1mq35ECy
         c5WbQ2oOHM06vspH1SW+BAeJCH2O4h0uyKjrLodXqPnL++SK0e1FqWgRQJegxZgxqA
         BGGLvVx9QB/OeXxOKtanhIDBU8dD1pTaEMN1l4uA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.18 146/181] iio: adc: stm32: fix vrefint wrong calibration value handling
Date:   Mon, 27 Jun 2022 13:21:59 +0200
Message-Id: <20220627111948.919222363@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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

From: Olivier Moysan <olivier.moysan@foss.st.com>

commit bc05f30fc24705cd023f38659303376eaa5767df upstream.

If the vrefint calibration is zero, the vrefint channel output value
cannot be computed. Currently, in such case, the raw conversion value
is returned, which is not relevant.
Do not expose the vrefint channel when the output value cannot be
computed, instead.

Fixes: 0e346b2cfa85 ("iio: adc: stm32-adc: add vrefint calibration support")
Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20220609095856.376961-1-olivier.moysan@foss.st.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/stm32-adc.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index 8c5f05f593ab..11ef873d6453 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -1365,7 +1365,7 @@ static int stm32_adc_read_raw(struct iio_dev *indio_dev,
 		else
 			ret = -EINVAL;
 
-		if (mask == IIO_CHAN_INFO_PROCESSED && adc->vrefint.vrefint_cal)
+		if (mask == IIO_CHAN_INFO_PROCESSED)
 			*val = STM32_ADC_VREFINT_VOLTAGE * adc->vrefint.vrefint_cal / *val;
 
 		iio_device_release_direct_mode(indio_dev);
@@ -1969,10 +1969,10 @@ static int stm32_adc_populate_int_ch(struct iio_dev *indio_dev, const char *ch_n
 
 	for (i = 0; i < STM32_ADC_INT_CH_NB; i++) {
 		if (!strncmp(stm32_adc_ic[i].name, ch_name, STM32_ADC_CH_SZ)) {
-			adc->int_ch[i] = chan;
-
-			if (stm32_adc_ic[i].idx != STM32_ADC_INT_CH_VREFINT)
-				continue;
+			if (stm32_adc_ic[i].idx != STM32_ADC_INT_CH_VREFINT) {
+				adc->int_ch[i] = chan;
+				break;
+			}
 
 			/* Get calibration data for vrefint channel */
 			ret = nvmem_cell_read_u16(&indio_dev->dev, "vrefint", &vrefint);
@@ -1980,10 +1980,15 @@ static int stm32_adc_populate_int_ch(struct iio_dev *indio_dev, const char *ch_n
 				return dev_err_probe(indio_dev->dev.parent, ret,
 						     "nvmem access error\n");
 			}
-			if (ret == -ENOENT)
-				dev_dbg(&indio_dev->dev, "vrefint calibration not found\n");
-			else
-				adc->vrefint.vrefint_cal = vrefint;
+			if (ret == -ENOENT) {
+				dev_dbg(&indio_dev->dev, "vrefint calibration not found. Skip vrefint channel\n");
+				return ret;
+			} else if (!vrefint) {
+				dev_dbg(&indio_dev->dev, "Null vrefint calibration value. Skip vrefint channel\n");
+				return -ENOENT;
+			}
+			adc->int_ch[i] = chan;
+			adc->vrefint.vrefint_cal = vrefint;
 		}
 	}
 
@@ -2020,7 +2025,9 @@ static int stm32_adc_generic_chan_init(struct iio_dev *indio_dev,
 			}
 			strncpy(adc->chan_name[val], name, STM32_ADC_CH_SZ);
 			ret = stm32_adc_populate_int_ch(indio_dev, name, val);
-			if (ret)
+			if (ret == -ENOENT)
+				continue;
+			else if (ret)
 				goto err;
 		} else if (ret != -EINVAL) {
 			dev_err(&indio_dev->dev, "Invalid label %d\n", ret);
-- 
2.36.1



