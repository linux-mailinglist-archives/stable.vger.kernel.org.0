Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526E5513712
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 16:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348351AbiD1Olr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 10:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345616AbiD1Olr (ORCPT
        <rfc822;Stable@vger.kernel.org>); Thu, 28 Apr 2022 10:41:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF42F95A35
        for <Stable@vger.kernel.org>; Thu, 28 Apr 2022 07:38:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A9DEB82DA9
        for <Stable@vger.kernel.org>; Thu, 28 Apr 2022 14:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E0EC385A9;
        Thu, 28 Apr 2022 14:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651156710;
        bh=zTZuSX7nbEnXkrQ6qQ630EVazwGZhZPDNvHimxATGi0=;
        h=Subject:To:From:Date:From;
        b=B3IM6LyR0HDgqcK6u2iCdeMyH1jItYciNTtJ9Iim/53dytXothvsOgGz63JPvYtRl
         2WXLu33HWyvOoAjiRiOxohq1kudYSExRxTIHnx5bbSfAcCk+S09766Q/M7Eeeobiql
         oVrv2uBO1Ett715piSjHOO8+hJ64FTdy0Q2nlQN4=
Subject: patch "iio: dac: ad5446: Fix read_raw not returning set value" added to char-misc-linus
To:     michael.hennerich@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, nuno.sa@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 28 Apr 2022 16:37:54 +0200
Message-ID: <16511566742925@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: dac: ad5446: Fix read_raw not returning set value

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 89a01cd688d3c0ac983ef0b0e5f40018ab768317 Mon Sep 17 00:00:00 2001
From: Michael Hennerich <michael.hennerich@analog.com>
Date: Wed, 6 Apr 2022 12:56:20 +0200
Subject: iio: dac: ad5446: Fix read_raw not returning set value
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

read_raw should return the un-scaled value.

Fixes: 5e06bdfb46e8b ("staging:iio:dac:ad5446: Return cached value for 'raw' attribute")
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220406105620.1171340-1-michael.hennerich@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/dac/ad5446.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad5446.c b/drivers/iio/dac/ad5446.c
index 14cfabacbea5..fdf824041497 100644
--- a/drivers/iio/dac/ad5446.c
+++ b/drivers/iio/dac/ad5446.c
@@ -178,7 +178,7 @@ static int ad5446_read_raw(struct iio_dev *indio_dev,
 
 	switch (m) {
 	case IIO_CHAN_INFO_RAW:
-		*val = st->cached_val;
+		*val = st->cached_val >> chan->scan_type.shift;
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_SCALE:
 		*val = st->vref_mv;
-- 
2.36.0


