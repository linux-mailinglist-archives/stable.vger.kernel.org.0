Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9981F344190
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhCVMeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:34:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231562AbhCVMdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:33:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4603260C3D;
        Mon, 22 Mar 2021 12:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416400;
        bh=TFKVahvGzm+GotE0wtrWTzAStF8C/uxtKaR3tJVLvec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o2NIcTaaqAxrMozCxzR+AOfEWzYs6j4lmwuIB1MjexXQNI1ipD72zBOoXK8YZg1nI
         1a5q4TouU7SHIwwPMEQEE0NfaAmAIx8LCGh19qWlyRsMuMIGIvZ5ucZkI1W2sDlAhU
         XP2Bk1wB2GgeeGfSwSmQjiyxPoIY46irMU1cxQs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wilfried Wessner <wilfried.wessner@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Charles-Antoine Couret <charles-antoine.couret@essensium.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.11 092/120] iio: adc: ad7949: fix wrong ADC result due to incorrect bit mask
Date:   Mon, 22 Mar 2021 13:27:55 +0100
Message-Id: <20210322121932.756876908@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
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


