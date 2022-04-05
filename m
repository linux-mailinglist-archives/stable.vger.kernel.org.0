Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8D74F24F5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbiDEHnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiDEHmM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:42:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C995F91549;
        Tue,  5 Apr 2022 00:40:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 18FB8CE1BF5;
        Tue,  5 Apr 2022 07:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3C2C340EE;
        Tue,  5 Apr 2022 07:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144406;
        bh=aEb6bFctWPFgGqy+PW+9mHUKyTN0aHivpB5iy1Ji954=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DMIewlRHCkbioRXs6SCiK6CvR3gCELRCb0o3Jmkf2TGd+1exGfPZValPVWk9KAvsp
         En4g13NTWbzJyeC+XysegQp0m/mZb+4JPwgbLbx7bg7CLw90cD19EfY+ySCY6VOxUl
         16LKJDLyrf3K2U0j0SE+B98yZOAdSWIuNChEcdNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liam Beguin <liambeguin@gmail.com>,
        Peter Rosin <peda@axentia.se>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.17 0033/1126] iio: afe: rescale: use s64 for temporary scale calculations
Date:   Tue,  5 Apr 2022 09:13:00 +0200
Message-Id: <20220405070408.526923660@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

commit 51593106b608ae4247cc8da928813347da16d025 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/afe/iio-rescale.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/afe/iio-rescale.c
+++ b/drivers/iio/afe/iio-rescale.c
@@ -39,7 +39,7 @@ static int rescale_read_raw(struct iio_d
 			    int *val, int *val2, long mask)
 {
 	struct rescale *rescale = iio_priv(indio_dev);
-	unsigned long long tmp;
+	s64 tmp;
 	int ret;
 
 	switch (mask) {
@@ -77,10 +77,10 @@ static int rescale_read_raw(struct iio_d
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


