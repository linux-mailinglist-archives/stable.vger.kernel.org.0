Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177F2344334
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhCVMtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232224AbhCVMrN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:47:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64471619BA;
        Mon, 22 Mar 2021 12:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416985;
        bh=TFKVahvGzm+GotE0wtrWTzAStF8C/uxtKaR3tJVLvec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnBs5CZU932Ecd+3lj/TaMgCzMFDelhfFpadA8QUEo/FwLUPgPBa3GGiPHtTwcuvm
         pszuVZWXXiaFoLo3pNsSQhXPYfP1O3UM2+kPZCOiLKrW3q02pfsnRmnz1ftS3P9Shw
         7yUyau5eoDicWKxVRmLJlwGWOeS/ZIH2WXhZMShs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wilfried Wessner <wilfried.wessner@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Charles-Antoine Couret <charles-antoine.couret@essensium.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 43/60] iio: adc: ad7949: fix wrong ADC result due to incorrect bit mask
Date:   Mon, 22 Mar 2021 13:28:31 +0100
Message-Id: <20210322121923.804433865@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wilfried Wessner <wilfried.wessner@gmail.com>

commit f890987fac8153227258121740a9609668c427f3 upstream.

Fixes a wrong bit mask used for the ADC's result, which was caused by an
improper usage of the GENMASK() macro. The bits higher than ADC's
resolution are undefined and if not masked out correctly, a wrong result
can be given. The GENMASK() macro indexing is zero based, so the mask has
to go from [resolution - 1 , 0].

Fixes: 7f40e0614317f ("iio:adc:ad7949: Add AD7949 ADC driver family")
Signed-off-by: Wilfried Wessner <wilfried.wessner@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Charles-Antoine Couret <charles-antoine.couret@essensium.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210208142705.GA51260@ubuntu
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7949.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7949.c
+++ b/drivers/iio/adc/ad7949.c
@@ -91,7 +91,7 @@ static int ad7949_spi_read_channel(struc
 	int ret;
 	int i;
 	int bits_per_word = ad7949_adc->resolution;
-	int mask = GENMASK(ad7949_adc->resolution, 0);
+	int mask = GENMASK(ad7949_adc->resolution - 1, 0);
 	struct spi_message msg;
 	struct spi_transfer tx[] = {
 		{


