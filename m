Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5181C4DD956
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 13:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbiCRMCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 08:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235903AbiCRMCc (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 18 Mar 2022 08:02:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021412D4D4D
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 05:01:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91E73614CB
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 12:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5D5C340E8;
        Fri, 18 Mar 2022 12:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647604873;
        bh=vs+nKSBt4Y0OjQ5xf5Ymp2ul9WJq4AGCFcjnoe5kwsk=;
        h=Subject:To:From:Date:From;
        b=fCMLUNdc5GkZBWVTdQazQzAeL5PTx85MnBfhEE+jTfeKlrg0zywPgyhRQbl8yEZlI
         aSJY3tkuzuIPymGsKdOaL/MU/OxYSR0nw/06C9Su83uc1dlm4BSD0dqz54TURyx5g6
         wAea5TaUdKrqJiGGnNA7aR5lUgsEPk58bQ0JmlRc=
Subject: patch "iio: inkern: apply consumer scale on IIO_VAL_INT cases" added to char-misc-next
To:     liambeguin@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com, peda@axentia.se
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Mar 2022 12:45:22 +0100
Message-ID: <164760392215675@kroah.com>
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

    iio: inkern: apply consumer scale on IIO_VAL_INT cases

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 1bca97ff95c732a516ebb68da72814194980e0a5 Mon Sep 17 00:00:00 2001
From: Liam Beguin <liambeguin@gmail.com>
Date: Sat, 8 Jan 2022 15:53:04 -0500
Subject: iio: inkern: apply consumer scale on IIO_VAL_INT cases

When a consumer calls iio_read_channel_processed() and the channel has
an integer scale, the scale channel scale is applied and the processed
value is returned as expected.

On the other hand, if the consumer calls iio_convert_raw_to_processed()
the scaling factor requested by the consumer is not applied.

This for example causes the consumer to process mV when expecting uV.
Make sure to always apply the scaling factor requested by the consumer.

Fixes: 48e44ce0f881 ("iio:inkern: Add function to read the processed value")
Signed-off-by: Liam Beguin <liambeguin@gmail.com>
Reviewed-by: Peter Rosin <peda@axentia.se>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220108205319.2046348-2-liambeguin@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/inkern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 0222885b334c..021e1397ffc5 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -616,7 +616,7 @@ static int iio_convert_raw_to_processed_unlocked(struct iio_channel *chan,
 
 	switch (scale_type) {
 	case IIO_VAL_INT:
-		*processed = raw64 * scale_val;
+		*processed = raw64 * scale_val * scale;
 		break;
 	case IIO_VAL_INT_PLUS_MICRO:
 		if (scale_val2 < 0)
-- 
2.35.1


