Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BB9383802
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245172AbhEQPsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:48:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345058AbhEQPqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:46:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3788861D35;
        Mon, 17 May 2021 14:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262663;
        bh=qx/PjOA/ZuU7CCjNcrmVLoFRUgUwwm36wgvT06uqZQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5xrvXQb31rtmv3mGQIecJx7jp+CCQGFaVloMktITOfMwqP8mF6j2wN42mPdNOO/m
         KvjKam5UG5qzFU683i2GX6WcgXx0O1uK2sbkQEWQbsnhg4/ZPnOGAVMy7TgHsnLlcD
         vgiKrZpjGAxXggjGp5zDgAPQjQVX+uQy6xPbD3Yc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Svyatoslav Ryhel <clamor95@gmail.com>,
        Andy Shevchenko <Andy.Shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Maxim Schwalm <maxim.schwalm@gmail.com>
Subject: [PATCH 5.10 252/289] iio: gyro: mpu3050: Fix reported temperature value
Date:   Mon, 17 May 2021 16:02:57 +0200
Message-Id: <20210517140313.631285862@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit f73c730774d88a14d7b60feee6d0e13570f99499 upstream.

The raw temperature value is a 16-bit signed integer. The sign casting
is missing in the code, which results in a wrong temperature reported
by userspace tools, fix it.

Cc: stable@vger.kernel.org
Fixes: 3904b28efb2c ("iio: gyro: Add driver for the MPU-3050 gyroscope")
Datasheet: https://www.cdiweb.com/datasheets/invensense/mpu-3000a.pdf
Tested-by: Maxim Schwalm <maxim.schwalm@gmail.com> # Asus TF700T
Tested-by: Svyatoslav Ryhel <clamor95@gmail.com> # Asus TF201
Reported-by: Svyatoslav Ryhel <clamor95@gmail.com>
Reviewed-by: Andy Shevchenko <Andy.Shevchenko@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
Link: https://lore.kernel.org/r/20210423020959.5023-1-digetx@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/mpu3050-core.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -271,7 +271,16 @@ static int mpu3050_read_raw(struct iio_d
 	case IIO_CHAN_INFO_OFFSET:
 		switch (chan->type) {
 		case IIO_TEMP:
-			/* The temperature scaling is (x+23000)/280 Celsius */
+			/*
+			 * The temperature scaling is (x+23000)/280 Celsius
+			 * for the "best fit straight line" temperature range
+			 * of -30C..85C.  The 23000 includes room temperature
+			 * offset of +35C, 280 is the precision scale and x is
+			 * the 16-bit signed integer reported by hardware.
+			 *
+			 * Temperature value itself represents temperature of
+			 * the sensor die.
+			 */
 			*val = 23000;
 			return IIO_VAL_INT;
 		default:
@@ -328,7 +337,7 @@ static int mpu3050_read_raw(struct iio_d
 				goto out_read_raw_unlock;
 			}
 
-			*val = be16_to_cpu(raw_val);
+			*val = (s16)be16_to_cpu(raw_val);
 			ret = IIO_VAL_INT;
 
 			goto out_read_raw_unlock;


