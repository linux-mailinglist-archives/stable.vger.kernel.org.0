Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4772F61D966
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 11:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiKEKdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Nov 2022 06:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKEKdN (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sat, 5 Nov 2022 06:33:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DB022B
        for <Stable@vger.kernel.org>; Sat,  5 Nov 2022 03:33:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 904BEB8164F
        for <Stable@vger.kernel.org>; Sat,  5 Nov 2022 10:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DD3C433C1;
        Sat,  5 Nov 2022 10:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667644390;
        bh=tkozvjMih89DPy0ghXE0RynqHLX8E8J6C79qKgBUul4=;
        h=Subject:To:From:Date:From;
        b=kZl1U2GuDsp/oaa+3nqnJzheiYc1WEf1zJfN3tRSDw+ENoVUgswZ4FSoizi4hVhHU
         eC6XUt6mXl16UEABX6rRs0i5kwsQfn0Lh0QUfXXWIyw4uoiuxCnON759gNy2O6zGej
         soW7m8dhaksBuyAUIl4ODL4kfjSL2LsUa3beMuZ0=
Subject: patch "iio: pressure: ms5611: changed hardcoded SPI speed to value limited" added to char-misc-linus
To:     mitja@lxnav.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Nov 2022 11:33:00 +0100
Message-ID: <1667644380124117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: pressure: ms5611: changed hardcoded SPI speed to value limited

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 741cec30cc52058d1c10d415f3b98319887e4f73 Mon Sep 17 00:00:00 2001
From: Mitja Spes <mitja@lxnav.com>
Date: Fri, 21 Oct 2022 15:58:21 +0200
Subject: iio: pressure: ms5611: changed hardcoded SPI speed to value limited

Don't hardcode the ms5611 SPI speed, limit it instead.

Signed-off-by: Mitja Spes <mitja@lxnav.com>
Fixes: c0644160a8b5 ("iio: pressure: add support for MS5611 pressure and temperature sensor")
Link: https://lore.kernel.org/r/20221021135827.1444793-3-mitja@lxnav.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/pressure/ms5611_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/pressure/ms5611_spi.c b/drivers/iio/pressure/ms5611_spi.c
index 432e912096f4..a0a7205c9c3a 100644
--- a/drivers/iio/pressure/ms5611_spi.c
+++ b/drivers/iio/pressure/ms5611_spi.c
@@ -91,7 +91,7 @@ static int ms5611_spi_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, indio_dev);
 
 	spi->mode = SPI_MODE_0;
-	spi->max_speed_hz = 20000000;
+	spi->max_speed_hz = min(spi->max_speed_hz, 20000000U);
 	spi->bits_per_word = 8;
 	ret = spi_setup(spi);
 	if (ret < 0)
-- 
2.38.1


