Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9524C7599
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbiB1Rzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239466AbiB1RxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:53:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399D4A9967;
        Mon, 28 Feb 2022 09:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AEDFB815C6;
        Mon, 28 Feb 2022 17:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE15C340E7;
        Mon, 28 Feb 2022 17:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070019;
        bh=b15eEKyFsvxhv7wzv4TWKHP+1e+cw/Eu+//k6NfN7gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHT0w71+FwAHq9BCLDFr64Oq0kL1ZZIzAcwIw8GR4FFdQqpZ9vrbRxc2rt5guFCu/
         rJ2XwoPCk+SD0oQT++f8th48uTepHois5nFBZjL/PjNxmSyU9P8IlrTGC9J6H7olxs
         ao6KimFVkopMHJp/w9rVqqIl0/r7ALRZ+wJDHvoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 097/139] iio: adc: men_z188_adc: Fix a resource leak in an error handling path
Date:   Mon, 28 Feb 2022 18:24:31 +0100
Message-Id: <20220228172357.817243246@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit e0a2e37f303828d030a83f33ffe14b36cb88d563 upstream.

If iio_device_register() fails, a previous ioremap() is left unbalanced.

Update the error handling path and add the missing iounmap() call, as
already done in the remove function.

Fixes: 74aeac4da66f ("iio: adc: Add MEN 16z188 ADC driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/320fc777863880247c2aff4a9d1a54ba69abf080.1643445149.git.christophe.jaillet@wanadoo.fr
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/men_z188_adc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/men_z188_adc.c
+++ b/drivers/iio/adc/men_z188_adc.c
@@ -103,6 +103,7 @@ static int men_z188_probe(struct mcb_dev
 	struct z188_adc *adc;
 	struct iio_dev *indio_dev;
 	struct resource *mem;
+	int ret;
 
 	indio_dev = devm_iio_device_alloc(&dev->dev, sizeof(struct z188_adc));
 	if (!indio_dev)
@@ -128,8 +129,14 @@ static int men_z188_probe(struct mcb_dev
 	adc->mem = mem;
 	mcb_set_drvdata(dev, indio_dev);
 
-	return iio_device_register(indio_dev);
+	ret = iio_device_register(indio_dev);
+	if (ret)
+		goto err_unmap;
 
+	return 0;
+
+err_unmap:
+	iounmap(adc->base);
 err:
 	mcb_release_mem(mem);
 	return -ENXIO;


