Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E71500E92
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243807AbiDNNTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243851AbiDNNSa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:18:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0097190CDC;
        Thu, 14 Apr 2022 06:15:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0FB2B82981;
        Thu, 14 Apr 2022 13:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F86AC385A5;
        Thu, 14 Apr 2022 13:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942141;
        bh=lFCP5nzLeSmkOcqS5XILgFyL0/GQwVTVtYdNABHyz08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLtSbKPrc6vUcIfQ1T5tIEZyFl5E55HIEssTgKnSXRSZTplFIC8fZmstBTQhqRRgO
         41ViKN3xSUHNqOreboCJcs0fz16EjlKHoTs+wWriDRz3yG1wCK7l/qTI2FPyhZE5lI
         XVn9+5J3YpFv2NTE9FxJFVtL6G2vytr/yf+byUMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liam Beguin <liambeguin@gmail.com>,
        Peter Rosin <peda@axentia.se>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 022/338] iio: inkern: make a best effort on offset calculation
Date:   Thu, 14 Apr 2022 15:08:45 +0200
Message-Id: <20220414110839.523346440@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liam Beguin <liambeguin@gmail.com>

commit ca85123354e1a65a22170286387b4791997fe864 upstream.

iio_convert_raw_to_processed_unlocked() assumes the offset is an
integer. Make a best effort to get a valid offset value for fractional
cases without breaking implicit truncations.

Fixes: 48e44ce0f881 ("iio:inkern: Add function to read the processed value")
Signed-off-by: Liam Beguin <liambeguin@gmail.com>
Reviewed-by: Peter Rosin <peda@axentia.se>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220108205319.2046348-4-liambeguin@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/inkern.c |   32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -591,13 +591,35 @@ EXPORT_SYMBOL_GPL(iio_read_channel_avera
 static int iio_convert_raw_to_processed_unlocked(struct iio_channel *chan,
 	int raw, int *processed, unsigned int scale)
 {
-	int scale_type, scale_val, scale_val2, offset;
+	int scale_type, scale_val, scale_val2;
+	int offset_type, offset_val, offset_val2;
 	s64 raw64 = raw;
-	int ret;
 
-	ret = iio_channel_read(chan, &offset, NULL, IIO_CHAN_INFO_OFFSET);
-	if (ret >= 0)
-		raw64 += offset;
+	offset_type = iio_channel_read(chan, &offset_val, &offset_val2,
+				       IIO_CHAN_INFO_OFFSET);
+	if (offset_type >= 0) {
+		switch (offset_type) {
+		case IIO_VAL_INT:
+			break;
+		case IIO_VAL_INT_PLUS_MICRO:
+		case IIO_VAL_INT_PLUS_NANO:
+			/*
+			 * Both IIO_VAL_INT_PLUS_MICRO and IIO_VAL_INT_PLUS_NANO
+			 * implicitely truncate the offset to it's integer form.
+			 */
+			break;
+		case IIO_VAL_FRACTIONAL:
+			offset_val /= offset_val2;
+			break;
+		case IIO_VAL_FRACTIONAL_LOG2:
+			offset_val >>= offset_val2;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		raw64 += offset_val;
+	}
 
 	scale_type = iio_channel_read(chan, &scale_val, &scale_val2,
 					IIO_CHAN_INFO_SCALE);


