Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF68E505498
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241445AbiDRNQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241457AbiDRNH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:07:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200402AE29;
        Mon, 18 Apr 2022 05:47:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3419161253;
        Mon, 18 Apr 2022 12:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BCCC385A1;
        Mon, 18 Apr 2022 12:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286056;
        bh=7kX7CnvluiWbJU3rkOnN9B/tJ1K7lAW9rQihbi123BI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dz8W+l8AD3iJmvHm2wxnROmgzhrp5J1GXtUochxruuYfnKOUk2Ka+bbLDABqfWTLY
         sMTfl/JuLnbl3hIrnYjww1rTlfPWnNMYsSO9l42FnAKuAwxJVHsLVybJurwppDoJlF
         nWdXYUvfa7EREr6h5iutTdxxCoBIh8hNPvfcU34U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liam Beguin <liambeguin@gmail.com>,
        Peter Rosin <peda@axentia.se>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 016/284] iio: inkern: apply consumer scale when no channel scale is available
Date:   Mon, 18 Apr 2022 14:09:57 +0200
Message-Id: <20220418121211.159619760@linuxfoundation.org>
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

commit 14b457fdde38de594a4bc4bd9075019319d978da upstream.

When a consumer calls iio_read_channel_processed() and no channel scale
is available, it's assumed that the scale is one and the raw value is
returned as expected.

On the other hand, if the consumer calls iio_convert_raw_to_processed()
the scaling factor requested by the consumer is not applied.

This for example causes the consumer to process mV when expecting uV.
Make sure to always apply the scaling factor requested by the consumer.

Fixes: adc8ec5ff183 ("iio: inkern: pass through raw values if no scaling")
Signed-off-by: Liam Beguin <liambeguin@gmail.com>
Reviewed-by: Peter Rosin <peda@axentia.se>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220108205319.2046348-3-liambeguin@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/inkern.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -603,10 +603,10 @@ static int iio_convert_raw_to_processed_
 					IIO_CHAN_INFO_SCALE);
 	if (scale_type < 0) {
 		/*
-		 * Just pass raw values as processed if no scaling is
-		 * available.
+		 * If no channel scaling is available apply consumer scale to
+		 * raw value and return.
 		 */
-		*processed = raw;
+		*processed = raw * scale;
 		return 0;
 	}
 


