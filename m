Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C410F37C325
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbhELPRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:17:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233985AbhELPPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:15:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82E0F6194B;
        Wed, 12 May 2021 15:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831923;
        bh=p7oZqjXWuE1cWkBeLWzNJRLy9g7AUCPEUr1Hre8cKBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdjYJ5/jmkNC23r6O4celMgO/f1eo1DJOIqEHNcVcFYmi01qcCCnIHUMWAgyCJjD7
         9zawpR5IxHQ7kXBYHpv3eMqZ1aaDrvHZg6E2Zi1gDxRUZid9DtwcrqrNwM+1ajdPeX
         S6rou8USCAvGSdd4Ch5R5Ja8cSwPBN+r/x1e7V6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stable@vger.kernel.org, Himanshu Jha <himanshujha199640@gmail.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Alexandru Ardelean <ardeleanalex@gmail.com>
Subject: [PATCH 5.10 035/530] iio:accel:adis16201: Fix wrong axis assignment that prevents loading
Date:   Wed, 12 May 2021 16:42:25 +0200
Message-Id: <20210512144820.896208738@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 4e102429f3dc62dce546f6107e34a4284634196d upstream.

Whilst running some basic tests as part of writing up the dt-bindings for
this driver (to follow), it became clear it doesn't actually load
currently.

iio iio:device1: tried to double register : in_incli_x_index
adis16201 spi0.0: Failed to create buffer sysfs interfaces
adis16201: probe of spi0.0 failed with error -16

Looks like a cut and paste / update bug.  Fixes tag obviously not accurate
but we don't want to bother carry thing back to before the driver moved
out of staging.

Fixes: 591298e54cea ("Staging: iio: accel: adis16201: Move adis16201 driver out of staging")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <Stable@vger.kernel.org>
Cc: Himanshu Jha <himanshujha199640@gmail.com>
Cc: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Link: https://lore.kernel.org/r/20210321182956.844652-1-jic23@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/adis16201.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/adis16201.c
+++ b/drivers/iio/accel/adis16201.c
@@ -215,7 +215,7 @@ static const struct iio_chan_spec adis16
 	ADIS_AUX_ADC_CHAN(ADIS16201_AUX_ADC_REG, ADIS16201_SCAN_AUX_ADC, 0, 12),
 	ADIS_INCLI_CHAN(X, ADIS16201_XINCL_OUT_REG, ADIS16201_SCAN_INCLI_X,
 			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
-	ADIS_INCLI_CHAN(X, ADIS16201_YINCL_OUT_REG, ADIS16201_SCAN_INCLI_Y,
+	ADIS_INCLI_CHAN(Y, ADIS16201_YINCL_OUT_REG, ADIS16201_SCAN_INCLI_Y,
 			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
 	IIO_CHAN_SOFT_TIMESTAMP(7)
 };


