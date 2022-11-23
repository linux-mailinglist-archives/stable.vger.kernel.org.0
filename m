Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F956358DE
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbiKWKEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237033AbiKWKCd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:02:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2129E11E738
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:54:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAAA1B81EE6
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F312C433C1;
        Wed, 23 Nov 2022 09:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197281;
        bh=JKmQEgQo1fhSRWUNVLi8zL1Eml8RpI+dtrQU7jtWIkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8H7Osn8bk8Cp+4gZ5P791WkvhFTNs90m4H4xEsDQCdIpujUMGo4u9cgkVh6mkTM0
         beUOkkXUU9AoU7CR7qN8CBqfXHgiGpKtCswAhNVA8PoCc/1L/0zZD8qC28eyNQcMhA
         tS6tNR86xp2SmsdJLLzv6miGpoOTKtXjMTbq0IiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mitja Spes <mitja@lxnav.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.0 250/314] iio: pressure: ms5611: changed hardcoded SPI speed to value limited
Date:   Wed, 23 Nov 2022 09:51:35 +0100
Message-Id: <20221123084636.842505505@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Mitja Spes <mitja@lxnav.com>

commit 741cec30cc52058d1c10d415f3b98319887e4f73 upstream.

Don't hardcode the ms5611 SPI speed, limit it instead.

Signed-off-by: Mitja Spes <mitja@lxnav.com>
Fixes: c0644160a8b5 ("iio: pressure: add support for MS5611 pressure and temperature sensor")
Link: https://lore.kernel.org/r/20221021135827.1444793-3-mitja@lxnav.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/ms5611_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/pressure/ms5611_spi.c
+++ b/drivers/iio/pressure/ms5611_spi.c
@@ -91,7 +91,7 @@ static int ms5611_spi_probe(struct spi_d
 	spi_set_drvdata(spi, indio_dev);
 
 	spi->mode = SPI_MODE_0;
-	spi->max_speed_hz = 20000000;
+	spi->max_speed_hz = min(spi->max_speed_hz, 20000000U);
 	spi->bits_per_word = 8;
 	ret = spi_setup(spi);
 	if (ret < 0)


