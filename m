Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB636CBDBE
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjC1LcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjC1Lbx (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 28 Mar 2023 07:31:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9DAAB
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 04:31:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 975C3B81BDD
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 11:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFA3C433D2;
        Tue, 28 Mar 2023 11:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680003090;
        bh=rmkGMLpPHMHbGXaGCCO8yf2+25cz/sseuLcvMVONNtQ=;
        h=Subject:To:From:Date:From;
        b=NfJjCFUX0JekTUXmqM5QC9Jk6yplbxZBGdK1IjXZRavtU3b1SH0KAxahfbr+4nFL2
         qyC5q/2nAT09QCXo+LBJH80gLhLZSdbKXa/d3Qxezz5RerrnQapVs1FHvaGKF/5dGA
         mloH939Ad7m8YmxyVMizj7PLU/pYoba1eWhiwhks=
Subject: patch "drivers: iio: adc: ltc2497: fix LSB shift" added to char-misc-linus
To:     ian.ray@ge.com, Jonathan.Cameron@huawei.com, Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 13:31:24 +0200
Message-ID: <1680003084123217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    drivers: iio: adc: ltc2497: fix LSB shift

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6327a930ab7bfa1ab33bcdffd5f5f4b1e7131504 Mon Sep 17 00:00:00 2001
From: Ian Ray <ian.ray@ge.com>
Date: Fri, 27 Jan 2023 14:57:14 +0200
Subject: drivers: iio: adc: ltc2497: fix LSB shift

Correct the "sub_lsb" shift for the ltc2497 and drop the sub_lsb element
which is now constant.

An earlier version of the code shifted by 14 but this was a consequence
of reading three bytes into a __be32 buffer and using be32_to_cpu(), so
eight extra bits needed to be skipped.  Now we use get_unaligned_be24()
and thus the additional skip is wrong.

Fixes: 2187cfeb3626 ("drivers: iio: adc: ltc2497: LTC2499 support")
Signed-off-by: Ian Ray <ian.ray@ge.com>
Link: https://lore.kernel.org/r/20230127125714.44608-1-ian.ray@ge.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ltc2497.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/ltc2497.c b/drivers/iio/adc/ltc2497.c
index 17370c5eb6fe..ec198c6f13d6 100644
--- a/drivers/iio/adc/ltc2497.c
+++ b/drivers/iio/adc/ltc2497.c
@@ -28,7 +28,6 @@ struct ltc2497_driverdata {
 	struct ltc2497core_driverdata common_ddata;
 	struct i2c_client *client;
 	u32 recv_size;
-	u32 sub_lsb;
 	/*
 	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
@@ -65,10 +64,10 @@ static int ltc2497_result_and_measure(struct ltc2497core_driverdata *ddata,
 		 * equivalent to a sign extension.
 		 */
 		if (st->recv_size == 3) {
-			*val = (get_unaligned_be24(st->data.d8) >> st->sub_lsb)
+			*val = (get_unaligned_be24(st->data.d8) >> 6)
 				- BIT(ddata->chip_info->resolution + 1);
 		} else {
-			*val = (be32_to_cpu(st->data.d32) >> st->sub_lsb)
+			*val = (be32_to_cpu(st->data.d32) >> 6)
 				- BIT(ddata->chip_info->resolution + 1);
 		}
 
@@ -122,7 +121,6 @@ static int ltc2497_probe(struct i2c_client *client)
 	st->common_ddata.chip_info = chip_info;
 
 	resolution = chip_info->resolution;
-	st->sub_lsb = 31 - (resolution + 1);
 	st->recv_size = BITS_TO_BYTES(resolution) + 1;
 
 	return ltc2497core_probe(dev, indio_dev);
-- 
2.40.0


