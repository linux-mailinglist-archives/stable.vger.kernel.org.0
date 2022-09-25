Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733935E9155
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 09:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiIYHMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 03:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiIYHMu (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 25 Sep 2022 03:12:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B2C3885
        for <Stable@vger.kernel.org>; Sun, 25 Sep 2022 00:12:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DFDF60F9C
        for <Stable@vger.kernel.org>; Sun, 25 Sep 2022 07:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5B7C433C1;
        Sun, 25 Sep 2022 07:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664089968;
        bh=nCrz9nM6dG++ysO4GKCk1NKwjt/kEppyftyle+XPziM=;
        h=Subject:To:From:Date:From;
        b=xw4lrOA1jyoSZonC1GWm6jIwSUS8tvIULaU2BRm53mngo8Y3/4aTyx0ReC9+QUpkU
         iiKrUV8SR6AZxs1KLfk0jd3AVWkOK9WYJCacehxr8zkXN7esywx3qk4/3wg0GF6cgl
         AeUrhB+u1qvMJC6D6BofCsOWULuda6uFWJaje7Q8=
Subject: patch "iio: adc: ad7923: fix channel readings for some variants" added to char-misc-testing
To:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 25 Sep 2022 09:10:06 +0200
Message-ID: <1664089806186232@kroah.com>
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

    iio: adc: ad7923: fix channel readings for some variants

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From f4f43f01cff2f29779343ade755191afd2581c77 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Date: Mon, 12 Sep 2022 10:12:21 +0200
Subject: iio: adc: ad7923: fix channel readings for some variants
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Some of the supported devices have 4 or 2 LSB trailing bits that should
not be taken into account. Hence we need to shift these bits out which
fits perfectly on the scan type shift property. This change fixes both
raw and buffered reads.

Fixes: f2f7a449707e ("iio:adc:ad7923: Add support for the ad7904/ad7914/ad7924")
Fixes: 851644a60d20 ("iio: adc: ad7923: Add support for the ad7908/ad7918/ad7928")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220912081223.173584-2-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ad7923.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7923.c b/drivers/iio/adc/ad7923.c
index edad1f30121d..502253f53d96 100644
--- a/drivers/iio/adc/ad7923.c
+++ b/drivers/iio/adc/ad7923.c
@@ -93,6 +93,7 @@ enum ad7923_id {
 			.sign = 'u',					\
 			.realbits = (bits),				\
 			.storagebits = 16,				\
+			.shift = 12 - (bits),				\
 			.endianness = IIO_BE,				\
 		},							\
 	}
@@ -268,7 +269,8 @@ static int ad7923_read_raw(struct iio_dev *indio_dev,
 			return ret;
 
 		if (chan->address == EXTRACT(ret, 12, 4))
-			*val = EXTRACT(ret, 0, 12);
+			*val = EXTRACT(ret, chan->scan_type.shift,
+				       chan->scan_type.realbits);
 		else
 			return -EIO;
 
-- 
2.37.3


