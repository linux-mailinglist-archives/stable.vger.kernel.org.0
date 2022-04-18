Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1AF050559B
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241389AbiDRNME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241391AbiDRNHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:07:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1392AC66;
        Mon, 18 Apr 2022 05:47:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 329FE6124A;
        Mon, 18 Apr 2022 12:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406A5C385A7;
        Mon, 18 Apr 2022 12:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286053;
        bh=iPfEOOaZY6SngMtkH2EjLZFnoqkLvslAt+rH43/wWIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=psHjd+DMRGpDidX3kq8vcxoXBqXWOJ/3d1R318lG/gpl0mhoMMzgnQjQUQ67XYW64
         fPvPI/k6fwXOgTlcAHQ/lj+RI3BrH24zijjmLsozxWXGcBCTNY2qJ36Od/lCz6mzSY
         usH0T68aGZA4WVd7zEMf4riX1daFX7UOjWGzvKD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liam Beguin <liambeguin@gmail.com>,
        Peter Rosin <peda@axentia.se>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 015/284] iio: inkern: apply consumer scale on IIO_VAL_INT cases
Date:   Mon, 18 Apr 2022 14:09:56 +0200
Message-Id: <20220418121211.131642179@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liam Beguin <liambeguin@gmail.com>

commit 1bca97ff95c732a516ebb68da72814194980e0a5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/inkern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -612,7 +612,7 @@ static int iio_convert_raw_to_processed_
 
 	switch (scale_type) {
 	case IIO_VAL_INT:
-		*processed = raw64 * scale_val;
+		*processed = raw64 * scale_val * scale;
 		break;
 	case IIO_VAL_INT_PLUS_MICRO:
 		if (scale_val2 < 0)


