Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F90A63557B
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237364AbiKWJTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237202AbiKWJSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:18:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2009662D9
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:18:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B090661B4D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B227FC433C1;
        Wed, 23 Nov 2022 09:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195095;
        bh=bJLK9TtYJJiId5Bdeizaj6OdGcT549OyB9vacAEBJIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7Vu8+UGiPVgsFszTmM5wDsjiOWHxy1lJwM2hBAiwZcJ8hV6e+CIMpr7LOB2g3AOK
         ezTuhzd01Oy2JOzdHa5Q/MNn+KwDy0/91PS1ESYhJiQRhTx/IL7xG2lL90NT47Cb/B
         hKGR+dG3AjlZlVxgXt7/SnMcOoLPbQoZMlnGEB3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mitja Spes <mitja@lxnav.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 128/156] iio: pressure: ms5611: changed hardcoded SPI speed to value limited
Date:   Wed, 23 Nov 2022 09:51:25 +0100
Message-Id: <20221123084602.558477496@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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
@@ -92,7 +92,7 @@ static int ms5611_spi_probe(struct spi_d
 	spi_set_drvdata(spi, indio_dev);
 
 	spi->mode = SPI_MODE_0;
-	spi->max_speed_hz = 20000000;
+	spi->max_speed_hz = min(spi->max_speed_hz, 20000000U);
 	spi->bits_per_word = 8;
 	ret = spi_setup(spi);
 	if (ret < 0)


