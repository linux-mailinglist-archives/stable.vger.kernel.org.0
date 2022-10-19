Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7B46041AA
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbiJSKrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbiJSKpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:45:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FE715A30E;
        Wed, 19 Oct 2022 03:21:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C759B8243A;
        Wed, 19 Oct 2022 08:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7C1C433D6;
        Wed, 19 Oct 2022 08:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169922;
        bh=42i1W62ybqHhLkB5AsmTWMLUg+3p/yCokCwXsmtb4sE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJeYFNO6F3tabxFfDvX7DoGqbKE5GIxESn3PqEk78VOaoCveDW8eAyA4+OSiZ3YVn
         TTA9dvBGfPS9pwLpl7Ua4sZDliRiIfZY9ZYp605lDoZo3xXNZB+D1ZpZk5mKzYDBuS
         q7lb7LxGe3yNmB+pBZeEUYehDlwD4f/3E4RU42ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 460/862] iio: adc: at91-sama5d2_adc: disable/prepare buffer on suspend/resume
Date:   Wed, 19 Oct 2022 10:29:07 +0200
Message-Id: <20221019083310.321198621@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 808175e21d9b7f866eda742e8970f27b78afe5db ]

In case triggered buffers are enabled while system is suspended they will
not work anymore after resume. For this call at91_adc_buffer_postdisable()
on suspend and at91_adc_buffer_prepare() on resume. On tests it has been
seen that at91_adc_buffer_postdisable() call is not necessary but it has
been kept because it also does the book keeping for DMA. On resume path
there is no need to call at91_adc_configure_touch() as it is embedded in
at91_adc_buffer_prepare().

Fixes: 073c662017f2f ("iio: adc: at91-sama5d2_adc: add support for DMA")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220803102855.2191070-5-claudiu.beznea@microchip.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/at91-sama5d2_adc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/adc/at91-sama5d2_adc.c b/drivers/iio/adc/at91-sama5d2_adc.c
index 3734ddc82952..e2c82c5a2fac 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -2116,6 +2116,9 @@ static int at91_adc_suspend(struct device *dev)
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	struct at91_adc_state *st = iio_priv(indio_dev);
 
+	if (iio_buffer_enabled(indio_dev))
+		at91_adc_buffer_postdisable(indio_dev);
+
 	/*
 	 * Do a sofware reset of the ADC before we go to suspend.
 	 * this will ensure that all pins are free from being muxed by the ADC
@@ -2159,14 +2162,11 @@ static int at91_adc_resume(struct device *dev)
 	if (!iio_buffer_enabled(indio_dev))
 		return 0;
 
-	/* check if we are enabling triggered buffer or the touchscreen */
-	if (at91_adc_current_chan_is_touch(indio_dev))
-		return at91_adc_configure_touch(st, true);
-	else
-		return at91_adc_configure_trigger(st->trig, true);
+	ret = at91_adc_buffer_prepare(indio_dev);
+	if (ret)
+		goto vref_disable_resume;
 
-	/* not needed but more explicit */
-	return 0;
+	return at91_adc_configure_trigger(st->trig, true);
 
 vref_disable_resume:
 	regulator_disable(st->vref);
-- 
2.35.1



