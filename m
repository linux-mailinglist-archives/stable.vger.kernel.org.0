Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AA2609497
	for <lists+stable@lfdr.de>; Sun, 23 Oct 2022 18:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiJWQGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Oct 2022 12:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiJWQGt (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 23 Oct 2022 12:06:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07896C779
        for <Stable@vger.kernel.org>; Sun, 23 Oct 2022 09:06:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32C84B80D5C
        for <Stable@vger.kernel.org>; Sun, 23 Oct 2022 16:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8D4C433D6;
        Sun, 23 Oct 2022 16:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666541205;
        bh=ipsLOjis/yREj3evqVuNqCRVRwU7yjCY9m6QqfGkgX4=;
        h=Subject:To:From:Date:From;
        b=0oXOh2NiRF9fyO0BhRXpZKdV84+0ZpqFsDbIG3IVaGPGHzZ5awrC5nzY+He8Xqk2d
         tjKgAkCtRK5JpTMxsjZHqlwq6IGfxNP50dU4h0jVrefN8iNR7535fqgZ9VAg3Z/lT0
         tdpn0zJ64yTjhCEGdp/gD+iGuW/oyaYMgyB8ueF4=
Subject: patch "iio: temperature: ltc2983: allocate iio channels once" added to char-misc-linus
To:     cosmin.tanislav@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Oct 2022 18:06:25 +0200
Message-ID: <16665411851121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: temperature: ltc2983: allocate iio channels once

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4132f19173211856d35180958d2754f5c56d520a Mon Sep 17 00:00:00 2001
From: Cosmin Tanislav <cosmin.tanislav@analog.com>
Date: Fri, 14 Oct 2022 15:37:22 +0300
Subject: iio: temperature: ltc2983: allocate iio channels once

Currently, every time the device wakes up from sleep, the
iio_chan array is reallocated, leaking the previous one
until the device is removed (basically never).

Move the allocation to the probe function to avoid this.

Signed-off-by: Cosmin Tanislav <cosmin.tanislav@analog.com>
Fixes: f110f3188e563 ("iio: temperature: Add support for LTC2983")
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221014123724.1401011-2-demonsingur@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/temperature/ltc2983.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/temperature/ltc2983.c b/drivers/iio/temperature/ltc2983.c
index b652d2b39bcf..a60ccf183687 100644
--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -1385,13 +1385,6 @@ static int ltc2983_setup(struct ltc2983_data *st, bool assign_iio)
 		return ret;
 	}
 
-	st->iio_chan = devm_kzalloc(&st->spi->dev,
-				    st->iio_channels * sizeof(*st->iio_chan),
-				    GFP_KERNEL);
-
-	if (!st->iio_chan)
-		return -ENOMEM;
-
 	ret = regmap_update_bits(st->regmap, LTC2983_GLOBAL_CONFIG_REG,
 				 LTC2983_NOTCH_FREQ_MASK,
 				 LTC2983_NOTCH_FREQ(st->filter_notch_freq));
@@ -1514,6 +1507,12 @@ static int ltc2983_probe(struct spi_device *spi)
 		gpiod_set_value_cansleep(gpio, 0);
 	}
 
+	st->iio_chan = devm_kzalloc(&spi->dev,
+				    st->iio_channels * sizeof(*st->iio_chan),
+				    GFP_KERNEL);
+	if (!st->iio_chan)
+		return -ENOMEM;
+
 	ret = ltc2983_setup(st, true);
 	if (ret)
 		return ret;
-- 
2.38.1


