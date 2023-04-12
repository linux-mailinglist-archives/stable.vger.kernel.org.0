Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCFD6DEE97
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbjDLInJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjDLIm5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:42:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EFB72AA
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:42:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29B396308B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5A5C433D2;
        Wed, 12 Apr 2023 08:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288940;
        bh=x56azieUZ+uRlKvWVAU8DC9DUcZVkTo6qiVvuz0bVs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jV+QJdl8EyJvHIha87kiVs9Qurq2oVJgQKg1XZlBowAo9KAnjNbEQeef9q0ea0cRv
         Kf+OCDWSLJxz6dkDPNZhanbP+Ld8+RMRanmOzBlPOegMK816eolJSYKmN5dT2O0EhT
         oqgWsgExtTBdBIBk3hHu54HUf/XkV+52nDZ12Q+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lars-Peter Clausen <lars@metafoo.de>,
        David Lechner <david@lechnology.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 074/164] iio: adc: ti-ads7950: Set `can_sleep` flag for GPIO chip
Date:   Wed, 12 Apr 2023 10:33:16 +0200
Message-Id: <20230412082839.899327433@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

commit 363c7dc72f79edd55bf1c4380e0fbf7f1bbc2c86 upstream.

The ads7950 uses a mutex as well as SPI transfers in its GPIO callbacks.
This means these callbacks can sleep and the `can_sleep` flag should be
set.

Having the flag set will make sure that warnings are generated when calling
any of the callbacks from a potentially non-sleeping context.

Fixes: c97dce792dc8 ("iio: adc: ti-ads7950: add GPIO support")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: David Lechner <david@lechnology.com>
Link: https://lore.kernel.org/r/20230312210933.2275376-1-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads7950.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/ti-ads7950.c
+++ b/drivers/iio/adc/ti-ads7950.c
@@ -634,6 +634,7 @@ static int ti_ads7950_probe(struct spi_d
 	st->chip.label = dev_name(&st->spi->dev);
 	st->chip.parent = &st->spi->dev;
 	st->chip.owner = THIS_MODULE;
+	st->chip.can_sleep = true;
 	st->chip.base = -1;
 	st->chip.ngpio = TI_ADS7950_NUM_GPIOS;
 	st->chip.get_direction = ti_ads7950_get_direction;


