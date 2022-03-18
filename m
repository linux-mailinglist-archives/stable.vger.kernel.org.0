Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4F24DD95B
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 13:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbiCRMDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 08:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236034AbiCRMCx (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 18 Mar 2022 08:02:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B7E2D4D4F
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 05:01:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31561B82199
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 12:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EB7C340E8;
        Fri, 18 Mar 2022 12:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647604893;
        bh=Mzv80Ryk8V+ViDseYjUe5NM617Iwr/TnxyfUXXbkdIw=;
        h=Subject:To:From:Date:From;
        b=rwc46tMUKASkd52JT2SkTxy23yEjlBBoGIZNGaOadXW3qiXCT68tSA8LZmcbg2ia7
         IFb5goinFQrtTv+KYK+HAy7BAJmQWN8DYjxYEJ+/8VKP/JPldglxYB5b/7szNSTT2i
         XvzzsJB98qvQV7ZzMWe6Uu6NHeu2lEAHh5pqeD7U=
Subject: patch "iio: afe: rescale: use s64 for temporary scale calculations" added to char-misc-next
To:     liambeguin@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com, peda@axentia.se
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Mar 2022 12:45:24 +0100
Message-ID: <1647603924233194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: afe: rescale: use s64 for temporary scale calculations

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 51593106b608ae4247cc8da928813347da16d025 Mon Sep 17 00:00:00 2001
From: Liam Beguin <liambeguin@gmail.com>
Date: Sat, 8 Jan 2022 15:53:07 -0500
Subject: iio: afe: rescale: use s64 for temporary scale calculations

All four scaling coefficients can take signed values.
Make tmp a signed 64-bit integer and switch to div_s64() to preserve
signs during 64-bit divisions.

Fixes: 8b74816b5a9a ("iio: afe: rescale: new driver")
Signed-off-by: Liam Beguin <liambeguin@gmail.com>
Reviewed-by: Peter Rosin <peda@axentia.se>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220108205319.2046348-5-liambeguin@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/afe/iio-rescale.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/afe/iio-rescale.c b/drivers/iio/afe/iio-rescale.c
index 774eb3044edd..271d73e420c4 100644
--- a/drivers/iio/afe/iio-rescale.c
+++ b/drivers/iio/afe/iio-rescale.c
@@ -39,7 +39,7 @@ static int rescale_read_raw(struct iio_dev *indio_dev,
 			    int *val, int *val2, long mask)
 {
 	struct rescale *rescale = iio_priv(indio_dev);
-	unsigned long long tmp;
+	s64 tmp;
 	int ret;
 
 	switch (mask) {
@@ -77,10 +77,10 @@ static int rescale_read_raw(struct iio_dev *indio_dev,
 			*val2 = rescale->denominator;
 			return IIO_VAL_FRACTIONAL;
 		case IIO_VAL_FRACTIONAL_LOG2:
-			tmp = *val * 1000000000LL;
-			do_div(tmp, rescale->denominator);
+			tmp = (s64)*val * 1000000000LL;
+			tmp = div_s64(tmp, rescale->denominator);
 			tmp *= rescale->numerator;
-			do_div(tmp, 1000000000LL);
+			tmp = div_s64(tmp, 1000000000LL);
 			*val = tmp;
 			return ret;
 		default:
-- 
2.35.1


