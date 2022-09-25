Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610B95E9154
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 09:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiIYHM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 03:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiIYHMZ (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 25 Sep 2022 03:12:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FEC3885
        for <Stable@vger.kernel.org>; Sun, 25 Sep 2022 00:12:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56B7AB80C03
        for <Stable@vger.kernel.org>; Sun, 25 Sep 2022 07:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE277C433D6;
        Sun, 25 Sep 2022 07:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664089941;
        bh=D5pMlcAyb8Fn1ZPzFN7E0ZUS9Zac2LD53BcgJWyw04c=;
        h=Subject:To:From:Date:From;
        b=DbnuMNGlTe/q06FX3n2NGwOSAI0uskNNn+O8Z88m9R6lYL3UE8m+ws8byqOU2bQmY
         SkcMQF/m6/4KRhclGNM6W4oQGeJUNurhU0fASe21JUQ0CuY4KOB8coB5UwIIBZ12gU
         tdx+K1pQeXvmJD3QB/OE0xkop8FPM4bdOxrmEbik=
Subject: patch "iio: ltc2497: Fix reading conversion results" added to char-misc-testing
To:     u.kleine-koenig@pengutronix.de, Jonathan.Cameron@huawei.com,
        Meng.Li@windriver.com, Stable@vger.kernel.org, dzagorui@cisco.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 25 Sep 2022 09:10:01 +0200
Message-ID: <166408980133238@kroah.com>
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


This is a note to let you know that I've just added the patch titled

    iio: ltc2497: Fix reading conversion results

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 7f4f1096d5921f5d90547596f9ce80e0b924f887 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Date: Mon, 15 Aug 2022 09:16:47 +0000
Subject: iio: ltc2497: Fix reading conversion results
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

After the result of the previous conversion is read the chip
automatically starts a new conversion and doesn't accept new i2c
transfers until this conversion is completed which makes the function
return failure.

So add an early return iff the programming of the new address isn't
needed. Note this will not fix the problem in general, but all cases
that are currently used. Once this changes we get the failure back, but
this can be addressed when the need arises.

Fixes: 69548b7c2c4f ("iio: adc: ltc2497: split protocol independent part in a separate module ")
Reported-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Tested-by: Denys Zagorui <dzagorui@cisco.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220815091647.1523532-1-dzagorui@cisco.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ltc2497.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/iio/adc/ltc2497.c b/drivers/iio/adc/ltc2497.c
index f7c786f37ceb..78b93c99cc47 100644
--- a/drivers/iio/adc/ltc2497.c
+++ b/drivers/iio/adc/ltc2497.c
@@ -41,6 +41,19 @@ static int ltc2497_result_and_measure(struct ltc2497core_driverdata *ddata,
 		}
 
 		*val = (be32_to_cpu(st->buf) >> 14) - (1 << 17);
+
+		/*
+		 * The part started a new conversion at the end of the above i2c
+		 * transfer, so if the address didn't change since the last call
+		 * everything is fine and we can return early.
+		 * If not (which should only happen when some sort of bulk
+		 * conversion is implemented) we have to program the new
+		 * address. Note that this probably fails as the conversion that
+		 * was triggered above is like not complete yet and the two
+		 * operations have to be done in a single transfer.
+		 */
+		if (ddata->addr_prev == address)
+			return 0;
 	}
 
 	ret = i2c_smbus_write_byte(st->client,
-- 
2.37.3


