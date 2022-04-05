Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75424F3AA9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346871AbiDELpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354638AbiDEKO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4E66A42A;
        Tue,  5 Apr 2022 03:01:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C062EB818F6;
        Tue,  5 Apr 2022 10:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3C2C385A1;
        Tue,  5 Apr 2022 10:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152913;
        bh=fJfAxLgU5ZYT0blaKUPM/lFIty97wmdikPk91H852pY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lR/79T85yWdRp7NDPgbW2+1cHdE4aPPgDtHIvKlcEddR99AerTPhNKyROp+2upLhk
         tSSfi366q5AyO93kk2iTU5ZJDoDCs8ww6Nh/JRxuK+erF6cSAq1xc853+aQoEwHpat
         psmVh8+9OAbxrvLGn+EVluetKvcz9/Orl4Z3fdbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liam Beguin <liambeguin@gmail.com>,
        Peter Rosin <peda@axentia.se>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 033/599] iio: afe: rescale: use s64 for temporary scale calculations
Date:   Tue,  5 Apr 2022 09:25:27 +0200
Message-Id: <20220405070259.808043455@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
@@ -38,7 +38,7 @@ static int rescale_read_raw(struct iio_d
 			    int *val, int *val2, long mask)
 {
 	struct rescale *rescale = iio_priv(indio_dev);
-	unsigned long long tmp;
+	s64 tmp;
 	int ret;
 
 	switch (mask) {
@@ -59,10 +59,10 @@ static int rescale_read_raw(struct iio_d
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


