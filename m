Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51615E9159
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 09:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiIYHO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 03:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIYHO5 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 25 Sep 2022 03:14:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E686193F4
        for <Stable@vger.kernel.org>; Sun, 25 Sep 2022 00:14:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32979B80DBA
        for <Stable@vger.kernel.org>; Sun, 25 Sep 2022 07:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D929C433D6;
        Sun, 25 Sep 2022 07:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664090093;
        bh=uH+3h0CKNB6JV0QRQbK9qGuekidccqd7iMMZzYJ6E+o=;
        h=Subject:To:From:Date:From;
        b=EAINwpx69+h+sX8nIVzJVAX3u6ChRn7DkvNBQyGbGkc3pgn7/zl0pQ4Fz109z8EVR
         kuJSKJ0MuXbLvbd4fre6KpLv5CfV4YomhxVAa0Z2najgiNTu+ndxnL4LmuV3Z+3Uvr
         Tg4Mch63n8LDObMQ5w3WcQliFRZ7Vhclfzvro6kM=
Subject: patch "iio: ltc2497: Fix reading conversion results" added to char-misc-next
To:     u.kleine-koenig@pengutronix.de, Jonathan.Cameron@huawei.com,
        Meng.Li@windriver.com, Stable@vger.kernel.org, dzagorui@cisco.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 25 Sep 2022 09:10:52 +0200
Message-ID: <166408985296249@kroah.com>
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
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


